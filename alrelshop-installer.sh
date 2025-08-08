#!/bin/bash

# AlrelShop VPN Server Main Installer
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

# Variables
MYIP=$(curl -sS ipv4.icanhazip.com)
GITHUB_USER="alrel1408"
REPO="https://raw.githubusercontent.com/${GITHUB_USER}/alrelshopv4/main/"

echo -e "\e[32mLoading AlrelShop installer...\e[0m"
clear

# Install basic tools
apt install ruby -y >/dev/null 2>&1
gem install lolcat >/dev/null 2>&1
apt install wondershaper -y >/dev/null 2>&1
clear

# Timer
start=$(date +%s)
secs_to_human() {
    echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}

# Status Functions
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}

function print_install() {
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    echo -e "${YELLOW} » $1 ${FONT}"
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
        echo -e "${Green} » $1 berhasil dipasang"
        echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
        sleep 2
    fi
}

# Create Xray directory
print_install "Creating Xray Directory"
mkdir -p /etc/xray
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
mkdir -p /var/lib/alrelshop >/dev/null 2>&1

# Memory Information
while IFS=":" read -r a b; do
case $a in
    "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
    "Shmem") ((mem_used+=${b/kB}))  ;;
    "MemFree" | "Buffers" | "Cached" | "SReclaimable")
    mem_used="$((mem_used-=${b/kB}))"
;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))"
Ram_Total="$((mem_total / 1024))"
export tanggal=`date -d "0 days" +"%d-%m-%Y - %X"`
export OS_Name=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g')
export Kernel=$(uname -r)
export Arch=$(uname -m)
export IP=$(curl -s https://ipinfo.io/ip/)

# System Setup Function
function first_setup(){
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    print_success "Directory Xray"
    
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        echo "Setup Dependencies $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        OS_VERSION=$(cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/VERSION_ID//g')
        sudo apt update -y
        apt-get install --no-install-recommends software-properties-common -y
        
        # Updated HAProxy installation for Ubuntu
        if [[ $OS_VERSION == "22.04" ]] || [[ $OS_VERSION == "24.04" ]] || [[ $OS_VERSION == "25.04" ]]; then
            apt-get -y install haproxy
        elif [[ $OS_VERSION == "18.04" ]] || [[ $OS_VERSION == "20.04" ]]; then
            add-apt-repository ppa:vbernat/haproxy-2.0 -y
            apt-get -y install haproxy=2.0.\*
        else
            apt-get -y install haproxy
        fi
        
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        echo "Setup Dependencies For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        OS_VERSION=$(cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/VERSION_ID//g')
        
        # Updated HAProxy for Debian
        if [[ $OS_VERSION == "11" ]] || [[ $OS_VERSION == "12" ]]; then
            sudo apt-get update
            apt-get -y install haproxy
        elif [[ $OS_VERSION == "9" ]] || [[ $OS_VERSION == "10" ]]; then
            curl https://haproxy.debian.net/bernat.debian.org.gpg |
                gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
            echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
                http://haproxy.debian.net buster-backports-1.8 main \
                >/etc/apt/sources.list.d/haproxy.list
            sudo apt-get update
            apt-get -y install haproxy=1.8.\*
        else
            sudo apt-get update
            apt-get -y install haproxy
        fi
    else
        echo -e " Your OS Is Not Supported ($(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g') )"
        exit 1
    fi
}

# Nginx Installation
function nginx_install() {
    clear
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        sudo apt-get install nginx -y 
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt -y install nginx 
    else
        echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
    fi
}

# Base Package Installation (Updated for newer systems)
function base_package() {
    clear
    print_install "Installing Required Packages"
    
    # Updated package list compatible with newer OS
    apt install zip pwgen openssl netcat-openbsd socat cron bash-completion -y
    apt install figlet -y
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y
    
    # Improved time synchronization
    if command -v chronyd >/dev/null 2>&1; then
        systemctl enable chronyd >/dev/null 2>&1 || true
        systemctl restart chronyd >/dev/null 2>&1 || true
        chronyc sourcestats -v >/dev/null 2>&1 || true
        chronyc tracking -v >/dev/null 2>&1 || true
    elif command -v chrony >/dev/null 2>&1; then
        systemctl enable chrony >/dev/null 2>&1 || true
        systemctl restart chrony >/dev/null 2>&1 || true
    else
        systemctl enable systemd-timesyncd >/dev/null 2>&1 || true
        systemctl start systemd-timesyncd >/dev/null 2>&1 || true
    fi
    
    apt install ntpdate -y
    ntpdate pool.ntp.org
    apt install sudo -y
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get install -y debconf-utils
    sudo apt-get remove --purge exim4 -y
    sudo apt-get remove --purge ufw firewalld -y
    sudo apt-get install -y --no-install-recommends software-properties-common
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    
    # Complete package installation
    sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev \
    libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools \
    libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr \
    libxml-parser-perl build-essential gcc g++ python3 htop lsof psmisc tar wget curl ruby zip \
    unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates \
    bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates \
    gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils \
    apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
    
    systemctl enable netfilter-persistent >/dev/null 2>&1 || true
    systemctl start netfilter-persistent >/dev/null 2>&1 || true
    print_success "Required Packages"
}

# Domain Setup Function (Updated with AlrelShop domain)
function setup_domain() {
    clear
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " \e[1;32mPlease Select a Domain Type Below \e[0m"
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " \e[1;32m1)\e[0m Use Custom Domain (Recommended)"
    echo -e " \e[1;32m2)\e[0m Use Random Subdomain (xxx.alrelshop.my.id)"
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p " Please select numbers 1-2: " domain_choice
    echo ""
    
    if [[ $domain_choice == "1" ]]; then
        echo -e " \e[1;32mPlease Enter Your Custom Domain${NC}"
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e ""
        read -p " Enter Domain: " custom_domain
        echo -e ""
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "IP=" >> /var/lib/alrelshop/ipvps.conf
        echo $custom_domain > /etc/xray/domain
        echo $custom_domain > /root/domain
        echo "Domain set to: $custom_domain"
        echo ""
    elif [[ $domain_choice == "2" ]]; then
        echo -e " \e[1;32mGenerating Random Subdomain...${NC}"
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Generate random string for subdomain
        random_string=$(openssl rand -hex 4)
        random_domain="${random_string}.alrelshop.my.id"
        
        echo "IP=" >> /var/lib/alrelshop/ipvps.conf
        echo $random_domain > /etc/xray/domain
        echo $random_domain > /root/domain
        
        echo -e ""
        echo -e " Random domain generated: ${green}$random_domain${NC}"
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    else
        echo -e "${ERROR} Invalid choice. Using random subdomain..."
        random_string=$(openssl rand -hex 4)
        random_domain="${random_string}.alrelshop.my.id"
        echo "IP=" >> /var/lib/alrelshop/ipvps.conf
        echo $random_domain > /etc/xray/domain
        echo $random_domain > /root/domain
        echo "Domain set to: $random_domain"
    fi
}

# SSL Installation
function install_ssl() {
    clear
    print_install "Installing SSL Certificate"
    rm -rf /etc/xray/xray.key
    rm -rf /etc/xray/xray.crt
    domain=$(cat /root/domain)
    
    rm -rf /root/.acme.sh
    mkdir -p /root/.acme.sh
    
    # Stop services using port 80
    systemctl stop nginx >/dev/null 2>&1 || true
    systemctl stop apache2 >/dev/null 2>&1 || true
    fuser -k 80/tcp >/dev/null 2>&1 || true
    
    # ACME installation
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    chmod 777 /etc/xray/xray.key
    print_success "SSL Certificate"
}

# Create folder structure
function make_folder_xray() {
    rm -rf /etc/vmess/.vmess.db
    rm -rf /etc/vless/.vless.db
    rm -rf /etc/trojan/.trojan.db
    rm -rf /etc/shadowsocks/.shadowsocks.db
    rm -rf /etc/ssh/.ssh.db
    
    mkdir -p /etc/xray
    mkdir -p /etc/vmess
    mkdir -p /etc/vless
    mkdir -p /etc/trojan
    mkdir -p /etc/shadowsocks
    mkdir -p /etc/ssh
    mkdir -p /usr/bin/xray/
    mkdir -p /var/log/xray/
    mkdir -p /var/www/html
    mkdir -p /etc/alrelshop/limit/vmess/ip
    mkdir -p /etc/alrelshop/limit/vless/ip
    mkdir -p /etc/alrelshop/limit/trojan/ip
    mkdir -p /etc/alrelshop/limit/ssh/ip
    mkdir -p /etc/limit/vmess
    mkdir -p /etc/limit/vless
    mkdir -p /etc/limit/trojan
    mkdir -p /etc/limit/ssh
    mkdir -p /etc/user-create
    
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    touch /etc/vmess/.vmess.db
    touch /etc/vless/.vless.db
    touch /etc/trojan/.trojan.db
    touch /etc/shadowsocks/.shadowsocks.db
    touch /etc/ssh/.ssh.db
    
    echo "& AlrelShop Account" >>/etc/vmess/.vmess.db
    echo "& AlrelShop Account" >>/etc/vless/.vless.db
    echo "& AlrelShop Account" >>/etc/trojan/.trojan.db
    echo "& AlrelShop Account" >>/etc/shadowsocks/.shadowsocks.db
    echo "& AlrelShop Account" >>/etc/ssh/.ssh.db
    echo "echo -e 'AlrelShop VPS Config User Account'" >> /etc/user-create/user.log
}

# Install Xray Core
function install_xray() {
    clear
    print_install "Core Xray Latest Version"
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    # Get latest Xray version
    latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version

    # Download configurations with fallback
    wget -O /etc/xray/config.json "${REPO}config/config.json" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}files/runn.service" >/dev/null 2>&1
    chmod 644 /etc/systemd/system/runn.service
    
    domain=$(cat /etc/xray/domain)
    IPVS=$(cat /etc/xray/ipvps)
    print_success "Core Xray Latest Version"
    
    # Setup configurations
    clear
    curl -s ipinfo.io/city >>/etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
    print_install "Installing Package Configuration"
    
    # Download configs with fallback sources
    wget -O /etc/haproxy/haproxy.cfg "${REPO}config/haproxy.cfg" >/dev/null 2>&1
    wget -O /etc/nginx/conf.d/xray.conf "${REPO}config/xray.conf" >/dev/null 2>&1
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
    
    curl ${REPO}config/nginx.conf > /etc/nginx/nginx.conf

    # HAProxy setup
    mkdir -p /etc/haproxy
    mkdir -p /run/haproxy
    
    if [ -f /etc/xray/xray.crt ] && [ -f /etc/xray/xray.key ]; then
        cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem
        chmod 600 /etc/haproxy/hap.pem
    else
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/haproxy/hap.key \
            -out /etc/haproxy/hap.crt \
            -subj "/C=ID/ST=Jakarta/L=Jakarta/O=AlrelShop/CN=${domain}" >/dev/null 2>&1
        cat /etc/haproxy/hap.crt /etc/haproxy/hap.key > /etc/haproxy/hap.pem
        chmod 600 /etc/haproxy/hap.pem
    fi

    # Create haproxy user if not exists
    if ! id -u haproxy >/dev/null 2>&1; then
        useradd -r -s /bin/false haproxy
    fi

    mkdir -p /var/lib/haproxy
    chown haproxy:haproxy /var/lib/haproxy

    # Create Xray service
    cat >/etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF

    chmod 644 /etc/systemd/system/xray.service
    systemctl daemon-reload
    nginx -t >/dev/null 2>&1 || echo "Warning: nginx config test failed"
    print_success "Package Configuration"
}

# SSH Setup (continued in additional functions)
function setup_ssh(){
    clear
    print_install "Installing SSH Configuration"
    
    # Download SSH password config
    wget -O /etc/pam.d/common-password "${REPO}files/password" >/dev/null 2>&1
    chmod +x /etc/pam.d/common-password

    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration

    cd

    # Create rc-local service
    cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

    # Create rc.local
    cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

    chmod +x /etc/rc.local
    systemctl enable rc-local
    systemctl start rc-local.service

    # Disable IPv6
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

    # Set timezone
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

    # SSH configuration
    sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
    
    # Ensure SSH port access
    iptables -I INPUT -p tcp --dport 22 -j ACCEPT
    iptables -I INPUT -p tcp --dport 2222 -j ACCEPT
    iptables -I INPUT -p tcp --dport 2223 -j ACCEPT
    iptables-save > /etc/iptables.up.rules
    netfilter-persistent save >/dev/null 2>&1 || true
    
    print_success "SSH Configuration"
}

# Install WebSocket Proxy
function install_websocket_proxy(){
    print_install "Installing WebSocket Proxy"
    
    # Create WebSocket proxy script
    cat > /usr/bin/ws << 'EOF'
#!/bin/bash
# WebSocket Proxy Alternative using socat
if [ "$1" = "-f" ] && [ -f "$2" ]; then
    echo "Starting WebSocket proxy with config: $2"
    
    # Read config and start proxy using socat
    while IFS= read -r line; do
        if [[ $line =~ listen_port:\ ([0-9]+) ]]; then
            LISTEN_PORT="${BASH_REMATCH[1]}"
        elif [[ $line =~ target_port:\ ([0-9]+) ]]; then
            TARGET_PORT="${BASH_REMATCH[1]}"
            if [ ! -z "$LISTEN_PORT" ] && [ ! -z "$TARGET_PORT" ]; then
                echo "Proxying port $LISTEN_PORT -> $TARGET_PORT"
                socat TCP4-LISTEN:$LISTEN_PORT,reuseaddr,fork TCP4:127.0.0.1:$TARGET_PORT &
                LISTEN_PORT=""
                TARGET_PORT=""
            fi
        fi
    done < "$2"
    wait
else
    echo "Usage: ws -f <config_file>"
    exit 1
fi
EOF
    
    chmod +x /usr/bin/ws
    
    # Create tun.conf configuration
    wget -q -O /usr/bin/tun.conf "${REPO}config/tun.conf" || cat > /usr/bin/tun.conf << 'EOF'
verbose: 0
listen:
- target_host: 127.0.0.1
  target_port: 22
  listen_port: 10015
- target_host: 127.0.0.1
  target_port: 1194
  listen_port: 10012
EOF
    
    # Create WebSocket service
    wget -q -O /etc/systemd/system/ws.service "${REPO}files/ws.service" || cat > /etc/systemd/system/ws.service << 'EOF'
[Unit]
Description=WebSocket ePro Proxy
Documentation=https://github.com/jaka1m
After=syslog.target network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/ws -f /usr/bin/tun.conf
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    chmod 644 /etc/systemd/system/ws.service
    systemctl daemon-reload
    systemctl enable ws >/dev/null 2>&1 || true
    
    print_success "WebSocket Proxy"
}

# Install additional services (Dropbear, OpenVPN, etc.)
function install_additional_services(){
    clear
    print_install "Installing Additional Services"
    
    # Install Dropbear
    apt-get install dropbear -y > /dev/null 2>&1
    mkdir -p /etc/dropbear
    
    # Generate dropbear keys if not exist
    if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
        dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key -s 2048 >/dev/null 2>&1
    fi
    if [ ! -f /etc/dropbear/dropbear_dss_host_key ]; then
        dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key >/dev/null 2>&1
    fi
    if [ ! -f /etc/dropbear/dropbear_ecdsa_host_key ]; then
        dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key >/dev/null 2>&1
    fi
    
    chmod 600 /etc/dropbear/dropbear_*_host_key 2>/dev/null || true
    
    wget -q -O /etc/default/dropbear "${REPO}config/dropbear.conf"
    wget -q -O /etc/issue.net "${REPO}files/issue.net"
    chmod 644 /etc/default/dropbear
    
    # Create banner file if not exists
    if [ ! -f /etc/kyt.txt ]; then
        echo "Welcome to AlrelShop VPS Server" > /etc/kyt.txt
        chmod 644 /etc/kyt.txt
    fi

    echo "/bin/false" >> /etc/shells 2>/dev/null || true
    echo "/usr/sbin/nologin" >> /etc/shells 2>/dev/null || true

    systemctl stop dropbear >/dev/null 2>&1 || true
    sleep 2
    systemctl start dropbear >/dev/null 2>&1 || /etc/init.d/dropbear start >/dev/null 2>&1 || true

    # Install VNStat
    apt -y install vnstat > /dev/null 2>&1
    /etc/init.d/vnstat restart
    
    # Install WebSocket Proxy
    install_websocket_proxy
    
    # Install OpenVPN
    apt install openvpn easy-rsa unzip -y >/dev/null 2>&1
    wget ${REPO}files/openvpn >/dev/null 2>&1 &&  chmod +x openvpn && ./openvpn

    print_success "Additional Services"
}

# Menu Installation (Updated with AlrelShop branding)
function install_menu(){
    clear
    print_install "Installing AlrelShop Management Panel"
    
    # Download menu
    wget -O menu.zip ${REPO}menu/menu.zip >/dev/null 2>&1
    
    if [ ! -s menu.zip ]; then
        echo -e "${RED}Failed to download menu.zip${NC}"
        return 1
    fi
    
    unzip -o menu.zip >/dev/null 2>&1 || unzip menu.zip
    chmod +x menu/*
    mkdir -p /usr/local/sbin
    mv menu/* /usr/local/sbin
    rm -rf menu menu.zip
    
    # Update branding to AlrelShop (remove toxic words)
    find /usr/local/sbin -type f -exec sed -i 's/memek//g; s/tembem//g; s/kontol//g; s/anjing//g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's/Vallstore/AlrelShop/g; s/VALLSTORE/ALRELSHOP/g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's/082300115583/082285851668/g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's/+6282300115583/+6282285851668/g' {} \;
    
    # Disable registration system completely
    find /usr/local/sbin -type f -exec sed -i 's|https://raw.githubusercontent.com/alrel1408/AutoScript/main/Register|# Register system disabled|g' {} \;
    find /usr/local/sbin -type f -exec sed -i 's|https://raw.githubusercontent.com/alrel1408/scriptaku/main/Register|# Register system disabled|g' {} \;
    find /usr/local/sbin -type f -exec sed -i '/checking_sc() {/,/^}/c\
checking_sc() {\
  # Register system disabled - always allow\
  return 0\
}' {} \;
    
    # Setup PATH
    if ! grep -q "/usr/local/sbin" /etc/environment; then
        echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/environment
    fi
    
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    
    # Create symlinks
    if [ -f /usr/local/sbin/menu ]; then
      ln -sf /usr/local/sbin/menu /usr/bin/menu
      ln -sf /usr/local/sbin/menu /bin/menu
    fi
    
    chmod +x /usr/local/sbin/menu 2>/dev/null || true
    
    # Update bash profiles
    grep -q 'export PATH="/usr/local/sbin:$PATH"' /etc/bash.bashrc || echo 'export PATH="/usr/local/sbin:$PATH"' >> /etc/bash.bashrc
    grep -q 'export PATH="/usr/local/sbin:$PATH"' /etc/profile || echo 'export PATH="/usr/local/sbin:$PATH"' >> /etc/profile
    
    print_success "AlrelShop Management Panel"
}

# Auto-Menu Profile Setup
function setup_auto_menu(){
    clear
    print_install "Setting Up Auto-Menu System"
    
    # Create profile for auto-menu
    cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "\$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi

# Set PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
mesg n || true

# Auto-run menu on SSH login
if [ -t 0 ] && [ "\$SSH_CONNECTION" ]; then
    clear
    echo -e "\033[1;32m"
    echo "════════════════════════════════════════"
    echo "    Welcome to AlrelShop VPN Server"
    echo "════════════════════════════════════════"
    echo -e "\033[0m"
    sleep 1
    menu
fi
EOF

    # Create bashrc
    cat >/root/.bashrc <<EOF
# ~/.bashrc: executed by bash for non-login shells.
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Auto run menu on interactive login with SSH
if [ -t 0 ] && [ "\$PS1" ] && [ "\$SSH_CONNECTION" ]; then
    clear
    menu
fi
EOF

    # Create aliases
    cat >/root/.bash_aliases <<EOF
# AlrelShop VPN Management Aliases
alias menu='/usr/local/sbin/menu'
alias m='menu'
alias panel='menu'
alias alrelshop='menu'
EOF

    # Copy to skeleton
    cp /root/.bashrc /etc/skel/.bashrc
    cp /root/.bash_aliases /etc/skel/.bash_aliases
    cp /root/.profile /etc/skel/.profile
    
    chmod 644 /root/.profile

    # Create cron jobs
    cat >/etc/cron.d/xp_all <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
END

    cat >/etc/cron.d/logclean <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/20 * * * * root /usr/local/sbin/clearlog
END

    service cron restart
    
    print_success "Auto-Menu System"
}

# Service Management
function enable_services(){
    clear
    print_install "Enabling Services"
    
    systemctl daemon-reload
    
    # Stop conflicting services
    systemctl stop apache2 >/dev/null 2>&1 || true
    
    # Install netfilter-persistent if not exists
    if ! systemctl list-unit-files | grep -q netfilter-persistent; then
        apt-get install -y iptables-persistent netfilter-persistent >/dev/null 2>&1
    fi
    
    # Unmask services
    systemctl unmask nginx >/dev/null 2>&1 || true
    systemctl unmask xray >/dev/null 2>&1 || true
    systemctl unmask haproxy >/dev/null 2>&1 || true
    
    systemctl daemon-reload
    
    # Enable services
    systemctl enable rc-local >/dev/null 2>&1 || true
    systemctl enable cron >/dev/null 2>&1 || true
    systemctl enable netfilter-persistent >/dev/null 2>&1 || true
    systemctl enable nginx >/dev/null 2>&1 || true
    systemctl enable haproxy >/dev/null 2>&1 || true
    systemctl enable xray >/dev/null 2>&1 || true
    systemctl enable ws >/dev/null 2>&1 || true
    
    # Handle dropbear
    if command -v dropbear >/dev/null 2>&1; then
        update-rc.d dropbear enable >/dev/null 2>&1 || true
    fi
    
    # Start services
    systemctl start rc-local >/dev/null 2>&1 || true
    systemctl start cron >/dev/null 2>&1 || true
    systemctl start netfilter-persistent >/dev/null 2>&1 || true
    systemctl start nginx >/dev/null 2>&1 || true
    systemctl start haproxy >/dev/null 2>&1 || true
    systemctl start xray >/dev/null 2>&1 || true
    systemctl start ws >/dev/null 2>&1 || true
    
    # Start dropbear
    if command -v dropbear >/dev/null 2>&1; then
        service dropbear start >/dev/null 2>&1 || true
    fi
    
    print_success "Services Enabled"
}

# Final notification and reboot
function final_notification(){
    clear
    
    # USERNAME DEFAULT
    echo "alrelshop" >/usr/bin/user
    echo "2099-12-31" >/usr/bin/e
    
    # DETAIL ORDER
    username=$(cat /usr/bin/user)
    exp=$(cat /usr/bin/e)
    
    # VPS Information
    DATE=$(date +'%Y-%m-%d')
    ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
    domain=$(cat /etc/xray/domain)
    TIMES="10"
    CHATID="6735684125"
    KEY="YOUR_TELEGRAM_BOT_TOKEN"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    TIMEZONE=$(printf '%(%H:%M:%S)T')
    
    TEXT="
<code>━━━━━━━━━━━━━━━━━━━━━━━━━</code>
<b>ALRELSHOP VPN SERVER</b>
<code>━━━━━━━━━━━━━━━━━━━━━━━━━</code>
<code>User     :</code><code>$username</code>
<code>Domain   :</code><code>$domain</code>
<code>IPVPS    :</code><code>$MYIP</code>
<code>ISP      :</code><code>$ISP</code>
<code>DATE     :</code><code>$DATE</code>
<code>Time     :</code><code>$TIMEZONE</code>
<code>Exp Sc.  :</code><code>$exp</code>
<code>━━━━━━━━━━━━━━━━━━━━━━━━━</code>
<b>ALRELSHOP VPN</b>
<code>━━━━━━━━━━━━━━━━━━━━━━━━━</code>
<i>Auto Installation Notification</i>
"'&reply_markup={"inline_keyboard":[[{"text":"ᴄᴏɴᴛᴀᴄᴛ","url":"https://wa.me/+6282285851668"}]]}'

    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
    
    # Test menu availability
    echo ""
    echo "Testing menu installation..."
    if command -v menu >/dev/null 2>&1; then
        echo -e "${green}✓ Menu command is available${NC}"
    else
        echo -e "${red}✗ Menu command not found, creating additional symlinks...${NC}"
        ln -sf /usr/local/sbin/menu /usr/bin/menu 2>/dev/null || true
        ln -sf /usr/local/sbin/menu /bin/menu 2>/dev/null || true
    fi
    
    source /etc/profile 2>/dev/null || true
    hash -r 2>/dev/null || true
    
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "   ${green}🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""
    echo -e " ${green}✓${NC} AlrelShop VPN Server successfully installed"
    echo -e " ${green}✓${NC} Domain: $(cat /etc/xray/domain)"
    echo -e " ${green}✓${NC} IP Address: $MYIP"
    echo -e " ${green}✓${NC} Auto-menu system configured"
    echo -e " ${green}✓${NC} Registration system disabled"
    echo -e " ${green}✓${NC} All services configured"
    echo -e ""
    echo -e " ${YELLOW}INSTALLATION TIME:${NC}"
    secs_to_human "$(($(date +%s) - ${start}))"
    echo -e ""
    echo -e " ${YELLOW}IMPORTANT NOTES:${NC}"
    echo -e " - After reboot, type ${YELLOW}'menu'${NC} to access control panel"
    echo -e " - Menu will automatically appear when you SSH login"
    echo -e " - All services will start automatically"
    echo -e " - No registration or IP limit restrictions"
    echo -e ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""
    echo -e "${GREEN}System will reboot now to complete installation...${NC}"
    echo -e ""
    read -p "$(echo -e "${CYAN}Press Enter to reboot now, or Ctrl+C to cancel: ${NC}")"
    echo -e ""
    echo -e "${YELLOW}Rebooting system in 3 seconds...${NC}"
    sleep 3
    reboot
}

# Main Installation Function
function main_install(){
    clear
    first_setup
    nginx_install
    base_package
    make_folder_xray
    setup_domain
    install_ssl
    install_xray
    setup_ssh
    install_additional_services
    install_menu
    setup_auto_menu
    enable_services
    
    # Cleanup
    history -c
    rm -rf /root/menu
    rm -rf /root/*.zip
    rm -rf /root/*.sh
    rm -rf /root/LICENSE
    rm -rf /root/README.md
    rm -rf /root/domain
    echo "unset HISTFILE" >> /etc/profile
    
    # Set hostname
    sudo hostnamectl set-hostname alrelshop
    
    final_notification
}

# Execute main installation
main_install
