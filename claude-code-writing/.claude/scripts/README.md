# Scripts

工具脚本存放目录。

## refresh-internal-links.sh

自动刷新公司内部链接缓存的 Bash 脚本。**不使用 AI，直接通过命令行处理。**

### 用法

```bash
.claude/scripts/refresh-internal-links.sh <company-name> <sitemap-index-url>
```

### 示例

```bash
# 刷新 cowseal 的内链
.claude/scripts/refresh-internal-links.sh cowseal https://cowseal.com/sitemap_index.xml

# 刷新 tanhon 的内链
.claude/scripts/refresh-internal-links.sh tanhon https://tanhon.com/sitemap_index.xml
```

### 脚本功能

1. 获取 sitemap index，提取所有子 sitemap URL
2. 依次 curl 每个子 sitemap，提取所有 `<loc>` URLs
3. 过滤非英语链接（排除 `/fr/`, `/it/`, `/de/` 等路径）
4. 排序去重
5. 将 URL 转换为标题格式（`how-to-fix` → `How To Fix`）
6. 生成 markdown 格式的链接列表
7. 写入 `.claude/data/companies/<company>/internal-links.md`
8. 更新 `Last Updated` 日期为今天

### 输出格式

```markdown
# Internal Links Cache

<!-- Last Updated: 2026-01-09 -->

## Articles
- [Title From Url](https://example.com/title-from-url/)
- [Another Article](https://example.com/another-article/)
...
```

### 性能

- **速度:** ~10秒（7个网站）
- **成本:** $0（无 AI 调用）
- **依赖:** curl, grep, sed, awk（标准 Unix 工具）

### 在 Workflow 中使用

在 `CLAUDE.md` 的 Step 1（内链缓存检查）中，当用户选择刷新时，调用此脚本：

```bash
# 1. 从 about-us.md 提取 sitemap URL
sitemap_url=$(grep "Index:" about-us.md | sed 's/.*Index: //')

# 2. 执行刷新
.claude/scripts/refresh-internal-links.sh cowseal "$sitemap_url"
```

### 注意事项

- 脚本需要 `curl` 可用（网络访问）
- 如果网站 sitemap 很大，可能需要 30-60 秒
- 自动创建临时目录，执行完自动清理
