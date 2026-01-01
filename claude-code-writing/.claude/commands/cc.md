---
description: 清理所有工作流文件（跨平台）
allowed-tools: Bash(*)
---

清理工作流文件夹。使用 `find` 命令（避免 zsh glob 问题）：

```bash
cd "/Users/todd/Library/CloudStorage/OneDrive-个人/Claude Code/claude-code-writing" && \
find config -maxdepth 1 -type f \( -name "*.json" -o -name "*.tmp" \) -delete 2>/dev/null; \
find drafts -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null; \
find knowledge -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null; \
find outline -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null; \
find output -maxdepth 1 -type f -name "*.md" -delete 2>/dev/null; \
find imports -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null; \
find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*~" \) -delete 2>/dev/null; \
echo "清理完成"
```

执行上述命令，然后报告结果。
