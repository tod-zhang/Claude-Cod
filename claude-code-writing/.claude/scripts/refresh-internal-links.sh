#!/bin/bash
# Refresh internal links for a company (with incremental deep refresh support)
# Usage: refresh-internal-links.sh <company-name> <sitemap-index-url> [--diff-only]
#
# Modes:
#   Default: Full refresh (URL extraction + slug-based titles)
#   --diff-only: Only calculate differences, output to temp files for deep refresh

set -e

COMPANY=$1
SITEMAP_INDEX_URL=$2
MODE=${3:-"full"}
OUTPUT_DIR=".claude/data/companies/$COMPANY"
OUTPUT_FILE="$OUTPUT_DIR/internal-links.md"
DIFF_DIR="$OUTPUT_DIR/.internal-links-diff"

if [ -z "$COMPANY" ] || [ -z "$SITEMAP_INDEX_URL" ]; then
    echo "Usage: $0 <company-name> <sitemap-index-url> [--diff-only]"
    echo "Example: $0 cowseal https://cowseal.com/sitemap_index.xml"
    echo "         $0 cowseal https://cowseal.com/sitemap_index.xml --diff-only"
    exit 1
fi

echo "Refreshing internal links for $COMPANY..."

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Step 1: Fetch sitemap index and extract sitemap URLs
echo "  Fetching sitemap index..."
curl -s "$SITEMAP_INDEX_URL" | \
    grep -o '<loc>[^<]*</loc>' | \
    sed 's/<loc>//g; s/<\/loc>//g' > "$TEMP_DIR/sitemaps.txt"

SITEMAP_COUNT=$(wc -l < "$TEMP_DIR/sitemaps.txt" | tr -d ' ')
echo "  Found $SITEMAP_COUNT sitemaps"

# Step 2: Fetch all sitemaps and extract URLs
echo "  Fetching URLs from sitemaps..."
while IFS= read -r sitemap_url; do
    echo "    - $(basename "$sitemap_url")"
    curl -s "$sitemap_url" | \
        grep -o '<loc>[^<]*</loc>' | \
        sed 's/<loc>//g; s/<\/loc>//g' | \
        grep -v -E '/(fr|it|de|es|pt|nl|pl|ja|ko|zh)/' >> "$TEMP_DIR/all_urls.txt" || true
done < "$TEMP_DIR/sitemaps.txt"

# Step 3: Sort and deduplicate URLs
sort -u "$TEMP_DIR/all_urls.txt" > "$TEMP_DIR/current_urls.txt"
URL_COUNT=$(wc -l < "$TEMP_DIR/current_urls.txt" | tr -d ' ')
echo "  Found $URL_COUNT English URLs (after filtering)"

# Step 4: Calculate differences if existing cache exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "  Calculating differences with existing cache..."

    # Extract URLs from existing internal-links.md
    grep -o 'https://[^)]*' "$OUTPUT_FILE" | sort -u > "$TEMP_DIR/cached_urls.txt"
    CACHED_COUNT=$(wc -l < "$TEMP_DIR/cached_urls.txt" | tr -d ' ')
    echo "  Existing cache has $CACHED_COUNT URLs"

    # Calculate differences
    # New URLs: in current but not in cached
    comm -23 "$TEMP_DIR/current_urls.txt" "$TEMP_DIR/cached_urls.txt" > "$TEMP_DIR/new_urls.txt"
    # Deleted URLs: in cached but not in current
    comm -13 "$TEMP_DIR/current_urls.txt" "$TEMP_DIR/cached_urls.txt" > "$TEMP_DIR/deleted_urls.txt"
    # Unchanged URLs: in both
    comm -12 "$TEMP_DIR/current_urls.txt" "$TEMP_DIR/cached_urls.txt" > "$TEMP_DIR/unchanged_urls.txt"

    NEW_COUNT=$(wc -l < "$TEMP_DIR/new_urls.txt" | tr -d ' ')
    DELETED_COUNT=$(wc -l < "$TEMP_DIR/deleted_urls.txt" | tr -d ' ')
    UNCHANGED_COUNT=$(wc -l < "$TEMP_DIR/unchanged_urls.txt" | tr -d ' ')

    echo "  Differences: +$NEW_COUNT new, -$DELETED_COUNT deleted, =$UNCHANGED_COUNT unchanged"
else
    echo "  No existing cache, all URLs are new"
    cp "$TEMP_DIR/current_urls.txt" "$TEMP_DIR/new_urls.txt"
    touch "$TEMP_DIR/deleted_urls.txt"
    touch "$TEMP_DIR/unchanged_urls.txt"
    NEW_COUNT=$URL_COUNT
    DELETED_COUNT=0
    UNCHANGED_COUNT=0
fi

# If --diff-only mode, output diff files and exit
if [ "$MODE" = "--diff-only" ]; then
    mkdir -p "$DIFF_DIR"
    cp "$TEMP_DIR/new_urls.txt" "$DIFF_DIR/new_urls.txt"
    cp "$TEMP_DIR/deleted_urls.txt" "$DIFF_DIR/deleted_urls.txt"
    cp "$TEMP_DIR/unchanged_urls.txt" "$DIFF_DIR/unchanged_urls.txt"

    echo ""
    echo "Diff files written to $DIFF_DIR/"
    echo "  - new_urls.txt ($NEW_COUNT)"
    echo "  - deleted_urls.txt ($DELETED_COUNT)"
    echo "  - unchanged_urls.txt ($UNCHANGED_COUNT)"
    echo ""
    echo "Next: Use deep refresh to fetch titles/summaries for new URLs"
    exit 0
fi

# Step 5: Full refresh mode - convert URLs to markdown format with titles
echo "  Formatting as markdown..."

# Function to convert URL to title
url_to_title() {
    local url="$1"
    local path=$(echo "$url" | sed "s|https://[^/]*/||; s|/$||")

    if [ -z "$path" ]; then
        echo "Home"
        return
    fi

    # Convert dashes to spaces and capitalize first letter of each word
    echo "$path" | sed 's|-| |g; s|/| |g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Write output file
cat > "$OUTPUT_FILE" << 'HEADER'
# Internal Links Cache

<!-- Last Updated: DATE_PLACEHOLDER -->

## Articles
HEADER

# Replace date placeholder with actual date
sed -i '' "s/DATE_PLACEHOLDER/$(date +%Y-%m-%d)/" "$OUTPUT_FILE" 2>/dev/null || \
sed -i "s/DATE_PLACEHOLDER/$(date +%Y-%m-%d)/" "$OUTPUT_FILE"

# Write all URLs as markdown links
while IFS= read -r url; do
    if [ -n "$url" ]; then
        title=$(url_to_title "$url")
        echo "- [$title]($url)" >> "$OUTPUT_FILE"
    fi
done < "$TEMP_DIR/current_urls.txt"

echo "✓ Updated $OUTPUT_FILE with $URL_COUNT links"
