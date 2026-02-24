#!/bin/bash
# filepath: /home/kali/Documents/Scripts/2025_12_aptupdate.sh
# Description: Script to update and upgrade a linux system with the apt package manager.
# Author: L3l7
# Date: December 12, 2025
# Usage: Run this script as root or with sudo privileges.

LOGFILE="/var/log/configscripts/2025_12_aptupdate.log"

exec > >(tee -a "$LOGFILE") 2>&1 # Log all output to respective logfile

# Check if the script is being run as root or with sudo privileges
check_privis() {
    if [ "$EUID" -ne 0 ]; then
        echo "This awesome script requires to be run as root or with sudo privileges."
        exit 1
    fi
}

# Confirmation prompt
confirm_prompt() {
    read -p "This script was designed to update and upgrade a linux system with the apt package manager. Do you want to continue? (Y/n): " user_input
    user_input=${user_input,,} # Conversion to lowercase
    if [[ "$user_input" != "y" ]]; then
        echo "Exiting script as per user request."
        exit 0
    fi
}

# Step: Update and upgrade the system
update_and_upgrade() {  
    echo "Updating and upgrading the system..."
    apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean
}

check_privis
confirm_prompt
update_and_upgrade