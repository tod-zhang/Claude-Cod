# Company Profile Template

为 B2B 制造业公司创建档案的模板。

---

## 模板结构

```markdown
# Company Profile: [Company Name]

## Basic Information
- **Company Name**: [Full Name]
- **Website**: [URL]
- **Industry**: [Industry Description]
- **Location**: [City, Province, Country]
- **Founded**: [Year]
- **Target Market**: [Global B2B / Regional]

## Products & Services

### Main Products
- [Product Line 1]
- [Product Line 2]
- ...

### Services Offered
- [Service 1]
- [Service 2]
- ...

## Target Industries
- [Industry 1]
- [Industry 2]
- ...

## Competitive Advantages
1. [Advantage 1]
2. [Advantage 2]
3. ...

## Core Keywords
- [keyword 1]
- [keyword 2]
- ...

## Main Competitors
- [Competitor 1]
- [Competitor 2]
- ...
```

---

## 说明

### 缓存内容

| 项目 | 说明 | 是否缓存 |
|------|------|----------|
| Basic Information | 公司基本信息 | ✅ 缓存 |
| Products & Services | 产品和服务 | ✅ 缓存 |
| Target Industries | 目标行业 | ✅ 缓存 |
| Competitive Advantages | 竞争优势 | ✅ 缓存 |
| Core Keywords | 核心关键词 | ✅ 缓存 |
| Main Competitors | 主要竞争对手 | ✅ 缓存 |
| **User Personas** | **用户画像** | ❌ **不缓存，动态生成** |

### 用户画像 - 动态生成

用户画像不存储在 profile.md 中，而是在每次关键词研究时**根据关键词动态生成**。

**为什么动态生成？**
- 不同关键词面向不同用户群体
- 可以发现缓存画像未覆盖的新角度
- 避免思维固化，保持灵活性

**动态生成时的参考维度：**

| 维度 | 示例 |
|------|------|
| **角色** | Maintenance Engineer, Procurement Manager, OEM, Distributor... |
| **地理位置** | 北美/欧洲(严格合规) vs 东南亚(价格敏感) vs 中东(高规格) |
| **行业垂直** | 化工、水处理、油气、制药、食品等 |
| **公司规模** | 大型跨国 vs 中小企业 |
| **采购阶段** | 紧急维修 vs 计划采购 vs 新项目 |
| **预算约束** | 充足(质量优先) vs 有限(价格敏感) |
| **合规要求** | API, FDA, ATEX, ISO, CE 等 |

---

## 创建新公司档案

1. 使用 `analyze [company-url]` 命令
2. 系统抓取网站信息
3. 按上述模板创建 `companies/[company-name]/profile.md`
4. 用户画像在关键词研究时动态生成
