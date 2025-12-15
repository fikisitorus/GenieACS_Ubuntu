# GenieACS Auto Installation Script

![GenieACS](https://img.shields.io/badge/GenieACS-Latest-blue)
![MongoDB](https://img.shields.io/badge/MongoDB-4.4-green)
![Node.js](https://img.shields.io/badge/Node.js-18.x-brightgreen)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%20%7C%2022.04-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)

Script instalasi otomatis untuk GenieACS (Generic Easy-to-use Auto Configuration Server) di Ubuntu dengan semua dependencies yang diperlukan.

**Created by: Fikri Sitorus**

---

## 📋 Daftar Isi

- [Tentang GenieACS](#tentang-genieacs)
- [Fitur Script](#fitur-script)
- [Requirements](#requirements)
- [Instalasi](#instalasi)
- [Penggunaan](#penggunaan)
- [Port yang Digunakan](#port-yang-digunakan)
- [Perintah Berguna](#perintah-berguna)
- [Troubleshooting](#troubleshooting)
- [Konfigurasi Lanjutan](#konfigurasi-lanjutan)
- [Uninstall](#uninstall)
- [FAQ](#faq)
- [Kontribusi](#kontribusi)
- [License](#license)

---

## 🎯 Tentang GenieACS

GenieACS adalah Auto Configuration Server (ACS) open-source yang mengimplementasikan protokol TR-069 untuk remote management perangkat CPE (Customer Premises Equipment) seperti:

- Router
- ONT/ONU
- IP Camera
- VoIP Gateway
- Set-top Box
- IoT Devices

### Keunggulan GenieACS:
- ✅ Open Source & Gratis
- ✅ High Performance (Node.js based)
- ✅ RESTful API
- ✅ Web-based UI
- ✅ Extensible dengan custom scripts
- ✅ Support untuk ribuan devices

---

## 🚀 Fitur Script

Script ini akan menginstall dan mengkonfigurasi secara otomatis:

1. **Node.js 18.x** - JavaScript runtime
2. **MongoDB 4.4** - Database server
3. **GenieACS** - ACS server dengan semua dependencies
4. **Essential Libraries**:
   - libssl-dev & libssl3 (OpenSSL)
   - build-essential (compiler tools)
   - curl, wget, git
   - ca-certificates
5. **Systemd Services** - Auto-start untuk semua komponen
6. **User & Permissions** - Setup user system yang aman

### Komponen GenieACS yang Diinstall:
- **CWMP** - TR-069 server
- **NBI** - Northbound Interface (REST API)
- **FS** - File Server untuk firmware updates
- **UI** - Web interface untuk management

---

## 💻 Requirements

### Sistem Operasi
- Ubuntu 20.04 LTS (Focal Fossa)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 18.04 LTS (Bionic Beaver) - *mungkin perlu adjustment*

### Hardware Minimal
- **CPU**: 2 cores
- **RAM**: 2 GB (4 GB recommended)
- **Disk**: 10 GB free space
- **Network**: Internet connection untuk download packages

### Software
- Root atau sudo access
- Fresh Ubuntu installation (recommended)

---

## 📥 Instalasi

### Metode 1: Download Langsung

```bash
# Download script
wget https://raw.githubusercontent.com/fikisitorus/GenieACS_Ubuntu/main/install-genieacs.sh

# Atau gunakan curl
curl -O https://raw.githubusercontent.com/fikisitorus/GenieACS_Ubuntu/main/install-genieacs.sh

# Berikan permission execute
chmod +x install-genieacs.sh

# Jalankan script
sudo ./install-genieacs.sh
```

### Metode 2: Clone Repository

```bash
# Clone repository
git clone https://github.com/fikisitorus/GenieACS_Ubuntu.git

# Masuk ke direktori
cd GenieACS_Ubuntu

# Berikan permission
chmod +x install-genieacs.sh

# Jalankan
sudo ./install-genieacs.sh
```

### Metode 3: One-liner Installation

```bash
curl -fsSL https://raw.githubusercontent.com/fikisitorus/GenieACS_Ubuntu/main/install-genieacs.sh | sudo bash
```

---

## 🎮 Penggunaan

### Menjalankan Script

```bash
sudo ./install-genieacs.sh
```

### Proses Instalasi

Script akan menjalankan 9 langkah:
1. Update system packages
2. Install essential libraries (libssl, build-tools)
3. Install Node.js 18.x
4. Install MongoDB 4.4
5. Install GenieACS
6. Create GenieACS user
7. Create directories
8. Create systemd services
9. Start all services

**Estimasi waktu**: 5-10 menit (tergantung koneksi internet)

### Output Instalasi

Setelah selesai, akan tampil:

```
========================================
Installation Complete!
========================================

Service Status:
CWMP: Running
NBI: Running
FS: Running
UI: Running

========================================
Access Information:
========================================
Web UI: http://192.168.1.100:3000
CWMP: http://192.168.1.100:7547
NBI (API): http://192.168.1.100:7557
FS: http://192.168.1.100:7567
```

---

## 🔌 Port yang Digunakan

| Service | Port | Protokol | Deskripsi |
|---------|------|----------|-----------|
| **UI** | 3000 | HTTP | Web Interface |
| **CWMP** | 7547 | HTTP/HTTPS | TR-069 ACS Endpoint |
| **NBI** | 7557 | HTTP | REST API |
| **FS** | 7567 | HTTP | File Server |
| **MongoDB** | 27017 | TCP | Database (localhost only) |

### Konfigurasi Firewall

Jika menggunakan firewall, buka port berikut:

```bash
# UFW Firewall
sudo ufw allow 3000/tcp   # Web UI
sudo ufw allow 7547/tcp   # CWMP
sudo ufw allow 7557/tcp   # NBI
sudo ufw allow 7567/tcp   # FS

# Atau buka semua sekaligus
sudo ufw allow 3000,7547,7557,7567/tcp
```

---

## 🛠️ Perintah Berguna

### Cek Status Services

```bash
# Semua services
sudo systemctl status genieacs-*

# Individual service
sudo systemctl status genieacs-cwmp
sudo systemctl status genieacs-nbi
sudo systemctl status genieacs-fs
sudo systemctl status genieacs-ui
```

### Start/Stop/Restart Services

```bash
# Start semua services
sudo systemctl start genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui

# Stop semua services
sudo systemctl stop genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui

# Restart semua services
sudo systemctl restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui

# Restart satu service
sudo systemctl restart genieacs-cwmp
```

### View Logs

```bash
# Realtime logs (follow mode)
sudo journalctl -u genieacs-cwmp -f
sudo journalctl -u genieacs-nbi -f
sudo journalctl -u genieacs-fs -f
sudo journalctl -u genieacs-ui -f

# Semua logs dari semua services
sudo journalctl -u 'genieacs-*' -f

# View 100 baris terakhir
sudo journalctl -u genieacs-cwmp -n 100

# View logs hari ini
sudo journalctl -u genieacs-cwmp --since today
```

### MongoDB Management

```bash
# Masuk MongoDB shell
mongosh

# Atau untuk MongoDB < 5.0
mongo

# Cek database GenieACS
use genieacs
show collections

# Backup database
mongodump --db genieacs --out /backup/mongodb/

# Restore database
mongorestore --db genieacs /backup/mongodb/genieacs/
```

### GenieACS CLI Commands

```bash
# Cek versi
genieacs-cwmp --version

# Node modules yang terinstall
npm list -g genieacs
```

---

## 🐛 Troubleshooting

### Services Tidak Berjalan

```bash
# Cek error detail
sudo journalctl -u genieacs-cwmp --no-pager -n 50

# Restart service
sudo systemctl restart genieacs-cwmp

# Cek port yang digunakan
sudo netstat -tulpn | grep 7547
```

### Port Already in Use

```bash
# Cek proses yang menggunakan port
sudo lsof -i :7547

# Kill proses
sudo kill -9 <PID>

# Restart service
sudo systemctl restart genieacs-cwmp
```

### MongoDB Connection Error

```bash
# Cek status MongoDB
sudo systemctl status mongod

# Start MongoDB
sudo systemctl start mongod

# Restart MongoDB
sudo systemctl restart mongod

# Cek logs MongoDB
sudo journalctl -u mongod -f
```

### Web UI Tidak Bisa Diakses

```bash
# Cek firewall
sudo ufw status

# Buka port 3000
sudo ufw allow 3000/tcp

# Cek apakah service running
sudo systemctl status genieacs-ui

# Cek listen port
sudo netstat -tulpn | grep 3000
```

### Permission Denied

```bash
# Fix ownership
sudo chown -R genieacs:genieacs /opt/genieacs

# Restart services
sudo systemctl restart genieacs-*
```

---

## ⚙️ Konfigurasi Lanjutan

### Environment Variables

Edit file service untuk menambah environment variables:

```bash
sudo nano /etc/systemd/system/genieacs-cwmp.service
```

Tambahkan di section `[Service]`:

```ini
Environment="GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/cwmp-access.log"
Environment="GENIEACS_CWMP_INTERFACE=0.0.0.0"
Environment="GENIEACS_CWMP_PORT=7547"
Environment="GENIEACS_CWMP_SSL=false"
```

Reload dan restart:

```bash
sudo systemctl daemon-reload
sudo systemctl restart genieacs-cwmp
```

### SSL/HTTPS Configuration

Untuk enable HTTPS:

```bash
# Generate self-signed certificate
sudo openssl req -new -x509 -days 365 -nodes \
  -out /opt/genieacs/cert.pem \
  -keyout /opt/genieacs/key.pem

# Update ownership
sudo chown genieacs:genieacs /opt/genieacs/*.pem

# Edit service file
sudo nano /etc/systemd/system/genieacs-cwmp.service
```

Tambahkan:

```ini
Environment="GENIEACS_CWMP_SSL=true"
Environment="GENIEACS_CWMP_SSL_CERT=/opt/genieacs/cert.pem"
Environment="GENIEACS_CWMP_SSL_KEY=/opt/genieacs/key.pem"
```

### Reverse Proxy dengan Nginx

```bash
# Install Nginx
sudo apt-get install -y nginx

# Konfigurasi
sudo nano /etc/nginx/sites-available/genieacs
```

Isi dengan:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /acs {
        proxy_pass http://localhost:7547;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable dan restart:

```bash
sudo ln -s /etc/nginx/sites-available/genieacs /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🗑️ Uninstall

### Uninstall Lengkap

```bash
# Stop dan disable services
sudo systemctl stop genieacs-*
sudo systemctl disable genieacs-*

# Remove systemd files
sudo rm /etc/systemd/system/genieacs-*.service
sudo systemctl daemon-reload

# Uninstall GenieACS
sudo npm uninstall -g genieacs

# Remove user dan direktori
sudo userdel genieacs
sudo rm -rf /opt/genieacs

# Remove MongoDB (optional)
sudo systemctl stop mongod
sudo apt-get purge -y mongodb-org*
sudo rm -rf /var/log/mongodb
sudo rm -rf /var/lib/mongodb

# Remove Node.js (optional)
sudo apt-get purge -y nodejs
sudo rm -rf /etc/apt/sources.list.d/nodesource.list
```

---

## ❓ FAQ

### Q: Apakah script ini aman digunakan di production?
**A:** Ya, script ini mengikuti best practices untuk production deployment. Namun, disarankan untuk melakukan review dan testing di staging environment terlebih dahulu.

### Q: Apakah bisa install di Ubuntu 18.04?
**A:** Kemungkinan bisa, tapi mungkin perlu adjustment pada repository MongoDB. Ubuntu 20.04 atau 22.04 lebih disarankan.

### Q: Kenapa menggunakan MongoDB 4.4 bukan versi terbaru?
**A:** MongoDB 4.4 lebih stabil dan kompatibel dengan GenieACS. Versi 4.4 juga masih mendapat support dan cocok untuk production.

### Q: Bagaimana cara backup data GenieACS?
**A:** Backup database MongoDB dengan `mongodump` dan backup direktori `/opt/genieacs/ext`.

### Q: Apakah bisa diinstall di VM atau container?
**A:** Ya, script ini kompatibel dengan VM (VirtualBox, VMware) dan container (Docker, LXC).

### Q: Bagaimana cara update GenieACS ke versi terbaru?
**A:** Jalankan `sudo npm update -g genieacs` kemudian restart services.

### Q: Device CPE tidak bisa connect ke ACS?
**A:** Pastikan:
- Port 7547 terbuka di firewall
- ACS URL di CPE sudah benar: `http://server-ip:7547`
- Network bisa reach dari CPE ke server

### Q: Berapa kapasitas maksimal devices yang bisa dihandle?
**A:** Tergantung hardware, tapi GenieACS bisa handle ribuan hingga puluhan ribu devices dengan hardware yang memadai.

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

### TODO List
- [ ] Support untuk Ubuntu 24.04
- [ ] Auto SSL dengan Let's Encrypt
- [ ] Docker version
- [ ] Backup/restore script
- [ ] Monitoring dashboard

---

## 📞 Support

Jika menemukan bug atau butuh bantuan:

- 📧 Email: fikri.sitorus@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/fikisitorus/GenieACS_Ubuntu/issues)
- 📖 Dokumentasi: [GenieACS Documentation](https://genieacs.com/docs/)

---

## 📚 Referensi

- [GenieACS Official Website](https://genieacs.com/)
- [GenieACS GitHub](https://github.com/genieacs/genieacs)
- [TR-069 Protocol](https://www.broadband-forum.org/technical/download/TR-069.pdf)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Node.js Documentation](https://nodejs.org/docs/)

---

## 📜 License

MIT License

Copyright (c) 2025 Fikri Sitorus

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🌟 Credits

**Script Created by:** Fikri Sitorus  
**Version:** 1.0.0  
**Last Updated:** December 2025  

Special thanks to:
- GenieACS Team
- MongoDB Team
- Node.js Community
- Ubuntu Community

---

<div align="center">

### ⭐ Jika script ini membantu, berikan star di GitHub! ⭐

**Made with ❤️ by Fikri Sitorus**

</div>
