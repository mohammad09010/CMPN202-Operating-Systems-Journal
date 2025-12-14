# Phase 3: Application Selection for Performance Testing (Week 3)

**Objective:** Need to install the software with which you will later `stress` the server in Week 6. Also, it is necessary for you to document the installation of SSH, and what your expectation is in terms of the system CPU vs. RAM ​‍​‌‍​‍‌usage.

## 1. Introduction
Phase​‍​‌‍​‍‌ 3 revolves around choosing and implementing software programs to create certain workloads on the server. The goal is to produce real-life stress scenarios to test how the OS handles resource ​‍​‌‍​‍‌allocation.

## 2. Application Selection Matrix
My​‍​‌‍​‍‌ choice landed on three different applications to target various system ​‍​‌‍​‍‌resources (CPU, Memory, I/O, and Network).

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
Phase​‍​‌‍​‍‌ 3 revolved around getting the environment ready for stress tests, which eventually highlighted networking issues that were previously less noticeable.

**1. The "Air-Gap" Trade-off:**

The main difficulty of this period was the antagonism between the secured **Host-Only **network and a reasonable course of action which was software installation. Since the server was disconnected from `apt` repositories, it was impossible to install `stress-ng` or `iperf3` by using a command line. To make these updates possible, I temporarily redesigned the network by adding a **NAT** adapter. This operational incident exemplifies the so-called **trade-off** in the real-world scenario of the IT industry, where highly secured, isolated networks cause quite a few problems for simple maintenance tasks such as patching.

**2. Synthetic vs. Realistic Workloads:**

During the process of app picking, I was introduced to the concept of distinguishing **Synthetic** from **Realistic** loads. It is `stress-ng` which is a good tool for hardware performance under theoretical situations (100% CPU), however, it is not able to simulate chaotic operations of a server in the real world. That is the reason why I supplemented `gcc` compilation, which by nature is bursty workload that severely stresses CPU, RAM, and Disk at the same time and thus, gives a better insight of resource contention in the OS environment.

**3. The Observer Effect:**

It was on purpose that I selected `iperf3` and `stress-ng` as they both have daemon or quiet modes in which they can be run. Heavy monitoring tools *on* the server that is being tested would lead to resource consumption by a monitoring tool and therefore, the test results would be distorted. Here thus, the decision to offload data collection to the Workstation via SSH is ​‍​‌‍​‍‌confirmed.

---
[< Previous: Week 2](week2.md) | [Return to Home](index.md) | [Next: Week 4 >](week4.md)
