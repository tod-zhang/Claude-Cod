#!/bin/bash
# Refresh internal links for a company
# Usage: refresh-internal-links.sh <company-name> <sitemap-index-url>

set -e

COMPANY=$1
SITEMAP_INDEX_URL=$2
OUTPUT_DIR=".claude/data/companies/$COMPANY"
OUTPUT_FILE="$OUTPUT_DIR/internal-links.md"

if [ -z "$COMPANY" ] || [ -z "$SITEMAP_INDEX_URL" ]; then
    echo "Usage: $0 <company-name> <sitemap-index-url>"
    echo "Example: $0 cowseal https://cowseal.com/sitemap_index.xml"
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

SITEMAP_COUNT=$(wc -l < "$TEMP_DIR/sitemaps.txt")
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
sort -u "$TEMP_DIR/all_urls.txt" > "$TEMP_DIR/sorted_urls.txt"
URL_COUNT=$(wc -l < "$TEMP_DIR/sorted_urls.txt")
echo "  Found $URL_COUNT English URLs (after filtering)"

# Step 4: Convert URLs to markdown format with titles
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
    echo "$path" | sed 's|-| |g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Write output file
cat > "$OUTPUT_FILE" << 'HEADER'
# Internal Links Cache

<!-- Last Updated: $(date +%Y-%m-%d) -->

## Articles
HEADER

# Replace date placeholder with actual date
sed -i "s/\$(date +%Y-%m-%d)/$(date +%Y-%m-%d)/" "$OUTPUT_FILE"

# Write all URLs as markdown links
while IFS= read -r url; do
    if [ -n "$url" ]; then
        title=$(url_to_title "$url")
        echo "- [$title]($url)" >> "$OUTPUT_FILE"
    fi
done < "$TEMP_DIR/sorted_urls.txt"

echo "✓ Updated $OUTPUT_FILE with $URL_COUNT links"
