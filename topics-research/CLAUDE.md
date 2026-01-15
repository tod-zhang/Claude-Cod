# Topics Research - SEO Keyword Generator

## Overview

Generate user-centric keywords for B2B manufacturing companies based on the "Grounding AI for SEO" methodology.

**Content Language**: English only

## Companies

| Company | Industry | Profile |
|---------|----------|---------|
| bastone-plastics | Plasticizers & PVC Additives | `companies/bastone-plastics/profile.md` |
| cowseal | Mechanical Seals | `companies/cowseal/profile.md` |
| metal-castings | Sand & Investment Casting | `companies/metal-castings/profile.md` |
| mtedmachinery | Aluminum Foil Container Machines | `companies/mtedmachinery/profile.md` |
| soontact | Packaging Machinery | `companies/soontact/profile.md` |
| tanhon | Gearboxes & Reducers | `companies/tanhon/profile.md` |

---

## Usage

### Mode 1: Company-Based Keyword Generation

```
Generate keywords for [company-name]
Topic: [product or topic]
```

Example:
```
Generate keywords for cowseal
Topic: mechanical seal failure
```

### Mode 2: Direct Keyword Expansion

```
Expand keyword: [seed keyword]
Industry: [optional context]
```

Example:
```
Expand keyword: plasticizer
Industry: PVC manufacturing
```

---

## Keyword Generation Process

### Step 1: Load User Personas

Each company profile contains 4 user personas with:
- Experience level
- Goals
- Pain Points
- Decision Factors
- Search Behavior

### Step 2: Transform by Search Intent

For each persona, generate keywords by intent:

| Intent | Pattern | Example |
|--------|---------|---------|
| Informational | "what is...", "how does...", "types of..." | "what causes mechanical seal failure" |
| Commercial | "best...", "top... suppliers", "... vs ..." | "best plasticizer for PVC film" |
| Transactional | "... manufacturer", "buy...", "... supplier" | "gearbox manufacturer China" |

### Step 3: Generate PAA Questions

Create "People Also Ask" style questions:
- What/Why/How/Where questions
- Comparison questions
- Problem-solution questions

### Step 4: Output Format

```markdown
## Keywords for: [topic]

### Informational Intent
- keyword 1
- keyword 2

### Commercial Intent
- keyword 1
- keyword 2

### Transactional Intent
- keyword 1
- keyword 2

### PAA Questions
- question 1
- question 2
```

---

## Quick Commands

| Command | Action |
|---------|--------|
| `list companies` | Show all companies |
| `keywords for [company] topic: [topic]` | Generate keywords for company |
| `expand [keyword]` | Expand a seed keyword |
| `analyze [url]` | Analyze website and create new company profile |

---

## Adding New Company

1. Create directory: `companies/[company-name]/`
2. Create `profile.md` with sections:
   - Basic Information
   - Products & Services
   - User Personas (4 types with Search Behavior)
   - Target Industries
   - Competitive Advantages
   - Core Keywords
   - Long-tail Keyword Themes
   - PAA-Style Questions
   - Main Competitors
