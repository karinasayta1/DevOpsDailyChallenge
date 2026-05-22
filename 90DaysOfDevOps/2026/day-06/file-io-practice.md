# Day 06 – Linux File I/O (Notes)

## 📌 Goal
Learn how to create, write, read, and process text files in Linux.

---

## 🟢 Basic Commands

### Create File
touch notes.txt  
# creates empty file

### Write (Overwrite)
echo "Line 1: Linux is powerful" > notes.txt  
# writes data, deletes old content

### Append
echo "Line 2: DevOps uses Linux daily" >> notes.txt  
# adds new line without deleting old data

### Write + Display
echo "Line 3: Practice makes perfect" | tee -a notes.txt  
# shows output + appends to file

---

## 📖 Read File

cat notes.txt  
# shows full file

head -n 2 notes.txt  
# shows first 2 lines

tail -n 2 notes.txt  
# shows last 2 lines

---

## 🔍 Advanced Commands

### Search
grep "Linux" notes.txt  
grep -i "linux" notes.txt  
grep -n "Line" notes.txt  
# search text, ignore case, show line numbers

---

### Sort & Remove Duplicates
sort notes.txt  
sort notes.txt | uniq  
# sort data and remove duplicates

---

### Count
wc notes.txt  
wc -l notes.txt  
# count lines, words, characters

---

### Pipes (Combine Commands)
cat notes.txt | grep "Linux"  
cat notes.txt | grep "Line" | wc -l  
# chain commands

---

### Extract Data
cut -d " " -f 2 notes.txt  
# extract specific column

---

### Replace Text
sed 's/Linux/UNIX/g' notes.txt  
# replace text

---

### Live Monitoring
tail -f notes.txt  
# monitor file in real time

---

## ⚡ Real DevOps Example

cat notes.txt | grep "Line" | sort | uniq | wc -l  

# read → filter → sort → remove duplicates → count

---

## 📂 Final File Output

Line 1: Linux is powerful  
Line 2: DevOps uses Linux daily  
Line 3: Practice makes perfect  

---

## 🧠 Key Notes

- > overwrite file  
- >> append data  
- tee write + display  
- grep search logs  
- tail -f real-time debugging  
- | (pipe) combine commands  

---

## 🚀 Why Important

- Used in logs (/var/log)
- Used in config files
- Helps in debugging and automation

---

# ✅ Day 06 Completed