# Planning in the Dark: LLM-Symbolic Planning Pipeline without Experts

**Authors:** Sukai Huang, Nir Lipovetzky, Trevor Cohn  
**Year:** 2024  
**Citation Key:** huangPlanningDarkLLMSymbolic2024  
**Affiliation:** University of Melbourne, Australia

## Abstract / Overview
This paper proposes a novel LLM-symbolic planning pipeline that eliminates the need for expert intervention in action schema generation and validation. The approach constructs an action schema library with multiple candidates to capture diverse interpretations of natural language descriptions, then uses semantic validation and automatic ranking to filter and prioritize schemas and plans without human-in-the-loop.

## Key Research Questions
- Can we eliminate expert intervention from LLM-symbolic planning pipelines while maintaining plan quality?
- How can we address the inherent ambiguity in natural language task descriptions systematically?
- Can semantic similarity between natural language and symbolic representations be leveraged for automatic validation?

## Methodology

### Three-Step Pipeline Architecture

**Step 1: Building a Diverse Schema Library**
- Deploy multiple LLM instances (N instances) with high temperature settings to encourage diversity
- Each instance generates complete sets of action schemas for all M actions in a domain
- Aggregate schemas into a library, creating approximately $N^M$ possible schema set combinations
- Addresses the exponentially low probability of single LLMs generating solvable schemas (e.g., 0.00003125% with p=0.05, M=5)

**Step 2: Semantic Coherence Filtering**
- Uses sentence encoders to compute cosine similarity between natural language descriptions E(Z(α)) and generated schemas E(α̂)
- Applies Conformal Prediction (CP) framework to calculate threshold q̂ at confidence level 1-ε
- Filters out schemas with similarity scores below threshold
- Reduces combinations from $N^M$ to $\prod_{i=1}^{M} m_i$ where $m_i$ is the number of passing schemas per action
- Fine-tunes sentence encoder (all-roberta-large-v1) with triplet loss using:
  - **Easy negatives**: schemas from other domains
  - **Semi-hard negatives**: schemas from same domain, different actions
  - **Hard negatives**: manipulated versions with predicate swaps, negations, removals, or mutex additions

**Step 3: Plan Generation and Ranking**
- Feeds solvable schema sets into symbolic planner (DUAL-BWFS)
- Ranks generated plans by cumulative semantic similarity: $\sum_{i=1}^{M} \frac{E(Z(\alpha_i)) \cdot E(\hat{\alpha}_i)}{\|E(Z(\alpha_i))\| \|E(\hat{\alpha}_i)\|}$
- Returns multiple ranked plan candidates to user

### Experimental Setup
- **Test Domains**: Libraryworld (modified Blocksworld), Minecraft (resource gathering), Dungeon (navigation with monsters/traps)
- **LLM**: Open-source GLM-4-0520 (avoiding proprietary models for accessibility)
- **Symbolic Planner**: DUAL-BWFS (Best-First Width Search)
- **Baselines**: (1) Guan et al. (2023) expert-iterative pipeline, (2) Tree-of-Thought (ToT) direct LLM planning
- **Description Types**: (a) Detailed expert-written, (b) Ambiguous layman descriptions from 5 non-expert participants
- **Training**: 200K synthesized samples on NVIDIA A100 80GB, 11 hours training time

## Key Findings

### 1. Semantic Equivalence Validation (H1)
- Pre-trained sentence encoders (text-embedding-3-large, sentence-t5-xl) show higher cosine similarity for matched NL-schema pairs vs. mismatched
- Fine-tuning significantly improves hard negative discrimination (manipulated schemas)
- Supports Weaver's "common base of meaning" principle across representations

### 2. Ambiguity Generates Diversity (H2)
- Layman descriptions yield 2.35× more distinct solvable schema sets compared to detailed descriptions (8039 vs. 3419 with 10 LLMs, no CP)
- Example: In Libraryworld, some schemas include 'category' predicate for stacking books, others don't—reflecting different valid interpretations

### 3. Expert-Free Solvable Schema Generation (H3)
- **Without CP**: 10 LLM instances sufficient to generate solvable schemas across all test domains
- **With CP (ε=0.2)**: Reduces combinations to 3.3% of original (1051/31483) while increasing solvable ratio from 10.9% to 23.0%
- Probability of solvable set increases from <0.0001% (single LLM) to >95% (10 LLMs) under reasonable assumptions

### 4. Plan Quality Superiority (H4)
- **Human Evaluation**: 4 expert assessors ranked plans; proposed pipeline achieved average rank 2.97 vs. ToT's 3.58 (gold standard: 1.79)
- **Sussman Anomaly**: Pipeline successfully solved the problem with correct interleaved subgoal handling; ToT approaches (GLM, GPT-3.5, GPT-4o) all failed by attempting linear goal ordering

### 5. Efficiency Improvements
- CP filtering demonstrated 96.7% combination reduction in some cases (e.g., libraryworld detailed: 2160 → 60 solvable)
- Modern symbolic planners verify solvability in polynomial time via delete-free reachability
- AMD Ryzen 5900 (32 threads) can check 20,000 schema sets in 2 minutes; with CP, verification reduced to seconds

## Important Concepts & Definitions

**Action Schema Library**: A collection of action schemas generated by multiple LLM instances, where each complete "set" contains one schema per action in the domain. The library enables exploration of $N^M$ combinations.

**Solvable Schema Set**: A set of action schemas from which a symbolic planner can successfully generate at least one valid plan for a given problem instance.

**Semantic Equivalence Hypothesis**: Natural language descriptions and their corresponding symbolic PDDL representations should exhibit high semantic similarity when embedded in the same vector space, as they encode the same underlying meaning despite different syntactic forms.

**Conformal Prediction (CP)**: A statistical framework that guarantees true positive action schemas have probability ≥ 1-ε of being preserved while minimizing the filtered set size. Calculates empirical quantile threshold q̂ from calibration data.

**Hard Negative Samples**: Manipulated action schemas with subtle semantic differences (predicate swaps, negations, removals, mutex additions) used to enhance sentence encoder discrimination during fine-tuning.

**Sussman Anomaly**: A classical planning problem requiring interleaved subgoal handling—solving subgoals in the order they appear leads to undoing previous progress. Tests for true planning capability vs. linear reasoning.

## Formulas & Metrics

### Schema Library Size
- Total combinations: $\binom{N}{1}^M \approx N^M$ (where N = LLM instances, M = actions)
- After CP filtering: $\prod_{i=1}^{M} m_i$ (where $m_i$ = schemas passing threshold for action i)

### Probability of Solvable Set
$$P(\text{at least one solvable}) = 1 - (1 - p^M)^{N^M}$$
where p = probability of individual schema correctness

Example: N=10, M=5, p=0.05 → P = 1 - 0.0484 = **95.2%**

### Conformal Prediction Threshold
$$\hat{q} = \text{quantile}_{1-\epsilon}\left(\left\{\frac{E(Z(\alpha)) \cdot E(\alpha)}{\|E(Z(\alpha))\| \|E(\alpha)\|}\right\}_{n}\right)$$
where n = calibration set size, ε = significance level (typically 0.2)

Empirical quantile level: $\lceil (n+1)(1-\epsilon) \rceil / n$

### Plan Ranking Score
$$\text{RankScore} = \sum_{i=1}^{M} \frac{E(Z(\alpha_i)) \cdot E(\hat{\alpha}_i)}{\|E(Z(\alpha_i))\| \|E(\hat{\alpha}_i)\|}$$

### Triplet Loss (Fine-tuning)
Minimizes distance between anchor (NL description) and positive (true schema) while maximizing distance to negative samples (manipulated/mismatched schemas).

## Results & Statistics

### Schema Generation Performance (10 LLM instances, detailed descriptions, no CP)
| Domain | Total Combinations | Solvable | Distinct Plans | Avg. Plan Length |
|--------|-------------------|----------|----------------|------------------|
| Libraryworld | 86,400 | 4,560 (5.3%) | 7 | 6.57 |
| Dungeon | 2,800 | 2,099 (75.0%) | 5 | 4.0 |
| Minecraft | 5,250 | 3,598 (68.5%) | 4 | 3.0 |

### With Conformal Prediction (ε = 0.2, threshold = 0.398)
| Domain | Total Combinations | Solvable | Distinct Plans | Reduction |
|--------|-------------------|----------|----------------|-----------|
| Libraryworld | 2,160 | 60 (2.8%) | 2 | 97.5% ↓ |
| Dungeon | 48 | 36 (75.0%) | 3 | 98.3% ↓ |
| Minecraft | 945 | 630 (66.7%) | 2 | 82.0% ↓ |

### Layman Descriptions (10 LLMs, ambiguous inputs, no CP)
| Domain | Total Combinations | Solvable | Distinct Plans |
|--------|-------------------|----------|----------------|
| Libraryworld | 124,416 | 17,976 (14.4%) | 7 |
| Dungeon | 700 | 140 (20.0%) | 1 |
| Minecraft | 21,600 | 6,000 (27.8%) | 6 |

**Key observation**: Ambiguous descriptions → 2.35× more combinations (124,416 vs. 86,400 for Libraryworld)

### Human Evaluation Rankings (4 expert assessors, 24 problem instances)
| Approach | Rank 1st | Rank 2nd | Rank 3rd | Rank 4th | Rank 5th | Avg. Rank |
|----------|----------|----------|----------|----------|----------|-----------|
| Gold Standard | 14 | 4 | 4 | 1 | 1 | **1.79** |
| Proposed (Ours) | 4 | 18 | 11 | 5 | 10 | **2.97** |
| ToT | 3 | 6 | 12 | 14 | 13 | **3.58** |

Statistical significance: χ² test, p < 0.01

### Sussman Anomaly Results
| Model | Correct Plans | Best Heuristic Score (ToT) | Best Rank Score (Ours) |
|-------|---------------|----------------------------|------------------------|
| ToT GLM | 0/3 | 9.0 (incorrect) | - |
| ToT GPT-3.5 | 0/3 | 5.11 (incorrect) | - |
| ToT GPT-4o | 0/6 | 8.5 (incorrect) | - |
| **Ours GLM** | **7/7** | - | **0.788** |

Correct solution example:  
`remove-from-shelf(book3, book1) → take-from-table(book2) → place-on-shelf(book2, book3) → take-from-table(book1) → place-on-shelf(book1, book2)`

### Sentence Encoder Performance
- Pre-trained models (text-embedding-3-large, sentence-t5-xl): Matched pairs show 0.15-0.20 higher cosine similarity vs. mismatched
- After fine-tuning all-roberta-large-v1: Hard negative discrimination improved by 0.25 (cosine similarity units)
- Training: 200K samples, 40 epochs, batch size 256, 11 hours on A100 80GB

## Limitations

### Acknowledged by Authors

1. **No Direct Schema Quality Metrics**: Existing metrics like "bisimulation" or "heuristic domain equivalence" require fixed action parameters matching reference sets—incompatible with dynamically generated schemas from NL descriptions. New evaluation frameworks needed.

2. **Open-Source LLM Constraints**: Using GLM instead of GPT-4 increases accessibility but occasionally reduces solvability rates. With 7 LLM instances, occasional failures occurred in Libraryworld and Minecraft (resolved at 10 instances).

3. **Unexpected Human Preferences**: In Dungeon domain, assessors preferred ToT plans that included "grab sword" (unnecessary but strategically sensible), ranking them higher than optimal symbolic plans. Human evaluation may favor contextually reasonable actions over strict optimality.

4. **Computational Cost**: Generating and verifying $N^M$ combinations still requires significant compute (mitigated by CP filtering to 3-23% of original).

### Implicit Limitations

5. **Short-Horizon Focus**: Experiments focused on 3-7 step plans. While justified (schema quality matters more than length for hybrid approaches), scalability to 50+ step plans undemonstrated.

6. **Domain Leakage Risk**: Authors tested only on domains unlikely to be in LLM training data (Minecraft, Dungeon, Libraryworld)—generalization to truly novel domains uncertain.

7. **Single Language**: English-only; multilingual NL descriptions untested.

## Relevance to Thesis

This paper directly addresses critical challenges in creating believable LLM-based agents through automated planning without expert intervention. The work connects to multiple thesis dimensions:

**Key connections:**

1. **Automated Believability Evaluation**: The semantic coherence filtering mechanism (using sentence encoders + conformal prediction) provides a template for automated assessment of LLM agent outputs without human-in-the-loop—directly applicable to evaluating agent believability at scale.

2. **Handling Ambiguity in Agent Behavior**: The action schema library approach demonstrates how to systematically handle ambiguous natural language specifications by generating and ranking multiple valid interpretations. This is crucial for believable agents that must interpret vague user requests (e.g., "act friendly" can manifest in multiple valid ways).

3. **LLM-Symbolic Hybrid Architecture**: Demonstrates successful integration of LLMs (for NL understanding) with symbolic systems (for guaranteed soundness). This hybrid approach could inform agent architectures where believability requires both flexible interpretation and consistent rule-following.

4. **Evaluation Without Ground Truth**: The use of semantic similarity for automatic ranking without gold-standard plans parallels the challenge of evaluating believable agents without perfect behavioral models. The conformal prediction framework could adapt to agent action validation.

5. **Sussman Anomaly Insights**: The failure of even GPT-4o on interleaved planning reveals LLM limitations in complex reasoning—critical for understanding when believable agents need external cognitive scaffolding (memory, planning modules) vs. pure LLM generation.

**Methodological relevance:**  
- CO-STAR prompt engineering framework could structure agent personality/behavior prompts
- Triplet loss training with hard negatives (manipulated schemas) could train models to distinguish subtle behavioral variations in agents
- Multi-instance generation with diversity sampling mirrors need for varied agent responses to same context

**Theoretical contribution:**  
Validates Weaver's semantic equivalence hypothesis across NL↔symbolic representations, suggesting believability metrics could similarly leverage semantic similarity between agent behaviors and human expectations across modalities (text, action sequences, state changes).

## Notable Quotes

> "Unlike formal language designed to have an exact, context-independent meaning, natural language inherently contains ambiguities that yield diverse valid interpretations of the same description." (p. 2)

> "A single expert's interpretation of ambiguous natural language descriptions might not align with the user's actual intent." (p. 1)

> "Planning and reasoning tasks are typically associated with System 2 competency, which involves slow, deliberate, and conscious thinking... However, LLMs, being essentially text generators, exhibit constant response times regardless of the complexity of the question posed." (p. 2, citing Kambhampati et al. 2024)

> "By preserving the inherent ambiguity of natural language, [our approach] offers users multiple valid interpretations of the task and their corresponding plans." (p. 5)

> "Even with a 99% per-step accuracy, the probability of a correct 100-step plan plummets to 36.6%." (p. 16—on limitations of direct LLM planning)

> "The most effective way to translate between languages is to go deeper to uncover a shared 'common base of meaning' between language representations." (p. 4, paraphrasing Weaver 1952)

## References to Follow Up

1. **Guan et al. (2023)** - "Leveraging pre-trained large language models to construct and utilize world models for model-based task planning" (NeurIPS)  
   *Establishes baseline expert-iterative pipeline; reports 59 iterations for single domain correction*

2. **Kambhampati et al. (2024)** - "Position: LLMs Can't Plan, But Can Help Planning in LLM-Modulo Frameworks" (ICML)  
   *Critical analysis of LLM planning limitations; System 1 vs. System 2 reasoning distinction*

3. **Weaver (1952)** - "Translation" (Proceedings of the Conference on Mechanical Translation)  
   *Foundational work on semantic equivalence across language representations*

4. **Valmeekam et al. (2022, 2023)** - "PlanBench: An Extensible Benchmark for Evaluating Large Language Models on Planning and Reasoning" (NeurIPS)  
   *Critical evaluation of LLM planning capabilities; reveals hallucination and inconsistency issues*

5. **Liu et al. (2023)** - "LLM+P: Empowering Large Language Models with Optimal Planning Proficiency"  
   *Early hybrid LLM-symbolic approach combining language models with PDDL planners*

## Tags
`#llm-planning` `#symbolic-ai` `#hybrid-architecture` `#action-schemas` `#pddl` `#conformal-prediction` `#semantic-similarity` `#automation` `#expert-free` `#sentence-encoders` `#ambiguity-handling` `#evaluation-methodology` `#believability-relevant`
