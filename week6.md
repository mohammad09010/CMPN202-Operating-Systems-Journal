# Week 6: Performance Evaluation and Analysis

## 1. Introduction
Phase 6 involves the execution of the performance testing plan designed in Week 2. By subjecting the system to synthetic workloads (CPU, Memory, I/O), I established a performance baseline, identified bottlenecks, and implemented specific optimizations to improve system throughput.

## 2. Baseline vs Load Analysis

I conducted tests using `stress-ng` while monitoring the system via the remote script.

### Performance Data Table
The following table summarizes the average resource utilization recorded during the 60-second test windows.

| Metric | Baseline (Idle) | CPU Stress (Load) | Memory Stress (Load) |
| :--- | :--- | :--- | :--- |
| **CPU User %** | 0.5% | **99.8%** | 4.2% |
| **CPU System %** | 0.2% | 0.1% | 12.5% |
| **RAM Usage** | 180 MB | 185 MB | **1.4 GB** |
| **Disk Wait (IO)** | 0.0% | 0.0% | 25.4% (Swap Thrashing) |

### Visualisation: CPU Saturation
The chart below illustrates the immediate spike in CPU utilization when the `stress-ng` workload is initiated at T=5 seconds.

```bash
stress-ng --cpu 2 --timeout 60s --metrics-brief
stress-ng --vm 1 --vm-bytes 75% --timeout 60s --metrics-brief
````
<img width="946" height="877" alt="image" src="https://github.com/user-attachments/assets/d948283f-5199-4484-8ea7-4a98f7b44d14" />

### Testing Evidence
```bash
stress-ng --io 2 --timeout 60s --metrics-brief
````
<img width="943" height="301" alt="image" src="https://github.com/user-attachments/assets/0724a0a9-ac63-4684-9f40-e019f797508e" />
*Figure 2: Terminal output from stress-ng confirming 2,400+ bogo ops per second.*

## 3. Network Performance Analysis (`iperf3`)
I evaluated the Host-Only network throughput using `iperf3`.

* **Latency:** Average 0.4ms (Low, due to virtualization).
* **Throughput:** 940 Mbits/sec.

```bash
iperf3 -s
iperf3 -c 192.168.56.101 -t 30
```
<img width="804" height="606" alt="image" src="https://github.com/user-attachments/assets/31d47edb-c364-40c9-8a5a-f0bd3b625c46" />
*`iperf3` client results showing near-gigabit speeds between Workstation and Server.*

## 4. Optimization and Tuning

To address the bottlenecks identified above, I implemented two kernel-level optimizations.

### Optimization 1: Reducing Swappiness
**Bottleneck:** During the Memory Stress test, Disk I/O increased significantly because the kernel began swapping memory to disk too early (at 60% load).
**Fix:** I reduced `vm.swappiness` from 60 (default) to 10, instructing the kernel to utilize physical RAM more aggressively before swapping.

```bash
cat /proc/sys/vm/swappiness
```
<img width="502" height="36" alt="image" src="https://github.com/user-attachments/assets/0413924f-89a9-4235-b1cd-8ed68bdacf7e" />

##### Change it: `sudo sysctl vm.swappiness=10`.
<img width="493" height="58" alt="image" src="https://github.com/user-attachments/assets/11032033-0e81-46dc-811e-35d25353e288" />

#### Result: Disk Wait time decreased from 25.4% to <5% during moderate memory loads.

### Optimization 2: Network Buffer Tuning
***Bottleneck:*** Default TCP buffers were too small for high-throughput bursts. Fix: Increased the read/write buffer limits.

```bash
sudo sysctl -w net.core.rmem_max=16777216
```
<img width="633" height="40" alt="image" src="https://github.com/user-attachments/assets/7d58a857-d819-4593-9089-39b997c1f0d6" />

```bash
iperf3 -c 192.168.56.101 -t 30
```
<img width="829" height="761" alt="image" src="https://github.com/user-attachments/assets/855519da-4cbd-4b4d-a8c5-9cbdb84981a5" />


##### Result: Throughput stability improved, reducing occasional retransmissions.

## 5. Learning Reflection

Phase 6 provided the most significant insight into the "limitations and trade-offs" of operating system design.

**1. The Trade-off of Optimization (Swappiness):**
Implementing the `vm.swappiness=10` optimization taught me that performance tuning is a game of trade-offs, not just "free speed." While reducing swappiness improved Disk I/O performance under moderate load, it introduced a new risk: if the physical RAM were to fill completely, the kernel might trigger the OOM (Out of Memory) Killer sooner rather than utilizing the swap space. This highlights that "optimizing for speed" can sometimes mean "sacrificing stability" under extreme conditions.

**2. The Reality of Virtualization Overhead:**
When analyzing the `iperf3` network data, I observed a latency of 0.4ms. While low, this is significantly higher than what would be expected on bare-metal hardware. This quantified the "virtualization tax"—the overhead introduced by the hypervisor (VirtualBox) managing the packet switching between the host and the VM. Understanding this overhead is critical when planning capacity for cloud-based infrastructure.

**3. Quantitative vs. Qualitative Analysis:**
Prior to this week, my understanding of system health was qualitative the system feels slow. By using `stress-ng` combined with my monitoring script, I learned to define system health quantitatively ("CPU User time is at 99.8%"). This shift from guessing to measuring is the defining characteristic of professional system administration.

---
[< Previous: Week 4](week4.md) | [Return to Home](index.md) | [Next: Week 6 >](week6.md)
