#!/bin/bash
# filepath: /home/kali/Documents/Scripts/2025_03_bashrc.sh
# Description: Script to customize the bashrc file.
# Author: L3l7
# Date: March 24, 2025
# Usage: Run this script as root or with sudo privileges.

# Variables
HOME="/home/kali"
BASHRC_FILE="$HOME/.bashrc"
TIMESTAMP_PROMPT='PS1="[\[\033[0;32m\]\u@\h \[\033[0;36m\]\w \[\033[0;33m\]\$(date +%Y-%m-%d\ %H:%M:%S)\[\033[0m\]]\$ "'
LOGFILE="/var/log/configscripts/2025_03_bashrc.log"
RECORDING_FILE="/var/log/configscripts/terminal_session_$(date +%Y%m%d_%H%M%S)_bashrc.log"


exec > >(tee -a "$LOGFILE") 2>&1 # Log all output to respective logfile


check_privis() { # Check are you root
    if [ "$EUID" -ne 0 ]; then
        echo "This awesome script requires to be run as root or with sudo privileges."
        exit 1
    fi
}

confirm_prompt() { # Confirmation prompt
    read -p "This script was designed to customize the bashrc file to fit user needs. Do you want to continue? (Y/n): " user_input
    user_input=${user_input,,} # Conversion to lowercase
    if [[ "$user_input" != "y" ]]; then
        echo "Exiting script as per user request."
        exit 0
    fi
}

# Step 1: Modify .bashrc file to user needs

modify_bashrc() {
    if grep -q "PS1=.*date" "$BASHRC_FILE"; then
        echo "Timestamp prompt is already configured in $BASHRC_FILE."
    else
        echo "Adding timestamp prompt to $BASHRC_FILE..."
        echo "" >> "$BASHRC_FILE"
        echo "# Custom prompt with timestamp" >> "$BASHRC_FILE"
        echo "$TIMESTAMP_PROMPT" >> "$BASHRC_FILE"
        echo "Timestamp prompt added successfully."
    fi
}

# Step 2: Start terminal session recording if needed
start_terminal_recorder() {
    echo "Starting terminal session recording..."
    echo "All terminal activity will be recorded in: $RECORDING_FILE"
    echo "To stop recording, type 'exit' or press Ctrl+D."

    # Using the terminal session recorder Script
    script -q "$RECORDING_FILE"
}



check_privis
confirm_prompt

modify_bashrc
start_terminal_recorder
