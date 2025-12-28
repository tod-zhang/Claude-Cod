# Workflow State Schema

This file defines the JSON structure for `workflowState` in config files. Agents read this when they need to update the config.

---

## Core Identity Fields (Config Root)

Added by: **config-creator**
Read by: all agents

```json
{
  "writingAngle": {
    "thesis": "The ONE claim this article proves (specific, not vague)",
    "stance": "challenge | confirm | nuance",
    "proofPoints": ["evidence 1", "evidence 2", "evidence 3"]
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

**writingAngle.stance explained:**
- `challenge`: Disagree with common belief ("Most guides are wrong about X")
- `confirm`: Reinforce with new evidence ("X is important, here's proof")
- `nuance`: Add complexity ("X depends on Y, here's when each applies")

**authorPersona.bias is critical:**
- This is what makes the article NOT neutral
- Must appear in at least 2 H2 sections as recommendation/warning
- Examples: "宁可过度设计，不要临界运行", "标准流程优于个人经验"

---

## workflowState.research

Added by: **web-researcher**
Read by: outline-writer, proofreader

```json
"workflowState": {
  "research": {
    "status": "completed",
    "completedAt": "[ISO timestamp]",
    "summary": {
      "sourceCount": 0,
      "dataPointCount": 0,
      "competitorCount": 0
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
    "gaps": {
      "data": ["missing data areas"],
      "coverage": ["topics competitors missed"]
    },
    "controversies": ["expert disagreements found"],
    "coreThesis": "proposed thesis from research",
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
    "visualStrategy": {
      "competitorVisuals": {
        "dominantType": "stock photos/original diagrams/data charts/mixed",
        "quality": "low/medium/high",
        "gaps": ["concepts competitors don't visualize"]
      },
      "requiredVisuals": [
        {
          "concept": "concept needing visualization",
          "reason": "complex process/data comparison/abstract idea",
          "suggestedType": "flowchart/comparison-table/diagram/infographic/chart",
          "placement": "H2 section name",
          "differentiator": true,
          "canUseMarkdownTable": false
        }
      ],
      "differentiationOpportunity": "how visuals can set us apart",
      "originalNeeded": ["concepts requiring custom diagrams"],
      "stockAcceptable": ["concepts where stock photos work"]
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
      "dataPointsUsed": 0
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
      },
      "visualPlan": {
        "totalPlanned": 0,
        "imagesNeeded": [
          {
            "concept": "concept from visualStrategy.requiredVisuals",
            "type": "flowchart/diagram/chart/infographic",
            "placement": "H2 section name",
            "description": "what image should show",
            "differentiator": true,
            "priority": "high/medium/low"
          }
        ],
        "markdownTablesUsed": [
          {
            "concept": "concept that used markdown table instead of image",
            "placement": "H2 section name",
            "reason": "simple comparison data"
          }
        ],
        "stockPhotoSuggestions": [
          {
            "placement": "H2 section name",
            "keywords": "search keywords for stock photo",
            "purpose": "illustrative/decorative"
          }
        ]
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
| `writingAngle.thesis` | config-creator | all | The ONE claim to prove |
| `writingAngle.stance` | config-creator | all | challenge/confirm/nuance |
| `authorPersona.role` | config-creator | all | WHO is writing |
| `authorPersona.bias` | config-creator | all | Non-neutral perspective |
| `authorPersona.voiceTraits` | config-creator | outline-writer | HOW to express ideas |

### For Downstream Agents

| Field Path | Used By | Purpose |
|------------|---------|---------|
| `research.thesisValidation.validatedThesis` | outline-writer | Adjusted thesis if original lacked evidence |
| `research.thesisValidation.personaFraming` | outline-writer | How persona would express thesis |
| `research.writingAdvice.personaVoiceNotes` | outline-writer | Research-informed voice guidance |
| `research.differentiation.primaryDifferentiator` | outline-writer | Lead with this in title/intro |
| `research.differentiation.avoidList` | outline-writer, proofreader | Patterns to avoid |
| `research.writingAdvice.cautious` | outline-writer | Use fuzzy language here |
| `research.insights.suggestedHook` | outline-writer | Hook strategy |
| `writing.decisions.thesisExecution` | proofreader | Verify thesis stated and reinforced |
| `writing.decisions.personaExecution` | proofreader | Verify persona consistency |
| `writing.decisions.sectionsToWatch.weak` | proofreader | Focus verification here |
| `writing.decisions.hookUsed` | proofreader | Verify hook delivers |
| `writing.decisions.visualPlan.markdownTablesUsed` | proofreader | Skip image generation |
