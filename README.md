# CMPN202-Operating-Systems-Journal
**Student ID:** A00031761

**Name:** Mohammad Betab Alam

**Module:** CMPN202 Operating Systems

**University:** University of Roehampton

A technical journal documenting the configuration, security hardening, and performance analysis of a headless Linux server infrastructure.

## Project Overview
Such​‍​‌‍​‍‌ a technical journal exemplifies the creation of a robust Linux server environment that not only illustrates professional sysadmin competencies but also the capacity for critical evaluation of operating system behavior.

The endeavour centres around the installation of a two-computer setup with a **headless Linux server** that is the only management target by means of SSH and a separate **administrative workstation**. This log of the 7 weeks documents the step-by-step, repetitive pathway ​‍​‌‍​‍‌of:

1.  **System Planning:** Designing a virtualized network architecture.
2.  **Security Hardening:** Implementing industry-standard controls including SSH key authentication, firewalls (UFW), and intrusion detection (Fail2Ban)
3. **Automation:** Developing Bash scripts for security verification `security-baseline.sh` and remote system monitoring `monitor-server.sh`
4.  **Performance Analysis:** Conducting quantitative stress testing to evaluate CPU, memory, and I/O limitations under different application workloads

## Learning Objectives
By completing this assessment, this journal demonstrates the achievement of the following learning outcomes:
* **Security:** Assessing vulnerabilities and applying mechanisms to protect systems from exploits.
* **Command-Line Proficiency:** Using system utilities for process monitoring, file manipulation, and configuration without a graphical interface.
* **Critical Evaluation:** Synthesizing knowledge of hardware constraints and performance trade-offs to understand the computer as an integrated system

## Technical Environment
* **Server OS:** Ubuntu Server 24.04 LTS (Headless)
* **Workstation:** Ubuntu Desktop VM 
* **Virtualization:** Oracle VirtualBox (Host-Only Network)
* **Tools:** SSH, Bash, UFW, Fail2Ban, Lynis, Nmap
## Table of Contents
* [Week 1: System Planning and Distribution Selection](week1.md)
* [Week 2: Security Planning and Testing Methodology](week2.md)
* [Week 3: Application Selection for Performance Testing](week3.md)
* [Week 4: Initial System Configuration](week4.md)
* [Week 5: Advanced Security and Monitoring](week5.md)
* [Week 6: Performance Evaluation and Analysis](week6.md)
* [Week 7: Security Audit and System Evaluation](week7.md)
