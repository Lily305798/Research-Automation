#!/bin/bash
# filepath: /home/kali/Documents/Scripts/2025_03_VM_init.sh
# Description: Script to initialize a VM with necessary updates and tools.
# Author: L3l7
# Date: March 21, 2025
# Usage: Run this script as root or with sudo privileges.

# Variables
VSCODE_REPO="https://packages.microsoft.com/repos/code"
VSCODE_KEY="/usr/share/keyrings/packages.microsoft.gpg"
LOGFILE="/var/log/2025_03_vm_init.log"
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
    read -p "This script was designed to initialize a VM with necessary updates and tools. Do you want to continue? (Y/n): " user_input
    user_input=${user_input,,} # Conversion to lowercase
    if [[ "$user_input" != "y" ]]; then
        echo "Exiting script as per user request."
        exit 0
    fi
}

# Step 1: Update and upgrade the VM

update_and_upgrade() {
    echo "Updating and upgrading the system..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean
}

# If one of these errors occur, run the following command to fix it :
# 1. syntax error in the mitmproxy package's Python code :
# sudo apt remove --purge mitmproxy
# sudo apt autoremove
# sudo apt update
# sudo apt install mitmproxy
# sudo apt --fix-broken install
# Last cmd should yield no errors


# Step 2: Install the necessary packages for the VM
# VSCode
install_vscode() {
    echo "Installing Visual Studio Code..."
    sudo apt install software-properties-common apt-transport-https wget -y || { echo "Failed to install prerequisites. You got internet ?"; exit 1; }
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o "$VSCODE_KEY" || { echo "Failed to download Microsoft GPG key. Check if obsolete ?"; exit 1; }
    echo "deb [arch=amd64 signed-by="$VSCODE_KEY"] "$VSCODE_REPO" stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update || { echo "Failed to update package lists. That's odd."; exit 1; }
    sudo apt install code -y || { echo "Failed to install VSCode. That's odd."; exit 1; }
}

# Enum4linux, Gobuster, Nmap, OpenVPN, Python3, Python3-pip, Python3-venv, Wget, Wireshark, Zsh... for a start
install_other_tools() {
    echo "Installing the additional tools..."
    # Enumeration and Scanning
    sudo apt install enum4linux gobuster nmap -y || { echo "Failed to install one of the enumeration and scanning tools."; exit 1; }
    # Networking and VPN
    sudo apt install openvpn wireshark -y || { echo "Failed to install one of the networking and VPN tools."; exit 1; }
    # Programming and Development
    sudo apt install python3 python3-pip python3-venv -y || { echo "Failed to install one of the programming and development tools."; exit 1; }
    # System Utilities
    sudo apt install wget zsh -y || { echo "Failed to install one of the system utilities tools."; exit 1; }
}

check_privis
confirm_prompt

update_and_upgrade
install_vscode
install_other_tools