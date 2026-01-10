#!/usr/bin/env python3
"""
Deep refresh all internal links across all 5 companies.
Processes URLs in sequential batches with delays to avoid rate limiting.
"""

import os
import sys
import time
import json
import re
from datetime import datetime
from pathlib import Path
import urllib.request
import urllib.error
from xml.etree import ElementTree as ET
from typing import List, Dict, Tuple

BASE_DIR = Path(__file__).parent.parent
COMPANIES = {
    'cowseal': 'https://cowseal.com/sitemap_index.xml',
    'metal-castings': 'https://metal-castings.com/sitemap_index.xml',
    'bastone-plastics': 'https://bastone-plastics.com/sitemap_index.xml',
    'mtedmachinery': 'https://mtedmachinery.com/sitemap_index.xml',
    'tanhon': 'https://tanhon.com/sitemap_index.xml',
}

BATCH_SIZE = 20
DELAY_BETWEEN_BATCHES = 2  # seconds
DELAY_BETWEEN_URLS = 0.1  # seconds within batch

def fetch_url(url: str, timeout: int = 10) -> Tuple[bool, str]:
    """Fetch URL and return (success, content)"""
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=timeout) as response:
            return True, response.read().decode('utf-8', errors='ignore')
    except Exception as e:
        print(f"    ERROR fetching {url}: {str(e)}")
        return False, str(e)

def fetch_sitemaps(company: str, sitemap_index_url: str) -> List[str]:
    """Fetch sitemap index and return list of all URLs"""
    urls = []

    print(f"  Fetching sitemap index: {sitemap_index_url}")
    success, content = fetch_url(sitemap_index_url)
    if not success:
        print(f"    Failed to fetch sitemap index")
        return []

    try:
        # Parse sitemap index to get child sitemaps
        root = ET.fromstring(content)
        ns = {'sm': 'http://www.sitemaps.org/schemas/sitemap/0.9'}

        # Get all sitemaps from index
        sitemaps = root.findall('.//sm:sitemap/sm:loc', ns)
        if not sitemaps:
            # Fallback for no namespace
            sitemaps = root.findall('.//sitemap/loc')

        sitemap_urls = [elem.text for elem in sitemaps if elem.text]
        print(f"  Found {len(sitemap_urls)} child sitemaps")

        # Fetch each child sitemap
        for sitemap_url in sitemap_urls:
            print(f"    Fetching {sitemap_url}")
            success, content = fetch_url(sitemap_url)
            if success:
                try:
                    root = ET.fromstring(content)
                    ns = {'sm': 'http://www.sitemaps.org/schemas/sitemap/0.9'}

                    # Get all URLs from this sitemap
                    loc_elements = root.findall('.//sm:url/sm:loc', ns)
                    if not loc_elements:
                        # Fallback
                        loc_elements = root.findall('.//url/loc')

                    for elem in loc_elements:
                        if elem.text:
                            urls.append(elem.text)
                except Exception as e:
                    print(f"      Error parsing sitemap: {e}")
            time.sleep(0.5)  # Delay between sitemap fetches

    except Exception as e:
        print(f"  Error parsing sitemap index: {e}")

    return urls

def extract_title_and_summary(url: str, html: str) -> Tuple[str, str]:
    """Extract page title and generate one-sentence summary from HTML"""
    title = url.split('/')[-2].replace('-', ' ').title() if '/' in url else 'Page'
    summary = "Article content."

    try:
        # Extract title from <title> tag
        title_match = re.search(r'<title[^>]*>([^<]+)</title>', html, re.IGNORECASE)
        if title_match:
            title = title_match.group(1).strip()
            # Remove site name if present
            if '|' in title:
                title = title.split('|')[0].strip()
            if '-' in title and 'cowseal' not in title.lower():
                title = title.rsplit('-', 1)[0].strip()

        # Try to extract meta description
        desc_match = re.search(r'<meta\s+name=["\']description["\']\s+content=["\'](.*?)["\']', html, re.IGNORECASE)
        if desc_match:
            summary = desc_match.group(1).strip()[:150] + "."
            if summary.endswith(".."):
                summary = summary[:-1]
        else:
            # Fallback: extract first paragraph from HTML
            p_match = re.search(r'<p[^>]*>([^<]+)</p>', html, re.IGNORECASE)
            if p_match:
                text = re.sub(r'<[^>]+>', '', p_match.group(1)).strip()
                summary = text[:150] + ("." if not text.endswith('.') else "")

    except Exception as e:
        print(f"      Error extracting content: {e}")

    return title, summary

def deep_refresh_company(company: str, sitemap_index_url: str, output_path: Path):
    """Deep refresh all URLs for a company"""
    print(f"\n{'='*60}")
    print(f"Processing: {company.upper()}")
    print(f"{'='*60}")

    # Fetch all URLs from sitemaps
    print("STEP 1: Fetching URLs from sitemaps...")
    urls = fetch_sitemaps(company, sitemap_index_url)

    if not urls:
        print(f"  ERROR: No URLs found for {company}")
        return 0

    print(f"  Total URLs found: {len(urls)}")

    # Process in batches
    print(f"\nSTEP 2: Deep refreshing URLs (batch size: {BATCH_SIZE})...")
    entries = []
    failed_urls = []

    for batch_num, i in enumerate(range(0, len(urls), BATCH_SIZE)):
        batch = urls[i:i+BATCH_SIZE]
        print(f"\n  Batch {batch_num + 1}/{(len(urls) + BATCH_SIZE - 1) // BATCH_SIZE}: {len(batch)} URLs")

        for idx, url in enumerate(batch):
            print(f"    [{idx+1}/{len(batch)}] {url}")
            success, content = fetch_url(url)

            if success:
                title, summary = extract_title_and_summary(url, content)
                entries.append({
                    'url': url,
                    'title': title,
                    'summary': summary
                })
                print(f"      ✓ {title}")
            else:
                failed_urls.append(url)
                print(f"      ✗ FAILED")

            time.sleep(DELAY_BETWEEN_URLS)

        # Delay between batches
        if i + BATCH_SIZE < len(urls):
            print(f"  Waiting {DELAY_BETWEEN_BATCHES}s before next batch...")
            time.sleep(DELAY_BETWEEN_BATCHES)

    # Sort entries alphabetically by title
    entries.sort(key=lambda x: x['title'].lower())

    # Generate markdown
    print(f"\nSTEP 3: Writing internal-links.md...")
    markdown = f"""# Internal Links Cache

<!-- Last Updated: {datetime.now().strftime('%Y-%m-%d')} -->
<!-- Deep Refresh: {len(entries)} URLs fetched -->

## Articles

"""

    for entry in entries:
        markdown += f"- [{entry['title']}]({entry['url']})\n"
        markdown += f"  > {entry['summary']}\n\n"

    # Write to file
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(markdown)

    print(f"  Written to: {output_path}")
    print(f"  Total entries: {len(entries)}")
    print(f"  Failed URLs: {len(failed_urls)}")

    if failed_urls:
        print(f"  Failed URLs:")
        for url in failed_urls[:10]:  # Show first 10
            print(f"    - {url}")
        if len(failed_urls) > 10:
            print(f"    ... and {len(failed_urls) - 10} more")

    return len(entries)

def main():
    print("DEEP REFRESH ALL INTERNAL LINKS")
    print(f"Start time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    total_urls = 0
    results = {}

    for company, sitemap_url in COMPANIES.items():
        output_path = BASE_DIR / 'data' / 'companies' / company / 'internal-links.md'
        count = deep_refresh_company(company, sitemap_url, output_path)
        results[company] = count
        total_urls += count

    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    for company, count in results.items():
        print(f"  {company:20s}: {count:4d} URLs")
    print(f"  {'TOTAL':20s}: {total_urls:4d} URLs")
    print(f"\nEnd time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

if __name__ == '__main__':
    main()
