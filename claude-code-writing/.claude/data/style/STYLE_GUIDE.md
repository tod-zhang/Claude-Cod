# STYLE_GUIDE.md

**Purpose:** Core writing rules for article content.

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

**Example - Heading: "What Does the Input Shaft Do?"**
- ✅ BELONGS: "The input shaft receives rotational energy and transfers it into the gear train."
- ❌ WRONG: "Manufacturers build input shafts from 4140 steel." → Answers "What is it MADE OF?"
- ❌ WRONG: "Input shafts typically cost $50-$200." → Answers "How much does it COST?"

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

**Quick conversions:**
- ❌ "significantly improved productivity" → ✅ "saved 3 hours every week"
- ❌ "This approach has many benefits" → ✅ "This approach cuts writing time in half"
- ❌ "The tool worked well in different conditions" → ✅ "The battery lasted through our entire 8-hour trek"

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

**Examples:**
- ❌ Neutral: "Both approaches have their merits" → ✅ "I prefer the second approach because it's simpler"
- ❌ Neutral: "This may be worth considering" → ✅ "You should definitely try this if you have the same problem"

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

**Example:**
- ❌ Unsupported: "Helical gears are always the best choice for industrial applications."
- ✅ Evidence-based: "For applications above 1000 RPM, helical gears outperform spur gears in noise reduction. Below that speed, the cost premium often isn't justified."

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
- **H3 (###)**: Subsections within H2 (see below)
- **H4 (####)**: Rarely needed
- Never skip levels. Keep under 60 characters.

**H2 Title Style:**
- Simple question or statement (no length restriction)
- ❌ No colon subtitles: "Equipment Costs: Your Largest Investment"
- ❌ No modifiers/commentary: "Hidden Costs Most Beginners Miss"
- ✅ Simple: "Equipment Costs", "What Are the Hidden Costs?", "How Scale Affects Unit Cost"

**H3 Usage:** Plan H3 in outline, not as post-writing fix.
- Use when H2 has parallel sub-concepts, process steps, or multi-angle analysis
- Don't use when H2 content is singular and doesn't need subdivision

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

**Example - Good table (consistent, specific):**
| Gear Type | Efficiency | Noise Level | Best For |
|-----------|------------|-------------|----------|
| Spur | 94-98% | High | Low-speed, high-load |
| Helical | 94-98% | Low | Smooth, quiet operation |

**Example - Bad table (vague, unhelpful):**
| Feature | Details |
|---------|---------|
| Material | Varies by application |
| Cost | Call for quote |

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

**Hook Examples:**
- **Direct Answer:** "Gear ratio equals driven teeth divided by driving teeth. A 60-tooth gear driven by a 20-tooth gear gives you 3:1."
- **Problem Statement:** "Gearbox overheating destroys bearings and seals within weeks. Left unchecked, you're looking at a full rebuild."
- **Surprising Fact:** "Helical gears aren't always quieter than spur gears—it depends entirely on the application speed."

**Opening Rule:** Never start with definitions, history, or "In this article..."
**Closing Rule:** End naturally. Sometimes summarize, sometimes guide to next step.

### 5.1 Conclusion: Add Value, Never Repeat

**Core principle:** Readers who finish the article already know what you covered. Repeating it wastes their time.

**AVOID (zero value):**
- "Key Takeaways" bullet lists that summarize H2 headers
- "In conclusion, we covered..." recaps
- Any summary that just repeats article content

**PREFER (adds value):**

| Type | Description | When to Use |
|------|-------------|-------------|
| next-step | What reader should do now | How-to, Tutorial |
| verdict | Clear recommendation | Comparison, Decision |
| prevention | Critical mistake to avoid | Problem-solving |
| final-insight | New angle not fully covered | Informational |
| common-mistake | What most people get wrong | Technical |

**Examples:**

```
❌ WRONG (repeats content):
"Key Takeaways:
- Categories define operating envelope
- Types address temperature capability
- Arrangements determine containment..."

✅ RIGHT (next-step):
"Start with the 8-field code to define your baseline requirements. Once you have that, engage seal manufacturers for application-specific recommendations."

✅ RIGHT (common-mistake):
"The most common failure I see: engineers specify the right seal but ignore piping plan execution. A correctly specified Plan 53B with a stuck check valve delivers the same 7-month MTBF as a wrong specification."

✅ RIGHT (final-insight):
"API 682 gets credit for seal reliability, but the real gains come from what it forces: systematic documentation of operating conditions before purchase. That discipline, not the seal specifications, prevents most failures."
```

**Length:** 2-4 sentences. If you need more, you're probably repeating.

---

## 6. Content Economy

Keep articles lean. Every element must earn its place.

### 6.1 One Case Per Point

Each claim or argument gets ONE supporting case maximum.

| Scenario | Action |
|----------|--------|
| Multiple cases support same point | Keep strongest, cut others |
| Case already used earlier | Reference briefly, don't retell |
| Case is "nice to have" | Cut it |

```
❌ "CloudKitchens had 3.2% leak rate... FitMeals saved $76K... SkyChef improved 20%..."
   (Three cases making the same point: design matters)

✅ "FitMeals redesigned containers for shipping density, saving $76K annually."
   (One case, strongest proof)
```

### 6.2 Data Restraint

Only include data the reader needs for decisions. Cut "interesting but not essential" numbers.

| Keep | Cut |
|------|-----|
| Decision-critical thresholds | Regional price variations |
| Actionable benchmarks | Historical context |
| Cost impact percentages | Precise per-unit breakdowns |

```
❌ "US Midwest buyers face $210/ton premium. Japan CIF adds $180/ton. Europe..."
✅ "Regional premiums add 5-12% to base cost depending on location."
```

**Test:** Would removing this data change the reader's decision? No → cut it.

### 6.3 No Repetition

Each fact, case, or concept appears ONCE at its most relevant location.

| Pattern | Fix |
|---------|-----|
| "As mentioned earlier..." | Delete the reference |
| Restating a stat in conclusion | Just draw the implication |
| Same example in multiple H2s | Pick one H2, remove from others |

```
❌ H2-1: "Raw materials are 60-70% of cost"
   H2-4: "Given that raw materials dominate at 60-70%..."
   Conclusion: "Remember, raw materials are 60-70%..."

✅ H2-1: "Raw materials are 60-70% of cost"
   H2-4: "This cost structure means..."
   Conclusion: "Focus procurement efforts where they matter most."
```

**Exception:** Thesis reinforcement in conclusion (one sentence, not data rehash).

---

## 7. What to Avoid

### 7.1 Banned Phrases

**Clichés:**
- "In conclusion", "In summary", "In today's world"
- "It's important to note", "It is worth noting that"
- "Furthermore", "Moreover", "Additionally", "Consequently"

**Filler:**
- "Here's the thing:", "The good news?", "The truth is..."
- "Let me be honest:", "The bottom line?", "Long story short..."

**Examples:**
- ❌ "Here's the thing: without understanding these components, you'll struggle." → ✅ "Without understanding these components, you'll struggle."
- ❌ "The good news? The concept is surprisingly simple." → ✅ "The concept is simple once you see how it works."

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

### 7.2 Writing Anti-Patterns
- Overloaded sentences with multiple claims
- Unanchored claims ("cutting-edge" without specifics)
- Weak hedging when evidence is strong

### 7.3 Data Integrity

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
11. **One case per point** - Multiple cases for same argument → keep strongest
12. **Data restraint** - Only decision-critical data; cut "nice to know"
13. **No repetition** - Each fact/case appears once at most relevant location
