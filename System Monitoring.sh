#!/bin/bash

# Create a System Monitoring Script

# varibles

output=$HOME/research/sys_info.txt
date=$(date +'%m/%d/%Y')
threshold=1
LOG_FILE="system_monitor.log"
base_on="cpu"
INFILE=/proc/stat

# Initialize color
BLUE='\033[0;34m'  #Titles
NC='\033[0m'
RED='\033[0;31m'    #Error
GREEN='\033[0;32m'  #Success
YELLOW='\033[0;33m'  #Info

# Socure the file
# shellcheck disable=SC1091
source ./check_cpu.sh
# shellcheck disable=SC1091
source ./check_disk.sh
# shellcheck disable=SC1091
source ./check_memory.sh
# shellcheck disable=SC1091
source ./check_top_proc.sh



main (){
    echo -e "${BLUE}System Monitoring Script"
    echo -e "-----------------------${NC}"
    
    
    # display the current date and time
    
    echo -e " $YELLOW Current date and time: $date $NC" | tee -a "$LOG_FILE"
    echo "---------------------------------"
    
    while getopts 't:f:n:i:b:' flag; do
        case "${flag}" in
            t) threshold=${OPTARG} ;;
            f) output=${OPTARG} ;;
            n) number_of_processes=${OPTARG} ;;
            i) iteration=${OPTARG} ;;
            b) base_on=${OPTARG} ;;
            *) echo -e " $RED Invalid option. Please use -t for threshold and -f for output file $NC" ;;
        esac
    done
    echo "$base_on $iteration $number_of_processes $threshold $output"
    check_disk_usage "$LOG_FILE"

    check_cpu_usage "$threshold" "$iteration" "$LOG_FILE"

    check_memory_usage "$LOG_FILE"
    
    check_top_processes "$LOG_FILE" "$number_of_processes" "$base_on"

    echo -e " $GREEN System Monitoring Script is done $NC" | tee -a "$LOG_FILE"
}
main "$@"
