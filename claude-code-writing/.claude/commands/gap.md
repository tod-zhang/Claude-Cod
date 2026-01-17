---
description: 分析公司内容空白和薄弱覆盖领域
allowed-tools: Read, Glob
---

从 `article-history.md` 读取人工维护的内容空白，展示待写话题。

## 输入

用户提供公司名（如 `cowseal`），或不提供则先展示公司列表让用户选择。

## 执行步骤

### 1. 确定公司

如果用户未指定公司：
```
Read(.claude/data/companies/index.md)
```
展示列表让用户选择。

### 2. 读取 article-history.md

```
Read(.claude/data/companies/[company]/article-history.md)
```

如果文件不存在，提示用户创建。

### 3. 提取空白信息

从文件中提取三类空白：

**A. [GAP] 标记**（在话题簇中）
```
├── api-plan-11
├── api-plan-13
└── [GAP] api-plan-62  ← 提取这个
```

**B. Coverage Gaps 部分**
```
**No content on:**
- cryogenic seals  ← 提取
- nuclear pump seals

**Thin coverage on:**
- High viscosity fluid sealing  ← 提取（未删除线的）
- ~~slurry applications~~ [ADDRESSED]  ← 跳过（已解决）
```

**C. 最近文章的 Note**（可选）
检查最近文章记录中是否有建议的后续话题。

### 4. 输出报告

```markdown
## 内容空白分析: [Company]

### 📍 话题簇中的空白 ([GAP] 标记)

| 簇名 | 空白话题 |
|------|---------|
| API Flush Plans | api-plan-62 |
| Materials | silicon-carbide-grades-comparison |
| Calculations | mechanical-seal-balance-ratio-calculation |
| Dry Gas Seals | dry-gas-seal-working-principle |

### 📋 待写话题 (No content on)

- Mechanical seal working principle with animation/video
- John Crane equivalent seals guide
- Total cost of ownership analysis
- How to evaluate mechanical seal suppliers
- Back-to-back seal arrangement guide

### 🟡 薄弱覆盖 (Thin coverage on)

- High viscosity fluid sealing
- Cryogenic seal applications

### ✅ 最近已解决

- ~~slurry applications~~ → mining-slurry-pump-seal-wear-solutions
- ~~pharmaceutical GMP~~ → gmp-mechanical-seal-pharmaceutical

---

**下一步建议：** 从上方选择一个话题开始写作
```

## 注意事项

- 此命令读取**人工维护**的空白信息
- 如需添加新空白，直接编辑 article-history.md
- [GAP] 标记和 Coverage Gaps 部分需要定期更新
