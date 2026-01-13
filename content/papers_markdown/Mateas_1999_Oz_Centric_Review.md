# An Oz-Centric Review of Interactive Drama and Believable Agents

**Authors:** Michael Mateas  
**Year:** 1999  
**Citation Key:** `mateasOzCentricReviewInteractive1999`  
**Institution:** Computer Science Department, Carnegie Mellon University

## Abstract / Overview

This paper presents a comprehensive review of research in believable agents and interactive drama from the perspective of the Oz Project at CMU. The Oz Project uniquely addresses both character (believable agents) and story (interactive drama) as a unified whole, arguing that Drama = Character + Story + Presentation. Mateas surveys related work in artificial life, virtual humanoids, embodied characters, chatterbots, and behavioral animation through the lens of building worlds with rich character and compelling stories.

## Key Research Questions

- What makes virtual characters believable to an audience?
- How can we build interactive dramas that balance user agency with narrative coherence?
- What architectural approaches support both believable character behavior and story management?
- How do we reconcile the tension between interaction (user control) and drama (author control)?
- What authoring tools enable direct artistic creation of believable agents?

## Methodology

This is a **survey and position paper** that:
1. Defines the Oz Project's research philosophy and architectural approach
2. Analyzes requirements for believability from character arts (animation, dramatic writing)
3. Contrasts classical AI, behavioral AI, and believable agents approaches
4. Reviews related work across multiple fields (AI, ALife, game AI, chatterbots, animation)
5. Establishes design dimensions for interactive drama systems

The paper draws heavily on traditional character arts (Disney animation principles, dramatic writing theory) to inform technical research directions.

## Key Findings

### 1. **Requirements for Believability**

The Oz Project identified these essential characteristics from character arts:

- **Personality**: Rich, unique personality infuses everything a character does
- **Emotion**: Characters exhibit and respond to emotions in personality-specific ways
- **Self-motivation**: Characters have internal drives; they don't just react
- **Change**: Characters grow and evolve consistently with their personality
- **Social relationships**: Detailed interactions that affect and are affected by relationships
- **Illusion of life**: Multiple simultaneous goals, broad capabilities, quick environmental reactions

> "Believable is a term coming from the character arts. A believable character is one who seems lifelike, whose actions make sense, who allows you to suspend disbelief. This is not the same thing as realism. For example, Bugs Bunny is a believable character, but not a realistic character."

### 2. **Believable Agents ≠ Traditional AI**

Key contrasts with AI research goals:

| Believable Agents | Traditional AI |
|-------------------|----------------|
| Personality | Competence |
| Audience perception | Objective measurement |
| Specificity | Generality |
| Characters (artistic abstraction) | Realism |

### 3. **Oz Architecture: Drama = Character + Story + Presentation**

The system consists of:
- **World**: Contains characters with rich personalities, emotions, motivations
- **Characters**: Autonomous agents exhibiting believable behavior
- **Drama Manager**: Observes world, guides experience to create story (can modify world, influence characters)
- **Presentation Layer**: May be objective or apply dramatic filtering (camera angles, language style)
- **User/Avatar**: Interacts with world through presentation

### 4. **Behavioral vs. Classical AI for Characters**

Oz philosophy aligns with behavioral AI for the "illusion of life" requirement:

| Classical AI | Behavioral AI |
|--------------|---------------|
| Narrow/deep | Broad/shallow |
| Generality | Fits an environment |
| Disembodied | Embodied and situated |
| Semantic symbols | State dispersed, uninterpreted |
| Sense-plan-act cycle | Reactive |

> "In order to build characters that have the illusion of life, they will need to have broad capabilities to interact with complex environments."

However, Oz transforms behavioral AI to serve artistic character creation—it's not simply applying existing AI technology.

### 5. **Interactive Drama Design Dimensions**

Three key dimensions structure the design space:

1. **Strong vs. Weak stories**: How tightly constrained is the narrative?
2. **Local vs. Global control**: Does drama manager control individual actions or global story structure?
3. **Interaction frequency**: How often and in what ways can users interact?

## Important Concepts & Definitions

- **Believable Agent**: An autonomous agent that exhibits a rich personality and allows audiences to suspend disbelief (not about truthfulness, but about seeming lifelike)

- **Interactive Drama**: Virtual worlds inhabited by believable agents where user interaction creates story experience

- **Oz Project**: 10-year research group at CMU (as of 1999) focused on believable agents and interactive drama

- **Drama Manager**: System component that observes the simulated world and guides user experience to create story

- **Illusion of Life**: Collection of requirements including multiple simultaneous goals, broad capabilities, quick reactions—term from Disney animation

- **Hap**: Reactive planning language developed by Oz Project for authoring believable agent behaviors

## Research Philosophy & Contributions

### Authoring-Centric Approach

Oz emphasizes **direct artistic control** over character creation:

- Traditional AI: High explicitness, generic architectures parameterized for specific characters
- ALife: Low explicitness, emergent behavior from simple rules
- **Oz/Hap**: Middle ground—explicit enough for authorial control, reactive enough for lifelike behavior

> "In traditional media, such as writing, painting, or animation, artists exhibit fine control over their creations. Similarly, Oz wants to support the same level of artistic control in the creation of believable agents."

### Taking Character Seriously

Key principle: **Technology must serve artistic and expressive goals**

> "Effective techno-artistic research must continuously evaluate whether the technology is serving the artistic and expressive goals."

The Oz Project draws from:
- Disney's *The Illusion of Life*
- Chuck Jones' *Chuck Amuck*
- Lajos Egri's *The Art of Dramatic Writing*

## Related Work Surveyed

### 1. **Artificial Life (ALife)**
- Emphasis on emergence, bottom-up design
- Example: Braitenberg vehicles, artificial ecosystems
- **Oz critique**: Lacks authorial control for creating specific personalities

### 2. **Virtual Humanoids / Embodied Characters**
- Example: ALIVE project (MIT Media Lab)
- Characters with visual presence users can interact with
- **Oz perspective**: Important for presence, but often lacks emotional depth

### 3. **Chatterbots**
- Example: ELIZA, Julia (TinyMUD bot)
- Focus on natural language conversation
- **Oz critique**: Often lack embodiment, personality integration

### 4. **Behavioral Animation**
- Example: Perlin & Goldberg's "Improv" system
- Rule-based character animation
- **Oz alignment**: Shares reactive, behavioral approach

### 5. **Game AI / NPCs**
- Commercial game characters (adventure games, RPGs)
- **Oz critique**: Often limited personality, reactive only to player actions

## Architecture: The Hap System

**Hap** (abbreviation of "Hamlet") is a reactive planning language developed for Oz:

**Key features:**
- Combines reactive behaviors with traditional planning
- **Success Tests**: Behaviors monitor whether they're succeeding
- **Context Conditions**: When behaviors should/shouldn't run
- **Goals**: Higher-level objectives that spawn behaviors
- **Spronkle**: Monitors success/failure, manages goal pursuit

**Example domains:**
- Edge of Intention: Interactive fiction with believable dog character
- Woggles: Creatures in virtual environment
- Lyotard: Characters in 3D graphical world

## Limitations

1. **Computational Complexity**: Real-time reactive systems for multiple characters remain challenging
2. **Authoring Burden**: Even with Hap, creating rich personalities requires significant effort
3. **Evaluation Difficulty**: "Audience perception" as success metric is subjective and hard to measure systematically
4. **Limited Long-Horizon Planning**: Reactive approach may struggle with complex, long-term character arcs
5. **Story vs. Autonomy Tension**: Drama manager intervention can undermine character believability if not careful

### Acknowledged Limitations

The paper notes:
- Survey is explicitly biased toward Oz perspective
- Drama manager technology less mature than character technology (as of 1999)
- Tension between authorial control and character autonomy not fully resolved

## Relevance to Thesis

This paper is **foundational** for research on believable LLM-based agents:

**Key connections:**

1. **Believability Definition**: Establishes that believability ≠ realism and emphasizes personality, emotion, self-motivation—directly applicable to evaluating LLM agents

2. **Architecture Patterns**: The Drama = Character + Story + Presentation framework provides structure for thinking about LLM agent systems (LLM as character, orchestration layer as drama manager)

3. **Evaluation Philosophy**: "Audience perception" as success criterion aligns with human evaluation of LLM believability rather than purely objective metrics

4. **Requirements Framework**: The six believability requirements (personality, emotion, self-motivation, change, social relationships, illusion of life) provide concrete evaluation dimensions for LLM agents

5. **AI Approach Critique**: The contrast between classical AI (sense-plan-act), behavioral AI (reactive), and believable agents (artistically controlled) helps position LLM agents—which combine linguistic reasoning with reactive prompting

6. **Authoring Tools**: Emphasizes need for artist-friendly tools to create specific characters—relevant for prompt engineering and LLM agent frameworks

**Methodological relevance:**
- Survey methodology for positioning new work relative to established fields
- Drawing on arts/humanities to inform technical research
- Multi-dimensional design space analysis

**Theoretical contribution:**
- Distinguishes believability (artistic abstraction) from competence (AI performance)
- Establishes that believable agents research is a *stance* that reconstructs AI, not a subfield applying AI technology

## Notable Quotes

> "Believable agents research is not a subfield of AI. Rather it is a stance or viewpoint from which all of AI is reconstructed."

> "No idea, and no situation, was ever strong enough to carry you through to its logical conclusion without a clear-cut premise." (Egri, quoted in paper)

> "Leave out one of the three [dimensions of character: physiology, sociology, psychology], and although your plot may be exciting and you may make a fortune, your play will still not be a literary success." (Egri, quoted in paper)

> "The success of a believable agent is determined by audience perception. If the audience finds the agent believable, the agent is a success."

> "Characters are not reality, but rather an artistic abstraction of reality."

> "Any technology, whether it comes from classical or behavioral AI, or from outside of AI entirely, is fair game for exploration within the Oz context as long as it opens up new expressive and artistic spaces."

## Historical Context

**Oz Project Timeline (as of 1999):**
- 10 years of research at CMU
- Key members: Joe Bates, Bryan Loyall, Scott Neal Reilly, Phoebe Sengers, Peter Weyhrauch

**Influenced by:**
- Joseph Bates' "The Role of Emotion in Believable Agents" (1994)
- Disney animation principles (Thomas & Johnston, 1981)
- Dramatic writing theory (Egri, 1946)

**Contemporaneous work:**
- MIT Media Lab's ALIVE project
- Commercial game AI (adventure games, RPGs)
- Early embodied conversational agents

## References to Follow Up

1. **Bates, J.** "The Role of Emotion in Believable Agents" (1994) - Foundational Oz paper [`batesRoleEmotionBelievable1994`]

2. **Loyall, B.** "Believable Agents: Building Interactive Personalities" (PhD thesis) - Detailed believability requirements [`loyallBelievableAgentsBuilding`]

3. **Reilly, S.N.** Work on emotional agents (referenced but not in current bibliography)

4. **Egri, L.** "The Art of Dramatic Writing" (1946) - Character theory from dramatic arts

5. **Thomas, F. & Johnston, O.** "The Illusion of Life" (1981) - Disney animation principles

6. **Perlin, K. & Goldberg, A.** "Improv" system - Behavioral animation

## Impact & Legacy

This paper established:
- **Believability as distinct from competence** in agent design
- **Multi-disciplinary approach** combining CS, arts, humanities
- **Architectural patterns** (drama manager, presentation layer) adopted by later interactive narrative systems
- **Evaluation philosophy** based on audience perception rather than only objective metrics

## Tags

`#believability` `#interactive-drama` `#oz-project` `#character-agents` `#behavioral-ai` `#authoring-tools` `#survey-paper` `#narrative-systems` `#CMU` `#foundational`

---

**Processing Notes:**
- Paper length: 32 pages (proceedings chapter)
- Comprehensive survey with historical perspective
- Heavy emphasis on arts/humanities foundation for technical work
- Clear articulation of research philosophy and values
