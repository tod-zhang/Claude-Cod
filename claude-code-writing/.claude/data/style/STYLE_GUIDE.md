# STYLE_GUIDE.md

**Purpose:** Core writing rules for article content. For detailed examples, see `STYLE_EXAMPLES.md`.

Write in a clear, accessible style. Answer questions directly. Explain concepts as an expert writing for non-experts.

---

## 1. Structure

### 1.1 Inverted Pyramid
- **Most important information first**: Lead with the key takeaway
- **Start every section with the main point**: Answer the question immediately
- **Follow with supporting details**: Add context after the main point
- **End with background**: Save less critical information for last

### 1.2 Direct Answers
The first sentence of a section must directly answer the question in the subheading.

### 1.3 Heading-Content Alignment (MANDATORY)
Every paragraph must directly answer the heading's question. If it doesn't belong, DELETE or MOVE it.

**Validation Test:** "Does this paragraph answer the question in my heading?"

### 1.4 Short Paragraphs
1-3 sentences per paragraph. One idea per paragraph.

### 1.5 Sentence Variety
Mix short, medium, and occasional longer sentences. Avoid monotonous patterns.

### 1.6 Transitions

| Purpose | Examples |
|---------|----------|
| Adding | "Beyond this...", "Another factor..." |
| Contrasting | "However...", "Unlike X..." |
| Cause/Effect | "As a result...", "This leads to..." |
| Sequence | "First...", "Next...", "Finally..." |

---

## 2. Style

### 2.1 Be Concrete and Specific
Avoid vague descriptors. Use numbers, specs, and tangible attributes.
- ❌ "significantly improved productivity"
- ✅ "saved 3 hours every week"

### 2.2 Use Synonyms
No more than 2-3 uses of the same key term per paragraph. Use semantic variations.

### 2.3 Tone by Audience
**B2B/Industrial:** Formal, data-driven, specifications-focused
**Consumer:** Conversational, relatable, benefits-focused

Use `config.audience.writingApproach` for calibration.

### 2.4 Active Voice
- ❌ "The deadline was missed"
- ✅ "Our team missed the deadline"

### 2.5 Punctuation
Use periods and commas consistently. Avoid decorative symbols.

---

## 3. Voice & Originality

Articles must have clear opinions and feel unique, not templated.

### 3.1 Opinion Density
Every H2 section needs at least ONE:
- Explicit recommendation
- Expert judgment
- Counter-intuitive insight
- Practical warning
- Clear preference

### 3.2 Opinion Patterns

| Type | Pattern |
|------|---------|
| Recommendation | "For most applications, I recommend..." |
| Judgment | "The real issue here isn't X—it's Y" |
| Warning | "Avoid the trap of..." |
| Counter-intuitive | "Contrary to popular belief..." |
| Preference | "I prefer X over Y because..." |

### 3.3 Opinion Strength by Evidence

| Evidence | Strength |
|----------|----------|
| Strong data + sources | "X is clearly superior" |
| Moderate evidence | "I recommend X" |
| Limited evidence | "Based on experience, X tends to..." |
| Conflicting | "When [condition], choose X; otherwise Y" |

### 3.4 Golden Insight Prominence
Golden Insights from research must be PROMINENT, not buried.

| Placement | Writing Pattern |
|-----------|-----------------|
| Hook | Lead paragraph, first sentence |
| Section opener | First paragraph of H2, not third |
| Counter-argument | Introduce with "However..." or "What most overlook..." |

```
❌ BURIED: "Various factors affect selection. Some engineers note that... [insight in paragraph 4]"
✅ PROMINENT: "90% of cylinder heads are cast, not forged. That single fact explains why geometry trumps strength."
```

### 3.5 Contrarian Positioning
Challenge at least one common assumption per article.

| Weak | Strong |
|------|--------|
| "Quality is important" | "Most engineers over-specify—wasting budget on tolerances they'll machine away" |
| "Consider your requirements" | "Skip the requirements analysis. Start with cost constraints, work backwards" |

### 3.6 Specificity Over Generality

```
❌ VAGUE: "This can lead to significant cost savings."
✅ SPECIFIC: "One automotive supplier cut die costs 40% by switching from cold to warm forging—$120K saved."
```

### 3.7 "I Didn't Know That" Test

| Count | Assessment |
|-------|------------|
| 0-1 | ❌ Too generic, add more insights |
| 2-3 | ✅ Acceptable |
| 4+ | ✅ Excellent |

---

## 4. Formatting

### 4.1 Heading Hierarchy
- **H2 (##)**: Main sections
- **H3 (###)**: Subsections
- **H4 (####)**: Rarely needed
- Never skip levels. Keep under 60 characters.

### 4.2 Lists
- **Bullets**: Unordered items, 3-7 items per list
- **Numbers**: Sequential steps, ranked items

### 4.3 Tables

**Core principle: Tables are for "lookup", prose is for "reading".**

| | Table | Prose |
|---|-------|-------|
| Reader mode | Scan, locate | Follow, understand |
| Information | Parallel, independent | Causal, logical chain |
| Reader behavior | Find the one row they need | Read through completely |

**Use tables when:** Reader comes with a question, wants a quick answer
- Specifications (dimensions, weights, capacities)
- Mapping relationships (input → output, condition → action)
- Category lookups (3+ items with parallel attributes)

**Use prose when:** Reader wants to understand why or how
- Explanations, cause-effect relationships
- Insights, warnings, recommendations
- Anything requiring context or nuance

**Density guideline:** Avoid consecutive tables. Separate with 2-3 paragraphs of prose.

**Format rules:** Brief cells (1-5 words), consistent units, left-align text, right-align numbers

### 4.4 Numbers and Units
- Spell out one through nine; numerals for 10+
- Always numerals with units: "5 mm" not "5mm"
- Space between number and unit

### 4.5 Technical Terms
- First mention: Spell out with abbreviation in parentheses
- Subsequent: Use abbreviation only
- Define jargon for your target audience

### 4.6 Content Format by Type

| Format Indicator | Use For | Structure |
|------------------|---------|-----------|
| `[step-by-step]` | Detailed tutorials | H3 per step with full explanation |
| `[numbered list]` | Simple processes | Brief intro + numbered list |
| `[table format]` | Comparisons, specs | Intro + table + insight |

---

## 5. Opening & Closing

| Article Type | Hook | Conclusion |
|--------------|------|------------|
| How-To / Tutorial | Direct Answer | Next step or verification |
| Reference / Chart | Direct Answer | Practical takeaway |
| Problem-Solving | Problem Statement (PAS) | Prevention or next consideration |
| Comparison / Decision | Surprising Fact (AIDA) | Clear verdict |

**Opening Rule:** Never start with definitions, history, or "In this article..."
**Closing Rule:** End naturally. Sometimes summarize, sometimes guide to next step.

### 5.1 Conclusion: Natural Closure

The conclusion should feel like a natural ending, not a forced template.

**Choose based on article content:**

| When... | Natural Ending |
|---------|----------------|
| Article is actionable (How-to, Tutorial) | Next step for reader |
| Article is informational (What is, Technical) | Brief synthesis + practical takeaway |
| Article solved a problem | Verification method or next consideration |
| Reader compared options | Clear verdict or decision criteria |

**Core principles:**
1. **Be brief** - 2-4 sentences maximum
2. **Add value** - Don't just repeat H2 headers
3. **Match the tone** - Informational → calm close; Decision → confident recommendation

**Avoid:**
- "In conclusion", "In summary", "To wrap up"
- Mechanical recap of every section
- Forcing a CTA when none fits naturally

```
❌ WRONG: "In conclusion, we covered the types of forging, their advantages..."
❌ WRONG: Forcing "Contact us!" when article is purely informational
✅ RIGHT: "The choice between hot and cold forging comes down to your tolerance requirements. For parts under 0.5mm tolerance, cold forging eliminates post-machining."
✅ RIGHT: "Ready to discuss your forging requirements? Our engineering team can help."
```

---

## 6. What to Avoid

### 6.1 Banned Phrases

**Clichés:**
- "In conclusion", "In summary", "In today's world"
- "It's important to note", "It is worth noting that"
- "Furthermore", "Moreover", "Additionally", "Consequently"

**Filler:**
- "Here's the thing:", "The good news?", "The truth is..."
- "Let me be honest:", "The bottom line?", "Long story short..."

**Announcing phrases (say it, don't announce it):**

Rule: Any "[Label]:" followed by a complete sentence is an announcing phrase.

Common patterns to avoid (not exhaustive):
- The result:, The answer:, The solution:, The reason:, The point:
- The truth:, The reality:, The fact:, The problem:, The issue:
- The key insight:, The key takeaway:, The main point:, The bottom line:
- Here's why this matters:, What you need to know:, What this means:
- One consideration:, One key factor:, An important note:, A critical point:
- The calculation is simple:, The answer is straightforward:, Put simply...

Examples:
- "The result: every bottle looks identical" → "Every bottle looks identical."
- "The answer: use stainless steel" → "Use stainless steel."

**Self-reference:**
- "In this article, we will discuss..."
- "As mentioned in the previous section..."

### 6.2 Writing Anti-Patterns
- Overloaded sentences with multiple claims
- Unanchored claims ("cutting-edge" without specifics)
- Weak hedging when evidence is strong

### 6.3 Data Integrity

**All data must be fact-based or research-sourced.**

- Every claim must come from verified research or authoritative sources
- If unverified: **omit it** rather than assume
- Never fabricate data or statistics
- Attribute naturally: "According to a 2023 industry report..."
- Use ranges or qualifiers when data is uncertain

---

## Quick Reference

1. **Inverted pyramid** - Most important first
2. **Direct answers** - Answer the heading's question immediately
3. **Short paragraphs** - 1-3 sentences
4. **Concrete language** - Numbers over vague descriptors
5. **Active voice** - Subject does the action
6. **One opinion per H2** - Recommendation, warning, or judgment
7. **Data integrity** - No unverified claims
8. **No filler phrases** - If deletable, delete it
9. **Golden Insights prominent** - Not buried in paragraphs
10. **Contrarian positioning** - Challenge one assumption per article

**For detailed examples, see:** `STYLE_EXAMPLES.md`
