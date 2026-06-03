# 📘 Day 21 – Shell Scripting Cheat Sheet

## 🎯 Goal

Build a personal quick-reference guide for Bash scripting covering basics, conditionals, loops, functions, and text processing.

---

# ⚡ Quick Reference Table

| Topic    | Syntax              | Example                  |
| -------- | ------------------- | ------------------------ |
| Variable | `VAR="value"`       | `NAME="DevOps"`          |
| Argument | `$1, $2`            | `./script.sh arg1`       |
| If       | `if [ cond ]; then` | `if [ -f file ]; then`   |
| For Loop | `for i in list; do` | `for i in 1 2 3; do`     |
| Until    | `until [ cond ]`    | `until [ $i -eq 5 ]`     |
| Function | `name() {}`         | `greet() { echo "Hi"; }` |
| Grep     | `grep pattern file` | `grep -i error log.txt`  |
| Awk      | `awk '{print $1}'`  | `awk -F: '{print $1}'`   |
| Sed      | `sed 's/a/b/g'`     | `sed -i 's/foo/bar/g'`   |
| Case     | `case var in`       | `case $x in`             |
| Sort     | `sort file`         | `sort -n log.txt`        |
| Tr       | `tr a-z A-Z`        | `tr a-z A-Z < file`      |
| Wc       | `wc -l`             | `wc -l file.txt`         |
| Head     | `head -n`           | `head -10 file`          |
| Tail     | `tail -n`           | `tail -10 file`          |

---

# 🧩 Task 1: Basics

## Shebang

```bash
#!/bin/bash
```

Defines interpreter (Bash). Without it, default `/bin/sh` is used.

## Running Script

```bash
chmod +x script.sh
./script.sh
bash script.sh
```

## Comments

```bash
# Single line
echo "Hello" # Inline comment
```

## Variables

```bash
name="Afroz"
echo "$name"
echo '$name'
```

## User Input

```bash
read -p "Enter Name: " name
```

## Arguments

```bash
$0 → script name
$1 → first argument
$# → total arguments
$@ → all arguments
$? → last command status
```

---

# ⚙️ Task 2: Operators & Conditionals

## String Comparison

```bash
[[ $a = $b ]]
[[ $a != $b ]]
[[ -z $a ]]
[[ -n $a ]]
```

## Integer Comparison

```bash
-eq -ne -lt -gt -le -ge
```

## File Tests

```bash
-f -d -e -r -w -x -s
```

## If-Else

```bash
if [ cond ]; then
  echo "Yes"
elif [ cond ]; then
  echo "Maybe"
else
  echo "No"
fi
```

## Logical Operators

```bash
&&  ||  !
```

## Case Statement

```bash
case $var in
  a) echo "A";;
  b) echo "B";;
  *) echo "Other";;
esac
```

---

# 🔁 Task 3: Loops

## For Loop

```bash
for i in 1 2 3; do
  echo $i
done
```

## While Loop

```bash
while [ $i -gt 0 ]; do
  echo $i
done
```

## Until Loop

```bash
until [ $i -eq 5 ]; do
  echo $i
done
```

## Loop Control

```bash
break
continue
```

## Loop Files

```bash
for file in *.log; do
  echo $file
done
```

---

# 🧠 Task 4: Functions

```bash
add() {
  local a=$1
  local b=$2
  echo $((a+b))
}
```

* `local` → restrict scope
* `return` → exit status
* `echo` → output value

---

# 🔍 Task 5: Text Processing

## Grep

```bash
grep -i "error" file.log
grep -n "error" file.log
```

## Awk

```bash
awk '{print $1}'
awk -F: '{print $1}'
```

## Sed

```bash
sed 's/foo/bar/g' file
sed -i 's/foo/bar/g' file
```

## Cut

```bash
cut -d: -f1 /etc/passwd
```

## Sort / Uniq

```bash
sort file.txt
sort file.txt | uniq -c
```

## Tr

```bash
tr a-z A-Z < file
```

## Wc

```bash
wc -l file.txt
```

## Head / Tail

```bash
head -5 file
tail -5 file
```

---

# ⚡ Task 6: Useful One-Liners

```bash
find . -mtime +4
wc -l *.log
sed 's/old/new/g' *.txt
systemctl status ssh
df -h | awk '$5>80'
tail -f file.log | grep error
```

---

# 🛑 Task 7: Error Handling

## Exit Codes

```bash
$?
exit 0
exit 1
```

## Strict Mode

```bash
set -euo pipefail
```

## Debug Mode

```bash
set -x
```

## Trap

```bash
trap 'echo "Cleanup"' EXIT
```

---

# 📚 Key Learnings

* Bash is powerful when combined with Linux tools
* Automation = combining small commands smartly
* Debugging & error handling are critical in real scripts

---

# 🚀 Conclusion

This cheat sheet acts as a quick reference for daily DevOps tasks and scripting workflows.

Keep building. Keep automating. 💪
