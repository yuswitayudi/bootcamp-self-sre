# 🚀 Day 01: Auditing the EKS Networking Topology
**Status:** Accomplished ✅

### 🔍 Discovery: The Hybrid Routing Architecture
Today, I audited the AWS Application Load Balancer (ALB) connected to our EKS environment and discovered a **Mixed Target Topology**:

1. **IP Target Mode:** Used for high-performance routing. The ALB bypasses the EC2 Node and communicates directly with the Pod IPs. This confirms we are leveraging the **AWS VPC CNI** for native networking.
2. **Instance Target Mode:** Identified in some Target Groups. This indicates that traffic for certain services still follows the `ALB -> EC2 Node (NodePort) -> Kube-proxy -> Pod` path.

### 💡 Why this matters for SRE
Understanding this mixed mode is critical for **Incident Management**:
- **Latency:** Services on `IP` mode will have lower latency than those on `Instance` mode due to one fewer network hop.
- **Troubleshooting:** For `IP` mode, I must investigate **Pod ENIs**. For `Instance` mode, I must verify that **NodePorts** (30000-32767) are open in the EC2 Security Groups.

### 🛡 Discovery: The Service Mesh Layer (Linkerd)
While the ALB handles external traffic, **Linkerd** handles the "East-West" (internal) traffic. 

**My Environment Check:**
- [x] **Injection Status:** Verified pods are running in `2/2` ready state.
- [x] **Sidecar Identified:** Confirmed `linkerd-proxy` is running alongside the main application container.
- [x] **Injection Method:** Found the `linkerd.io/inject: enabled` annotation at the [Namespace/Deployment] level.

**Mastery Insight:** Because Linkerd is present, our internal traffic is automatically encrypted via **mTLS**. This means even if an attacker got into the VPC, they couldn't "sniff" the traffic between our services because it's encrypted by the Linkerd sidecars.

### ✅ Tasks Completed
- [x] Identified ALB Target Groups via AWS Console.
- [x] Confirmed the existence of both `ip` and `instance` target types.
- [x] Mapped the physical traffic path for both routing modes.
- [x] Confirmed mTLS and observability coverage by identifying active linkerd-proxy sidecars.

### 🛠 Tools Used
- AWS Management Console (EC2 -> Target Groups)
- kubectl (Audit of Ingress resources)
