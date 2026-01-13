# 分析工具设置指南

本目录包含 Google Search Console 和 Google Analytics 的 MCP 服务器配置。

## 目录结构

```
分析/
├── .mcp.json                    # MCP 服务器配置
├── mcp-gsc/                     # Google Search Console MCP 服务器
│   ├── gsc_server.py
│   ├── requirements.txt
│   └── ...
└── client_secret_*.json         # OAuth 凭据（不在仓库中）
```

## 环境设置

### 1. 设置 mcp-gsc 虚拟环境

```bash
cd 分析/mcp-gsc

# 创建虚拟环境
python3 -m venv .venv

# 激活虚拟环境
source .venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

### 2. 配置凭据文件

以下文件需要手动复制（从安全存储获取，如密码管理器）：

| 文件 | 位置 | 用途 |
|------|------|------|
| `client_secrets.json` | `分析/mcp-gsc/` | GSC OAuth 客户端凭据 |
| `client_secret_*.json` | `分析/` | Google OAuth 凭据 |

首次运行时会自动生成 `token.json`（OAuth 授权后）。

### 3. 配置 Google Cloud 凭据（用于 Analytics MCP）

```bash
# 安装 gcloud CLI（如未安装）
brew install google-cloud-sdk

# 登录并设置应用默认凭据
gcloud auth application-default login
```

凭据会保存到：`~/.config/gcloud/application_default_credentials.json`

### 4. 安装 analytics-mcp

```bash
pipx install analytics-mcp
```

## 更新 .mcp.json 路径

`.mcp.json` 中的路径是硬编码的，需要根据你的环境修改：

```json
{
  "mcpServers": {
    "gsc-server": {
      "command": "/你的路径/分析/mcp-gsc/.venv/bin/python",
      "args": ["/你的路径/分析/mcp-gsc/gsc_server.py"],
      "env": {
        "GSC_OAUTH_CLIENT_SECRETS_FILE": "/你的路径/分析/mcp-gsc/client_secrets.json"
      }
    }
  }
}
```

## 验证设置

设置完成后，可以让 Claude Code 验证：

> "帮我检查分析文件夹的 MCP 服务器是否配置正确"

## 注意事项

- `.venv/` 不在仓库中，需要在每台机器上重新创建
- 凭据文件（`*secret*.json`, `token.json`）不在仓库中，需手动复制
- Python 版本要求：>= 3.11
