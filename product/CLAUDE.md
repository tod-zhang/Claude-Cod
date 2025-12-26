# Metal-Castings.com Product Page SEO Workflow

## Overview

This document defines a reusable workflow for creating SEO-optimized product pages that rank well on Google while providing genuine value to users. The workflow is designed for metal-castings.com but can be adapted for any B2B industrial manufacturing website.

## Language Protocol

- **Tool/Model interactions**: English
- **User interactions**: 中文

---

## Multi-Company Workflow（多公司工作流程）

> **此工作流程支持多个不同行业的公司网站**

### 工作原理

```
CLAUDE.md (通用工作流程)
    ↓
/companies/{domain}.md (公司特定上下文)
    ↓
产品页根据公司行业配置生成
```

### 切换公司

创建产品页时，先确认是为哪个公司：

1. **确认公司** — "这是为哪个网站创建的？"
2. **读取公司文件** — 获取行业配置、规格模板、案例问题
3. **按配置生成** — 产品页内容根据行业调整

### 已配置的公司

| 公司 | 文件 | 行业 |
|------|------|------|
| metal-castings.com | `/companies/metal-castings-com.md` | 铸造 |
| *(新公司)* | `/companies/{domain}.md` | *(待配置)* |

### 添加新公司

1. 复制 `/companies/_template.md`
2. 重命名为 `{domain}.md`
3. 填写公司信息和**行业配置（Section 3）**
4. 行业配置决定：
   - 产品页应包含哪些规格
   - 案例收集应问哪些问题
   - 竞争对手搜索用什么关键词

---

## Core Principles

1. **Differentiation over Imitation** - Don't copy competitors; create unique value
2. **Depth over Breadth** - Go deeper on fewer topics rather than shallow coverage
3. **E-E-A-T Focus** - Experience, Expertise, Authoritativeness, Trustworthiness
4. **User Intent First** - Serve the buyer's decision-making journey

---

## Phase 0: Company Analysis (Foundation)

> **Before creating any product pages, complete the company analysis first.**

### Purpose

Company analysis establishes the foundation for all content. It defines:
- Who the company is and what makes them unique
- Who the target customers are and what they need
- How to position content for maximum impact

### Process

1. **Create company file**: Copy `/companies/_template.md` to `/companies/{domain}.md`
2. **Research the company**: Website, about page, capabilities, certifications
3. **Define positioning**: What is their unique value proposition?
4. **Analyze target customers**:
   - Segment customers by type (OEM, aftermarket, engineers, end users)
   - Document pain points for each segment
   - Identify buying criteria (ranked)
   - Map the customer journey
5. **Content strategy implications**: What content will resonate with these customers?

### Key Outputs

| Output | Description | Location |
|--------|-------------|----------|
| Company Profile | Basic info, capabilities, certifications | Section 1-2 |
| Positioning Statement | One-sentence market position | Section 3.1 |
| Customer Segments | 3-4 detailed buyer personas | Section 4.1 |
| Ideal Customer Profile | Primary target description | Section 4.2 |
| Content Pillars | 3-4 themes for all content | Section 5.2 |
| Trust Signals | Priority list of credibility elements | Section 5.3 |

### Template Location

```
/companies/
├── _template.md              # Master template for new companies
└── metal-castings-com.md     # Example: KT Metal Castings analysis
```

---

## Phase 1: Competitive Intelligence

### Step 1.1: Identify Top Competitors

```
Search queries to run:
- "[product name] manufacturer"
- "[product name] supplier USA"
- "custom [product name] services"
- "[product name] casting" / "[product name] machining"
```

### Step 1.2: Analyze Competitor Pages

For each top 5 competitor, document:

| Element | What to Capture |
|---------|-----------------|
| **Page Structure** | H1, H2, H3 hierarchy |
| **Content Depth** | Word count, technical detail level |
| **Trust Signals** | Certifications, reviews, testimonials |
| **Visual Assets** | Product images, videos, diagrams |
| **CTAs** | Types and placement |
| **Technical Specs** | How specs are presented |
| **Internal Links** | Link patterns and anchor text |

### Step 1.3: Gap Analysis Matrix

Create a gap analysis using this template:

```markdown
## Competitor Gap Analysis: [Product Name]

### Content Gaps (What competitors DON'T have)
- [ ] Gap 1: ___
- [ ] Gap 2: ___

### Quality Gaps (Where we can do better)
- [ ] Gap 1: ___
- [ ] Gap 2: ___

### Trust Gaps (E-E-A-T opportunities)
- [ ] Gap 1: ___
- [ ] Gap 2: ___
```

### Step 1.4: Save Competitor Analysis

**Output all competitor research to a file:**

```
/competitors/{product-name}.md
```

Use the template at `/competitors/_template.md`. This creates:
- Reusable research for future content updates
- Documentation of differentiation strategy
- Keyword insights for SEO optimization

---

## Phase 2: Differentiation Strategy

### 2.1 Sunk-Cost Differentiators

These require investment but create sustainable competitive advantages:

| Differentiator Type | Examples | Difficulty |
|---------------------|----------|------------|
| **Interactive Tools** | Material selector, cost calculator, tolerance calculator | High |
| **Original Research** | Industry surveys, performance testing data | High |
| **Video Content** | Manufacturing process, quality inspection, installation guides | Medium |
| **Technical Guides** | Design guides, specification sheets, comparison charts | Medium |
| **Case Studies** | Real projects with metrics and outcomes | Medium |

### 2.2 Content Differentiators

| Strategy | Implementation |
|----------|----------------|
| **Engineer-Level Depth** | Include formulas, calculations, tolerances that competitors skip |
| **Application-Specific Content** | Create content for each industry application |
| **Problem-Solution Format** | Address specific engineering challenges |
| **Comparison Content** | Material vs material, process vs process |
| **FAQ Expansion** | Answer questions competitors ignore |

### 2.3 Trust Differentiators

| Signal Type | Examples |
|-------------|----------|
| **Certifications** | ISO 9001, AS9100, IATF 16949, NADCAP |
| **Social Proof** | Google reviews, industry awards, client logos |
| **Expertise Signals** | Team credentials, years of experience, patents |
| **Transparency** | Pricing guidance, lead times, process documentation |
| **Third-Party Validation** | Lab test results, material certifications |

---

## Phase 3: Page Structure Template

> **设计原则：** 模块化、可扫描、转化导向。用表格和视觉元素代替大段文字。

### 3.1 产品页架构（转化导向）

```
[Hero Section] ─────────────────────────────────
├── H1: 产品关键词 + 差异化
├── 一句话价值主张（20字以内）
├── 3个核心卖点（图标+短语）
├── Primary CTA: [获取报价]
└── 产品主图

[Specifications Section] ────────────────────────
├── H2: 规格参数
├── 核心规格表（5-8行）
├── 材料选项表（带对比）
└── [下载规格书] 按钮

[Applications Section] ──────────────────────────
├── H2: 应用行业
├── 6个行业图标网格（图标+名称+一句话）
└── 不需要大段描述

[Why Choose Us Section] ─────────────────────────
├── H2: 为什么选择我们
├── 4个差异化卡片（图标+标题+一句话）
├── 认证logo条
└── 客户logo条（可选）

[CTA Section] ───────────────────────────────────
├── 询价表单 或 联系方式
└── 辅助信息（交期、最小起订量等）

[FAQ Section]（可选，折叠式）──────────────────
└── 3-5个常见问题（点击展开）
```

### 3.2 不要在产品页重复的内容

| 内容类型 | 放在哪里 | 产品页处理 |
|----------|----------|------------|
| 制造流程 | /manufacturing/ 单独页面 | 链接过去 |
| 公司介绍 | /about/ 页面 | 不需要 |
| 详细技术指南 | /resources/ 资源页 | 链接或折叠 |
| 材料深度对比 | /resources/material-guide/ | 链接 |

### 3.3 内容量指南

| 页面类型 | 字数范围 | 说明 |
|----------|----------|------|
| 产品页 | 400-800 | 精简、模块化、转化导向 |
| 资源/指南页 | 1,500-2,500 | 深度内容、SEO导向 |
| 行业应用页 | 800-1,200 | 针对特定行业的详细内容 |

---

## Phase 4: On-Page SEO Checklist

### 4.1 Technical SEO

- [ ] **Title Tag**: Primary keyword + brand (55-60 chars)
- [ ] **Meta Description**: Compelling summary with CTA (150-160 chars)
- [ ] **URL Structure**: `/products/[product-name]/` (simple, keyword-rich)
- [ ] **H1**: One per page, includes primary keyword
- [ ] **H2-H6**: Logical hierarchy, include secondary keywords
- [ ] **Image Alt Text**: Descriptive, includes keywords naturally
- [ ] **Internal Links**: 5-10 relevant internal links
- [ ] **External Links**: 1-2 authoritative sources (optional)

### 4.2 Content Quality Checklist

- [ ] Original content (not copied from competitors)
- [ ] Technical accuracy verified
- [ ] Clear value proposition
- [ ] Addresses user pain points
- [ ] Includes unique data/insights
- [ ] Professional images (not stock)
- [ ] Proper grammar and formatting
- [ ] Mobile-friendly layout

---

## Phase 5: Case Study Collection

> **产品页的差异化来自真实案例，而不是空洞的声称。**

### 5.1 为什么需要案例

| 方式 | 可信度 |
|------|--------|
| "我们经验丰富" | 低 — 任何人都可以说 |
| "已交付500+规格" | 中 — 无法验证 |
| 真实项目 + 照片 | 高 — 具体可信 |

### 5.2 案例信息收集清单

创建产品页时，向客户询问以下信息：

**基本信息：**
| 问题 | 示例 |
|------|------|
| 产品名称 | 飞轮、配重、壳体 |
| 客户行业 | 农业机械、工程机械、发电设备 |
| 客户国家/地区 | 美国、欧洲、澳大利亚 |
| 可否透露客户名称？ | 是/否（匿名也可） |

**产品规格：**
| 问题 | 示例 |
|------|------|
| 材料 | 灰铁 HT250、球铁 QT450-10 |
| 重量 | 500 lbs / 230 kg |
| 尺寸 | 直径 36"，厚度 4" |
| 年订单量 | 200件/年 |

**项目故事（关键）：**
| 问题 | 示例 |
|------|------|
| 客户之前遇到什么问题？ | 之前供应商交期太长 / 质量不稳定 / 价格太高 |
| 这个项目有什么挑战？ | 公差要求紧 / 尺寸大 / 特殊材料 |
| 我们怎么解决的？ | 优化模具设计 / 调整浇注工艺 / 提供DFM建议 |
| 最终结果如何？ | 交期缩短30% / 成本降低25% / 连续合作3年 |

**照片素材：**
| 需要的照片 | 说明 |
|------------|------|
| 产品照片 | 成品照片，最好有尺寸参照物 |
| 生产过程照片 | 浇注、机加工等（可选） |
| 包装/发货照片 | 展示交付能力（可选） |

### 5.3 案例输出格式

**产品页简短版（3-5句）：**
```
## Project Example

**Application:** Diesel generator flywheel
**Customer:** Leading US power equipment manufacturer
**Specs:** Ductile iron, 36" dia, 850 lbs, G6.3 balance
**Result:** 200 pcs/year, 3-year ongoing partnership

[产品照片]
```

**单独案例研究页（如素材丰富）：**
保存到 `/cases/{product}-{customer}.md`

### 5.4 没有案例时的处理

如果暂时无法获取案例信息：
1. 产品页不放案例模块
2. 只保留规格和CTA
3. 后续获取素材后再补充

---

## Phase 6: Content Creation Workflow

### 6.1 Research Phase

1. **Keyword Research**
   - Primary keyword: Main product term
   - Secondary keywords: Variations, materials, applications
   - Long-tail keywords: Specific use cases, questions

2. **User Intent Analysis**
   - Informational: "What is [product]?"
   - Commercial: "[product] manufacturer"
   - Transactional: "[product] quote"

3. **Competitor Content Audit**
   - What do they cover well?
   - What do they miss?
   - What can we do better?

### 6.2 Writing Phase

1. **Outline Creation** (based on Phase 3 template)
2. **Draft Writing** (focus on unique value)
3. **Technical Review** (engineering accuracy)
4. **SEO Optimization** (keywords, structure)
5. **Final Edit** (readability, flow)

### 6.3 Asset Creation

| Asset Type | Purpose | Priority |
|------------|---------|----------|
| Product Photos | Show actual products | High |
| Process Images | Demonstrate capability | High |
| Technical Diagrams | Explain specifications | Medium |
| Comparison Charts | Aid decision-making | Medium |
| Video Content | Build trust, explain complex topics | Medium |
| Downloadable PDFs | Capture leads, provide value | Low |

---

## Quick Reference: Differentiation Checklist

For each product page, ensure at least 3 unique differentiators:

### Must-Have Differentiators
- [ ] Original product photography
- [ ] Unique technical specifications table
- [ ] Company-specific process description
- [ ] At least one trust signal (certification, review)

### Recommended Differentiators
- [ ] Interactive element (calculator, configurator)
- [ ] Video content (process, product demo)
- [ ] Downloadable technical resource
- [ ] Case study or application example
- [ ] Expert content (engineer-authored section)

### Advanced Differentiators
- [ ] Original research or testing data
- [ ] Industry-specific landing pages
- [ ] 3D product viewer or CAD downloads
- [ ] ROI calculator or cost comparison tool

---

## File Structure

```
/product/
├── CLAUDE.md                    # This file - main workflow
├── companies/
│   ├── _template.md             # Company analysis template
│   └── {domain}.md              # Company-specific analysis files
├── competitors/
│   ├── _template.md             # Competitor analysis template
│   └── {product-name}.md        # Product-specific competitor analysis
├── pages/
│   ├── _template.md             # Product page template
│   └── {product-name}.md        # Product page content files
├── cases/
│   ├── _template.md             # Case study template
│   └── {product}-{customer}.md  # Individual case studies
├── skills/
│   └── seo-product-page.md      # Skill for creating product pages
├── agents/
│   └── competitor-analyzer.md   # Agent for competitive analysis
└── data/
    ├── competitor-template.md   # (Legacy) Competitor analysis template
    └── page-structure.md        # Page structure reference
```

---

## Usage Examples

### Example 1: Onboarding a New Company

```
User: "Help me create content for example-foundry.com"

1. Create company analysis: /companies/example-foundry-com.md
   - Research website, capabilities, certifications
   - Define 3-4 customer segments with pain points
   - Identify ideal customer profile (ICP)
   - Establish content pillars and trust signals

2. Now ready to create product pages using the company context
```

### Example 2: Creating a Product Page (with company file)

```
User: "write: custom metal coupling"

1. Reference company file for positioning and target customer context
2. Run competitor analysis for "custom metal coupling"
3. Identify gaps: Most competitors lack video content, interactive tools
4. Create differentiated content:
   - Address specific pain points from customer analysis
   - Include trust signals prioritized in company file
   - Use messaging aligned with company positioning
5. Follow page structure template
6. Output to /pages/custom-metal-coupling.md
```

---

## Sources & References

This workflow was developed based on research from:
- [First Page Sage - B2B SEO Best Practices](https://firstpagesage.com/seo-blog/b2b-seo-best-practices/)
- [Backlinko - SEO for Manufacturers](https://backlinko.com/seo-for-manufacturers)
- [The 215 Guys - Manufacturing Product Page SEO](https://www.the215guys.com/blog/optimize-product-pages-manufacturing-seo/)
- [CXL - B2B Content Strategy Differentiation](https://cxl.com/blog/b2b-content-strategy-differentiation/)
- [Shopify - Product Detail Pages Guide 2025](https://www.shopify.com/blog/what-is-pdp-in-ecommerce)
- [Google - Product Snippet Structured Data](https://developers.google.com/search/docs/appearance/structured-data/product-snippet)
