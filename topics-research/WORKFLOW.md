# Topics Research Workflow

B2B制造商博客话题研究流程（Query Fan Out 策略）

## 概述
本流程使用 **Query Fan Out（查询扇出）** 策略，帮助B2B制造商发现通用行业话题，建立主题权威。

**核心原则**：生成的话题是行业通用话题，而非公司特定产品话题。

## Query Fan Out 策略说明

### 什么是 Query Fan Out？
从公司的核心业务出发，向多个维度扩展搜索，获取全面的行业话题：

```
公司核心: 铝箔容器机械
              |
   ┌──────────┼──────────┐
   ↓          ↓          ↓
 材料      应用场景    生产
   |          |          |
┌──┴──┐   ┌──┴──┐   ┌──┴──┐
8011  3003  航空  外卖  质量  成本
合金  合金  餐盒  容器  控制  分析
```

### 9大研究维度

| 维度 | 描述 | 示例话题 |
|------|------|----------|
| 材料科学 | 合金、厚度、规格 | 8011 vs 3003铝合金对比 |
| 质量控制 | 缺陷、检验、标准 | 常见缺陷分析指南 |
| 应用场景 | 行业特定需求 | 航空餐盒生产指南 |
| 材料对比 | 不同材料比较 | 铝箔 vs 塑料对比 |
| 成本分析 | 生产经济学 | 生产成本全解析 |
| 法规认证 | 合规要求 | FDA法规详解 |
| 市场趋势 | 行业展望 | 市场增长分析 |
| 可持续发展 | 环保、回收 | 铝箔环保优势 |
| 生产效率 | 自动化、生产力 | 快速换模技术 |

## 流程步骤

### 第一步：创建公司档案
```bash
cp companies/_template.md companies/[公司名]/profile.md
```

填写以下关键信息：
- 行业类别（如：铝箔容器机械）
- 目标行业（如：航空餐饮、外卖包装）
- 产品应用（如：蛋糕盘、外卖盒）

### 第二步：启动话题研究
```
请为 [公司名] 进行话题研究
```

### 第三步：Query Fan Out 执行
Agent 将自动执行多维度并行搜索：

**维度1: 材料与规格**
```
- aluminum alloy 8011 vs 3003 food container
- aluminum foil thickness micron application
- food grade aluminum FDA requirements
```

**维度2: 质量与缺陷**
```
- aluminum foil container defects problems
- food packaging quality control standards
```

**维度3: 应用场景**
```
- airline meal tray requirements
- takeout container leak problems
- bakery aluminum pan production
```

**维度4: 材料对比**
```
- aluminum vs plastic container comparison
- aluminum vs CPET tray microwave
```

**维度5: 成本与商业**
```
- aluminum container production cost
- food packaging automation labor
```

**维度6: 法规认证**
```
- FDA food contact material regulation
- EU food packaging regulation
```

**维度7: 市场趋势**
```
- aluminum foil packaging market growth
- sustainable packaging trend
```

### 第四步：查看结果
研究报告保存到：
```
output/[公司名]-topics-research.md
```

## 输出格式

严格按照 `output/_template.md` 模板格式输出。

### 话题分类总览
```markdown
| 类别 | 话题数 | 目标读者 |
|------|--------|----------|
| 材料科学与规格 | 8 | 采购经理、工程师 |
| 质量控制与缺陷 | 7 | 生产经理、QC人员 |
| 应用场景指南 | 10 | 各行业买家 |
...
```

### 每个 Category 结构
```markdown
## Category N: [类别名称]

**用户痛点来源**: [论坛、指南等来源]

| 痛点 | 用户原话 |
|------|----------|
| [痛点描述] | "English quote from user..." |

**话题列表:**

| # | 中文标题 | English Title | 搜索意图 | 关键词 |
|---|----------|---------------|----------|--------|
| 1 | [中文话题标题] | [English Topic Title] | 信息型 | keyword1, keyword2 |
```

## 话题命名规则

### 正确示例 ✓
- "8011 vs 3003 铝合金：食品容器材料选择指南"
- "铝箔容器生产成本全解析"
- "航空餐盒生产完整指南"
- "铝箔 vs 塑料容器对比"

### 错误示例 ✗
- "~~MTED C系列 vs H系列对比~~"（公司特定产品）
- "~~MTED设备ROI计算~~"（公司品牌名）
- "~~如何选择MTED机器~~"（公司特定）

## 项目结构

```
topics-research/
├── companies/
│   ├── _template.md                  # 公司档案模板
│   ├── _posts-sitemap-template.md    # 站点地图模板
│   └── [公司名]/
│       ├── profile.md                # 公司档案
│       └── posts-sitemap.md          # 已发布文章站点地图
├── output/
│   └── [公司名]-topics-research.md   # 研究报告
├── WORKFLOW.md                       # 本文档
└── README.md
```

## 使用示例

```
用户: 请为 mtedmachinery 进行话题研究

Claude:
1. 读取 companies/mtedmachinery/profile.md
2. 识别核心行业：铝箔容器机械
3. 执行 Query Fan Out：
   - 材料维度：8011/3003合金、厚度规格...
   - 应用维度：航空餐盒、外卖容器...
   - 质量维度：缺陷分析、质检标准...
   - 成本维度：生产成本、自动化ROI...
   - 法规维度：FDA、EU标准...
   - 市场维度：增长趋势、区域机会...
4. 生成 output/mtedmachinery-topics-research.md
```

## 研究来源

### 主要平台
| 平台 | 内容类型 |
|------|----------|
| Reddit | 用户讨论、痛点 |
| Quora | 问答、常见问题 |
| Practical Machinist | 技术讨论 |
| Industry Reports | 市场数据 |
| FDA/EU官网 | 法规标准 |

### 搜索模板
| 维度 | 搜索模板 |
|------|----------|
| 材料 | `[材料A] vs [材料B] [应用]` |
| 缺陷 | `[产品] defects problems quality` |
| 应用 | `[行业] [产品] requirements` |
| 对比 | `[材料] vs [材料] comparison` |
| 成本 | `[产品] production cost analysis` |
| 法规 | `[法规] [产品] requirements` |
| 市场 | `[产品] market size growth trend` |

## 第五步：增量话题扩展（可选）

已完成初始研究后，可以继续扩展话题：

```
请为 [公司名] 增加更多 [方向] 话题
```

**扩展方向示例：**
- 更多细分应用场景
- 更深技术话题
- 更多对比类话题
- 特定行业垂直话题

**扩展结果**：追加到现有报告，或生成补充报告。

---

## 新话题研究模式（公司列表前置）

当用户提供一个话题方向，但目标公司不确定时，使用此流程：

### 步骤1：用户提供话题方向
```
我想研究 [话题方向] 相关的话题
```

例如：
- "工业自动化"
- "食品包装设备"
- "B2B外贸SEO"

### 步骤2：Claude 列出匹配公司

Claude 会列出可能相关的公司列表：

```markdown
## 可能匹配的公司

| 公司 | 行业 | 匹配度 | 产品关联 |
|------|------|--------|----------|
| Cowseal | 机械密封 | ⭐⭐⭐ | 泵、设备密封 |
| MTED | 铝箔容器设备 | ⭐⭐ | 食品包装机械 |
| ... | ... | ... | ... |

请选择目标公司（可多选）：
```

### 步骤3：用户选择目标公司

用户明确选择后，Claude 生成高度匹配的话题。

### 步骤4：生成匹配话题

Claude 确保所有话题都与选定公司的业务高度相关：
- 话题与公司产品/服务有明确关联
- 目标读者是公司的潜在客户
- 内容可自然引导到公司解决方案

---

## 文章站点地图（去重机制）

每个公司维护一个 `posts-sitemap.md` 文件，记录已发布文章：

```
companies/[公司名]/posts-sitemap.md
```

### 站点地图内容

| 字段 | 用途 |
|------|------|
| 文章索引 | 标题、搜索意图、关键词、URL |
| 意图统计 | Informational/Commercial/Transactional 数量 |
| 集群覆盖 | 各话题集群的已写/待写数量 |
| 已用关键词 | 生成新话题时避免重复 |

### 去重规则

生成新话题时，Claude 会检查：
1. **关键词重复**：新话题主关键词不与已发布文章重复
2. **搜索意图重复**：同一搜索意图下不重复相似话题
3. **话题集群平衡**：优先补充覆盖较少的集群

### 使用流程

1. **初始化站点地图**：从公司网站 `post-sitemap.xml` 同步已发布文章
   ```
   请为 [公司名] 更新 posts-sitemap，格式为 example.com/post-sitemap.xml
   ```
2. 发布新文章后，手动更新 `posts-sitemap.md`
3. 生成新话题时，Claude 自动读取站点地图
4. 新话题会排除已覆盖的搜索意图和关键词

---

## 注意事项

1. **通用话题优先**：所有话题都应该是行业通用的，不包含公司特定产品名称
2. **多维度覆盖**：每次研究至少覆盖5个维度
3. **用户声音**：尽量包含真实用户的原话引用
4. **SEO关键词**：每个话题都应该有对应的SEO关键词
5. **优先级排序**：按商业价值和搜索量进行优先级排序
6. **增量扩展**：已完成研究可随时扩展，不需重新开始
7. **公司匹配前置**：新话题方向可先确认公司列表，再生成话题
8. **去重检查**：生成话题前先读取 posts-sitemap.md，避免重复
