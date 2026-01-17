# Sand Casting Tolerances: What Precision Can You Achieve

A tolerance of +/-0.4 mm on a sand casting "just isn't a reasonable expectation," as one foundry engineer put it on an industry forum. Yet engineers routinely specify tolerances that foundries cannot achieve, leading to rejected quotes, project delays, or expensive rework.

Sand casting typically achieves CT9 to CT12 tolerance grades per ISO 8062-3, translating to +/-0.9 mm to +/-1.5 mm on a 100 mm dimension. But that headline number varies widely based on feature location, mold process, and material. This guide breaks down realistic tolerances by feature type and explains how to specify them correctly.

## What Tolerance Grades Can Sand Casting Achieve?

[Sand casting](https://metal-castings.com/what-is-sand-casting/) falls in the CT9-CT12 range for most production work, with CT10-CT11 being typical for machine-molded parts. These tolerance grades come from ISO 8062-3, the international standard for casting dimensional tolerances.

The CT grade system can seem abstract until you translate it into actual dimensions. Here's what these grades mean for common nominal sizes:

| Nominal Dimension | CT9 | CT10 | CT11 | CT12 |
|-------------------|-----|------|------|------|
| Up to 10 mm | +/-0.36 mm | +/-0.52 mm | +/-0.74 mm | +/-1.0 mm |
| 25-40 mm | +/-0.52 mm | +/-0.74 mm | +/-1.0 mm | +/-1.5 mm |
| 63-100 mm | +/-0.74 mm | +/-1.0 mm | +/-1.5 mm | +/-2.0 mm |
| 250-400 mm | +/-1.3 mm | +/-1.8 mm | +/-2.6 mm | +/-3.6 mm |

Real production data confirms these ranges. A gray iron bracket targeting CT8 achieved +0.5/-0.4 mm on a 100 mm boss. A larger ductile iron housing at CT9 hit +1.2/-0.9 mm on a 300 mm face-to-face dimension. Larger parts need proportionally wider tolerances.

Process selection matters too. Green sand casting typically achieves CT7-CT10, while resin-bonded sand can hit CT8-CT10 with better consistency. For most purchasing decisions, plan for CT10-CT12 unless the foundry specifically confirms tighter capability for your part geometry.

## Why Tolerances Vary by Feature Location

Not all dimensions on a casting hold the same tolerance. A 50 mm dimension might achieve +/-0.8 mm in one location but require +/-2.0 mm in another. The difference comes down to where that feature sits in the mold.

### Same Mold Half

Features contained entirely within the cope or drag achieve the tightest tolerances. With no parting line or core joints involved, dimensional variation depends only on pattern accuracy and sand stability. Expect to hold published CT grade values without additional allowance.

### Across the Parting Line

Dimensions crossing the parting line add +/-0.2 to +/-0.25 mm additional tolerance. The two mold halves never close with perfect alignment, and mismatch increases with casting size. The larger the projected area of the casting, the more flask deflection and parting line shift you'll see.

Design around this when possible. If a critical dimension must span the parting line, call it out explicitly and discuss with the foundry before finalizing the pattern.

### Cored Features

Cored dimensions add another +/-1 mm or more depending on core size and support. Cores can bow, sag, or shift under the pressure of incoming metal. According to the SFSA Handbook, "the accuracy of cored passage dimensions may be limited by the ability to make cores which will resist bowing or sagging."

A hole position relative to an external surface involves at least two tolerance contributors: the core placement and the mold dimension. Internal passages are even more challenging because you cannot easily verify dimensions after casting without destructive testing or CT scanning.

For critical cored features, design for post-machining rather than relying on as-cast precision.

## Draft, Shrinkage, and Machining Allowance

Three other dimensional factors affect your finished part beyond tolerance bands.

**Draft angles** allow pattern removal from the sand. Standard practice is 1-3 degrees, with 2 degrees being typical for most surfaces. The formula is 0.017 inch per inch of draw per degree of [draft](https://metal-castings.com/what-is-traditional-casting-draft-angle/). Reducing draft below 1 degree increases pattern costs and defect risk; excessive draft adds weight and machining.

**[Shrinkage](https://metal-castings.com/what-is-shrinkage-in-casting-defects/) allowance** compensates for metal contraction during cooling. Gray iron shrinks 0.83-1.3%, aluminum about 1.3%, and steel 1.5-2.0%. The pattern maker builds this into the pattern dimensions, but material choice affects final size. Switching alloys mid-project can throw off dimensions if not accounted for.

**Machining allowance** provides extra material for post-processing. Experienced foundry operators typically leave 2-5 mm for sand castings. "Generally, we leave 3 mm for machining stock," noted one practitioner. "Sand is 3 to 4 mm."

Add machining stock only on surfaces that require it. Over-specifying wastes metal and increases machining time. Identify your critical surfaces early and communicate them clearly.

## How to Specify Tolerances in Your RFQ

Foundries see unrealistic tolerance specifications daily. The engineers who get accurate quotes and on-spec parts follow a clear communication pattern.

**Use CT grades with absolute values.** Reference ISO 8062-3 CT grades on your drawing, but include a tolerance table translating grades to millimeters for the shop floor. This gives you international standardization while ensuring everyone knows the actual targets. Most foundries quote capability around +/-0.005 inch per inch (+/-0.127 mm per 25 mm), which aligns with CT10-CT11 for moderate dimensions.

**Call out critical dimensions explicitly.** Don't rely on a blanket tolerance note. Mark the three to five dimensions that truly matter for function and specify them individually. State whether they're as-cast requirements or will be machined to final size.

**Ask the foundry before finalizing.** "Your casting supplier is the expert on what they need to make the part," as one industry veteran noted. Share your tolerance requirements early and ask what they can realistically hold. A good foundry will tell you which dimensions are challenging and suggest design adjustments.

The worst approach is specifying +/-0.5 mm across the board, getting quotes, then discovering after tooling that half the dimensions cannot be held.

## When Sand Casting Precision Is Not Enough

Sand casting tolerances work for many applications, but some parts demand tighter precision than the process can deliver.

Tighter tolerances cost more at every step. Tooling, process control, and inspection all increase. Industry experience suggests each tolerance grade improvement adds a noticeable cost premium. For most parts, that premium isn't justified.

The smarter strategy is near-net-shape: cast the bulk geometry and machine only critical zones. This captures sand casting's cost advantage for 90% of the part while achieving tight tolerances where function requires them.

When you need CT5-CT7 as-cast precision across the entire part, [investment casting tolerances](https://metal-castings.com/investment-casting-tolerances/) become worth evaluating. Investment casting costs more per piece but eliminates secondary machining on complex geometries. For parts under roughly 20 kg with many precision features, the total cost sometimes favors investment over sand-plus-machining.

## Conclusion

Before sending your next casting RFQ, verify these points:

- Tolerance grades match feature locations (tighter for same-mold-half, wider for parting line and cores)
- Critical dimensions are called out individually, not buried in blanket tolerance notes
- Draft angles are specified at 1-3 degrees unless foundry confirms otherwise
- Machining allowance appears only on surfaces that will be machined
- The foundry has confirmed they can hold your critical tolerances before tooling begins

Most sand casting tolerance problems come from specification, not capability. Foundries can consistently hit CT10-CT11 on well-designed parts. The key is designing features for the process and communicating requirements clearly before the pattern is made.

---

**Slug:** sand-casting-tolerances
**URL:** https://metal-castings.com/sand-casting-tolerances/
