# How Far Are LLMs from Believable AI? A Benchmark for Evaluating the Believability of Human Behavior Simulation

**Authors:** Yang Xiao, Yi Cheng, Jiashuo Wang, Wenjie Li, Jinlan Fu, Pengfei Liu

**Year:** 2024

**Citation Key:** xiaoHowFarAre2024

**Institutions:** The Hong Kong Polytechnic University, National University of Singapore, Shanghai Jiao Tong University

## Abstract / Overview

This paper introduces **SimulateBench**, a comprehensive benchmark for evaluating the believability of LLMs when simulating human behaviors. The authors propose two critical dimensions for measuring believability: **consistency** (how well LLMs align with character profiles) and **robustness** (how stable LLM behaviors remain under profile perturbations). Testing 10 major LLMs reveals significant gaps in current models' ability to convincingly simulate human behavior.

## Key Research Questions

- To what extent can LLMs accurately depict identity information, social roles, and relationships from long profile inputs (consistency)?
- How robust are LLMs' simulated behaviors when faced with updates or perturbations in character profiles?
- Which factors most significantly influence the believability of LLM-based human behavior simulation?
- How do current LLMs compare in their ability to simulate believable human characters?

## Methodology

### SimulateBench Construction

**Character Dataset:**
- 65 character profiles from 4 TV series (The Simpsons, Friends, Breaking Bad, The Rings of Power)
- Average profile length: 3,277 tokens (vs. 203 tokens in prior work like Park et al. 2023)
- Extracted from fandom wikis with human verification

**Profile Descriptive Framework:**
Three comprehensive categories:
1. **Immutable Characteristics:** Name, gender, age, race, etc.
2. **Social Roles:** Connected behaviors, obligations, beliefs, norms, traits, routines, experiences, goals
3. **Relationships:** Familiarity, judgment, affection, behavioral patterns, relationship status, communication history

**Evaluation Dataset:**
- Total: 8,400 multiple-choice questions
- Average: ~129 questions per character
- Question types: Known (sufficient info in profile) vs. Unknown (insufficient info)

**Robustness Dataset:**
- Profile perturbations across 4 demographic factors: Education, Surname, Race, Age
- Modified questions aligned with perturbed profiles
- Tests whether LLM behavior changes inappropriately with minor profile variations

### Evaluation Metrics

1. **CA (Consistency Ability):** Accuracy on multi-choice questions requiring reasoning from profile
2. **RA (Robustness Ability):** Standard deviation of CA scores across profile variants (σ)
3. **RCoV (Robustness Coefficient of Variation):** RA normalized by mean CA (σ/μ) - quantifies robustness impact on actual performance

### Models Evaluated

10 LLMs tested:
- Commercial: GPT-4 (8k), GPT-3.5-Turbo-16K (16k)
- Open-source: XVERSE-13B-Chat, Qwen-14B-Chat, Qwen-7B-Chat, Vicuna-13B-16K, Vicuna-7B-16K, ChatGLM2-6B-32K, ChatGLM2-6B, LongChat-7B-32K

### Prompting Strategies

Five combinations tested:
- Zero-shot
- Zero-shot + Chain-of-Thought (CoT)
- Few-shot
- Few-shot + CoT
- Few-shot + Self-Ask

## Key Findings

### 1. Poor Consistency Performance

**Overall Results (CA scores):**
- GPT-4: 0.77 (best)
- GPT-3.5-Turbo-16K: 0.70
- Best open-source (XVERSE-13B-Chat): 0.62
- Worst (Vicuna-7B-16K): 0.46

**Critical observation:** Longer context size ≠ better consistency
- LongChat-7B-32K (32k context): 0.48 CA
- Worse than GPT-4 (8k), Qwen-7B-Chat (8k), ChatGLM2-6B (8k)

### 2. Severe Simulation Hallucination

Models perform significantly worse on "Unknown" questions where profile lacks sufficient information:

| Model | Known Q Accuracy | Unknown Q Accuracy |
|-------|------------------|-------------------|
| GPT-4 | 1.00 | 0.47 |
| GPT-3.5-16K | 0.82 | 0.58 |
| XVERSE-13B | 0.68 | 0.53 |
| Qwen-14B | 0.59 | 0.21 |

**Definition:** "Simulation hallucination" = tendency to provide answers based on training knowledge rather than profile information, violating believability.

**Example:** Homer Simpson's religious affiliation not mentioned in profile → GPT-3.5 infers "Christian" based on Caucasian ethnicity rather than answering "not enough information."

### 3. Poor Robustness to Profile Perturbations

**Key observations:**
- Better consistency ≠ better robustness
  - Example: Vicuna-13B-16K (CA: 0.621) worse robustness than Vicuna-7B-16K (CA: 0.457)
  - Vicuna-13B RCoV: 0.024 vs. Vicuna-7B RCoV: 0.006
- Open-source models particularly vulnerable
  - LongChat-7B-32K: RCoV = 0.118, RA = 0.047 (perturbations impact performance by 11.8%)

**Correlation across perturbation types:**

| Variant Pair | RCoV Correlation | RA Correlation |
|--------------|------------------|----------------|
| Age & Education | 0.91** | 0.82** |
| Age & Surname | 0.76** | 0.57** |
| Education & Surname | 0.92** | 0.85** |

(** p < 0.01)

→ Models show similar robustness weaknesses across different perturbation types, suggesting a general limitation.

### 4. Demographic Bias in Profiles

Models exhibit preferences for specific demographic factors:

**Race preference (8/10 models):** Caucasian profiles → higher CA
**Age preference (5/10 models):** Birth year 2000 → higher CA
**Surname preference:** Bedonie surname → higher CA across multiple models
**Education preference:** Bachelor's degree → higher CA

→ Suggests corpus bias propagating across models trained on overlapping data.

## Important Concepts & Definitions

### Believability in AI Agents
The quality that allows users to "suspend their disbelief" when interacting with AI, crucial for:
- Prototyping social theories
- Generating synthetic research data
- Building non-player characters (NPCs)
- Social simulations

### Simulation Hallucination
When LLMs generate responses based on training knowledge or stereotypes rather than adhering strictly to the provided character profile, undermining believability. Analogous to factual hallucination but in character simulation context.

### Profile Perturbation
Systematic modification of demographic factors (age, race, surname, education) in character profiles to test robustness of simulated behaviors.

### Consistency (CA)
The extent to which LLM-generated behaviors accurately depict all information in the character profile (identity, social roles, relationships).

### Robustness (RA, RCoV)
The ability of LLM behaviors to remain stable when faced with minor perturbations to the character profile.

## Formulas & Metrics

### Consistency Ability (CA)
$$CA = \frac{\text{Number of correctly answered questions}}{\text{Total number of questions}}$$

### Robustness Ability (RA)
$$RA = \sigma$$
where σ is the standard deviation of CA scores across profile variants (e.g., different ages: 10, 15, 20, 25, 30).

### Robustness Coefficient of Variation (RCoV)
$$RCoV = \frac{RA}{\mu} = \frac{\sigma}{\mu}$$
where μ is the mean CA score across variants.

**Interpretation:** RCoV quantifies the proportional impact of robustness on actual performance. Lower RCoV = more robust.

**Example:**
- LLM A: RA = 0.04, μ = 0.3 → RCoV = 0.13
- LLM B: RA = 0.08, μ = 0.9 → RCoV = 0.089
- Despite higher RA, LLM B has better robustness (lower proportional impact)

## Results & Statistics

### Main Performance Results

**Consistency by Question Type (GPT-4):**
- Immutable Characteristic (Known): 1.00
- Immutable Characteristic (Unknown): 0.47
- Social Role (Known): 1.00
- Social Role (Unknown): 0.59
- Relationship (Known): 0.97
- Relationship (Unknown): 0.06

**Robustness Results (Age Variants):**
| Model | RCoV | RA | Mean CA |
|-------|------|-----|---------|
| GPT-4 | 0.01 | 0.007 | 0.757 |
| GPT-3.5-16K | 0.014 | 0.01 | 0.70 |
| LongChat-7B-32K | 0.118 | 0.047 | 0.398 |
| Vicuna-13B-16K | 0.024 | 0.015 | 0.621 |

**Statistical Significance:**
- All correlation coefficients between variant types significant at p < 0.01
- Demonstrates systematic robustness issues across perturbation types

### Profile Length Impact
- SimulateBench average: 3,277 tokens/profile
- Park et al. (2023) Generative Agents: ~203 tokens/profile
- **16x more comprehensive** profile information

### Dataset Scale
- 65 characters total
- 8,400 total questions
- ~129 questions per character
- 4 demographic perturbation factors
- Multiple variants per factor (e.g., 5 age values, 6 races, 20 surnames)

## Influential Factors Analysis

### 1. Profile Information Position
**Experiment:** Reversed profile order (Social Role → Relationship → Immutable Characteristic)

**Results (Immutable Characteristic questions):**
- Open-source models: Significant improvement with Immutable Characteristic at end
  - ChatGLM2-6B-32K: 0.68 → 0.73 (Known), 0.21 → 0.32 (Unknown)
- Commercial models: Minimal change
  - GPT-4: 1.00 → 0.95 (Known), 0.47 → 0.47 (Unknown)

**Implication:** Open-source models struggle with long context even with sufficient context window; information position matters.

### 2. Reasoning Prompting Techniques
**Tested:** Zero, Zero+CoT, Few, Few+CoT, Few+Self-Ask

**Key finding:** No single prompting strategy consistently improves all models.

**Counterintuitive results:**
- Some open-source models (Qwen-14B, Vicuna series) perform **better** in Zero than Few-shot
- Analysis revealed models copying examples verbatim in Few-shot setting
- CoT/Self-Ask designed for reasoning tasks; simulation requires different abilities (profile comprehension, relationship dynamics)

### 3. Demographic Factor Preferences
**Systematic bias patterns across models:**
- Birth year 2000: 5/10 models show preference
- Caucasian race: 8/10 models show preference
- Bedonie surname: consistent higher performance
- Bachelor's degree: consistent higher performance

**Hypothesis:** Overlapping training corpora lead to shared biases.

### 4. Simulation Hallucination via Anonymization
**Experiment:** Replace character surname with common surnames from different ethnic backgrounds (Keams, Bedonie, Nguyen)

**Result:** Most models' Unknown question accuracy increased or stayed same after anonymization

**Example (GPT-3.5-Turbo-16K):**
- Original surname "Simpson" → answers religious affiliation as "Christian" (incorrect)
- Surname "Keams" or "Bedonie" → correctly answers "not enough information"

**Interpretation:** Models leverage world knowledge about famous characters (Homer Simpson) rather than strictly using profile.

## Limitations

### Acknowledged by Authors
1. **Profile Completeness:** Despite 16x improvement over prior work, profiles may still be insufficient for fully accurate simulation
2. **Model Coverage:** Some commercial models (e.g., Claude from Anthropic) not evaluated due to access restrictions requiring qualification audits
3. **Character Diversity:** 65 characters from 4 TV shows may not represent full diversity of human profiles
4. **Language Focus:** Evaluation conducted in English only

### Methodological Considerations
1. **Question Generation:** GPT-4 generated questions may have biases
2. **Multiple Choice Format:** May not capture full spectrum of believable behavior
3. **TV Character Bias:** Characters from fiction may have different information density than real people
4. **Temporal Scope:** Models evaluated at specific versions; rapid LLM development may date findings

## Relevance to Thesis

This paper is **highly central** to a thesis on believable LLM-based agents for several reasons:

### Direct Evaluation Framework
SimulateBench provides a concrete, systematic methodology for evaluating believability across two critical dimensions (consistency and robustness) that can be adapted or referenced for NSP agent evaluation.

### Comprehensive Character Representation
The Profile Descriptive Framework (Immutable Characteristics, Social Roles, Relationships) offers a structured approach to character modeling that could inform NSP agent design, particularly for representing patient profiles comprehensively.

### Identifying Critical Gaps
The paper reveals fundamental limitations in current LLMs:
1. **Long context processing** - relevant for NSP agents needing rich patient histories
2. **Profile hallucination** - critical safety concern for healthcare applications
3. **Robustness to perturbations** - essential for agents dealing with evolving patient information

### Methodological Contributions
- **Known vs. Unknown questions** - brilliant design for detecting hallucination that could apply to medical knowledge boundaries
- **Profile perturbation testing** - methodology applicable to testing NSP agents with varying patient demographics
- **Multi-dimensional metrics** (CA, RA, RCoV) - quantitative framework for believability

### Practical Implications
- Commercial models (GPT-4, GPT-3.5) significantly outperform open-source → cost-benefit considerations for NSP deployment
- Context window size alone insufficient → architectural improvements needed
- Prompting techniques (CoT, Few-shot) show limited value for simulation tasks → suggests need for specialized training/fine-tuning

### Connection to Thesis Research Questions
- **Believability evaluation:** Provides validated benchmark approach and metrics
- **LLM architectural choices:** Evidence that model selection critically impacts consistency/robustness
- **Profile design:** Demonstrates importance of comprehensive character information (3,277 vs. 203 tokens)
- **Bias and fairness:** Reveals demographic biases that would be unacceptable in healthcare settings

## Notable Quotes

> "In recent years, AI has demonstrated remarkable capabilities in simulating human behaviors, particularly those implemented with large language models (LLMs). However, due to the lack of systematic evaluation of LLMs' simulated behaviors, the believability of LLMs among humans remains ambiguous." (Abstract)

> "Current LLMs cannot effectively process long input context... This could impede LLMs from capturing crucial information about characters in the profile, as the provided profile is usually long and complex." (p. 1)

> "LLMs lack robustness when confronted with perturbation to the input... This could result in varying behaviors in the same scenarios." (p. 2)

> "When the available information in the profile is insufficient to address the query, these models tend to provide nonsensical responses rather than adhering to the prescribed profile, undermining their believability." (p. 5-6)

> "Models that exhibit strong consistency performance may yet demonstrate inadequate robustness performance." (p. 6)

> "Better consistency performance does not necessarily mean better robustness performance." (p. 6)

> "Although equipped with a longer context size of 32k, the performance of the Longchat-7B-32K(32K) is worse than the GPT-4(8K)... This implies that increasing the size of the context window does not necessarily result in improved consistency performance." (p. 5)

> "We refer to the phenomenon as simulation hallucination... inspired by the definition of hallucination." (p. 6)

## References to Follow Up

### Cited Foundational Work
1. **Park et al. (2023)** - "Generative Agents: Interactive Simulacra of Human Behavior" - seminal work on LLM-based agents, provides baseline for comparison
2. **Aher et al. (2023)** - "Using large language models to simulate multiple humans and replicate human subject studies" - Turing Experiment methodology
3. **Ortony et al. (2003)** - "On making believable emotional agents believable" - theoretical foundation for believability concept

### Relevant Evaluation Work
4. **Rao et al. (2023)** - Personality trait understanding in LLMs
5. **Huang et al. (2023)** - "ChatGPT an ENFJ, Bard an ISTJ: Empirical study on personalities of large language models"
6. **Jiang et al. (2023)** - "PersonalLLM: Investigating the ability of GPT-3.5 to express personality traits"

### LLM Robustness & Context
7. **Liu et al. (2023)** - "Lost in the middle: How language models use long contexts" - explains context processing limitations
8. **Perez & Ribeiro (2022)** - "Ignore previous prompt: Attack techniques for language models" - robustness to input perturbations

### Application-Oriented
9. **Qian et al. (2023)** - "Communicative agents for software development" - multi-agent LLM systems
10. **Zhang et al. (2023)** - "Siren's song in the AI ocean: a survey on hallucination in large language models" - comprehensive hallucination taxonomy

## Tags

`#believability` `#llm` `#agents` `#evaluation` `#benchmark` `#consistency` `#robustness` `#human-behavior-simulation` `#profile-modeling` `#hallucination` `#character-simulation` `#social-roles` `#relationships` `#perturbation-testing` `#demographic-bias` `#gpt4` `#open-source-llms` `#context-window` `#prompting-strategies` `#simulatebench` `#npc` `#social-simulation` `#believable-agents`
