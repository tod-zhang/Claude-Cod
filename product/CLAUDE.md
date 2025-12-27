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
/companies/{company}/config.md (公司特定上下文)
    ↓
产品页保存到 /companies/{company}/pages/
```

### 切换公司

创建产品页时，先确认是为哪个公司：

1. **确认公司** — "这是为哪个网站创建的？"
2. **读取公司文件** — 获取 `/companies/{company}/config.md`
3. **按配置生成** — 所有输出保存到该公司文件夹

### 已配置的公司

| 公司 | 文件夹 | 行业 |
|------|--------|------|
| metal-castings.com | `/companies/metal-castings/` | 铸造 |
| *(新公司)* | `/companies/{domain}/` | *(待配置)* |

### 添加新公司

1. 创建文件夹 `/companies/{domain}/`
2. 复制 `/_templates/company.md` 到 `/companies/{domain}/config.md`
3. 创建子文件夹：`competitors/`、`pages/`
4. 填写公司信息和**行业配置（Section 3）**
5. 行业配置决定：
   - 产品页应包含哪些规格
   - 竞争对手搜索用什么关键词
   - 信任信号优先级

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

1. **Create company folder**: Create `/companies/{domain}/` with subfolders, copy `/_templates/company.md` to `config.md`
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

### Template & File Location

```
/_templates/
└── company.md                # Master template for new companies

/companies/metal-castings/
├── config.md                 # Company configuration
├── competitors/              # Competitor analysis files
└── pages/                    # Product page content
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

**Output all competitor research to the company's folder:**

```
/companies/{company}/competitors/{product-name}.md
```

Use the template at `/_templates/competitor.md`. This creates:
- Reusable research for future content updates
- Documentation of differentiation strategy
- Keyword insights for SEO optimization

---

## Phase 2: Differentiation Strategy（可执行版）

> **原则：差异化来自竞争分析，不是凭空创造**

### 2.1 差异化流程

```
Phase 1 竞争分析
      ↓
识别3类空白：内容空白 / 质量空白 / 信任空白
      ↓
针对每个空白，选择具体差异化动作
      ↓
融入产品页各模块
```

### 2.2 差异化动作清单

**根据 Phase 1 发现的空白，从以下动作中选择：**

#### 规格差异化（Specifications Section）

| 空白类型 | 差异化动作 | 示例 |
|----------|------------|------|
| 竞争对手规格表只有5行 | 扩展到10-15行 | 增加公差、表面处理、热处理选项 |
| 只有通用规格 | 增加材料对比表 | 铸铁 vs 铸钢 vs 球墨铸铁性能对比 |
| 缺少尺寸范围 | 明确最小/最大能力 | "50 lbs - 50,000 lbs" |
| 无技术图纸 | 提供标注图 | 三视图 + 关键尺寸标注 |

#### 应用差异化（Applications Section）

| 空白类型 | 差异化动作 | 示例 |
|----------|------------|------|
| 只列行业名称 | 写具体设备型号 | "叉车" → "Toyota 8FGCU25, Hyster H50FT" |
| 缺少安装位置 | 描述安装场景 | "后配重仓，通过4个M16螺栓固定" |
| 无行业痛点 | 针对每行业写1句痛点 | "农业设备需要耐腐蚀涂层" |

#### FAQ差异化

| 空白类型 | 差异化动作 | 来源 |
|----------|------------|------|
| 无FAQ | 添加5-8个问题 | Google "People Also Ask" |
| FAQ太浅 | 回答工程级问题 | "配重计算公式" "材料选择依据" |
| 只有通用问题 | 加入产品特定问题 | 搜索 "[product] problems" |

#### 信任差异化（Why Choose Us Section）

| 空白类型 | 差异化动作 | 说明 |
|----------|------------|------|
| 无认证展示 | 添加认证徽章条 | ISO 9001, IATF 16949 等 |
| 无社会证明 | 嵌入Google评分 | ★★★★★ 4.9 (50+ reviews) |
| 只有文字描述 | 添加工厂实拍 | 设备、产线、质检照片 |

### 2.3 差异化检查清单

**每个产品页发布前，确认至少完成3项：**

- [ ] 规格表比竞争对手多50%以上内容
- [ ] 应用场景包含具体设备型号
- [ ] FAQ包含至少1个工程级问题
- [ ] 有至少1个可验证的信任信号
- [ ] 有竞争对手没有的独特信息点

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

## Phase 5: Trust Signals（信任信号）

> **不用案例，用可验证的信任信号建立可信度。**

### 5.1 为什么不用案例

| 格式 | 问题 |
|------|------|
| 匿名案例 "Leading manufacturer" | 无法验证，像是编的 |
| 模板化故事 | 竞争对手也能写一样的 |
| 没有真实素材的案例 | 空洞，反而降低信任 |

**原则：没有真实可验证的素材，不放案例。**

### 5.2 替代方案：可验证的信任信号

| 信任信号 | 说明 | 优先级 |
|----------|------|--------|
| **认证徽章** | ISO 9001, IATF 16949 等（可查验） | 高 |
| **Google Reviews** | 评分 + 评论数（公开可查） | 高 |
| **真实产品照片** | 工厂实拍，非stock photo | 高 |
| **客户logo墙** | 有授权使用的客户logo | 中 |
| **设备/工厂照片** | 展示真实生产能力 | 中 |
| **详细技术规格** | 体现专业性 | 中 |

### 5.3 产品页信任模块

```
[Why Choose Us Section] ─────────────────────────
├── 4个差异化卡片（图标+标题+一句话）
├── 认证logo条：ISO 9001 | IATF 16949 | ...
├── Google Reviews：★★★★★ 4.9 (50+ reviews)
└── 客户logo条（可选，需有授权）
```

### 5.4 收集信任素材清单

向客户收集：
- [ ] 认证证书扫描件/编号
- [ ] Google Business Profile 链接
- [ ] 可公开使用的客户logo（需授权）
- [ ] 工厂/设备实拍照片
- [ ] 产品实拍照片（非渲染图）

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

## Phase 7: Image Specifications（图片描述文件）

> **每个产品页都需要生成配套的图片描述文件，供AI生成图片使用**

### 7.1 文件命名

```
/companies/{company}/pages/{product}-images.md
```

### 7.2 图片数量要求

| 优先级 | 数量 | 类型 |
|--------|------|------|
| P1 - Must Have | 2张 | Hero产品图、技术图纸 |
| P2 - Should Have | 6-8张 | **应用场景（按行业）**、工艺流程、质检 |
| P3 - Nice to Have | 2-4张 | 细节、对比图、示意图 |
| **总计** | **10-14张** | |

> **重点：应用场景照片优先级提升为 P2**
>
> 每个产品页应包含该产品所有主要应用行业的场景照片。例如配重产品需要覆盖：叉车、挖掘机、拖拉机、起重机、电梯、船舶等。

### 7.3 每张图片包含的字段

| 字段 | 说明 | 必填 |
|------|------|------|
| **Title** | 图片标题（英文） | 是 |
| **Type** | 图片类型：Product Photography / Technical Drawing / Process Photography / Infographic | 是 |
| **Priority** | P1/P2/P3 | 是 |
| **Placement** | 在页面中的位置 | 是 |
| **AI Generation Prompt** | 详细的AI生成提示词（英文，150-300词） | 是 |
| **Alt Text** | SEO替代文本（英文，10-20词） | 是 |

### 7.4 AI Prompt 写作要点

**好的Prompt应包含：**
- 具体的拍摄角度/视角
- 光线条件和氛围
- 产品尺寸参考（与常见物品对比）
- 背景环境描述
- 材质和表面质感
- 画幅比例（4:3, 16:9, 1:1）
- 明确说明"无人物"或"工业环境"等

**示例：**
```
Professional industrial product photography of 5-6 cast iron counterweights
arranged on a clean concrete factory floor. Weights range from small (50 lbs,
roughly basketball-sized) to large (5,000 lbs, roughly refrigerator-sized).
Dark gray iron finish with visible casting texture. Soft industrial lighting
from above. No people in frame. 4:3 aspect ratio.
```

### 7.5 图片类型参考

| 类型 | 优先级 | 适用场景 | 示例 |
|------|--------|----------|------|
| **Product Photography** | P1 | Hero区 | 产品组合照、尺寸对比 |
| **Technical Drawing** | P1 | 规格区 | 尺寸标注图、三视图 |
| **Application Photography** | P2 | 应用区 | 叉车、挖掘机、拖拉机、起重机、电梯、船舶等实际安装场景 |
| **Process Photography** | P2 | 信任区 | 浇注、机加工、质检 |
| **Infographic** | P2/P3 | 对比区 | 材料对比图、流程图 |
| **Detail Shot** | P3 | 规格区 | 表面质感、加工细节 |

> **应用场景照片要求：**
> - 每个主要应用行业至少1张
> - 清晰展示产品在设备上的安装位置
> - 体现产品的实际工作环境
> - 参考公司config.md中定义的目标行业

---

## File Structure

```
/product/
├── CLAUDE.md                    # This file - main workflow
├── _templates/                  # 通用模板（跨公司共用）
│   ├── company.md               # Company analysis template
│   └── competitor.md            # Competitor analysis template
└── companies/                   # 每个公司独立文件夹
    └── {domain}/
        ├── config.md            # 公司配置 + 产品页通用规范
        ├── competitors/         # 竞争分析
        │   └── {product}.md
        └── pages/               # 产品页内容
            ├── {product}.md           # 产品页正文
            └── {product}-images.md    # 图片描述文件（供AI生成）
```

---

## Usage Examples

### Example 1: Onboarding a New Company

```
User: "Help me create content for example-foundry.com"

1. Create company folder: /companies/example-foundry/
   - Create subfolders: competitors/, pages/
   - Copy /_templates/company.md to config.md
   - Research website, capabilities, certifications
   - Define 3-4 customer segments with pain points
   - Identify ideal customer profile (ICP)
   - Establish content pillars and trust signals

2. Now ready to create product pages using the company context
```

### Example 2: Creating a Product Page (with company file)

```
User: "write: custom metal coupling" (for metal-castings)

1. Reference /companies/metal-castings/config.md for positioning
2. Run competitor analysis, save to /companies/metal-castings/competitors/custom-metal-coupling.md
3. Identify gaps: Most competitors lack video content, interactive tools
4. Create differentiated content:
   - Address specific pain points from customer analysis
   - Include trust signals prioritized in company file
   - Use messaging aligned with company positioning
5. Follow page structure template
6. Output to /companies/metal-castings/pages/custom-metal-coupling.md
7. Generate image descriptions: /companies/metal-castings/pages/custom-metal-coupling-images.md
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
