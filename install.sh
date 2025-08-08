#!/bin/bash

# AlrelShop VPN Server Auto Installer
# Created by AlrelShop Team
# Support: Ubuntu 18.04, 20.04, 22.04, 24.04, 25.04 & Debian 9, 10, 11, 12
# Version: 2025.1
# Website: https://alrelshop.my.id

# Color definitions
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}  »${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
CYAN="\033[36m"

clear

# Export IP Address
export IP=$(curl -sS icanhazip.com)

# Clear screen
clear && clear && clear
clear;clear;clear

# AlrelShop Banner
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Developer » ${green}AlrelShop${NC} ${YELLOW}(${NC}${green} Premium Edition ${NC}${YELLOW})${NC}"
echo -e "  » Quick VPN Server Setup Script for Modern OS"
echo -e "  Pembuat : ${green}AlrelShop Team${NC}"
echo -e "  © AlrelShop VPN Script ${YELLOW}(${NC} 2025 ${YELLOW})${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
sleep 2

# Check Architecture
if [[ $(uname -m | awk '{print $1}') == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$(uname -m)${NC} )"
else
    echo -e "${ERROR} Your Architecture Is Not Supported ( ${YELLOW}$(uname -m)${NC} )"
    exit 1
fi

# Check OS and Version Support (Updated for newest versions)
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
    OS_VERSION=$(cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/VERSION_ID//g')
    if [[ $OS_VERSION == "18.04" ]] || [[ $OS_VERSION == "20.04" ]] || [[ $OS_VERSION == "22.04" ]] || [[ $OS_VERSION == "24.04" ]] || [[ $OS_VERSION == "25.04" ]]; then
        echo -e "${OK} Your OS Is Supported ( ${green}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
    else
        echo -e "${ERROR} Your Ubuntu Version Is Not Supported ( ${YELLOW}$OS_VERSION${NC} )"
        echo -e "${YELLOW} Supported: Ubuntu 18.04, 20.04, 22.04, 24.04, 25.04${NC}"
        exit 1
    fi
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
    OS_VERSION=$(cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/VERSION_ID//g')
    if [[ $OS_VERSION == "9" ]] || [[ $OS_VERSION == "10" ]] || [[ $OS_VERSION == "11" ]] || [[ $OS_VERSION == "12" ]]; then
        echo -e "${OK} Your OS Is Supported ( ${green}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
    else
        echo -e "${ERROR} Your Debian Version Is Not Supported ( ${YELLOW}$OS_VERSION${NC} )"
        echo -e "${YELLOW} Supported: Debian 9, 10, 11, 12${NC}"
        exit 1
    fi
else
    echo -e "${ERROR} Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
    echo -e "${YELLOW} Supported OS: Ubuntu 18.04/20.04/22.04/24.04/25.04, Debian 9/10/11/12${NC}"
    exit 1
fi

# IP Address Validation
if [[ $IP == "" ]]; then
    echo -e "${ERROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# Pre-installation Confirmation
echo ""
echo -e "${YELLOW}════════════════════════════════════════${NC}"
echo -e "  ${green}AlrelShop VPN Server Installation${NC}"
echo -e "${YELLOW}════════════════════════════════════════${NC}"
echo -e ""
echo -e " This script will install:"
echo -e " ${green}✓${NC} Xray Core (Latest Version)"
echo -e " ${green}✓${NC} Nginx Web Server"
echo -e " ${green}✓${NC} HAProxy Load Balancer"
echo -e " ${green}✓${NC} OpenVPN Server"
echo -e " ${green}✓${NC} SSH/Dropbear"
echo -e " ${green}✓${NC} V2Ray/Vmess/Vless/Trojan"
echo -e " ${green}✓${NC} Shadowsocks"
echo -e " ${green}✓${NC} WebSocket Proxy"
echo -e " ${green}✓${NC} UDP Mini Services"
echo -e " ${green}✓${NC} Management Panel"
echo -e " ${green}✓${NC} Auto-Menu System"
echo -e ""
echo -e " ${YELLOW}⚠️  WARNING:${NC} This will modify your system configuration"
echo -e " ${YELLOW}⚠️  NOTE:${NC} Installation will take approximately 5-10 minutes"
echo -e ""
read -p "$(echo -e "${CYAN}Do you want to continue with installation? [y/N]: ${NC}")" confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo -e "${YELLOW}Installation cancelled by user.${NC}"
    exit 0
fi

echo ""
read -p "$(echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} to start installation")"
echo ""
clear

# Root check
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi

# OpenVZ check
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

# Variables
GITHUB_USER="alrel1408"
REPO_URL="https://raw.githubusercontent.com/${GITHUB_USER}/alrelshopv4/main"

# Download main installer
echo -e "\e[32mDownloading main installer...\e[0m"
wget -O alrelshop-main.sh "${REPO_URL}/alrelshop-installer.sh"
if [ ! -f "alrelshop-main.sh" ]; then
    echo -e "\e[31mFailed to download installer. Please check your internet connection.\e[0m"
    exit 1
fi

chmod +x alrelshop-main.sh
clear

# Execute main installer
echo -e "\e[32mStarting AlrelShop VPN installation...\e[0m"
sleep 2
./alrelshop-main.sh

# Cleanup
rm -f alrelshop-main.sh
rm -f install.sh
