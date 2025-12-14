# Phase 3: Application Selection for Performance Testing (Week 3)

**Objective:** Must install the software you will use to `stress` the server later in Week 6. You also need to document how you installed SSH, and what you expect it to do to the system CPU vs. RAM usage.

## 1. Introduction
Phase 3 focuses on selecting and deploying applications that will generate specific workloads on the server. The objective is to simulate realistic stress scenarios to evaluate the operating system's resource management capabilities.

## 2. Application Selection Matrix
I have selected three distinct applications to target different system resources (CPU, Memory, I/O, and Network).

| Application | Workload Type | Justification |
| :--- | :--- | :--- |
| **`stress-ng`** | **CPU & RAM Intensive** | An industry-standard stress tool that can generate precise synthetic loads. It allows me to pin CPU usage to 100% or fill RAM to specific limits to test OOM (Out of Memory) handling. |
| **`iperf3`** | **Network Intensive** | A tool specifically designed to measure maximum TCP/UDP bandwidth. This will test the throughput limits of the virtualized Host-Only network adapter. |
| **`gcc` (Compilation)** | **Mixed (CPU + I/O)** | Compiling a large source code project, like the Linux kernel or a C program is a realistic **Server** task that stresses both the processor compiling and the disk for reading/writing thousands of small files. |

## 3. Installation Documentation
All applications were installed via SSH from the workstation, adhering to the headless administration constraint.

### Step 1: System Update
```bash
sudo apt update
```
<img width="812" height="408" alt="Screenshot 2025-12-14 084357" src="https://github.com/user-attachments/assets/1c33eccf-d4c7-4882-92a1-c5ca83f45b3d" />

```bash
sudo apt upgrade -y
````
<img width="1889" height="729" alt="Screenshot 2025-12-14 084436" src="https://github.com/user-attachments/assets/ebb547de-81e2-4126-9cdc-a1c8e99efe35" />

### Step 2: Tool InstallationBash# Install stress testing suite and compiler tools
```bash
sudo apt install -y stress-ng iperf3 build-essential git
```
<img width="1109" height="673" alt="Screenshot 2025-12-14 084530" src="https://github.com/user-attachments/assets/f6e0c757-5499-4556-af86-6f7a9816b3f7" />


## Evidence of Installation
Verification that `stress-ng`, `iperf3`, and `gcc` are successfully installed on the target server via SSH.
```bash
stress-ng --version
````
<img width="746" height="39" alt="Screenshot 2025-12-14 084613" src="https://github.com/user-attachments/assets/f91c23b0-4c3a-460f-b40c-6940932ed98d" />

```bash
iperf3 --version
```
<img width="1890" height="84" alt="Screenshot 2025-12-14 084637" src="https://github.com/user-attachments/assets/ba75fe2f-0646-4da6-86d3-1177c995a87e" />

```bash
gcc --version
```
<img width="701" height="122" alt="Screenshot 2025-12-14 084743" src="https://github.com/user-attachments/assets/1c465652-2fa7-4769-8eb0-c3d47ea0c8f2" />


## 4. Expected Resource Profiles
Based on the selected applications, I anticipate the following resource usage behaviors during the testing phase:

| Application | Expected CPU Profile | Expected RAM Profile | Expected I/O Profile |
| :--- | :--- | :--- | :--- |
| **stress-ng (CPU mode)** | **100% Usage** across all cores. High user-space time. | Minimal usage. | Minimal. |
| **stress-ng (VM mode)** | Moderate usage (kernel managing pages). | **High Usage** (targeting 80-90% of available RAM). | High Swap usage if physical RAM is exhausted. |
| **iperf3** | Low to Moderate (interrupt handling). | Low. | Minimal. |
| **gcc compilation** | **High/Bursty**. Variable usage as different files are compiled. | Moderate (fluctuating). | **High**. Continuous small reads/writes to disk. |

## 5. Monitoring Strategy
To measure the impact of these applications, I will use the following **Remote Monitoring** approach:
- **Command:** I will use my custom `monitor-server.sh` script to be developed in Week 5, which utilizes `top`, `vmstat`, and `free` commands via SSH.
- **Sampling Rate:** Metrics will be captured every **1 second** during the active test window approx. 60 seconds per test.
- **Data Capture:**
  - ***CPU:*** `%usr` (User) and `%sys` (System) from `vmstat`.
  - ***Memory:*** `available` memory from `free -m`.
  - ***Disk:*** `wa` (Wait) time from top to measure I/O blocking.

## 6. Learning Reflection
Phase 3 focused on preparing the environment for stress testing, which brought practical networking challenges to the forefront.
**1. The "Air-Gap" Trade-off:**
The most significant challenge this week was the conflict between the secure "Host-Only" network requirement and the practical need to install software. The server could not reach the `apt` repositories to install `stress-ng` or `iperf3`. I had to temporarily re-architect the network adding a NAT adapter to facilitate these updates. This demonstrated a real-world operational trade-off: highly secure, isolated networks make simple maintenance tasks like patching significantly more complex.

**2. Synthetic vs. Realistic Workloads:**
In selecting the applications, I learned to distinguish between "Synthetic" and "Realistic" loads. While `stress-ng` is excellent for pushing hardware to its theoretical limit (100% CPU), it does not accurately model the chaotic behavior of a real server. This is why I included `gcc` compilation—it creates a "bursty" workload that stresses the CPU, RAM, and Disk simultaneously, providing a more holistic view of how the OS handles resource contention.

**3. The Observer Effect:**
I deliberately chose `iperf3` and `stress-ng` because they can be run in "daemon" or "quiet" modes. I realized that if I used heavy monitoring tools *on* the server itself, the monitoring tool would consume resources, skewing the test results. This validated the decision to offload data collection to the Workstation via SSH.

---
[< Previous: Week 2](week2.md) | [Return to Home](index.md) | [Next: Week 4 >](week4.md)
