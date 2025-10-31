# Evolving to be Your Soulmate: Personalized Dialogue Agents with Dynamically Adapted Personas

**Authors:** Yi Cheng, Wenge Liu, Kaishuai Xu, Wenjun Hou, Yi Ouyang, Chak Tou Leong, Wenjie Li, Xian Wu, Yefeng Zheng  
**Year:** 2024  
**Citation Key:** `chengEvolvingBeYour2024`  
**Affiliations:** The Hong Kong Polytechnic University, Jarvis Research Center (Tencent YouTu Lab), Baidu Inc.

## Abstract / Overview

This paper introduces **Self-evolving Personalized Dialogue Agents (SPDA)**, a novel paradigm where dialogue agents continuously evolve their personas during conversations to better align with user expectations. Unlike traditional static persona approaches that preset agent personas before deployment, SPDA dynamically adapts persona attributes in real-time based on emerging user information, enabling superior personalization and long-term engagement.

## Key Research Questions

1. How can dialogue agents dynamically adapt their personas during conversations to align with user expectations?
2. What mechanisms ensure smooth transitions when adapting agent personas without causing inconsistencies?
3. Can dynamically adapted personas improve personalization, affinity, and naturalness compared to static persona assignments?
4. How should persona adaptation balance immediate attribute-level matching with comprehensive profile-level refinement?

## Methodology

### Framework Architecture
The SPDA framework consists of four main components:

1. **User Persona Attribute Detection**
   - Continuously monitors dialogue for new user persona information
   - Uses GPT-3.5 with few-shot prompting
   - Categorizes detected attributes into predefined categories (occupation, hobbies, personality, etc.)

2. **Attribute-level Persona Adaptation**
   - Matches each detected user attribute with corresponding agent attribute
   - Uses transformer-based conditional variational autoencoder (CVAE)
   - Performs compatibility checks to ensure smooth transitions
   - Identifies "inadaptable" attributes already expressed in dialogue history

3. **Profile-level Persona Adaptation**
   - Operates periodically every k=4 turns
   - Globally refines entire agent persona by adding authentic details
   - Implemented with Llama-3-8B fine-tuned using:
     - Supervised Fine-Tuning (SFT)
     - Direct Preference Optimization (DPO) with GPT-4 as preference judge
   
4. **Persona-Grounded Utterance Generation**
   - Generates responses based on adapted persona
   - Tested with multiple base models (BlenderBot, Llama-3-8B, Gemini-1.0, GPT-3.5)

### Persona Definition Structure
- **Persona Categories:** Gender, Age, Location, Occupation, Education, Family Relationships, Routines/Habits, Goals/Plans, Social Relationships, Personality Traits, Other Experiences
- **Persona Attributes:** Short text descriptions (avg. 6-8 words) within each category
- Taxonomy based on Dunbar et al. (1997) and Xiao et al. (2023)

### Dataset and Training
- **Base Dataset:** ESConv (Emotional Support Conversations)
  - 910/195/195 train/val/test conversations
  - Average 23.4 dialogue turns per conversation
- **Constructed Dataset:**
  - 3,635/725/729 attribute-level matching samples (train/val/test)
  - 1,863/420/378 profile-level adaptation samples (train/val/test)
  - Average 10.33 seeker attributes, 10.46 supporter attributes per persona

### Experimental Settings
**Base Models Tested:**
- Fine-tuned: BlenderBot, Llama-3-8B-Instruct (SFT)
- Zero-shot: Llama-3-8B-Instruct, Gemini-1.0-pro, GPT-3.5-turbo

**Persona Settings Compared:**
1. **w/o Persona:** No persona grounding
2. **Supporter:** Uniform professional counselor persona for all dialogues
3. **Pre-Match:** Static persona matched before dialogue starts (Tu et al., 2023)
4. **Ours:** Dynamically adapted SPDA framework

## Key Findings

### 1. Consistent Performance Improvements Across Models
- SPDA framework improved performance across all five base models tested
- Most significant gains in language diversity (D-1/2/3 metrics) and personalization (P-Cover, A-Cover)
- Improvements more pronounced in zero-shot LLMs vs. fine-tuned models (likely due to overfitting in fine-tuned models)

### 2. Superior Human Evaluation Results
Interactive evaluation with simulated seeker agents showed SPDA outperformed baselines:
- **vs. w/o Persona:** 66.4% win rate (Naturalness), 85.9% (Affinity), 32.8% (Personalization)
- **vs. Supporter:** 54.7% (Naturalness), 54.7% (Affinity), 59.4% (Personalization)
- **vs. Pre-Match:** 58.6% (Naturalness), 55.5% (Affinity), 57.0% (Personalization)

### 3. Progressive Persona Alignment
- Persona alignment scores improve progressively throughout conversations
- Pre-Match performs best initially but is surpassed by SPDA after turn 4
- Demonstrates that pre-chat surveys provide insufficient information for optimal persona matching

### 4. Hierarchical Adaptation Benefits
Ablation study (GPT-3.5 base):
- **Profile-level DPO** crucial for diversity (D-3: 51.18 vs 46.18 without)
- **Attribute-level** enables responsive, lightweight matching
- **Combined framework** achieves optimal performance (D-3: 52.17, P-Cover: 3.108, A-Cover: 2.950)

### 5. Enhanced Personalization Metrics
SPDA with GPT-3.5 achieved:
- BLEU-1: 5.34 (vs 4.17 w/o persona)
- Distinct-3: 52.17 (vs 46.21 w/o persona)
- P-Cover: 3.108 (vs 2.883 w/o persona)
- A-Cover: 2.950 (vs 2.627 w/o persona)

## Important Concepts & Definitions

### Self-evolving Personalized Dialogue Agents (SPDA)
A paradigm where dialogue agents continuously adapt their personas during conversations to progressively align with user expectations, as opposed to static persona assignment.

### Persona Alignment
The process of adapting an agent's persona to better match user anticipation, achieved progressively as user information gradually unfolds during dialogue.

### Smooth Transition
Ensuring persona adaptations do not cause inconsistencies by tracking "inadaptable" attributes (those already expressed in dialogue) and performing compatibility checks.

### Attribute-level Adaptation
Lightweight, prompt persona matching that pairs newly detected user attributes with corresponding agent attributes in the same category.

### Profile-level Adaptation
Periodic global refinement of the entire agent persona by adding authentic details to create comprehensive, human-like descriptions.

### Persona Coverage Metrics
- **A-Cover (Attribute-level):** Maximum IDF-weighted word overlap between generated utterance and any persona attribute
- **P-Cover (Profile-level):** IDF-weighted word overlap between all generated responses and entire persona

### Inadaptable Attributes
Persona attributes already manifested in dialogue history that cannot be modified without causing inconsistencies.

## Formulas & Metrics

### Persona Alignment Score
Measures similarity between evaluated persona P and ground-truth persona P̃:

```
PA(P, P̃) = (1/l) Σ(i=1 to l) AA(aᵢ, P̃)

AA(aᵢ, P̃) = max_{ãⱼ ∈ P̃} IDF-O(aᵢ, ãⱼ)
```

Where:
- l = number of attributes in P
- IDF-O = IDF-weighted word overlap
- AA = attribute alignment score

### Attribute-level Coverage (A-Cover)
```
A-Cover(y, P) = max_{ãⱼ ∈ P̃} IDF-O(y, ãⱼ)
```
Where y is the generated response.

### Profile-level Coverage (P-Cover)
```
P-Cover(R, P) = IDF-O(R, P)
```
Where R is the set of all generated responses in a dialogue.

### Evaluation Metrics Used
- **NLG Metrics:** BLEU-1/2/3, ROUGE-L
- **Diversity:** Distinct-1/2/3 (vocabulary uniqueness)
- **Personalization:** P-Cover, A-Cover

## Results & Statistics

### Quantitative Results (GPT-3.5 Base Model)

| Metric | w/o Persona | Supporter | Pre-Match | SPDA (Ours) |
|--------|-------------|-----------|-----------|-------------|
| BLEU-1 | 4.17 | 5.08 | 4.89 | 5.34 |
| BLEU-2 | 2.31 | 2.54 | 2.51 | 2.78 |
| BLEU-3 | 16.28 | 18.15 | 18.27 | 18.47 |
| ROUGE-L | 14.16 | 14.02 | 14.17 | 14.21 |
| Distinct-1 | 5.38 | 5.83 | 5.84 | 6.12 |
| Distinct-2 | 26.67 | 27.41 | 26.91 | 29.24 |
| Distinct-3 | 46.21 | 48.94 | 48.56 | 52.17 |
| P-Cover | 2.883 | 3.056 | 3.029 | 3.108 |
| A-Cover | 2.627 | 2.853 | 2.821 | 2.950 |

### Ablation Study Results

| Component | D-3 | P-Cover | A-Cover |
|-----------|-----|---------|---------|
| w/o Persona | 46.21 | 2.883 | 2.627 |
| + Profile-level-SFT | 46.18 | 3.030 | 2.821 |
| + Profile-level-DPO | 51.18 | 3.058 | 2.832 |
| + Attribute-level | 51.60 | 3.076 | 2.894 |
| Full SPDA | 52.17 | 3.108 | 2.950 |

### Human Evaluation Win Rates
SPDA achieved majority preference across all dimensions:
- **Naturalness:** 54.7-66.4% wins vs baselines
- **Affinity:** 55.5-85.9% wins vs baselines  
- **Personalization:** 32.8-59.4% wins vs baselines

Strongest performance against w/o Persona baseline (85.9% win rate for affinity), demonstrating critical importance of appropriate persona grounding in emotional support contexts.

### Training Details
- **Attribute-level matching:** Transformer-based CVAE, 10 epochs
- **Profile-level SFT:** Llama-3-8B with LoRA, 2 epochs
- **Profile-level DPO:** 4 epochs with n=4 candidates, GPT-4 preference annotations
- **Adaptation frequency:** Every k=4 dialogue turns
- **Hardware:** 2× NVIDIA RTX A6000
- **Training time:** ~7 hours total (1h attribute + 2h SFT + 4h DPO)

## Limitations

### Acknowledged by Authors
1. **Limited Long-term Analysis:** Experiments conducted on ESConv with average 23.4 turns; real-world long-term scenarios (100+ turns) not explored
2. **Persona Information Management:** No solution provided for managing growing persona information in extended conversations
3. **Adaptation Efficiency:** Time/resource costs for persona adaptation not thoroughly analyzed, which could impact user experience
4. **Dataset Scope:** Only tested on emotional support conversations; generalization to other domains not validated
5. **Evaluation Scale:** Human evaluation limited to simulated conversations; real user studies not conducted

### Additional Observations
- Fine-tuned models show less improvement than zero-shot LLMs, suggesting overfitting issues
- Compatibility checking relies on LLM-based verification, which may have edge cases
- Framework complexity introduces multiple LLM calls, potentially increasing latency

## Relevance to Thesis

This paper is **highly relevant** to research on believable LLM-based agents, particularly for NSP (Next Sentence Prediction) applications requiring sustained user engagement.

**Key connections:**

1. **Believability through Dynamic Adaptation:** SPDA addresses a fundamental limitation of static personas—they cannot adapt to individual users. The dynamic evolution mechanism creates more believable interactions by demonstrating contextual awareness and personal growth, core aspects of believable agent behavior.

2. **Personalization as Believability Metric:** The paper operationalizes personalization through concrete metrics (P-Cover, A-Cover) and demonstrates that tailored personas significantly improve perceived naturalness and affinity—both central to believability evaluations.

3. **Hierarchical Persona Architecture:** The two-level adaptation (attribute + profile) provides a practical framework for balancing consistency (through inadaptable attributes) with responsiveness (through attribute-level matching)—a key challenge in maintaining believable agent behavior over time.

4. **Evaluation Methodology:** The interactive evaluation with simulated agents and human assessment across Naturalness, Affinity, and Personalization dimensions offers a reusable framework for evaluating believable agent systems.

5. **LLM-based Implementation:** Demonstrates effective use of modern LLMs (GPT-3.5, Llama-3, Gemini) for persona modeling and adaptation, showing that LLM-based agents can leverage these architectures for improved believability.

**Methodological relevance:**
- Persona structure taxonomy (11 categories) provides concrete framework for agent characterization
- Compatibility checking mechanism addresses consistency maintenance
- DPO training approach shows how to align persona adaptation with human preferences

**Theoretical contribution:**
- Challenges static persona paradigm dominant in prior work
- Demonstrates that persona-user alignment improves progressively through interaction
- Shows pre-dialogue matching is insufficient compared to dynamic adaptation

This work directly informs thesis chapters on agent architecture design, personalization mechanisms, and evaluation frameworks for believable behavior.

## Notable Quotes

> "To the best of our knowledge, we are the first to explore SPDA, a new self-evolving paradigm for personalized dialogue agents." (p. 2)

> "A significant aspect that has not received adequate attention is how to craft an appropriate persona for the agent that can align with the target user's anticipation." (p. 1)

> "A well-suited persona can create an identity that the user can connect with, thereby fostering familiarity and trust." (p. 1)

> "Any adjustments made to the agent's persona should not cause inconsistencies. For example, in Figure 1, the agent has already stated that they are a 'software engineer', so their occupation does not allow any arbitrary modifications later." (p. 2)

> "In essence, it means that the agent's persona is dynamically adaptable. Compared to the static persona paradigm, such a self-evolving manner could elicit better personalization, long-term engagement, and deeper user connections." (p. 2)

> "We find that the responses from LLMs without persona grounding are usually very impersonal and are more inclined to provide helpful suggestions rather than emotional caring to the seeker." (p. 10, Discussion section)

> "Grounding the LLM on an appropriate persona in those scenarios demanding affinity with the user" is critical for emotional support contexts. (p. 10)

> "SPDA shows potential in advancing the longstanding vision of conversational AI serving as enduring virtual companions for humans." (p. 11, Conclusion)

## References to Follow Up

1. **Zhang et al. (2018) - Persona-Chat Dataset:** Foundational work on persona-based dialogue that introduced the concept of grounding agents on textual profiles. Original dataset construction methodology.

2. **Park et al. (2023) - Generative Agents:** While not explicitly cited, this represents parallel work on dynamic agent personas in simulation contexts that could provide complementary insights on long-term persona evolution.

3. **Xiao et al. (2023) - Believability Evaluation Framework:** Cited for persona taxonomy; likely contains evaluation methodologies for assessing believable agent behavior that would complement this work's approach.

4. **Tu et al. (2023) - CharacterChat:** Referenced as baseline for pre-matching approach; explores personalized social support with static persona assignment, useful for comparison.

5. **Zhong et al. (2024) - MemoryBank:** Cited in conclusion as promising direction for continuous memory updates to enhance long-term engagement—directly relevant to extending SPDA.

6. **Liu et al. (2021) - ESConv Dataset:** Source dataset for emotional support conversations; contains guidelines and strategies that inform evaluation criteria.

7. **Fang et al. (2021) - Conditional VAE for Controllable Generation:** Technical foundation for attribute-level matching; addresses one-to-many persona matching problem.

## Tags

`#believability` `#llm` `#agents` `#personalization` `#dialogue-systems` `#persona-adaptation` `#emotional-support` `#dynamic-agents` `#self-evolving` `#user-alignment` `#evaluation-metrics` `#hierarchical-adaptation` `#cvae` `#dpo` `#consistency-maintenance` `#long-term-engagement`
