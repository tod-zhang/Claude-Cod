# SEO 文章写作工作流

基于 Claude Code 的智能 SEO 文章生成系统，通过 4 个专业 Agent 协作，生成高质量、深度研究的专业文章。

## 功能特点

- **智能研究**：自动进行竞品分析、数据收集、差异化定位
- **专业写作**：根据目标受众和搜索意图定制内容
- **质量保障**：多轮校对、事实核查、来源验证
- **多公司支持**：可配置不同公司的品牌风格和内链策略

## 快速开始

### 使用方式

直接告诉 Claude 你想写什么文章：

```
帮我写一篇关于 steel heat treatment 的文章
```

系统会引导你完成以下选择：
1. 选择公司（决定品牌风格和内链）
2. 选择目标受众
3. 选择文章深度
4. 选择写作角度

然后自动完成研究、写作、校对全流程。

### 清理工作流文件

使用内置命令清理所有工作流文件：

```
/cc
```

## 目录结构

```
.
├── .claude/
│   ├── agents/              # Agent 定义
│   │   ├── config-creator.md
│   │   ├── web-researcher.md
│   │   ├── outline-writer.md
│   │   └── proofreader.md
│   ├── commands/            # 自定义命令
│   └── data/
│       ├── companies/       # 公司配置
│       │   ├── index.md     # 公司索引
│       │   └── [company]/   # 各公司目录
│       │       ├── about-us.md
│       │       └── internal-links.md
│       └── style/           # 写作风格指南
│           ├── STYLE_GUIDE.md
│           └── STYLE_EXAMPLES.md
├── config/                  # 文章配置文件
├── knowledge/               # 研究资料
├── outline/                 # 文章大纲
├── drafts/                  # 文章草稿
└── output/                  # 最终输出
```

## 工作流程

### 4 步流程概览

| 步骤 | Agent | 输入 | 输出 |
|------|-------|------|------|
| 1 | config-creator | 用户选择 | `config/[topic].json` |
| 2 | web-researcher | 配置文件 | `knowledge/[topic]-sources.md` |
| 3 | outline-writer | 研究资料 | `outline/[topic].md` + `drafts/[topic].md` |
| 4 | proofreader | 草稿 | `output/` 目录下的最终文件 |

### Step 1: 配置创建

收集用户输入，生成文章配置：
- 公司选择 → 品牌风格、内链策略
- 目标受众 → 内容深度、术语选择
- 文章深度 → 字数范围、覆盖广度
- 写作角度 → 内容框架、差异化方向

### Step 2: 深度研究

自动执行：
- 竞品文章分析
- 数据点收集
- 权威来源查找
- 差异化机会识别
- 用户声音采集

### Step 3: 大纲与写作

基于研究结果：
- 设计文章结构
- 确定差异化策略
- 撰写完整草稿
- 插入内链和产品提及

### Step 4: 校对与交付

最终质量把控：
- 事实核查
- 来源验证
- 风格一致性检查
- 生成图片建议

## 输出文件

完成后在 `output/` 目录生成：

| 文件 | 说明 |
|------|------|
| `[topic].md` | 最终文章 |
| `[topic]-sources.md` | 引用来源列表 |
| `[topic]-images.md` | 配图建议和说明 |

## 添加新公司

1. 在 `.claude/data/companies/` 下创建公司目录
2. 添加 `about-us.md`（公司介绍、产品、品牌声音）
3. 添加 `internal-links.md`（内链策略）
4. 更新 `.claude/data/companies/index.md` 索引

## 语言规则

| 场景 | 语言 |
|------|------|
| 用户交互 | 中文 |
| 文章输出 (semrush) | 中文 |
| 文章输出 (其他公司) | English |

## 命名规范

文件名使用 **kebab-case**：
- `steel-heat-treatment`
- `pvc-conduit-fill-chart`
- `aluminum-alloy-grades`
