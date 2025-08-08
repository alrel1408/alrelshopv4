# AlrelShop VPN Server Script

<p align="center">
<img src="https://readme-typing-svg.herokuapp.com?color=%2336BCF7&center=true&vCenter=true&lines=A+L+R+E+L+S+H+O+P++V+P+N++S+E+R+V+E+R" />
</p>

<p align="center">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/alrel1408/alrelshopv4">
  <img alt="GitHub" src="https://img.shields.io/github/license/alrel1408/alrelshopv4">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/alrel1408/alrelshopv4">
  <img alt="GitHub stars" src="https://img.shields.io/github/stars/alrel1408/alrelshopv4">
</p>

### 🚀 Script VPN Server Premium AlrelShop v2025

Script otomatis untuk instalasi VPN server lengkap dengan dukungan multi-protokol dan management panel terintegrasi.

## ⚡ Quick Installation

```bash
apt install -y && apt update -y && apt upgrade -y && wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/install.sh && chmod +x install.sh && ./install.sh
```

## 🖥️ Supported Operating Systems

| OS | Version | Status |
|---|---|---|
| Ubuntu | 18.04, 20.04, 22.04, 24.04, 25.04 | ✅ Fully Supported |
| Debian | 9, 10, 11, 12 | ✅ Fully Supported |

## 🔥 Key Features

### 🌐 **Multi-Protocol Support**
- **Xray Core** - Latest version dengan performa tinggi
- **V2Ray** - Vmess, Vless protocols
- **Trojan** - High-speed proxy protocol  
- **Shadowsocks** - Multiple cipher support
- **OpenVPN** - TCP & UDP modes
- **SSH Tunneling** - WebSocket & TLS support

### 🚀 **Advanced Features**
- **Auto Menu System** - Direct access setelah SSH login
- **Domain Options** - Custom domain atau random subdomain (xxx.alrelshop.my.id)
- **SSL Auto-Install** - Let's Encrypt integration
- **Load Balancer** - HAProxy untuk traffic distribution
- **Real-time Monitoring** - Bandwidth & system monitoring

### 🛡️ **Security & Performance**
- **Military-grade Encryption** - AES-256, ChaCha20-Poly1305
- **BBR Congestion Control** - Optimized network performance
- **Firewall Integration** - Auto iptables configuration
- **SSL/TLS Termination** - Modern security standards

## 📋 Installation Guide

### 1. **Persiapan VPS**
- Fresh VPS dengan OS yang didukung
- Minimal 512MB RAM (1GB+ recommended)
- 5GB+ free storage
- IPv4 public IP address

### 2. **One-Click Installation**
```bash
# Download and execute installer
wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/install.sh && chmod +x install.sh && ./install.sh
```

### 3. **Domain Configuration**
Script akan menanyakan pilihan domain:
- **Custom Domain**: Gunakan domain sendiri (recommended)
- **Random Subdomain**: Auto-generate xxx.alrelshop.my.id

### 4. **Post Installation**
Setelah VPS restart, login dan ketik `menu` untuk mengakses control panel.

## 🎯 Protocol Configuration

| Protocol | Port | Type | Usage |
|---|---|---|---|
| SSH WebSocket | 80, 8880 | TCP | Browser-based tunneling |
| SSH WebSocket TLS | 443, 8443 | TCP | Encrypted tunneling |
| V2Ray Vmess/Vless | 443, 8443, 80, 8880 | TCP | Modern proxy |
| Trojan | 443, 8443 | TCP | High-speed proxy |
| Shadowsocks | Various | TCP/UDP | Lightweight proxy |
| OpenVPN | 1194 | UDP/TCP | Traditional VPN |
| Stunnel4 | 444, 445, 447, 777 | TCP | SSL tunneling |

## 🎛️ Management Panel

Akses management panel dengan perintah `menu` setelah SSH login:

### 📊 **Main Features**
- **Account Management** - Create, delete, extend user accounts
- **Service Control** - Start, stop, restart services  
- **System Monitor** - Real-time resource monitoring
- **Bandwidth Tracking** - Per-user usage statistics
- **Backup/Restore** - Configuration backup tools
- **SSL Management** - Certificate management

### 👥 **Account Types**
- **SSH/OpenVPN** - Traditional VPN accounts
- **V2Ray/Xray** - Modern proxy accounts  
- **Trojan** - High-performance proxy
- **Shadowsocks** - Lightweight proxy

## 🔄 Update & Maintenance

### Update Script
```bash
wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/update.sh && chmod +x update.sh && ./update.sh
```

### Manual Service Management
```bash
# Check service status
systemctl status nginx xray haproxy dropbear

# Restart specific service
systemctl restart [service-name]

# View logs
journalctl -u [service-name] --no-pager
```

## 🛠️ Troubleshooting

### Common Issues

<details>
<summary>Menu tidak muncul setelah login</summary>

```bash
# Check menu installation
ls -la /usr/local/sbin/menu

# Create symlink if needed
ln -sf /usr/local/sbin/menu /usr/bin/menu

# Update PATH
export PATH="/usr/local/sbin:$PATH"
```
</details>

<details>
<summary>Service gagal start</summary>

```bash
# Check service status
systemctl status [service-name]

# View detailed logs
journalctl -u [service-name] --no-pager -l

# Restart service
systemctl restart [service-name]
```
</details>

<details>
<summary>SSL Certificate error</summary>

```bash
# Regenerate SSL certificate
systemctl stop nginx
/root/.acme.sh/acme.sh --issue -d yourdomain.com --standalone -k ec-256
systemctl start nginx
```
</details>

## 📖 Documentation

- 📚 [Installation Guide](docs/INSTALLATION.md)
- 🔥 [Features Overview](docs/FEATURES.md)
- 🤝 [Contributing Guide](CONTRIBUTING.md)
- 📝 [Changelog](CHANGELOG.md)

## 🔗 Quick Links

| Service | URL/Command |
|---|---|
| **Control Panel** | `menu` command |
| **SSL Certificate** | Auto-generated via Let's Encrypt |
| **Service Status** | `systemctl status nginx xray haproxy` |
| **Logs** | `journalctl -u [service]` |

## 💬 Support & Community

- 💬 **Telegram**: [@alrelshop](https://t.me/alrelshop)
- 📱 **WhatsApp**: [+62 822-8585-1668](https://wa.me/6282285851668)
- 🐛 **Issues**: [GitHub Issues](https://github.com/alrel1408/alrelshopv4/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/alrel1408/alrelshopv4/discussions)

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### 👨‍💻 Contributors

Thanks to all contributors who help improve this project!

<!-- Add contributor list here -->

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=alrel1408/alrelshopv4&type=Date)](https://star-history.com/#alrel1408/alrelshopv4&Date)

## 🚀 What's Next?

- [ ] Web-based management interface
- [ ] Mobile app for management
- [ ] API for automation
- [ ] Multi-server management
- [ ] Advanced analytics dashboard

---

<p align="center">
  <b>⚡ Powered by AlrelShop - Premium VPN Solutions</b><br>
  Made with ❤️ for the VPN community
</p>

<p align="center">
  <a href="#alrelshop-vpn-server-script">Back to Top ⬆️</a>
</p>