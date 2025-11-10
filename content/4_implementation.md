# Chapter 4: Implementation

## 4.1 System Architecture Overview

The implementation transforms the Generative Agents simulation system from a monolithic architecture into a service-oriented design with clear separation of concerns. The system comprises three major components:

1. **Simulation Engine** (`reverie/backend_server/`) – Core agent simulation logic with cognitive modules
2. **Environment Backend** (`environment/frontend_server/`) – Django REST API for environment state management
3. **Frontend Application** (`vue-spa-app/`) – Vue.js SPA for visualization and replay

This chapter documents the architectural transformation, focusing on the structural changes that enable extensibility, testability, and maintainability while preparing for neuro-symbolic planning integration.

---

## 4.2 Architectural Transformation: From Monolith to Services

### 4.2.1 Original Monolithic Structure

The baseline Generative Agents system exhibited tight coupling between simulation logic, environment management, and LLM interactions:

**Monolithic Structure:**
```
reverie/backend_server/
  ├── reverie.py              # Main simulation loop
  ├── utils.py                # Global config with hardcoded API keys
  ├── persona/
  │   ├── persona.py
  │   └── cognitive_modules/
  │       ├── plan.py         # Direct OpenAI calls
  │       ├── converse.py     # Direct OpenAI calls
  │       ├── perceive.py     # Direct file I/O
  │       └── reflect.py      # Direct OpenAI calls
  └── prompt_template/        # Versioned prompts
```

**Critical Problems:**
- **Hard-coded dependencies**: OpenAI API calls embedded directly in cognitive modules
- **No abstraction**: Impossible to swap LLM providers or test without live API access
- **Mixed concerns**: Business logic intertwined with data access (filesystem I/O, API calls)
- **No extensibility**: Adding new planning modules required modifying core cognitive code

### 4.2.2 Service-Oriented Architecture

The new architecture introduces **layered abstractions** with dependency injection:

**New Structure:**
```
Project Root
├── repositories/                    # Data access layer
│   ├── llm_repository.py           # Abstract LLM interface
│   ├── environment_repository.py   # Abstract env interface
│   └── implementations/
│       ├── openai_repo.py          # OpenAI implementation
│       ├── mock_llm_repo.py        # Mock for testing
│       └── file_env_repo.py        # Filesystem implementation
│
├── services/                        # Business logic layer
│   ├── planning_service.py         # Abstract planning interface
│   ├── dialogue_service.py         # Abstract dialogue interface
│   ├── perception_service.py       # Abstract perception interface
│   ├── reflection_service.py       # Abstract reflection interface
│   ├── environment_service.py      # Abstract environment interface
│   ├── chat_prompt_service.py      # Prompt template management
│   ├── config.py                   # Dependency injection container
│   └── implementations/
│       ├── planning_service_shim.py
│       ├── dialogue_service_shim.py
│       └── environment_service_fs.py
│
└── reverie/backend_server/          # Simulation orchestration
    ├── reverie.py                   # Uses injected services
    └── persona/
```

**Architectural Principles:**
1. **Repository Pattern**: Abstract data access (LLM, environment storage) behind interfaces
2. **Service Layer**: Encapsulate business logic (planning, dialogue, perception) in swappable services
3. **Dependency Injection**: Services receive dependencies via constructor, configured in `services/config.py`
4. **Interface Segregation**: Each cognitive module depends only on the service interface it needs

---

## 4.3 Core Architectural Layers

### 4.3.1 Repository Layer: Data Access Abstraction

The repository layer isolates external dependencies (LLM APIs, file systems) behind abstract interfaces.

**LLM Repository Interface:**
```python
class LLMRepository(ABC):
    @abstractmethod
    def chat(self, messages: List[Dict], model: str, **kwargs) -> str:
        """Generate text completion from chat messages"""
        
    @abstractmethod
    def structured(self, prompt: str, schema: Dict, **kwargs) -> Dict:
        """Generate structured JSON response matching schema"""
```

**Implementations:**
- `OpenAIRepo` – Production implementation using OpenAI API
- `MockLLMRepository` – Deterministic responses for testing without API costs

**Environment Repository Interface:**
```python
class EnvironmentRepository(ABC):
    @abstractmethod
    def load_world_state(self, sim_id: str) -> Dict:
        """Load spatial environment and object locations"""
    
    @abstractmethod
    def save_agent_state(self, sim_id: str, agent_id: str, state: Dict):
        """Persist agent memory and movement history"""
```

**Key Benefit:** Switching from OpenAI to a local LLM or from filesystem to database storage requires implementing a single interface, not rewriting cognitive modules.

### 4.3.2 Service Layer: Business Logic Encapsulation

The service layer defines abstract interfaces for each cognitive capability, enabling multiple implementations (baseline vs. neuro-symbolic).

**Core Service Abstractions:**

1. **PlanningService** – High-level daily planning and hour-level task decomposition
2. **DialogueService** – Conversation generation between agents
3. **PerceptionService** – Environment observation and memory retrieval
4. **ReflectionService** – Memory summarization and insight extraction
5. **EnvironmentService** – Spatial navigation, object interaction, movement tracking

**Service Interface Example (Planning):**
```python
class PlanningService(ABC):
    @abstractmethod
    def plan(self, persona, maze, personas, new_day, retrieved) -> Tuple[int, int]:
        """Compute target action/address for persona"""
```

**Implementation Strategy:**
- **Shim Services**: Wrap existing cognitive modules (e.g., `PlanningServiceShim` delegates to `persona/cognitive_modules/plan.py`)
- **Symbolic Services**: New implementations using PDDL planning (future work)

**Service Composition Pattern:**
Services receive dependencies via constructor, enabling composability:

```python
class PlanningServiceShim(PlanningService):
    def __init__(self, llm_repo: LLMRepository, env_service: EnvironmentService):
        self.llm_repo = llm_repo
        self.env_service = env_service
```

### 4.3.3 Dependency Injection via Configuration

All services are instantiated and wired in `services/config.py`:

```python
def build_services() -> Dict[str, Any]:
    llm_provider = os.getenv("LLM_PROVIDER", "openai").lower()
    
    # LLM repository selection
    if llm_provider == "mock":
        llm_repo = MockLLMRepository()
    else:
        llm_repo = OpenAIRepo(api_key=os.getenv("OPENAI_API_KEY"))
    
    # Environment service setup
    storage_root = os.getenv("NSPLLM_STORAGE_ROOT", "environment/frontend_server/storage")
    env_service = FileSystemEnvironmentService(FileEnvRepo(), storage_root, ...)
    
    # Service composition
    return {
        "planning_service": PlanningServiceShim(llm_repo, env_service),
        "dialogue_service": DialogueServiceShim(llm_repo, env_service),
        "perception_service": PerceptionServiceShim(llm_repo, env_service),
        "reflection_service": ReflectionServiceShim(llm_repo, env_service),
        "environment_service": env_service,
        "llm_repository": llm_repo
    }
```

**Configuration via Environment Variables:**
```bash
# Production: Use OpenAI
LLM_PROVIDER=openai
OPENAI_API_KEY=sk-...

# Testing: Use deterministic mocks
LLM_PROVIDER=mock

# Custom paths
NSPLLM_STORAGE_ROOT=/custom/storage
NSPLLM_TEMP_ROOT=/custom/temp
```

**Simulation Initialization:**
```python
class ReverieServer:
    def __init__(self, fork_sim_code, sim_code, services=None):
        if services is None:
            services = build_services()
        self.planning_service = services["planning_service"]
        self.environment_service = services["environment_service"]
        # ... use services throughout simulation loop
```

---

## 4.4 Environment Backend: RESTful API

### 4.4.1 Transformation from Template-Based to API-Driven

The original Django server (`environment/frontend_server/`) rendered HTML templates with embedded JavaScript. The new architecture exposes a **RESTful API** to decouple backend from frontend.

**New API Structure:**
```
environment/frontend_server/
  ├── manage.py
  ├── api/
  │   ├── views.py          # REST API endpoints
  │   ├── urls.py           # API routing
  │   └── middleware.py     # CORS for SPA
  ├── storage/              # Simulation state
  ├── temp_storage/         # Runtime state
  └── compressed_storage/   # Archived simulations
```

**Core API Endpoints:**

- `GET /api/health` – Health check for environment and simulation servers
- `GET /api/simulations` – List all available simulations
- `GET /api/simulations/{sim_id}/step/{step_num}` – Fetch specific simulation step data
- `POST /api/simulations/command` – Send commands to simulation server (run, pause, reset)

**CORS Configuration:**
Middleware allows cross-origin requests from Vue.js SPA (localhost:5173) during development.

### 4.4.2 Benefits of API Separation

1. **Frontend Independence**: Vue SPA can be developed, built, and deployed separately
2. **Third-Party Integrations**: External tools can query simulation state programmatically
3. **Scalability**: Backend and frontend can scale independently
4. **Testing**: API endpoints testable with tools like `curl` or Postman

---

## 4.5 Frontend Application: Vue.js SPA

### 4.5.1 Transition from Server-Rendered Templates

The original UI was embedded in Django templates with mixed server-side rendering and JavaScript. The new frontend is a **Vue 3 Single-Page Application** with TypeScript.

**Vue SPA Structure:**
```
vue-spa-app/
  ├── src/
  │   ├── main.ts               # App entry point
  │   ├── App.vue               # Root component
  │   ├── components/           # Reusable UI components
  │   ├── views/                # Page-level components
  │   │   ├── Home.vue
  │   │   ├── SimulationView.vue
  │   │   └── ReplayView.vue
  │   ├── router/               # Vue Router configuration
  │   ├── stores/               # Pinia state management
  │   │   └── simulationStore.ts
  │   ├── services/             # API client layer
  │   │   └── api.ts
  │   └── types/                # TypeScript definitions
  ├── public/
  │   └── assets/               # Static assets (maps, sprites)
  ├── vite.config.ts            # Build configuration
  └── package.json
```

**Key Architectural Patterns:**

1. **API Service Layer**: Centralized API client (`services/api.ts`) abstracts HTTP calls
2. **State Management**: Pinia store (`stores/simulationStore.ts`) manages global simulation state
3. **Component Composition**: Reusable Vue components for personas, environment map, controls
4. **Type Safety**: TypeScript interfaces for simulation data structures

**API Client Example:**
```typescript
export class SimulationAPI {
  private baseURL = 'http://localhost:8000/api';
  
  async listSimulations(): Promise<Simulation[]> {
    const response = await fetch(`${this.baseURL}/simulations`);
    return response.json();
  }
  
  async getSimulationStep(simId: string, step: number): Promise<StepData> {
    const response = await fetch(`${this.baseURL}/simulations/${simId}/step/${step}`);
    return response.json();
  }
}
```

### 4.5.2 Benefits of SPA Architecture

1. **Modern Tooling**: Hot module replacement, TypeScript, component-based development
2. **Reactive UI**: Automatic updates when simulation state changes (Pinia reactivity)
3. **Reusable Components**: Persona cards, map tiles, and controls shared across views
4. **Production-Ready**: Optimized builds with Vite (code splitting, tree shaking)

---

## 4.6 Testing Infrastructure

### 4.6.1 Test Organization

The migration introduced comprehensive testing at three levels:

**Test Structure:**
```
tests/
  ├── unit/                         # Fast, isolated tests (no I/O)
  │   ├── test_planning_service_shim.py
  │   ├── test_dialogue_service_shim.py
  │   └── test_environment_service.py
  ├── integration/                  # Multi-component tests (with mocks)
  │   ├── test_switch_llm_provider.py
  │   └── test_prompt_suite.py
  ├── contract/                     # Interface compliance tests
  │   └── test_llm_provider_contract.py
  └── conftest.py                   # Shared fixtures
```

### 4.6.2 Test Fixtures and Mocking

**Shared Fixtures (conftest.py):**
- `mock_llm_repo` – Deterministic LLM responses for testing
- `temp_environment` – Isolated filesystem for environment state
- `services` – Pre-configured service container with mocks

**Mock LLM Repository Example:**
```python
class MockLLMRepository(LLMRepository):
    def chat(self, messages: List[Dict], model: str, **kwargs) -> str:
        # Return deterministic response based on message content
        if "plan" in str(messages).lower():
            return "Wake up at 7:00 AM, breakfast at 8:00 AM, work at 9:00 AM"
        return "Default response"
```

### 4.6.3 Test Levels and Coverage

**Unit Tests (Fast, No External Dependencies):**
```bash
uv run pytest tests/unit/  # Runs in seconds
```
- Verify service delegation to cognitive modules
- Test prompt template loading and validation
- Check environment state serialization

**Integration Tests (With Mocks):**
```bash
uv run pytest tests/integration/
```
- Verify LLM provider switching (mock vs. OpenAI)
- Test multi-step simulation scenarios
- Validate API endpoint responses

**Smoke Tests (Optional, Requires API Keys):**
```bash
SMOKE=1 OPENAI_API_KEY=sk-... uv run pytest tests/integration/test_prompt_suite.py
```
- Validate prompts against live OpenAI API
- Check response format and schema compliance
- Measure believability scores for generated content

**Test Coverage Metrics:**
- **Before Migration**: 0% (no automated tests)
- **After Migration**: 75%+ coverage for services and repositories

---

## 4.7 Migration Benefits and Trade-offs

### 4.7.1 Architectural Improvements

| Aspect | Before | After |
|--------|--------|-------|
| **Coupling** | Tight (direct calls) | Loose (interface-based) |
| **Testability** | None (requires live API) | High (mock repositories) |
| **Extensibility** | Hard (rewrite modules) | Easy (implement interface) |
| **Configuration** | Scattered (hardcoded) | Centralized (env vars) |
| **Frontend** | Server-rendered Django | Modern Vue SPA |
| **API** | None | RESTful Django API |

### 4.7.2 Developer Workflow Transformation

**Before Migration:**
1. Edit cognitive module code
2. Manually run full simulation with live API
3. Check logs for errors
4. Hope changes work as intended

**After Migration:**
1. Edit service implementation
2. Run fast unit tests (`uv run pytest tests/unit/`)
3. Verify interface compliance
4. Optional: Smoke test against live API
5. Deploy with confidence

### 4.7.3 Production Flexibility

**LLM Provider Swapping:**
```bash
# Use OpenAI (production)
LLM_PROVIDER=openai OPENAI_API_KEY=sk-... python reverie.py

# Use mock for debugging
LLM_PROVIDER=mock python reverie.py

# Future: Use local LLaMA model
LLM_PROVIDER=local LOCAL_MODEL_PATH=/models/llama python reverie.py
```

**Environment Storage Swapping:**
```bash
# Filesystem (default)
NSPLLM_STORAGE_ROOT=/custom/path python reverie.py

# Future: PostgreSQL database
ENV_BACKEND=postgres POSTGRES_URL=postgresql://... python reverie.py

# Future: AWS S3 cloud storage
ENV_BACKEND=s3 S3_BUCKET=simulations python reverie.py
```

### 4.7.4 Trade-offs and Complexity

**Added Complexity:**
- More files and abstractions (repositories, services, interfaces)
- Steeper learning curve for new contributors
- Dependency injection requires understanding service wiring

**Justified by Benefits:**
- Complexity is **localized** (interfaces in one place, implementations in another)
- **Testability** reduces debugging time significantly
- **Extensibility** enables thesis experiments (baseline vs. symbolic planning) without rewriting core code
- **Maintainability** improves long-term (changes isolated to specific services)

---

## 4.8 Enabling Neuro-Symbolic Planning Integration

### 4.8.1 Planning Service Interface as Extension Point

The `PlanningService` abstraction enables side-by-side comparison of baseline (LLM-only) and neuro-symbolic planning:

**Baseline Implementation (Shim):**
```python
class PlanningServiceShim(PlanningService):
    """Wraps original LLM-based planning from cognitive_modules/plan.py"""
    def plan(self, persona, maze, personas, new_day, retrieved):
        return legacy_plan_function(persona, maze, personas, new_day, retrieved)
```

**Symbolic Planning Implementation (Future):**
```python
class SymbolicPlanningService(PlanningService):
    """PDDL-based planning with LLM for task decomposition"""
    def __init__(self, llm_repo, env_service, pddl_planner):
        self.llm_repo = llm_repo
        self.env_service = env_service
        self.pddl_planner = pddl_planner
    
    def plan(self, persona, maze, personas, new_day, retrieved):
        # 1. Use LLM to decompose daily goal into tasks
        tasks = self.llm_repo.structured(daily_goal, task_schema)
        # 2. Use PDDL planner to generate action sequences for each task
        actions = self.pddl_planner.plan(tasks, world_state)
        # 3. Return next action coordinates
        return actions[0]
```

**Switching Implementations:**
```python
# services/config.py
plan_module = os.getenv("PLAN_MODULE", "shim").lower()
if plan_module == "symbolic":
    planning_service = SymbolicPlanningService(llm_repo, env_service, pddl_planner)
else:
    planning_service = PlanningServiceShim(llm_repo, env_service)
```

**Experimental Control:**
```bash
# Run baseline simulation
PLAN_MODULE=shim python reverie.py

# Run neuro-symbolic simulation
PLAN_MODULE=symbolic python reverie.py
```

### 4.8.2 Architecture Supports Controlled Experiments

The service-oriented design enables rigorous comparison:

1. **Same Environment**: Both implementations use `EnvironmentService` (same world state)
2. **Same LLM**: Both use `LLMRepository` (same model, prompts for high-level tasks)
3. **Isolated Difference**: Only planning logic differs (LLM-only vs. LLM + PDDL)

**Evaluation Setup:**
- Run identical scenarios with both `PLAN_MODULE=shim` and `PLAN_MODULE=symbolic`
- Collect metrics: task completion rate, action coherence, believability scores
- Statistical comparison ensures differences attributable to planning approach

---

## 4.9 Summary and Next Steps

### 4.9.1 Architectural Achievements

The migration established a maintainable, testable, and extensible platform:

✅ **Repository Pattern**: LLM and environment access abstracted behind interfaces  
✅ **Service Layer**: Business logic (planning, dialogue, perception) encapsulated in swappable services  
✅ **Dependency Injection**: Centralized configuration in `services/config.py`  
✅ **RESTful API**: Django backend exposes simulation state for frontend and third-party tools  
✅ **Modern SPA**: Vue.js frontend with TypeScript, Pinia, and component-based architecture  
✅ **Comprehensive Testing**: Unit, integration, and smoke tests with 75%+ coverage  

### 4.9.2 Foundation for Thesis Contributions

This architecture directly enables the thesis research:

1. **Baseline Evaluation**: Existing LLM-based planning serves as experimental control
2. **Symbolic Planning Integration**: `PlanningService` interface allows PDDL implementation
3. **Comparative Analysis**: Same simulation environment ensures valid comparisons
4. **Prompt Engineering**: `ChatPromptTemplateService` manages versioned prompts for task decomposition
5. **Metrics Collection**: API endpoints expose simulation data for believability evaluation

### 4.9.3 Future Implementation Work

**Immediate Next Steps (Thesis Scope):**
1. Implement `SymbolicPlanningService` with PDDL planner integration
2. Design PDDL domain and problem definitions for household environment
3. Develop LLM-to-PDDL translation for high-level tasks
4. Integrate symbolic planning into simulation loop
5. Collect comparative metrics (baseline vs. neuro-symbolic)

**Long-Term Extensions (Beyond Thesis):**
- Microservices architecture (separate LLM, planning, environment services)
- WebSocket support for real-time simulation viewing
- Cloud deployment (Kubernetes, containerization)
- Alternative storage backends (PostgreSQL, S3)

**Page Budget Check:** This chapter contributes approximately 8–10 pages. Remaining budget: ~35–37 pages for Background, Methodology, Results, Discussion, and Conclusion.

---

