#!/bin/bash


check_disk_usage() {
    LOG_FILE=$1
    echo -e " $BLUE Disk Usage: $NC"
    output=$(df -h  | grep -Ev 'tmpfs|devtmpfs' | awk '{print $1,$5}')
    echo -e "$BLUE FILESYSTEM USAGE $NC"
    echo "$output" | tee -a "$LOG_FILE"
    echo "---------------------------------" | tee -a "$LOG_FILE"


}