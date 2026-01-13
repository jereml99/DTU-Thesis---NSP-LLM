# Narrative Planning: Balancing Plot and Character

**Authors:** Mark O. Riedl, R. Michael Young  
**Year:** 2010  
**Citation Key:** `riedlNarrativePlanningBalancing2010`  
**Journal:** Journal of Artificial Intelligence Research (JAIR), Vol. 39, pp. 217-267  
**Institutions:** Georgia Institute of Technology, North Carolina State University

## Abstract / Overview

This paper presents the Intent-based Partial Order Causal Link (IPOCL) planner, a narrative generation system that balances two universal attributes of good narratives: (a) logical causal progression of plot, and (b) character believability through intentionality. IPOCL extends conventional POCL planning to generate story fabula (event sequences) where characters appear to form intentions and act to achieve those intentions, making them believable to audiences, while simultaneously ensuring the story achieves author-specified outcomes.

## Key Research Questions

- How can automated narrative generation systems produce stories with both causally coherent plots AND believable characters?
- How do we reconcile character agency (characters acting on their own intentions) with author goals (desired story outcomes)?
- Can deliberative planning approaches generate narratives where character intentionality is perceivable by audiences?
- How do we evaluate whether automatically generated narratives support audience comprehension of character intentions?

## Methodology

### Approach: Refinement Search Planning

**IPOCL Algorithm**: Extends Partial Order Causal Link (POCL) planning

**Key Innovations:**
1. **Expanded plan representation** including:
   - **Frames of Commitment**: Data structures representing character intentions
   - **Intention Reasoning**: Continuous testing of character intentionality from audience perspective
   - **Actor-Action Binding**: Explicit specification of which parameters are intentional actors

2. **Dual Search**: Simultaneously searches:
   - Space of plans (action sequences)
   - Space of agent intentions (character goals)

3. **Audience-Centric**: Reasons about intentions from audience's ability to infer them, not just internal character state

### Action Schema Extensions

IPOCL distinguishes:
- **Happenings**: Events without intentional actors (accidents, natural forces)
- **Non-happenings**: Actions requiring intentional actors
- **Actors slot**: Specifies which parameters are intentional agents

### Evaluation Study Design

**Method:** Between-subjects experiment (n=34 participants)

**Conditions:**
- **IPOCL condition**: Narrative generated with character intentionality reasoning
- **POCL condition**: Narrative from conventional planner (control)

**Domain:** Aladdin-inspired fairy tale (knight, princess, king, dragon, genie, magic lamp)

**Outcome:** Both achieve same goal state: `married(king, jasmine) ∧ ¬alive(genie)`

**Measurement:** QUEST (Question-Answer) model
- Participants answer why-questions about character actions
- Goodness-of-Answer (GOA) ratings for responses
- **"Good" QA pairs**: Structural distance ≤ 2 in QUEST graph
- **"Poor" QA pairs**: Structural distance > 2

**Hypotheses:**
1. H1: IPOCL narratives have higher GOA for "good" QA pairs
2. H2: IPOCL narratives have lower GOA for "poor" QA pairs (fewer false inferences)

## Key Findings

### 1. **IPOCL Significantly Improves Character Intentionality**

| Metric | POCL (Control) | IPOCL (Experimental) | Statistical Significance |
|--------|----------------|----------------------|-------------------------|
| Mean GOA for "good" QA pairs | 1.1484 (SD: 0.2254) | 1.2539 (SD: 0.1542) | t=1.6827, p<0.0585 (strongly suggestive) |
| Mean GOA for "poor" QA pairs | 1.2969 (SD: 0.1802) | 1.1898 (SD: 0.1406) | t=1.8743, p<0.05 (significant) |

**Result**: IPOCL narratives support reader comprehension of character goals, intentions, and motivations significantly better than POCL narratives.

### 2. **Character vs. Author Intentions Can Be Distinguished**

Key insight: Character intentions ≠ Author goals

- **POCL problem**: Conflates character goals with author outcomes
- **IPOCL solution**: Characters form intentions that serve the plot WITHOUT knowing the author's desired ending
- Characters act on local, believable motivations that emergently achieve global story structure

**Example from evaluation:**
- **Author goal**: King marries Jasmine, Genie dies
- **Character intentions** (IPOCL):
  - King falls in love → intends to marry Jasmine
  - King orders Aladdin to fetch lamp → Aladdin intends king has lamp
  - King commands Genie to cast love spell → Genie intends Jasmine loves King
  - Genie appears threatening → Aladdin intends Genie not alive
  
All character actions are locally motivated while achieving global author outcome.

### 3. **Frames of Commitment: Representing Character Intentionality**

**Frame of Commitment**: `⟨character, goal, actions, established-by, discharged-by⟩`

- **Established-by**: Action(s) that cause character to adopt intention
- **Discharged-by**: Action(s) that achieve/abandon the intention

**Functions:**
1. Groups actions belonging to single intention pursuit
2. Makes character motivations explicit and trackable
3. Enables audience-perspective reasoning (can audience infer this intention?)

### 4. **Intentionality Test: Audience Perspective**

IPOCL performs **Intentionality Test** during planning:

**For each non-happening action**:
1. Is action part of existing frame of commitment? → OK
2. Does action directly establish new intention? → Create frame
3. Does a recent "intention priming" action explain this? → Link to frame
4. **FAIL**: Action appears unmotivated from audience perspective → Backtrack or insert intention-priming action

**Intention Priming Actions:**
- **order(A, B, goal)**: A orders B to achieve goal → B intends goal
- **love(A, B)**: A loves B → A intends B's welfare goals
- **threaten(A, B)**: A threatens B → B intends to neutralize threat
- **appear-threatening(A, B)**: A appears dangerous → B intends ¬alive(A)

### 5. **Deliberative vs. Emergent Narrative Generation**

**Deliberative (Planning-based)**:
- Considers narrative sequence as whole
- Ensures causal coherence (no plot holes)
- Historically conflated character/author goals → unbelievable characters

**Emergent (Simulation-based)**:
- Characters act on local information
- Believable character autonomy
- Risk of causal incoherence, no guaranteed outcomes

**IPOCL**: Hybrid approach
- Deliberative planning for causal coherence
- Character intentionality reasoning for believability
- "Characters appear to be simulated while being planned"

## Important Concepts & Definitions

- **Narrative**: "The recounting of a sequence of events that have a continuant subject and constitute a whole" (Prince, 1987)

- **Fabula**: Chronological enumeration of ALL events in story world (what happened)

- **Sjuzet**: Subset of fabula presented to audience via narration (what's told)

- **Character Believability**: "The perception by the audience that the actions performed by characters do not negatively impact the audience's suspension of disbelief. Specifically, characters must be perceived by the audience to be intentional agents."

- **Perceived Intentionality**: Characters observed by audience to have goals and act to achieve them

- **Intentional Stance** (Dennett, 1989): Interpreting entity behavior by attributing beliefs, desires, intentions

- **POCL (Partial Order Causal Link) Planner**: Planning algorithm that builds partially ordered action sequences with causal links

- **Causal Link**: `s1 --p--> s2` where s1 establishes condition p needed by s2

- **Open Condition Flaw**: Precondition not satisfied by preceding action/initial state

- **Causal Threat**: Action that might undo effects of earlier action

- **Frame of Commitment**: Plan structure representing character's intention to achieve goal

- **Happening**: Event that occurs without character intention (accidents, nature)

- **Outcome**: Goal situation describing desired world state at narrative end (author's goal)

## Formulas & Algorithms

### POCL Plan Definition

**Definition 1 (POCL Plan)**: A tuple `⟨S, B, O, L⟩` where:
- **S**: Set of plan steps (actions)
- **B**: Set of binding constraints (variable assignments)
- **O**: Set of temporal orderings `s₁ < s₂`
- **L**: Set of causal links `⟨s₁, p, q, s₂⟩` (s₁ achieves p which satisfies precondition q of s₂)

### IPOCL Planning Problem

**Definition 2 (IPOCL Planning Problem)**: A tuple `⟨I, A, G, Λ⟩` where:
- **I**: Initial state
- **A**: Set of symbols referring to character agents
- **G**: Goal situation (outcome)
- **Λ**: Set of action schemata

### IPOCL Plan Representation

Extends POCL plan to: `⟨S, B, O, L, Φ⟩` where:
- **Φ**: Set of frames of commitment

### Frame of Commitment Structure

`⟨c, g, A, e, d⟩` where:
- **c**: Character agent
- **g**: Goal literal
- **A** ⊆ S: Actions in frame
- **e** ⊆ S: Actions establishing intention
- **d** ⊆ S: Actions discharging intention

### Heuristic Search Cost Function

IPOCL uses A* search with cost function:
```
f(n) = g(n) + h(n)
```

Where penalties include:
- 5000 for repeat actions (avoid loops)
- 5000 for frames with implausible character-goal combinations
- 1000 if marry action lacks commitment frames for both actors
- Rewards for actions within existing frames

## Results & Statistics

### Quantitative Results

**Primary Finding**: IPOCL narratives support significantly better character intention comprehension

**"Good" Question-Answer Pairs** (short structural distance):
- POCL mean GOA: 1.1484 (SD: 0.2254)
- IPOCL mean GOA: 1.2539 (SD: 0.1542)
- t(15) = 1.6827, **p < 0.0585** (strongly suggestive)

**"Poor" Question-Answer Pairs** (long structural distance):
- POCL mean GOA: 1.2969 (SD: 0.1802)
- IPOCL mean GOA: 1.1898 (SD: 0.1406)
- t(15) = 1.8743, **p < 0.05** (significant)

**Interpretation:**
- IPOCL readers better infer correct character motivations
- IPOCL readers less likely to make false inferences about motivations
- High SD in POCL "good" QA suggests participants generated multiple competing hypotheses

### Qualitative Comparison

**POCL Narrative** (14 actions):
- King falls in love with Jasmine
- Aladdin travels to mountain, slays dragon, pillages lamp, returns
- Aladdin gives lamp to king
- King summons genie
- Genie casts love spell on Jasmine
- Aladdin slays genie
- King marries Jasmine

**Problems**: Why does Aladdin help the king then kill the genie? Appears contradictory/unmotivated.

**IPOCL Narrative** (16 actions, includes intention-establishing actions):
- King falls in love → **orders Aladdin** to fetch lamp (establishes Aladdin's intention)
- Aladdin travels, slays dragon, pillages lamp, returns, gives to king
- King summons genie, **commands genie** to cast love spell (establishes Genie's intention)
- **Genie appears threatening** to Aladdin (establishes Aladdin's new intention)
- Aladdin slays genie
- King marries Jasmine

**Improvements**: Each character action motivated by explicit intention. Aladdin slays genie because genie appeared threatening, not arbitrarily.

## Limitations

### Acknowledged by Authors

1. **Narrative Length**: IPOCL narratives were longer (16 vs 14 actions). Effect might be confounded with length, though authors argue filler sentences don't impact mental models per Graesser et al. (1994).

2. **Discourse Model**: Longbow discourse planner made overly explicit statements about intentions in natural language rendering. Authors believe results would hold without these (humans infer well), but didn't control for this.

3. **Domain Specificity**: Evaluation used single domain (fairy tale). Generalizability to other genres/domains not tested.

4. **Sample Size**: n=34 split across two conditions gives moderate statistical power.

5. **Computational Complexity**: IPOCL adds significant search overhead. No performance benchmarks reported.

### Additional Limitations

6. **Heuristic Engineering**: Domain-dependent heuristics required (e.g., plausible character-goal pairs). Doesn't scale to arbitrary domains without author expertise.

7. **Binary Intentionality**: Actions either require intention or don't (happenings). Reality more nuanced.

8. **Single Outcome**: Generates one narrative per outcome. Doesn't explore multiple story possibilities for same ending.

9. **No Emotional Modeling**: Focuses on intentionality, not emotion, personality, or other believability dimensions identified by Oz Project ([`mateasOzCentricReviewInteractive1999`])

10. **Static Character Goals**: Characters adopt intentions reactively during planning, but don't have persistent personality-driven goals.

## Relevance to Thesis

This paper is **highly relevant** for LLM-based believable agent research:

### Key Connections

1. **Planning + Believability**: Demonstrates that long-horizon planning can support character believability if intentionality is explicitly modeled—directly applicable to LLM planning architectures (e.g., [`zhouISRLLMIterativeSelfRefined2023`], [`huangPlanningDarkLLMSymbolic2024`])

2. **Dual-Level Reasoning**: IPOCL's separation of character intentions vs. author goals parallels:
   - LLM agent with personal goals/persona vs. system-level objectives
   - Local action selection vs. global coherence in agent frameworks

3. **Audience Perspective**: The "intentionality test" evaluates actions from observer viewpoint—directly relevant to evaluating LLM agent believability through human perception (cf. [`xiaoHowFarAre2024`])

4. **Frames of Commitment**: Could inform LLM agent memory architectures:
   - Track active agent intentions over time
   - Group actions by motivating goal
   - Explain action sequences through intention attribution

5. **Evaluation Methodology**: QUEST-based evaluation (question-answering about character motivations) provides concrete evaluation framework for LLM agents in narrative contexts

6. **Hybrid Deliberative-Reactive**: IPOCL combines planning (deliberative) with immediate response to threats (reactive). LLMs naturally support hybrid reasoning—this provides architectural pattern.

### Methodological Relevance

- **Formal Framework**: POCL formalism offers structured way to represent LLM agent plans with explicit causal dependencies
- **Heuristic Search**: A* search with domain heuristics analogous to LLM planning with prompting strategies
- **Human Evaluation**: GOA rating methodology adaptable to evaluating LLM-generated agent behaviors

### Theoretical Contribution

- **Character Agency ≠ Competence**: Characters can be "dumb" (poor planners) but still believable if intentions are clear
- **Intentionality as Observable**: Believability depends on audience's ability to infer intentions, not internal fidelity
- **Narrative = Multi-Agent Planning**: Storytelling as coordinating multiple (possibly conflicting) agent intentions toward author outcome

### Contrasts with LLM Approaches

| IPOCL (Symbolic Planning) | LLM-Based Agents |
|---------------------------|------------------|
| Explicit causal reasoning | Implicit pattern recognition |
| Guaranteed logical coherence | May produce contradictions |
| Requires formal domain model (STRIPS) | Works with natural language |
| Computationally expensive search | Fast inference |
| Deterministic given heuristics | Stochastic sampling |
| Character goals explicitly represented | Goals implicit in prompts/context |

**Synergy opportunity**: Use LLMs to generate natural language from IPOCL plans, or use symbolic planning to validate LLM-generated action sequences ([`tantakounLLMsPlanningModelers2025`])

## Notable Quotes

> "Character believability is the perception by the audience that the actions performed by characters do not negatively impact the audience's suspension of disbelief. Specifically, characters must be perceived by the audience to be intentional agents."

> "In the context of computational storytelling systems, it is not sufficient for a character to act intentionally if the audience is not capable of inferring that character's intentions from the circumstances that surround the character in the story world."

> "The audience of a story is not a collection of passive observers. Instead, the audience actively performs mental problem-solving activities to predict what characters will do and how the story will evolve." (citing Gerrig, 1993)

> "The goal of our research is to devise a narrative generation system that generates narratives that exhibit both causal coherence and character intentionality."

> "IPOCL can produce narratives that have both logical causal progression, meaning that they achieve author-indicated outcomes states, and have believable characters."

> "We conclude that there is strong evidence that the narrative in the experimental condition supported reader comprehension of character goals, intentions, and motivations better than the narrative in the control condition."

> "The opportunistic discovery of character intentions during action instantiation significantly affects the understandability of character behavior by providing a better means of explaining actions to an observing audience."

## Related Work Discussed

### Deliberative Narrative Generation

- **TALE-SPIN** (Meehan, 1977): Early story generator using simulation
- **AUTHOR** (Callaway & Lester, 2002): Discourse planning for narratives
- **Fabulist** (Riedl, 2004): Vignette-based narrative planning
- **Narrative planning with landmarks** (Riedl, 2009): Author-specified waypoints

### Emergent Narrative

- **Façade** (Mateas & Stern, 2003): Interactive drama with autonomous characters
- **Virtual storyteller** (Swartjes & Theune, 2006): Distributed character agents

### Planning Algorithms

- **UCPOP** (Penberthy & Weld, 1992): Classic POCL planner
- **STRIPS** (Fikes & Nilsson, 1971): Foundational planning representation
- **Graphplan**, **SATPLAN**: Alternative planning paradigms

### Narrative Theory

- **QUEST** (Graesser, Lang, & Roberts, 1991): Question-answering model of comprehension
- **Intentional stance** (Dennett, 1989): Philosophical foundation for intention attribution
- **Narrative intelligence** (Mateas & Sengers, 1999): Cognitive role of storytelling

## Impact & Connections

**Cited by** (selection):
- Work on LLM-based planning ([`tantakounLLMsPlanningModelers2025`])
- Interactive narrative systems
- Computational creativity research
- Multi-agent story generation

**Builds on:**
- Oz Project believability work ([`batesRoleEmotionBelievable1994`], [`mateasOzCentricReviewInteractive1999`])
- Classical AI planning (STRIPS, POCL)
- Narrative comprehension psychology (Trabasso, Graesser)

**Influenced:**
- Subsequent work on character-driven narrative generation
- Evaluation methodologies for computational creativity
- Integration of planning and storytelling

## Future Directions (from paper)

1. **Richer Intentionality**: Model beliefs, desires, emotions beyond just goals
2. **Social Relationships**: Character intentions influenced by relationships
3. **Discourse Generation**: Better natural language rendering without over-explicit intentions
4. **Interactive Narrative**: Adapt IPOCL for real-time story generation with user input
5. **Multiple Outcomes**: Generate story variations for same scenario
6. **Learning Heuristics**: Automate discovery of domain-appropriate heuristics

## Tags

`#narrative-planning` `#believability` `#character-intentionality` `#IPOCL` `#POCL` `#automated-storytelling` `#multi-agent-systems` `#narrative-generation` `#evaluation` `#QUEST` `#symbolic-planning` `#fabula` `#causal-reasoning`

---

**Processing Notes:**
- Paper length: 51 pages (journal article)
- Highly technical with formal algorithmic specifications
- Strong empirical evaluation with statistical significance
- Bridges AI planning and narrative theory
- Foundational for planning-based narrative generation
