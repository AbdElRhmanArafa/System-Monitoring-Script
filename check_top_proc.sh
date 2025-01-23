#!/bin/bash

check_top_processes() {
    LOG_FILE=$1
    number_of_processes=$2
    base_on=$3
    
    if [ "$base_on" == "cpu" ]; then
        echo -e " $BLUE Top $number_of_processes processes CPU consume: $NC" | tee -a "$LOG_FILE"
        echo "-----------------------"  | tee -a "$LOG_FILE"
        ps aux --sort=-%cpu | awk 'NR>1 {printf "%-10s %-8.2f %-50s\n", $1, $3, $11}' | head -$number_of_processes | tee -a "$LOG_FILE"
    elif [ "$base_on" == "mem" ]; then
        echo -e " $BLUE Top $number_of_processes processes memory consume: $NC " | tee -a "$LOG_FILE"
        echo "-----------------------"  | tee -a "$LOG_FILE"
        ps aux --sort=-%mem |awk 'NR>1 {printf "%-10s %-5s %-50s %s MB\n", $1, $4, $11, $6/1024}' | head -$number_of_processes | tee -a "$LOG_FILE"
    else
        echo -e "$RED Invalid base_on value. Please use 'cpu' or 'memory' $NC" | tee -a "$LOG_FILE"
    fi
}
