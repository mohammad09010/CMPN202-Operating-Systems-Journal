#!/bin/bash
# Script: monitor-server.sh
# Purpose: Remote performance monitoring script
# Author: A00031761

SERVER_IP="192.168.56.10"
USER="admin_user"

echo "Timestamp,CPU_User,CPU_Sys,RAM_Free,Disk_Usage" > server_metrics.csv

while true; do
    TIMESTAMP=$(date "+%H:%M:%S")
    # Fetch metrics via SSH
    METRICS=$(ssh $USER@$SERVER_IP "vmstat 1 2 | tail -1 | awk '{print \$13,\$14}' && free -m | grep Mem | awk '{print \$4}' && df -h / | tail -1 | awk '{print \$5}'")

    # Format and save
    echo "$TIMESTAMP $METRICS" | tr ' ' ',' >> server_metrics.csv
    sleep 1
done
