# Observability Model (Cross-Cutting Domain)

## Purpose

This document defines the Observability Domain of the EKS Platform Reference Architecture.

It specifies how system-wide telemetry is structured, collected, and interpreted across all architectural domains.

It is a cross-cutting concern and does not belong to any single domain such as infrastructure, runtime, workloads, or delivery.

It defines the **system-wide visibility model only**.

---

## 1. Observability Domain Scope

The Observability Domain is responsible for providing system-wide insight into:

- system health
- service performance
- infrastructure behavior
- application behavior
- delivery pipeline outcomes

It spans all architectural domains without owning any of them.

---

## 2. Observability Pillars

The system is structured around three core observability pillars:

### 2.1 Metrics

Metrics represent structured numerical telemetry describing system behavior over time.

- infrastructure metrics (node health, cluster state)
- application metrics (request rates, latency, error rates)
- system metrics (resource utilization)

Metrics are designed for aggregation and alerting.

---

### 2.2 Logs

Logs represent discrete event-level system records.

- application logs
- system logs
- infrastructure logs

Logs MUST be structured (not free-form text where possible) to support queryability and correlation.

---

### 2.3 Traces

Traces represent distributed request flows across system components.

- request propagation across services
- latency decomposition
- dependency mapping between services

Tracing is optional at workload level but recommended for distributed systems.

---

## 3. Observability Integration Model

Each architectural domain exposes observability hooks:

### 3.1 Build Domain (Infrastructure)

- provisioning logs
- state transition visibility
- infrastructure change audit trails

---

### 3.2 Runtime Domain (Platform)

- cluster-level metrics
- node and pod health signals
- control plane visibility (EKS)

---

### 3.3 Execution Domain (Workloads)

- application-level metrics
- structured logging output
- health probes (readiness/liveness)

---

### 3.4 Delivery Domain (GitOps)

- CI pipeline logs
- deployment status events
- reconciliation state from GitOps controller

---

## 4. Observability System Model

The observability system is designed as a **collection of consumers and exporters**, not as a centralized logic layer.

### Key principle:

- Systems emit telemetry
- Observability systems collect and interpret telemetry

No domain owns the full observability stack.

---

## 5. Alerting Model (Conceptual)

Alerting is derived from metrics and system conditions.

Alerts SHOULD:

- be based on measurable system conditions
- avoid subjective thresholds where possible
- map to service-level indicators (SLIs)

Alerting logic is not embedded in application code.

---

## 6. Correlation Model

All observability signals SHOULD support correlation via:

- trace IDs
- request identifiers
- consistent labeling/tagging strategy

This enables cross-domain visibility without coupling systems.

---

## 7. Non-Goals

The Observability Domain explicitly does NOT define:

- infrastructure provisioning (`infrastructure.md`)
- runtime architecture (`platform.md`)
- workload definitions (`workloads.md`)
- CI/CD pipelines (`gitops.md`)

It only defines the **visibility model across those systems**.

---

## 8. Relationship to Architecture Model

This document implements a cross-cutting domain defined in `architecture.md`.

It must conform to:

- non-ownership of other domains
- strict separation from execution and infrastructure concerns
- consistent telemetry integration across all system layers

---

## Summary

The Observability Domain defines a unified system-wide visibility model across metrics, logs, and traces.

It ensures consistent observability integration across infrastructure, runtime, workloads, and delivery systems without introducing coupling or ownership conflicts.
