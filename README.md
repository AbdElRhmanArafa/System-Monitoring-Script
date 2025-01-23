# System Monitoring Script

This script monitors various system resources such as CPU usage, memory usage, disk usage, and top processes. It logs the information to a specified log file and provides alerts if certain thresholds are exceeded.

## Files

- `System Monitoring.sh`: The main script that orchestrates the monitoring tasks.
- `check_cpu.sh`: Script to check CPU usage.
- `check_memory.sh`: Script to check memory usage.
- `check_disk.sh`: Script to check disk usage.
- `check_top_proc.sh`: Script to check top processes by CPU or memory usage.
- `.gitignore`: Specifies files to be ignored by Git.
- `system_monitor.log`: Log file where the monitoring results are stored.

## Usage

Run the main script with the following command:

```sh
./System\ Monitoring.sh [options]
```

### Options

- `-t`: Set the threshold for CPU, memory, and disk usage (default: 80%).
- `-f`: Set the log file path (default: system_monitor.log).
- `-i`: Set the interval for monitoring in seconds (default: 5 seconds).
- `-n`: Set the number of top processes to display (default: 5).
- `-b`: Base on either CPU or memory usage for top processes (default: CPU).

## Example

```sh
./System\ Monitoring.sh -t 90 -f /var/log/system_monitor.log -i 10 -n 10 -b memory
```

### notes

- To remve cron job use `crontab -e` and remove the line that was added by the script
