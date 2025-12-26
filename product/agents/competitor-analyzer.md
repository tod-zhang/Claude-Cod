# Agent: Competitor Analyzer

## Purpose
Analyzes competitor product pages to identify content gaps, differentiation opportunities, and best practices to inform our product page strategy.

## Trigger
`/competitor-analyze "[product keyword]"`

## Capabilities

### 1. Search & Discovery
- Search for top-ranking competitors for the target keyword
- Identify the top 5-7 competitor pages to analyze
- Note their domain authority and ranking positions

### 2. Page Structure Analysis
For each competitor page, extract:

```yaml
competitor_analysis:
  url: "[competitor URL]"
  page_structure:
    title_tag: ""
    meta_description: ""
    h1: ""
    h2_headings: []
    h3_headings: []

  content_metrics:
    word_count: 0
    sections_count: 0
    images_count: 0
    videos_count: 0

  trust_elements:
    certifications: []
    reviews_count: 0
    testimonials: []
    company_credentials: []

  technical_content:
    specifications_table: true/false
    materials_listed: []
    tolerances_provided: true/false
    downloadable_resources: []

  cta_elements:
    primary_cta: ""
    secondary_ctas: []
    contact_options: []
```

### 3. Gap Analysis
Compare all competitors to identify:

#### Content Gaps
- Topics no competitor covers well
- Questions left unanswered
- Technical details missing
- Applications not mentioned

#### Quality Gaps
- Poor images that could be improved
- Shallow content areas
- Missing specifications
- Outdated information

#### Trust Gaps
- Certifications not displayed
- No customer testimonials
- Missing expertise signals
- Lack of social proof

#### Technical SEO Gaps
- Poor URL structure
- No internal linking
- Missing alt text

### 4. Opportunity Scoring
Score each gap on:
- **Impact**: How much would filling this gap help rankings? (1-5)
- **Effort**: How difficult to implement? (1-5)
- **Uniqueness**: How hard to replicate? (1-5)

Priority = Impact × Uniqueness / Effort

### 5. Recommendation Generation
Based on analysis, generate:
- Top 5 differentiation opportunities
- Content outline for superior page
- Asset requirements

## Output Format

```markdown
# Competitor Analysis: [Product Keyword]

## Executive Summary
[2-3 sentence overview of competitive landscape]

## Competitor Overview

### Competitor 1: [Name]
- URL: [url]
- Strengths: [list]
- Weaknesses: [list]

[Repeat for each competitor]

## Gap Analysis Matrix

| Gap Type | Description | Impact | Effort | Uniqueness | Priority |
|----------|-------------|--------|--------|------------|----------|
| [type]   | [gap]       | [1-5]  | [1-5]  | [1-5]      | [score]  |

## Top Differentiation Opportunities

### Opportunity 1: [Title]
- **Gap**: What's missing in competitor content
- **Our Approach**: How we'll fill this gap
- **Expected Impact**: Why this matters for rankings
- **Implementation**: How to execute

[Repeat for top 5 opportunities]

## Recommended Page Structure
[Outline of optimal page structure based on analysis]

## Required Assets
- [ ] Asset 1
- [ ] Asset 2

## Competitive Advantage Summary
[Key differentiators that will set our page apart]
```

## Integration with Product Page Creation

After running competitor analysis:
1. Results feed into `/create-product-page` skill
2. Gaps inform content depth decisions
3. Opportunities guide differentiation strategy
4. Findings stored in `/data/analysis/[product]-analysis.md`

## Example

```
User: /competitor-analyze "custom metal coupling"

Agent Output:
# Competitor Analysis: Custom Metal Coupling

## Executive Summary
The custom metal coupling space is moderately competitive with 5 major players.
Key gap: No competitor provides material selection guidance or torque calculators.
Opportunity: Deep technical content + interactive tools can differentiate.

## Competitor Overview

### Competitor 1: The Federal Group USA
- URL: tfgusa.com/products/custom-metal-coupling
- Strengths: Good trust signals, investment casting focus
- Weaknesses: No comparison content, limited applications coverage

### Competitor 2: Stafford Manufacturing
- URL: staffordmfg.com/rigid-shaft-couplings
- Strengths: Product configurator, downloadable CAD
- Weaknesses: Generic content, no custom manufacturing focus

[...]
```
