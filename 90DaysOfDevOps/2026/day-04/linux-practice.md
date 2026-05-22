# Day 04 – Linux Practice: Processes and Services

## Real time output of commands I practiced

---

## Process commands

ps aux | head - List running processes (top lines)  

![ps output](screenshots/ps.png)

top - Monitor processes in real time  

![top output](screenshots/top.png)

---

## Service commands

systemctl status ssh - Check SSH service status  

![ssh status](screenshots/ssh-status.png)

systemctl list-units --type=service - List running services  

![services](screenshots/services.png)

---

## Log commands

journalctl -u ssh --no-pager | tail -n 10 - Shows SSH logs  

![journal logs](screenshots/journal.png)

tail -n 20 /var/log/syslog - Shows system logs  

![logs](screenshots/logs.png)

---

## Service for inspection (SSH)

systemctl status ssh  

![running](screenshots/ssh-status.png)

It is running. Now stopping the service:

![stopped](screenshots/stop.png)

Checking logs for issue:

![logs check](screenshots/logs.png)

Logs show service is stopped.

Starting SSH service again:

![started](screenshots/start.png)

Service is active now and working fine.

---

## What I learned

- How to check running processes using ps and top  
- How to inspect services using systemctl  
- How to read logs using journalctl and tail  
- Basic troubleshooting by stopping and restarting services  