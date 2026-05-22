
#  Linux Architecture & Basics

##  Architecture of Linux

Linux follows a layered architecture where each layer interacts with the one below it:

### 1. **Hardware**

* The physical components of the system such as CPU, memory (RAM), disk, and input/output devices.
* The operating system is installed on top of this layer.

### 2. **Kernel**

* The **core (heart) of Linux**.
* Directly interacts with hardware.
* Responsibilities:

  * Process management
  * Memory management
  * Device management
  * File system handling
* Controls everything happening in the system.

### 3. **Shell**

* Interface between **user and kernel**.
* Allows users to execute commands.
* Examples: `bash`, `sh`, `zsh`

### 4. **Applications**

* Programs that run in **user space**.
* Examples:

  * Google Chrome
  * VS Code
  * Docker
* These do not directly interact with hardware; they use the kernel.

### 5. **System Utilities**

* Command-line tools used for performing system operations.
* Work in user space but depend on the kernel.
* Examples:

  * `ls`
  * `cp`
  * `top`
  * `ps`



##  Processes in Linux

* A **process** is an instance of a running program.
* Whenever you execute a command or application, a process is created.

###  Example:

```bash
ping www.google.com
```

* This creates a `ping` process.
* It continuously sends requests and receives responses → process keeps running.

---

##  Process States in Linux

| State        | Description                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------- |
| **Running**  | Process is actively executing on CPU                                                           |
| **Sleeping** | Waiting for input/output (idle state)                                                          |
| **Stopped**  | Paused using signals like `SIGSTOP` (Ctrl + Z)                                                 |
| **Zombie**   | Process has finished execution but still exists in process table until parent reads its status |

---

##  systemd (init / PID 1)

* `systemd` is the **first process** that starts when Linux boots.
* It always has **PID = 1**.
* Responsible for managing system services.

###  Responsibilities:

* Start, stop, restart services
* Monitor system services
* Manage background processes (daemons)
* Provide logging and troubleshooting support

###  Example:

```bash
systemctl status nginx
```

---

##  Commonly Used Linux Commands

| Command                      | Description                 |
| ---------------------------- | --------------------------- |
| `ls`                         | List files and directories  |
| `cd`                         | Change directory            |
| `pwd`                        | Show current directory path |
| `cat`                        | Display file content        |
| `systemctl status <service>` | Check service status        |

