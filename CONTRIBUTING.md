# Contributing to AlrelShop VPN Script

Terima kasih atas minat Anda untuk berkontribusi pada AlrelShop VPN Script! 

## 🤝 Cara Berkontribusi

### 1. Fork Repository
- Fork repository ini ke akun GitHub Anda
- Clone fork tersebut ke local machine
- Setup upstream remote

```bash
git clone https://github.com/yourusername/alrelshop-script.git
cd alrelshop-script
git remote add upstream https://github.com/originalusername/alrelshop-script.git
```

### 2. Buat Branch Baru
```bash
git checkout -b feature/nama-fitur
# atau
git checkout -b fix/nama-bug
```

### 3. Commit Changes
```bash
git add .
git commit -m "feat: menambahkan fitur xyz"
# atau
git commit -m "fix: memperbaiki bug abc"
```

### 4. Push dan Create Pull Request
```bash
git push origin feature/nama-fitur
```

Kemudian buat Pull Request melalui GitHub interface.

## 📝 Commit Message Guidelines

Gunakan conventional commits:

- `feat:` untuk fitur baru
- `fix:` untuk bug fix
- `docs:` untuk dokumentasi
- `style:` untuk formatting
- `refactor:` untuk refactoring
- `test:` untuk testing
- `chore:` untuk maintenance

Contoh:
```
feat: add support for Ubuntu 25.04
fix: resolve SSL certificate installation issue
docs: update installation guide
```

## 🧪 Testing

Sebelum submit PR, pastikan:

1. **Test pada OS yang didukung**
   - Ubuntu 22.04/24.04/25.04
   - Debian 11/12

2. **Test scenario**
   - Fresh installation
   - Update dari versi lama
   - Domain custom dan random
   - Semua service berjalan normal

3. **Code quality**
   - Script dapat dijalankan tanpa error
   - Tidak ada hardcoded values
   - Proper error handling

## 📋 Pull Request Guidelines

### Checklist sebelum submit PR:
- [ ] Code sudah di-test pada minimal 2 OS yang berbeda
- [ ] Tidak ada breaking changes (kecuali major version)
- [ ] Dokumentasi sudah diupdate jika perlu
- [ ] Commit message mengikuti convention
- [ ] PR description menjelaskan perubahan dengan jelas

### Template PR Description:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Breaking change

## Testing
- [ ] Tested on Ubuntu 22.04
- [ ] Tested on Ubuntu 24.04
- [ ] Tested on Debian 11
- [ ] Tested on Debian 12

## Screenshots (if applicable)
Add screenshots here

## Additional Notes
Any additional information
```

## 🐛 Bug Reports

### Before submitting bug report:
1. Search existing issues
2. Test pada clean VPS
3. Kumpulkan informasi sistem

### Bug report template:
```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen

**Environment:**
- OS: [e.g. Ubuntu 22.04]
- VPS Provider: [e.g. DigitalOcean]
- Script Version: [e.g. 2025.1]

**Additional context**
Any other context about the problem
```

## 💡 Feature Requests

### Template feature request:
```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
Clear description of what you want to happen

**Describe alternatives you've considered**
Any alternative solutions or features

**Additional context**
Any other context or screenshots
```

## 🔧 Development Setup

### Prerequisites
- Linux environment (Ubuntu/Debian recommended)
- Basic shell scripting knowledge
- Git knowledge
- Text editor (VS Code recommended)

### Recommended VS Code Extensions
- Shell Script (bash)
- GitLens
- Markdown All in One

### Testing Environment
Recommended untuk testing:
- VirtualBox/VMware dengan fresh OS install
- Cloud VPS dengan snapshot capability
- Docker containers untuk quick testing

## 📖 Code Style Guidelines

### Shell Scripting Best Practices
1. **Use strict mode**
   ```bash
   set -euo pipefail
   ```

2. **Quote variables**
   ```bash
   echo "$variable"  # Good
   echo $variable    # Bad
   ```

3. **Check command success**
   ```bash
   if command -v nginx >/dev/null 2>&1; then
       echo "nginx installed"
   fi
   ```

4. **Use functions for repeated code**
   ```bash
   function print_status() {
       echo "[$(date)] $1"
   }
   ```

5. **Proper error handling**
   ```bash
   if ! wget -O file.txt "$URL"; then
       echo "Failed to download file"
       exit 1
   fi
   ```

### File Organization
- **config/**: Configuration files
- **files/**: Binary files, service files
- **docs/**: Documentation
- **menu/**: Menu system files
- **media/**: Alternative source files

## 🚀 Release Process

### Version Numbering
- Format: `YYYY.N` (e.g., 2025.1)
- Major changes: Increment N
- Minor changes: Use patch releases (2025.1.1)

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version numbers updated in scripts
- [ ] Create release tag
- [ ] Update README.md if needed

## 📞 Communication

### Channels
- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: General questions, ideas
- **Telegram**: [@alrelshop](https://t.me/alrelshop)
- **WhatsApp**: [+62 822-8585-1668](https://wa.me/6282285851668)

### Response Time
- Critical bugs: 24 hours
- Feature requests: 1 week
- Pull requests: 48 hours

## 🏆 Recognition

Contributors akan di-credit di:
- README.md contributors section
- CHANGELOG.md untuk specific contributions
- Release notes

## ❓ Questions?

Jika ada pertanyaan tentang contributing:
1. Check dokumentasi yang ada
2. Search existing issues/discussions
3. Contact melalui channel komunikasi

Terima kasih atas kontribusi Anda! 🎉
