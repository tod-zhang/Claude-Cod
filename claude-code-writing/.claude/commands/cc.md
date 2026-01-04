---
description: 清理所有工作流文件（跨平台）
allowed-tools: Bash(*)
---

清理工作流文件夹（config, drafts, knowledge, outline, output, imports），保留 .gitkeep。

## 执行命令

**win32** → 必须用 `powershell -Command "..."`，禁止用 cmd/del

```powershell
powershell -Command "@('config','drafts','knowledge','outline','output','imports') | ForEach-Object { Get-ChildItem $_ -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne '.gitkeep' } | Remove-Item -Force }; Get-ChildItem -Recurse -Include *.tmp,*.bak,*~ -File -ErrorAction SilentlyContinue | Remove-Item -Force"
```

**darwin** → 用 find 命令

```bash
find config -maxdepth 1 -type f \( -name "*.json" -o -name "*.tmp" \) -delete 2>/dev/null
find drafts -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null
find knowledge -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null
find outline -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null
find output -maxdepth 1 -type f -name "*.md" -delete 2>/dev/null
find imports -maxdepth 1 -type f -name "*.md" ! -name ".gitkeep" -delete 2>/dev/null
find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*~" \) -delete 2>/dev/null
```

## 验证

执行后用 Glob 检查各文件夹，确认已清空，报告结果。
