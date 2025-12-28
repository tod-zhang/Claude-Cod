
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

SEO article writing workflow. Creates high-quality, well-researched articles through a 4-step process using context-isolated agents.

## Architecture: Agents with State Passing

| Step | Agent | Context in Main | State Passed |
|------|-------|-----------------|--------------|
| 1 | `config-creator` | ~150 tokens | Creates config |
| 2 | `web-researcher` | ~200 tokens | → workflowState.research |
| 3 | `outline-writer` | ~250 tokens | → workflowState.writing |
| 4 | `proofreader` | ~300 tokens | Reads both states |
| **Total** | | **~900 tokens** | |

**No skills.** Agents are called directly via Task tool.

## Directory Structure

```
.claude/
├── agents/           # 4 agent definitions
│   ├── config-creator.md
│   ├── web-researcher.md
│   ├── outline-writer.md
│   └── proofreader.md
└── data/
    ├── companies/    # Company about-us.md and internal-links.md
    └── style/        # STYLE_GUIDE.md and STYLE_EXAMPLES.md
```

## Language Protocol

- **Tool/Model interactions**: English
- **User interactions**: 中文
- **Article output**: semrush → 中文, others → English

---

## Workflow

When user provides a topic (e.g., "帮我写一篇关于 steel heat treatment 的文章"):

### Step 1: Collect Inputs & Create Config

**分步收集用户输入（不要一次性询问所有选项）：**

#### Step 1a: 选择公司

1. **读取所有公司目录**: `.claude/data/companies/*/`
2. **读取每个公司的 about-us.md**: 检查是否已有 `## Summary` 缓存描述
3. **处理描述**:
   - 如已有 `## Summary` → 直接使用
   - 如没有 → 生成详细描述（主营业务、核心产品/服务、目标市场），并追加到 about-us.md 末尾：
     ```markdown
     ## Summary
     [详细描述]
     ```

**展示格式：**
```
可选公司：
- semrush - SEO和数字营销工具平台，提供关键词研究、竞品分析、网站审计等服务
- mpmc-group - 移动电源和发电机组制造商，专注柴油/燃气发电机、储能系统，服务全球市场
- apextray - 电缆桥架系统供应商，产品涵盖梯式、槽式、网格式桥架，面向工业和商业项目
...
```

```
AskUserQuestion: 选择公司
Options: [公司名] - [详细描述]
```

#### Step 1b: 分析并提供后续选项
用户选择公司后：
1. **读取公司文档**: `.claude/data/companies/[company]/about-us.md`
2. **分析搜索意图**: 结合题目理解用户搜索目的
3. **基于以上信息**，使用 AskUserQuestion 提供后续选项：

| # | Question | Options | 如何生成 |
|---|----------|---------|----------|
| 1 | Audience | beginner / intermediate / practitioner / expert | 根据公司定位和搜索意图推荐 |
| 2 | Depth | 入门科普 / 实用指南 / 深度技术 | 根据搜索意图推荐 |
| 3 | Writing Angle | 3-4个角度 | 结合公司优势和搜索意图生成 |

**Tips:**
- 分析搜索意图后，为每个选项添加 "(推荐)" 标记
- Language: semrush → 中文, others → English
- 写作角度应体现公司的独特优势和专业领域

**Then launch agent:**
```
Task: subagent_type="config-creator"
Prompt: Create config for [company], [topic], [audience], [depth], [angle], [language]
```

### Step 2: Research (Auto)

```
Task: subagent_type="web-researcher"
Prompt: Conduct research for: [topic-title]
```

Agent writes `knowledge/[topic-title]-sources.md` and updates config with `workflowState.research`.

### Step 3: Write (Auto)

```
Task: subagent_type="outline-writer"
Prompt: Create outline and write article for: [topic-title]
```

Agent writes `outline/[topic-title].md`, `drafts/[topic-title].md`, and updates config with `workflowState.writing`.

### Step 4: Proofread & Deliver (Auto)

```
Task: subagent_type="proofreader"
Prompt: Proofread and deliver article for: [topic-title]
```

Agent writes to `output/`:
- `[topic-title].md` - Final article
- `[topic-title]-sources.md` - Source citations
- `[topic-title]-images.md` - Image plan

---

## workflowState

Agents pass decisions via config file. Each agent adds to workflowState:

```json
{
  "workflowState": {
    "research": {
      "status": "completed",
      "summary": { "sourceCount": X, "dataPointCount": X, "competitorCount": X },
      "competitorAnalysis": {
        "stances": { "consensus": [...], "implicitAssumptions": [...] },
        "dataSourcing": { "strongSources": [...], "weakClaims": [...] },
        "terminology": { "standardTerms": {...}, "readerExpectations": "..." }
      },
      "insights": { "goldenInsights": [...], "quality": "high/medium/limited", "suggestedHook": "..." },
      "differentiation": {
        "score": "strong/moderate/weak",
        "primaryDifferentiator": "...",
        "irreplicableInsights": [...],
        "avoidList": [...]
      },
      "writingAdvice": { "emphasize": [...], "cautious": [...], "differentiateWith": [...] },
      "userVoices": { "audienceMatch": "...", "terminologyMap": [...], "quotableVoices": [...] },
      "visualStrategy": { "requiredVisuals": [...], "differentiationOpportunity": "..." },
      "authorityStrategy": { "sourcesFound": { "tier1_academic": [...], "tier4_practitioners": [...] } }
    },
    "writing": {
      "status": "completed",
      "outline": { "h2Count": X, "structure": [...] },
      "decisions": {
        "hookUsed": { "type": "...", "content": "..." },
        "differentiationApplied": { "primaryDifferentiatorUsed": "...", "irreplicableInsightsUsed": [...] },
        "sectionsToWatch": { "strong": [...], "weak": [...], "differentiated": [...] },
        "visualPlan": { "imagesNeeded": [...], "markdownTablesUsed": [...] },
        "productMentions": { "used": [...], "count": X }
      }
    }
  }
}
```

**Key fields for downstream agents:**
- `research.differentiation` → outline-writer uses for title & content differentiation
- `research.writingAdvice.cautious` → outline-writer uses fuzzy language here
- `writing.decisions.sectionsToWatch.weak` → proofreader focuses verification here
- `writing.decisions.visualPlan.markdownTablesUsed` → proofreader skips image generation for these

---

## File Flow

```
config/[topic-title].json           ← Step 1, updated by Steps 2-3
knowledge/[topic-title]-sources.md  ← Step 2
outline/[topic-title].md            ← Step 3
drafts/[topic-title].md             ← Step 3
output/[topic-title].md             ← Step 4
output/[topic-title]-sources.md     ← Step 4
output/[topic-title]-images.md      ← Step 4
```

## Completion Checklist

Workflow complete when all 7 files exist. If `output/` missing → run Step 4.

## Naming Convention

Use **kebab-case**: `steel-heat-treatment`, `pvc-conduit-fill-chart`

