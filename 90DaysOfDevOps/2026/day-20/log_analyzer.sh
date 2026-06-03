#!/bin/bash

# -------------------------------
# Log Analyzer Script
# -------------------------------

# Task 1: Input Validation
if [ $# -eq 0 ]; then
    echo "❌ Error: Please provide a log file path."
    exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Error: File does not exist."
    exit 1
fi

echo "📂 Analyzing log file: $LOG_FILE"
echo "-----------------------------------"

# Total lines
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# Task 2: Error Count
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

echo "🚨 Total Errors: $ERROR_COUNT"

# Task 3: Critical Events
echo ""
echo "--- Critical Events ---"
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE")

if [ -z "$CRITICAL_EVENTS" ]; then
    echo "No critical events found."
else
    echo "$CRITICAL_EVENTS"
fi

# Task 4: Top 5 Error Messages
echo ""
echo "--- Top 5 Error Messages ---"

TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=$3=""; print $0}' \
    | sort | uniq -c | sort -rn | head -5)

echo "$TOP_ERRORS"

# Task 5: Generate Report
DATE=$(date +%Y-%m-%d)
REPORT_FILE="log_report_$DATE.txt"

{
    echo "===== Log Analysis Report ====="
    echo "Date: $DATE"
    echo "Log File: $LOG_FILE"
    echo "Total Lines: $TOTAL_LINES"
    echo "Total Errors: $ERROR_COUNT"
    echo ""
    echo "--- Top 5 Error Messages ---"
    echo "$TOP_ERRORS"
    echo ""
    echo "--- Critical Events ---"
    echo "$CRITICAL_EVENTS"
} > "$REPORT_FILE"

echo ""
echo "📄 Report generated: $REPORT_FILE"

# Task 6: Archive Logs (Optional)
ARCHIVE_DIR="archive"

mkdir -p "$ARCHIVE_DIR"
mv "$LOG_FILE" "$ARCHIVE_DIR/"

echo "📦 Log file moved to $ARCHIVE_DIR/"