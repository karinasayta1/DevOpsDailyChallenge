# Linux Commands Cheat Sheet - Day 03

## 🔹 File System
pwd : show current directory  
ls : list files and folders  
ls -l : detailed list view  
cd : change directory  
mkdir : create directory  
touch : create file  
cp : copy files  
mv : move/rename files  
rm : delete file  
rm -r : delete directory  
cat : view file content  
tail -f file : live log monitoring  

---

## 🔹 Process Management
ps aux : show running processes  
top : monitor CPU & memory  
htop : interactive process view  
kill <PID> : stop process  
kill -9 <PID> : force kill  
pgrep name : find process by name  
pkill name : kill process by name  
jobs : list background jobs  
bg : run process in background  
fg : bring process to foreground  
nohup command & : run process after logout  

---

## 🔹 System & Logs
df -h : disk usage  
du -h : file size  
free -h : memory usage  
uptime : system running time  
dmesg | tail : recent logs  

---

## 🔹 Networking
ping google.com : check connectivity  
ip addr : show IP address  
curl url : test API/website  
dig domain : check DNS  
ss -tulnp : check open ports  
netstat -tulnp : network connections  
traceroute domain : check network path  

---

##  Use Case
- Debug processes → ps, top, kill  
- Check logs → tail -f  
- Network issues → ping, curl, dig  
- System health → df, free  
