
# Week 1: System Planning and Distribution Selection

## 1. Introduction
The objective of this first phase was to design a secure dual-system architecture and deploy the initial Linux server environment. [cite_start]This phase focuses on establishing a "Headless" server infrastructure—managed entirely via the command line—to replicate professional cloud administration practices and reduce resource overhead.

## 2. System Architecture Diagram
The following diagram illustrates the dual-system topology designed for this coursework. It features a strict
 separation between the **Control Plane** (Workstation) and the **Target Environment** (Server), connected via an isolated Host-Only network.

<img width="4674" height="1445" alt="System Architecture" src="https://github.com/user-attachments/assets/31cfdda7-e91d-4ffe-b310-bfdeda2674c8" />
*Figure 1: High-level system architecture showing the VirtualBox Host-Only network topology.*

## 3. Distribution Selection Justification
For the server environment, I selected **Ubuntu Server 24.04 LTS**. The decision process involved comparing three industry-standard distributions:

| Distribution | Pros | Cons | Decision |
| :--- | :--- | :--- | :--- |
| **Ubuntu Server 24.04 LTS** | 5-year Long Term Support (LTS); Extensive documentation; Standard in cloud environments; widely supported `apt` package manager. | Can be slightly heavier than Debian minimal installs. | **SELECTED** |
| **Debian 12** | Extremely stable and lightweight; 100% free open-source software. | Older package versions in stable repositories; slightly steeper learning curve for configuration. | Rejected |
| **CentOS Stream / Rocky** | RHEL-binary compatible; Enterprise standard. | Shift in release model (Stream) created uncertainty; smaller community documentation for beginners. | Rejected |

**Rationale:** Ubuntu Server was chosen because it provides a balance of enterprise-grade stability and up-to-date software packages. [cite_start]Furthermore, running the server **headless** (without a GUI) aligns with the sustainability goals of reducing energy consumption and hardware resource usage[cite: 12].

## 4. Workstation Configuration
To manage the server, I have opted for **Option B (Host Machine)**.

* **Justification:** [WRITE 1 SENTENCE HERE. Example: "I chose Option B (Host Machine) because it allows me to allocate more RAM to the server VM and simulates a real-world scenario where an admin connects from their laptop to a remote data center."]

## 5. Network Configuration
The network is the critical security boundary for this project.
* **Hypervisor:** Oracle VirtualBox
* **Network Mode:** Host-Only Adapter and Bridged Adapter
* **Subnet:** `192.168.56.101/24`

This configuration ensures the server is isolated from the public internet (preventing external attacks) while allowing direct SSH access from my workstation. This simulates a "Back-End" network often found in tiered web architecture.

## 6. System Specifications (CLI Evidence)
The following screenshots verify the successful deployment of the headless server and the operating system specifications.

### Kernel and Architecture (`uname -a`)
<img width="935" height="80" alt="image" src="https://github.com/user-attachments/assets/6934ff70-e24f-41ba-b120-59fde3b28604" />

*Evidence of Linux kernel version and x86_64 architecture.*

### Memory Usage (`free -h`)
<img width="943" height="139" alt="image" src="https://github.com/user-attachments/assets/70126444-6fa7-4e0b-89e1-79241f09960f" />

*Evidence of RAM allocation. Note the low usage due to the lack of a Desktop Environment.*

### Disk Usage (`df -h`)
<img width="894" height="184" alt="image" src="https://github.com/user-attachments/assets/c7de20b7-bb5e-4f42-acda-3734ee67fac6" />

*Evidence of filesystem layout and available storage.*

### Network Interface (`ip addr`)
<img width="942" height="559" alt="image" src="https://github.com/user-attachments/assets/64b3d228-cd50-48b3-8b5e-0155ab59c8f6" />

*Shows the IP address assigned by the VirtualBox DHCP server.*

### Release Information (`lsb_release -a`)
<img width="508" height="140" alt="image" src="https://github.com/user-attachments/assets/19ea8146-e193-416d-b384-1ed4314e8bd5" />

*Confirmation of the Ubuntu 24.04 LTS distribution.*

## 7. Learning Reflection
During this week, I learned the importance of defining network boundaries before deployment. Setting up the Host-Only network initially failed because the DHCP server was disabled in VirtualBox; troubleshooting this reinforced my understanding of how virtual switches assign IP addresses. I also realized how significantly the removal of a GUI affects resource usage, as the server idles at a fraction of the RAM required for a desktop installation.

---
[Return to Home](index.md) | [Next: Week 2 >](week2.md)
