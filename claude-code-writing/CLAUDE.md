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
2. **分析搜索意图**（独立于公司）:
   | 意图类型 | 典型搜索者 |
   |----------|------------|
   | B2C | 爱好者、家庭用户、小型卖家 |
   | B2B | 工程师、生产经理、采购人员 |
   | 混合 | 两类都有 |

3. **意图-公司匹配检查**:
   - B2B 意图 + B2B 公司 → 继续
   - B2C 意图 + B2B 公司 → 提示用户（见下方 Display Templates）
   - 混合 → 让用户选择目标受众类型

4. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`

5. **内链缓存检查**:
   - 读取 `internal-links.md`，提取 `Last Updated` 日期
   - 显示: `内链缓存: [日期] ([X]天前) - 刷新? [N(默认)/Y]`
   - 用户选 Y → 执行刷新:
     ```
     1. Read about-us.md → 提取 sitemap URL (post-sitemap.xml)
     2. WebFetch sitemap → 提取所有 <loc> URLs
     3. Write internal-links.md:
        - 更新 Last Updated 为今天
        - 格式: `- [Title](URL)` 每行一个
     ```

6. **收集用户选择**（展示格式见下方 Display Templates）:
   - 受众 + 深度（一次询问）
   - 文章类型
   - 作者人设

7. **确定输出语言**: `semrush → 中文, others → English`

8. **Launch config-creator**:
   ```
   Task: subagent_type="config-creator"
   Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [persona], [language]
   ```

9. **验证**: `config/[topic-title]-core.json` 存在

### Step 2: Competitor Analysis

```
Task: subagent_type="web-researcher"
Prompt: Phase 1 - Competitor Analysis for: [topic-title]
```

**输出**: `config/[topic-title]-research.json` (含 `recommendedTheses`)

**验证**: research.json 有 `recommendedTheses`

### Step 3: Select Writing Angle

1. 读取 `research.json` 的 `recommendedTheses`，翻译展示给用户（格式见下方 Display Templates）
2. 用户选择后，**main workflow 直接 Edit** `core.json`:
   ```
   Edit core.json:
   - "writingAngle.thesis": "[选中的 thesis]"
   - "writingAngle.stance": "[对应的 stance]"
   - "writingAngle.pending": false
   - 如果深度不匹配: "writingAngle.depthMismatchAcknowledged": true
   ```
3. 信息型文章跳过此步骤（`pending` 已为 false）

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

| 受众 | 预选深度 |
|-----|---------|
| DIY初学者/家庭手工者 | 入门基础 |
| 爱好者/小型卖家 | 进阶技巧 |
| 工程师/技术人员 | 技术细节 |
| 生产经理/采购人员 | 概述 |

### 文章类型→角度要求

| 类型 | 角度要求 |
|------|----------|
| 观点型 | 必须选 |
| 教程型 | 可选 |
| 信息型 | 跳过 |
| 对比型 | 可选 |

### 人设→场景匹配

| 人设 | 适合深度 | 适合类型 | 适合受众 |
|-----|---------|---------|---------|
| 技术专家 | 技术细节/专家级 | 观点/信息 | 工程师/技术人员 |
| 实践导师 | 入门/进阶 | 教程/信息 | 初学者/爱好者 |
| 行业观察者 | 概述/进阶 | 对比/观点 | 经理/采购 |

---

## Config Files

Schema: @.claude/data/workflow-state-schema.md

**core.json** (config-creator → all agents):
- `articleType`: opinion/tutorial/informational/comparison
- `writingAngle.thesis`: The ONE claim (null until Step 3)
- `writingAngle.stance`: challenge/confirm/nuance
- `authorPersona.role/bias`: WHO writes, with what perspective

**research.json** (web-researcher → outline-writer, proofreader):
- `recommendedTheses` → Step 3 角度选择
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

展示选项时的格式模板。直接在对话中输出，不使用 AskUserQuestion 工具。

### 意图不匹配提示

```
⚠️ 意图不匹配提示

该主题的典型搜索者是 [DIY爱好者/消费者]，
但 [公司名] 是 B2B 公司，User Types 针对专业受众设计。

建议选择：
1. 调整目标受众 → 将 "DIY爱好者" 调整为 "小型创业者/小型生产商"
2. 更换主题 → 选择更匹配 B2B 的主题
3. 继续使用通用 B2C 指导 → 文章将缺乏公司特色
```

### 受众 + 深度选项

**格式规则：**
- 基于意图推荐的受众标 `(推荐)`
- 其他选项用 `△ 适合场景:` 说明
- 用户回复数字组合（如 "1, 1"）

**B2B 意图示例：**
```
请选择目标受众：

1. 工程师 (推荐)
   负责工艺设计和参数优化的技术人员
   ✓ 匹配原因：B2B主题，典型搜索者是需要技术规格的专业人员

2. 生产经理
   △ 适合场景：关注效率、成本、产能的决策内容

3. 采购人员
   △ 适合场景：关注供应商选择、性价比的采购指南

请选择内容深度：

1. 技术细节 (推荐)
   ✓ 匹配原因：工程师通常需要可直接应用的技术信息

2. 概述
   △ 适合场景：快速了解新领域，或作为决策参考
```

### 文章类型选项

```
请选择文章类型：

1. 对比型 (推荐)
   ✓ 匹配原因：主题 "A vs B" 天然适合对比分析

2. 观点型
   △ 适合场景：想要挑战某个常见误区或强调某个被忽视的要点

3. 信息型
   △ 适合场景：纯粹的知识科普，不需要表达立场

4. 教程型
   △ 适合场景：主题是 "how to" 类型
```

### 作者人设选项

从公司 about-us.md Part 5 读取预设：

```
请选择作者人设：

1. 技术专家 (推荐)
   "热处理车间主任，15年一线经验"
   ✓ 匹配原因：观点型文章需要实践权威，技术细节深度需要专业背景

2. 实践导师
   △ 适合场景：教程型文章、入门深度

3. 行业观察者
   △ 适合场景：对比型文章、采购决策者
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
