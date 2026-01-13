# Generative Agents: Interactive Simulacra of Human Behavior

**Authors:** Joon Sung Park, Joseph C. O'Brien, Carrie J. Cai, Meredith Ringel Morris, Percy Liang, Michael S. Bernstein  
**Conference:** UIST '23, October 29-November 1, 2023, San Francisco, CA, USA  
**DOI:** 10.1145/3586183.3606763

## Abstract

This landmark paper introduces **generative agents**: computational software agents that simulate believable human behavior using large language models (LLMs). The agents wake up, cook breakfast, work, form opinions, remember experiences, reflect on the past, and plan future behavior. The architecture extends LLMs with mechanisms for memory storage, synthesis (reflection), and dynamic retrieval to maintain long-term coherence.

## Key Innovation: The Architecture

### Three Core Components:

1. **Memory Stream** - Comprehensive record of agent experiences in natural language
   - Observations (directly perceived events)
   - Reflections (higher-level inferences)
   - Plans (future action sequences)

2. **Retrieval Mechanism** - Surfaces relevant memories based on:
   - **Recency**: Exponential decay (factor = 0.995)
   - **Importance**: LLM rates 1-10 (mundane to poignant)
   - **Relevance**: Cosine similarity of embeddings

   Final score: `score = α_recency · recency + α_importance · importance + α_relevance · relevance`

3. **Reflection** - Periodic synthesis of experiences into higher-level thoughts
   - Triggered when importance scores exceed threshold (150 in implementation)
   - Generates questions about recent experiences
   - Produces insights with citations to source memories
   - Creates **reflection trees** (observations → reflections → meta-reflections)

## Planning and Reaction

### Planning Process:
1. **Top-down recursive decomposition**
   - Day-level plan (5-8 chunks)
   - Hour-level plans
   - 5-15 minute action plans

2. **Dynamic re-planning**
   - Agents perceive environment each time step
   - LLM decides: continue plan or react?
   - Generate new plans when circumstances change

### Example Plan Hierarchy:
```
Day: "wake up, attend class, work on composition, have dinner, do assignments, sleep"
↓
Hour: "1pm: brainstorm ideas for composition... 4pm: take break and recharge"
↓
5-min: "4:00pm: grab light snack... 4:05pm: short walk... 4:50pm: clean workspace"
```

## Smallville: The Sandbox Environment

### Setup:
- 25 agents in a Sims-style game world
- 2 full game days of simulation
- Natural language interaction
- Sprite-based 2D environment with realistic spaces (cafe, park, homes, etc.)

### Emergent Social Behaviors Observed:

1. **Information Diffusion**
   - Sam's mayoral candidacy: spread from 1 agent → 8 agents (32%)
   - Isabella's Valentine's party: 1 agent → 13 agents (52%)

2. **Relationship Formation**
   - Network density increased from 0.167 → 0.74
   - Only 1.3% hallucinated relationships

3. **Coordination**
   - Isabella plans party → invites agents → decorates cafe
   - 5 out of 12 invited agents attended
   - Agents showed up at correct time and location

### Example: Valentine's Day Party
Starting condition: One agent (Isabella) initialized with intent to throw a party

Emergent chain of events:
1. Isabella spreads word about party
2. Agents remember and decide to attend
3. Maria invites Klaus (her crush) as her date
4. Agents help decorate
5. Agents show up at correct time (5pm, Feb 14)
6. Agents interact naturally at the party

## Evaluation Results

### Controlled Study (100 participants)
Agents ranked by believability using TrueSkill ratings:

1. **Full architecture**: μ = 29.89, σ = 0.72
2. **No reflection**: μ = 26.88, σ = 0.69  
3. **No reflection/planning**: μ = 25.64, σ = 0.68
4. **Human crowdworkers**: μ = 22.95, σ = 0.69
5. **No memory/reflection/planning**: μ = 21.21, σ = 0.70

Effect size vs baseline: **d = 8.16** (eight standard deviations!)

All pairwise differences significant (p < 0.001) except crowdworker vs fully ablated baseline.

### Interview Categories (5 questions each):
1. **Self-knowledge** - "Give an introduction of yourself"
2. **Memory** - "Who is [name]?" "Who is running for mayor?"
3. **Plans** - "What will you be doing at 10am tomorrow?"
4. **Reactions** - "Your breakfast is burning! What would you do?"
5. **Reflections** - "If you could spend time with one person, who and why?"

## Key Findings

### What Works:
- **Memory retrieval** enables consistent character and accurate recall
- **Reflection** necessary for deeper synthesis and decisions
- **Planning** prevents contradictions over time (e.g., eating lunch 3 times in a row)
- **Emergent behavior** from bottom-up interactions (no scripted coordination)

### Failure Modes:
1. **Memory retrieval errors** - Missing relevant information
2. **Hallucination** - Embellishing details not in memory
3. **Location selection issues** - As agents learn more places, may choose atypical locations
4. **Overly formal dialogue** - Effect of instruction tuning in base LLM
5. **Over-cooperation** - Agents too agreeable, don't say "no" enough

## Technical Implementation

### Environment Representation:
- Tree data structure (rooms contain objects)
- Converted to natural language for LLM
- Example: "stove" → child of "kitchen" → "there is a stove in the kitchen"

### Memory to Action Pipeline:
1. Perceive environment → add observations to memory stream
2. Retrieve relevant memories (recency + importance + relevance)
3. Generate or update plan
4. Decide specific action location (recursive tree traversal)
5. Execute action, update object states

### Optimizations:
- **Cached summaries** of agent identity (name, traits, occupation, self-assessment)
- **Just-in-time planning** - Only decompose near-future in detail
- Currently sequential (real-time), but parallelizable

## Prompting Examples

### Generating Plans:
```
Name: Eddy Lin (age: 19)
Innate traits: friendly, outgoing, hospitable
[... background description ...]
On Tuesday February 12, Eddy 1) woke up and completed morning routine at 7am, [...]
Today is Wednesday February 13. Here is Eddy's plan today in broad strokes: 1)
```

### Deciding to React:
```
[Agent's Summary Description]
It is February 13, 2023, 4:56 pm.
John Lin's status: John is back home early from work.
Observation: John saw Eddy taking a short walk around his workplace.
Summary of relevant context from John's memory: [...]
Should John react to the observation, and if so, what would be an appropriate reaction?
```

### Generating Dialogue:
```
[Agent's Summary Description]  
John is asking Eddy about his music composition project. What would he say to Eddy?
```

## Applications

1. **Social Prototyping** - Test platform designs with believable user proxies
2. **Role-play & Training** - Practice difficult conversations (job interviews, conflicts)
3. **Human-centered Design** - Model user behaviors (like Sal in Weiser's ubicomp vignette)
4. **Virtual Worlds & Games** - Populate environments with autonomous NPCs
5. **Research Tool** - Test social science theories safely

## Ethical Considerations

### Risks Identified:
1. **Parasocial relationships** - Users may form inappropriate attachments
2. **Error propagation** - Wrong inferences could cause harm in real applications
3. **Deepfakes & misinformation** - Could be used maliciously
4. **Over-reliance** - Shouldn't replace real human input in design

### Proposed Mitigations:
- Agents must disclose computational nature
- Value-aligned to avoid inappropriate behaviors
- Audit logs of inputs/outputs for accountability
- Use only for prototyping, never as substitute for human stakeholders

## Implementation Details

- **Base Model**: GPT-3.5-turbo (gpt3.5-turbo version of ChatGPT)
- **Embeddings**: text-embedding-ada-002
- **Cost**: Thousands of dollars in API credits for 2-day simulation
- **Time**: Multiple days to complete full simulation
- **Environment**: Phaser web game framework
- **Agents**: 25 agents in Smallville
- **Code**: Open source at github.com/joonspk-research/generative_agents
- **Demo**: reverie.herokuapp.com/UIST_Demo/

## Comparison to Prior Work

### vs Social Simulacra (Park et al. 2022):
- Stateless personas → **Stateful agents with memory**
- Single-turn responses → **Long-term coherent behavior**
- No coordination → **Emergent group dynamics**

### vs Cognitive Architectures (SOAR, ACT-R):
- Hand-coded procedures → **LLM-generated behavior**
- Symbolic structures → **Natural language memories**
- Limited scope → **Open-world capable**

### vs Rule-based NPCs (FSM, behavior trees):
- Scripted paths → **Emergent narratives**
- Static responses → **Dynamic adaptation**
- Predetermined → **Learned from experience**

## Future Work

1. **Improve retrieval** - Fine-tune relevance/importance functions
2. **Reduce cost** - Parallelize agents, specialized LLMs
3. **Longer evaluations** - Observe behavior over extended periods
4. **Robustness testing** - Prompt hacking, memory hacking, hallucination
5. **Address biases** - Inherited from base LLM
6. **Better models** - GPT-4 and future improvements

## Key Quotes

> "Believable agents are designed to provide an illusion of life and present a facade of realism in the way they appear to make decisions and act on their own volition" (citing Bates, 1994)

> "We demonstrate through ablation that the components of our agent architecture—observation, planning, and reflection—each contribute critically to the believability of agent behavior."

> "For example, starting with only a single user-specified notion that one agent wants to throw a Valentine's Day party, the agents autonomously spread invitations to the party over the next two days, make new acquaintances, ask each other out on dates to the party, and coordinate to show up for the party together at the right time."

## Relevance to NSP-LLM Thesis

This paper is **directly relevant** because:

1. **First LLM-based believable agent architecture** with demonstrated success
2. **Memory + Reflection + Planning** paradigm applicable to NSP domains
3. **Empirical validation** of what makes agents believable
4. **Open-world capability** - agents handle unexpected situations
5. **Emergent social behavior** - relevant for multi-agent NSP systems
6. **Identified failure modes** - what to avoid/improve
7. **Practical implementation** - can build upon their architecture

## Connection to Believability Theory

Addresses Loyall (1997) and Bates (1994) requirements:
- ✅ Personality (via background description)
- ✅ Emotion (emergent from context)
- ✅ Self-motivation (internal goals)
- ✅ Change (via reflection and adaptation)
- ✅ Social relationships (emergent from interactions)
- ✅ Consistency (via memory retrieval)
- ✅ Illusion of life (via full architecture)

Goes beyond by adding:
- **Long-term memory** (comprehensive record)
- **Recursive reflection** (trees of abstractions)
- **Dynamic retrieval** (relevance-based)
- **Natural language grounding** (LLM-native)
