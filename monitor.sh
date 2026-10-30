
#!/bin/bash

# Linux System Health Monitor

WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90

# Check system information
system_info() {
    echo "========== SYSTEM INFORMATION =========="
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo
}

# Check memory usage
memory_info() {
    echo "========== MEMORY INFORMATION =========="

    free -h

    memory_usage=$(free | awk '/^Mem:/ {
        printf "%.0f", (($3)/$2)*100
    }')

    echo "Memory Usage: ${memory_usage}%"

    if [ "$memory_usage" -ge "$CRITICAL_THRESHOLD" ]; then
        echo "STATUS: CRITICAL - High memory usage!"
    elif [ "$memory_usage" -ge "$WARNING_THRESHOLD" ]; then
        echo "STATUS: WARNING - Memory usage is high."
    else
        echo "STATUS: NORMAL"
    fi

    echo
}

# Check disk usage
disk_info() {
    echo "========== DISK INFORMATION =========="

    df -h /

    disk_usage=$(df -P / | awk 'NR==2 {
        gsub("%","",$5);
        print $5
    }')

    echo "Disk Usage: ${disk_usage}%"

    if [ "$disk_usage" -ge "$CRITICAL_THRESHOLD" ]; then
        echo "STATUS: CRITICAL - Disk almost full!"
    elif [ "$disk_usage" -ge "$WARNING_THRESHOLD" ]; then
        echo "STATUS: WARNING - Disk usage is high."
    else
        echo "STATUS: NORMAL"
    fi

    echo
}

# Main program
echo "========================================"
echo "       LINUX SYSTEM HEALTH MONITOR"
echo "========================================"
echo

system_info
memory_info
disk_info

