# An Overview of the Mimesis Architecture: Integrating Intelligent Narrative Control into an Existing Gaming Environment

**Author:** R. Michael Young  
**Year:** ~2001 (AAAI Spring Symposium)  
**Citation Key:** `youngOverviewMimesisArchitecture`  
**Institution:** Liquid Narrative Research Group, Department of Computer Science, NC State University

## Abstract / Overview

This paper presents the Mimesis system, an intelligent controller for virtual worlds that generates and maintains coherent, narrative-based storylines by integrating AI planning and natural language discourse generation with real-time control of Epic Games' Unreal Tournament. Mimesis represents a pioneering approach to embedding narrative intelligence into commercial game engines, using declarative action models and HTN planning to orchestrate story-driven gameplay while accommodating user agency through exception handling and plan adaptation.

## Key Research Questions

- How can AI-based narrative control be integrated into existing commercial game engines?
- How do we maintain narrative coherence while preserving player agency in interactive environments?
- What architectural patterns enable real-time story generation and execution monitoring in virtual worlds?
- How can declarative planning representations interface with procedural game code?
- How do we detect and respond to player actions that threaten narrative structure?

## Methodology

### System Architecture

**Two-Component Design:**

1. **MUTS (Mimesis Unreal Tournament Server)**: Extended UT server with Mimesis components
2. **MC (Mimesis Controller)**: Remote intelligent controller running narrative planning

**Integration Approach:**
- **Declarative-Procedural Mirroring**: Each HTN plan operator in MC mirrored by UnrealScript implementation in MUTS
- **Socket-Based Communication**: MC sends commands to MUTS via network protocol
- **Modular Design**: Components as independent UnrealScript threads and Lisp processes

### Key Technical Components

**MUTS-Side Components (UnrealScript):**

1. **AILink**: Socket-based communications module
   - Routes messages between MC and MUTS
   - Distributes incoming commands to appropriate modules

2. **Funcaller**: Command execution module
   - Parses text command strings from MC
   - Translates to UnrealScript function calls
   - Uses hash table for string-to-object reference resolution
   - Dispatches to appropriate procedures with correct arguments

3. **Mediator**: User action monitoring and intervention
   - Intercepts all user actions before execution
   - Detects exceptions (actions threatening narrative plan)
   - Implements intervention or accommodation responses
   - Caches relevant causal links for fast exception detection

4. **Execution Monitor**: Tracks action completion
   - Reports when actions finish executing
   - Handles durative action semantics (actions taking time)
   - Manages asynchronous execution model

**MC-Side Components (Lisp):**

1. **Central Controller Process**: Coordinates narrative generation
2. **Longbow Planner**: HTN-style narrative planner (adapted from discourse planning)
3. **World Map**: Spatial representation of game environment
4. **Knowledge Base**: Current world state tracking
5. **Socket Communications**: Connects to remote MUTS instances

### HTN Planning Representation

**Action Operators Include:**
- **Preconditions**: World states required for action execution
- **Effects**: Changes to world state upon completion
- **Decompositions**: Hierarchical refinement into sub-actions
- **Temporal Constraints**: Ordering and duration specifications

### Exception Handling

**Two Response Strategies:**

1. **Intervention**: Prevent action execution
   - MC causes action to fail even if normally valid
   - Substitute alternate action with consistent outcome
   - Example: Control dial "jams" to prevent reactor overload

2. **Accommodation**: Allow action, adapt plan
   - Let user action execute
   - Restructure narrative plan "behind the scenes"
   - Minor: Change event location after unexpected turn
   - Major: Replan when user finds key early or destroys critical object

**Optimization Techniques:**
- **Causal Link Cache**: Store only currently relevant constraints for fast lookup
- **Pre-computed Responses**: Generate exception responses during idle time
- **Action Availability Set**: Track which actions have satisfied preconditions

## Key Findings

### 1. **Feasibility of AI-Game Integration**

Successfully demonstrated integration of:
- Complex AI planning (HTN/POCL)
- Real-time game engine (Unreal Tournament)
- Network-distributed architecture

**Key enabler**: Shared declarative action representation between planner and game engine

### 2. **Declarative-Procedural Bridging Pattern**

**Critical insight**: Manually mirror each plan operator with procedural implementation

**Process:**
1. Define action in HTN formalism (preconditions, effects, constraints)
2. Implement corresponding UnrealScript procedure
3. Funcaller translates symbolic commands to procedure calls

**Automated support**: LBUS (LongBow-UnrealScript) tool
- Input: Primitive action operators
- Output: UnrealScript class files with procedure stubs
- Designer fills in low-level behavior implementations

### 3. **Temporal Mismatch Resolution**

**Problem**: MC views actions as atomic with discrete start/end; UT actions are durative and asynchronous

**Solution**: Execution Monitor bridges representations
- Reports action initiation to MC
- Tracks ongoing execution in MUTS
- Signals completion back to MC
- Allows MC to reason about discrete actions while MUTS executes continuously

### 4. **User Agency vs. Narrative Control**

**Core tension**: Player freedom vs. author's story

**Mimesis approach**:
- Generate plan-based storyline before gameplay
- Monitor user actions for narrative threats
- Respond adaptively (intervene or accommodate)
- Maintain illusion of agency while guiding toward narrative outcomes

**Innovation**: Exception detection as causal threat analysis
- User action effects compared to cached causal links
- Violations detected in real-time
- Responses pre-computed during idle periods

### 5. **Modular, Extensible Architecture**

Successfully supports extensions:
- **Virtual Camera Controller**: Film-based shot composition integrated with narrative
- **Text-to-Speech**: Client-side mod for spoken dialogue via Microsoft TTS API
- **Multiple MUTS instances**: Single MC can control multiple game servers

## Important Concepts & Definitions

- **Mimesis** (μίμησις): Greek term meaning "imitation" or "representation"; Aristotle's concept of artistic representation of reality

- **HTN Planning** (Hierarchical Task Network): Planning paradigm where complex tasks decompose into simpler sub-tasks

- **POCL Planning** (Partial Order Causal Link): Planning that builds partially ordered action sequences with explicit causal dependencies

- **Causal Link**: Relationship where one action establishes a condition required by another action

- **Exception**: User action whose effects threaten (i.e., undo or prevent) conditions required by future narrative events

- **Intervention**: Strategy where system prevents user action from executing to maintain narrative coherence

- **Accommodation**: Strategy where system allows user action and restructures narrative plan to adapt

- **Funcaller**: Module translating symbolic action commands into executable game code

- **Mediator**: Module intercepting user actions to detect and respond to narrative threats

- **Longbow**: Discourse planning system adapted for narrative generation (Young, Moore, Pollack 1994)

- **UnrealScript**: Object-oriented scripting language for Unreal Tournament, compiles to platform-independent bytecode

- **Native Code Execution**: Compiled C++ code (developer license only) vs. UnrealScript (available to all licensees)

- **LBUS** (LongBow-UnrealScript): Tool auto-generating UnrealScript class stubs from action operator definitions

## Architecture Diagram (Textual)

```
┌─────────────────────────────────────────────────────────┐
│                    Game Client(s)                        │
│              (Graphics, Audio, Input)                    │
└────────────────────┬────────────────────────────────────┘
                     │ Network
┌────────────────────┴────────────────────────────────────┐
│  MUTS (Mimesis Unreal Tournament Server)                │
│  ┌────────────┐  ┌──────────┐  ┌────────────┐         │
│  │  AILink    │◄─┤ Funcaller├─►│  Mediator  │         │
│  │ (Comms)    │  │(Executor)│  │ (Monitor)  │         │
│  └─────┬──────┘  └────┬─────┘  └─────┬──────┘         │
│        │              │              │                  │
│        │         ┌────┴──────────────┴────┐            │
│        │         │  Execution Monitor     │            │
│        │         └────────────────────────┘            │
└────────┼────────────────────────────────────────────────┘
         │ Socket Connection
┌────────┴────────────────────────────────────────────────┐
│  MC (Mimesis Controller) - Remote Lisp Process          │
│  ┌─────────────────────────────────────────────────┐   │
│  │          Central Controller Process              │   │
│  └───┬─────────────────────────────────────────┬───┘   │
│      │                                         │        │
│  ┌───┴──────────┐  ┌──────────────┐  ┌───────┴─────┐ │
│  │   Longbow    │  │  World Map   │  │  Knowledge  │ │
│  │   Planner    │  │  (Spatial)   │  │    Base     │ │
│  └──────────────┘  └──────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Implementation Status (as of paper)

### Completed Components

✅ MC plan generation for interaction storylines  
✅ Command transmission MC → MUTS  
✅ Funcaller execution of UnrealScript procedures  
✅ AILink socket-based communication  
✅ LBUS tool for auto-generating UnrealScript stubs  
✅ Virtual camera controller (with film idioms)  
✅ Text-to-speech client mod (Microsoft TTS API)

### In Progress

🔄 Execution monitoring (partially implemented)  
🔄 Mediator functionality (partially implemented)  
🔄 End-to-end system integration

## Limitations

### Acknowledged Limitations

1. **Manual Mirroring**: Declarative-procedural correspondence created manually by designers (LBUS only generates stubs)

2. **Incomplete Implementation**: Execution Monitor and Mediator not fully operational at time of writing

3. **Intervention Visibility**: Players may notice when actions mysteriously fail (breaks immersion)

4. **Computational Overhead**: Exception detection and response generation add latency

5. **Domain Specificity**: Requires domain-specific action operators for each story world

### Additional Limitations

6. **Single-User Focus**: Architecture descriptions don't address multi-user narrative coordination

7. **Limited Adaptation**: Accommodation responses pre-computed only for currently available actions (may miss creative player strategies)

8. **No Learning**: System doesn't learn from player behavior to improve future narratives

9. **Binary Success/Failure**: Actions either succeed or fail (no partial success or degraded outcomes)

10. **Centralized MC**: Single point of failure; MC crash disrupts all connected MUTS instances

11. **Network Latency**: Socket-based communication introduces delays between planning and execution

12. **No User Modeling**: Doesn't adapt narrative complexity or style to individual player preferences

## Relevance to Thesis

This paper is **foundational** for understanding LLM-based believable agent architectures in game/simulation contexts:

### Key Connections

1. **Planning-Execution Bridge**: Mimesis's declarative-procedural mirroring pattern directly applicable to:
   - LLM-generated plans → executable agent actions
   - PDDL/STRIPS representations → Python/game code (cf. [`tantakounLLMsPlanningModelers2025`], [`huangPlanningDarkLLMSymbolic2024`])
   - Natural language action descriptions → structured function calls

2. **Real-Time Narrative Control**: Mimesis's approach to balancing story coherence with player agency parallels:
   - LLM agent autonomy vs. system-level objectives
   - Character intentions vs. narrative outcomes ([`riedlNarrativePlanningBalancing2010`])
   - Local action selection vs. global coherence

3. **Exception Handling**: Intervention/accommodation strategies inform:
   - LLM agent constraint enforcement (soft via prompting, hard via filtering)
   - Handling unexpected agent behaviors in multi-agent simulations
   - Replanning when LLM agents deviate from expected behaviors

4. **Modular Architecture**: Clean separation of concerns (planning, execution, monitoring) provides pattern for:
   - LLM orchestration layers (cf. [`zhangAgenticContextEngineering2025`])
   - Agent memory vs. reasoning vs. action modules ([`parkGenerativeAgentsInteractive2023`])
   - Distributed LLM agent systems

5. **Commercial Integration**: Demonstrates feasibility of integrating AI research with production systems—relevant for deploying LLM agents in real applications

### Methodological Relevance

- **Prototype-Driven**: Build working system first, evaluate later (vs. theoretical-first approaches)
- **Leverage Existing Infrastructure**: Use game engines (UT) / LLMs (GPT-4) rather than building from scratch
- **Modular Development**: Implement components incrementally with clear interfaces

### Theoretical Contribution

- **Narrative as Multi-Layer Control**: Story generation (MC) + execution monitoring (MUTS) + user interaction (clients)
- **Declarative-Procedural Duality**: Same action represented symbolically (for reasoning) and procedurally (for execution)
- **Adaptive Storytelling**: Real-time narrative adjustment based on participant actions

### Contrasts with LLM Approaches

| Mimesis (Symbolic Planning) | LLM-Based Agents |
|-----------------------------|------------------|
| Explicit HTN action models | Implicit action knowledge in weights |
| Guaranteed causal coherence | May produce contradictions |
| Pre-planned storylines | Generated narratively in real-time |
| Manual operator authoring | Few-shot prompted actions |
| Deterministic (given plan) | Stochastic sampling |
| Separate planning/execution | Unified generation process |

**Synergy Opportunity:**
- Use LLMs to generate Mimesis-style action operators from natural language descriptions
- Use Mimesis exception detection to validate/constrain LLM agent actions
- Combine LLM flexibility with symbolic planning's coherence guarantees

## Notable Quotes

> "The benefit of this approach for AI researchers is immediate; use of systems like UT provide readily accessible, stable and high-quality graphics, networking, database and process execution support for virtual environments, eliminating the need for time consuming development of these components in a research project."

> "The principal factor that allows the integration of AI research tools and technology with the existing UT server engine is the sharing between the two of a declarative representation of action and of the conditions within the UT server's virtual world."

> "When a user's action would violate one of the narrative plan's constraints, Mimesis can intervene, causing the action to fail even when its execution in the current world state would normally succeed."

> "The second response to an exception is to adjust the narrative structure of the plan to accommodate the new activity of the user. When accommodating an exception, the system allows the user's command to execute in the virtual world, then reconsiders the narrative context to look for changes that can be made 'behind the scenes' to avoid the original exception's conflict."

> "Clearly, the computational process of detecting exceptions is a time-critical task, particularly when intervention is a potential response."

## Related Systems & Influences

### Builds On
- **Longbow**: Discourse planning system (Young, Moore, Pollack 1994) adapted for narrative
- **DPOCL**: Discourse planning with causal links (Young & Moore 1994)
- **HTN Planning**: Hierarchical Task Network formalism (Erol, Hendler, Nau 1994)

### Contemporary Work
- **Façade** (Mateas & Stern): Interactive drama with autonomous characters ([`mateasOzCentricReviewInteractive1999`])
- **Oz Project**: Believable agents and interactive drama at CMU

### Game Engine Context
- **Unreal Tournament** (Epic Games 1999): First-person shooter used as platform
- **UnrealScript**: Object-oriented scripting language for UT extensibility
- **Client-Server Architecture**: Standard multiplayer game design pattern

## Future Directions (Implied)

1. **Complete Implementation**: Finish execution monitor and mediator modules
2. **User Evaluation**: Test with real players to assess narrative quality and agency perception
3. **Multi-User Support**: Extend to coordinate narratives across multiple simultaneous players
4. **Automated Operator Generation**: Expand LBUS to generate full implementations, not just stubs
5. **Learning System**: Adapt narrative strategies based on player behavior patterns
6. **Richer Exception Responses**: More sophisticated accommodation strategies beyond location/timing changes

## Historical Context

**Era**: Early 2000s (post-STRIPS, emergence of commercial AI in games)

**Significance**:
- One of first integrations of academic AI planning with commercial game engine
- Pioneered "drama manager" architectural pattern
- Influenced interactive narrative and procedural storytelling research

**Technical Context**:
- Pre-LLM era: Symbolic AI still dominant for reasoning
- Game AI mostly reactive (FSMs, behavior trees)
- Narrative in games typically scripted linearly or branching

## Impact & Legacy

**Influenced:**
- Interactive narrative systems research
- Drama manager architectures
- Procedural storytelling in games
- Multi-agent simulation with narrative goals

**Architectural Patterns Established:**
- Separation of narrative planning from execution
- Exception-based narrative adaptation
- Declarative-procedural action mirroring
- Modular intelligent controller design

## Tags

`#mimesis` `#interactive-narrative` `#drama-manager` `#HTN-planning` `#unreal-tournament` `#game-AI` `#narrative-generation` `#real-time-systems` `#exception-handling` `#architecture` `#liquid-narrative` `#planning-execution-bridge`

---

**Processing Notes:**
- Short paper: ~8 pages (symposium overview paper)
- Implementation-focused: describes working prototype
- Clear architectural descriptions with technical details
- Limited evaluation (system still under development)
- Foundational for drama manager / interactive narrative architectures
