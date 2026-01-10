#!/bin/bash

# Deep refresh all internal links across all 5 companies
# Uses curl for reliable network access
# Processes URLs in batches with delays to avoid rate limiting

set -e

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
BATCH_SIZE=20
DELAY_BETWEEN_BATCHES=2
DELAY_BETWEEN_URLS=0.1

declare -A COMPANIES
COMPANIES=(
    [cowseal]="https://cowseal.com/sitemap_index.xml"
    [metal-castings]="https://metal-castings.com/sitemap_index.xml"
    [bastone-plastics]="https://bastone-plastics.com/sitemap_index.xml"
    [mtedmachinery]="https://mtedmachinery.com/sitemap_index.xml"
    [tanhon]="https://tanhon.com/sitemap_index.xml"
)

TOTAL_FETCHED=0
TOTAL_FAILED=0

# Extract title from HTML
extract_title() {
    local html="$1"
    local url="$2"

    # Try to get title from <title> tag
    local title=$(echo "$html" | grep -o '<title[^>]*>[^<]*</title>' | sed 's/<[^>]*>//g' | head -1)

    # If no title, extract from URL
    if [ -z "$title" ]; then
        title=$(echo "$url" | sed 's|.*/||' | sed 's|/$||' | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
    else
        # Remove site name if present
        if echo "$title" | grep -q '|'; then
            title=$(echo "$title" | cut -d'|' -f1 | xargs)
        fi
        # Remove trailing site name after dash (but not for cowseal)
        if echo "$title" | grep -q '-' && ! echo "$title" | grep -iq 'cowseal'; then
            title=$(echo "$title" | sed 's/ - [^-]*$//')
        fi
    fi

    echo "$title"
}

# Extract summary from HTML
extract_summary() {
    local html="$1"

    # Try meta description
    local summary=$(echo "$html" | grep -o '<meta[^>]*name=['\''"]description['\''"][^>]*content=['\''"][^'\''\"]*['\''"]' | head -1 | sed 's/.*content=["'\'']//;s/["'\''].*//')

    # If no summary, try first paragraph
    if [ -z "$summary" ]; then
        summary=$(echo "$html" | grep -o '<p[^>]*>[^<]*</p>' | head -1 | sed 's/<[^>]*>//g')
    fi

    # Truncate to 150 chars and add period
    if [ -n "$summary" ]; then
        summary=$(echo "$summary" | cut -c1-150 | xargs)
        if ! echo "$summary" | grep -q '\.$'; then
            summary="$summary."
        fi
    else
        summary="Article content."
    fi

    echo "$summary"
}

# Fetch and extract URLs from sitemap
fetch_sitemaps() {
    local company="$1"
    local sitemap_index_url="$2"
    local temp_file="/tmp/${company}_urls.txt"

    echo "  Fetching sitemap index: $sitemap_index_url"

    local index_content=$(curl -s --max-time 10 "$sitemap_index_url" 2>/dev/null || true)

    if [ -z "$index_content" ]; then
        echo "    Failed to fetch sitemap index"
        return
    fi

    # Extract child sitemap URLs
    local sitemap_urls=$(echo "$index_content" | grep -o '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g')
    local sitemap_count=$(echo "$sitemap_urls" | wc -l)

    echo "  Found $sitemap_count child sitemaps"

    > "$temp_file"  # Clear file

    # Fetch each child sitemap
    while IFS= read -r sitemap_url; do
        [ -z "$sitemap_url" ] && continue
        echo "    Fetching $sitemap_url"

        local sm_content=$(curl -s --max-time 10 "$sitemap_url" 2>/dev/null || true)
        if [ -n "$sm_content" ]; then
            echo "$sm_content" | grep -o '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' >> "$temp_file"
        fi
        sleep 0.5
    done <<< "$sitemap_urls"

    cat "$temp_file"
}

# Deep refresh company
deep_refresh_company() {
    local company="$1"
    local sitemap_index_url="$2"
    local output_path="$3"

    echo ""
    echo "============================================================"
    echo "Processing: ${company^^}"
    echo "============================================================"

    # Fetch all URLs
    echo "STEP 1: Fetching URLs from sitemaps..."
    local urls_file="/tmp/${company}_all_urls.txt"
    fetch_sitemaps "$company" "$sitemap_index_url" > "$urls_file"

    local url_count=$(wc -l < "$urls_file")
    if [ "$url_count" -eq 0 ]; then
        echo "  ERROR: No URLs found"
        return 0
    fi

    echo "  Total URLs found: $url_count"

    # Process in batches
    echo ""
    echo "STEP 2: Deep refreshing URLs (batch size: $BATCH_SIZE)..."

    local entries_file="/tmp/${company}_entries.txt"
    > "$entries_file"

    local failed_file="/tmp/${company}_failed.txt"
    > "$failed_file"

    local batch_num=0
    local total_batches=$(( (url_count + BATCH_SIZE - 1) / BATCH_SIZE ))
    local idx=0

    while IFS= read -r url; do
        [ -z "$url" ] && continue

        # Calculate batch number
        local current_batch=$(( idx / BATCH_SIZE + 1 ))
        local idx_in_batch=$(( idx % BATCH_SIZE + 1 ))

        # Print batch header
        if [ $((idx % BATCH_SIZE)) -eq 0 ]; then
            if [ $idx -gt 0 ]; then
                echo "  Waiting ${DELAY_BETWEEN_BATCHES}s before next batch..."
                sleep "$DELAY_BETWEEN_BATCHES"
            fi
            echo ""
            echo "  Batch $current_batch/$total_batches:"
        fi

        # Fetch URL
        printf "    [%02d/%02d] %-60s " "$idx_in_batch" "$BATCH_SIZE" "${url:0:60}..."

        local html=$(curl -s --max-time 10 "$url" 2>/dev/null || true)

        if [ -n "$html" ]; then
            local title=$(extract_title "$html" "$url")
            local summary=$(extract_summary "$html")
            echo "[TITLE]|$title|[URL]|$url|[SUMMARY]|$summary" >> "$entries_file"
            echo "✓"
            ((TOTAL_FETCHED++))
        else
            echo "✗"
            echo "$url" >> "$failed_file"
            ((TOTAL_FAILED++))
        fi

        sleep "$DELAY_BETWEEN_URLS"
        ((idx++))
    done < "$urls_file"

    # Sort entries and generate markdown
    echo ""
    echo "STEP 3: Writing internal-links.md..."

    local today=$(date +%Y-%m-%d)
    local entries_count=$(grep -c . "$entries_file" || true)

    local markdown_file="/tmp/${company}_markdown.txt"
    cat > "$markdown_file" << EOF
# Internal Links Cache

<!-- Last Updated: $today -->
<!-- Deep Refresh: $entries_count URLs fetched -->

## Articles

EOF

    # Sort and format entries
    if [ -s "$entries_file" ]; then
        sort "$entries_file" -t'|' -k3 | while IFS='|' read -r _ title _ url _ summary _; do
            echo "- [$title]($url)" >> "$markdown_file"
            echo "  > $summary" >> "$markdown_file"
            echo "" >> "$markdown_file"
        done
    fi

    # Write to output
    mkdir -p "$(dirname "$output_path")"
    cp "$markdown_file" "$output_path"

    echo "  Written to: $output_path"
    echo "  Total entries: $entries_count"

    local failed_count=$(grep -c . "$failed_file" || true)
    echo "  Failed URLs: $failed_count"

    if [ "$failed_count" -gt 0 ]; then
        echo "  Failed URLs:"
        head -10 "$failed_file" | while IFS= read -r url; do
            echo "    - $url"
        done
        if [ "$failed_count" -gt 10 ]; then
            echo "    ... and $((failed_count - 10)) more"
        fi
    fi

    # Cleanup
    rm -f "$urls_file" "$entries_file" "$failed_file" "$markdown_file"

    return "$entries_count"
}

# Main
main() {
    echo "DEEP REFRESH ALL INTERNAL LINKS"
    echo "Start time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

    local total_urls=0

    for company in "${!COMPANIES[@]}"; do
        local sitemap_url="${COMPANIES[$company]}"
        local output_path="$BASE_DIR/data/companies/$company/internal-links.md"

        deep_refresh_company "$company" "$sitemap_url" "$output_path"
        local count=$?
        total_urls=$((total_urls + count))
    done

    echo ""
    echo "============================================================"
    echo "SUMMARY"
    echo "============================================================"
    echo "  Total URLs processed: $total_urls"
    echo "  Total fetched: $TOTAL_FETCHED"
    echo "  Total failed: $TOTAL_FAILED"
    echo ""
    echo "End time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

main "$@"
