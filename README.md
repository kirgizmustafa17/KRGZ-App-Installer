# ⚡ KRGZ App Installer

Modern, **WPF & .NET 8** tabanlı Windows uygulama yükleyici. Winget entegrasyonu ile 50+ uygulamayı tek tıkla kurun, Microsoft Office'i ODT ile yapılandırın ve gereksiz Windows uygulamalarını temizleyin.

![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue?style=flat-square&logo=windows)
![.NET](https://img.shields.io/badge/.NET-8.0-purple?style=flat-square&logo=dotnet)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## ✨ Özellikler

- 🚀 **56 Uygulama** — 11 kategoride düzenlenmiş hazır katalog
- ⚡ **Winget Entegrasyonu** — Otomatik sessiz kurulum, durum ve güncelleme tespiti
- 📦 **Microsoft Office Kurulumu** — ODT tabanlı özelleştirilebilir Office dağıtımı
- 🗑️ **Uygulama Kaldırma** — Windows AppX paketlerini kolayca kaldırın
- 🌐 **Çoklu Dil Desteği** — Türkçe ve İngilizce dahil, topluluk tarafından genişletilebilir
- 🎨 **WinUI Dark Tema** — Modern Windows 11 tasarım dili
- 🔍 **Gelişmiş Filtreleme** — Ada/açıklamaya göre arama, kurulum durumuna göre filtreleme
- 🔇 **Sessiz Kurulum** — Otomatik kurulum için kullanıcı etkileşimsiz mod

---

## 📸 Ekran Görüntüsü

> Uygulama WinUI Dark temasıyla, sidebar kategori navigasyonu ve canlı durum göstergeleri ile gelir.

---

## 🚀 Hızlı Başlangıç

### Gereksinimler
- Windows 10/11 (x64)
- [.NET 8 Runtime](https://dotnet.microsoft.com/download/dotnet/8.0)
- Winget (Windows Package Manager) — bulunamazsa uygulama otomatik kurmayı teklif eder

### Çalıştırma (Geliştirici)

```powershell
git clone https://github.com/kirgizmustafa17/KRGZ-App-Installer.git
cd KRGZ-App-Installer\KrgzAppInstallerWpf
dotnet run
```

> ⚠️ `app.manifest` içinde `requireAdministrator` ayarlı olduğundan uygulamayı **yönetici olarak** çalıştırın ya da derlenmiş `.exe`'yi doğrudan kullanın.

### Release Build (Tek Dosya)

```powershell
dotnet publish -c Release -r win-x64 --self-contained false
```

Çıktı: `bin\Release\net8.0-windows\win-x64\publish\KrgzAppInstaller.exe`

---

## 📂 Proje Yapısı

```
KrgzAppInstallerWpf/
├── App.xaml / App.xaml.cs          # Uygulama başlangıcı, global hata yönetimi
├── MainWindow.xaml / .cs           # Ana pencere — arama, sidebar, kurulum
├── OfficeInstallWindow.xaml / .cs  # ODT tabanlı Office kurulum penceresi
├── AppRemovalWindow.xaml / .cs     # Windows AppX kaldırma penceresi
├── Models/
│   ├── AppInfo.cs                  # Uygulama veri modeli
│   └── AppCatalog.cs               # 56 uygulama kataloğu + 11 kategori
├── Services/
│   ├── WingetService.cs            # Winget kurulum, durum kontrolü
│   ├── OfficeService.cs            # ODT indirme ve Office kurulumu
│   ├── AppRemovalService.cs        # AppX paket kaldırma
│   └── LocalizationService.cs      # Çoklu dil yönetimi
├── Languages/
│   ├── tr.json                     # Türkçe dil dosyası
│   └── en.json                     # İngilizce dil dosyası
└── app.manifest                    # Admin yetki + DPI ayarları
```

---

## 🌐 Yeni Dil Ekleme

Topluluk katkısıyla yeni diller eklenebilir. Sadece 3 adım:

1. `KrgzAppInstallerWpf/Languages/` klasörüne gidin
2. `tr.json` dosyasını kopyalayın, örneğin `de.json` olarak kaydedin
3. `_lang_name` ve `_lang_code` alanlarını güncelleyip tüm değerleri çevirin

Uygulama klasördeki tüm `.json` dosyalarını otomatik olarak keşfeder ve dil seçiciye ekler.

```jsonc
{
  "_lang_name": "Deutsch",
  "_lang_code": "de",
  "app_title": "KRGZ App Installer",
  "btn_install": "⚡ Installieren",
  // ...
}
```

---

## 📦 Uygulama Kategorileri

| Kategori | Uygulamalar |
|---|---|
| ⭐ Olmazsa Olmazlar | Chrome, Firefox, 7-Zip, VLC, LibreOffice, Notepad++ |
| 🌐 Tarayıcılar | Brave, Opera, Vivaldi, Tor |
| 📁 Arşiv | WinRAR, PeaZip, NanaZip |
| 🎵 Medya | PotPlayer, Spotify, OBS Studio, AIMP, HandBrake |
| 📝 Ofis & Editör | Adobe Reader, SumatraPDF, Obsidian |
| 💻 Geliştirici | VS Code, Git, Node.js, Python, Docker, Postman |
| 💬 İletişim | Discord, Telegram, Zoom, Teams, Slack |
| 🔧 Yardımcı | Everything, PowerToys, Rufus, CPU-Z, WizTree |
| 🎮 Oyun | Steam, Epic Games, GOG Galaxy, EA App |
| 🛡️ Güvenlik | Bitwarden, KeePassXC, Malwarebytes |

---

## 🤝 Katkıda Bulunma

Pull request'ler memnuniyetle karşılanır! Özellikle:
- Yeni dil dosyaları (`Languages/`)
- Kataloga yeni uygulama önerileri
- UI/UX iyileştirmeleri

---

## 📄 Lisans

MIT License — özgürce kullanın, değiştirin ve dağıtın.
