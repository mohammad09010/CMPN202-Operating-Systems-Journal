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
iperf3 -c 192.168.56.101 -t 30
```
<img width="772" height="251" alt="image" src="https://github.com/user-attachments/assets/ba9c90b0-c17c-430f-9a3a-bfcc0b16946a" />

##### Result: Throughput stability improved, reducing occasional retransmissions.


