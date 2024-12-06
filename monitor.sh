#!/bin/bash

# Log file to store system statistics
LOG_FILE="system_monitor.log"

# Function to display current system statistics
display_stats() {
    echo "=== System Statistics ==="
    echo "Time: $(date)"
    echo "CPU Usage:"
    top -b -n1 | grep "Cpu(s)" | awk '{print "  " $2 "% user, " $4 "% system, " $8 "% idle"}'
    echo "RAM Usage:"
    free -h | awk '/Mem:/ {print "  Used: "$3", Free: "$4}'
    echo "Disk Usage:"
    df -h --output=source,pcent | grep '^/dev' | awk '{print "  " $1 " occupied: "$2}'
}

# Function to log statistics into a file
log_stats() {
    {
        echo "=== System Statistics ==="
        echo "Time: $(date)"
        echo "CPU Usage:"
        top -b -n1 | grep "Cpu(s)" | awk '{print "  " $2 "% user, " $4 "% system, " $8 "% idle"}'
        echo "RAM Usage:"
        free -h | awk '/Mem:/ {print "  Used: "$3", Free: "$4}'
        echo "Disk Usage:"
        df -h --output=source,pcent | grep '^/dev' | awk '{print "  " $1 " occupied: "$2}'
        echo ""
    } >> "$LOG_FILE"
}

# User menu
echo "Choose an option:"
echo "1. Display current statistics"
echo "2. Save statistics to log file ($LOG_FILE)"
echo "3. Exit"
read -p "Your choice: " choice

case $choice in
    1)
        display_stats
        ;;
    2)
        log_stats
        echo "Statistics saved to $LOG_FILE"
        ;;
    3)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option. Try again."
        ;;
esac
