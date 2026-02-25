# KRGZ App Installer

Windows için modern arayüzlü, Winget tabanlı uygulama yükleyici ve yöneticisi.

## Özellikler

- **65+ Popüler Uygulama**: Kategorize edilmiş (Tarayıcılar, Ofis, Geliştirici, vb.) geniş uygulama kataloğu.
- **Modern WPF Arayüzü**: Karanlık mod destekli, hızlı ve kullanıcı dostu tasarım.
- **Sessiz Kurulum**: Uygulamaları arka planda otomatik olarak yükleme seçeneği.
- **Microsoft Office (ODT)**: Office bileşenlerini (Word, Excel, vb.) seçerek özel kurulum yapabilme.
- **Uygulama Kaldırma**: Yüklü Windows uygulamalarını (AppX) güvenli bir şekilde kaldırma.
- **Duyarlı Tasarım**: Kurulum sırasında donmayan, arka planda çalışan işlem motoru.

## Kullanım

PowerShell'i yönetici olarak açın ve scripti çalıştırın:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\KrgzAppInstaller.ps1
```

## Gereksinimler

- Windows 10 veya 11
- PowerShell 5.1+
- Winget (Eğer yüklü değilse script otomatik olarak kuracaktır)
