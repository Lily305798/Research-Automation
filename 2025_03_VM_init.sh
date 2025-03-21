#!/bin/bash
# filepath: /home/kali/Documents/Scripts/2025_03_VM_init.sh
# Description: Script to initialize a VM with necessary updates and tools.
# Author: L3l7
# Date: March 21, 2025
# Usage: Run this script as root or with sudo privileges.

# Variables
VSCODE_REPO="https://packages.microsoft.com/repos/code"
VSCODE_KEY="/usr/share/keyrings/packages.microsoft.gpg"
LOGFILE="/var/log/configscripts/2025_03_vm_init.log"
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
    if command -v code &> /dev/null; then
        echo "✅ VS Code is already installed. Skipping installation."
        return 0  # Exit function early
    fi

    echo "❌ VS Code is not installed. Installing Visual Studio Code..."
    sudo apt install software-properties-common apt-transport-https wget -y || { echo "Failed to install prerequisites. You got internet ?"; exit 1; }
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o "$VSCODE_KEY" || { echo "Failed to download Microsoft GPG key. Check if obsolete ?"; exit 1; }
    echo "deb [arch=amd64 signed-by="$VSCODE_KEY"] "$VSCODE_REPO" stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update || { echo "Failed to update package lists. That's odd."; exit 1; }
    sudo apt install code -y || { echo "Failed to install VSCode. That's odd."; exit 1; }
}

# Enum4linux, Gobuster, Nmap, OpenVPN, Python3, Python3-pip, Python3-venv, Wget, Wireshark, Zsh... for a start
install_other_tools() {
    echo "Installing the additional tools..."

    # Helper function to check if a tool is installed
    is_installed() {
        dpkg -l | grep -qw "$1"
    }

    # Enumeration and Scanning
    for tool in enum4linux gobuster nmap; do
        if is_installed "$tool"; then
            echo "✅ $tool is already installed. Skipping."
        else
            echo "❌ $tool is not installed. Installing..."
            sudo apt install "$tool" -y || { echo "Failed to install $tool."; exit 1; }
        fi
    done

    # Networking and VPN
    for tool in openvpn wireshark; do
        if is_installed "$tool"; then
            echo "✅ $tool is already installed. Skipping."
        else
            echo "❌ $tool is not installed. Installing..."
            sudo apt install "$tool" -y || { echo "Failed to install $tool."; exit 1; }
        fi
    done

    # Programming and Development
    for tool in python3 python3-pip python3-venv; do
        if is_installed "$tool"; then
            echo "✅ $tool is already installed. Skipping."
        else
            echo "❌ $tool is not installed. Installing..."
            sudo apt install "$tool" -y || { echo "Failed to install $tool."; exit 1; }
        fi
    done

    # System Utilities
    for tool in wget zsh; do
        if is_installed "$tool"; then
            echo "✅ $tool is already installed. Skipping."
        else
            echo "❌ $tool is not installed. Installing..."
            sudo apt install "$tool" -y || { echo "Failed to install $tool."; exit 1; }
        fi
    done
}

check_privis
confirm_prompt

update_and_upgrade
install_vscode
install_other_tools