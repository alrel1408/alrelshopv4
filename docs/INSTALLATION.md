# Panduan Instalasi AlrelShop VPN Server

## Persyaratan Sistem

### Sistem Operasi yang Didukung
- **Ubuntu**: 18.04, 20.04, 22.04, 24.04, 25.04
- **Debian**: 9, 10, 11, 12

### Spesifikasi Minimum
- **RAM**: 512 MB (Rekomendasi: 1 GB+)
- **Storage**: 5 GB free space
- **Bandwidth**: Unlimited/Unmetered
- **Arsitektur**: x86_64
- **Network**: IPv4 public IP

## Langkah Instalasi

### 1. Instalasi Script

> **Note**: Tidak perlu update/upgrade manual! Script sudah otomatis melakukan semua persiapan sistem yang diperlukan.
```bash
# Download dan jalankan installer
wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/install.sh && chmod +x install.sh && ./install.sh
```

### 2. Konfigurasi Domain

#### Option A: Custom Domain
1. Pointing domain ke IP VPS Anda
2. Tunggu propagasi DNS (5-60 menit)
3. Pilih option 1 saat instalasi
4. Masukkan domain Anda

#### Option B: Random Subdomain
1. Pilih option 2 saat instalasi
2. Script akan generate subdomain otomatis
3. Format: `xxx.alrelshop.my.id`

### 3. Proses Instalasi
- Proses instalasi memakan waktu 5-10 menit
- Jangan tutup terminal selama proses
- VPS akan restart otomatis setelah selesai

### 4. Setelah Instalasi
```bash
# Setelah restart, login kembali
# Menu akan muncul otomatis atau ketik:
menu
```

## Konfigurasi Lanjutan

### SSL Certificate
Script akan otomatis install SSL certificate menggunakan Let's Encrypt.

### Firewall Rules
Port yang dibuka otomatis:
- SSH: 22, 2222, 2223
- HTTP: 80, 8880
- HTTPS: 443, 8443
- OpenVPN: 1194
- Stunnel: 444, 445, 447, 777

### Services yang Terinstall
- **Xray Core**: Latest version
- **Nginx**: Web server
- **HAProxy**: Load balancer
- **Dropbear**: SSH server
- **OpenVPN**: VPN server
- **WebSocket Proxy**: Custom tunneling

## Troubleshooting

### Menu Tidak Muncul
```bash
# Cek instalasi menu
ls -la /usr/local/sbin/menu

# Buat symlink jika perlu
ln -sf /usr/local/sbin/menu /usr/bin/menu

# Update PATH
export PATH="/usr/local/sbin:$PATH"
```

### Service Tidak Jalan
```bash
# Cek status service
systemctl status nginx xray haproxy dropbear

# Restart service yang bermasalah
systemctl restart [service-name]

# Cek log error
journalctl -u [service-name] --no-pager
```

### SSL Certificate Error
```bash
# Regenerate SSL certificate
systemctl stop nginx
/root/.acme.sh/acme.sh --issue -d yourdomain.com --standalone -k ec-256
systemctl start nginx
```

### Port Blocked
```bash
# Cek iptables rules
iptables -L -n

# Reset iptables jika perlu
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
```

## Update Script

```bash
# Download dan jalankan update
wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/update.sh && chmod +x update.sh && ./update.sh
```

## Uninstall

```bash
# Backup data penting terlebih dahulu
# Hapus script dan konfigurasi
rm -rf /usr/local/sbin/*
rm -rf /etc/xray
rm -rf /etc/v2ray
systemctl disable nginx xray haproxy dropbear
```

## Support

Jika mengalami masalah:
- **Telegram**: [@alrelshop](https://t.me/alrelshop)
- **WhatsApp**: [+62 822-8585-1668](https://wa.me/6282285851668)
- **Email**: support@alrelshop.my.id
