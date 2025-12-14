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

*Successful SSH connection using cryptographic keys.*

### Configuration File Comparison (`/etc/ssh/sshd_config`)
I modified the SSH daemon configuration to strictly enforce the new security policy.

| Setting | Before (Default) | After (Hardened) | Justification |
| :--- | :--- | :--- | :--- |
| `PermitRootLogin` | `yes` | **`no`** | Prevents direct root access. |
| `PasswordAuthentication` | `yes` | **`no`** | Eliminates password guessing attacks. |
| `PubkeyAuthentication` | `yes` | **`yes`** | Enforces the use of cryptographic keys. |

### Configuration Verification
```bash
grep -E "PermitRoot|PasswordAuth" /etc/ssh/sshd_config
```
*Grep output confirming that PasswordAuthentication and PermitRootLogin are disabled.*
<img width="850" height="217" alt="image" src="https://github.com/user-attachments/assets/b286f71a-7151-4037-ae34-503363eb42b5" />



## 4. Firewall Configuration (UFW)
I implemented a "Whitelist" strategy using UFW. The default policy rejects all incoming traffic. The only exception is Port 22 (SSH), restricted to the administrative workstation.

#### Configure Firewall (UFW)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.1.84 to any port 22
````
<img width="986" height="184" alt="image" src="https://github.com/user-attachments/assets/89a37a56-51a5-46bb-971b-68695ebeae25" />

### Evidence of Active Firewall

```bash
sudo ufw status verbose
```
<img width="833" height="295" alt="image" src="https://github.com/user-attachments/assets/aad0a82b-3d9c-4455-af02-ae496764628e" />

*Output of `ufw status verbose` confirming the strict access control rules.*

#### 5. Learning Reflection

This week highlighted the risk of remote administration. When disabling password authentication, I realized that a mistake in the `sshd_config` or a lost private key would result in a permanent lockout from the "headless" server. To prevent this, I kept one terminal session open while testing the new configuration in a second terminal, a critical safety practice in systems administration.

---
[< Previous: Week 3](week3.md) | [Return to Home](index.md) | [Next: Week 5 >](week5.md)
