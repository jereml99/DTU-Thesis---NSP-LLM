# Believable Agents: Building Interactive Personalities

**Author:** A. Bryan Loyall  
**Year:** 1997  
**Citation Key:** `loyallBelievableAgentsBuilding`  
**Type:** PhD Dissertation  
**Institution:** Carnegie Mellon University, School of Computer Science

---

## Abstract / Overview

This dissertation presents progress toward creating believable agents—autonomous agents with personality-rich characteristics from traditional character-based arts (film, animation, literature). The work combines autonomous agent research with insights from art to create interactive versions of powerful characters. Three main contributions: (1) a study of believability requirements from arts and agent construction experience, (2) the Hap architecture designed specifically for believable agents, and (3) an approach to natural language generation for believable agents.

---

## Key Research Questions

1. **What makes agents believable?** What are the requirements and properties needed for autonomous agents to achieve the same compelling quality as characters from traditional arts?

2. **How can we build expressive architectures?** How can agent architectures support the detailed, personality-specific expression needed for believability while maintaining responsiveness and real-time performance?

3. **How can language generation support believability?** How can natural language generation be integrated with action, emotion, and situated behavior to produce believable communication?

---

## Methodology

### Approach
- **Art-informed design:** Study of character-based arts (Disney animation, Stanislavski acting method, dramatic writing) to extract principles of believability
- **Architecture development:** Creation of Hap (reactive architecture) with specific support for believability requirements
- **Integration testing:** Building complete agents (Lyotard the cat, Woggles) to validate architecture
- **Public exhibition:** Year-long exhibition at Boston Computer Museum (~30,000 users) to gather empirical evidence

### Domains Tested
- **Lyotard:** Simulated housecat in interactive environment
- **Woggles:** Three autonomous creatures in real-time animated world with physics
- **Natural language agents:** Experimental agents with speech generation capabilities

### Technical Framework
- **Hap architecture:** Reactive planning system with goals, behaviors, and primitive actions
- **Em emotion model:** Integration of Scott Neal Reilly's emotion system
- **Real-time execution:** 10 frames/second with concurrent goal pursuit
- **Unified architecture:** All mental processes (action, sensing, emotion, thinking, language) expressed in single framework

---

## Key Findings

### 1. **Requirements for Believable Agents**
Identified and analyzed comprehensive set of requirements from arts and autonomous agents:

**From Character Arts:**
- **Personality:** Wealth of specific behavioral details defining the individual
- **Emotion:** Emotional reactions visible and expressed appropriately
- **Self-motivation:** Internal drives beyond reactive behavior
- **Change:** Growth appropriate to personality over time
- **Social relationships:** Nuanced interactions with other characters
- **Consistency:** Unified expression across all avenues (action, voice, emotion)

**From Autonomous Agents:**
- **Appearance of goals:** Explicit, visible goal pursuit
- **Concurrent goals:** Multiple simultaneous objectives
- **Parallel action:** Coordinated multi-tasking
- **Reactivity:** Response to environmental changes
- **Situated behavior:** Context-appropriate action selection
- **Resource bounded:** Visible computational and physical limitations
- **Broad capability:** Integration of sensing, action, emotion, language
- **Well integrated:** Seamless combination of capabilities

### 2. **Hap Architecture Success**
Demonstrated that reactive architectures can support believability when designed with specific features:

- **Situated variation:** Behaviors chosen based on current context, emotional state, social relationships
- **Personality expression:** Preconditions, success tests, context conditions allow personality-specific variation
- **Real-time responsiveness:** Compiled to RAL, selective sensing enables 10Hz performance
- **Emotion integration:** Automatic emotion generation from goal success/failure with personality-specific expression
- **Concurrent pursuit:** Collection behaviors enable parallel goal pursuit with priority management

### 3. **Empirical Validation**
Public exhibition results:
- **Engagement:** 5-10 minute average interaction time (exceptional for public exhibits)
- **Emotional response:** Visitors laughed, showed visible enjoyment
- **Believability threshold:** Some visitors perceived creatures as "just bouncing balls," others engaged deeply with personalities
- **Learning curve:** Others successfully learned Hap and built majority of Woggles behaviors in 6 weeks

### 4. **Integration Benefits**
Unified architecture (all processes in Hap) provides automatic inheritance of believability properties:
- Composite sensing inherits reactivity and situated behavior
- Language generation inherits emotion awareness, parallel action capability
- All thinking processes share goal structure, priority management
- Consistent resource management across all agent capabilities

### 5. **Personality Permeation**
No aspect should be generic—personality must pervade all details:
- Different walk cycles for different characters
- Emotion affects all behaviors (language, movement, sensing priorities)
- Social relationships modulate interaction patterns
- Even low-level actions (blinking, glancing) vary by personality

---

## Important Concepts & Definitions

### **Believable Agents**
Personality-rich autonomous agents with powerful properties of characters from arts. Not necessarily realistic (abstracted, caricatured), not necessarily intelligent (focus on personality, emotion, social facility over problem-solving).

### **Personality**
All particular details—especially behavioral, thought, and emotional—that define the individual. Requires wealth of specific details, not generic templates.

### **Hap (Reactive Architecture)**
- **Goals:** Derive meaning from author-written behaviors
- **Behaviors:** Structured sequences/collections of subgoals and actions
- **Active Behavior Tree (ABT):** Current execution state showing active goals and behaviors
- **Annotations:** Preconditions, success tests, context conditions, priorities
- **Step types:** Subgoals, actions, mental acts, waits

### **Situated Variation**
Behaviors chosen in-the-moment based on current context (emotional state, social relationships, environmental conditions) rather than pre-planned sequences.

### **Context Conditions**
Reactive annotations that abort behaviors when conditions become false (e.g., "stay sad only while not angry")—enables emotional reactivity in ongoing behaviors.

### **Behavioral Features**
Emotion-derived modifiers affecting behavior execution (e.g., intensity, style, timing) automatically computed from emotion model.

### **Composite Sensing**
High-level sensing patterns expressed as Hap behaviors (e.g., "detect threats over time") that integrate with action behaviors through same goal/priority system.

### **Unified Architecture**
Single framework (Hap) expressing all agent mental processes: action, sensing, emotion, thinking, language generation—ensuring consistent personality expression.

---

## Formulas & Metrics

### Priority Calculation
```
Effective Priority = Base Priority + Priority Modifier
```
- Enables dynamic priority shifts based on context (e.g., emergencies)
- Greedy scheduling: highest priority leaf node always executed

### Emotion Generation (Em Model)
Emotions generated from:
- **Goal Success/Failure:** Joy (success), Distress (failure)
- **Attribution:** Gratitude/Anger (credit/blame), Pride/Shame (self-attribution)
- **Prospective:** Fear/Hope (anticipated outcomes)

Emotion intensity based on:
- **Importance:** Author-specified goal importance values
- **Credit/Blame:** Inferred from goal relationships and agent models
- **Likelihood:** Probability of anticipated outcomes

### Emotion Decay
```
Intensity(t) = Intensity(0) × e^(-λt)
```
- Automatic exponential decay over time
- Prevents emotion accumulation
- Allows natural emotional transitions

### Behavioral Feature Mapping
```
Feature_Value = f(Emotion_Intensity, Personality_Mapping)
```
- Personality-specific mapping from emotions to behavioral modifiers
- Example: Anger → increased speed, reduced deliberation

### Resource Management
Single computational bottleneck:
- One goal expanded per cycle
- Greedy selection by priority
- Time-slicing among parallel threads

---

## Results & Statistics

### Boston Computer Museum Exhibition
- **Duration:** ~1 year (1994-1995)
- **Total visitors:** ~150,000 annual museum attendance
- **Users:** ~30,000 people interacted with Woggles
- **Average engagement:** 5-10 minutes (exceptionally high for public exhibits)
- **Qualitative response:** "Overwhelmingly positive," visible laughter and enjoyment

### Development Efficiency
- **Woggles creation:** 6 weeks with 5 people (3 new to architecture)
- **Agent complexity:** Wolf (primary example) had ~100+ behaviors across action, sensing, emotion
- **Performance:** 10 frames/second in real-time animated world

### Architecture Adoption
- **Academic use:** 2 PhD theses (Neal Reilly on emotion/social knowledge, Sengers on behavior transitions)
- **Research adoption:** Stanford (Virtual Theater), MERL (animated worlds)
- **Commercial use:** Fujitsu's "Teo" product featuring "Fin Fin" agent

### Grammar Scale (NLG)
- **Preliminary:** Small grammar tested in portions of agents
- **Not complete:** Full agent with comprehensive language not yet built
- **Evidence:** Demonstrated integration of language with action, emotion, reactivity

---

## Limitations

### Acknowledged by Author

1. **Change/Learning:** No architectural support for agent growth and change—critical requirement not addressed

2. **Social Context:** No specific support for following social conventions of particular worlds

3. **Consistency:** No architectural enforcement of consistency across expression modes (author responsibility)

4. **NLG Preliminary:** Natural language work incomplete:
   - Only small grammar tested
   - No complete talking agent built
   - No evidence others can use NLG approach

5. **Scalability Unknown:**
   - How large can grammars/behaviors grow?
   - Cognitive load on authors for large agents?
   - No formal usability studies

6. **Authoring Difficulty:** Building believable agents remains challenging:
   - Many details to specify
   - Consistency maintenance burden
   - Requires understanding of architecture + personality design

### Methodological Limitations

1. **Subjective Evaluation:** Believability inherently subjective—no objective metrics

2. **Exhibition Bias:** Museum visitors may be more willing to engage than skeptical evaluators

3. **Simple Domains:** Tested in bounded worlds with limited object/action spaces

4. **Small-Scale Tests:** Individual agents, small groups—not large multi-agent societies

---

## Relevance to Thesis: Believable Agents and LLMs

### Direct Connections

#### 1. **Foundational Requirements Framework**
Loyall's requirements analysis provides authoritative foundation for believability that applies to LLM-based agents:
- **Personality permeation:** LLMs must exhibit consistent personality across all utterances/actions, not generic responses
- **Emotion integration:** LLM agents need emotion models affecting language, reasoning, action selection
- **Self-motivation:** Agents must pursue goals beyond reactive responses—proactive behavior

**Thesis application:** Can use Loyall's 14 requirements as evaluation criteria for LLM-based believable agents. His distinction between "realistic" (simulation accuracy) and "believable" (artistic suspension of disbelief) critical for setting appropriate goals.

#### 2. **Architecture Design Principles**
Hap's design offers lessons for LLM integration architectures:
- **Unified architecture benefit:** Integrating all capabilities (language, action, emotion) in single framework ensures consistency
- **Reactive annotations:** Context conditions and success tests enable personality-specific reactivity—could inform LLM prompt engineering or fine-tuning strategies
- **Priority management:** Greedy scheduling with priorities provides visible resource bounds—relevant for LLM token budgets, attention mechanisms

**Thesis application:** Compare Hap's goal/behavior structure to LLM planning approaches (ReAct, chain-of-thought). Evaluate if LLMs can learn situated variation through examples or require explicit symbolic structures.

#### 3. **Personality Expression Methodology**
Loyall's emphasis on authoring detailed, specific behaviors contrasts with training-based LLM approaches:
- **Specificity requirement:** "No two characters do anything the same way"—challenges LLM tendency toward averaged responses
- **Expressiveness over ease:** Low-level primitive tools enable personality expression—suggests LLM agents may need fine-grained control mechanisms, not just high-level prompts
- **Integration hazards:** Modularity undermines believability—warns against separating LLM language module from action/emotion systems

**Thesis application:** Investigate whether LLMs can achieve personality specificity through few-shot examples, persona prompts, or require fine-tuning. Test if modular vs. end-to-end architectures better support believability.

#### 4. **Emotion and Behavior Integration**
Em emotion model integration demonstrates requirements for LLM emotion systems:
- **Automatic generation + authored expression:** Emotions arise from goal outcomes, but expression is personality-specific
- **Behavioral features:** Emotions modulate all behaviors, not just emotional utterances
- **Temporal dynamics:** Decay, summarization, persistence—LLMs need mechanisms beyond single-turn emotion recognition

**Thesis application:** Explore if LLMs can maintain consistent emotional state across multi-turn interactions. Compare Em's automatic generation from goals to LLM emotion inference from context. Test if behavioral feature modulation can be achieved through prompt conditioning.

#### 5. **Natural Language Generation Insights**
Chapter 8's NLG approach identifies critical challenges for LLM-based agents:
- **Incremental generation:** Pauses, restarts, breakdowns must be visible—LLMs typically generate complete responses
- **Action-language mixing:** Concurrent gesture + speech requires parallel execution—LLMs are inherently sequential
- **Reactive language:** Grammar choices depend on real-time sensing, emotional state changes mid-utterance
- **Personality variation:** Word choice, syntax, timing all vary by personality and context

**Thesis application:** Evaluate LLM capabilities for incremental generation, interruptible speech, emotion-conditioned language. Test if LLMs can learn to vary language by personality through examples or require explicit control.

---

### Methodological Contributions

#### 1. **Art-Informed AI Design**
Loyall demonstrates systematic knowledge extraction from arts (animation principles, Stanislavski method, dramatic writing):
- **Principle:** Study traditional character arts before reinventing—"artists have struggled for millennia"
- **Method:** Translate artistic concepts (e.g., "tridimensional characters," "illusion of life") to computational requirements

**Thesis application:** Use film/theater character analysis to identify LLM agent requirements. Study actor training methods (e.g., method acting, improvisation) for LLM prompting strategies.

#### 2. **Empirical Believability Testing**
Boston Museum exhibition provides model for large-scale public testing:
- **Engagement time** (5-10 min) as believability proxy
- **Qualitative observation:** Laughter, visible enjoyment
- **Threshold effects:** Some users engage deeply, others don't "get it"

**Thesis application:** Design similar public-facing LLM agent deployments measuring engagement, emotional response. Investigate threshold effects—what factors determine if users suspend disbelief?

#### 3. **Complete Agent Requirement**
Loyall emphasizes building complete, integrated agents rather than isolated capabilities:
- **Integration testing:** Only complete agents reveal consistency problems, timing issues
- **Holistic personality:** All details (walk, blink, language, emotion expression) must cohere

**Thesis application:** Test LLM agents in complete scenarios with multimodal interaction (language + action simulation). Avoid evaluating language generation in isolation from embodied context.

---

### Theoretical Challenges for LLM-Based Believability

#### 1. **Specificity vs. Generalization Tension**
- **Loyall:** Believability requires unique, specific details—"no generic solutions"
- **LLMs:** Trained for generalization, produce averaged responses
- **Question:** Can few-shot examples, persona prompts, or fine-tuning overcome this? Or do LLMs fundamentally resist the specificity believability requires?

#### 2. **Authorial Control vs. Emergent Behavior**
- **Loyall:** Authors specify every behavioral detail through Hap behaviors
- **LLMs:** Behavior emerges from training data, prompts—less direct control
- **Question:** What level of authorial control is necessary for believability? Can LLMs achieve sufficient control through prompt engineering, or do they need symbolic overlay (like Hap)?

#### 3. **Real-Time Reactivity**
- **Loyall:** Context conditions enable mid-behavior emotional/environmental reactivity
- **LLMs:** Autoregressive generation doesn't naturally support interruption, mid-utterance adaptation
- **Question:** Can LLM-based agents achieve reactive language without fundamental architectural changes (e.g., streaming, interruptible generation)?

#### 4. **Unified Architecture Benefits**
- **Loyall:** Integrating all processes in Hap ensures consistency, shared resource management
- **LLMs:** Often used as language module in hybrid architectures (separate vision, planning, emotion modules)
- **Question:** Do LLMs require tight integration (end-to-end training with action/emotion) or can modular approaches with careful interface design suffice?

---

### Key Lessons for NSP-LLM Thesis

1. **Requirements before Technology:** Define believability requirements from arts first, then evaluate if/how LLMs meet them—not vice versa.

2. **Personality Specificity Test:** Test whether LLMs can achieve Loyall's "no two characters do anything the same" through personas, few-shot, or fine-tuning.

3. **Integration over Modularity:** Favor end-to-end approaches where LLMs jointly model language + emotion + goals over separated modules—Loyall shows modularity harms believability.

4. **Complete Agent Evaluation:** Test LLMs in full scenarios (multi-turn, emotional dynamics, action coordination) not isolated tasks.

5. **Authoring Tools Research:** If LLMs resist fine-grained control, investigate authoring interfaces balancing expressiveness (Loyall's primitive tools) with ease of use.

6. **Emotion Dynamics:** Implement temporal emotion models (decay, attribution, behavioral features) in LLM agents—not just single-turn sentiment.

7. **Public Testing:** Design Wizard-of-Oz or deployment studies measuring engagement time, suspension of disbelief with general users.

---

## Notable Quotes

> "For a character to be that real, he must have a personality, and, preferably, an interesting one." (Thomas and Johnston, cited p. 16)

> "No two scenes should ever be alike and no two characters should ever do something the same way." (Thomas and Johnston, cited p. 18)

> "You must know what your character is, in every detail, to know what he will do in a given situation." (Egri, cited p. 16)

> "Any role that does not include a real characterization will be poor, not lifelike... That is why I propose for actors a complete inner and external metamorphosis." (Stanislavski, cited p. 17)

> "Generality is good computer science but bad believability." (Loyall, p. 165)

> "Artists are breakers of rules... The goal is to express an envisioned unique, quirky, rule-breaking personality in interactive form, not to make reusable code." (Loyall, p. 166)

> "Irrationality is OK: The Hazards of the Assumption of Rationality... Many characters are irrational. Some might argue that those are the interesting ones." (Loyall, p. 169)

> "Modularity is in conflict with the needs of believable agents. Tight, seamless integration is needed for believable agents." (Loyall, p. 166)

> "When working to express a personality, authors always want to modify any part of the architecture that gets in the way of what they are trying to express." (Loyall, p. 166)

> "The more an animator goes toward caricaturing the animal, the more he seems to be capturing the essence of that animal... If we had drawn real deer in Bambi there would have been so little acting potential that no one would have believed the deer really existed as characters." (Thomas and Johnston, cited p. 2)

---

## References to Follow Up

### Foundational Works Cited

1. **Thomas, F. and Johnston, O. (1981). Disney Animation: The Illusion of Life.** — Authoritative source on animation principles for believability

2. **Stanislavski, C. (1968). Stanislavski's Legacy.** — Acting method emphasizing internal emotional truth, character transformation

3. **Egri, L. (1960). The Art of Dramatic Writing.** — "Tridimensional characters" framework (physiology, sociology, psychology)

4. **Bates, J. (1992). Virtual reality, art, and entertainment.** — Oz Project vision for interactive drama

### Related Believable Agent Research

5. **Neal Reilly, W.S. (1996). Believable Social and Emotional Agents (PhD thesis).** — Em emotion model integrated with Hap

6. **Sengers, P. (1996). Symptom management for schizophrenic agents.** — Behavior transition coherence

7. **Blumberg, B. (1996). Old Tricks, New Dogs: Ethology and Interactive Creatures (PhD thesis).** — Ethology-based architecture, ALIVE system

8. **Hayes-Roth, B. and van Gent, R. (1997). Story-making with improvisational puppets.** — Virtual Theater using Hap + BB1

### Architecture Foundations

9. **Brooks, R. (1986). A robust layered control system for a mobile robot.** — Subsumption architecture, behavior-based AI

10. **Agre, P. and Chapman, D. (1987). Pengi: An implementation of a theory of activity.** — Situated action, indexical-functional representation

11. **Firby, J. (1989). Adaptive Execution in Complex Dynamic Worlds (PhD thesis).** — Reactive Action Packages (RAPs)

12. **Georgeff, M. and Lansky, A. (1987). Reactive reasoning and planning.** — Procedural Reasoning System (PRS)

### Natural Language for Agents

13. **Appelt, D. (1985). Planning English Sentences.** — KAMP system, integrating action and language

14. **Hovy, E. (1988). Generating Natural Language under Pragmatic Constraints.** — Pauline system, pragmatic variation

---

## Tags

`#believability` `#autonomous-agents` `#personality` `#emotion` `#architecture` `#reactive-planning` `#hap` `#character-based-arts` `#animation-principles` `#stanislavski` `#natural-language-generation` `#unified-architecture` `#situated-action` `#real-time-interaction` `#integration` `#authoring` `#phd-thesis` `#foundational-work` `#oz-project` `#evaluation-methodology`
