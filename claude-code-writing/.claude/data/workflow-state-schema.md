# Workflow State Schema

This file defines the JSON structure for `workflowState` in config files. Agents read this when they need to update the config.

---

## Core Identity Fields (Config Root)

Added by: **config-creator** (initial), **main workflow** (thesis after Step 3)
Read by: all agents

```json
{
  "audienceFramework": "b2b | b2c",
  "articleType": "opinion | tutorial | informational | comparison",
  "articleLength": "short | standard | deep",
  "writingAngle": {
    "thesis": "The ONE claim this article proves (null until Step 3)",
    "stance": "challenge | confirm | nuance (null until Step 3)",
    "pending": true,
    "proofPoints": ["evidence 1", "evidence 2", "evidence 3"],
    "recommendedDepth": "B2B: 入门基础|进阶技巧|技术细节|概述|专家级 | B2C: 极简|实用|对比 | all",
    "depthMismatchAcknowledged": false
  },
  "authorPersona": {
    "role": "热处理车间主任",
    "experience": "15年一线经验",
    "specialty": "大型铸件热处理",
    "bias": "注重工艺稳定性，反对追求参数极限",
    "voiceTraits": ["务实", "直接", "爱举实例"]
  }
}
```

**articleType explained:**
- `opinion`: Article with clear stance, must prove a thesis
- `tutorial`: How-to guide, thesis optional (e.g., "the simplest method")
- `informational`: Objective explanation, no thesis needed
- `comparison`: Comparing options, thesis optional (can be neutral or have preference)

**articleLength explained:**
- `short`: 900-1100 words
  - Use for: clear-answer informational articles, quick guides
- `standard`: 1200-1500 words (DEFAULT)
  - Use for: most articles
- `deep`: 1800-2300 words
  - Use for: comprehensive tutorials, detailed technical analysis

**H2 and case study counts:**
- Determined by topic structure and content needs, not word count
- outline-writer decides based on natural subtopics and evidence requirements

**writingAngle.thesis is the ANGLE, not the TOPIC:**
- **Topic** = what the article covers (from user's search intent)
- **Thesis** = unique perspective that differentiates the article
- Article structure: cover topic fully, thesis gets 1-2 dedicated H2s
- Other H2s use thesis as **lens** (informs perspective, doesn't dominate)
- Example: Topic="Seal selection for water treatment", Thesis="Flush water quality matters more than seal spec" → Most H2s cover seal selection; 1 H2 proves the flush water claim

**writingAngle.stance explained:**
- `challenge`: Disagree with common belief ("Most guides are wrong about X")
- `confirm`: Reinforce with new evidence ("X is important, here's proof")
- `nuance`: Add complexity ("X depends on Y, here's when each applies")

**authorPersona.bias is critical:**
- This is what makes the article NOT neutral
- Must appear in at least 2 H2 sections as recommendation/warning
- Examples: "宁可过度设计，不要临界运行", "标准流程优于个人经验"

**writingAngle.recommendedDepth explained:**

B2B depths:
- `入门基础`: Thesis uses simple examples, analogies, case studies
- `进阶技巧`: Requires industry context and selection frameworks
- `技术细节`: Specific parameters, procedures, standards references
- `概述`: Value and cost focus, no technical depth needed
- `专家级`: Highest complexity, research and standards citations

B2C depths:
- `极简`: Conversational, 3-5 min read, core question only
- `实用`: Problem → diagnosis → solution → when to call pro
- `对比`: Features as benefits, comparison tables, recommendations

Special:
- `all`: Flexible thesis that works at any depth level

**writingAngle.pending:**
- Set to `true` by config-creator (except for informational articles)
- Indicates thesis has not yet been selected
- When `true`:
  - web-researcher Phase 1 generates `recommendedTheses` based on competitor analysis
  - Main workflow pauses after Step 2 for user to select thesis in Step 3
  - After selection, main workflow updates config and sets `pending: false`
- Set to `false` for informational articles (no thesis needed)

**writingAngle.depthMismatchAcknowledged:**
- Set to `true` when user chooses a thesis whose `recommendedDepth` differs from selected article depth
- When `true`, outline-writer must adjust argumentation strategy:
  - B2B: 专家级 thesis + 入门基础 depth → use simplified explanations, analogies
  - B2B: 入门基础 thesis + 技术细节 depth → add technical depth while keeping core argument accessible
  - B2C: Mismatches rare (User Type typically determines both depth and thesis suitability)
- This is an intentional choice, not an error - can be a differentiation strategy

---

## Innovation Space Assessment

Added by: **web-researcher** (Phase 1)
Read by: main workflow, outline-writer, proofreader

Not all topics have room for unique angles. Some topics have fixed answers or standardized processes where "differentiation" means execution quality, not novel perspectives.

**innovationSpace.level explained:**
- `low`: Fixed steps, single correct answer, competitors content is nearly identical
  - Examples: "How to install Python", "What is HTTP", "How to boil an egg"
  - Strategy: execution differentiation (depth, coverage, practical value)
- `medium`: Some variation possible, but core content is similar
  - Examples: "Best practices for X", "Common mistakes in Y"
  - Strategy: both (light thesis + execution differentiation)
- `high`: Multiple valid approaches, requires judgment, room for disagreement
  - Examples: "How to choose a framework", "Best architecture for X"
  - Strategy: angle differentiation (thesis required)

**innovationSpace.signals explained:**
- `contentVariance`: How much do competitors differ? (low = nearly identical, high = very different)
- `answerUniqueness`: How many valid answers exist? (single = one right way, many = depends on context)
- `judgmentRequired`: Does the reader need to make decisions? (none = follow steps, significant = evaluate tradeoffs)

**innovationSpace.skipThesis:**
- When `true`, main workflow skips Step 3 (thesis selection)
- Set automatically when `level: low` or `articleType: informational`
- When skipped, `executionDifferentiation` becomes the primary differentiation strategy

**executionDifferentiation explained:**
- Used when `innovationSpace.strategy` includes "execution"
- Three dimensions:
  - **depth**: Go deeper than competitors on technical explanations
  - **coverage**: Cover edge cases, alternatives, failure modes they miss
  - **practicalValue**: Add real-world examples, common mistakes, troubleshooting
- Each has `competitorLevel/Provides` (what they do) and `ourTarget/Additions` (what we'll do better)

---

## workflowState.research

Added by: **web-researcher**
Read by: outline-writer, proofreader

```json
"workflowState": {
  "research": {
    "status": "completed",
    "completedAt": "[ISO timestamp]",
    "urlCache": ["url1", "url2", "url3"],
    "competitorContent": {
      "url1": {
        "structure": ["H2-1", "H2-2"],
        "stances": ["position on X"],
        "dataPoints": ["stat from this competitor"],
        "gaps": ["what they missed"]
      }
    },
    "summary": {
      "sourceCount": 0,
      "dataPointCount": 0,
      "competitorCount": 0,
      "caseCount": 0,
      "expertExplanationCount": 0,
      "debateCount": 0,
      "userVoiceCount": 0
    },
    "materialMix": {
      "targetMix": {
        "cases": "40%",
        "data": "15%",
        "expert": "25%",
        "userVoice": "10%",
        "debates": "10%"
      },
      "actualMix": {
        "cases": "35%",
        "data": "20%",
        "expert": "25%",
        "userVoice": "10%",
        "debates": "10%"
      },
      "gaps": ["need more cases for opinion article"]
    },
    "competitorAnalysis": {
      "stances": {
        "consensus": ["positions all competitors agree on"],
        "disagreements": ["positions where competitors differ"],
        "implicitAssumptions": ["what all assume without stating"]
      },
      "dataSourcing": {
        "strongSources": ["verifiable primary sources"],
        "weakClaims": ["unsourced or questionable claims"],
        "opportunityAreas": ["where we can provide better evidence"]
      },
      "terminology": {
        "standardTerms": {"concept": "industry standard term"},
        "readerExpectations": "common phrasing readers expect"
      },
      "stanceOpportunities": [
        {
          "theyAllSay": "consensus position",
          "ourStance": "challenge/confirm/nuance",
          "evidence": "our supporting evidence"
        }
      ]
    },
    "insights": {
      "goldenInsights": [
        {
          "insight": "key insight text",
          "source": "url",
          "suggestedUse": "hook/opener/evidence"
        }
      ],
      "quality": "high/medium/limited",
      "suggestedHook": "surprising-stat/question/problem/direct"
    },
    "differentiation": {
      "score": "strong/moderate/weak",
      "primaryDifferentiator": "what makes this article uniquely valuable",
      "types": {
        "coverage": ["topics they miss"],
        "stance": ["where we disagree or add nuance"],
        "quality": ["better sourcing, clarity, depth"]
      },
      "irreplicableInsights": [
        {
          "insight": "insight text",
          "sourceType": "practitioner/data/counter-intuitive/case-study",
          "source": "url",
          "intentAlignment": "aligned/partial"
        }
      ],
      "avoidList": ["what competitors do that we should NOT copy"]
    },
    "innovationSpace": {
      "level": "low | medium | high",
      "reason": "why this level - e.g., fixed steps, single answer, or multiple valid approaches",
      "signals": {
        "contentVariance": "low/medium/high - how much competitors differ",
        "answerUniqueness": "single/few/many - number of valid answers",
        "judgmentRequired": "none/some/significant - decision-making needed"
      },
      "strategy": "execution | angle | both",
      "skipThesis": false
    },
    "executionDifferentiation": {
      "depth": {
        "competitorLevel": "surface | moderate | deep",
        "ourTarget": "match | deeper | much-deeper",
        "specificAreas": ["areas where we go deeper than competitors"]
      },
      "coverage": {
        "competitorGaps": ["edge cases", "alternative methods", "failure modes"],
        "ourAdditions": ["specific topics we'll cover that they miss"]
      },
      "practicalValue": {
        "competitorProvides": ["basic steps", "general advice"],
        "ourAdditions": ["common mistakes", "efficiency tips", "real examples", "troubleshooting"]
      },
      "score": "strong | moderate | weak"
    },
    "gaps": {
      "data": ["missing data areas"],
      "coverage": ["topics competitors missed"]
    },
    "controversies": ["expert disagreements found"],
    "coreThesis": "proposed thesis from research",
    "recommendedTheses": [
      {
        "thesis": "specific claim based on research data",
        "stance": "challenge | confirm | nuance",
        "recommendedDepth": "B2B: 入门基础|进阶技巧|技术细节|概述|专家级 | B2C: 极简|实用|对比 | all",
        "evidenceSummary": "key data points supporting this thesis",
        "differentiationScore": "strong | moderate | weak"
      }
    ],
    "thesisValidation": {
      "originalThesis": "from config.writingAngle.thesis",
      "evidenceFor": ["data/quotes supporting thesis"],
      "evidenceAgainst": ["contradicting data - note for nuance"],
      "validatedThesis": "adjusted thesis if original lacked evidence",
      "personaFraming": "how [role] would express this thesis",
      "adjustment": "keep | soften | strengthen"
    },
    "writingAdvice": {
      "emphasize": ["topics with strong data"],
      "cautious": ["topics with weak data - use fuzzy language"],
      "differentiateWith": ["specific differentiators to highlight"],
      "stanceToTake": ["positions to take on consensus topics"],
      "terminologyToUse": {"concept": "preferred term"},
      "personaVoiceNotes": [
        "Research-informed voice guidance for the persona",
        "e.g., 'Found practitioner stories that support bias'"
      ]
    },
    "userVoices": {
      "collected": true,
      "audienceMatch": "how well voices match config.audience",
      "beginnerPhrasing": {
        "questions": ["how beginners ask about this topic"],
        "problemDescriptions": ["how they describe issues"],
        "emotionalTone": "uncertain/curious/frustrated"
      },
      "practitionerPhrasing": {
        "questions": ["how practitioners ask"],
        "problemDescriptions": ["practical problem framing"],
        "emotionalTone": "frustrated/urgent/analytical"
      },
      "expertPhrasing": {
        "discussions": ["how experts frame the topic"],
        "assumedKnowledge": ["what they don't explain"],
        "technicalLevel": "advanced terminology used"
      },
      "terminologyMap": [
        {
          "usersSay": "informal term",
          "technicalTerm": "formal term",
          "useInArticle": "which to use based on audience"
        }
      ],
      "quotableVoices": [
        {
          "quote": "memorable phrase",
          "sourceType": "beginner/practitioner/expert",
          "suggestedUse": "hook/example/evidence"
        }
      ]
    },
    "authorityStrategy": {
      "sourcesFound": {
        "tier1_academic": [
          {
            "source": "Name/Institution",
            "credential": "title/affiliation",
            "quote": "exact quote",
            "url": "verification URL",
            "usage": "where to use in article"
          }
        ],
        "tier2_industry": [
          {
            "source": "Organization/Standard",
            "document": "report/standard name",
            "quote": "exact quote",
            "url": "URL",
            "usage": "where to use"
          }
        ],
        "tier3_namedExperts": [
          {
            "name": "Full Name",
            "credential": "title at company",
            "quote": "quote",
            "url": "URL",
            "usage": "where to use"
          }
        ],
        "tier4_practitioners": [
          {
            "username": "u/username or ForumName",
            "platform": "Reddit/Eng-Tips/etc",
            "statedExperience": "20 years in X",
            "quote": "quote",
            "url": "URL",
            "usage": "where to use"
          }
        ]
      },
      "eatSignals": {
        "experienceSignals": ["first-hand testing found"],
        "expertiseSignals": ["technical depth demonstrated"],
        "authoritySignals": ["recognized sources cited"],
        "trustSignals": ["limitations acknowledged"]
      },
      "quotePlan": {
        "targetCount": "2-3",
        "distribution": {
          "introduction": "Tier X quote for hook",
          "body": "Tier X quotes for evidence",
          "conclusion": "optional practitioner insight"
        }
      }
    },
    "materials": {
      "cases": [
        {
          "id": "CASE-001",
          "title": "The Cracked Crankshaft Batch",
          "summary": "23% failure rate traced to clogged filter",
          "suggestedUse": "hook",
          "persuasionType": "shock-value",
          "thesisSupport": "strong",
          "competitorHas": false,
          "suggestedPlacement": "introduction"
        }
      ],
      "expertExplanations": [
        {
          "id": "EXP-001",
          "concept": "Why quenching speed matters",
          "expert": "Dr. James Chen, MIT",
          "analogyAvailable": true,
          "canBorrow": ["analogy", "phrasing"],
          "thesisSupport": "strong",
          "suggestedPlacement": "H2-2"
        }
      ],
      "debates": [
        {
          "id": "DEB-001",
          "topic": "Water vs. Oil Quenching",
          "positions": 2,
          "ourPosition": "context-dependent",
          "thesisSupport": "nuance",
          "suggestedPlacement": "H2-3"
        }
      ],
      "byThesisRelevance": {
        "strongSupport": ["CASE-001", "EXP-001", "D001"],
        "counterPoints": ["DEB-001"],
        "neutral": ["D003", "VOICE-002"]
      },
      "byPlacement": {
        "hook": ["CASE-001", "D001"],
        "H2-1": ["EXP-001"],
        "H2-2": ["CASE-002", "D002"],
        "H2-3": ["DEB-001"],
        "conclusion": ["VOICE-003"]
      },
      "differentiators": ["CASE-001", "EXP-001", "DEB-001"]
    }
  }
}
```

---

## workflowState.writing

Added by: **outline-writer**
Read by: proofreader

```json
"workflowState": {
  "research": { "..." : "preserved from previous step" },
  "writing": {
    "status": "completed",
    "completedAt": "[ISO timestamp]",
    "outline": {
      "h2Count": 0,
      "structure": ["H2-1 title", "H2-2 title"],
      "introFramework": "Direct Hook/PAS/AIDA",
      "conclusionType": "next-step/synthesis/verdict/prevention (based on article type)",
      "funnelStage": "from config.buyerJourney.funnelStage"
    },
    "buyerJourney": {
      "funnelStage": "awareness/consideration/decision",
      "primaryCTAUsed": "from conversionPath.primaryCTA.action",
      "nextTopicsMentioned": ["topics referenced from nextTopics"],
      "prerequisitesMentioned": ["topics linked from prerequisites"]
    },
    "execution": {
      "actualWordCount": 0,
      "internalLinksUsed": 0,
      "dataPointsUsed": 0,
      "casesUsed": 0,
      "expertExplanationsUsed": 0,
      "debatesUsed": 0,
      "userVoicesUsed": 0
    },
    "materialUsage": {
      "used": [
        {"id": "CASE-001", "location": "introduction", "purpose": "hook"},
        {"id": "EXP-001", "location": "H2-2", "purpose": "technical-proof"},
        {"id": "D001", "location": "H2-1", "purpose": "evidence"}
      ],
      "skipped": [
        {"id": "CASE-003", "reason": "weak thesis support"},
        {"id": "D005", "reason": "redundant with D001"}
      ],
      "borrowed": [
        {"id": "EXP-001", "element": "analogy", "adapted": "slightly modified for audience"}
      ],
      "differentiatorCoverage": {
        "total": 3,
        "used": 2,
        "list": ["CASE-001 ✅", "EXP-001 ✅", "DEB-001 ❌ skipped"]
      }
    },
    "decisions": {
      "thesisExecution": {
        "thesis": "the thesis used (original or validated)",
        "stance": "challenge/confirm/nuance",
        "proofPointsUsed": ["how each proof point was incorporated"],
        "introStatement": "how thesis was stated in intro",
        "conclusionReinforcement": "how thesis was reinforced in conclusion"
      },
      "personaExecution": {
        "role": "the persona role used",
        "biasAppliedIn": [
          "H2-1: how bias shaped recommendation",
          "H2-3: how bias appeared as warning"
        ],
        "voiceTraitsUsed": ["which traits were applied"],
        "signaturePhrases": ["memorable persona-voice phrases used in article"]
      },
      "depthAdaptation": {
        "applied": false,
        "originalRecommendedDepth": "B2B: 入门基础|进阶技巧|技术细节|概述|专家级 | B2C: 极简|实用|对比 | all",
        "actualDepth": "B2B: 入门基础|进阶技巧|技术细节|概述|专家级 | B2C: 极简|实用|对比",
        "strategy": "how argumentation was adjusted to bridge the gap"
      },
      "hookUsed": {
        "type": "surprising-stat/question/problem/direct",
        "content": "actual hook text or insight used"
      },
      "differentiationApplied": {
        "primaryDifferentiatorUsed": "how primaryDifferentiator was applied",
        "irreplicableInsightsUsed": [
          {"insight": "text", "location": "intro/H2-X/conclusion"}
        ],
        "avoidedPatterns": ["patterns from avoidList that were avoided"],
        "titleDifferentiation": "how title reflects unique value"
      },
      "opinionsIncluded": [
        "[H2-1]: opinion summary",
        "[H2-3]: opinion summary"
      ],
      "sectionsToWatch": {
        "strong": ["sections with good data support"],
        "weak": ["sections needing proofreader attention"],
        "differentiated": ["sections with irreplicable content"]
      },
      "internalLinks": {
        "requiredLinksUsed": [
          {"target": "slug", "anchor": "text used", "url": "url", "location": "H2-X"}
        ],
        "recommendedLinksUsed": [
          {"target": "slug", "anchor": "text used", "url": "url", "priority": "high/medium"}
        ],
        "totalCount": 0,
        "clusterContext": "cluster name or standalone"
      },
      "crossArticleStrategy": {
        "differentiatedFrom": [
          {"article": "slug", "theirAngle": "...", "ourAngle": "..."}
        ],
        "backlinkOpportunitiesCreated": [
          {"existingArticle": "slug", "concept": "what they can link to"}
        ],
        "linkableAnchorsCreated": [
          {"phrase": "anchor text", "concept": "what it covers", "location": "H2-X"}
        ]
      },
      "productMentions": {
        "used": [
          {"category": "Category", "mentionText": "text used", "location": "H2-X"}
        ],
        "skipped": [
          {"category": "Category", "reason": "why skipped"}
        ],
        "count": 0
      }
    }
  }
}
```

---

## Field Reference (Quick Lookup)

### Core Identity (Config Root)

| Field Path | Set By | Used By | Purpose |
|------------|--------|---------|---------|
| `audienceFramework` | config-creator | all | b2b/b2c - determines User Types, depths, personas sources |
| `articleType` | config-creator | all | opinion/tutorial/informational/comparison |
| `articleLength` | config-creator | outline-writer | short/standard/deep - controls H2 count and word budget |
| `writingAngle.thesis` | main (Step 3) | all | The ONE claim to prove (null until Step 3) |
| `writingAngle.stance` | main (Step 3) | all | challenge/confirm/nuance (null until Step 3) |
| `writingAngle.pending` | config-creator | web-researcher, main | true = thesis 待选择 |
| `writingAngle.recommendedDepth` | main (Step 3) | outline-writer | Thesis 最佳深度 |
| `writingAngle.depthMismatchAcknowledged` | main (Step 3) | outline-writer | 需要调整论证策略 |
| `authorPersona.role` | config-creator | all | WHO is writing |
| `authorPersona.bias` | config-creator | all | Non-neutral perspective |
| `authorPersona.voiceTraits` | config-creator | outline-writer | HOW to express ideas |

### For Downstream Agents

| Field Path | Used By | Purpose |
|------------|---------|---------|
| `research.urlCache` | web-researcher (Phase 2) | 跳过已 Fetch 的 URL，避免重复请求 |
| `research.competitorContent` | web-researcher (Phase 2) | 复用 Phase 1 竞品数据，无需再次 Fetch |
| `articleType` | all agents | 决定是否需要 thesis 验证 |
| `research.innovationSpace.level` | main, outline-writer | low/medium/high 决定差异化策略 |
| `research.innovationSpace.skipThesis` | main workflow | true = 跳过 Step 3 角度选择 |
| `research.innovationSpace.strategy` | outline-writer | execution/angle/both 决定差异化类型 |
| `research.executionDifferentiation` | outline-writer | 执行层差异化的具体方向 |
| `research.executionDifferentiation.depth` | outline-writer | 比竞品更深入的领域 |
| `research.executionDifferentiation.coverage` | outline-writer | 竞品遗漏的边界情况 |
| `research.executionDifferentiation.practicalValue` | outline-writer | 竞品缺少的实用价值 |
| `writingAngle.pending` | web-researcher (Phase 1) | true = 需要生成 recommendedTheses |
| `writingAngle.depthMismatchAcknowledged` | outline-writer | Adjust argumentation for depth gap |
| `research.recommendedTheses` | main (Step 3) | Phase 1 输出的角度推荐 |
| `research.thesisValidation.validatedThesis` | outline-writer | Adjusted thesis if original lacked evidence |
| `research.thesisValidation.personaFraming` | outline-writer | How persona would express thesis |
| `research.writingAdvice.personaVoiceNotes` | outline-writer | Research-informed voice guidance |
| `research.differentiation.primaryDifferentiator` | outline-writer | Lead with this in title/intro |
| `research.differentiation.avoidList` | outline-writer, proofreader | Patterns to avoid |
| `research.writingAdvice.cautious` | outline-writer | Use fuzzy language here |
| `research.insights.suggestedHook` | outline-writer | Hook strategy |
| `writing.decisions.thesisExecution` | proofreader | Verify thesis stated and reinforced |
| `writing.decisions.personaExecution` | proofreader | Verify persona consistency |
| `writing.decisions.depthAdaptation` | proofreader | Verify argumentation matches depth |
| `writing.decisions.sectionsToWatch.weak` | proofreader | Focus verification here |
| `writing.decisions.hookUsed` | proofreader | Verify hook delivers |
| `research.materials.byPlacement` | outline-writer | Which materials to use where |
| `research.materials.differentiators` | outline-writer | Prioritize these materials |
| `research.materialMix.targetMix` | outline-writer | Target material distribution |
| `writing.materialUsage.used` | proofreader | Verify materials were applied |
| `writing.materialUsage.differentiatorCoverage` | proofreader | Check differentiators used |
