# 分析工具设置指南

本目录包含 SEO 分析所需的 MCP 服务器配置，支持以下服务：

- **DataForSEO** - SERP、反向链接、页面分析
- **Google Analytics** - 流量和用户行为分析
- **Google Search Console** - 搜索表现和索引状态

## 目录结构

```
分析/
├── .mcp.json                    # MCP 服务器配置（包含敏感信息，不提交）
├── .mcp.json.example            # 配置示例模板
└── README.md                    # 本文档
```

## 快速开始

1. 复制示例配置文件：
   ```bash
   cp .mcp.json.example .mcp.json
   ```

2. 按照下方指南安装并配置各个 MCP 服务器

---

## 1. DataForSEO MCP Server

提供 SERP 查询、反向链接分析、页面 SEO 检查等功能。

### 安装

```bash
# 使用 npm 全局安装
npm install -g dataforseo-mcp-server

# 或使用 npx（无需安装）
# command 改为 "npx" , args 改为 ["dataforseo-mcp-server"]
```

### 配置

在 `.mcp.json` 中配置：

```json
{
  "dataforseo": {
    "command": "dataforseo-mcp-server",
    "args": [],
    "env": {
      "DATAFORSEO_USERNAME": "<你的用户名>",
      "DATAFORSEO_PASSWORD": "<你的密码>",
      "ENABLED_MODULES": "BACKLINKS,SERP,ONPAGE"
    }
  }
}
```

### 获取凭据

1. 访问 [DataForSEO](https://dataforseo.com/) 注册账户
2. 在 Dashboard > API Access 中获取 API 凭据

### 可用模块

| 模块 | 功能 |
|------|------|
| `SERP` | 搜索引擎结果页分析 |
| `BACKLINKS` | 反向链接数据 |
| `ONPAGE` | 页面 SEO 分析、Lighthouse 测试 |

---

## 2. Google Analytics MCP Server

访问 Google Analytics 4 数据进行流量分析。

### 安装

```bash
# 使用 pipx 安装（推荐）
pipx install analytics-mcp

# 或使用 uv
uv tool install analytics-mcp
```

### 配置

在 `.mcp.json` 中配置：

```json
{
  "analytics-mcp": {
    "command": "pipx",
    "args": ["run", "analytics-mcp"],
    "env": {
      "GOOGLE_APPLICATION_CREDENTIALS": "<凭据文件路径>",
      "GOOGLE_PROJECT_ID": "<Google Cloud 项目 ID>"
    }
  }
}
```

### 设置 Google Cloud 凭据

```bash
# 1. 安装 gcloud CLI（如未安装）
brew install google-cloud-sdk

# 2. 登录 Google 账户
gcloud auth login

# 3. 设置应用默认凭据
gcloud auth application-default login

# 4. 确认凭据位置
# 凭据保存在：~/.config/gcloud/application_default_credentials.json
```

### 启用必要的 API

在 [Google Cloud Console](https://console.cloud.google.com/) 中启用：
- Google Analytics Data API
- Google Analytics Admin API

---

## 3. Google Search Console MCP Server

访问 Google Search Console 数据进行搜索表现分析。

### 安装

```bash
# 使用 pipx 安装（推荐）
pipx install mcp-gsc

# 或使用 uv
uv tool install mcp-gsc
```

### 配置

在 `.mcp.json` 中配置：

```json
{
  "gsc-server": {
    "command": "mcp-gsc",
    "args": [],
    "env": {
      "GSC_OAUTH_CLIENT_SECRETS_FILE": "~/.config/mcp-gsc/client_secrets.json"
    }
  }
}
```

### 设置 OAuth 凭据

1. **创建 OAuth 凭据**
   - 访问 [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
   - 创建 OAuth 2.0 客户端 ID（桌面应用类型）
   - 下载 JSON 凭据文件

2. **放置凭据文件**
   ```bash
   mkdir -p ~/.config/mcp-gsc
   mv ~/Downloads/client_secret_*.json ~/.config/mcp-gsc/client_secrets.json
   ```

3. **首次运行授权**
   - 首次运行时会打开浏览器进行 OAuth 授权
   - 授权后会自动生成 token 文件

### 启用必要的 API

在 [Google Cloud Console](https://console.cloud.google.com/) 中启用：
- Google Search Console API

---

## 验证安装

设置完成后，可以让 Claude Code 验证各服务是否正常：

```
# 测试 DataForSEO
"帮我查询 example.com 的反向链接数据"

# 测试 Google Analytics
"显示我的 GA4 账户列表"

# 测试 Search Console
"列出我的 Search Console 站点"
```

---

## 故障排除

### DataForSEO 连接失败

```bash
# 检查命令是否可用
which dataforseo-mcp-server

# 如果找不到，重新安装
npm install -g dataforseo-mcp-server
```

### Analytics 认证失败

```bash
# 刷新凭据
gcloud auth application-default login

# 检查项目 ID
gcloud config get-value project
```

### GSC 授权问题

```bash
# 删除旧 token 重新授权
rm ~/.config/mcp-gsc/token.json

# 检查凭据文件是否存在
ls -la ~/.config/mcp-gsc/
```

---

## 注意事项

- `.mcp.json` 包含敏感凭据，**不要提交到 Git 仓库**
- 各服务的 API 调用可能产生费用，请注意用量
- Python 工具建议使用 pipx 隔离安装，避免依赖冲突
