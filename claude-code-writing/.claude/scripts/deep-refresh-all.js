#!/usr/bin/env node

const https = require('https');
const http = require('http');
const { URL } = require('url');
const fs = require('fs');
const path = require('path');

const BASE_DIR = path.join(__dirname, '..');
const COMPANIES = {
  'cowseal': 'https://cowseal.com/sitemap_index.xml',
  'metal-castings': 'https://metal-castings.com/sitemap_index.xml',
  'bastone-plastics': 'https://bastone-plastics.com/sitemap_index.xml',
  'mtedmachinery': 'https://mtedmachinery.com/sitemap_index.xml',
  'tanhon': 'https://tanhon.com/sitemap_index.xml',
};

const BATCH_SIZE = 20;
const DELAY_BETWEEN_BATCHES = 2000; // ms
const DELAY_BETWEEN_URLS = 100; // ms

let totalFetched = 0;
let totalFailed = 0;

function fetchUrl(url, timeout = 10000) {
  return new Promise((resolve) => {
    const urlObj = new URL(url);
    const protocol = urlObj.protocol === 'https:' ? https : http;

    const options = {
      hostname: urlObj.hostname,
      path: urlObj.pathname + urlObj.search,
      method: 'GET',
      timeout,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    };

    const req = protocol.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        resolve({ success: true, content: data });
      });
    });

    req.on('error', (error) => {
      resolve({ success: false, error: error.message });
    });

    req.on('timeout', () => {
      req.destroy();
      resolve({ success: false, error: 'Timeout' });
    });
  });
}

async function extractUrlsFromSitemap(content) {
  const urls = [];
  const regex = /<loc>([^<]+)<\/loc>/g;
  let match;

  while ((match = regex.exec(content)) !== null) {
    urls.push(match[1]);
  }

  return urls;
}

async function fetchSitemaps(company, sitemapIndexUrl) {
  const urls = [];

  console.log(`  Fetching sitemap index: ${sitemapIndexUrl}`);
  const { success, content, error } = await fetchUrl(sitemapIndexUrl);

  if (!success) {
    console.log(`    Failed: ${error}`);
    return [];
  }

  try {
    // Extract child sitemap URLs from index
    const sitemapUrls = await extractUrlsFromSitemap(content);
    console.log(`  Found ${sitemapUrls.length} child sitemaps`);

    // Fetch each child sitemap
    for (const sitemapUrl of sitemapUrls) {
      console.log(`    Fetching ${sitemapUrl}`);
      const { success: smSuccess, content: smContent } = await fetchUrl(sitemapUrl);

      if (smSuccess) {
        try {
          const smUrls = await extractUrlsFromSitemap(smContent);
          urls.push(...smUrls);
        } catch (e) {
          console.log(`      Error parsing: ${e.message}`);
        }
      }
      await new Promise(resolve => setTimeout(resolve, 500));
    }
  } catch (error) {
    console.log(`  Error processing sitemaps: ${error.message}`);
  }

  return urls;
}

function extractTitleAndSummary(url, html) {
  let title = url.split('/').filter(x => x).pop() || 'Page';
  title = title.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase());

  let summary = 'Article content.';

  try {
    // Extract title from <title> tag
    const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i);
    if (titleMatch) {
      title = titleMatch[1].trim();
      // Remove site name if present
      if (title.includes('|')) {
        title = title.split('|')[0].trim();
      }
      if (title.includes('-') && !title.toLowerCase().includes('cowseal')) {
        const parts = title.split('-');
        title = parts.slice(0, -1).join('-').trim();
      }
    }

    // Try meta description
    const descMatch = html.match(/<meta\s+name=['"]description['"]\s+content=['"]([^'"]*)['"]/i);
    if (descMatch) {
      summary = descMatch[1].trim();
      if (summary.length > 150) {
        summary = summary.substring(0, 150) + '.';
      }
      if (!summary.endsWith('.')) {
        summary += '.';
      }
    } else {
      // Extract first paragraph
      const pMatch = html.match(/<p[^>]*>([^<]+)<\/p>/i);
      if (pMatch) {
        let text = pMatch[1].replace(/<[^>]+>/g, '').trim();
        if (text.length > 150) {
          text = text.substring(0, 150);
        }
        summary = text + (text.endsWith('.') ? '' : '.');
      }
    }
  } catch (e) {
    console.log(`      Error extracting: ${e.message}`);
  }

  return { title, summary };
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function deepRefreshCompany(company, sitemapIndexUrl, outputPath) {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`Processing: ${company.toUpperCase()}`);
  console.log(`${'='.repeat(60)}`);

  // Fetch all URLs
  console.log('STEP 1: Fetching URLs from sitemaps...');
  const urls = await fetchSitemaps(company, sitemapIndexUrl);

  if (urls.length === 0) {
    console.log(`  ERROR: No URLs found`);
    return 0;
  }

  console.log(`  Total URLs found: ${urls.length}`);

  // Process in batches
  console.log(`\nSTEP 2: Deep refreshing URLs (batch size: ${BATCH_SIZE})...`);
  const entries = [];
  const failedUrls = [];

  for (let batchNum = 0; batchNum < urls.length; batchNum += BATCH_SIZE) {
    const batch = urls.slice(batchNum, batchNum + BATCH_SIZE);
    const batchTotal = Math.ceil(urls.length / BATCH_SIZE);
    const currentBatch = Math.floor(batchNum / BATCH_SIZE) + 1;

    console.log(`\n  Batch ${currentBatch}/${batchTotal}: ${batch.length} URLs`);

    for (let idx = 0; idx < batch.length; idx++) {
      const url = batch[idx];
      const urlDisplay = url.length > 60 ? url.substring(0, 60) + '...' : url;
      process.stdout.write(`    [${(idx + 1).toString().padStart(2)}/${batch.length.toString().padStart(2)}] ${urlDisplay} `);

      const { success, content } = await fetchUrl(url);

      if (success) {
        const { title, summary } = extractTitleAndSummary(url, content);
        entries.push({ url, title, summary });
        console.log(`✓`);
        totalFetched++;
      } else {
        console.log(`✗`);
        failedUrls.push(url);
        totalFailed++;
      }

      await sleep(DELAY_BETWEEN_URLS);
    }

    // Delay between batches
    if (batchNum + BATCH_SIZE < urls.length) {
      console.log(`  Waiting ${DELAY_BETWEEN_BATCHES}ms before next batch...`);
      await sleep(DELAY_BETWEEN_BATCHES);
    }
  }

  // Sort entries alphabetically by title
  entries.sort((a, b) => a.title.toLowerCase().localeCompare(b.title.toLowerCase()));

  // Generate markdown
  console.log(`\nSTEP 3: Writing internal-links.md...`);
  const now = new Date().toISOString().split('T')[0];
  let markdown = `# Internal Links Cache\n\n`;
  markdown += `<!-- Last Updated: ${now} -->\n`;
  markdown += `<!-- Deep Refresh: ${entries.length} URLs fetched -->\n\n`;
  markdown += `## Articles\n\n`;

  for (const entry of entries) {
    markdown += `- [${entry.title}](${entry.url})\n`;
    markdown += `  > ${entry.summary}\n\n`;
  }

  // Write to file
  const outputDir = path.dirname(outputPath);
  fs.mkdirSync(outputDir, { recursive: true });
  fs.writeFileSync(outputPath, markdown, 'utf-8');

  console.log(`  Written to: ${outputPath}`);
  console.log(`  Total entries: ${entries.length}`);
  console.log(`  Failed URLs: ${failedUrls.length}`);

  if (failedUrls.length > 0) {
    console.log(`  Failed URLs:`);
    for (let i = 0; i < Math.min(failedUrls.length, 10); i++) {
      console.log(`    - ${failedUrls[i]}`);
    }
    if (failedUrls.length > 10) {
      console.log(`    ... and ${failedUrls.length - 10} more`);
    }
  }

  return entries.length;
}

async function main() {
  console.log('DEEP REFRESH ALL INTERNAL LINKS');
  console.log(`Start time: ${new Date().toISOString()}`);

  let totalUrls = 0;
  const results = {};

  for (const [company, sitemapUrl] of Object.entries(COMPANIES)) {
    const outputPath = path.join(BASE_DIR, 'data', 'companies', company, 'internal-links.md');
    const count = await deepRefreshCompany(company, sitemapUrl, outputPath);
    results[company] = count;
    totalUrls += count;
  }

  console.log(`\n${'='.repeat(60)}`);
  console.log('SUMMARY');
  console.log(`${'='.repeat(60)}`);
  for (const [company, count] of Object.entries(results)) {
    console.log(`  ${company.padEnd(20)}: ${count.toString().padStart(4)} URLs`);
  }
  console.log(`  ${'TOTAL'.padEnd(20)}: ${totalUrls.toString().padStart(4)} URLs`);
  console.log(`  Total fetched: ${totalFetched}, Total failed: ${totalFailed}`);
  console.log(`\nEnd time: ${new Date().toISOString()}`);
}

main().catch(console.error);
