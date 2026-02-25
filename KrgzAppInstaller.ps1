<#
.SYNOPSIS
    KRGZ App Installer - Winget tabanli modern uygulama yukleyici
.DESCRIPTION
    WPF GUI ile kategorize edilmis 65+ uygulama, arama, sessiz kurulum,
    Microsoft Office (ODT) destegi ve otomatik winget kurulumu.
#>
#Requires -Version 5.1

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ============================================================
# APP CATALOG
# ============================================================
$script:AppCatalog = @(
    # Must Have
    [PSCustomObject]@{ Name = "Google Chrome"; Id = "Google.Chrome"; Categories = @("musthave", "browser"); Desc = "Hizli ve populer web tarayicisi" }
    [PSCustomObject]@{ Name = "Mozilla Firefox"; Id = "Mozilla.Firefox"; Categories = @("musthave", "browser"); Desc = "Gizlilik odakli acik kaynak tarayici" }
    [PSCustomObject]@{ Name = "7-Zip"; Id = "7zip.7zip"; Categories = @("musthave", "archive"); Desc = "Ucretsiz ve guclu arsiv yoneticisi" }
    [PSCustomObject]@{ Name = "VLC Media Player"; Id = "VideoLAN.VLC"; Categories = @("musthave", "media"); Desc = "Her formati oynatan medya oynatici" }
    [PSCustomObject]@{ Name = "LibreOffice"; Id = "TheDocumentFoundation.LibreOffice"; Categories = @("musthave", "office"); Desc = "Ucretsiz acik kaynak ofis paketi" }
    [PSCustomObject]@{ Name = "Notepad++"; Id = "Notepad++.Notepad++"; Categories = @("musthave", "office"); Desc = "Gelismis metin ve kod editoru" }
    # Browsers
    [PSCustomObject]@{ Name = "Brave Browser"; Id = "BraveSoftware.BraveBrowser"; Categories = @("browser"); Desc = "Reklam engelleyicili guvenli tarayici" }
    [PSCustomObject]@{ Name = "Opera"; Id = "Opera.Opera"; Categories = @("browser"); Desc = "Dahili VPN li modern tarayici" }
    [PSCustomObject]@{ Name = "Vivaldi"; Id = "Vivaldi.Vivaldi"; Categories = @("browser"); Desc = "Ozellestirilebilir guclu tarayici" }
    [PSCustomObject]@{ Name = "Tor Browser"; Id = "TorProject.TorBrowser"; Categories = @("browser"); Desc = "Anonim gezinti tarayicisi" }
    # Archive
    [PSCustomObject]@{ Name = "WinRAR"; Id = "RARLab.WinRAR"; Categories = @("archive"); Desc = "Populer arsiv yoneticisi" }
    [PSCustomObject]@{ Name = "PeaZip"; Id = "Giorgiotani.Peazip"; Categories = @("archive"); Desc = "Acik kaynak arsiv yoneticisi" }
    [PSCustomObject]@{ Name = "NanaZip"; Id = "M2Team.NanaZip"; Categories = @("archive"); Desc = "Modern 7-Zip tabanli arsivleyici" }
    # Media
    [PSCustomObject]@{ Name = "PotPlayer"; Id = "Daum.PotPlayer"; Categories = @("media"); Desc = "Hafif ve guclu video oynatici" }
    [PSCustomObject]@{ Name = "K-Lite Codec Pack"; Id = "CodecGuide.K-LiteCodecPack.Full"; Categories = @("media"); Desc = "Kapsamli codec paketi" }
    [PSCustomObject]@{ Name = "Spotify"; Id = "Spotify.Spotify"; Categories = @("media"); Desc = "Muzik akis platformu" }
    [PSCustomObject]@{ Name = "AIMP"; Id = "AIMP.AIMP"; Categories = @("media"); Desc = "Hafif muzik calar" }
    [PSCustomObject]@{ Name = "foobar2000"; Id = "PeterPawlowski.foobar2000"; Categories = @("media"); Desc = "Ozellestirilebilir muzik calar" }
    [PSCustomObject]@{ Name = "OBS Studio"; Id = "OBSProject.OBSStudio"; Categories = @("media"); Desc = "Ekran kaydi ve yayin yazilimi" }
    [PSCustomObject]@{ Name = "HandBrake"; Id = "HandBrake.HandBrake"; Categories = @("media"); Desc = "Video donusturme araci" }
    # Office
    [PSCustomObject]@{ Name = "Adobe Acrobat Reader"; Id = "Adobe.Acrobat.Reader.64-bit"; Categories = @("office"); Desc = "PDF goruntuyeci" }
    [PSCustomObject]@{ Name = "SumatraPDF"; Id = "SumatraPDF.SumatraPDF"; Categories = @("office"); Desc = "Hafif PDF/eKitap okuyucu" }
    [PSCustomObject]@{ Name = "Foxit PDF Reader"; Id = "Foxit.FoxitReader"; Categories = @("office"); Desc = "Hizli PDF okuyucu ve editoru" }
    [PSCustomObject]@{ Name = "Obsidian"; Id = "Obsidian.Obsidian"; Categories = @("office"); Desc = "Markdown tabanli not alma uygulamasi" }
    [PSCustomObject]@{ Name = "Microsoft Office"; Id = "OFFICE_ODT"; Categories = @("office"); Desc = "Word, Excel, PowerPoint... (ODT ile kurulum)" }
    # Dev
    [PSCustomObject]@{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode"; Categories = @("dev"); Desc = "Populer kod editoru" }
    [PSCustomObject]@{ Name = "Git"; Id = "Git.Git"; Categories = @("dev"); Desc = "Versiyon kontrol sistemi" }
    [PSCustomObject]@{ Name = "Node.js LTS"; Id = "OpenJS.NodeJS.LTS"; Categories = @("dev"); Desc = "JavaScript calisma ortami" }
    [PSCustomObject]@{ Name = "Python 3"; Id = "Python.Python.3.12"; Categories = @("dev"); Desc = "Python programlama dili" }
    [PSCustomObject]@{ Name = "Windows Terminal"; Id = "Microsoft.WindowsTerminal"; Categories = @("dev"); Desc = "Modern terminal uygulamasi" }
    [PSCustomObject]@{ Name = "PowerShell 7"; Id = "Microsoft.PowerShell"; Categories = @("dev"); Desc = "Guncel PowerShell surumu" }
    [PSCustomObject]@{ Name = "Docker Desktop"; Id = "Docker.DockerDesktop"; Categories = @("dev"); Desc = "Konteyner yonetim platformu" }
    [PSCustomObject]@{ Name = "Postman"; Id = "Postman.Postman"; Categories = @("dev"); Desc = "API gelistirme ve test araci" }
    [PSCustomObject]@{ Name = "FileZilla"; Id = "TimKosse.FileZilla.Client"; Categories = @("dev"); Desc = "FTP/SFTP istemcisi" }
    [PSCustomObject]@{ Name = "WinSCP"; Id = "WinSCP.WinSCP"; Categories = @("dev"); Desc = "SFTP ve SCP istemcisi" }
    # Communication
    [PSCustomObject]@{ Name = "Discord"; Id = "Discord.Discord"; Categories = @("comm"); Desc = "Sesli ve yazili iletisim platformu" }
    [PSCustomObject]@{ Name = "Telegram"; Id = "Telegram.TelegramDesktop"; Categories = @("comm"); Desc = "Hizli ve guvenli mesajlasma" }
    [PSCustomObject]@{ Name = "Zoom"; Id = "Zoom.Zoom"; Categories = @("comm"); Desc = "Video konferans uygulamasi" }
    [PSCustomObject]@{ Name = "Microsoft Teams"; Id = "Microsoft.Teams"; Categories = @("comm"); Desc = "Is birligi ve toplanti araci" }
    [PSCustomObject]@{ Name = "Slack"; Id = "SlackTechnologies.Slack"; Categories = @("comm"); Desc = "Ekip iletisim platformu" }
    [PSCustomObject]@{ Name = "Skype"; Id = "Microsoft.Skype"; Categories = @("comm"); Desc = "Goruntulu gorusme uygulamasi" }
    # Utility
    [PSCustomObject]@{ Name = "Everything"; Id = "voidtools.Everything"; Categories = @("utility"); Desc = "Anlik dosya arama araci" }
    [PSCustomObject]@{ Name = "ShareX"; Id = "ShareX.ShareX"; Categories = @("utility"); Desc = "Ekran goruntusu ve paylasim" }
    [PSCustomObject]@{ Name = "PowerToys"; Id = "Microsoft.PowerToys"; Categories = @("utility"); Desc = "Windows guclendirme araclari" }
    [PSCustomObject]@{ Name = "TreeSize Free"; Id = "JAMSoftware.TreeSize.Free"; Categories = @("utility"); Desc = "Disk kullanim analizi" }
    [PSCustomObject]@{ Name = "Bulk Crap Uninstaller"; Id = "Klocman.BulkCrapUninstaller"; Categories = @("utility"); Desc = "Toplu program kaldirma araci" }
    [PSCustomObject]@{ Name = "CPU-Z"; Id = "CPUID.CPU-Z"; Categories = @("utility"); Desc = "Donanim bilgi araci" }
    [PSCustomObject]@{ Name = "HWiNFO"; Id = "REALiX.HWiNFO"; Categories = @("utility"); Desc = "Detayli donanim izleme" }
    [PSCustomObject]@{ Name = "Rufus"; Id = "Rufus.Rufus"; Categories = @("utility"); Desc = "USB bootable disk olusturma" }
    [PSCustomObject]@{ Name = "WizTree"; Id = "AntibodySoftware.WizTree"; Categories = @("utility"); Desc = "Hizli disk alani analizi" }
    # Gaming
    [PSCustomObject]@{ Name = "Steam"; Id = "Valve.Steam"; Categories = @("gaming"); Desc = "Oyun magazasi ve platformu" }
    [PSCustomObject]@{ Name = "Epic Games Launcher"; Id = "EpicGames.EpicGamesLauncher"; Categories = @("gaming"); Desc = "Epic Games oyun magazasi" }
    [PSCustomObject]@{ Name = "GOG Galaxy"; Id = "GOG.Galaxy"; Categories = @("gaming"); Desc = "DRM-siz oyun platformu" }
    [PSCustomObject]@{ Name = "EA App"; Id = "ElectronicArts.EADesktop"; Categories = @("gaming"); Desc = "EA oyun istemcisi" }
    # Security
    [PSCustomObject]@{ Name = "Bitwarden"; Id = "Bitwarden.Bitwarden"; Categories = @("security"); Desc = "Acik kaynak sifre yoneticisi" }
    [PSCustomObject]@{ Name = "KeePassXC"; Id = "KeePassXCTeam.KeePassXC"; Categories = @("security"); Desc = "Cevrimdisi sifre yoneticisi" }
    [PSCustomObject]@{ Name = "Malwarebytes"; Id = "Malwarebytes.Malwarebytes"; Categories = @("security"); Desc = "Zararli yazilim temizleme" }
)

$script:Categories = [ordered]@{
    "all"      = @{ Label = "Tum Uygulamalar"; Icon = "+"; Color = "#58A6FF" }
    "musthave" = @{ Label = "Olmazsa Olmazlar"; Icon = "*"; Color = "#F0883E" }
    "browser"  = @{ Label = "Tarayicilar"; Icon = ">"; Color = "#3FB950" }
    "archive"  = @{ Label = "Arsiv Yoneticileri"; Icon = "#"; Color = "#A371F7" }
    "media"    = @{ Label = "Medya Oynaticilar"; Icon = ">"; Color = "#F778BA" }
    "office"   = @{ Label = "Ofis & Editor"; Icon = "="; Color = "#79C0FF" }
    "dev"      = @{ Label = "Gelistirici Araclari"; Icon = "<"; Color = "#D2A8FF" }
    "comm"     = @{ Label = "Iletisim"; Icon = "@"; Color = "#56D364" }
    "utility"  = @{ Label = "Yardimci Araclar"; Icon = "~"; Color = "#E3B341" }
    "gaming"   = @{ Label = "Oyun Platformlari"; Icon = "!"; Color = "#FF7B72" }
    "security" = @{ Label = "Guvenlik"; Icon = "&"; Color = "#7EE787" }
}

$script:CurrentCategory = "all"
$script:CurrentFilter = "all"
$script:AppCheckBoxes = @{}
$script:AppBorders = @{}
$script:AppStatusDots = @{}
$script:AppStatuses = @{}
$script:IsInstalling = $false
$script:JustInstalled = [System.Collections.ArrayList]::new()

# ============================================================
# WINGET FUNCTIONS
# ============================================================
function Test-WingetAvailable {
    try {
        $v = & winget --version 2>$null
        if ($v) { return $true }
    }
    catch {}
    return $false
}

function Install-WingetIfNeeded {
    if (Test-WingetAvailable) { return $true }

    $result = [System.Windows.MessageBox]::Show(
        "Winget bulunamadi. Otomatik olarak kurulsun mu?",
        "Winget Gerekli",
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question
    )
    if ($result -ne [System.Windows.MessageBoxResult]::Yes) { return $false }

    # Method 1: AppxPackage RegisterByFamilyName
    try {
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction Stop
        Start-Sleep -Seconds 3
        if (Test-WingetAvailable) { return $true }
    }
    catch {
        Write-Host "RegisterByFamilyName basarisiz, indirme deneniyor..."
    }

    # Method 2: Download from aka.ms/getwinget
    try {
        $tempPath = Join-Path $env:TEMP "Microsoft.DesktopAppInstaller.msixbundle"
        [System.Windows.MessageBox]::Show("Winget indiriliyor, lutfen bekleyin...", "Indirme", "OK", "Information")
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile $tempPath -UseBasicParsing
        Add-AppxPackage -Path $tempPath -ErrorAction Stop
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
        if (Test-WingetAvailable) { return $true }
    }
    catch {
        [System.Windows.MessageBox]::Show(
            "Winget kurulamadi: $($_.Exception.Message)`nLutfen manuel olarak kurun: https://aka.ms/getwinget",
            "Hata", "OK", "Error"
        )
    }
    return $false
}

# ============================================================
# OFFICE DEPLOYMENT TOOL FUNCTIONS
# ============================================================
function Show-OfficeInstallWindow {
    param([System.Windows.Window]$Owner)

    $officeXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Microsoft Office Kurulumu (ODT)" Width="520" Height="580"
    WindowStartupLocation="CenterOwner" ResizeMode="NoResize"
    Background="#0D1117" Foreground="#C9D1D9" FontFamily="Segoe UI">
  <Grid Margin="20">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>

    <TextBlock Grid.Row="0" Text="Microsoft Office Bilesenleri" FontSize="18" FontWeight="Bold" Foreground="#F0F6FC" Margin="0,0,0,6"/>
    <TextBlock Grid.Row="1" Text="Kurmak istediginiz Office uygulamalarini secin:" Foreground="#8B949E" Margin="0,0,0,14" FontSize="13"/>

    <Border Grid.Row="2" Background="#161B22" CornerRadius="8" Padding="16" BorderBrush="#30363D" BorderThickness="1">
      <StackPanel>
        <CheckBox Name="chkWord" Content="  Word - Kelime islemci" Foreground="#C9D1D9" Margin="0,6" FontSize="14" IsChecked="True"/>
        <CheckBox Name="chkExcel" Content="  Excel - Hesap tablosu" Foreground="#C9D1D9" Margin="0,6" FontSize="14" IsChecked="True"/>
        <CheckBox Name="chkPowerPoint" Content="  PowerPoint - Sunum" Foreground="#C9D1D9" Margin="0,6" FontSize="14" IsChecked="True"/>
        <CheckBox Name="chkOutlook" Content="  Outlook - E-posta istemcisi" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
        <CheckBox Name="chkAccess" Content="  Access - Veritabani" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
        <CheckBox Name="chkPublisher" Content="  Publisher - Masaustu yayincilik" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
        <CheckBox Name="chkOneNote" Content="  OneNote - Not alma" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
        <CheckBox Name="chkVisio" Content="  Visio - Diyagram olusturma" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
        <CheckBox Name="chkProject" Content="  Project - Proje yonetimi" Foreground="#C9D1D9" Margin="0,6" FontSize="14"/>
      </StackPanel>
    </Border>

    <Grid Grid.Row="3" Margin="0,14,0,0">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>
      <StackPanel Grid.Column="0" Margin="0,0,8,0">
        <TextBlock Text="Kanal:" Foreground="#58A6FF" Margin="0,0,0,4" FontSize="12" FontWeight="SemiBold"/>
        <ComboBox Name="cmbChannel" Background="#E6EDF3" Foreground="#0D1117" FontSize="13" Padding="6,4" SelectedIndex="0">
          <ComboBoxItem Content="Current Channel"/>
          <ComboBoxItem Content="Monthly Enterprise"/>
          <ComboBoxItem Content="Semi-Annual Enterprise"/>
        </ComboBox>
      </StackPanel>
      <StackPanel Grid.Column="1" Margin="8,0,0,0">
        <TextBlock Text="Mimari:" Foreground="#58A6FF" Margin="0,0,0,4" FontSize="12" FontWeight="SemiBold"/>
        <ComboBox Name="cmbArch" Background="#E6EDF3" Foreground="#0D1117" FontSize="13" Padding="6,4" SelectedIndex="0">
          <ComboBoxItem Content="64-bit"/>
          <ComboBoxItem Content="32-bit"/>
        </ComboBox>
      </StackPanel>
    </Grid>

    <TextBlock Grid.Row="4" Name="txtOfficeStatus" Text="" Foreground="#E3B341" Margin="0,10,0,0" FontSize="12" TextWrapping="Wrap"/>

    <StackPanel Grid.Row="5" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,14,0,0">
      <Button Name="btnOfficeCancel" Content="Iptal" Width="90" Height="34" Margin="0,0,10,0" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" FontSize="13" Cursor="Hand"/>
      <Button Name="btnOfficeInstall" Content="Kur" Width="120" Height="34" Background="#238636" Foreground="White" BorderBrush="#2EA043" FontSize="14" FontWeight="SemiBold" Cursor="Hand"/>
    </StackPanel>
  </Grid>
</Window>
"@

    $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($officeXaml))
    $officeWin = [System.Windows.Markup.XamlReader]::Load($reader)
    $officeWin.Owner = $Owner

    $btnCancel = $officeWin.FindName("btnOfficeCancel")
    $btnInstall = $officeWin.FindName("btnOfficeInstall")
    $txtStatus = $officeWin.FindName("txtOfficeStatus")

    $btnCancel.Add_Click({ $officeWin.DialogResult = $false; $officeWin.Close() })

    $btnInstall.Add_Click({
            $apps = @()
            $excludes = @()
            $allApps = @{
                "Word" = "chkWord"; "Excel" = "chkExcel"; "PowerPoint" = "chkPowerPoint";
                "Outlook" = "chkOutlook"; "Access" = "chkAccess"; "Publisher" = "chkPublisher";
                "OneNote" = "chkOneNote"; "Visio" = "chkVisio"; "Project" = "chkProject"
            }
            foreach ($app in $allApps.GetEnumerator()) {
                $cb = $officeWin.FindName($app.Value)
                if ($cb.IsChecked) { $apps += $app.Key } else { $excludes += $app.Key }
            }

            if ($apps.Count -eq 0) {
                $txtStatus.Text = "En az bir uygulama secmelisiniz!"
                $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                return
            }

            $channelMap = @{ 0 = "Current"; 1 = "MonthlyEnterprise"; 2 = "SemiAnnual" }
            $cmbCh = $officeWin.FindName("cmbChannel")
            $cmbAr = $officeWin.FindName("cmbArch")
            $channel = $channelMap[$cmbCh.SelectedIndex]
            $arch = if ($cmbAr.SelectedIndex -eq 0) { "64" } else { "32" }

            $txtStatus.Text = "Office Deployment Tool hazirlaniyor..."
            $txtStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#E3B341")
            $officeWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

            $odtDir = Join-Path $env:TEMP "ODT_KRGZ"
            if (-not (Test-Path $odtDir)) { New-Item -Path $odtDir -ItemType Directory -Force | Out-Null }

            $setupExe = $null

            # Check known paths for setup.exe
            $knownPaths = @(
                Join-Path $env:ProgramFiles "OfficeDeploymentTool\setup.exe"
                Join-Path ${env:ProgramFiles(x86)} "OfficeDeploymentTool\setup.exe"
                Join-Path $env:TEMP "ODT_KRGZ\setup.exe"
            )
            foreach ($p in $knownPaths) {
                if ($p -and (Test-Path $p)) { $setupExe = $p; break }
            }

            if (-not $setupExe) {
                $txtStatus.Text = "ODT kuruluyor (winget ile)..."
                $officeWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

                # Method 1: winget ile ODT kur
                try {
                    $wProc = Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.OfficeDeploymentTool --accept-package-agreements --accept-source-agreements --source winget --silent" -Wait -PassThru -NoNewWindow
                    Start-Sleep -Seconds 2
                    # Re-check known paths after install
                    foreach ($p in $knownPaths) {
                        if ($p -and (Test-Path $p)) { $setupExe = $p; break }
                    }
                }
                catch {}

                # Method 2: Web'den indir ve extract et
                if (-not $setupExe) {
                    $txtStatus.Text = "ODT indiriliyor (web)..."
                    $officeWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)
                    try {
                        $odtDir = Join-Path $env:TEMP "ODT_KRGZ"
                        if (-not (Test-Path $odtDir)) { New-Item -Path $odtDir -ItemType Directory -Force | Out-Null }
                        $odtExe = Join-Path $env:TEMP "ODTSetup.exe"
                        $ProgressPreference = 'SilentlyContinue'
                        Invoke-WebRequest -Uri "https://aka.ms/ODT" -OutFile $odtExe -UseBasicParsing
                        $fileSize = (Get-Item $odtExe).Length
                        if ($fileSize -lt 500000) {
                            throw "Indirilen dosya gecersiz (boyut: $fileSize byte). Lutfen https://aka.ms/ODT adresinden manuel indirin."
                        }
                        Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$odtExe`" /quiet /extract:`"$odtDir`"" -Wait -NoNewWindow
                        Remove-Item $odtExe -Force -ErrorAction SilentlyContinue
                        $candidatePath = Join-Path $odtDir "setup.exe"
                        if (Test-Path $candidatePath) { $setupExe = $candidatePath }
                    }
                    catch {
                        $txtStatus.Text = "ODT indirilemedi: $($_.Exception.Message)"
                        $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                        return
                    }
                }

                if (-not $setupExe) {
                    $txtStatus.Text = "ODT setup.exe bulunamadi. Lutfen https://aka.ms/ODT adresinden manuel indirin."
                    $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                    return
                }
            }

            $odtDir = Split-Path $setupExe -Parent

            # Build configuration XML
            $excludeXml = ""
            foreach ($ex in $excludes) {
                $excludeXml += "        <ExcludeApp ID=`"$ex`" />`n"
            }

            $configXml = @"
<Configuration>
  <Add OfficeClientEdition="$arch" Channel="$channel">
    <Product ID="O365ProPlusRetail">
      <Language ID="tr-TR" />
      <Language ID="en-US" />
$excludeXml    </Product>
  </Add>
  <Display Level="Full" AcceptEULA="TRUE" />
  <Updates Enabled="TRUE" />
</Configuration>
"@
            $configPath = Join-Path $odtDir "configuration.xml"
            $configXml | Out-File -FilePath $configPath -Encoding UTF8 -Force

            $txtStatus.Text = "Office indiriliyor... (Bu islem uzun surebilir)"
            $officeWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

            try {
                $dlProc = Start-Process -FilePath $setupExe -ArgumentList "/download `"$configPath`"" -Wait -PassThru
                if ($dlProc.ExitCode -ne 0) {
                    $txtStatus.Text = "Indirme hatasi (kod: $($dlProc.ExitCode))"
                    $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                    return
                }
            }
            catch {
                $txtStatus.Text = "Indirme hatasi: $($_.Exception.Message)"
                $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                return
            }

            $txtStatus.Text = "Office kuruluyor..."
            $officeWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

            try {
                $instProc = Start-Process -FilePath $setupExe -ArgumentList "/configure `"$configPath`"" -Wait -PassThru
                if ($instProc.ExitCode -eq 0) {
                    $txtStatus.Text = "Office basariyla kuruldu!"
                    $txtStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#3FB950")
                    [System.Windows.MessageBox]::Show("Microsoft Office basariyla kuruldu!", "Basarili", "OK", "Information")
                }
                else {
                    $txtStatus.Text = "Kurulum hatasi (kod: $($instProc.ExitCode))"
                    $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
                }
            }
            catch {
                $txtStatus.Text = "Kurulum hatasi: $($_.Exception.Message)"
                $txtStatus.Foreground = [System.Windows.Media.Brushes]::Red
            }
        })

    $officeWin.ShowDialog() | Out-Null
}

# ============================================================
# WINDOWS APP REMOVAL WINDOW
# ============================================================
function Show-AppRemovalWindow {
    param([System.Windows.Window]$Owner)

    $removeXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Windows Uygulamalarini Kaldir" Width="700" Height="620"
    WindowStartupLocation="CenterOwner" ResizeMode="CanResize"
    Background="#0D1117" Foreground="#C9D1D9" FontFamily="Segoe UI"
    MinWidth="500" MinHeight="400">
  <Grid Margin="16">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>

    <TextBlock Grid.Row="0" Text="Windows Uygulamalarini Kaldir" FontSize="18" FontWeight="Bold" Foreground="#F0F6FC" Margin="0,0,0,4"/>
    <TextBlock Grid.Row="0" Text="Get-AppxPackage" FontSize="11" Foreground="#484F58" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,0,6"/>

    <Border Grid.Row="1" Background="#161B22" CornerRadius="8" BorderBrush="#30363D" BorderThickness="1" Padding="10,6" Margin="0,8,0,8">
      <Grid>
        <TextBlock Name="txtRemSearchHint" Text="Uygulama ara..." Foreground="#484F58" FontSize="13" VerticalAlignment="Center" IsHitTestVisible="False"/>
        <TextBox Name="txtRemSearch" Background="Transparent" Foreground="#F0F6FC" BorderThickness="0" FontSize="13" VerticalAlignment="Center" CaretBrush="#58A6FF"/>
      </Grid>
    </Border>

    <Border Grid.Row="2" Background="#161B22" CornerRadius="8" BorderBrush="#30363D" BorderThickness="1">
      <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="4">
        <StackPanel Name="pnlRemApps"/>
      </ScrollViewer>
    </Border>

    <Grid Grid.Row="3" Margin="0,10,0,0">
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" VerticalAlignment="Center">
        <Button Name="btnRemSelectAll" Content="Tumunu Sec" Padding="12,5" Margin="0,0,6,0" FontSize="12" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
        <Button Name="btnRemDeselectAll" Content="Temizle" Padding="12,5" Margin="0,0,6,0" FontSize="12" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
        <Button Name="btnRemRefresh" Content="Yenile" Padding="12,5" FontSize="12" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
      </StackPanel>
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
        <TextBlock Name="txtRemSelected" Text="0 secili" Foreground="#8B949E" VerticalAlignment="Center" Margin="0,0,12,0" FontSize="13"/>
        <Button Name="btnRemClose" Content="Kapat" Padding="14,6" Margin="0,0,6,0" FontSize="13" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
        <Button Name="btnRemRemove" Content="Secilenleri Kaldir" Padding="16,6" FontSize="13" FontWeight="SemiBold" Background="#B62324" Foreground="White" BorderBrush="#DA3633" Cursor="Hand"/>
      </StackPanel>
    </Grid>

    <TextBlock Grid.Row="4" Name="txtRemStatus" Text="Uygulamalar yukleniyor..." Foreground="#8B949E" FontSize="12" Margin="0,8,0,0" TextWrapping="Wrap"/>
  </Grid>
</Window>
"@

    $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($removeXaml))
    $remWin = [System.Windows.Markup.XamlReader]::Load($reader)
    $remWin.Owner = $Owner

    $pnlRemApps = $remWin.FindName("pnlRemApps")
    $txtRemSearch = $remWin.FindName("txtRemSearch")
    $txtRemSearchHint = $remWin.FindName("txtRemSearchHint")
    $txtRemSelected = $remWin.FindName("txtRemSelected")
    $txtRemStatus = $remWin.FindName("txtRemStatus")
    $btnRemSelectAll = $remWin.FindName("btnRemSelectAll")
    $btnRemDeselectAll = $remWin.FindName("btnRemDeselectAll")
    $btnRemRefresh = $remWin.FindName("btnRemRefresh")
    $btnRemRemove = $remWin.FindName("btnRemRemove")
    $btnRemClose = $remWin.FindName("btnRemClose")

    $remCheckBoxes = @{}
    $remBorders = @{}
    $remPackages = @{}

    # --- Helper: update selected count ---
    $updateRemCount = {
        $c = 0
        foreach ($kv in $remCheckBoxes.GetEnumerator()) {
            if ($kv.Value.IsChecked) { $c++ }
        }
        $txtRemSelected.Text = "$c secili"
    }

    # --- Helper: filter by search ---
    $filterRemApps = {
        $q = $txtRemSearch.Text.Trim().ToLower()
        foreach ($kv in $remBorders.GetEnumerator()) {
            $visible = [string]::IsNullOrEmpty($q) -or $kv.Key.ToLower().Contains($q)
            $kv.Value.Visibility = if ($visible) { "Visible" } else { "Collapsed" }
        }
    }

    # --- Load packages into UI ---
    $loadPackages = {
        $pnlRemApps.Children.Clear()
        $remCheckBoxes.Clear()
        $remBorders.Clear()
        $remPackages.Clear()

        $txtRemStatus.Text = "Uygulamalar yukleniyor..."
        $remWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

        $pkgs = Get-AppxPackage | Sort-Object Name
        $count = 0

        foreach ($pkg in $pkgs) {
            $displayName = $pkg.Name
            $version = $pkg.Version

            # Create card
            $border = New-Object System.Windows.Controls.Border
            $border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#0D1117")
            $border.CornerRadius = [System.Windows.CornerRadius]::new(4)
            $border.Margin = [System.Windows.Thickness]::new(0, 1, 0, 1)
            $border.Padding = [System.Windows.Thickness]::new(10, 7, 10, 7)
            $border.Cursor = [System.Windows.Input.Cursors]::Hand

            $grid = New-Object System.Windows.Controls.Grid
            $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = "Auto"
            $c2 = New-Object System.Windows.Controls.ColumnDefinition; $c2.Width = "*"
            $c3 = New-Object System.Windows.Controls.ColumnDefinition; $c3.Width = "Auto"
            $grid.ColumnDefinitions.Add($c1)
            $grid.ColumnDefinitions.Add($c2)
            $grid.ColumnDefinitions.Add($c3)

            $cb = New-Object System.Windows.Controls.CheckBox
            $cb.VerticalAlignment = "Center"
            $cb.Margin = [System.Windows.Thickness]::new(0, 0, 10, 0)
            [System.Windows.Controls.Grid]::SetColumn($cb, 0)
            $cb.Add_Checked($updateRemCount)
            $cb.Add_Unchecked($updateRemCount)

            $tp = New-Object System.Windows.Controls.StackPanel
            $tp.VerticalAlignment = "Center"
            [System.Windows.Controls.Grid]::SetColumn($tp, 1)

            $nb = New-Object System.Windows.Controls.TextBlock
            $nb.Text = $displayName
            $nb.FontSize = 12.5
            $nb.FontWeight = "SemiBold"
            $nb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#F0F6FC")
            $nb.TextTrimming = "CharacterEllipsis"

            $vb = New-Object System.Windows.Controls.TextBlock
            $vb.Text = "v$version"
            $vb.FontSize = 10.5
            $vb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#6E7681")
            $vb.Margin = [System.Windows.Thickness]::new(0, 1, 0, 0)

            $tp.Children.Add($nb) | Out-Null
            $tp.Children.Add($vb) | Out-Null

            $szBlock = New-Object System.Windows.Controls.TextBlock
            $szBlock.VerticalAlignment = "Center"
            [System.Windows.Controls.Grid]::SetColumn($szBlock, 2)
            $szBlock.FontSize = 10
            $szBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#484F58")
            if ($pkg.IsFramework) { $szBlock.Text = "Framework" } else { $szBlock.Text = "App" }

            $grid.Children.Add($cb) | Out-Null
            $grid.Children.Add($tp) | Out-Null
            $grid.Children.Add($szBlock) | Out-Null
            $border.Child = $grid

            # Hover
            $border.Add_MouseEnter({ param($s, $e); $s.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#161B22") })
            $border.Add_MouseLeave({ param($s, $e); $s.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#0D1117") })
            $border.Tag = $cb
            $border.Add_MouseLeftButtonUp({
                    param($s, $e)
                    if ($e.OriginalSource -isnot [System.Windows.Controls.CheckBox]) {
                        $s.Tag.IsChecked = -not $s.Tag.IsChecked
                    }
                })

            $pnlRemApps.Children.Add($border) | Out-Null
            $remCheckBoxes[$displayName] = $cb
            $remBorders[$displayName] = $border
            $remPackages[$displayName] = $pkg
            $count++
        }

        $txtRemStatus.Text = "$count uygulama listelendi."
    }

    # --- Load when window is rendered (lazy) ---
    $remWin.Add_ContentRendered({ & $loadPackages })

    # --- Events ---
    $txtRemSearch.Add_TextChanged({
            $txtRemSearchHint.Visibility = if ([string]::IsNullOrEmpty($txtRemSearch.Text)) { "Visible" } else { "Collapsed" }
            & $filterRemApps
        })

    $btnRemSelectAll.Add_Click({
            foreach ($kv in $remBorders.GetEnumerator()) {
                if ($kv.Value.Visibility -eq [System.Windows.Visibility]::Visible) {
                    $remCheckBoxes[$kv.Key].IsChecked = $true
                }
            }
        })

    $btnRemDeselectAll.Add_Click({
            foreach ($kv in $remCheckBoxes.GetEnumerator()) { $kv.Value.IsChecked = $false }
        })

    $btnRemRefresh.Add_Click({ & $loadPackages })
    $btnRemClose.Add_Click({ $remWin.Close() })

    $btnRemRemove.Add_Click({
            $toRemove = @()
            foreach ($kv in $remCheckBoxes.GetEnumerator()) {
                if ($kv.Value.IsChecked) {
                    $toRemove += $kv.Key
                }
            }

            if ($toRemove.Count -eq 0) {
                [System.Windows.MessageBox]::Show("Lutfen kaldirmak icin en az bir uygulama secin.", "Uyari", "OK", "Warning")
                return
            }

            $confirm = [System.Windows.MessageBox]::Show(
                "$($toRemove.Count) uygulama kaldirilacak. Devam edilsin mi?`n`nNot: Bu islem sadece mevcut kullanici icin gecerlidir (guvenli mod).",
                "Onay",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Warning
            )
            if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) { return }

            $successCount = 0
            $failCount = 0
            $total = $toRemove.Count
            $i = 0

            foreach ($appName in $toRemove) {
                $i++
                $txtRemStatus.Text = "[$i/$total] Kaldiriliyor: $appName"
                $remWin.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Background)

                $pkg = $remPackages[$appName]
                if ($pkg) {
                    try {
                        Remove-AppxPackage -Package $pkg.PackageFullName -ErrorAction Stop
                        $successCount++
                    }
                    catch {
                        $failCount++
                    }
                }
            }

            $txtRemStatus.Text = "Tamamlandi. $successCount basarili, $failCount basarisiz."
            [System.Windows.MessageBox]::Show("$successCount uygulama basariyla kaldirildi.`n$failCount basarisiz.", "Sonuc", "OK", "Information")

            # Refresh list
            & $loadPackages
        })

    $remWin.ShowDialog() | Out-Null
}

# ============================================================
# MAIN XAML
# ============================================================
$mainXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="KRGZ App Installer" Width="960" Height="700"
    WindowStartupLocation="CenterScreen" Background="#0D1117"
    FontFamily="Segoe UI" Foreground="#C9D1D9" MinWidth="750" MinHeight="500">
  <Grid>
    <Grid.RowDefinitions>
      <RowDefinition Height="60"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>

    <!-- HEADER -->
    <Border Grid.Row="0" Background="#161B22" BorderBrush="#30363D" BorderThickness="0,0,0,1">
      <Grid Margin="20,0">
        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
          <TextBlock Text="&#x26A1;" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
          <TextBlock Text="KRGZ App Installer" FontSize="20" FontWeight="Bold" Foreground="#F0F6FC" VerticalAlignment="Center"/>
          <TextBlock Text="winget tabanli uygulama yukleyici" FontSize="11" Foreground="#484F58" VerticalAlignment="Center" Margin="14,3,0,0"/>
        </StackPanel>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
          <CheckBox Name="chkSilent" VerticalAlignment="Center" Margin="0,0,6,0" IsChecked="True"/>
          <TextBlock Text="Sessiz Kurulum" Foreground="#8B949E" VerticalAlignment="Center" FontSize="13"/>
        </StackPanel>
      </Grid>
    </Border>

    <!-- CONTENT -->
    <Grid Grid.Row="1">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="200"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>

      <!-- SIDEBAR -->
      <Border Grid.Column="0" Background="#0D1117" BorderBrush="#21262D" BorderThickness="0,0,1,0">
        <ScrollViewer VerticalScrollBarVisibility="Auto">
          <StackPanel Name="pnlSidebar" Margin="8,10"/>
        </ScrollViewer>
      </Border>

      <!-- RIGHT PANEL -->
      <Grid Grid.Column="1">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- SEARCH + FILTER -->
        <Grid Grid.Row="0" Margin="14,10,14,4">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="Auto"/>
          </Grid.ColumnDefinitions>
          <Border Grid.Column="0" Background="#161B22" CornerRadius="8" BorderBrush="#30363D" BorderThickness="1" Padding="12,7" Margin="0,0,8,0">
            <Grid>
              <TextBlock Name="txtSearchHint" Text="&#x1F50D; Uygulama ara..." Foreground="#484F58" FontSize="14" VerticalAlignment="Center" IsHitTestVisible="False"/>
              <TextBox Name="txtSearch" Background="Transparent" Foreground="#F0F6FC" BorderThickness="0" FontSize="14" VerticalAlignment="Center" CaretBrush="#58A6FF"/>
            </Grid>
          </Border>
          <ComboBox Name="cmbFilter" Grid.Column="1" Background="#E6EDF3" Foreground="#0D1117" FontSize="12" Padding="8,6" SelectedIndex="0" MinWidth="140" VerticalAlignment="Center">
            <ComboBoxItem Content="Tumu"/>
            <ComboBoxItem Content="Yuklu Olanlar"/>
            <ComboBoxItem Content="Yuklu Olmayanlar"/>
            <ComboBoxItem Content="Guncelleme Var"/>
          </ComboBox>
        </Grid>

        <!-- APP LIST -->
        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="14,6,14,0" Padding="0,0,4,0">
          <StackPanel Name="pnlApps"/>
        </ScrollViewer>

        <!-- ACTION BAR -->
        <Border Grid.Row="2" Background="#161B22" BorderBrush="#30363D" BorderThickness="0,1,0,0" Padding="14,10">
          <Grid>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" VerticalAlignment="Center">
              <Button Name="btnSelectAll" Content="Tumunu Sec" Padding="14,6" Margin="0,0,6,0" FontSize="12" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
              <Button Name="btnDeselectAll" Content="Temizle" Padding="14,6" Margin="0,0,6,0" FontSize="12" Background="#21262D" Foreground="#C9D1D9" BorderBrush="#30363D" Cursor="Hand"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
              <TextBlock Name="txtSelected" Text="0 uygulama secili" Foreground="#8B949E" VerticalAlignment="Center" Margin="0,0,14,0" FontSize="13"/>
              <Button Name="btnCancel" Content="Iptal" Padding="16,7" FontSize="13" Background="#B62324" Foreground="White" BorderBrush="#DA3633" Cursor="Hand" Visibility="Collapsed"/>
              <Button Name="btnInstall" Content="&#x26A1; Yukle" Padding="20,7" FontSize="14" FontWeight="SemiBold" Background="#238636" Foreground="White" BorderBrush="#2EA043" Cursor="Hand"/>
            </StackPanel>
          </Grid>
        </Border>
      </Grid>
    </Grid>

    <!-- STATUS BAR -->
    <Border Grid.Row="2" Background="#161B22" BorderBrush="#30363D" BorderThickness="0,1,0,0" Padding="20,8">
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <TextBlock Name="txtStatus" Text="Hazir" Foreground="#8B949E" FontSize="12" Grid.Row="0"/>
        <ProgressBar Name="prgProgress" Height="5" Grid.Row="1" Margin="0,5,0,0" Background="#21262D" Foreground="#58A6FF" Value="0" Maximum="100" BorderThickness="0"/>
      </Grid>
    </Border>
  </Grid>
</Window>
"@

# ============================================================
# BUILD WINDOW
# ============================================================
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($mainXaml))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

$pnlSidebar = $window.FindName("pnlSidebar")
$pnlApps = $window.FindName("pnlApps")
$txtSearch = $window.FindName("txtSearch")
$txtSearchHint = $window.FindName("txtSearchHint")
$txtSelected = $window.FindName("txtSelected")
$txtStatus = $window.FindName("txtStatus")
$prgProgress = $window.FindName("prgProgress")
$btnSelectAll = $window.FindName("btnSelectAll")
$btnDeselectAll = $window.FindName("btnDeselectAll")
$btnInstall = $window.FindName("btnInstall")
$btnCancel = $window.FindName("btnCancel")
$chkSilent = $window.FindName("chkSilent")
$cmbFilter = $window.FindName("cmbFilter")

# ============================================================
# HELPER: Update selected count
# ============================================================
function Update-SelectedCount {
    $count = 0
    foreach ($kv in $script:AppCheckBoxes.GetEnumerator()) {
        if ($kv.Value.IsChecked) { $count++ }
    }
    $txtSelected.Text = "$count uygulama secili"
}

# ============================================================
# HELPER: Filter apps by category & search
# ============================================================
function Update-AppVisibility {
    $searchText = $txtSearch.Text.Trim().ToLower()
    $filterIndex = $cmbFilter.SelectedIndex
    foreach ($app in $script:AppCatalog) {
        $key = $app.Id + "_" + ($app.Categories -join "_")
        $border = $script:AppBorders[$key]
        if (-not $border) { continue }

        $catMatch = ($script:CurrentCategory -eq "all") -or ($app.Categories -contains $script:CurrentCategory)
        $searchMatch = [string]::IsNullOrEmpty($searchText) -or
        $app.Name.ToLower().Contains($searchText) -or
        $app.Desc.ToLower().Contains($searchText) -or
        $app.Id.ToLower().Contains($searchText)

        # Filter by install status
        $filterMatch = $true
        if ($filterIndex -gt 0 -and $app.Id -ne "OFFICE_ODT") {
            $appIdLower = $app.Id.ToLower()
            $isInstalled = $script:StatusSyncHash.InstalledIds -contains $appIdLower
            $hasUpgrade = $script:StatusSyncHash.UpgradeIds -contains $appIdLower
            switch ($filterIndex) {
                1 { $filterMatch = $isInstalled }         # Yuklu
                2 { $filterMatch = -not $isInstalled }    # Yuklu degil
                3 { $filterMatch = $hasUpgrade }          # Guncelleme var
            }
        }

        if ($catMatch -and $searchMatch -and $filterMatch) {
            $border.Visibility = [System.Windows.Visibility]::Visible
        }
        else {
            $border.Visibility = [System.Windows.Visibility]::Collapsed
        }
    }
}

# ============================================================
# BUILD SIDEBAR
# ============================================================
$script:SidebarButtons = @{}
foreach ($cat in $script:Categories.GetEnumerator()) {
    $catKey = $cat.Key
    $catInfo = $cat.Value
    $count = if ($catKey -eq "all") { $script:AppCatalog.Count } else { ($script:AppCatalog | Where-Object { $_.Categories -contains $catKey }).Count }

    $btn = New-Object System.Windows.Controls.Button
    $btn.Height = 36
    $btn.Margin = [System.Windows.Thickness]::new(0, 2, 0, 2)
    $btn.Cursor = [System.Windows.Input.Cursors]::Hand
    $btn.HorizontalContentAlignment = "Left"
    $btn.Padding = [System.Windows.Thickness]::new(12, 0, 12, 0)
    $btn.BorderThickness = [System.Windows.Thickness]::new(3, 0, 0, 0)
    $btn.FontSize = 13

    if ($catKey -eq "all") {
        $btn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#1C2333")
        $btn.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFrom($catInfo.Color)
        $btn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#F0F6FC")
    }
    else {
        $btn.Background = [System.Windows.Media.Brushes]::Transparent
        $btn.BorderBrush = [System.Windows.Media.Brushes]::Transparent
        $btn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#8B949E")
    }

    $btn.Content = "$($catInfo.Label) ($count)"
    $btn.Tag = $catKey

    $btn.Add_Click({
            param($s, $e)
            $clickedKey = $s.Tag
            $script:CurrentCategory = $clickedKey

            foreach ($sbKv in $script:SidebarButtons.GetEnumerator()) {
                $sbBtn = $sbKv.Value
                $sbKey = $sbKv.Key
                $sbInfo = $script:Categories[$sbKey]
                if ($sbKey -eq $clickedKey) {
                    $sbBtn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#1C2333")
                    $sbBtn.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFrom($sbInfo.Color)
                    $sbBtn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#F0F6FC")
                }
                else {
                    $sbBtn.Background = [System.Windows.Media.Brushes]::Transparent
                    $sbBtn.BorderBrush = [System.Windows.Media.Brushes]::Transparent
                    $sbBtn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#8B949E")
                }
            }
            Update-AppVisibility
        })

    $pnlSidebar.Children.Add($btn) | Out-Null
    $script:SidebarButtons[$catKey] = $btn
}

# --- Sidebar: Separator + App Removal Button ---
$separator = New-Object System.Windows.Controls.Separator
$separator.Margin = [System.Windows.Thickness]::new(8, 10, 8, 10)
$separator.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#21262D")
$pnlSidebar.Children.Add($separator) | Out-Null

$btnRemoveApps = New-Object System.Windows.Controls.Button
$btnRemoveApps.Height = 36
$btnRemoveApps.Margin = [System.Windows.Thickness]::new(0, 2, 0, 2)
$btnRemoveApps.Cursor = [System.Windows.Input.Cursors]::Hand
$btnRemoveApps.HorizontalContentAlignment = "Left"
$btnRemoveApps.Padding = [System.Windows.Thickness]::new(12, 0, 12, 0)
$btnRemoveApps.BorderThickness = [System.Windows.Thickness]::new(3, 0, 0, 0)
$btnRemoveApps.FontSize = 13
$btnRemoveApps.Background = [System.Windows.Media.Brushes]::Transparent
$btnRemoveApps.BorderBrush = [System.Windows.Media.Brushes]::Transparent
$btnRemoveApps.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF7B72")
$btnRemoveApps.Content = "Uygulama Kaldir"
$btnRemoveApps.Add_Click({ Show-AppRemovalWindow -Owner $window })
$pnlSidebar.Children.Add($btnRemoveApps) | Out-Null

# ============================================================
# BUILD APP CARDS
# ============================================================
foreach ($app in $script:AppCatalog) {
    $key = $app.Id + "_" + ($app.Categories -join "_")

    $border = New-Object System.Windows.Controls.Border
    $border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#161B22")
    $border.CornerRadius = [System.Windows.CornerRadius]::new(6)
    $border.Margin = [System.Windows.Thickness]::new(0, 3, 0, 3)
    $border.Padding = [System.Windows.Thickness]::new(0, 0, 14, 0)
    $border.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#21262D")
    $border.BorderThickness = [System.Windows.Thickness]::new(1)
    $border.Cursor = [System.Windows.Input.Cursors]::Hand

    $grid = New-Object System.Windows.Controls.Grid
    $col0 = New-Object System.Windows.Controls.ColumnDefinition; $col0.Width = [System.Windows.GridLength]::new(4)
    $col1 = New-Object System.Windows.Controls.ColumnDefinition; $col1.Width = "Auto"
    $col2 = New-Object System.Windows.Controls.ColumnDefinition; $col2.Width = "*"
    $col3 = New-Object System.Windows.Controls.ColumnDefinition; $col3.Width = "Auto"
    $grid.ColumnDefinitions.Add($col0)
    $grid.ColumnDefinitions.Add($col1)
    $grid.ColumnDefinitions.Add($col2)
    $grid.ColumnDefinitions.Add($col3)

    # Status indicator (colored left strip)
    $statusDot = New-Object System.Windows.Controls.Border
    $statusDot.Width = 4
    $statusDot.CornerRadius = [System.Windows.CornerRadius]::new(2)
    $statusDot.Background = [System.Windows.Media.Brushes]::Transparent
    $statusDot.VerticalAlignment = "Stretch"
    $statusDot.Margin = [System.Windows.Thickness]::new(0, 0, 0, 0)
    [System.Windows.Controls.Grid]::SetColumn($statusDot, 0)

    $cb = New-Object System.Windows.Controls.CheckBox
    $cb.VerticalAlignment = "Center"
    $cb.Margin = [System.Windows.Thickness]::new(10, 0, 12, 0)
    [System.Windows.Controls.Grid]::SetColumn($cb, 1)
    $cb.Add_Checked({ Update-SelectedCount })
    $cb.Add_Unchecked({ Update-SelectedCount })

    $textPanel = New-Object System.Windows.Controls.StackPanel
    $textPanel.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($textPanel, 2)

    $nameBlock = New-Object System.Windows.Controls.TextBlock
    $nameBlock.Text = $app.Name
    $nameBlock.FontSize = 14
    $nameBlock.FontWeight = "SemiBold"
    $nameBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#F0F6FC")

    $descBlock = New-Object System.Windows.Controls.TextBlock
    $descBlock.Text = $app.Desc
    $descBlock.FontSize = 11.5
    $descBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#8B949E")
    $descBlock.Margin = [System.Windows.Thickness]::new(0, 2, 0, 0)

    $textPanel.Children.Add($nameBlock) | Out-Null
    $textPanel.Children.Add($descBlock) | Out-Null

    $idBlock = New-Object System.Windows.Controls.TextBlock
    $idBlock.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($idBlock, 3)
    $idBlock.FontSize = 11
    $idBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#484F58")
    if ($app.Id -eq "OFFICE_ODT") {
        $idBlock.Text = "ODT"
    }
    else {
        $idBlock.Text = $app.Id
    }

    $grid.Children.Add($statusDot) | Out-Null
    $grid.Children.Add($cb) | Out-Null
    $grid.Children.Add($textPanel) | Out-Null
    $grid.Children.Add($idBlock) | Out-Null
    $border.Child = $grid

    $script:AppStatusDots[$key] = $statusDot

    # Hover effects
    $border.Add_MouseEnter({
            param($s, $e)
            $s.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#1C2333")
            $s.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#30363D")
        })
    $border.Add_MouseLeave({
            param($s, $e)
            $s.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#161B22")
            $s.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#21262D")
        })
    # Click border to toggle checkbox
    $border.Tag = $cb
    $border.Add_MouseLeftButtonUp({
            param($s, $e)
            if ($e.OriginalSource -isnot [System.Windows.Controls.CheckBox]) {
                $chk = $s.Tag
                $chk.IsChecked = -not $chk.IsChecked
            }
        })

    $pnlApps.Children.Add($border) | Out-Null
    $script:AppCheckBoxes[$key] = $cb
    $script:AppBorders[$key] = $border
}

# ============================================================
# SEARCH BAR EVENTS
# ============================================================
$txtSearch.Add_TextChanged({
        $txtSearchHint.Visibility = if ([string]::IsNullOrEmpty($txtSearch.Text)) { "Visible" } else { "Collapsed" }
        Update-AppVisibility
    })

$cmbFilter.Add_SelectionChanged({
        Update-AppVisibility
    })

# ============================================================
# SELECT ALL / DESELECT ALL
# ============================================================
$btnSelectAll.Add_Click({
        foreach ($app in $script:AppCatalog) {
            $key = $app.Id + "_" + ($app.Categories -join "_")
            $border = $script:AppBorders[$key]
            if ($border -and $border.Visibility -eq [System.Windows.Visibility]::Visible) {
                $script:AppCheckBoxes[$key].IsChecked = $true
            }
        }
    })

$btnDeselectAll.Add_Click({
        foreach ($kv in $script:AppCheckBoxes.GetEnumerator()) {
            $kv.Value.IsChecked = $false
        }
    })

# ============================================================
# SHARED STATE FOR BACKGROUND INSTALL
# ============================================================
$script:SyncHash = [hashtable]::Synchronized(@{
        Status       = ""
        CurrentIndex = 0
        TotalCount   = 0
        CurrentApp   = ""
        IsRunning    = $false
        IsFinished   = $false
        IsCancelled  = $false
        Completed    = [System.Collections.ArrayList]::new()
        Failed       = [System.Collections.ArrayList]::new()
    })

# ============================================================
# INSTALL BUTTON
# ============================================================
$btnInstall.Add_Click({
        if ($script:IsInstalling) { return }

        # Collect unique selected app IDs
        $selectedApps = @()
        $seenIds = @{}
        $hasOffice = $false

        foreach ($app in $script:AppCatalog) {
            $key = $app.Id + "_" + ($app.Categories -join "_")
            $cb = $script:AppCheckBoxes[$key]
            if ($cb -and $cb.IsChecked) {
                if ($app.Id -eq "OFFICE_ODT") {
                    $hasOffice = $true
                    continue
                }
                if (-not $seenIds.ContainsKey($app.Id)) {
                    $selectedApps += $app
                    $seenIds[$app.Id] = $true
                }
            }
        }

        # Handle Office ODT separately
        if ($hasOffice) {
            Show-OfficeInstallWindow -Owner $window
        }

        if ($selectedApps.Count -eq 0) {
            if (-not $hasOffice) {
                [System.Windows.MessageBox]::Show("Lutfen yuklemek icin en az bir uygulama secin.", "Uyari", "OK", "Warning")
            }
            return
        }

        # Check winget
        if (-not (Install-WingetIfNeeded)) {
            [System.Windows.MessageBox]::Show("Winget bulunamadi. Kurulum yapilamiyor.", "Hata", "OK", "Error")
            return
        }

        # Prepare UI
        $script:IsInstalling = $true
        $btnInstall.IsEnabled = $false
        $btnInstall.Content = "Yukleniyor..."
        $btnCancel.Visibility = "Visible"
        $btnSelectAll.IsEnabled = $false
        $btnDeselectAll.IsEnabled = $false

        $silentFlag = if ($chkSilent.IsChecked) { "--silent" } else { "" }
        $total = $selectedApps.Count
        $prgProgress.Maximum = $total
        $prgProgress.Value = 0

        # Reset sync state
        $script:SyncHash.Status = "Baslatiliyor..."
        $script:SyncHash.CurrentIndex = 0
        $script:SyncHash.TotalCount = $total
        $script:SyncHash.CurrentApp = ""
        $script:SyncHash.IsRunning = $true
        $script:SyncHash.IsFinished = $false
        $script:SyncHash.IsCancelled = $false
        $script:SyncHash.Completed.Clear()
        $script:SyncHash.Failed.Clear()

        # Build app list for the runspace (plain data, no WPF objects)
        $appList = @()
        foreach ($a in $selectedApps) {
            $appList += @{ Name = $a.Name; Id = $a.Id }
        }

        # Cancel button handler
        $btnCancel.Add_Click({ $script:SyncHash.IsCancelled = $true })

        # --- Background Runspace ---
        $runspace = [runspacefactory]::CreateRunspace()
        $runspace.ApartmentState = "STA"
        $runspace.Open()
        $runspace.SessionStateProxy.SetVariable("syncHash", $script:SyncHash)
        $runspace.SessionStateProxy.SetVariable("appList", $appList)
        $runspace.SessionStateProxy.SetVariable("silentFlag", $silentFlag)

        $psCmd = [powershell]::Create()
        $psCmd.Runspace = $runspace
        $psCmd.AddScript({
                param($syncHash, $appList, $silentFlag)

                $total = $appList.Count
                $i = 0

                foreach ($app in $appList) {
                    if ($syncHash.IsCancelled) {
                        $syncHash.Status = "Kurulum iptal edildi."
                        break
                    }

                    $i++
                    $syncHash.CurrentIndex = $i
                    $syncHash.CurrentApp = $app.Name
                    $syncHash.Status = "[$i/$total] Yukleniyor: $($app.Name)"

                    try {
                        $wingetArgs = "install --id $($app.Id) --accept-package-agreements --accept-source-agreements --source winget"
                        if ($silentFlag) { $wingetArgs += " $silentFlag" }

                        $proc = Start-Process -FilePath "winget" -ArgumentList $wingetArgs -Wait -PassThru -WindowStyle Hidden
                        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) {
                            $syncHash.Completed.Add($app.Name) | Out-Null
                        }
                        else {
                            $syncHash.Failed.Add("$($app.Name) (kod: $($proc.ExitCode))") | Out-Null
                        }
                    }
                    catch {
                        $syncHash.Failed.Add("$($app.Name) (hata: $($_.Exception.Message))") | Out-Null
                    }
                }

                $syncHash.IsRunning = $false
                $syncHash.IsFinished = $true
            }) | Out-Null

        $psCmd.AddArgument($script:SyncHash) | Out-Null
        $psCmd.AddArgument($appList) | Out-Null
        $psCmd.AddArgument($silentFlag) | Out-Null
        $psCmd.BeginInvoke() | Out-Null

        # --- DispatcherTimer to poll background progress ---
        $script:InstallTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:InstallTimer.Interval = [TimeSpan]::FromMilliseconds(500)
        $script:InstallTimer.Add_Tick({
                # Update UI from sync hash
                $txtStatus.Text = $script:SyncHash.Status
                $prgProgress.Value = $script:SyncHash.CurrentIndex

                if ($script:SyncHash.IsFinished) {
                    $script:InstallTimer.Stop()

                    $cCount = $script:SyncHash.Completed.Count
                    $fCount = $script:SyncHash.Failed.Count
                    $prgProgress.Value = $script:SyncHash.TotalCount

                    if ($script:SyncHash.IsCancelled) {
                        $txtStatus.Text = "Iptal edildi. $cCount basarili, $fCount basarisiz."
                    }
                    else {
                        $txtStatus.Text = "Tum kurulumlar tamamlandi. $cCount basarili, $fCount basarisiz."
                    }

                    $summary = "Tamamlandi!`n"
                    if ($cCount -gt 0) { $summary += "Basarili ($cCount): $($script:SyncHash.Completed -join ', ')`n" }
                    if ($fCount -gt 0) { $summary += "Basarisiz ($fCount): $($script:SyncHash.Failed -join ', ')" }

                    [System.Windows.MessageBox]::Show($summary, "Kurulum Sonucu", "OK", "Information")

                    $script:IsInstalling = $false
                    $btnInstall.IsEnabled = $true
                    $btnInstall.Content = "Yukle"
                    $btnCancel.Visibility = "Collapsed"
                    $btnSelectAll.IsEnabled = $true
                    $btnDeselectAll.IsEnabled = $true

                    # Clear all selections
                    foreach ($kv in $script:AppCheckBoxes.GetEnumerator()) {
                        $kv.Value.IsChecked = $false
                    }
                    Update-SelectedCount

                    # Mark just-installed apps with blue
                    $script:JustInstalled.Clear()
                    foreach ($name in $script:SyncHash.Completed) {
                        $script:JustInstalled.Add($name) | Out-Null
                    }

                    # Refresh install status in background
                    Start-AppStatusCheck

                    # Cleanup
                    $psCmd.Dispose()
                    $runspace.Close()
                }
            })
        $script:InstallTimer.Start()
    })

# ============================================================
# APP STATUS CHECK (Background)
# ============================================================
$script:StatusSyncHash = [hashtable]::Synchronized(@{
        InstalledIds = [System.Collections.ArrayList]::new()
        UpgradeIds   = [System.Collections.ArrayList]::new()
        IsFinished   = $false
    })

function Update-AppStatusUI {
    foreach ($app in $script:AppCatalog) {
        if ($app.Id -eq "OFFICE_ODT") { continue }
        $key = $app.Id + "_" + ($app.Categories -join "_")
        $dot = $script:AppStatusDots[$key]
        if (-not $dot) { continue }

        $appId = $app.Id.ToLower()

        if ($script:JustInstalled -contains $app.Name) {
            # Blue: just installed
            $dot.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#58A6FF")
        }
        elseif ($script:StatusSyncHash.UpgradeIds -contains $appId) {
            # Orange: update available
            $dot.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#E3B341")
        }
        elseif ($script:StatusSyncHash.InstalledIds -contains $appId) {
            # Green: installed
            $dot.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#238636")
        }
        else {
            # Transparent: not installed
            $dot.Background = [System.Windows.Media.Brushes]::Transparent
        }
    }
}

function Start-AppStatusCheck {
    $script:StatusSyncHash.InstalledIds.Clear()
    $script:StatusSyncHash.UpgradeIds.Clear()
    $script:StatusSyncHash.IsFinished = $false

    $txtStatus.Text = "Uygulama durumlari kontrol ediliyor..."

    $script:StatusRS = [runspacefactory]::CreateRunspace()
    $script:StatusRS.Open()
    $script:StatusRS.SessionStateProxy.SetVariable("statusSync", $script:StatusSyncHash)

    $script:StatusPS = [powershell]::Create()
    $script:StatusPS.Runspace = $script:StatusRS
    $script:StatusPS.AddScript({
            param($statusSync)

            # Get installed apps
            try {
                $listOutput = & winget list --accept-source-agreements 2>$null
                if ($listOutput) {
                    foreach ($line in $listOutput) {
                        $parts = $line -split '\s{2,}'
                        if ($parts.Count -ge 2) {
                            $id = $parts[1].Trim().ToLower()
                            if ($id -and $id -ne "id" -and $id.Contains(".")) {
                                $statusSync.InstalledIds.Add($id) | Out-Null
                            }
                        }
                    }
                }
            }
            catch {}

            # Get available upgrades
            try {
                $upgradeOutput = & winget upgrade --accept-source-agreements 2>$null
                if ($upgradeOutput) {
                    foreach ($line in $upgradeOutput) {
                        $parts = $line -split '\s{2,}'
                        if ($parts.Count -ge 2) {
                            $id = $parts[1].Trim().ToLower()
                            if ($id -and $id -ne "id" -and $id.Contains(".")) {
                                $statusSync.UpgradeIds.Add($id) | Out-Null
                            }
                        }
                    }
                }
            }
            catch {}

            $statusSync.IsFinished = $true
        }) | Out-Null
    $script:StatusPS.AddArgument($script:StatusSyncHash) | Out-Null
    $script:StatusPS.BeginInvoke() | Out-Null

    # Timer to poll and update UI
    $script:StatusTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:StatusTimer.Interval = [TimeSpan]::FromMilliseconds(1000)
    $script:StatusTimer.Add_Tick({
            if ($script:StatusSyncHash.IsFinished) {
                $script:StatusTimer.Stop()
                Update-AppStatusUI
                $installedCount = $script:StatusSyncHash.InstalledIds.Count
                $upgradeCount = $script:StatusSyncHash.UpgradeIds.Count
                if (-not $script:IsInstalling) {
                    $txtStatus.Text = "Hazir. $installedCount yuklu uygulama, $upgradeCount guncelleme mevcut."
                }
                try { $script:StatusPS.Dispose() } catch {}
                try { $script:StatusRS.Close() } catch {}
            }
        })
    $script:StatusTimer.Start()
}

# --- Run status check on startup ---
Start-AppStatusCheck

# ============================================================
# SHOW WINDOW
# ============================================================
$window.ShowDialog() | Out-Null
