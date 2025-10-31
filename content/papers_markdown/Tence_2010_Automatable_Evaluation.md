# Automatable Evaluation Method Oriented toward Behaviour Believability for Video Games

**Authors:** Fabien Tencé, Cédric Buche  
**Year:** 2010  
**Citation Key:** `tenceAutomatableEvaluationMethod2010`  
**Institution:** Université Européenne de Bretagne - ENIB, LISyC - CERV

## Abstract / Overview
This paper proposes an automatable evaluation method for assessing agent believability in video games by measuring how much an agent's behavior resembles human behavior. Unlike traditional evaluation methods that require human judges for each assessment, this approach stores human behavior data as "signatures" (feature vectors) and compares agent signatures against them, enabling rapid iterative testing during development.

## Key Research Questions
- How can we evaluate believable agent behaviors without requiring extensive human evaluation for each iteration?
- Can agent believability be assessed by measuring behavioral similarity to humans rather than subjective judgment?
- What behavioral features (signatures) effectively distinguish human from non-believable agent behavior?
- Can this method serve as a complement to traditional human-based evaluation during development?

## Methodology

### Evaluation Protocol
**Four-stage process:**

1. **Define behavior signatures** - Create feature vectors representing behavioral aspects and define distance metrics
2. **Monitor humans** - Record multiple human players and compute behavioral signatures under controlled conditions
3. **Monitor agents** - Record agents under identical conditions and compute the same signatures
4. **Compute distances** - Measure dissimilarity between agent and human signatures

### Monitoring Approach
- **Observer perspective:** External view (perception-decision-action loop) rather than internal architecture
- **Data tracked:** Subset of perceptions and actions during gameplay
- **Three signature types:**
  - Perception-based (less useful for judgment)
  - Action-based (potentially too simple)
  - Perception-action linked (most promising for capturing decision patterns)

### Experimental Setup
**Game:** Unreal Tournament 2004 (First Person Shooter)  
**Focus:** Movement behavior only (simplified scope)

**Human participants:**  
- 6 low/medium skill players
- 20-minute deathmatch sessions
- Keyboard + mouse controls

**Agent evaluation:**  
- 8 agents with varying skill levels
- 6-agent matches in identical environment
- Same duration as human sessions

### Behavioral Signatures Designed

**1. Velocity Change Angle (20-dimensional vector)**
- Measures angle between velocity vectors at consecutive time steps (Vₜ and Vₜ₊₁)
- Each component i represents frequency of angle ≈ i (in units where 20 = full turn)
- Captures abruptness of direction changes
- Normalized vector

**2. Velocity Relative to Direction (20-dimensional vector)**
- Measures angle between velocity vector (Vₜ) and aiming direction (Dₜ)
- Indicates relationship between movement and where character is looking
- Detects patterns like strafing, backpedaling
- Normalized vector
- Z-component ignored to simplify without major information loss

**Time resolution:** 125ms between time steps

### Analysis Methods

**Principal Component Analysis (PCA):**
- Variance explained: 90.37% (velocity change), 78.18% (velocity-direction)
- Visualizes subjects in 2D space of principal components

**Earth Mover's Distance (EMD):**
- Addresses PCA limitation: considers that adjacent components (i, i±1) are more similar than distant ones
- Computes minimum "effort" to transform one signature distribution into another
- More semantically appropriate for circular/angular features

**Multidimensional Scaling (MDS):**
- Applied to EMD dissimilarity matrices
- Represents subjects as points where Euclidean distances approximate EMD distances
- Stress < 0.003 (excellent fit)

## Key Findings

### 1. **Clear Human-Agent Distinction (PCA Analysis)**
- Both signature types showed separable clusters: a line could distinguish humans from agents in PCA space
- Agents appeared ordered along first principal component, suggesting skill parameter has linear, artificial effect
- First PC for velocity change angle: negatively correlated with brutal angle changes; second PC: positively correlated with small changes
- First PC for velocity-direction: negatively correlated with backward movement; second PC: related to forward+sideways movement

### 2. **Skill Parameter Creates Artificial Ordering**
- Agents lined up sequentially in both PCA and MDS visualizations
- Skill levels create predictable, linear behavioral variations unlike human diversity
- As human efficiency increased, they moved away from agent cluster (velocity change angle)

### 3. **Behavioral Similarity at Global Level (EMD/MDS Analysis)**
- EMD-based analysis showed more overlap between humans and agents than PCA
- Global signature shapes were similar, suggesting superficial believability
- However, stricter PCA analysis revealed distinguishable patterns

### 4. **Control Mechanism Hypothesis**
- Agents don't replicate human input limitations (keyboard/mouse constraints)
- May produce human-like global behavior but reveal artificial precision under close inspection
- Suggests believability requires modeling human control imperfections, not just strategic patterns

### 5. **Simple Signatures Reveal Differences**
- Even basic movement signatures (2 vectors, 40 total dimensions) detected believability issues
- Demonstrates method's sensitivity despite limited scope

## Important Concepts & Definitions

### Believability (Dual Definitions)
1. **Role-playing believability** - Ability to convincingly play a character role
2. **Human-likeness believability** - Indistinguishability from human players (definition used in this paper)

### Behavior Signatures
**Feature vectors representing behavioral characteristics:**
- Should have low variance within human population
- Must be sensitive enough to detect non-believable behaviors
- Reusable across evaluations after initial human data collection
- Can be global (computed every time step) or contextual (computed when conditions met)

### Automatable Evaluation
**Evaluation requiring human involvement only once:**
- Steps 3-4 of protocol repeatable without humans
- Enables optimization algorithms and overnight testing
- "Automatable" ≠ "fast" (agents still need simulation time)
- Complements, doesn't replace, traditional human evaluation

### Suspension of Disbelief
**Goal for game agents (Bates 1992):**
- Agents should not break player immersion
- Requires believable behaviors matching player expectations

## Formulas & Metrics

### Velocity Change Angle Signature
```
S_vca[i] = count(angle(V_t, V_{t+1}) ≈ i) / total_steps
where i ∈ [0, 19], normalized
```

### Velocity Relative to Direction Signature  
```
S_vrd[i] = count(angle(V_t, D_t) ≈ i) / total_steps
where i ∈ [0, 19], normalized
```

### Earth Mover's Distance (EMD)
```
EMD(V1, V2) = minimum effort to transform distribution V1 → V2
```
Figuratively: minimum work to move "earth" from relief V1 to relief V2

### Distance Comparison Example (from paper)
| Comparison | EMD  | L2 (Euclidean) |
|------------|------|----------------|
| V1, V2     | 1.15 | 3.0            |
| V1, V3     | 1.15 | 9.6            |
| V2, V3     | 1.15 | 7.0            |

EMD correctly identifies V1-V2 similarity; L2 treats all as equally distant.

### Principal Component Analysis
- **Velocity change angle:** PCA axes explain 90.37% variance
  - PC1: negatively correlated with brutal angle changes
  - PC2: positively correlated with small angle changes
  
- **Velocity relative to direction:** PCA axes explain 78.18% variance
  - PC1: negatively correlated with backward/backward+sideways movement
  - PC2: positively correlated with forward+slightly sideways, negatively with forward+sideways

### Multidimensional Scaling Quality
- **Stress metric:** < 0.003 for both MDS representations
- Indicates excellent preservation of original dissimilarity structure

## Results & Statistics

### Experimental Parameters
- **Human participants:** n = 6 (low/medium skill)
- **Agent variants:** n = 8 (different skill levels)
- **Session duration:** 20 minutes (signatures stabilize after 15-20 min)
- **Time step resolution:** 125 ms
- **Signature dimensions:** 20 components × 2 signatures = 40 total features per subject

### Variance Explained
- **Velocity change angle PCA:** 90.37% (2 components)
- **Velocity-direction PCA:** 78.18% (2 components)
- Both sufficient for extracting meaningful patterns

### Separability
- **PCA space:** Linear separation possible between human and agent clusters
- **MDS/EMD space:** More overlap, suggesting global behavioral similarity
- **Implication:** Agents may pass casual inspection but fail detailed analysis

### Skill Ranking Effects
- Agents ordered linearly along first principal component in both analyses
- Human skill increases → movement away from agent cluster (velocity change)
- Suggests skill parameter doesn't capture natural human variation

## Limitations

### Acknowledged by Authors

1. **Simplified Signatures**
   - Only 2 signatures, focused solely on movement behavior
   - Insufficient for comprehensive believability evaluation
   - Many behavioral aspects (aiming, combat, item collection) not assessed

2. **PCA vs. EMD Interpretation Divergence**
   - PCA shows clear separation; EMD/MDS shows overlap
   - Difficult to determine which perspective is more relevant to human perception
   - Results analysis can be challenging

3. **Component Adjacency Not Captured by PCA**
   - Circular nature of angle measurements not reflected in PCA
   - Angle i is closer to i±1 than i±2, but PCA treats all dimensions independently
   - Motivated use of EMD as alternative metric

4. **Controlled vs. Natural Conditions**
   - Humans played together; agents played together (not mixed)
   - Concession necessary to avoid signature contamination from non-believable agents
   - May not reflect real gameplay scenarios

5. **Input Mechanism Confound**
   - Humans limited by keyboard/mouse control
   - Agents have perfect execution capabilities
   - Unclear if detected differences reflect strategic vs. motor control issues

6. **Signature Validation Needed**
   - No comparison to human perception sensitivity
   - Unknown if signatures detect what humans notice
   - Requires follow-up studies confronting this method with traditional evaluation

7. **Temporal Stabilization**
   - 20-minute duration based on observation, not rigorous testing
   - Optimal evaluation duration may vary by signature type or game

8. **Generalization Unknown**
   - Single game (UT2004), single game mode (deathmatch)
   - Applicability to other genres or gameplay styles not demonstrated

### Implicit Limitations

9. **Cold Start Problem**
   - Initial human data collection still required
   - Method only automatable after first round of human monitoring

10. **Context Sensitivity**
    - Global signatures may miss important contextual behaviors
    - Authors acknowledge need for contextual and temporal signatures in future work

11. **Ground Truth Ambiguity**
    - Human behavior variance creates unclear target
    - Some humans may be "less human-like" in their behavior patterns

## Relevance to Thesis

This paper is **highly relevant** to a thesis on believable LLM-based agents, as it addresses the fundamental challenge of evaluating agent believability in a scalable, automatable manner. The signature-based approach provides a methodological framework that could be adapted for evaluating LLM agents' behavioral outputs.

**Key connections:**

1. **Evaluation Methodology for Development Cycles**
   - LLM agents require extensive prompt engineering, parameter tuning, and architectural experimentation
   - This automatable approach enables rapid iteration without recruiting human evaluators for each test
   - Directly applicable to optimizing LLM agent prompts, memory architectures, or planning mechanisms

2. **Behavioral Feature Engineering**
   - The signature concept translates well to LLM agents: track patterns in dialogue choices, action sequences, personality consistency
   - Could define signatures for narrative coherence, emotional appropriateness, social intelligence
   - EMD metric particularly suitable for categorical/sequential LLM outputs (e.g., emotion categories, dialogue acts)

3. **Complementary to Turing-Test Approaches**
   - While Turing tests are ultimate validation, this method provides continuous feedback during development
   - Mirrors the distinction between formative (development-time) and summative (validation) evaluation
   - LLM agent research needs both: fast automated metrics for iteration, human studies for validation

4. **Human Behavior as Ground Truth**
   - Aligns with LLM agent goals: simulate human-like NPCs, conversational partners, or social entities
   - Collecting corpus of human player/user behaviors provides training signal and evaluation baseline
   - Addresses challenge of defining "believability" operationally rather than subjectively

5. **Limitations Inform LLM Agent Research**
   - Control mechanism confound parallels LLM "perfection" problem (no typos, perfect grammar, instant responses)
   - Suggests LLM agents may need deliberate imperfection modeling for believability
   - Skill parameter linearity mirrors potential issues with LLM temperature/sampling parameters

6. **Scalability for Multi-Agent Scenarios**
   - Method tested with 8 agent variants; LLM systems might explore dozens or hundreds of configurations
   - Automatable evaluation essential for large-scale LLM agent experiments (e.g., personality variations, memory capacities)

**Potential Applications to Thesis:**
- Design behavioral signatures for LLM agent dialogue (e.g., response time distributions, topic transition patterns, emotional arc shapes)
- Use EMD to compare LLM-generated conversation flows to human conversations
- Create contextual signatures for specific social scenarios (greetings, conflict, cooperation)
- Establish baseline human behavior corpus in target domain (game NPCs, customer service, educational tutors)
- Combine with LLM-specific metrics (perplexity, semantic similarity) for hybrid evaluation

**Theoretical Contribution:**
The paper's distinction between global behavioral similarity and fine-grained distinguishability is crucial for LLM agents. An agent might produce generally coherent dialogue (global signature match) while exhibiting subtle artificial patterns (PCA-detectable differences). This suggests multi-level evaluation frameworks for believability.

## Notable Quotes

> "Classic evaluation methods of believable agents are time-consuming because they involve many human to judge agents. They are well suited to validate work on new believable behaviours models. However, during the implementation, numerous experiments can help to improve agents' believability."

> "We aim at reducing human intervention as much as possible still helping researchers assessing artiﬁcial behaviours' believability. The objective is to have a method which could be automatised and thus which can be used in optimisation algorithms or for tests during the night."

> "Of course, this method does not aim at replacing classic ones but rather oﬀers a complementary approach so that the ﬁnal result looks more believable."

> "To be totally independent from the internal architecture, we chose to take the same point of view as a judge looking over the subject's shoulder. Therefore, in the well-known perception-decision-action loop we can only have access to the actions and the perceptions."

> "Perception-based signatures are not very useful because players judges agents on their actions. Action-based can be useful but may be too simple to explain complex behaviours. Finally, signatures linking actions to perceptions are the most interesting ones because they may ﬁnd patterns in the decisions."

> "It seems that the skill parameter which inﬂuence the agents' eﬃciency have a quite artiﬁcial eﬀect: agents are ordered on the ﬁrst principal component on both charts."

> "Evaluated agents do not copy those limitations [keyboard control], as a result, they may have a global human-like behaviour but they can be recognised if we look closely."

> "The proposed method seems promising as it could help in assessing the believability of a behaviour. Its main advantage is that it can evaluate a large number of agents, allowing ﬁner improvement of the models' parameters."

> "However, there is still some questions that should be answered: to what extent do humans notice variations in behaviours? and do signatures have the same sensitivity as humans?"

## References to Follow Up

1. **Bates, J. (1992)** - "The nature of characters in interactive worlds and the Oz project"
   - Foundational work on believability and suspension of disbelief
   - CMU-CS-92-200, Carnegie Mellon University

2. **Livingstone, D. (2006)** - "Turing's test and believable AI in games"
   - Discusses dual definitions of believability
   - Published in *Computers in Entertainment*, 4(1)

3. **Slater, M. (2004)** - "How colorful was your day? why questionnaires cannot assess presence in virtual environments"
   - Critiques questionnaire-based evaluation methods
   - *Presence: Teleoperators & Virtual Environments*, 13(4), 484-493

4. **Mac Namee, B. (2004)** - "Proactive persistent agents: using situational intelligence to create support characters in character-centric computer games"
   - PhD thesis on believable game agents
   - University of Dublin

5. **Rubner, Y., Tomasi, C., & Guibas, L. (2000)** - "The Earth Mover's Distance as a Metric for Image Retrieval"
   - Original EMD paper, applied here to behavioral signatures
   - *International Journal of Computer Vision*, 40(2), 99-121

## Tags
`#believability` `#evaluation-methodology` `#behavioral-signatures` `#automatable-evaluation` `#video-games` `#FPS` `#agent-behavior` `#human-likeness` `#principal-component-analysis` `#earth-movers-distance` `#unreal-tournament` `#movement-patterns` `#validation` `#metrics` `#scalable-testing` `#development-iteration` `#feature-engineering`

---

## Implementation Notes

**Tools Used:**
- Pogamut 2 framework for UT2004 agent development and monitoring
- Custom monitoring tools (available at svn://artemis.ms.mff.cuni.cz/pogamut/branches/fabien_tence)

**Reproducibility:**
- Code publicly available via SVN repository
- Clear protocol description enables replication
- Specific game version and settings documented

**Future Work Proposed by Authors:**
1. Integrate method into behavior modeling project with optimization
2. Validate optimized agents through traditional human evaluation
3. Develop contextual signatures (computed only under specific conditions)
4. Add temporal signatures (measuring time between events, reaction times)
5. Conduct studies comparing signature sensitivity to human perception sensitivity

**File Information:**
- Processed: October 31, 2025
- Source: `/home/ledwo/Zotero/storage/7PYZAXBN/Tencé and Buche - 2010 - Automatable Evaluation Method Oriented toward Behaviour Believability for Video Games.pdf`
- Agent: agent_1761926033
