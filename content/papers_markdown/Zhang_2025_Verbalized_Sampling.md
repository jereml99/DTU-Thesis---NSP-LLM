# Verbalized Sampling: How to Mitigate Mode Collapse and Unlock LLM Diversity

**Authors:** Jiayi Zhang, Simon Yu, Derek Chong, Anthony Sicilia, Michael R. Tomz, Christopher D. Manning, Weiyan Shi  
**Year:** 2025  
**Citation Key:** zhangVerbalizedSamplingHow2025

## Abstract / Overview

This paper identifies typicality bias in preference data as a fundamental cause of mode collapse in aligned LLMs and proposes Verbalized Sampling (VS), a training-free prompting method that asks models to generate a distribution of responses with probabilities. VS significantly improves diversity across creative writing, dialogue simulation, open-ended QA, and synthetic data generation without sacrificing factual accuracy or safety.

## Key Research Questions

- What is the fundamental, data-level cause of mode collapse in post-training aligned LLMs?
- Can mode collapse be mitigated at inference time without retraining?
- How can we unlock the diverse generative capabilities that LLMs learn during pre-training?
- Does increased diversity come at the cost of quality, accuracy, or safety?

## Methodology

**Theoretical Framework:**
- Formalized typicality bias using Bradley-Terry reward model: r(x,y) = r_true(x,y) + α log π_ref(y|x) + ϵ(x)
- Proved that typicality bias sharpens output distributions toward stereotypical completions
- Empirically verified typicality bias on HELPSTEER dataset (α = 0.57 ± 0.07 for Llama 3.1 405B Base)

**Verbalized Sampling Method:**
- Reformulates prompts to ask for distributions instead of single instances
- Example: "Generate 5 responses with their corresponding probabilities" instead of "Tell me a joke about coffee"
- Three variants tested: VS-Standard, VS-CoT (with chain-of-thought), VS-Multi (multi-turn)

**Experimental Setup:**
- Evaluated on 9 model families: GPT-4.1, Gemini-2.5, Claude-3.7/4, DeepSeek-R1, OpenAI o3, Llama-3.1-70B, Qwen3-235B
- Tasks: Creative writing (poem, story, joke), dialogue simulation (PersuasionForGood), open-ended QA (CoverageQA), synthetic data generation (GSM8K-style math)
- Baselines: Direct prompting, CoT, Sequence (list generation), Multi-turn
- Diversity metrics: Semantic (1 - mean pairwise cosine similarity), Lexical (ROUGE-L)
- Quality metrics: Claude-3.7-Sonnet as judge with task-specific rubrics

## Key Findings

1. **Mode Collapse is Data-Driven**: Typicality bias in preference data (α > 0) is a pervasive, fundamental cause—even perfect reward models and optimization cannot eliminate it.

2. **VS Dramatically Improves Diversity**:
   - Creative writing: 1.6-2.1× diversity increase over direct prompting
   - Recovers 66.8% of base model diversity (vs. 23.8% for direct prompting)
   - Poem task: diversity increases from 11.4% to 25.8% (VS-CoT)

3. **Quality is Maintained or Improved**:
   - VS-CoT improves human evaluation scores by 25.7% on creative writing
   - Factual accuracy on SimpleQA remains comparable to baselines (Top@1: 0.348 vs. 0.342 for CoT)
   - Safety refusal rate: 97.91% for VS-Multi vs. 98.22% for direct (minimal difference)

4. **Emergent Scaling Trend**: More capable models benefit more from VS—larger models (GPT-4.1, Gemini-2.5-Pro) show 1.5-2× greater diversity gains than smaller models

5. **Task-Specific Gains**:
   - Dialogue simulation: DeepSeek-R1 + VS matches fine-tuned Llama-3.1-8B on donation distribution alignment
   - Open-ended QA: KL divergence to pre-training distribution reduced from 14.43 to 3.22
   - Synthetic data: Math downstream accuracy improved from 32.8% to 37.5% when training on VS-generated data

6. **Tunable Diversity**: Unlike baselines, VS allows inference-time diversity tuning via probability thresholds in prompts

## Important Concepts & Definitions

- **Mode Collapse**: The phenomenon where aligned models favor a narrow set of responses over the full distribution, significantly reducing output diversity

- **Typicality Bias**: Human tendency to prefer familiar, fluent, and predictable text in preference annotations, rooted in:
  - Mere-exposure effect (Zajonc, 1968)
  - Processing fluency (Alter & Oppenheimer, 2009)
  - Availability heuristic (Tversky & Kahneman, 1973)
  - Schema congruity theory (Mandler, 2014)

- **Verbalized Sampling (VS)**: A prompting method that asks models to explicitly verbalize a distribution of responses with corresponding probabilities, recovering pre-training diversity

- **True Task Utility (r_true)**: The component of the reward function reflecting actual quality/correctness, independent of typicality

- **Reference Policy (π_ref)**: The base model (pre-alignment) used in RLHF optimization

## Formulas & Metrics

**Reward Model with Typicality Bias:**
```
r(x, y) = r_true(x, y) + α log π_ref(y | x) + ϵ(x)
```
where α > 0 indicates typicality bias weight

**Sharpened Distribution from RLHF:**
```
π*(y | x) ∝ π_ref(y | x)^γ exp(r_true(x, y) / β)
γ = 1 + α/β > 1 when α > 0
```

**Diversity Metrics:**
- Semantic diversity: `1 - mean(cosine_similarity(embeddings))` × 100%
- Lexical diversity: ROUGE-L (lower = more diverse)
- Distinct-N: Proportion of unique n-grams

**Alignment Metrics:**
- KL divergence: Measures deviation from reference distribution
- Coverage-N: Fraction of ground-truth answers covered in N samples
- Kolmogorov-Smirnov test: Distributional alignment

## Results & Statistics

**Creative Writing (averaged across models):**
- Poem diversity: Direct 11.4% → VS-CoT 25.8% (+127% improvement)
- Story diversity: Direct 22.2% → VS-CoT 38.2% (+72%)
- Joke diversity: Direct 30.0% → VS-Standard 62.5% (+108%)
- Human evaluation (4-point Likert scale): Direct 1.90 → VS-Standard 2.39 for poems (p < 0.001)

**Dialogue Simulation (PersuasionForGood):**
- DeepSeek-R1 + VS: KS test statistic comparable to fine-tuned Llama-3.1-8B
- Semantic diversity: GPT-4.1 Direct 0.06 → VS-Standard 0.15
- Distinct-1 scores approach human levels with VS

**Open-Ended QA (CoverageQA, N=100):**
- KL divergence from pre-training: Direct 14.43 → VS-Multi 3.22 (-78%)
- Coverage-N: Direct 0.10 → VS-Multi 0.71 (+610%)
- Precision maintained: 1.00 (Direct) → 0.96 (VS-Multi)

**Synthetic Data Generation:**
- Downstream math accuracy (Qwen2.5-7B trained on 1K synthetic examples):
  - Direct: 27.2% → VS-Multi: 34.8% (+28%)
  - MATH500: 44.4% → 55.4% (+25% with VS-Multi)

**Post-Training Ablation (Tulu-3 family):**
- Base model diversity: 45.4%
- After DPO: Direct 10.8%, VS-Standard 30.4%
- VS retains 66.8% of base diversity vs. 23.8% for direct

**Temperature Ablation:**
- VS + temperature scaling pushes Pareto front further
- VS-Standard at t=1.2 achieves better diversity-quality trade-off than baselines at any temperature

**Safety (StrongReject benchmark, 353 harmful prompts):**
- Refusal rate: Direct 98.22% → VS-Multi 97.91% (-0.31%, not significant)
- VS generates diverse refusal statements while maintaining safety alignment

## Limitations

1. **Scope of Evaluation**: Primarily tested on English language tasks; multilingual performance not extensively evaluated

2. **Computational Cost**: VS generates multiple candidates per call (k=5 typical), increasing inference cost vs. single-output methods, though still cheaper than training interventions

3. **Optimal k Selection**: Number of candidates (k) requires task-specific tuning; too large k degrades quality

4. **Probability Calibration**: Verbalized probabilities may not perfectly match true model probabilities; serves as relative ranking

5. **Base Model Dependency**: VS can only recover diversity present in the original pre-training distribution; cannot generate novel diversity beyond base model capabilities

6. **Limited Analysis on Reasoning Models**: While tested on DeepSeek-R1 and o3, deeper investigation into interaction with reasoning-specific training needed

7. **Proxy Metrics**: Used RedPajama as proxy for pre-training distribution; actual pre-training data distributions unknown for proprietary models

8. **Task Constraints**: Open-ended QA experiments excluded extremely low probability thresholds (p < 0.01) due to answer space constraints

## Relevance to Thesis

**Key connections to believable agents and LLMs:**

1. **Behavioral Diversity**: VS directly addresses a critical limitation for believable agents—mode-collapsed LLMs generate stereotypical, repetitive behaviors. Believable agents require diverse, context-appropriate responses that don't feel robotic.

2. **Simulation Realism**: PersuasionForGood results show VS enables LLMs to simulate human-like behavioral distributions (donation amounts, persuasion resistance patterns) without task-specific fine-tuning—crucial for believable agent architectures.

3. **Inference-Time Solution**: Unlike fine-tuning approaches that require retraining for each agent persona/context, VS is a lightweight prompting method compatible with API-based LLMs, making it practical for believable agent applications.

4. **Evaluation Framework**: The paper's multi-dimensional evaluation (diversity, quality, safety, behavioral alignment) provides a model for assessing believable agent outputs beyond simple accuracy metrics.

5. **Theoretical Foundation**: The typicality bias formalization explains why aligned LLMs struggle with believability—they're biased toward "safe" stereotypical outputs rather than contextually realistic ones. This informs design choices for agent architectures.

## Notable Quotes

> "Post-training alignment often reduces LLM diversity, leading to a phenomenon known as mode collapse. Unlike prior work that attributes this effect to algorithmic limitations, we identify a fundamental, pervasive data-level driver: typicality bias in preference data." (p. 1)

> "We find that mode collapse is an inherent property of preference data itself. We identify typicality bias, the human tendency to prefer more typical text, as a pervasive data-level cause for mode collapse." (p. 2)

> "Different prompts collapse to different modes. The modal response to a traditional instance-level prompt tends towards stereotypicality. By contrast, when prompted for a distribution in VS, the modal response tends to approximate the distribution learned during pre-training, recovering the diversity of the underlying base model." (p. 3)

> "Critically, this means that even with a perfect reward model and optimization process, inherent bias within preference datasets may still drive mode collapse, affecting the majority of alignment methods that rely on reward models." (p. 2)

> "We also observe an emergent trend that more capable models benefit more from VS. These results open up possibilities in real-world tasks such as richer exploration in RL, hypothesis generation, social simulation, and so on." (p. 3)

> "Our work shows that mode collapse can be mitigated at inference time, aligned models retain significant inherent diversity, and the quality-diversity trade-off can be systematically improved through prompting alone." (p. 14)

> "VS prompts the model to verbalize a probability distribution over a set of responses (e.g., 'Generate 5 jokes about coffee and their corresponding probabilities')." (p. 1)

## References to Follow Up

1. **Lu et al. (2025b)**: "Quantified this issue, showing that the creative capacity of LLMs diminishes after alignment" - relevant for understanding creativity loss in aligned models

2. **Padmakumar & He (2024); West & Potts (2025)**: Earlier observations of mode collapse in aligned models vs. base counterparts

3. **Wang et al. (2019)**: PersuasionForGood dataset - could be useful benchmark for evaluating believable persuasion behaviors

4. **Tian et al. (2023a); Xiong et al. (2024)**: Prior work on verbalizing knowledge/distributions for QA and reasoning tasks

5. **Meister et al. (2024)**: Survey simulations using LLMs - relevant for social simulation applications

6. **Cui et al. (2025); Wang et al. (2025)**: Recent emphasis on diversity in RL rollouts - VS could enhance exploration

7. **Kirk et al. (2024a)**: PRISM alignment dataset for pluralistic alignment - mode collapse relevant to representing diverse human values

8. **Ismayilzada et al. (2025)**: Creative Preference Optimization - alternative training-based approach to improving creativity

## Tags

`#llm` `#diversity` `#mode-collapse` `#prompting` `#creative-writing` `#dialogue-simulation` `#alignment` `#rlhf` `#believability` `#agents` `#typicality-bias` `#inference-time` `#evaluation` `#verbalized-sampling` `#synthetic-data`
