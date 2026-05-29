# Day 14 – Networking Fundamentals & Hands-on Checks

## 🧠 OSI and TCP/IP Model

### 🔹 OSI Model
OSI is a conceptual model that defines network communication. It consists of 7 layers where each layer performs a specific function.

- **Application (L7)** – User interaction (e.g., browser)  
- **Presentation (L6)** – Data encryption/decryption, format conversion  
- **Session (L5)** – Establish/manage/terminate sessions  
- **Transport (L4)** – Reliable delivery (TCP/UDP)  
- **Network (L3)** – IP addressing, routing  
- **Data Link (L2)** – Error-free node-to-node delivery  
- **Physical (L1)** – Hardware, cables, signals  

---

### 🔹 TCP/IP Model
TCP/IP is practically used for communication over the internet.

- **Application (L4)** – Combines OSI’s Application + Presentation + Session  
- **Transport (L3)** – Same as OSI Transport  
- **Internet (L2)** – Same as OSI Network  
- **Network Access (L1)** – Physical + Data Link combined  

---

## 🌐 Protocol Placement

- **Application Layer:** HTTP, HTTPS, FTP, SMTP, DNS, DHCP, SSH  
- **Transport Layer:** TCP, UDP  
- **Internet Layer:** IP, ICMP, ARP  
- **Network Access Layer:** Ethernet, Wi-Fi  

---

## 🔍 Real Example

```
curl https://www.google.com
```

→ HTTP (Application) → TCP (Transport) → IP (Internet)

📸 Screenshot:
images/curl.png  

---

## ⚙️ Hands-on Checklist

### 🆔 Identity
```bash
hostname -I
```
**Observation:** 172.31.44.197 → primary private IP
This is your EC2 instance IP inside the VPC (AWS internal network).

172.17.0.1 → Docker bridge network IP
This appears when Docker is installed
It’s used for container networking (docker0 interface)

📸 Screenshot:
images/hostname.png  

---

### 📡 Reachability
```bash
ping <target>
```
**Observation:** 0% packet loss with ~4006 ms average latency confirms good network connectivity.

📸 Screenshot:
images/ping.png
---

### 🛣️ Path
```bash
traceroute <target>
```
**Observation:** 30 hops max with ~80.629 ms latency. Slight delay at hop 2.

📸 Screenshot:
images/traceroute.png
---

### 🔌 Ports
```bash
ss -tulpn
```

📸 Screenshot:
images/port.png
---

### 🌍 Name Resolution
```bash
dig <domain>
```
**Observation:** Domain resolves to `142.250.70.46`.

📸 Screenshot:
images/dig.png

---

### 🌐 HTTP Check
```bash
curl -I <http/https-url>
```
**Observation:** HTTP/1.1 200 OK — server responded successfully.

📸 Screenshot:
images/curl-google.png

---

### 🔄 Connections Snapshot
```bash
netstat -an | head
```
**Observation:**  
- LISTEN: 3 to 5 entries (ports 40293, 22, 80)  
- ESTABLISHED: 2 entries (HTTPS connections)

📸 Screenshot:
images/netstat.png

---

## 🔍 Mini Task: Port Probe & Interpret

### Service Identified
- nginx running on port 80

📸 Screenshot:
images/nginx.png

### Test Port
```bash
nc -zv localhost 80
```

**Result:** Connection succeeded

📸 Screenshot:
images/test-port.png
---

### If Not Reachable

- Check service status:
  ```bash
  systemctl status nginx
  ```
- Check logs:
  ```bash
  journalctl -u nginx
  ```
- Check firewall:
  ```bash
  sudo ufw status
  ```

---

## 🤔 Reflection

### Fastest Signal When Broken
- `ping` gives the quickest connectivity check

---

### If DNS Fails
- DNS works at Application layer  
- Next checks:
  ```bash
  dig, nslookup, ping, ss -tulpn
  ```

---

### If HTTP 500 Appears
- Issue at Application layer  
- Network is fine since response is received  

Check:
```bash
systemctl status <service>
journalctl -u <service>
tail -f /var/log/<service>/error.log
```

---

### Follow-up Checks in Real Incident

- Firewall check:
  ```bash
  sudo ufw status
  sudo iptables -L -n -v
  ```

- Service health:
  ```bash
  systemctl status <service>
  ```

- Connectivity test:
  ```bash
  curl -I http://<server-ip>:<port>
  nc -zv <server-ip> <port>
  ```

---

