#!/bin/bash


check_memory_usage() {
    LOG_FILE=$1
    # display the Memory Usage
    echo "Memory Usage:"
    memory_info=$(free -h | grep Mem)
    total_mem=$(echo "$memory_info" | awk '{print $2}')
    used_mem=$(echo "$memory_info" | awk '{print $3}')
    free_mem=$(echo "$memory_info" | awk '{print $4}')
    available_mem=$(echo "$memory_info" | awk '{print $7}')
    echo "Total Memory: $total_mem" | tee -a "$LOG_FILE"
    echo "Used Memory: $used_mem" | tee -a "$LOG_FILE"
    echo "Free Memory: $free_mem" | tee -a "$LOG_FILE"
    echo "Available Memory: $available_mem" | tee -a "$LOG_FILE"
    echo "-----------------------" | tee -a "$LOG_FILE"
    if [ "$(echo "scale=2; $used_mem / $total_mem * 100 > 90" | bc)" -eq 1 ]; then
        echo -e "$RED Memory usage is above 90%: $used_mem $NC" | tee -a "$LOG_FILE"
    fi
}

