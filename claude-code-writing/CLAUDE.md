
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
     - B2C: Hobbyist / Home user / Small seller / Craft enthusiast
     - B2B: Engineer / Production manager / Procurement / Technical staff
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
6. **基于意图类型生成 Audience/Depth 选项**:
   - **B2C意图** → 选项应为消费者视角：
     ```
     Audience: Hobbyist / Small seller / Home crafter / DIY beginner
     Depth: Step-by-step basics / Intermediate techniques / Advanced methods
     ```
   - **B2B意图** → 选项应为专业视角：
     ```
     Audience: Engineer / Production manager / Procurement / Technical staff
     Depth: Overview / Technical details / Expert-level specifications
     ```
   - **混合意图** → 先让用户选择目标受众类型，再细化
7. **AskUserQuestion**: Audience / Depth（带推荐标记，选项匹配意图类型）
8. **AskUserQuestion**: 文章类型
   ```
   文章类型:
   1. 观点型 — 有明确立场，证明某个观点（需要选角度）
   2. 教程型 — 教读者如何完成某事（角度可选）
   3. 信息型 — 客观介绍概念/事物（无需角度）
   4. 对比型 — 比较多个选项的优劣（角度可选）
   ```

   | 类型 | 角度要求 | 说明 |
   |------|----------|------|
   | 观点型 | 必须选 | 文章核心就是证明这个观点 |
   | 教程型 | 可选 | 可以有"最简单/最可靠"等弱角度 |
   | 信息型 | 跳过 | 客观全面即可 |
   | 对比型 | 可选 | 可以有倾向，也可以中立 |

9. **[条件] 生成写作角度（仅观点型必须，教程/对比型可选，信息型跳过）**:
   - **Writing Angle (Thesis)**: 基于【主题 + 搜索意图类型 + 已选受众】生成 3 个有立场的角度
     - ⚠️ **不受公司背景影响** — 角度应匹配搜索者的关注点
     - B2C 主题 → 生成消费者视角的角度（如 DIY 技巧、成本节省、美观度）
     - B2B 主题 → 生成专业视角的角度（如 效率优化、技术规格、成本控制）
   - **每个标注最佳深度**：
     - ❌ 模糊: "实用指南"
     - ✅ 具体 + 标注: "大多数热处理失败是因为忽略了预热步骤 [适合: Beginner/Intermediate]"
   - **标注规则**:
     - `[适合: Beginner]` - 可用简单案例/类比论证
     - `[适合: Intermediate]` - 需要一定技术背景
     - `[适合: Expert]` - 需要深度技术分析支撑
     - `[适合: All]` - 灵活度高，任何深度都可论证
   - **展示格式示例**:
     ```
     请选择写作角度：
     1. 预热步骤是被低估的关键环节 [适合: Beginner/Intermediate]
        → stance: challenge, 可用简单案例论证
     2. 传统温度曲线计算存在系统误差 [适合: Expert]
        → stance: challenge, 需要技术分析支撑
     3. 热处理成功率取决于设备维护而非工艺参数 [适合: All]
        → stance: nuance, 灵活度高
     4. ⏳ 研究后再选 — 不熟悉话题时推荐，让 web-researcher 基于数据推荐角度
     ```
   - **选择"研究后再选"时**:
     - 设置 `writingAngle.deferred: true`
     - web-researcher 完成后会生成 3 个基于数据的角度推荐
     - 主流程在 Step 2 后暂停，等用户选择角度
     - 然后继续 Step 3

10. **⚠️ 深度兼容性检查（软提示，非阻断，仅当选择了具体角度时）**:
   ```
   if thesis.recommendedDepth != selectedDepth:
       提示: "您选择的角度通常适合 [X] 深度，当前选择 [Y]。
             outline-writer 会调整论证方式来适配，继续吗？"
       选项: [继续（记录 mismatch）/ 调整深度 / 换角度]
   ```
   - 用户选择"继续"时，设置 `depthMismatchAcknowledged: true`
   - 此信号传递给 outline-writer，提示需要调整论证策略

11. **选择作者人设**: 从公司 `about-us.md` Part 5 预设中选择
   - Persona 1: 技术专家 → 深度技术文章
   - Persona 2: 实践导师 → 入门指南、教程
   - Persona 3: 行业观察者 → 趋势分析、对比
   - 自定义 → 用户自行定义

12. **⚠️ 确定输出语言（必须执行，不可跳过）**:
    ```
    if company == "semrush":
        language = "中文"
    else:
        language = "English"
    ```
    **注意**: 无论用户用什么语言提供主题，输出语言只由公司决定。
13. **Launch agent**:
    ```
    Task: subagent_type="config-creator"
    Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [thesis], [persona], [language]
            Article type: [opinion/tutorial/informational/comparison]
            Thesis: [thesis or "deferred"]
            Thesis recommended depth: [recommendedDepth or null]
            Depth mismatch acknowledged: [true/false]
    ```
14. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

### Step 2: Research (Auto)

```
Task: subagent_type="web-researcher"
Prompt: Conduct research for: [topic-title]
```

Agent writes `knowledge/[topic-title]-sources.md` and updates config with `workflowState.research`.

**⚠️ 验证检查点（必须执行）：**
```
Glob: knowledge/[topic-title]-sources.md
```
- ✅ 文件存在 → 继续
- ❌ 文件不存在 → 重新运行 web-researcher

### Step 2.5: Deferred Thesis Selection (仅当 writingAngle.deferred == true)

**如果用户在 Step 1 选择了"研究后再选"：**

1. web-researcher 会在 `workflowState.research.recommendedTheses` 中提供 3 个基于数据的角度推荐
2. **展示推荐角度给用户**:
   ```
   基于研究结果，推荐以下写作角度：
   1. [thesis 1] [适合: X] — 数据支撑: [evidence summary]
   2. [thesis 2] [适合: Y] — 数据支撑: [evidence summary]
   3. [thesis 3] [适合: Z] — 数据支撑: [evidence summary]
   ```
3. **用户选择后**:
   - 更新 config: `writingAngle.thesis`, `writingAngle.stance`, `writingAngle.deferred: false`
   - 执行深度兼容性检查（同 Step 1 的步骤 8）
4. **继续 Step 3**

**如果不是 deferred 模式**：直接继续 Step 3

### Step 3: Write (Auto)

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
- ✅ 两个文件都存在 → 继续 Step 4
- ❌ 任一文件缺失 → 重新运行 outline-writer

### Step 4: Proofread & Deliver (Auto)

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
   - 意图类型：B2C消费者 / B2B专业 / 混合（同 Workflow 1 Step 3）
   - 如果原文意图与主题自然意图不符，向用户确认目标受众
4. **⚠️ 意图-公司匹配检查**（同 Workflow 1 Step 4）:
   - B2C 意图 + B2B 公司 → 提示用户选择：调整受众 / 更换主题 / 使用通用指导
5. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`
6. **基于意图类型生成 Audience/Depth 选项**（同 Workflow 1 Step 6）
7. **AskUserQuestion**: Audience / Depth（显示推荐值，来自分析，选项匹配意图类型）
8. **AskUserQuestion**: 文章类型（同 Workflow 1 Step 8）
   - 显示分析推荐的类型
9. **[条件] 生成写作角度（带深度标注）**: 基于【主题 + 搜索意图类型 + 已选受众 + 诊断】生成 3 个 Thesis 选项
   - ⚠️ **不受公司背景影响** — 同 Workflow 1 Step 9
   - 仅观点型必须，教程/对比型可选，信息型跳过
   - 每个选项标注 `[适合: X]` 和 `[推荐]`（来自分析）
   - 包含"⏳ 研究后再选"选项
10. **⚠️ 深度兼容性检查**: 同 Workflow 1 Step 10（软提示，非阻断，仅当选择了具体角度时）
11. **选择作者人设**: 从公司 Part 5 预设中选择
12. **⚠️ 确定输出语言（必须执行，不可跳过）**:
    ```
    if company == "semrush":
        language = "中文"
    else:
        language = "English"
    ```
13. **Launch agent**:
    ```
    Task: subagent_type="config-creator"
    Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [thesis], [persona], [language]
            Optimization mode: true, analysis file: imports/[topic-title]-analysis.md
            Article type: [opinion/tutorial/informational/comparison]
            Thesis: [thesis or "deferred"]
            Thesis recommended depth: [recommendedDepth or null]
            Depth mismatch acknowledged: [true/false]
    ```
14. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

### Step 2-4: 同 Workflow 1

- **Step 2**: web-researcher (会读取旧数据点，验证/更新)
- **Step 3**: outline-writer (参考旧结构，完全重写)
- **Step 4**: proofreader (验证并交付到 output/)

### Workflow 2 文件流

```
imports/[topic-title]-analysis.md   ← Step 0 (分析结果)
config/[topic-title].json           ← Step 1 (带 optimization.enabled: true)
knowledge/[topic-title]-sources.md  ← Step 2
outline/[topic-title].md            ← Step 3
drafts/[topic-title].md             ← Step 3
output/[topic-title].md             ← Step 4
output/[topic-title]-sources.md     ← Step 4
output/[topic-title]-images.md      ← Step 4
```

---

## workflowState

Agents pass decisions via config file. Full schema: @.claude/data/workflow-state-schema.md

**Core Identity Fields (in config root):**

| Field | Set By | Purpose |
|-------|--------|---------|
| `articleType` | config-creator | opinion/tutorial/informational/comparison |
| `writingAngle.thesis` | config-creator | The ONE claim article proves (null for informational) |
| `writingAngle.stance` | config-creator | challenge/confirm/nuance (null for informational) |
| `writingAngle.deferred` | config-creator | true = 研究后再选角度 |
| `writingAngle.recommendedDepth` | config-creator | Thesis 最佳深度 (beginner/intermediate/expert/all) |
| `writingAngle.depthMismatchAcknowledged` | config-creator | 用户确认了深度不匹配 |
| `authorPersona.role` | config-creator | WHO is writing |
| `authorPersona.bias` | config-creator | Non-neutral perspective |

**Key fields for downstream agents:**

| Field | Used By | Purpose |
|-------|---------|---------|
| `articleType` | all agents | 决定是否需要 thesis 验证 |
| `writingAngle.deferred` | web-researcher | 需要生成角度推荐 |
| `writingAngle.depthMismatchAcknowledged` | outline-writer | 需要调整论证策略 |
| `research.recommendedTheses` | main (Step 2.5) | Deferred 模式下的角度推荐 |
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
config/[topic-title].json           ← Step 1, updated by Steps 2-3
knowledge/[topic-title]-sources.md  ← Step 2
outline/[topic-title].md            ← Step 3
drafts/[topic-title].md             ← Step 3
output/[topic-title].md             ← Step 4
output/[topic-title]-sources.md     ← Step 4
output/[topic-title]-images.md      ← Step 4
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

