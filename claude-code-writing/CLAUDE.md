
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

SEO article writing workflows with two modes:
1. **新文章写作** - Create new articles from scratch
2. **旧文章优化** - Optimize existing articles from URL

Both use context-isolated agents with state passing.

## Architecture: Agents with State Passing

| Agent | Used In | Context in Main | State Passed |
|-------|---------|-----------------|--------------|
| `article-importer` | Workflow 2 only | ~150 tokens | → imports/ analysis |
| `config-creator` | Both | ~150 tokens | Creates config |
| `web-researcher` | Both | ~200 tokens | → workflowState.research |
| `outline-writer` | Both | ~250 tokens | → workflowState.writing |
| `proofreader` | Both | ~300 tokens | Reads all states |

**No skills.** Agents are called directly via Task tool.

## Directory Structure

```
.claude/
├── agents/           # 5 agent definitions
│   ├── article-importer.md   # Workflow 2: 导入分析
│   ├── config-creator.md
│   ├── web-researcher.md
│   ├── outline-writer.md
│   └── proofreader.md
└── data/
    ├── companies/    # Company about-us.md and internal-links.md
    │   └── index.md  # 公司索引（必须同步更新）
    └── style/        # STYLE_GUIDE.md and STYLE_EXAMPLES.md

imports/              # Workflow 2: 旧文章分析结果
```

**规则：创建新公司 `about-us.md` 时，必须同步更新 `index.md`**

## Language Protocol

- **Tool/Model interactions**: English
- **User interactions**: 中文
- **Article output**: semrush → 中文, others → English

---

## Workflow 1: 新文章写作

**触发**: 用户提供主题 (e.g., "帮我写一篇关于 steel heat treatment 的文章")

### Step 1: Collect Inputs & Create Config

1. **展示公司列表**: `Read .claude/data/companies/index.md` → 展示所有公司名称和描述（列表形式，不是选项）
2. **等待用户输入**: 用户直接告诉你公司名
3. **⚠️ 分析搜索意图（独立于公司，必须先执行）**:
   - **意图类型识别**（基于主题关键词，不受公司背景影响）：
     ```
     B2C消费者: DIY教程、家用指南、个人使用
     B2B专业: 工业应用、生产线、技术规格、采购决策
     混合: 两种意图都有搜索量
     ```
   - **典型搜索者画像**：
     - B2C: 爱好者 / 家庭用户 / 小型卖家 / 手工爱好者
     - B2B: 工程师 / 生产经理 / 采购人员 / 技术人员
     - 混合: 需列出两类受众
   - **示例**：
     | 主题 | 意图类型 | 典型搜索者 |
     |------|----------|------------|
     | how to wrap soap | B2C | DIY爱好者、手工皂卖家 |
     | soap packaging machine | B2B | 工厂采购、生产经理 |
     | soap packaging | 混合 | 两者都有 |

4. **⚠️ 意图-公司匹配检查**:
   - 大多数公司是 B2B 定位，其 User Types 针对专业受众设计
   - **匹配规则**：
     | 意图类型 | B2B 公司 | 处理方式 |
     |----------|----------|----------|
     | B2B | ✅ 匹配 | 正常继续 |
     | B2C | ⚠️ 不匹配 | 提示 + 建议调整 |
     | Mixed | 🔄 部分匹配 | 让用户选择目标受众类型 |

   - **B2C 意图 + B2B 公司时，提示用户**：
     ```
     ⚠️ 意图不匹配提示

     该主题的典型搜索者是 [DIY爱好者/消费者]，
     但 [公司名] 是 B2B 公司，User Types 针对专业受众设计。

     建议选择：
     1. 调整目标受众 → 将 "DIY爱好者" 调整为 "小型创业者/小型生产商"
        （使用公司 User Type 1，文章可衔接公司产品）
     2. 更换主题 → 选择更匹配 B2B 的主题
     3. 继续使用通用 B2C 指导 → 文章将缺乏公司特色（产品提及、内链等不适用）
     ```
   - 用户选择后记录：`intentMismatchResolution: adjusted | changed_topic | generic_b2c`

5. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`
6. **基于意图类型生成受众/深度选项**:
   - **受众→深度预选映射**：
     | 受众 | 预选深度 | 受众说明 |
     |-----|---------|---------|
     | DIY初学者 | 入门基础 | 刚接触该领域，需要基础指导 |
     | 家庭手工者 | 入门基础 | 家庭环境操作，关注安全和简单性 |
     | 爱好者 | 进阶技巧 | 有基础经验，想提升技能 |
     | 小型卖家 | 进阶技巧 | 小规模生产，关注效率和质量 |
     | 工程师 | 技术细节 | 负责工艺设计，需要参数和规格 |
     | 技术人员 | 技术细节 | 一线操作维护，需要实操指导 |
     | 生产经理 | 概述 | 管理决策层，关注效率和成本 |
     | 采购人员 | 概述 | 商务采购，关注选型和性价比 |
   - **深度说明**：
     | 深度 | 内容特点 |
     |-----|---------|
     | 入门基础 | 基本概念、简单步骤、常见问题解答 |
     | 进阶技巧 | 优化方法、效率提升、质量控制 |
     | 概述 | 核心原理、适用场景、决策要点 |
     | 技术细节 | 具体参数、操作规范、故障排除 |
     | 专家级规格 | 标准引用、研究数据、深度分析 |
   - **混合意图** → 先让用户选择目标受众类型，再细化
7. **直接展示选项，等待用户回复**: 受众 + 深度（一次询问两个字段）
   - **不使用 AskUserQuestion 工具**，直接在对话中输出完整格式的选项
   - **受众推荐逻辑**：基于搜索意图类型，典型搜索者标记 `(推荐)`
   - **深度预选**：用户选受众后自动预选，可修改
   - **用户回复格式**：数字组合（如 "1, 1" 表示第一个受众 + 第一个深度）
   - **展示格式（B2B意图示例）**：
     ```
     请选择目标受众：

     1. 工程师 (推荐)
        负责工艺设计和参数优化的技术人员
        ✓ 匹配原因：B2B主题，典型搜索者是需要技术规格的专业人员

     2. 生产经理
        负责生产计划和质量控制的管理人员
        △ 适合场景：关注效率、成本、产能的决策内容

     3. 采购人员
        负责设备或材料采购的商务人员
        △ 适合场景：关注供应商选择、性价比的采购指南

     4. 技术人员
        一线操作和设备维护人员
        △ 适合场景：关注操作规范、故障排除的实操内容

     请选择内容深度：

     1. 技术细节 (推荐)
        详细的工艺参数、操作步骤、故障排除指南
        ✓ 匹配原因：工程师通常需要可直接应用的技术信息

     2. 概述
        核心概念、基本原理、适用场景介绍
        △ 适合场景：快速了解新领域，或作为决策参考

     3. 专家级规格
        深度工程分析、标准引用、研究数据对比
        △ 适合场景：需要权威依据的技术论证或规格制定
     ```
8. **直接展示选项，等待用户回复**: 文章类型
   - **不使用 AskUserQuestion 工具**，直接在对话中输出完整格式
   - **展示格式**：
     ```
     请选择文章类型：

     1. 对比型 (推荐)
        比较多个选项的优劣，帮助读者做出选择
        ✓ 匹配原因：主题 "A vs B" 天然适合对比分析

     2. 观点型
        有明确立场，证明某个观点（需要选角度）
        △ 适合场景：想要挑战某个常见误区或强调某个被忽视的要点

     3. 信息型
        客观介绍概念/事物（无需角度）
        △ 适合场景：纯粹的知识科普，不需要表达立场

     4. 教程型
        教读者如何完成某事（角度可选）
        △ 适合场景：主题是 "how to" 类型
     ```

   | 类型 | 角度要求 | 说明 |
   |------|----------|------|
   | 观点型 | 必须选 | 文章核心就是证明这个观点 |
   | 教程型 | 可选 | 可以有"最简单/最可靠"等弱角度 |
   | 信息型 | 跳过 | 客观全面即可 |
   | 对比型 | 可选 | 可以有倾向，也可以中立 |

9. **直接展示选项，等待用户回复**: 作者人设
   - **不使用 AskUserQuestion 工具**，直接在对话中输出完整格式
   - 从公司 `about-us.md` Part 5 预设中选择，基于已选内容推荐
   - **人设→场景匹配表**：
     | 人设 | 适合深度 | 适合文章类型 | 适合受众 |
     |-----|---------|-------------|---------|
     | 技术专家 | 技术细节/专家级 | 观点型、信息型 | 工程师、技术人员 |
     | 实践导师 | 入门/进阶 | 教程型、信息型 | 初学者、爱好者 |
     | 行业观察者 | 概述/进阶 | 对比型、观点型 | 经理、采购人员 |
   - **展示格式**：
     ```
     请选择作者人设：

     1. 技术专家 (推荐)
        "热处理车间主任，15年一线经验"
        ✓ 匹配原因：观点型文章需要实践权威，技术细节深度需要专业背景

     2. 实践导师
        "资深工艺培训师，专注新人带教"
        △ 适合场景：教程型文章、入门深度

     3. 行业观察者
        "设备选型顾问，跨厂经验丰富"
        △ 适合场景：对比型文章、采购决策者

     4. 自定义
     ```
   - **推荐逻辑**：匹配度最高的人设标记 `(推荐)`，其他人设显示适合场景供参考

10. **⚠️ 确定输出语言（必须执行，不可跳过）**:
    ```
    if company == "semrush":
        language = "中文"
    else:
        language = "English"
    ```
    **注意**: 无论用户用什么语言提供主题，输出语言只由公司决定。
11. **Launch agent**:
    ```
    Task: subagent_type="config-creator"
    Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [persona], [language]
            Article type: [opinion/tutorial/informational/comparison]
            Note: Thesis will be selected after competitor analysis in Step 3
    ```
12. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

### Step 2: Competitor Analysis（竞品分析）

```
Task: subagent_type="web-researcher"
Prompt: Phase 1 - Competitor Analysis for: [topic-title]
        Analyze TOP 10 search results, identify differentiation opportunities
```

**目标**：快速扫描竞品，找差异化机会，生成角度推荐

**Agent 输出**：
- 更新 config `workflowState.research.competitorAnalysis`
- 更新 config `workflowState.research.recommendedTheses`（3 个推荐角度）

**⚠️ 验证检查点（必须执行）：**
- ✅ config 中有 `recommendedTheses` → 继续 Step 3
- ❌ 缺失 → 重新运行 web-researcher Phase 1

### Step 3: Select Writing Angle（选择写作角度）

**直接展示选项，等待用户回复**（信息型文章可跳过）：
- **不使用 AskUserQuestion 工具**，直接在对话中输出完整格式的选项

1. **读取 config 中的 `recommendedTheses`**
2. **⚠️ 翻译展示内容**（用户交互必须用中文）：
   - **thesis 标题**：翻译成中文
   - **stance**：使用中文术语
     | 英文 | 中文 |
     |-----|------|
     | challenge | 挑战型 |
     | confirm | 强化型 |
     | nuance | 细化型 |
   - **recommendedDepth**：使用中文术语
     | 英文 | 中文 |
     |-----|------|
     | beginner | 入门 |
     | intermediate | 进阶 |
     | expert | 专家级 |
     | all | 通用 |
   - **evidenceSummary**：翻译成中文
3. **角度属性说明**：
   | 属性 | 说明 |
   |-----|------|
   | 挑战型 | 挑战常见观点，"大多数人错了" |
   | 强化型 | 强化已知观点，提供新证据 |
   | 细化型 | 添加复杂性，"视情况而定" |
   | 适合深度 | 该角度需要什么深度才能充分论证 |
4. **展示推荐角度给用户**（格式与受众/深度/人设统一）：
   ```
   基于竞品分析，推荐以下写作角度：

   1. 预热步骤是被低估的关键环节 (推荐)
      立场: 挑战型 | 适合深度: 入门/进阶
      挑战"直接加热"的常见做法，用失败案例论证预热重要性
      ✓ 匹配原因：差异化强（TOP 10 仅 2 篇提及），数据充足（3个案例），
        深度兼容

   2. 温度控制比时间控制更重要
      立场: 细化型 | 适合深度: 技术细节
      平衡两种控制方式的优劣，给出场景化建议
      △ 匹配度：差异化中等，深度匹配，需参数数据支撑

   3. 传统温度曲线计算存在系统误差
      立场: 挑战型 | 适合深度: 专家级
      质疑教科书公式，引用最新研究数据
      ⚠️ 注意：深度不匹配（需专家级，已选技术细节），差异化强但数据要求高

   4. 自定义角度
      输入你自己的写作角度
   ```
5. **匹配度标记规则**：
   | 标记 | 条件 |
   |-----|------|
   | ✓ 匹配原因 | 差异化强 + 数据充足 + 深度兼容 |
   | △ 匹配度 | 部分匹配（差异化中等，或需要额外数据） |
   | ⚠️ 注意 | 深度不匹配，或数据要求高 |
6. **用户选择后**：
   - 更新 config: `writingAngle.thesis`, `writingAngle.stance`
   - 如果选择了 ⚠️ 标记的角度，确认是否继续
   - 设置 `depthMismatchAcknowledged: true`（如适用）
7. **信息型文章**：跳过角度选择，设置 `writingAngle.thesis: null`

### Step 4: Evidence Collection（证据搜索）

```
Task: subagent_type="web-researcher"
Prompt: Phase 2 - Evidence Collection for: [topic-title]
        Selected angle: [thesis]
        Collect data points, expert quotes, case studies to support the thesis
```

**目标**：针对已选角度，深入搜索证据和素材

**Agent 输出**：
- 写入 `knowledge/[topic-title]-sources.md`
- 更新 config `workflowState.research`（完整研究数据）

**⚠️ 验证检查点（必须执行）：**
```
Glob: knowledge/[topic-title]-sources.md
```
- ✅ 文件存在 → 继续 Step 5
- ❌ 文件不存在 → 重新运行 web-researcher Phase 2

### Step 5: Write（写作）

```
Task: subagent_type="outline-writer"
Prompt: Create outline and write article for: [topic-title]
```

Agent writes `outline/[topic-title].md`, `drafts/[topic-title].md`, and updates config with `workflowState.writing`.

**⚠️ 验证检查点（必须执行）：**
```
Glob: outline/[topic-title].md
Glob: drafts/[topic-title].md
```
- ✅ 两个文件都存在 → 继续 Step 6
- ❌ 任一文件缺失 → 重新运行 outline-writer

### Step 6: Proofread & Deliver（校对交付）

```
Task: subagent_type="proofreader"
Prompt: Proofread and deliver article for: [topic-title]
```

Agent writes to `output/`:
- `[topic-title].md` - Final article
- `[topic-title]-sources.md` - Source citations
- `[topic-title]-images.md` - Image plan

**⚠️ 验证检查点（必须执行）：**
```
Glob: output/[topic-title].md
Glob: output/[topic-title]-sources.md
Glob: output/[topic-title]-images.md
```
- ✅ 三个文件都存在 → 流程完成，向用户报告
- ❌ 任一文件缺失 → 重新运行 proofreader

---

## Workflow 2: 旧文章优化

**触发**: 用户说 "优化" + URL (e.g., "优化: https://example.com/article")

### Step 0: 导入分析

1. **Launch agent**:
   ```
   Task: subagent_type="article-importer"
   Prompt: Import and analyze article from: [URL]
   ```

2. **展示诊断摘要**:
   - 原文信息（标题、字数、结构）
   - 问题诊断（严重/重要/轻微）
   - 推荐设置（受众、深度、Thesis）

3. **✅ 验证**: `Glob imports/[topic-title]-analysis.md` 存在 → 继续

### Step 1: Collect Inputs & Create Config (带预填推荐)

1. **展示公司列表**: `Read .claude/data/companies/index.md`
2. **等待用户输入**: 用户选择公司
3. **⚠️ 分析/验证搜索意图（独立于公司）**:
   - 参考分析文件中的原文受众，但独立判断主题本身的搜索意图
   - 意图类型：B2C消费者 / B2B专业 / 混合（同 Workflow 1 Step 1.3）
   - 如果原文意图与主题自然意图不符，向用户确认目标受众
4. **⚠️ 意图-公司匹配检查**（同 Workflow 1 Step 1.4）
5. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`
6. **基于意图类型生成受众/深度选项**（同 Workflow 1 Step 1.6）
7. **直接展示选项，等待用户回复**: 受众 + 深度（同 Workflow 1 Step 1.7，显示分析推荐值）
8. **直接展示选项，等待用户回复**: 文章类型（同 Workflow 1 Step 1.8）
   - 显示分析推荐的类型
9. **直接展示选项，等待用户回复**: 作者人设（同 Workflow 1 Step 1.9，基于已选内容推荐）
10. **⚠️ 确定输出语言**（同 Workflow 1 Step 1.10）
11. **Launch agent**:
    ```
    Task: subagent_type="config-creator"
    Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [persona], [language]
            Optimization mode: true, analysis file: imports/[topic-title]-analysis.md
            Note: Thesis will be selected after competitor analysis in Step 3
    ```
12. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

### Step 2-6: 同 Workflow 1

- **Step 2**: Competitor Analysis（竞品分析，会参考旧文章的问题诊断）
- **Step 3**: Select Writing Angle（选择写作角度，显示分析推荐）
- **Step 4**: Evidence Collection（证据搜索，会读取旧数据点，验证/更新）
- **Step 5**: Write（outline-writer，参考旧结构，完全重写）
- **Step 6**: Proofread & Deliver（proofreader，验证并交付到 output/）

### Workflow 2 文件流

```
imports/[topic-title]-analysis.md   ← Step 0 (分析结果)
config/[topic-title].json           ← Step 1 (带 optimization.enabled: true)
                                    ← Step 2 更新 config (竞品分析)
                                    ← Step 3 更新 config (角度选择)
knowledge/[topic-title]-sources.md  ← Step 4 (证据搜索)
outline/[topic-title].md            ← Step 5
drafts/[topic-title].md             ← Step 5
output/[topic-title].md             ← Step 6
output/[topic-title]-sources.md     ← Step 6
output/[topic-title]-images.md      ← Step 6
```

---

## workflowState

Agents pass decisions via config file. Full schema: @.claude/data/workflow-state-schema.md

**Core Identity Fields (in config root):**

| Field | Set By | Purpose |
|-------|--------|---------|
| `articleType` | config-creator | opinion/tutorial/informational/comparison |
| `writingAngle.thesis` | main (Step 3) | The ONE claim article proves (null for informational) |
| `writingAngle.stance` | main (Step 3) | challenge/confirm/nuance (null for informational) |
| `writingAngle.recommendedDepth` | web-researcher (Step 2) | Thesis 最佳深度 (beginner/intermediate/expert/all) |
| `writingAngle.depthMismatchAcknowledged` | main (Step 3) | 用户确认了深度不匹配 |
| `authorPersona.role` | config-creator | WHO is writing |
| `authorPersona.bias` | config-creator | Non-neutral perspective |

**Key fields for downstream agents:**

| Field | Used By | Purpose |
|-------|---------|---------|
| `articleType` | all agents | 决定是否需要 thesis 验证 |
| `research.competitorAnalysis` | main (Step 3) | 竞品分析结果，用于生成角度选项 |
| `research.recommendedTheses` | main (Step 3) | 基于竞品分析的角度推荐 |
| `writingAngle.depthMismatchAcknowledged` | outline-writer | 需要调整论证策略 |
| `research.thesisValidation` | outline-writer | Validated/adjusted thesis |
| `research.differentiation.primaryDifferentiator` | outline-writer | Lead with this |
| `research.writingAdvice.cautious` | outline-writer | Use fuzzy language |
| `writing.decisions.thesisExecution` | proofreader | How thesis was stated |
| `writing.decisions.personaExecution` | proofreader | How persona was applied |
| `writing.decisions.sectionsToWatch.weak` | proofreader | Focus verification |
| `writing.decisions.visualPlan.markdownTablesUsed` | proofreader | Skip image generation |

---

## File Flow

**Workflow 1 (新文章):**
```
config/[topic-title].json           ← Step 1 创建, Step 2-3 更新
knowledge/[topic-title]-sources.md  ← Step 4 (证据搜索)
outline/[topic-title].md            ← Step 5 (写作)
drafts/[topic-title].md             ← Step 5 (写作)
output/[topic-title].md             ← Step 6 (校对交付)
output/[topic-title]-sources.md     ← Step 6 (校对交付)
output/[topic-title]-images.md      ← Step 6 (校对交付)
```

**Workflow 2 (优化旧文章):**
```
imports/[topic-title]-analysis.md   ← Step 0 (额外)
+ 同 Workflow 1 的所有文件
```

## Completion Checklist

**Workflow 1**: Complete when 7 files exist in config/, knowledge/, outline/, drafts/, output/.
**Workflow 2**: Complete when 8 files exist (包括 imports/ 分析文件).

## Naming Convention

Use **kebab-case**: `steel-heat-treatment`, `pvc-conduit-fill-chart`

