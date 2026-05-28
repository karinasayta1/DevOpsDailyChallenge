# Day 12 – Breather & Revision (Days 01–11)

## 🎯 Goal
Take a pause to consolidate everything learned so far and strengthen fundamentals.

---

## 🧠 Mindset & Plan
- My goal to become a DevOps Engineer in 2026 is still clear.
- Consistency is working → daily progress > perfect learning.
- Improvement: Need to focus more on networking and deeper Linux concepts.

---

## ⚙️ Processes & Services (Re-run Observations)
Commands practiced:
- `ps aux` → Observed multiple background processes; helps identify CPU-heavy tasks.
- `systemctl status nginx` → Verified service is active and running.
- `journalctl -u nginx` → Checked logs for debugging and service behavior.

---

## 📁 File Skills Practice
Commands practiced:
- `echo "test" >> file.txt` → Appended content successfully.
- `chmod 751 file.txt` → Applied secure permissions.
- `ls -l` → Verified permission changes.

---

## 🔁 Cheat Sheet Refresh (Top 5 Commands)
- `ps aux` → Process overview  
- `top` → Real-time monitoring  
- `systemctl status` → Service health  
- `journalctl -u service` → Logs debugging  
- `free -m` → Memory usage  

---

## 👤 User/Group Sanity Check
- Created a user using `useradd`
- Verified using `id username`
- Checked ownership using `ls -l`
- Changed ownership using `chown` and confirmed changes

---

## 🧪 Mini Self-Check

### 1. Which 3 commands save you the most time and why?
- `ps aux` → Quick process visibility  
- `systemctl status` → Instant service status  
- `journalctl -u` → Fast debugging with logs  

---

### 2. How do you check if a service is healthy?
- `systemctl status <service>`  
- `journalctl -u <service>`  
- `ps aux | grep <service>`  

---

### 3. How do you safely change ownership and permissions?
Example:
- `sudo chown user:group file.txt`
- `chmod 751 file.txt`  

Ensures secure and controlled access.

---

### 4. What will you focus on next 3 days?
- Networking basics  
- Linux Volume Management (LVM)  
- User & group management  
- AWS fundamentals (if time allows)  

---

## 📌 Key Takeaways
- Stronger understanding of Linux basics  
- More confidence in troubleshooting  
- Need deeper practice in networking  

---