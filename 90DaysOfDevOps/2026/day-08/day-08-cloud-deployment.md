# 🚀 Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

---

## 🛠 Commands Used

### SSH Connection
chmod 400 your-key.pem  
ssh -i your-key.pem ubuntu@<your-public-ip>  

### System Update
sudo apt update && sudo apt upgrade -y  

### Docker Installation
sudo apt install docker.io -y  
sudo systemctl start docker  
sudo systemctl enable docker  

### Nginx Installation
sudo apt install nginx -y  
sudo systemctl start nginx  
sudo systemctl enable nginx  
systemctl status nginx  

### Logs Handling
cd /var/log/nginx  
ls  
cat access.log  
cat access.log > ~/nginx-logs.txt  

### File Transfer
scp -i your-key.pem ubuntu@<your-ip>:~/nginx-logs.txt .  

---

## ⚠️ Challenges Faced

- Permission denied while SSH  
  → Fixed using: chmod 400 your-key.pem  

- Nginx not accessible in browser  
  → Fixed by allowing port 80 in security group  

- Logs not visible  
  → Navigated correctly to /var/log/nginx  

---

## 📚 What I Learned

- How to launch and connect to a cloud server using SSH  
- Installing and managing services like Docker and Nginx  
- Understanding security groups and opening ports  
- How to access and analyze logs  
- Transferring files from server to local machine using SCP  

---

## 🎯 Why This Matters for DevOps

This task helped me understand real-world DevOps workflows:

- Provisioning cloud infrastructure  
- Managing remote servers  
- Deploying and running web servers  
- Debugging using logs  
- Handling security and access control  

These are essential skills required in production environments.

---