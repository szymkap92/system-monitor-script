#!/bin/bash

# Log file to store system statistics
LOG_FILE="system_monitor.log"

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Script version
VERSION="1.1.0"

# Function to display current system statistics
display_stats() {
    echo "${BLUE}=== System Statistics ===${RESET}"
    echo "${GREEN}Time:${RESET} $(date)"
    echo "${RED}CPU Usage:${RESET}"
    top -b -n1 | grep "Cpu(s)" | awk '{print "  "$2 "% user, "$4 "% system, "$8 "% idle"}'
    echo "${RED}RAM Usage:${RESET}"
    free -h | awk '/Mem:/ {print "  Used: "$3", Free: "$4}'
    echo "${RED}Disk Usage:${RESET}"
    df -h --output=source,pcent | grep '^/dev' | awk '{print "  "$1 " occupied: "$2}'
    echo ""
}

# Function to log statistics into a file
log_stats() {
    {
        echo "=== System Statistics ==="
        echo "Time: $(date)"
        echo "CPU Usage:"
        top -b -n1 | grep "Cpu(s)" | awk '{print "  "$2 "% user, "$4 "% system, "$8 "% idle"}'
        echo "RAM Usage:"
        free -h | awk '/Mem:/ {print "  Used: "$3", Free: "$4}'
        echo "Disk Usage:"
        df -h --output=source,pcent | grep '^/dev' | awk '{print "  "$1 " occupied: "$2}'
        echo ""
    } >> "$LOG_FILE"
}

# Function to log stats continuously
log_continuously() {
    echo "Logging system stats every 30 seconds. Press [CTRL+C] to stop."
    while true; do
        log_stats
        sleep 30
    done
}

# Function to check internet connection
check_internet() {
    echo "Checking internet connection..."
    if ping -c 1 google.com &>/dev/null; then
        echo "Internet is available."
    else
        echo "No internet connection."
    fi
}

# Function to show help
show_help() {
    echo "System Monitoring Script v$VERSION"
    echo "Usage:"
    echo "  1 - Display CPU usage"
    echo "  2 - Display RAM usage"
    echo "  3 - Display Disk usage"
    echo "  4 - Display all stats"
    echo "  5 - Log stats continuously"
    echo "  6 - Check internet connection"
    echo "  7 - Show help"
    echo "  8 - Exit"
}

# Main menu
while true; do
    echo "${BLUE}Choose an option:${RESET}"
    echo "1. Display CPU Usage"
    echo "2. Display RAM Usage"
    echo "3. Display Disk Usage"
    echo "4. Display All Stats"
    echo "5. Log Stats Continuously"
    echo "6. Check Internet Connection"
    echo "7. Show Help"
    echo "8. Exit"
    read -p "Your choice: " choice

    case $choice in
        1)
            echo "=== CPU Usage ==="
            top -b -n1 | grep "Cpu(s)" | awk '{print $2 "% user, "$4 "% system, "$8 "% idle"}'
            ;;
        2)
            echo "=== RAM Usage ==="
            free -h | awk '/Mem:/ {print "Used: "$3", Free: "$4}'
            ;;
        3)
            echo "=== Disk Usage ==="
            df -h --output=source,pcent | grep '^/dev' | awk '{print $1 " occupied: "$2}'
            ;;
        4)
            display_stats
            ;;
        5)
            log_continuously
            ;;
        6)
            check_internet
            ;;
        7)
            show_help
            ;;
        8)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "${RED}Invalid option. Try again.${RESET}"
            ;;
    esac
done
