# Changelog

All notable changes to AlrelShop VPN Script will be documented in this file.

## [2025.1] - 2025-01-08

### Added
- ✨ Support untuk Ubuntu 25.04 (latest LTS)
- ✨ Support untuk Debian 12 (Bookworm) 
- ✨ Domain randomization system (xxx.alrelshop.my.id)
- ✨ Auto-menu system setelah SSH login
- ✨ Konfirmasi sebelum instalasi dan reboot
- ✨ Update system untuk Xray Core terbaru
- ✨ Enhanced SSL certificate management
- ✨ Improved HAProxy configuration untuk OS terbaru

### Changed
- 🔄 Updated branding dari Vallstore ke AlrelShop
- 🔄 Removed semua kata-kata toxic dari script
- 🔄 Updated contact information ke WhatsApp AlrelShop
- 🔄 Improved package installation untuk compatibility dengan OS terbaru
- 🔄 Enhanced time synchronization untuk Debian 12
- 🔄 Updated HAProxy installation method untuk Ubuntu 22.04+

### Removed
- ❌ Sistem registrasi IP (disabled completely)
- ❌ Pembatasan akses berdasarkan IP
- ❌ Kata-kata tidak pantas dari interface
- ❌ Dependency pada repository lama yang sudah tidak aktif

### Fixed
- 🐛 SSL certificate generation untuk domain baru
- 🐛 Service startup issues pada Debian 12
- 🐛 HAProxy SSL configuration
- 🐛 Nginx configuration compatibility
- 🐛 Path issues untuk menu system
- 🐛 Time synchronization pada sistem modern

### Security
- 🔒 Improved SSH configuration security
- 🔒 Enhanced firewall rules
- 🔒 Better SSL/TLS configuration
- 🔒 Updated encryption standards

## [Legacy Versions]

### [1.0] - 2024
- Initial version berdasarkan Scriptaku
- Basic VPN server functionality
- Support Ubuntu 18.04, 20.04, Debian 9, 10
- Original Vallstore branding

---

## Planned Features (Roadmap)

### [2025.2] - Q2 2025
- [ ] Web-based management panel
- [ ] API untuk automasi
- [ ] Multi-server management
- [ ] Advanced bandwidth monitoring
- [ ] User quota management
- [ ] Telegram bot integration

### [2025.3] - Q3 2025
- [ ] Docker support
- [ ] Kubernetes deployment
- [ ] Cloud provider integration
- [ ] Auto-scaling capabilities
- [ ] Advanced analytics dashboard

### [2025.4] - Q4 2025
- [ ] Mobile app untuk management
- [ ] Advanced security features
- [ ] AI-powered optimization
- [ ] Global load balancing

---

## Version Naming Convention

Kami menggunakan format `YYYY.N` untuk penamaan versi:
- `YYYY`: Tahun rilis
- `N`: Nomor rilis dalam tahun tersebut

Contoh: `2025.1` = Rilis pertama di tahun 2025

## Support Lifecycle

- **Current Version**: Mendapat update security dan bug fixes
- **Previous Version**: Mendapat critical security updates saja
- **Legacy Versions**: Tidak mendapat update (deprecated)

Setiap major version didukung selama minimal 1 tahun setelah rilis.

## Migration Guide

### Dari Scriptaku ke AlrelShop 2025.1
1. Backup konfigurasi existing
2. Download script terbaru
3. Jalankan installer (akan detect existing installation)
4. Verify semua service berjalan normal
5. Update menu system

### Dari Version Lama AlrelShop
Gunakan script update.sh:
```bash
wget -q https://raw.githubusercontent.com/alrel1408/alrelshopv4/main/update.sh && chmod +x update.sh && ./update.sh
```

## Breaking Changes

### 2025.1
- **Registration System**: Completely removed
- **Menu Path**: Changed to `/usr/local/sbin/menu`
- **Config Location**: Some configs moved to `/etc/alrelshop/`
- **Service Names**: Some services renamed for consistency

## Bug Reports

Untuk melaporkan bug atau request fitur:
1. Check existing issues di GitHub
2. Buat issue baru dengan template yang disediakan
3. Sertakan informasi sistem dan log error
4. Follow up untuk additional information

## Contributing

Contributions welcome! Please read CONTRIBUTING.md untuk guidelines.

---

**Note**: Changelog ini mengikuti format [Keep a Changelog](https://keepachangelog.com/).

## Legend
- ✨ New feature
- 🔄 Changed/Updated  
- ❌ Removed
- 🐛 Bug fix
- 🔒 Security improvement
- 📚 Documentation
- 🎨 UI/UX improvement
- ⚡ Performance improvement
