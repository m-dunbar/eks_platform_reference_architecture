---
layout: single
title: Platform Engineering Principles (System Invariants)

---

## Purpose

This document defines the invariant constraints governing the EKS Platform Reference Architecture.

It applies universally across all architectural domains:

- infrastructure.md (Build Domain)
- platform.md (Runtime Domain)
- workloads.md (Execution Domain)
- gitops.md (Delivery Domain)
- observability.md (Cross-Cutting Domain)

It defines **what the system must always remain true**, regardless of implementation changes.

It is the highest-order constraint layer in this repository.

---

## 1. System Design Invariants

The following invariants MUST always hold:

### 1.1 Explicitness Over Implicitness

All system behavior MUST be explicitly defined.

- No hidden dependencies
- No implicit cross-layer coupling
- No “assumed knowledge” between domains

If a relationship exists, it MUST be declared in a domain contract.

---

### 1.2 Domain Exclusivity

Each concept MUST belong to exactly one architectural domain.

- Infrastructure concepts belong ONLY to `infrastructure.md`
- Runtime concepts belong ONLY to `platform.md`
- Workload definitions belong ONLY to `workloads.md`
- Delivery mechanisms belong ONLY to `gitops.md`

Cross-cutting concerns MUST NOT redefine domain ownership.

---

### 1.3 Strict Boundary Enforcement

Domains MUST NOT:

- redefine responsibilities of other domains
- reference implementation details outside their scope
- assume internal structure of other domains

All interactions MUST occur via defined contracts.

---

## 2. State Management Principles

### 2.1 State Isolation

Each infrastructure layer MUST maintain isolated state boundaries.

- No shared Terraform state across unrelated domains
- State must be independently managed per domain layer
- State migration MUST be explicit and controlled

---

### 2.2 State as a System Artifact

State is treated as a **first-class system artifact**, not an implementation detail.

- State must be encrypted
- State must be versioned and auditable
- State transitions must be deterministic

---

### 2.3 Remote State Constraint

Remote state usage is restricted:

- Preferred: explicit provider/data-source resolution
- Allowed: remote state only when no alternative exists
- Forbidden: implicit cross-layer state coupling

---

## 3. Dependency Management Principles

### 3.1 Explicit Dependency Graph

All system dependencies MUST be explicitly defined.

- No circular dependencies between domains
- No hidden runtime dependency resolution
- All dependencies must be traceable

---

### 3.2 Deterministic Ordering

Infrastructure and system layers MUST be applied in deterministic sequence:

1. Identity & access foundations
2. Cryptographic foundations
3. State management layer
4. Network infrastructure
5. Compute infrastructure
6. Runtime platform
7. Workload deployment
8. Observability integration

---

## 4. Identity and Tagging Principles

### 4.1 Mandatory Tagging

All infrastructure resources MUST include standardized tags:

- environment
- service
- owner
- cost_center
- managed_by

---

### 4.2 Tag-Driven Discovery

Tags are not metadata—they are system identifiers.

- Used for resource discovery
- Used for cost allocation
- Used for operational classification

---

### 4.3 No Uncontrolled Tagging Variance

Additional tags MAY be added, but:

- core tag schema MUST remain consistent
- tag semantics MUST not be redefined per domain

---

## 5. CI/CD and Delivery Principles

### 5.1 Separation of Concerns

The system enforces strict separation between:

- CI (artifact creation and validation)
- CD (promotion and deployment orchestration)
- Runtime reconciliation (Argo CD)

No system MAY combine all three responsibilities.

---

### 5.2 Git as System of Record

Git is the authoritative source of:

- desired system state
- deployment definitions
- workload configuration

Runtime systems are NOT authoritative.

---

## 6. Runtime Principles

### 6.1 Platform as a Stable Contract

The runtime platform MUST be treated as:

> a stable execution substrate, not a configurable system

Workloads MUST NOT depend on internal platform implementation details.

---

### 6.2 Identity via IAM Boundaries

All runtime identity MUST be enforced via:

- IAM Roles for Service Accounts (IRSA)
- Kubernetes service account bindings

Static credentials are forbidden.

---

## 7. Observability Principles

### 7.1 Telemetry First-Class Model

Observability is a system-wide concern but:

- MUST NOT own any domain
- MUST NOT define system behavior
- MUST ONLY observe system behavior

---

### 7.2 Structured Telemetry Requirement

Where possible:

- logs MUST be structured
- metrics MUST be machine-aggregatable
- traces MUST support cross-domain correlation

---

## 8. Evolution Constraints

### 8.1 Backward-Compatible Extension Rule

New system capabilities MAY be added only if:

- they conform to an existing domain
- or are explicitly defined as cross-cutting concerns
- they do NOT introduce new top-level architectural planes without system-wide revision

---

### 8.2 No Silent Architecture Drift

Any change that alters:

- domain boundaries
- dependency ordering
- control hierarchy

MUST be reflected in `architecture.md` before implementation.

---

## 9. Relationship to Architecture Model

This document enforces the invariants defined in `architecture.md`.

If a conflict exists:

- `principles.md` defines constraints
- `architecture.md` defines structure

Constraints override structural descriptions.

---

## Summary

This document defines the invariant rules governing the entire EKS Platform Reference Architecture.

It ensures long-term structural integrity by enforcing explicitness, strict domain boundaries, deterministic dependency ordering, and controlled system evolution.
