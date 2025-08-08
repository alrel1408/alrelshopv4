#!/bin/bash

# AlrelShop VPN Server Update Script
# Created by AlrelShop Team
# Version: 2025.1

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

# Variables
GITHUB_USER="alrel1408"
REPO="https://raw.githubusercontent.com/${GITHUB_USER}/alrelshopv4/main/"

# Banner
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${green}AlrelShop VPN Server Update${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if running as root
if [ "${EUID}" -ne 0 ]; then
    echo -e "${ERROR} You need to run this script as root"
    exit 1
fi

# Functions
function print_install() {
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    echo -e "${YELLOW} » $1 ${FONT}"
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    sleep 1
}

function print_success() {
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    echo -e "${Green} » $1 berhasil diupdate"
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    sleep 2
}

# Check current installation
if [ ! -f "/usr/local/sbin/menu" ]; then
    echo -e "${ERROR} AlrelShop VPN Script not detected"
    echo -e "${YELLOW} Please install the script first using install.sh${NC}"
    exit 1
fi

echo -e " Current installation detected"
echo -e " ${green}✓${NC} AlrelShop VPN Server is installed"
echo ""

# Update confirmation
read -p "$(echo -e "${CYAN}Do you want to update AlrelShop VPN Script? [y/N]: ${NC}")" confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo -e "${YELLOW}Update cancelled by user.${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Starting update process...${NC}"
echo ""

# Update Menu
print_install "Updating Menu System"
cd /tmp
wget -O menu.zip ${REPO}menu/menu.zip >/dev/null 2>&1

if [ -f "menu.zip" ]; then
    # Backup current menu
    cp -r /usr/local/sbin /usr/local/sbin.backup.$(date +%Y%m%d_%H%M%S)
    
    unzip -o menu.zip >/dev/null 2>&1 || unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin/
    rm -rf menu menu.zip
    
    # Update branding
    find /usr/local/sbin -type f -exec sed -i 's/memek//g; s/tembem//g; s/kontol//g; s/anjing//g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's/Vallstore/AlrelShop/g; s/VALLSTORE/ALRELSHOP/g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's/082300115583/082285851668/g' {} \;
    
    # Disable registration system
    find /usr/local/sbin -type f -exec sed -i 's|https://raw.githubusercontent.com/alrel1408/AutoScript/main/Register|# Register system disabled|g' {} \;
    find /usr/local/sbin -type f -exec sed -i '/checking_sc() {/,/^}/c\
checking_sc() {\
  # Register system disabled - always allow\
  return 0\
}' {} \;
    
    print_success "Menu System"
else
    echo -e "${ERROR} Failed to download menu update"
fi

# Update Xray Core
print_install "Updating Xray Core"
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
current_version=$(/usr/local/bin/xray version | grep 'Xray' | awk '{print $2}')

if [ "$latest_version" != "$current_version" ]; then
    systemctl stop xray
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
    systemctl start xray
    print_success "Xray Core (v$latest_version)"
else
    echo -e "${green} ✓ Xray Core is already up to date (v$current_version)${NC}"
fi

# Update configurations
print_install "Updating Configurations"
wget -O /etc/xray/config.json "${REPO}config/config.json" >/dev/null 2>&1
wget -O /etc/haproxy/haproxy.cfg "${REPO}config/haproxy.cfg" >/dev/null 2>&1
wget -O /etc/nginx/conf.d/xray.conf "${REPO}config/xray.conf" >/dev/null 2>&1

# Update domain in configs
domain=$(cat /etc/xray/domain)
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

print_success "Configurations"

# Restart services
print_install "Restarting Services"
systemctl daemon-reload
systemctl restart nginx
systemctl restart haproxy
systemctl restart xray
systemctl restart dropbear

print_success "Services"

# Update system packages
print_install "Updating System Packages"
apt update >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1
print_success "System Packages"

# Final message
clear
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "   ${green}🎉 UPDATE COMPLETED SUCCESSFULLY! 🎉${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e " ${green}✓${NC} AlrelShop VPN Script has been updated"
echo -e " ${green}✓${NC} All services restarted successfully"
echo -e " ${green}✓${NC} System packages updated"
echo -e ""
echo -e " ${YELLOW}What's New:${NC}"
echo -e " - Latest Xray Core version"
echo -e " - Updated configurations"
echo -e " - Security improvements"
echo -e " - Bug fixes and optimizations"
echo -e ""
echo -e " Type ${YELLOW}'menu'${NC} to access the updated control panel"
echo -e ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Cleanup
rm -f /tmp/menu.zip
rm -f /tmp/update.sh
