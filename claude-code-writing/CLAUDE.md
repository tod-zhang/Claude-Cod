# CLAUDE.md

SEO 文章写作工作流。两种模式：新文章写作、旧文章优化。

## Architecture

| Agent | State Passed |
|-------|--------------|
| `article-importer` | → imports/ (Workflow 2 only) |
| `config-creator` | Creates config |
| `web-researcher` | → workflowState.research |
| `outline-writer` | → workflowState.writing |
| `proofreader` | Reads all, writes output/ |

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
   - B2C 意图 + B2B 公司 → 提示用户（见 @.claude/data/display-templates.md）
   - 混合 → 让用户选择目标受众类型

4. **读取公司文档**: `.claude/data/companies/[selected]/about-us.md`

5. **收集用户选择**（展示格式见 @.claude/data/display-templates.md）:
   - 受众 + 深度（一次询问）
   - 文章类型
   - 作者人设

6. **确定输出语言**: `semrush → 中文, others → English`

7. **Launch config-creator**:
   ```
   Task: subagent_type="config-creator"
   Prompt: Create config for [company], [topic], [audience], [depth], [articleType], [persona], [language]
   ```

8. **验证**: `config/[topic-title].json` 存在

### Step 2: Competitor Analysis

```
Task: subagent_type="web-researcher"
Prompt: Phase 1 - Competitor Analysis for: [topic-title]
```

**输出**: config 更新 `recommendedTheses`

**验证**: config 有 `recommendedTheses`

### Step 3: Select Writing Angle

1. 读取 `recommendedTheses`，翻译展示给用户（格式见 @.claude/data/display-templates.md）
2. 用户选择后更新 config: `writingAngle.thesis`, `writingAngle.stance`
3. 信息型文章跳过此步骤

### Step 4: Evidence Collection

```
Task: subagent_type="web-researcher"
Prompt: Phase 2 - Evidence Collection for: [topic-title], Selected angle: [thesis]
```

**输出**: `knowledge/[topic-title]-sources.md` + config 更新

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

## workflowState

Schema: @.claude/data/workflow-state-schema.md

**Core Identity (config root):**
- `articleType`: opinion/tutorial/informational/comparison
- `writingAngle.thesis`: The ONE claim (null until Step 3)
- `writingAngle.stance`: challenge/confirm/nuance
- `authorPersona.role/bias`: WHO writes, with what perspective

**Key downstream fields:**
- `research.recommendedTheses` → Step 3 角度选择
- `research.thesisValidation` → outline-writer 使用
- `research.writingAdvice.cautious` → 需模糊处理的区域
- `writing.decisions.*` → proofreader 验证

---

## File Flow

```
config/[topic].json           ← Step 1, updated Step 2-3
knowledge/[topic]-sources.md  ← Step 4
outline/[topic].md            ← Step 5
drafts/[topic].md             ← Step 5
output/[topic].md             ← Step 6
output/[topic]-sources.md     ← Step 6
output/[topic]-images.md      ← Step 6
imports/[topic]-analysis.md   ← Workflow 2 Step 0 only
```

**Completion**: Workflow 1 = 7 files, Workflow 2 = 8 files

**Naming**: kebab-case (`steel-heat-treatment`)
