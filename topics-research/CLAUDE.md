# Topics Research - SEO Keyword Generator

为 B2B 制造业公司生成以用户为中心的关键词和话题。

**业务模式**: B2B 生产工厂（非零售、非消费者）
**内容语言**: English only

---

## 工作流程

```
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: 基础关键词                                              │
│  用户提供种子关键词 + 公司名称                                    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Step 2: 读取公司档案 (缓存)                                     │
│  从 companies/[company]/profile.md 加载：                        │
│  - 产品/服务                                                     │
│  - 目标行业                                                      │
│  - 竞争优势                                                      │
│  - 核心关键词                                                    │
│  ⚠️ 不加载固定画像，画像在 Step 3 动态生成                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Step 3: 动态生成用户画像                                        │
│  根据 基础关键词 + 公司信息 → 生成针对性 B2B 用户画像             │
│  - 谁会搜索这个关键词？                                          │
│  - 他们的环境背景是什么？（地区、行业、规模、采购阶段）            │
│  - 他们的真实痛点是什么？                                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Step 4: Query Fan Out - 关键词衍生                              │
│  从每个画像角度重写基础关键词                                     │
│  1个关键词 → 几十个自然搜索词                                     │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Step 5: PAA 问题收集                                            │
│  询问用户提供 People Also Ask 列表                                │
│  (可选：先用工具抓取，用户补充)                                    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Step 6: 生成话题列表                                            │
│  综合 关键词 + 画像 + PAA 生成潜在话题                            │
│  输出到 output/[company]-topics-research.md                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 公司档案 (缓存)

| 公司 | 行业 | 档案路径 |
|------|------|----------|
| bastone-plastics | 增塑剂 & PVC 添加剂 | `companies/bastone-plastics/profile.md` |
| cowseal | 机械密封 | `companies/cowseal/profile.md` |
| metal-castings | 砂铸 & 熔模铸造 | `companies/metal-castings/profile.md` |
| mtedmachinery | 铝箔容器机械 | `companies/mtedmachinery/profile.md` |
| soontact | 包装机械 | `companies/soontact/profile.md` |
| tanhon | 减速机 & 齿轮箱 | `companies/tanhon/profile.md` |

### 档案内容（缓存项）

```markdown
## Basic Information
公司名、网站、行业、地点

## Products & Services
产品线、关键材料、服务项目

## Target Industries
目标行业列表

## Competitive Advantages
核心竞争优势

## Core Keywords
核心关键词列表
```

⚠️ **用户画像不缓存**，每次根据关键词动态生成

---

## B2B 用户画像 - 动态生成

### 约束条件

所有画像必须是 **B2B 企业买家**，不是消费者：

| 典型角色 | 说明 |
|----------|------|
| Maintenance Manager/Engineer | 设备维护、故障排除 |
| Plant/Reliability Engineer | 设备选型、可靠性改进 |
| Procurement Manager | 采购决策、供应商管理 |
| OEM Equipment Manufacturer | 设备制造商、配套采购 |
| Distributor/Reseller | 分销商、代理商 |
| Technical Consultant | 技术顾问、设计院 |
| Quality/Compliance Manager | 质量合规、认证需求 |

### 环境细分维度

| 维度 | 影响搜索意图 |
|------|--------------|
| **地理位置** | 北美/欧洲(严格合规) vs 东南亚(价格敏感) vs 中东(高规格) |
| **行业垂直** | 化工、水处理、油气、制药、食品等不同需求 |
| **公司规模** | 大型跨国(供应链稳定) vs 中小企业(价格导向) |
| **技术成熟度** | 工业4.0(智能监测) vs 传统(可靠耐用) |
| **采购阶段** | 紧急维修 vs 计划采购 vs 新项目招标 vs 供应商审核 |
| **预算约束** | 充足(质量优先) vs 有限(性价比优先) |
| **合规要求** | API, FDA, ATEX, ISO, CE 等 |

### 动态生成示例

**输入**: cowseal + "mechanical seal failure"

**生成画像**:
1. 北美化工厂维护经理 - 关注 EPA 合规、预防性维护
2. 东南亚水厂设备主管 - 紧急维修、寻找快速方案
3. 中东炼厂可靠性工程师 - API 682 标准、根因分析
4. 中国泵厂技术支持 - 帮客户解决售后问题

**输入**: cowseal + "seal for hydrogen compressor"

**生成画像**:
1. 欧洲氢能项目工程师 - 新兴应用、材料兼容性
2. 日本气体公司采购 - 高纯度要求、供应商认证
3. 美国压缩机OEM设计师 - 配套选型、技术参数

---

## Query Fan Out - 关键词衍生

从每个画像角度，将基础关键词转化为自然搜索词：

### 按搜索意图分类

| 意图 | 模式 | 示例 |
|------|------|------|
| **信息型** | "what is...", "how to...", "why does..." | "what causes mechanical seal failure" |
| **商业型** | "best...", "... vs ...", "top suppliers" | "best seal for sulfuric acid pump" |
| **交易型** | "... manufacturer", "buy...", "... price" | "API 682 seal supplier China" |

### 衍生模板

```
[基础关键词] + [画像环境]
[基础关键词] + [行业应用]
[基础关键词] + [问题/痛点]
[基础关键词] + [合规标准]
[基础关键词] + [对比/替代]
[基础关键词] + [地区/来源]
```

---

## 快捷命令

| 命令 | 说明 |
|------|------|
| `list companies` | 列出所有公司 |
| `[company] 关键词: [keyword]` | 为公司生成关键词衍生 |
| `expand [keyword]` | 直接扩展种子关键词 |
| `analyze [url]` | 分析网站，创建新公司档案 |

### 示例用法

```
cowseal 关键词: mechanical seal failure
```

```
expand: plasticizer migration
行业: PVC manufacturing
```

---

## 添加新公司

1. 分析网站: `analyze [company-website-url]`
2. 系统自动创建 `companies/[company-name]/profile.md`
3. 档案包含:
   - 基本信息
   - 产品/服务
   - 目标行业
   - 竞争优势
   - 核心关键词
   - ~~用户画像~~ (不缓存，动态生成)

---

## 输出格式

话题列表保存到 `output/[company]-[keyword]-topics.txt`

**格式要求**: 纯英文标题，每行一个，方便批量复制

```
What Is a Mechanical Seal? Complete Beginner's Guide
How Does a Mechanical Seal Work? Working Principle Explained
Mechanical Seal Components: Parts and Functions
...
```

**文件命名**: `[company]-[keyword]-topics.txt`
- 示例: `cowseal-mechanical-seals-topics.txt`

---

## 参考资料

- [Grounding AI for SEO](https://collaborator.pro/blog/grounding-ai-seo)
- [SEO personas for AI search](https://searchengineland.com/seo-personas-ai-search-461343)
