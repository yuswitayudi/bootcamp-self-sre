# 🗄️ Day 02: Data Persistence & Failover Resiliency
**Topic:** Deep-Dive into Database Connections, Failover Mechanics, and MSK Monitoring.  
**Focus:** RDS Aurora, DocumentDB, and MSK (Kafka).

## 📖 The Concept: The "Zombie Connection" Problem
Today I investigated how our EKS applications maintain connections to our primary data stores during infrastructure shifts (e.g., AWS maintenance or unplanned failovers). 

The primary risk in a distributed system isn't just the database going down—it's the **Application Pod** failing to find the new "Writer" node because of DNS caching or stale socket connections.

---

## 🔍 Investigation Part 1: RDS Aurora & The Cluster Endpoint
I audited the connection path from our EKS Pods to our Aurora clusters.

### **Findings:**
* **Connection Path:** The application connects directly to the **Cluster Endpoint** (CNAME).
* **Failover Strategy:** We rely on **Multi-AZ** for data redundancy.
* **Risk Identified:** We do **not** currently use **RDS Proxy**.
* **SRE Insight:** Without a proxy, even though AWS updates DNS in ~1-5 seconds, our pods may experience a 30–60 second "downtime" window. This is caused by the JVM or OS caching the "dead" IP address of the old Primary node (The Zombie Connection). 

---

## 🔍 Investigation Part 2: DocumentDB Connection Resiliency
I analyzed the connection string used by our applications to interact with DocumentDB.

### **Current Configuration:**
`?ssl=false&maxPoolSize=50&readPreference=primary&retryWrites=false`

### **Critical Audit & Improvements:**
1. **`readPreference=primary`**: The app only talks to the writer. We are currently not utilizing our Read Replicas for horizontal scaling.
2. **`retryWrites=false`**: This increases error rates. Setting this to `true` would allow the driver to automatically retry a failed write once during a network "hiccup."
3. **Missing `replicaSet`**: The absence of the `replicaSet` parameter suggests the driver is not "Topology Aware." 
    * **The Impact:** If the Primary node fails, the driver might not automatically discover the newly promoted Primary among the "friends" (replicas) in the cluster.

---

## 🔍 Investigation Part 3: MSK (Kafka) & Observability
We audited how we track **Consumer Lag**, which is our most critical metric for asynchronous processing.

### **Findings:**
* **Metric Source:** We are successfully tracking Consumer Lag in **Grafana**.
* **Monitoring Mode:** **Open Monitoring with Prometheus** is currently disabled on the MSK cluster to manage AWS costs. 
* **Strategy:** We likely utilize an internal exporter (e.g., `kafka-exporter` pod) to scrape JMX metrics, providing visibility without the additional AWS "Enhanced Monitoring" fees.

---

## 💰 Architectural Trade-offs (Cost vs. Reliability)
| Feature | Current State | Potential Upgrade | Why? |
| :--- | :--- | :--- | :--- |
| **Failover Speed** | 30s - 60s | < 5s (via RDS Proxy) | Reduces "Connection Refused" errors. |
| **Write Reliability** | Manual Retry | `retryWrites=true` | Handles minor network blips automatically. |
| **MSK Metrics** | Pod-based Scraper | Open Monitoring | Cleaner integration, but higher AWS cost. |

---

## ✅ Accomplishments
- [x] Mapped the DNS flow for Aurora Cluster Endpoints.
- [x] Identified a critical resiliency gap in the DocumentDB connection string.

---