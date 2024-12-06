#!/bin/bash

# Create a System Monitoring Script

# varibles

output=$HOME/research/sys_info.txt
date=$(date +'%m/%d/%Y')
threshold=1
LOG_FILE="system_monitor.log"
INFILE=/proc/stat
iteration=2
x=0

check_disk_usage() {
    # display the current date and time
    echo "Current date and time: $date"
    echo "---------------------------------"

    # display the Disk Usage
    echo "Disk Usage:"
    df -h 
    echo ""
    echo "---------------------------------"

}

check_cpu_usage() {
    # display the CPU Usage
    echo "CPU Usage:"

    # using top command to get the CPU usage
    echo "Using top command: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%"
    # using file /proc/stat to get the CPU usage
    # using while loop to get the CPU usage and therthreshold.
    echo "---------------------------------"
    echo "Using /proc/stat file :"
    while [ $x -lt $iteration ]; do
        read -r _ user nice system idle iowait irq softirq steal _ <$INFILE
        idle=$((idle + iowait))
        non_idle=$((user + nice + system + irq + softirq + steal))
        total=$((idle + non_idle))
        # Initialize prev_total and prev_idle if not set
        prev_total=${prev_total:-$total}
        prev_idle=${prev_idle:-$idle}

        # Calculate the CPU usage
        total_diff=$((total - prev_total))
        idle_diff=$((idle - prev_idle))
        usage=$(echo " scale=2; 1000 * ($total_diff - $idle_diff) / ($total_diff + 5)" | bc)
        usage=$(echo "scale=2; $usage / 10" | bc)
        if [ $x != 0 ]; then

            echo "CPU usage: $usage%"
        fi
        if [ "$(echo "scale=2; $usage > $threshold" | bc)" -eq 1 ]; then
            #echo "CPU usage is above threshold ($threshold%): $usage%"
            # real action
            echo "CPU usage is above threshold: $usage%" >>$LOG_FILE
        fi

        prev_total=$total
        prev_idle=$idle
        sleep 1
        x=$((x + 1))
    done
}
check_memory_usage() {
    # display the Memory Usage
    echo "Memory Usage:"
    memory_info=$(free -h | grep Mem)
    total_mem=$(echo "$memory_info" | awk '{print $2}')
    used_mem=$(echo "$memory_info" | awk '{print $3}')
    free_mem=$(echo "$memory_info" | awk '{print $4}')
    echo "Total Memory: $total_mem" | tee -a "$LOG_FILE"
    echo "Used Memory: $used_mem" | tee -a "$LOG_FILE"
    echo "Free Memory: $free_mem" | tee -a "$LOG_FILE"
    echo "-----------------------" | tee -a "$LOG_FILE"
}
check_top_processes() {
    # display the top 5 processes
    echo "Top 5 processes memory consume:"
    ps aux --sort=-%mem |awk 'NR>1 {printf "%-10s %-5s %-50s %s MB\n", $1, $4, $11, $6/1024}' | head -5
    echo "-----------------------"
    echo "Top 5 processes CPU consume:"
    echo "-----------------------"
    ps aux --sort=-%cpu | awk 'NR>1 {printf "%-10s %-8.2f %-50s\n", $1, $3, $11}' | head -5
    echo
    echo "-----------------------"
}

check_disk_usage
check_cpu_usage
check_memory_usage
check_top_processes
