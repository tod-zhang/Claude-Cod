
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
3. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`
4. **分析搜索意图** → 为后续选项生成推荐
5. **AskUserQuestion**: Audience / Depth（带推荐标记）
6. **生成写作角度，选择作者人设**:
   - **Writing Angle (Thesis)**: 基于主题生成 3 个有立场的角度供用户选择
     - ❌ 模糊: "实用指南"
     - ✅ 具体: "大多数热处理失败是因为忽略了预热步骤"
   - **Author Persona**: 从公司 `about-us.md` Part 5 预设中选择
     - Persona 1: 技术专家 → 深度技术文章
     - Persona 2: 实践导师 → 入门指南、教程
     - Persona 3: 行业观察者 → 趋势分析、对比
     - 自定义 → 用户自行定义
7. **Launch agent**:
   ```
   Task: subagent_type="config-creator"
   Prompt: Create config for [company], [topic], [audience], [depth], [thesis], [persona], [language]
   ```
8. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

**Tips:** Language: semrush → 中文, others → English

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
- ✅ 文件存在 → 继续 Step 3
- ❌ 文件不存在 → 重新运行 web-researcher 或手动从 config.workflowState.research 提取内容写入文件

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

**触发**: 用户提供 URL (e.g., "优化这个 URL: https://example.com/article")

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
3. **AskUserQuestion**: Audience / Depth（显示推荐值，来自分析）
4. **生成写作角度**: 基于诊断生成 3 个 Thesis 选项（标注推荐）
5. **选择作者人设**: 从公司 Part 5 预设中选择
6. **Launch agent**:
   ```
   Task: subagent_type="config-creator"
   Prompt: Create config for [company], [topic], [audience], [depth], [thesis], [persona], [language]
           Optimization mode: true, analysis file: imports/[topic-title]-analysis.md
   ```
7. **✅ 验证**: `Glob config/[topic-title].json` 存在 → 继续

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
| `writingAngle.thesis` | config-creator | The ONE claim article proves |
| `writingAngle.stance` | config-creator | challenge/confirm/nuance |
| `authorPersona.role` | config-creator | WHO is writing |
| `authorPersona.bias` | config-creator | Non-neutral perspective |

**Key fields for downstream agents:**

| Field | Used By | Purpose |
|-------|---------|---------|
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

