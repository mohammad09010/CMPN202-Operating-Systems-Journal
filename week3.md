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
sudo apt update && sudo apt upgrade -y
````

### Step 2: Tool InstallationBash# Install stress testing suite and compiler tools
```bash
sudo apt install -y stress-ng iperf3 build-essential git
````

Evidence of Installation
Verification that `stress-ng`, `iperf3`, and `gcc` are successfully installed on the target server via SSH.

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

---
[< Previous: Week 2](week2.md) | [Return to Home](index.md) | [Next: Week 4 >](week4.md)
