# Fast and Accurate Task Planning using Neuro-Symbolic Language Models and Multi-level Goal Decomposition

**Authors:** Minseo Kwon, Yaesol Kim, Young J. Kim  
**Year:** Not specified (recent, references 2024 works)  
**Citation Key:** kwonFastAccurateTask  
**Institution:** Department of Computer Science and Engineering, Ewha Womans University, Korea

## Abstract / Overview
This paper proposes a novel neuro-symbolic task planner that addresses the limitations of both symbolic planners (slow speed) and LLM-based planners (low accuracy). The approach decomposes complex long-horizon robotic tasks into manageable subgoals using LLMs and then solves each subgoal using either symbolic planners or MCTS-based LLM planners depending on subgoal complexity, achieving high success rates (88.2-100%) while significantly reducing planning time.

## Key Research Questions
- How can we combine the precision of symbolic planners with the speed and commonsense reasoning of LLMs for robotic task planning?
- Can goal decomposition using LLMs reduce the exponential search space problem in symbolic planning while maintaining high success rates?
- What is the optimal strategy for choosing between symbolic and LLM-based planning for different subgoal complexities?

## Methodology

### Planning Pipeline
The system formulates task planning as a **multi-valued planning task (MPT)**:
- **P ≡ ⟨S, O, A, T, s₀, S⋆⟩** where S is states, O is objects, A is actions, T is transition function, s₀ is initial state, S⋆ is goal states

### Three Major Steps

1. **Planning Formulation**
   - Uses multimodal LLM (GPT-4o) to process RGB-D images and text prompts
   - Generates PDDL problem specifications including objects, initial state, and goal state
   - Employs 2D open-vocabulary object detection for geometric information (bounding boxes)
   - One-shot prompting for PDDL generation

2. **Subgoal Generation**
   - LLM (L-Model) decomposes complex goals into ordered sequence of subgoals: G = {S⋆₀, S⋆₁, ..., S⋆ₙ}
   - Each subgoal is reachable from previous subgoal via finite state transitions
   - Transforms original problem P into n smaller sub-problems Pᵢ
   - Uses domain knowledge and one-shot examples with step-by-step explanations

3. **Task Planning**
   - For each sub-problem Pᵢ, finds policy πᵢ
   - Chooses between two planners based on estimated problem complexity:
     - **Symbolic LLM Planner**: For moderate complexity (uses Fast Downward planner)
     - **MCTS LLM Planner**: For high complexity (uses custom MCTS with LLM)

### MCTS LLM Planner Details

1. **Plan Sampling**
   - Samples nₛ plans using LLM (L-Policy) for sub-problem Pᵢ
   - Computes action weights from token log probabilities (reflects LLM confidence)
   - Action weight = sum of token log probabilities for each action

2. **State Tree Generation**
   - Coalesces sampled plans into state tree Tᵢ
   - Each node = state s ∈ S, each edge = action a ∈ A
   - Validates action preconditions from domain PDDL
   - Tree bounds MCTS search space to valid LLM-generated actions

3. **Monte Carlo Tree Search**
   - **Selection**: Traverse tree using UCB1 score (exploration parameter = 1) until reaching unvisited node
   - **Simulation**: Rollout policy selects next nodes by highest action weight until leaf node
   - **Backpropagation**: Update traversed nodes with rewards
   - **Reward function**: r = 1/(1+d) where d is distance to goal, or r=1 if goal reached, else r=0
   - Stops when goal state found, traces back to construct plan πᵢ

### Experimental Domains

Tested on three IPC domains with varying complexity (n):

1. **Barman-new**: Dual-arm manipulator making 2 ≤ n ≤ 10 cocktails
2. **Blocksworld-new**: Robotic arm restacking 3 ≤ n ≤ 10 blocks with 6 placement positions
3. **Gripper-new**: Four robots moving 2 ≤ n ≤ 10 balls to four rooms (multi-agent scenario)

Generated 30 random problem PDDL files per complexity level.

## Key Findings

1. **Hybrid Approach Outperforms Baselines**
   - **Symbolic LLM planner**: 100% success rate across all domains
   - **MCTS LLM planner**: Average 98.5% (Barman-new), 92.6% (Blocksworld-new), 88.2% (Gripper-new)
   - **CoT baseline**: Success rate approaches 0% as complexity increases
   - **Fast Downward baseline**: 100% success but exponentially increasing time

2. **Significant Speed Improvements Over Symbolic Planners**
   - Planning time grows much more slowly than symbolic planners
   - MCTS LLM shows almost linear time growth with complexity
   - Trade-off: 3.3× to 10.2× slower than CoT but with ~100% vs ~0% success rate

3. **Domain-Specific Performance Characteristics**
   - **Barman-new** (long MDL, large state space): MCTS LLM faster than Symbolic LLM
   - **Blocksworld-new & Gripper-new** (shorter MDL): Symbolic LLM faster than MCTS LLM
   - Demonstrates adaptive planner selection is beneficial

4. **Goal Decomposition is Critical**
   - MCTS with goal decomposition: high success rates
   - MCTS without goal decomposition: approaching 0% for complex problems
   - Decomposition reduces search space and enables LLM focus on manageable tasks

5. **Number of Sampled Plans (nₛ)**
   - Higher nₛ (3→5) generally improves success rate with increased planning time
   - Improvement saturates due to upper bound on search space complexity
   - Subgoal decomposition further restricts the effective search space

## Important Concepts & Definitions

- **L-Policy**: Using LLM to directly query proper policy for a given state (exploits commonsense knowledge)
- **L-Model**: Using LLM as simulation model to query resulting state after executing an action/policy
- **Minimum Description Length (MDL)**: Measure of problem complexity; determines planner selection
- **Multi-valued Planning Task (MPT)**: Planning formulation with fully observable states, deterministic transitions
- **Neuro-symbolic Planning**: Hybrid approach combining neural (LLM) and symbolic (PDDL) methods
- **Subgoal Decomposition**: Breaking complex goal into ordered sequence of simpler, reachable subgoals
- **Token Inefficiency**: LLM limitation due to long, repetitive sequences in planning descriptions
- **Correction Inefficiency**: LLM tendency to generate hallucinated action sequences requiring correction

## Formulas & Metrics

### Multi-valued Planning Task
```
P ≡ ⟨S, O, A, T, s₀, S⋆⟩
```
- S: finite set of fully observable states
- O: environment objects
- A: finite set of actions
- T: S × A → S (deterministic state transition)
- s₀ ∈ S: initial state
- S⋆ ⊂ S: set of goal states

### Subgoal Sequence
```
G = {S⋆₀, S⋆₁, ..., S⋆ₙ}
where S⋆₀ = {s₀}, S⋆ₙ = S⋆
```

### Sub-problem Definition
```
Pᵢ ≡ ⟨S, O, A, T, sᵢ, S⋆ᵢ₊₁⟩
```

### UCB1 Score
Used in MCTS selection phase (exploration parameter = 1)

### Reward Function (MCTS Simulation)
```
r = 1/(1+d)  if s⋆ ∈ S⋆ᵢ₊₁
r = 1         if sᵣ ∈ S⋆ᵢ₊₁
r = 0         otherwise
```
where d = nodal distance from sᵣ to s⋆

### Action Weight
```
w(a) = Σ log P(token | previous tokens)
```
Sum of token log probabilities, represents LLM confidence

### PSPACE-hard Complexity
Symbolic planners have exponential time complexity in worst case

## Results & Statistics

### Success Rates (Domain-specific)
- **Barman-new**: Symbolic LLM 100%, MCTS LLM 98.5%
- **Blocksworld-new**: Symbolic LLM 100%, MCTS LLM 92.6%
- **Gripper-new**: Symbolic LLM 100%, MCTS LLM 88.2%
- **CoT baseline**: Approaches 0% as n increases
- **Fast Downward**: 100% across all domains

### Planning Time Multipliers (vs. CoT baseline)
- **Barman-new**: Symbolic 6.5×, MCTS 3.8×
- **Blocksworld-new**: Symbolic 4.9×, MCTS 10.2×
- **Gripper-new**: Symbolic 3.36×, MCTS 8.0×

### Ablation Study
- MCTS with goal decomposition: High success rates maintained
- MCTS without goal decomposition: ~0% success on complex problems
- Validates critical importance of subgoal generation step

### Experimental Setup
- 30 randomly generated problem PDDL files per complexity level n
- Complexity range: 2 ≤ n ≤ 10 (varies by domain)
- Validation: PDDL validator VAL
- LLM: GPT-4o, temperature 0.0
- Symbolic planner: Fast Downward with "seq-opt-fdss-1" configuration

### Real Robot Demonstration
- **Hardware**: Dual UR5e manipulators with Robotiq 3F grippers
- **Vision**: Intel RealSense D455 RGB-D camera (top-down view)
- **Software**: MoveIt motion planner, ROS, CoppeliaSim for simulation
- Successfully demonstrated Blocksworld-new (10 blocks, real) and Barman-new (simulation)

## Limitations

1. **Motion Planning Assumptions**
   - Assumes every high-level action primitive has feasible low-level solution
   - Does not explicitly handle motion planning or execution failures
   - May lead to execution uncertainties in real-world scenarios

2. **Execution Failures**
   - Stability issues: occlusion in cluttered environments
   - Inaccurate planning formulation from sensor errors
   - Failed grasps and collapsed block stacks

3. **Planning Failures (MCTS LLM)**
   - Struggles with spatial reasoning in Blocksworld-new
   - Misordered block stacking sequences
   - Misinterprets goal states in Gripper-new (moving irrelevant balls)

4. **Planner Selection Criteria**
   - Currently relies on empirical criteria for choosing symbolic vs. MCTS
   - No automated strategy for determining optimal subgoal decomposition level
   - MDL estimation is difficult in practice for complex tasks

5. **Generalizability**
   - Tested primarily on three specific PDDL domains
   - Unclear how well subgoal decomposition generalizes to arbitrary real-world tasks
   - Limited evaluation in multi-agent systems beyond Gripper-new

6. **Scalability Questions**
   - Performance on very large state spaces (n >> 10) not fully explored
   - Computational cost of running multiple MCTS iterations for many subgoals

## Relevance to Thesis

This paper is highly relevant to the thesis on believable agents and LLMs, particularly for understanding how LLMs can be integrated into planning systems for autonomous agents. While the focus is on robotic task planning rather than believability per se, the methodology demonstrates critical capabilities needed for believable agent behavior.

**Key connections:**

1. **Planning and Reasoning**: The paper addresses fundamental challenges in making LLM-based agents plan coherently over long horizons, which is essential for believable behavior. Believable agents must demonstrate goal-directed, rational planning rather than hallucinated or inconsistent actions.

2. **Hybrid Symbolic-Neural Architectures**: The neuro-symbolic approach shows how combining structured knowledge (PDDL) with learned models (LLMs) can achieve both accuracy and efficiency. This is relevant for building believable agents that need both commonsense reasoning and precise action execution.

3. **Goal Decomposition for Complex Tasks**: The multi-level subgoal generation methodology could be applied to social planning and character behavior. Believable NPCs or dialogue agents must break down complex social goals (e.g., "befriend the player") into achievable subgoals, similar to how this system decomposes robotic tasks.

4. **Evaluation Methodology**: The rigorous experimental design with success rate metrics, planning time analysis, and ablation studies provides a model for evaluating believability components. The validation approach (using PDDL validator) demonstrates the importance of ground-truth verification.

5. **Failure Analysis**: Understanding failure modes (spatial reasoning errors, goal misinterpretation) is crucial for designing robust believable agents. The paper's categorization of execution vs. planning failures mirrors challenges in believable agent systems.

## Notable Quotes

> "Despite their strengths, LLMs suffer from token inefficiency and correction inefficiency, often generating hallucinated action sequences and failing on complex tasks." (Introduction)

> "Solving a complex task by breaking it down into smaller, easier tasks is often effective. In our case, while LLMs can directly generate relatively accurate plans for smaller tasks, their performance significantly decreases as the task complexity increases and the plan grows beyond a certain size." (Section III-B)

> "Our MCTS is quite different from conventional MCTS in that: 1) we already expanded the tree Ti that is fixed and constrains the overall search space, so the expansion step is not needed during the search; 2) our rollout policy searches only within Ti." (Section IV-B-3)

> "The CoT planner is the fastest among the four but has the lowest accuracy, with its success rate approaching nearly zero as n increases; on the other hand, the FD planner maintains a 100% success rate, but its planning time increases exponentially as n grows." (Section V-B)

> "We conducted an ablation study on the effectiveness of goal decomposition. [...] our planner with goal decomposition achieved a much higher success rate than the one without it, whereas the planner without goal decomposition approached zero success rates for complex problems." (Section V-B, Ablation Study)

## References to Follow Up

1. **Zhao et al. (2024)** - "Large language models as commonsense knowledge for large-scale task planning" - Introduces L-Model and L-Policy concepts, MCTS with LLMs for POMDPs
2. **Hu et al. (2023)** - "Tree-planner: Efficient close-loop task planning with large language models" - Tree-based LLM planning with action sampling
3. **Liu et al. (2023)** - "LLM+P: Empowering large language models with optimal planning proficiency" - LLM translation to PDDL for planning
4. **Silver et al. (2024)** - "Generalized planning in PDDL domains with pretrained large language models" - Python function generation for PDDL with automated debugging
5. **Valmeekam et al. (2023)** - "On the planning abilities of large language models (a critical investigation with a proposed benchmark)" - Critical analysis of LLM planning limitations

## Tags
`#task-planning` `#llm` `#neuro-symbolic` `#robotics` `#pddl` `#mcts` `#goal-decomposition` `#hybrid-planning` `#l-model` `#l-policy` `#symbolic-planning` `#evaluation` `#multi-agent`
