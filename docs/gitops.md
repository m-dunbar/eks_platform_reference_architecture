# GitOps Model (Delivery Domain)

## Purpose

This document defines the Delivery Domain of the EKS Platform Reference Architecture.

It specifies how infrastructure definitions, container images, and Kubernetes workloads are validated, built, and deployed through automated pipelines and GitOps reconciliation systems.

It does not define infrastructure provisioning (`infrastructure.md`), runtime architecture (`platform.md`), or workload structure (`workloads.md`).

It defines the **delivery and reconciliation system only**.

---

## 1. Delivery Domain Scope

The Delivery Domain is responsible for:

- Continuous Integration (CI) of application and infrastructure artifacts
- Container image build and validation
- Infrastructure validation (Terraform)
- Deployment orchestration via GitOps
- Environment promotion workflows

---

## 2. Delivery Control Model

The Delivery Domain operates as a **control layer over system state transitions**, not as a runtime execution system.

It is responsible for initiating and governing change, but not enforcing or maintaining system state.

### 2.1 Control Responsibilities

The Delivery Domain controls:

- when artifacts are produced (CI)
- when changes are promoted (CD)
- when desired state is updated in Git
- when reconciliation is triggered

---

### 2.2 Enforcement Responsibility (Explicit Separation)

State enforcement is NOT the responsibility of CI/CD systems.

- CI produces artifacts
- CD publishes desired state changes
- Argo CD enforces actual runtime state alignment

This creates a strict separation between:

- **control plane (delivery system)**
- **execution plane (runtime system)**

---

### 2.3 System Authority Hierarchy

The authoritative order of control is:

1. Git (desired state definition)
2. Argo CD (runtime reconciliation authority)
3. Kubernetes API (execution substrate)
4. AWS infrastructure (underlying compute/network layer)

CI/CD systems sit **above Git as change initiators only**, not as enforcement systems.

---

## 3. CI Model (Build and Validation Layer)

Continuous Integration is responsible for producing validated artifacts.

### 3.1 CI Responsibilities

CI pipelines MUST:

- Build container images from Dockerfiles
- Run unit and integration tests where applicable
- Validate Helm charts (linting and schema validation)
- Validate Terraform plans (without applying changes)
- Produce versioned artifacts for deployment

### 3.2 CI Constraints

CI MUST NOT:

- Modify runtime infrastructure directly
- Apply Kubernetes manifests directly to clusters
- Perform uncontrolled environment mutation

CI is strictly an artifact production system.

---

## 4. CD Model (Deployment and Promotion Layer)

Continuous Delivery is responsible for controlled propagation of validated artifacts into runtime environments.

### 4.1 CD Responsibilities

CD pipelines MAY:

- Promote container images across environments
- Update GitOps manifests (version bumping)
- Trigger Argo CD reconciliation
- Manage environment-specific configuration overlays

---

### 4.2 Environment Promotion Model

Environments are promoted in a controlled sequence:

- development
- staging
- production

Promotion MUST be:

- explicit
- version-controlled
- auditable

---

## 5. GitOps Reconciliation Model (Argo CD)

The system uses GitOps as the authoritative deployment mechanism.

### 5.1 Argo CD Responsibilities

Argo CD is responsible for:

- Continuous reconciliation of Kubernetes state
- Ensuring cluster state matches Git repository definitions
- Detecting and correcting configuration drift

### 5.2 Git as Source of Truth

All runtime desired state is stored in Git:

- Kubernetes manifests
- Helm values
- environment overlays

The cluster is NOT the source of truth.

---

## 6. CI/CD Separation Principle

The system enforces strict separation:

| Function | System |
|---------|--------|
| Build artifacts | CI pipelines |
| Validation | CI pipelines |
| Deployment orchestration | CD pipelines |
| Runtime enforcement | Argo CD |

---

## 7. Artifact Model

The Delivery Domain produces the following artifact types:

- Container images (versioned, immutable)
- Helm chart packages or references
- Terraform plan outputs (validated, not executed directly)
- Kubernetes manifests (Git-managed)

---

## 8. Pipeline Implementation Model

Pipelines MAY be implemented using:

- GitHub Actions (primary CI system)
- External CI systems (pluggable)
- Argo CD (CD reconciliation engine)

Pipeline logic MUST remain declarative and reproducible.

---

## 9. Security Model

The Delivery Domain MUST ensure:

- least privilege execution for CI/CD agents
- no long-lived credentials in pipelines
- secrets management via secure injection mechanisms
- signed and versioned artifacts where applicable

---

## 10. Observability of Delivery System

Delivery pipelines SHOULD expose:

- build logs
- deployment status events
- reconciliation state (via Argo CD)
- audit trails of promotion events

---

## 11. Non-Goals

The Delivery Domain explicitly does NOT define:

- infrastructure provisioning logic (see `infrastructure.md`)
- Kubernetes runtime architecture (see `platform.md`)
- workload definitions (see `workloads.md`)
- observability stack design (see `observability.md`)

---

## 12. Relationship to Architecture Model

This document implements the Delivery Domain defined in `architecture.md`.

It must conform to:

- domain exclusivity rules
- strict separation of CI, CD, and runtime responsibilities
- Git as the authoritative system of record for desired state

---

## Summary

The Delivery Domain defines a fully automated, GitOps-driven system for building, validating, and deploying platform and application artifacts.

It enforces strict separation between CI (artifact creation), CD (promotion orchestration), and runtime reconciliation (Argo CD).
