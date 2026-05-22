# Day 06 – Linux File I/O (Notes)

## 📌 Goal
Learn how to create, write, read, and process text files in Linux.

---

## 🟢 Basic Commands

### Create File
`touch notes.txt`  
Creates empty file

---

### Write (Overwrite)
`echo "Line 1: Linux is powerful" > notes.txt`  
Writes data, deletes old content

---

### Append
`echo "Line 2: DevOps uses Linux daily" >> notes.txt`  
Adds new line without deleting old data

---

### Write + Display
`echo "Line 3: Practice makes perfect" | tee -a notes.txt`  
Shows output + appends to file

---

## 📖 Read File

`cat notes.txt`  
Shows full file  

`head -n 2 notes.txt`  
Shows first 2 lines  

`tail -n 2 notes.txt`  
Shows last 2 lines  

---

## 🔍 Advanced Commands

### Search
`grep "Linux" notes.txt`  
`grep -i "linux" notes.txt`  
`grep -n "Line" notes.txt`  
Search text, ignore case, show line numbers

---

### Sort & Remove Duplicates
`sort notes.txt`  
`sort notes.txt | uniq`  
Sort data and remove duplicates

---

### Count
`wc notes.txt`  
`wc -l notes.txt`  
Count lines, words, characters

---

### Pipes (Combine Commands)
`cat notes.txt | grep "Linux"`  
`cat notes.txt | grep "Line" | wc -l`  
Chain commands

---

### Extract Data
`cut -d " " -f 2 notes.txt`  
Extract specific column

---

### Replace Text
`sed 's/Linux/UNIX/g' notes.txt`  
Replace text

---

### Live Monitoring
`tail -f notes.txt`  
Monitor file in real time

---

## ⚡ Real DevOps Example

`cat notes.txt | grep "Line" | sort | uniq | wc -l`  

Read → filter → sort → remove duplicates → count

---

## 📂 Final File Output

`Line 1: Linux is powerful`  
`Line 2: DevOps uses Linux daily`  
`Line 3: Practice makes perfect`  

---

## 🧠 Key Notes

- `>` overwrite file  
- `>>` append data  
- `tee` write + display  
- `grep` search logs  
- `tail -f` real-time debugging  
- `|` combine commands  

---

## 🚀 Why Important

- Used in logs (/var/log)
- Used in config files
- Helps in debugging and automation

---

# ✅ Day 06 Completed