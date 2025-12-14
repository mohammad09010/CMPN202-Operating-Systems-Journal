# Week 4: Initial System Configuration & Security Implementation

## 1. Introduction
Phase 4 marks the transition from planning to active security implementation. The objective was to deploy foundational controls to the headless server, specifically replacing password-based authentication with cryptographic keys and implementing a strict firewall policy.

## 2. User Privilege Management
To mitigate the risk of privilege escalation (Threat T2), I created a dedicated non-root administrative user `admin_user` and granted them limited `sudo` privileges.

### Implementation Command:
```bash
sudo adduser admin_user
sudo usermod -aG sudo admin_user
```
<img width="935" height="530" alt="image" src="https://github.com/user-attachments/assets/3740af02-1533-4675-bfd2-1df6bb73e2b3" />

```bash
ssh admin_user@server_ip
```
<img width="903" height="763" alt="image" src="https://github.com/user-attachments/assets/bc891a57-8b56-438c-ab34-e062b177079f" />

**Verification:** The user is now part of the `sudo` group, allowing administrative tasks only when explicitly requested.

## 3. SSH Hardening & Key-Based Authentication
To mitigate Brute Force attacks (Threat T1), I transitioned from password authentication to ED25519 key pairs.

### SSH Access Evidence
The screenshot below demonstrates a successful login from the workstation using the private key. Note the absence of a password prompt.
```bash
ssh-keygen -t ed25519
```
<img width="924" height="512" alt="image" src="https://github.com/user-attachments/assets/5636318d-8c21-41cf-823b-da3c9058a9ed" />

![SSH Key Login](ssh_key_login.png)
*Successful SSH connection using cryptographic keys.*

### Configuration File Comparison (`/etc/ssh/sshd_config`)
I modified the SSH daemon configuration to strictly enforce the new security policy.

| Setting | Before (Default) | After (Hardened) | Justification |
| :--- | :--- | :--- | :--- |
| `PermitRootLogin` | `yes` | **`no`** | Prevents direct root access. |
| `PasswordAuthentication` | `yes` | **`no`** | Eliminates password guessing attacks. |

### Configuration Verification
![SSH Config Check](sshd_config_after.png)
*Grep output confirming that PasswordAuthentication and PermitRootLogin are disabled.*

## 4. Firewall Configuration (UFW)
I implemented a "Whitelist" strategy using UFW. The default policy rejects all incoming traffic. The only exception is Port 22 (SSH), restricted to the administrative workstation.

### Evidence of Active Firewall
![UFW Status](ufw_status.png)
* Output of `ufw status verbose` confirming the strict access control rules.*

---
[< Previous: Week 3](week3.md) | [Return to Home](index.md) | [Next: Week 5 >](week5.md)
