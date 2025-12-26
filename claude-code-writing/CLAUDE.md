
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

**Before launching agent, collect 4 inputs using AskUserQuestion:**

| # | Question | Options |
|---|----------|---------|
| 1 | Company | List from `.claude/data/companies/*/` |
| 2 | Audience | beginner / intermediate / practitioner / expert |
| 3 | Depth | 入门科普 / 实用指南 / 深度技术 |
| 4 | Writing Angle | Generate 3-4 topic-specific angles |

**Tips:**
- Analyze search intent first, add "(推荐)" to best options
- Language: semrush → 中文, others → English
- Topic from user's message

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

Agents pass decisions via config file:

```json
{
  "workflowState": {
    "research": {
      "insights": { "goldenInsights": [...], "suggestedHook": "..." },
      "writingAdvice": { "emphasize": [...], "cautious": [...] }
    },
    "writing": {
      "decisions": {
        "hookUsed": {...},
        "sectionsToWatch": { "strong": [...], "weak": [...] }
      }
    }
  }
}
```

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

