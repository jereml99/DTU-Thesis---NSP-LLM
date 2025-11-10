# Chapter 4: Implementation

**Remaining page budget: ~45 pages (target 50–60, hard cap 70)**

## 4.1 System Architecture Overview

The implementation transforms the Generative Agents simulation system from a monolithic architecture into a service-oriented design with clear separation of concerns. The system comprises three major components:

1. **Simulation Engine** – Core agent simulation logic with cognitive modules
2. **Environment Backend** – Django REST API for environment state management
3. **Frontend Application** – Vue.js SPA for visualization and replay

This chapter documents the architectural transformation, focusing on the structural changes that enable extensibility, testability, and maintainability while preparing for neuro-symbolic planning integration.

---

## 4.2 Architectural Transformation: From Monolith to Services

### 4.2.1 Original Monolithic Structure

The baseline Generative Agents system exhibited tight coupling between simulation logic, environment management, and LLM interactions. OpenAI API calls were embedded directly in cognitive modules, filesystem access was scattered throughout the codebase, and configuration was hardcoded with no abstraction layer.

**[Figure 4.1: Monolithic Architecture Diagram – Reserved Space (content/implementation_assets/Code Structure - before.svg)]**

**Critical Problems:**
- Hard-coded dependencies: impossible to swap LLM providers or test without live API access
- Mixed concerns: business logic intertwined with data access
- No extensibility: adding new planning modules required modifying core cognitive code
- Zero test coverage

### 4.2.2 Service-Oriented Architecture

The new architecture introduces **layered abstractions** through dependency injection, separating the system into three layers:

1. **Repository Layer** – Abstract data access (LLM APIs, environment storage) behind interfaces
2. **Service Layer** – Encapsulate business logic (planning, dialogue, perception) in swappable services  
3. **Orchestration Layer** – Simulation loop consumes services through interfaces

**[Figure 4.2: Service-Oriented Architecture Diagram – Reserved Space (content/implementation_assets/Code Structure - after.svg)]**

**Architectural Principles:**
- Repository Pattern abstracts external dependencies
- Service interfaces enable multiple implementations (baseline vs. neuro-symbolic)
- Dependency injection via centralized configuration
- Environment variables control provider selection and storage paths

---

## 4.3 Core Architectural Layers

### 4.3.1 Repository Layer: Data Access Abstraction

The repository layer isolates external dependencies (LLM APIs, file systems) behind abstract interfaces. The `LLMRepository` interface provides methods for text generation (`chat`) and structured JSON responses (`structured`), with implementations for OpenAI (production) and mock responses (testing). The `EnvironmentRepository` interface abstracts world state loading and agent state persistence.

**Key Benefit:** Switching from OpenAI to a local LLM or from filesystem to database storage requires implementing a single interface, not rewriting cognitive modules.

### 4.3.2 Service Layer: Business Logic Encapsulation

Five core service abstractions encapsulate cognitive capabilities:

1. **PlanningService** – Daily planning and task decomposition
2. **DialogueService** – Conversation generation
3. **PerceptionService** – Environment observation and memory retrieval
4. **ReflectionService** – Memory summarization
5. **EnvironmentService** – Spatial navigation and object interaction

**Implementation Strategy:**
- **Shim Services** wrap existing cognitive modules for backward compatibility
- **Symbolic Services** (future work) will implement PDDL-based planning

Services receive dependencies via constructor, enabling composition and testability.

### 4.3.3 Dependency Injection via Configuration

All services are instantiated in a centralized configuration module that reads environment variables to select implementations. For example, `LLM_PROVIDER=mock` switches to deterministic test responses, while `LLM_PROVIDER=openai` uses the production API. Custom storage paths are configurable via `NSPLLM_STORAGE_ROOT` and similar variables.

The simulation server receives a complete service container at initialization, avoiding direct instantiation of dependencies throughout the codebase.

---

## 4.4 Environment Backend: RESTful API

### 4.4.1 Transformation from Template-Based to API-Driven

The original Django server rendered HTML templates with embedded JavaScript. The new architecture exposes a RESTful API to decouple backend from frontend, with endpoints for health checks, simulation listing, step-by-step data retrieval, and command execution.

CORS middleware allows cross-origin requests from the Vue.js SPA during development.

### 4.4.2 Benefits of API Separation

- Frontend independence: separate development, build, and deployment
- Third-party integrations: external tools can query simulation state programmatically
- Scalability: backend and frontend scale independently
- Testability: API endpoints testable with standard HTTP tools

---

## 4.5 Frontend Application: Vue.js SPA

### 4.5.1 Transition from Server-Rendered Templates

The original UI mixed server-side rendering with JavaScript. The new frontend is a Vue 3 Single-Page Application with TypeScript, featuring:

- **API Service Layer**: Centralized HTTP client abstracts backend communication
- **State Management**: Pinia store manages global simulation state with reactive updates
- **Component Composition**: Reusable Vue components for personas, environment map, and controls
- **Type Safety**: TypeScript interfaces enforce simulation data structures

### 4.5.2 Benefits of SPA Architecture

Modern tooling (hot module replacement, component-based development), reactive UI updates, and production-ready builds with code splitting and tree shaking.

---

## 4.6 Testing Infrastructure

### 4.6.1 Test Organization and Coverage

The migration introduced three test levels:

- **Unit Tests**: Fast, isolated tests with mocked dependencies (service delegation, prompt loading, state serialization)
- **Integration Tests**: Multi-component tests verifying LLM provider switching and multi-step scenarios
- **Smoke Tests**: Optional validation against live OpenAI API for prompt format and believability checks

**Key Testing Pattern:** The `MockLLMRepository` returns deterministic responses based on message content, enabling fast testing without API costs or external dependencies.

**Coverage Metrics:**
- Before: 0% (no automated tests)
- After: 75%+ for services and repositories

### 4.6.2 Developer Workflow Transformation

**Before:** Edit code → manually run full simulation with live API → check logs → hope it works  
**After:** Edit code → run unit tests in seconds → verify interface compliance → optional smoke test → deploy with confidence

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

### 4.7.2 Production Flexibility

Environment variables control all major behaviors:

- **LLM Provider Swapping**: `LLM_PROVIDER=openai|mock|local` switches between production API, test mocks, or future local models
- **Storage Backend**: `NSPLLM_STORAGE_ROOT` configures filesystem paths; future implementations can support PostgreSQL or S3 via `ENV_BACKEND` variable

### 4.7.3 Trade-offs and Complexity

**Added Complexity:**
- More files and abstractions (repositories, services, interfaces)
- Steeper learning curve for new contributors
- Dependency injection requires understanding service wiring

**Justified by Benefits:**
- Complexity is localized (interfaces separate from implementations)
- Testability dramatically reduces debugging time
- Extensibility enables thesis experiments without rewriting core code
- Maintainability improves through isolated changes

---

## 4.8 Enabling Neuro-Symbolic Planning Integration

### 4.8.1 Planning Service Interface as Extension Point

The `PlanningService` abstraction enables side-by-side comparison of baseline (LLM-only) and neuro-symbolic planning. The baseline `PlanningServiceShim` wraps existing cognitive modules, while future `SymbolicPlanningService` will integrate PDDL planning.

**Critical Implementation Detail:** The symbolic service will use the LLM repository for task decomposition and the PDDL planner for action sequence generation, with environment variables controlling which implementation runs (`PLAN_MODULE=shim|symbolic`).

### 4.8.2 Architecture Supports Controlled Experiments

The service-oriented design enables rigorous comparison by ensuring both implementations use the same `EnvironmentService` (world state), same `LLMRepository` (model and prompts for high-level tasks), with only the planning logic differing. This isolates the independent variable for statistical analysis.

---

## 4.9 Summary and Next Steps

### 4.9.1 Architectural Achievements

✅ Repository Pattern abstracts LLM and environment access  
✅ Service Layer encapsulates swappable business logic  
✅ Dependency Injection centralizes configuration  
✅ RESTful API decouples backend from frontend  
✅ Modern Vue SPA with TypeScript  
✅ 75%+ test coverage with fast unit tests  

### 4.9.2 Foundation for Thesis Contributions

This architecture directly enables:

1. Baseline evaluation (existing LLM-based planning as control)
2. Symbolic planning integration via `PlanningService` interface
3. Comparative analysis in identical simulation environments
4. Prompt engineering through versioned template management
5. Metrics collection via API endpoints

### 4.9.3 Future Implementation Work

**Thesis Scope:**
1. Implement `SymbolicPlanningService` with PDDL planner
2. Design PDDL domain/problem definitions for household environment
3. Develop LLM-to-PDDL translation
4. Collect comparative metrics (baseline vs. neuro-symbolic)
