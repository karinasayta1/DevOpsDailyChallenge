# Linux Troubleshooting Runbook – Cron Service

This runbook provides quick troubleshooting steps for the cron service.

---

## Environment Basics

### Command:

`uname -a`

**Output:**
Linux ip-172-31-44-197 7.0.0-1004-aws x86_64 GNU/Linux

**Observation:** Kernel version and architecture confirmed.

---

### Command:

`uname -r`

**Output:**
7.0.0-1004-aws

**Observation:** Confirms kernel version.

---

### Command:

`cat /etc/os-release`

**Output:**
Ubuntu 26.04 LTS

**Observation:** Confirms OS distribution and version.

---

## Filesystem Sanity

### Command:

`mkdir /tmp/runbook-demo`

**Observation:** Directory created successfully.

---

### Command:

`cp /etc/crontab /tmp/runbook-demo/crontab-copy && ls -l /tmp/runbook-demo`

**Output:**
crontab-copy present in directory

**Observation:** File copied successfully, filesystem is writable.

---

## CPU & Memory

### Command:

`top`

**Observation:** CPU idle ~100%, system load very low.

---

### Command:

`ps -o pid,pcpu,pmem,comm -C cron`

**Output:**
PID 584, CPU 0.0%, MEM 0.3%

**Observation:** cron process running with minimal resource usage.

---

### Command:

`free -h`

**Output:**
Total: ~908MB, Used: ~313MB, Free: ~400MB

**Observation:** Memory usage normal, no swap usage.

---

## Disk & IO

### Command:

`df -h`

**Output:**
Root filesystem ~31% used

**Observation:** Sufficient disk space available.

---

### Command:

`sudo du -sh /var/log`

**Output:**
18M /var/log

**Observation:** Log size is small and healthy.

---

## Network

### Command:

`ss -tulnp`

**Output:**
Port 22 (SSH) is listening

**Observation:** cron does not expose network ports (expected behavior).

---

### Command:

`ping -c 3 google.com`

**Output:**
0% packet loss

**Observation:** Network connectivity is working fine.

---

## Logs

### Command:

`journalctl -u cron -n 10`

**Output:**
CRON jobs executing (echo command visible)

**Observation:** cron service is active and running scheduled jobs.

---

## Cron Validation Test

### Command:

`crontab -e`

Added:
`* * * * * echo "cron working" >> /tmp/cron-test.log`

---

### Command:

`cat /tmp/cron-test.log`

**Output:**
cron working
cron working

**Observation:** File updates every minute confirming cron is working correctly.

---

## Quick Review

* cron service running normally
* CPU and memory usage low
* Disk space sufficient
* Network working fine
* Logs confirm cron jobs execution
* Manual cron test successful

---

## If This Worsens

1. Check logs again:
   `journalctl -u cron`

2. Verify cron jobs:
   `crontab -l`

3. Restart cron service:
   `systemctl restart cron`

4. Debug cron jobs manually

---
