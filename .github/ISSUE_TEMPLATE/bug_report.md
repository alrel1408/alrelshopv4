---
name: Bug Report
about: Laporkan bug untuk membantu kami memperbaiki script
title: '[BUG] '
labels: bug
assignees: ''

---

**Describe the bug**
Penjelasan singkat dan jelas tentang bug yang terjadi.

**To Reproduce**
Langkah-langkah untuk reproduce bug:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
Penjelasan singkat dan jelas tentang apa yang seharusnya terjadi.

**Screenshots**
Jika applicable, tambahkan screenshots untuk membantu menjelaskan masalah.

**Environment (please complete the following information):**
 - OS: [e.g. Ubuntu 22.04]
 - VPS Provider: [e.g. DigitalOcean, Vultr]
 - Script Version: [e.g. 2025.1]
 - Installation Method: [Fresh install / Update from previous version]

**System Information**
```bash
# Jalankan command berikut dan paste outputnya:
cat /etc/os-release
uname -a
free -h
df -h
systemctl status nginx xray haproxy --no-pager
```

**Log Files**
```bash
# Jika ada error, paste log yang relevan:
journalctl -u xray --no-pager -l
journalctl -u nginx --no-pager -l
```

**Additional context**
Tambahkan context lain tentang masalah ini di sini.

**Checklist:**
- [ ] Saya sudah search existing issues
- [ ] Saya sudah test pada VPS yang clean
- [ ] Saya sudah coba restart semua services
- [ ] Saya sudah include semua informasi yang diminta
