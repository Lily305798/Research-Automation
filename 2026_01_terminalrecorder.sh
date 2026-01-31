#!/bin/bash
# filepath: /home/kali/Documents/Scripts/2026_01_terminalrecorder.sh
# Description: Script to start a terminal session recorder .
# Author: L3l7
# Date: January 31, 2026
# Usage: Run this script as root or with sudo privileges.

# Variables
HOME="/home/kali"
BASHRC_FILE="$HOME/.bashrc"
LOGFILE="/var/log/configscripts/2026_01_terminalrecorder.log"
RECORDING_FILE="/var/log/configscripts/terminal_session_$(date +%Y%m%d_%H%M%S)_bashrc.log"


exec > >(tee -a "$LOGFILE") 2>&1 # Log all output to respective logfile


check_privis() { # Check are you root
    if [ "$EUID" -ne 0 ]; then
        echo "This awesome script requires to be run as root or with sudo privileges."
        exit 1
    fi
}

confirm_prompt() { # Confirmation prompt
    read -p "This script was designed to start a terminal session recorder. Do you want to continue? (Y/n): " user_input
    user_input=${user_input,,} # Conversion to lowercase
    if [[ "$user_input" != "y" ]]; then
        echo "Exiting script as per user request."
        exit 0
    fi
}

#Start terminal session recording
start_terminal_recorder() {
    echo "Starting terminal session recording..."
    echo "All terminal activity will be recorded in: $RECORDING_FILE"
    echo "To stop recording, type 'exit' or press Ctrl+D."

    # Using the terminal session recorder Script
    script -q "$RECORDING_FILE"
}



check_privis
confirm_prompt

start_terminal_recorder
