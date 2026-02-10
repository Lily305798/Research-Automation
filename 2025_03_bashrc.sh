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
PS1="[\u@\h \w \$(date +%Y-%m-%d %H:%M:%S)]\$ "


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

#Step 1 : Modify .bashrc file to user needs

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

#Step 2 : Offer to source .bashrc file to apply changes immediately

source_bashrc() {
    read -p "This script can source the .bashrc file to apply changes immediately. Do you want to source it now? (Y/n): " user_input
    user_input=${user_input,,} # Conversion to lowercase
    if [[ "$user_input" == "y" ]]; then
        echo "Sourcing .bashrc file..."
        source "$BASHRC_FILE"
        echo "Bashrc file sourced successfully."
        check_locale_prompt
    else
        echo "Skipping sourcing of .bashrc file."
    fi
}

#Step 3 : Check if date and time are displayed in prompt according to user's locale settings

check_locale_prompt() {
    echo ""
    echo "=== Prompt Configuration Preview ==="
    echo "Your prompt should now display like this:"
    echo "[user@host /path YYYY-MM-DD HH:MM:SS]\$"
    echo ""
    echo "Current timezone:"
    timedatectl | grep "Time zone"
    echo ""
    read -p "Do you want to adjust the timezone? (Y/n): " user_input
    user_input=${user_input,,}
    
    if [[ "$user_input" == "y" ]]; then
        echo ""
        echo "Available timezones (showing first 20):"
        timedatectl list-timezones | head -20
        echo "... (use 'timedatectl list-timezones' to see all)"
        echo ""
        read -p "Enter the timezone you want to set (e.g., Europe/Paris, Asia/Shanghai): " timezone
        
        if timedatectl set-timezone "$timezone" 2>/dev/null; then
            echo "Timezone successfully set to: $timezone"
            timedatectl | grep "Time zone"
        else
            echo "Error: Invalid timezone '$timezone'. Please use 'timedatectl list-timezones' to find valid options."
        fi
    else
        echo "Skipping timezone adjustment."
    fi
}


check_privis
confirm_prompt

modify_bashrc
source_bashrc

