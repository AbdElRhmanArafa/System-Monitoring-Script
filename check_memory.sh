#!/bin/bash


check_memory_usage() {
    LOG_FILE=$1
    # display the Memory Usage
    echo "Memory Usage:"
    memory_info=$(free -h | grep Mem)
    total_mem=$(echo "$memory_info" | awk '{print $2}' | sed 's/Gi//')
    used_mem=$(echo "$memory_info" | awk '{print $3}' | sed 's/Gi//')
    free_mem=$(echo "$memory_info" | awk '{print $4} ' | sed 's/Gi//')
    available_mem=$(echo "$memory_info" | awk '{print $7}' | sed 's/Gi//')
    echo "Total Memory: $total_mem Gi" | tee -a "$LOG_FILE"
    echo "Used Memory: $used_mem Gi" | tee -a "$LOG_FILE"
    echo "Free Memory: $free_mem Gi" | tee -a "$LOG_FILE"
    echo "Available Memory: $available_mem Gi" | tee -a "$LOG_FILE"
    echo "-----------------------" | tee -a "$LOG_FILE"
    above_90=$(echo "scale=2; $used_mem / $total_mem * 100 > 90" | bc)
    if [ "$above_90" -eq 1 ]; then
        echo -e "$RED Memory usage is above 90%: $above_90 % $NC" | tee -a "$LOG_FILE"
    fi
}

