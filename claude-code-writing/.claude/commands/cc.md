---
description: 清理所有工作流文件（跨平台）
allowed-tools: Bash(*)
---

清理 config、drafts、knowledge、outline、output 文件夹中的所有工作流文件。

根据当前操作系统执行清理：
- Windows: 使用 `Remove-Item` 或 `del`
- macOS/Linux: 使用 `rm`

请删除以下文件：
- config/*.json
- config/*.tmp
- drafts/*.md
- knowledge/*.md
- outline/*.md
- output/*.md
- imports/*.md

同时清理临时文件：
- **/*.tmp
- **/*.bak
- **/*~

执行完成后报告清理结果。
