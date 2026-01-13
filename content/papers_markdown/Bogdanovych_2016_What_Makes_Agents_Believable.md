# What Makes Virtual Agents Believable?

**Authors:** Anton Bogdanovych, Tomas Trescak, Simeon Simoff  
**Source:** Connection Science, 2016, Vol. 28, No. 1, 83-108  
**DOI:** 10.1080/09540091.2015.1130021

## Abstract

This paper investigates the concept of believability and attempts to isolate individual characteristics (features) that contribute to making virtual characters believable. The study produces a formalization of believability and builds a computational framework (I2B) focused on simulation of believable virtual agents. A user study tests whether identified features are responsible for agents being perceived as more believable.

## Key Findings

Agents that are perceived as more believable possess these features:
1. **Resource bounded** - show visible limits to physical/mental capabilities
2. **Environment aware** - aware of surroundings and context
3. **Self-aware** - aware of own state, goals, and capabilities  
4. **Interaction aware** - understand dynamic aspects of interactions
5. **Can adapt** - able to change behavior in response to environment
6. **Exist in correct social context** - appropriate social roles and relationships

## Believability Definition

> "A believable virtual agent is an autonomous software agent situated in a virtual environment that is life-like in its appearance and behavior, with a clearly defined personality and distinct emotional state, is driven by internal goals and beliefs, consistent in its behaviour, is capable of interacting with its environment and other participants, is aware of its surroundings and capable of changing its behaviour over time."

## Formalization

Believability (β) is formalized as:

β = ⟨AT, PT, ET, L, SR, ϒ, δ, Aw⟩

Where:
- **AT** = Appearance features
- **PT** = Personality  
- **ET** = Emotional state
- **L** = Liveness (includes illusion of life, verbal/non-verbal behavior)
- **SR** = Social relationships
- **ϒ** = Consistency constraints
- **δ** = Change function (learning/adaptation)
- **Aw** = Awareness (environment, self, interaction)

## Key Components Details

### Illusion of Life (IL)
```
IL = ⟨Goals, Concurrency, Immersion, ResourceLimitation, 
      SocialContext, BroadCapability, Reactivity, Proactiveness⟩
```

### Awareness Believability (Aw)
```
Aw = ⟨EA, SA, IA⟩
```

- **EA** (Environment Awareness) = {Objects, Avatars, Time}
- **SA** (Self-Awareness) = {Goals, Plans, Beliefs, Scene, State, ObjectsUsed, Role, Gestures}
- **IA** (Interaction Awareness) = {VisibleAvatars, SceneAvatars, Actions, Objects, State, Position, Orientation}

## Evaluation Results

### Statistical Significance
Study with 65 participants (43 for Loyall features, 22 for awareness features)

### Feature Ranking by Δ (contribution to believability):

1. **Resource bounded**: Δ = 0.58, p = 0.002 ✓
2. **Overall awareness**: Δ = 0.49, p < 0.001 ✓
   - Environment awareness: Δ = 0.54
   - Self-awareness: Δ = 0.49  
   - Interaction awareness: Δ = 0.47
3. **Change**: Δ = 0.34, p = 0.016 ✓
4. **Exist in social context**: Δ = 0.33, p = 0.016 ✓
5. **Reactive and responsive**: Δ = 0.31, p = 0.029 ✓
6. **Emotion**: Δ = 0.13, p = 0.049 ✓

### Features NOT statistically significant:
- Consistency of expression: Δ = 0.17, p = 0.457
- Personality: Δ = 0.12, p = 0.457
- Social relationships: Δ = 0.11, p = 0.457
- Broad capability (gestures): Δ = 0.30, p = 0.077
- Self-motivation: p = 0.008 (negative result - users preferred no feature!)

## I2B Framework Implementation

### Components:
1. **Appearance** - Parametric avatars (height, build, etc.)
2. **Personality** - OCEAN model (Big Five)
3. **Emotional State** - OCC emotional model
4. **Liveness:**
   - Goal generation (BDI approach)
   - Planning (static and dynamic A* search)
   - Obstacle avoidance
   - Object use
   - Non-verbal behavior (gestures, gaze)
   - Verbal behavior (ALICE chat engine + AIML)
5. **Social Relationships** - Virtual institutions technology
6. **Consistency** - Rule-based norms management
7. **Change** - Imitation learning, AIML modification
8. **Awareness** - Environment tree representation

### Case Study
- Simulation of Darug Aboriginal people (1770 A.D., Parramatta, Australia)
- 25 agents in "Generations of Knowledge" project
- Agents perform daily activities: tool making, painting, fishing, ceremonies

## Methodological Contributions

### Believability Index Calculation
For measuring perceived believability:

```
hp(ci) = |rp(ci) - A| / (A - B)
```

Where:
- hp(ci) = perception of participant p of correspondence ci as human-like
- rp(ci) = rating given by participant p
- A = "Artificial" value on scale
- B = "Human" value on scale

Overall believability index: B = Σbn / m

Comparison measure: Δ = |BFeaturePresent - BFeatureMissing|

## Limitations & Discussion

1. **Limited scenarios** - Each feature tested with one representative scenario
2. **Some features hard to isolate** - E.g., "being well integrated"
3. **Uncanny valley** not addressed for appearance
4. **Low statistical significance** for some Loyall features may indicate:
   - Scenario design issues
   - Need for more participants
   - Features genuinely less important

## Future Work

- More extensive studies with multiple scenarios per feature
- Longer-term simulations
- Testing features with different populations
- Addressing identified glitches and limitations

## Relevance to NSP-LLM Thesis

This paper provides:
1. **Formal model** of believability that can guide agent design
2. **Empirical validation** of which features matter most
3. **Quantitative metrics** (believability index) for evaluation
4. **Awareness** identified as crucial - highly relevant for NSP systems
5. **Resource boundedness** as top factor - important constraint for planning
6. **Practical implementation** (I2B framework) as reference architecture

## Key Quotes

> "Resource bounded agents that appear to have limits to their capabilities are perceived as significantly more believable (Δ = 0.58)"

> "Agent awareness is the next most important set of features (Δ = 0.49), meaning agents aware of their environment, interaction capabilities and own state."

> "Simply displaying emotions is not enough. The use of emotions has to be consistent with the personality, situation, and past history."
