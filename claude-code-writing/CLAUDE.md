# CLAUDE.md

SEO 文章写作工作流。两种模式：新文章写作、旧文章优化。

## Architecture

| Agent | Reads | Writes |
|-------|-------|--------|
| `article-importer` | URL | imports/[topic]-analysis.md |
| `config-creator` | about-us.md | config/[topic]-core.json |
| `web-researcher` | core.json | config/[topic]-research.json, sources.md |
| `outline-writer` | core.json, research.json, sources.md | config/[topic]-writing.json, outline, draft |
| `proofreader` | core.json, research.json, writing.json, sources.md | output/* |

**Config 拆分** (优化 token 消耗):
- `core.json`: 文章配置、受众、人设、搜索意图 (~200 行)
- `research.json`: 竞品分析、素材、写作建议 (~400 行)
- `writing.json`: 写作决策、素材使用记录 (~100 行)

**目录结构**: `.claude/agents/` (5 agents), `.claude/data/companies/` (公司配置), `.claude/data/style/` (风格指南)

**语言协议**: Tool/Model → English | 用户交互 → 中文 | 文章输出 → semrush 中文, others English

---

## Workflow 1: 新文章写作

**触发**: 用户提供主题

### Step 1: Collect Inputs & Create Config

1. **展示公司列表**: Read `.claude/data/companies/index.md`

2. **受众框架选择**:
   - 显示: `受众场景: B2B(专业/工作) / B2C(日常/个人)? [B/C]`
   - 用户选择后，显示对应的受众选项（见 Display Templates）

3. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`

5. **内链缓存检查**:
   - 读取 `internal-links.md`，提取 `Last Updated` 日期
   - 显示: `内链缓存: [日期] ([X]天前) - 刷新? [N(默认)/Y]`
   - 用户选 Y → 执行**增量深度刷新**:

     ```bash
     # Step 1: 计算差异
     .claude/scripts/refresh-internal-links.sh [company] [sitemap-url] --diff-only
     # 输出到 .claude/data/companies/[company]/.internal-links-diff/
     #   - new_urls.txt (新增)
     #   - deleted_urls.txt (删除)
     #   - unchanged_urls.txt (不变)
     ```

     ```
     # Step 2: 处理新增 URLs (Main workflow 直接执行)
     1. Read: .claude/data/companies/[company]/.internal-links-diff/new_urls.txt
     2. For each URL:
        - Extract title from URL slug (e.g., /mechanical-seal-failure/ → "Mechanical Seal Failure")
        - Infer search intent and write one-sentence summary in English
        - Format: - [Title From Slug](URL)\n  > Search intent summary
     3. Read existing: .claude/data/companies/[company]/internal-links.md
        - Keep entries for unchanged URLs (from unchanged_urls.txt)
        - Remove entries for deleted URLs (from deleted_urls.txt)
        - Add new entries with title + summary
     4. Write updated internal-links.md with:
        - <!-- Last Updated: [today] -->
        - <!-- Deep Refresh: [count] URLs processed -->
     ```

     **URL slug 转标题规则**:
     - `/api-plan-11/` → "API Plan 11"
     - `/mechanical-seal-failure/` → "Mechanical Seal Failure"
     - 保留数字和缩写的大写

     **缓存格式** (deep refresh 后):
     ```markdown
     # Internal Links Cache

     <!-- Last Updated: 2026-01-10 -->
     <!-- Deep Refresh: 15 URLs processed -->

     ## Articles
     - [15 Reasons For Mechanical Seal Failure](https://cowseal.com/...)
       > Common causes of seal failure including dry running, installation errors, and material incompatibility.

     - [API Plan 11](https://cowseal.com/api-plan-11/)
       > Single seal flush plan using process fluid from pump discharge.
     ```

6. **收集用户选择**（展示格式见下方 Display Templates）:
   - 受众 + 深度（一次询问）
   - 文章类型
   - 文章长度（简短/标准/深度）
   - 作者人设

7. **确定输出语言**: `semrush → 中文, others → English`

8. **Launch config-creator**:
   ```
   Task: subagent_type="config-creator"
   Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [articleLength], [persona], [language], [audienceFramework: b2b|b2c]
   ```

   **audienceFramework** 由 Step 4 用户选择确定

9. **验证**: `config/[topic-title]-core.json` 存在

### Step 2: Competitor Analysis

```
Task: subagent_type="web-researcher"
Prompt: Phase 1 - Competitor Analysis for: [topic-title]
```

**输出**: `config/[topic-title]-research.json` (含 `innovationSpace`, `executionDifferentiation`)

**验证**: research.json 有 `innovationSpace.level`

### Step 3: Select Writing Angle (条件执行)

**检查 `research.json` 的 `innovationSpace.skipThesis`**:

| skipThesis | 处理 |
|------------|------|
| `true` | 跳过 Step 3，显示执行差异化摘要，直接进入 Step 4 |
| `false` | 执行角度选择流程 |

**如果 skipThesis = true**:
```
显示：
创新空间: [level] — [reason]
差异化策略: 执行层差异化

将通过以下方式超越竞品：
- 深度: [executionDifferentiation.depth.specificAreas]
- 覆盖: [executionDifferentiation.coverage.ourAdditions]
- 实用价值: [executionDifferentiation.practicalValue.ourAdditions]

→ 跳过角度选择，进入素材收集
```

**如果 skipThesis = false**:
1. 读取 `research.json` 的 `recommendedTheses`，翻译展示给用户（格式见下方 Display Templates）
2. 用户选择后，**main workflow 直接 Edit** `core.json`:
   ```
   Edit core.json:
   - "writingAngle.thesis": "[选中的 thesis]"
   - "writingAngle.stance": "[对应的 stance]"
   - "writingAngle.pending": false
   - 如果深度不匹配: "writingAngle.depthMismatchAcknowledged": true
   ```

### Step 4: Evidence Collection

```
Task: subagent_type="web-researcher"
Prompt: Phase 2 - Evidence Collection for: [topic-title], Selected angle: [thesis]
```

**输出**: `knowledge/[topic-title]-sources.md` + `research.json` 更新

**验证**: sources.md 存在

### Step 5: Write

```
Task: subagent_type="outline-writer"
Prompt: Create outline and write article for: [topic-title]
```

**输出**: `outline/[topic-title].md`, `drafts/[topic-title].md`

**验证**: 两个文件都存在

### Step 6: Proofread & Deliver

```
Task: subagent_type="proofreader"
Prompt: Proofread and deliver article for: [topic-title]
```

**输出**: `output/[topic-title].md`, `output/[topic-title]-sources.md`, `output/[topic-title]-images.md`

**验证**: 三个文件都存在 → 完成

---

## Workflow 2: 旧文章优化

**触发**: "优化" + URL

### Step 0: 导入分析

```
Task: subagent_type="article-importer"
Prompt: Import and analyze article from: [URL]
```

**输出**: `imports/[topic-title]-analysis.md`

展示诊断摘要，然后继续 Step 1（带预填推荐）。

### Step 1-6: 同 Workflow 1

区别：
- Step 1: 显示分析推荐的受众/深度/类型
- Step 2: 竞品分析参考旧文章问题
- Step 4: 证据搜索验证/更新旧数据
- config-creator 带 `optimization.enabled: true`

---

## Reference Tables

### 受众→深度映射

**B2B 深度：**
| 深度 | 说明 |
|-----|------|
| 入门基础 | 解释概念，使用类比，假设无背景 |
| 进阶技巧 | 行业术语，选择框架，决策依据 |
| 技术细节 | 具体参数，操作步骤，规范引用 |
| 概述 | 聚焦价值和成本，不涉及技术细节 |
| 专家级 | 最高复杂度，引用研究和标准 |

**B2C 深度：**
| 深度 | 说明 |
|-----|------|
| 极简 | 像朋友聊天，3-5分钟读完，只回答核心问题 |
| 实用 | 问题→诊断→解决方案→何时找专业人士 |
| 对比 | 功能翻译成好处，对比表格，推荐建议 |

### 角度选择逻辑

角度选择现在由 **创新空间评估** 决定，而非单纯基于文章类型：

| 创新空间 | skipThesis | 差异化策略 |
|---------|------------|-----------|
| low | true | 执行差异化（深度、覆盖、实用价值） |
| medium | false | 轻量角度 + 执行差异化 |
| high | false | 观点差异化（必须选 thesis） |

**典型映射**（但由竞品分析动态决定）：

| 文章类型 | 常见创新空间 |
|---------|-------------|
| 观点型 | high（有争议空间） |
| 教程型 | low-medium（步骤通常固定） |
| 信息型 | low（答案通常唯一） |
| 对比型 | medium-high（需要判断） |

### 人设→场景匹配

**B2B 人设：**
| 人设 | 适合深度 | 适合类型 | 适合受众 |
|-----|---------|---------|---------|
| 技术专家 | 技术细节/专家级 | 观点/信息 | 实操者/专家 |
| 实践导师 | 入门基础/进阶技巧 | 教程/信息 | 入门新手/非专业人士 |
| 行业观察者 | 概述/进阶技巧 | 对比/观点 | 决策者/非专业人士 |

**B2C 人设：**
| 人设 | 适合深度 | 适合类型 | 适合受众 |
|-----|---------|---------|---------|
| 生活达人 | 极简 | 信息 | 好奇新手 |
| 热心邻居 | 实用 | 教程 | 问题解决者 |
| 精明买家代言人 | 对比 | 对比 | 精明买家 |

---

## Config Files

Schema: @.claude/data/workflow-state-schema.md

**core.json** (config-creator → all agents):
- `articleType`: opinion/tutorial/informational/comparison
- `writingAngle.thesis`: The ONE claim (null until Step 3)
- `writingAngle.stance`: challenge/confirm/nuance
- `authorPersona.role/bias`: WHO writes, with what perspective

**research.json** (web-researcher → outline-writer, proofreader):
- `innovationSpace.level/skipThesis` → 决定 Step 3 是否执行
- `executionDifferentiation` → 低创新空间的差异化方向
- `recommendedTheses` → Step 3 角度选择（如果需要）
- `thesisValidation` → outline-writer 使用
- `writingAdvice.cautious` → 需模糊处理的区域

**writing.json** (outline-writer → proofreader):
- `thesisExecution`, `personaExecution` → 执行记录
- `sectionsToWatch` → proofreader 重点验证
- `materialUsage` → 素材使用记录

---

## File Flow

```
config/[topic]-core.json      ← Step 1
config/[topic]-research.json  ← Step 2, updated Step 4
config/[topic]-writing.json   ← Step 5
knowledge/[topic]-sources.md  ← Step 4
outline/[topic].md            ← Step 5
drafts/[topic].md             ← Step 5
output/[topic].md             ← Step 6
output/[topic]-sources.md     ← Step 6
output/[topic]-images.md      ← Step 6
imports/[topic]-analysis.md   ← Workflow 2 Step 0 only
```

**Completion**: Workflow 1 = 9 files, Workflow 2 = 10 files

**Naming**: kebab-case (`steel-heat-treatment`)

---

## Display Templates

展示选项时的格式参考。直接在对话中输出，不使用 AskUserQuestion 工具。

**⚠️ 重要：动态生成描述**

下方模板仅为**结构参考**。每个选项的描述必须根据**具体话题的搜索意图**动态生成，而非照搬固定文字。

**错误示范**（照搬模板）：
```
话题：如何选择扫地机器人

1. 好奇新手
   纯粹好奇或首次接触，想快速了解是什么  ← 固定模板文字
```

**正确示范**（针对话题生成）：
```
话题：如何选择扫地机器人

1. 好奇新手
   听说扫地机器人很方便，想了解是不是真的好用  ← 针对话题
```

此原则适用于：**受众、深度、文章类型、人设** 所有选项的描述。

---

### 受众 + 深度选项

**先选择受众框架：**
```
受众指导: B2B(专业场景) / B2C(日常场景)? [B/C]

> 分析：[根据话题分析典型搜索者是谁、在什么场景下搜索、为什么搜索]
```

分析应说明：
- 谁会搜索这个话题（专业人士 vs 普通用户）
- 搜索场景（工作需要 vs 生活问题）
- 推荐 B2B 或 B2C 的理由

---

**B2B User Types**（专业/工作场景）：

| 类型 | 核心特征（供参考，需针对话题改写） |
|------|----------------------------------|
| 入门新手 | 刚进入行业，需要基础概念 |
| 非专业人士 | 了解基本概念，需做选择或决策 |
| 实操者 | 有实操经验，需具体步骤或解决问题 |
| 决策者 | 关注价值和成本，不需技术细节 |
| 专家 | 深度专业，需最新信息或深入分析 |

**B2C User Types**（日常/个人场景）：

| 类型 | 核心特征（供参考，需针对话题改写） |
|------|----------------------------------|
| 好奇新手 | 首次接触，想快速了解 |
| 问题解决者 | 遇到具体问题，需解决方案 |
| 精明买家 | 准备购买，需对比和选择建议 |

**展示格式**：
```
请选择目标受众：

1. [类型名] (推荐)
   [针对本话题，这类读者的具体情境和需求]
   ✓ 推荐原因：[为什么这个受众最匹配本话题]

2. [类型名]
   [针对本话题，这类读者的具体情境和需求]

> 分析：[说明为什么推荐这个受众，话题的搜索意图指向哪类人群]
```

**格式规则：**
- 根据搜索意图推断，推荐的选项标 `(推荐)` 并附推荐原因
- 末尾附分析说明推荐依据
- 用户回复：`B2` 或 `C1` 等

---

**深度选项**（选完受众后单独询问）：

**B2B 深度（核心特征）：**

| 深度 | 特征（需针对话题改写描述） |
|------|--------------------------|
| 入门基础 | 解释概念，使用类比，假设无背景 |
| 进阶技巧 | 行业术语，选择框架，决策依据 |
| 技术细节 | 具体参数，操作步骤，规范引用 |
| 概述 | 聚焦价值和成本，不涉及技术细节 |
| 专家级 | 最高复杂度，引用研究和标准 |

**B2C 深度（核心特征）：**

| 深度 | 特征（需针对话题改写描述） |
|------|--------------------------|
| 极简 | 3-5分钟读完，只回答核心问题 |
| 实用 | 问题→诊断→解决方案→何时找专业人士 |
| 对比 | 功能翻译成好处，对比表格，推荐建议 |

**展示格式**：
```
请选择内容深度：

1. [深度] (推荐)
   [针对本话题和已选受众，这个深度会怎样呈现内容]
   ✓ 推荐原因：[为什么这个深度最匹配]

2. [深度]
   [针对本话题，这个深度会怎样呈现内容]

> 分析：[基于已选受众，说明为什么推荐这个深度]
```

**推荐规则**（根据已选受众标注）：

| 受众 | 推荐深度 |
|-----|---------|
| B2B: 入门新手 | 入门基础 |
| B2B: 非专业人士 | 进阶技巧 |
| B2B: 实操者 | 技术细节 |
| B2B: 决策者 | 概述 |
| B2B: 专家 | 专家级 |
| B2C: 好奇新手 | 极简 |
| B2C: 问题解决者 | 实用 |
| B2C: 精明买家 | 对比 |

---

### 文章类型选项

| 类型 | 适合场景（需针对话题改写） |
|------|--------------------------|
| 对比型 | 比较多个选项、A vs B |
| 观点型 | 挑战误区、强调被忽视要点 |
| 信息型 | 纯粹知识科普，不需表达立场 |
| 教程型 | how-to 类型，步骤指南 |

**展示格式**：
```
请选择文章类型：

1. [类型] (推荐)
   ✓ [针对本话题为什么推荐这个类型]

2. [类型]
   △ [针对本话题选这个类型会怎样]

> 分析：[基于话题结构和搜索意图，说明为什么推荐这个类型]
```

---

### 作者人设选项

**B2B 人设**（从公司 about-us.md Part 5 读取核心特征）：

| 人设 | 核心视角（需针对话题改写） |
|------|--------------------------|
| 技术专家 | 深度技术分析，一线实战经验 |
| 实践导师 | 手把手教学，从基础讲起 |
| 行业观察者 | 跨公司视角，战略层面 |

**B2C 人设**（从 template Part 5 读取核心特征）：

| 人设 | 核心视角（需针对话题改写） |
|------|--------------------------|
| 生活达人 | 像朋友聊天，分享生活经验 |
| 热心邻居 | 踩过坑愿意分享，实用建议 |
| 精明买家代言人 | 做过功课的消费者，客观对比 |

**展示格式**：
```
请选择作者人设：

1. [人设] (推荐)
   [针对本话题，这个人设会怎样写这篇文章]
   ✓ 推荐原因：[为什么这个人设最匹配已选受众]

2. [人设]
   [针对本话题，这个人设会怎样写这篇文章]

> 分析：[基于已选受众和话题，说明为什么推荐这个人设]
```

**推荐规则**（根据已选受众标注）：

| 受众 | 推荐人设 |
|-----|---------|
| B2B: 入门新手 | 实践导师 |
| B2B: 非专业人士 | 实践导师 |
| B2B: 实操者 | 技术专家 |
| B2B: 决策者 | 行业观察者 |
| B2B: 专家 | 技术专家 |
| B2C: 好奇新手 | 生活达人 |
| B2C: 问题解决者 | 热心邻居 |
| B2C: 精明买家 | 精明买家代言人 |

---

### 文章长度选项

**展示格式**：
```
请选择文章长度：

1. 标准 (推荐)
   1200-1500 词
   ✓ [针对本话题，为什么标准长度合适]

2. 简短
   900-1100 词
   △ [针对本话题，选简短会怎样]

3. 深度
   1800-2300 词
   △ [针对本话题，选深度会怎样]

> 分析：[基于话题复杂度和已选深度，说明为什么推荐这个长度]
```

### 写作角度选项（Step 3）

从 `research.json` 的 `recommendedTheses` 读取，翻译后展示：

**术语翻译：**
| 英文 | 中文 |
|-----|------|
| challenge | 挑战型 |
| confirm | 强化型 |
| nuance | 细化型 |

**展示格式：**
```
基于竞品分析，推荐以下写作角度：

1. 预热步骤是被低估的关键环节 (推荐)
   立场: 挑战型 | 适合深度: 入门/进阶
   ✓ 匹配原因：差异化强，数据充足，深度兼容

2. 温度控制比时间控制更重要
   立场: 细化型 | 适合深度: 技术细节
   △ 匹配度：差异化中等，深度匹配

3. 传统温度曲线计算存在系统误差
   立场: 挑战型 | 适合深度: 专家级
   ⚠️ 注意：深度不匹配（需专家级，已选技术细节）
```
