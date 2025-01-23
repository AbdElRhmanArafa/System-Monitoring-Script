#!/bin/bash


check_cpu_usage() {
    #  $1 is the threshold
    threshold=$1
    # $2 is iteration
    iteration=$2
    # $3 is the log file
    LOG_FILE=$3


    # display the CPU Usage using top command
    echo -e "$BLUE CPU Usage: $NC" | tee -a "$LOG_FILE"
    echo "Using top command: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%" | tee -a "$LOG_FILE"
    echo -e "$GREEN --------------------------------- $NC" | tee -a "$LOG_FILE"

    # using file /proc/stat to get the CPU usage
    # using while loop to get the CPU usage and therthreshold.
    echo -e "$BLUE Using /proc/stat file : $NC"
    while [  "$iteration"  -ne 0 ]; do
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
        
        if [ "$(echo "scale=2; $usage > $threshold" | bc)" -eq 1 ]; then
            #echo "CPU usage is above threshold ($threshold%): $usage%"
            # real action
            echo "CPU usage is above threshold: $usage%" | tee -a "$LOG_FILE"
        fi
        
        prev_total=$total
        prev_idle=$idle
        sleep 1
        iteration=$((iteration - 1))
    done
}
