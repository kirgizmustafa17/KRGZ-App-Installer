namespace KrgzAppInstaller.Models;

using KrgzAppInstaller.Services;

public static class AppCatalog
{
    // Description keys mapped to app IDs for localization
    private static readonly Dictionary<string, string> DescKeys = new()
    {
        ["Google.Chrome"] = "desc_google_chrome",
        ["Mozilla.Firefox"] = "desc_mozilla_firefox",
        ["7zip.7zip"] = "desc_7zip",
        ["VideoLAN.VLC"] = "desc_vlc",
        ["TheDocumentFoundation.LibreOffice"] = "desc_libreoffice",
        ["Notepad++.Notepad++"] = "desc_notepadpp",
        ["BraveSoftware.BraveBrowser"] = "desc_brave",
        ["Opera.Opera"] = "desc_opera",
        ["Vivaldi.Vivaldi"] = "desc_vivaldi",
        ["TorProject.TorBrowser"] = "desc_tor",
        ["RARLab.WinRAR"] = "desc_winrar",
        ["Giorgiotani.Peazip"] = "desc_peazip",
        ["M2Team.NanaZip"] = "desc_nanazip",
        ["Daum.PotPlayer"] = "desc_potplayer",
        ["CodecGuide.K-LiteCodecPack.Full"] = "desc_klite",
        ["Spotify.Spotify"] = "desc_spotify",
        ["AIMP.AIMP"] = "desc_aimp",
        ["PeterPawlowski.foobar2000"] = "desc_foobar",
        ["OBSProject.OBSStudio"] = "desc_obs",
        ["HandBrake.HandBrake"] = "desc_handbrake",
        ["Adobe.Acrobat.Reader.64-bit"] = "desc_acrobat",
        ["SumatraPDF.SumatraPDF"] = "desc_sumatra",
        ["Foxit.FoxitReader"] = "desc_foxit",
        ["Obsidian.Obsidian"] = "desc_obsidian",
        ["Microsoft.VisualStudioCode"] = "desc_vscode",
        ["Git.Git"] = "desc_git",
        ["OpenJS.NodeJS.LTS"] = "desc_nodejs",
        ["Python.Python.3.12"] = "desc_python",
        ["Microsoft.WindowsTerminal"] = "desc_terminal",
        ["Microsoft.PowerShell"] = "desc_pwsh",
        ["Docker.DockerDesktop"] = "desc_docker",
        ["Postman.Postman"] = "desc_postman",
        ["TimKosse.FileZilla.Client"] = "desc_filezilla",
        ["WinSCP.WinSCP"] = "desc_winscp",
        ["Discord.Discord"] = "desc_discord",
        ["Telegram.TelegramDesktop"] = "desc_telegram",
        ["Zoom.Zoom"] = "desc_zoom",
        ["Microsoft.Teams"] = "desc_teams",
        ["SlackTechnologies.Slack"] = "desc_slack",
        ["Microsoft.Skype"] = "desc_skype",
        ["voidtools.Everything"] = "desc_everything",
        ["ShareX.ShareX"] = "desc_sharex",
        ["Microsoft.PowerToys"] = "desc_powertoys",
        ["JAMSoftware.TreeSize.Free"] = "desc_treesize",
        ["Klocman.BulkCrapUninstaller"] = "desc_bcu",
        ["CPUID.CPU-Z"] = "desc_cpuz",
        ["REALiX.HWiNFO"] = "desc_hwinfo",
        ["Rufus.Rufus"] = "desc_rufus",
        ["AntibodySoftware.WizTree"] = "desc_wiztree",
        ["Valve.Steam"] = "desc_steam",
        ["EpicGames.EpicGamesLauncher"] = "desc_epic",
        ["GOG.Galaxy"] = "desc_gog",
        ["ElectronicArts.EADesktop"] = "desc_ea",
        ["Bitwarden.Bitwarden"] = "desc_bitwarden",
        ["KeePassXCTeam.KeePassXC"] = "desc_keepass",
        ["Malwarebytes.Malwarebytes"] = "desc_malwarebytes",
    };

    public static string GetLocalizedDesc(string appId)
    {
        if (DescKeys.TryGetValue(appId, out var key))
            return LocalizationService.Get(key);
        return "";
    }

    public static List<AppInfo> GetAllApps() =>
    [
        // Must Have
        new() { Name = "Google Chrome", Id = "Google.Chrome", Categories = ["musthave", "browser"], Desc = GetLocalizedDesc("Google.Chrome") },
        new() { Name = "Mozilla Firefox", Id = "Mozilla.Firefox", Categories = ["musthave", "browser"], Desc = GetLocalizedDesc("Mozilla.Firefox") },
        new() { Name = "7-Zip", Id = "7zip.7zip", Categories = ["musthave", "archive"], Desc = GetLocalizedDesc("7zip.7zip") },
        new() { Name = "VLC Media Player", Id = "VideoLAN.VLC", Categories = ["musthave", "media"], Desc = GetLocalizedDesc("VideoLAN.VLC") },
        new() { Name = "LibreOffice", Id = "TheDocumentFoundation.LibreOffice", Categories = ["musthave", "office"], Desc = GetLocalizedDesc("TheDocumentFoundation.LibreOffice") },
        new() { Name = "Notepad++", Id = "Notepad++.Notepad++", Categories = ["musthave", "office"], Desc = GetLocalizedDesc("Notepad++.Notepad++") },

        // Browsers
        new() { Name = "Brave Browser", Id = "BraveSoftware.BraveBrowser", Categories = ["browser"], Desc = GetLocalizedDesc("BraveSoftware.BraveBrowser") },
        new() { Name = "Opera", Id = "Opera.Opera", Categories = ["browser"], Desc = GetLocalizedDesc("Opera.Opera") },
        new() { Name = "Vivaldi", Id = "Vivaldi.Vivaldi", Categories = ["browser"], Desc = GetLocalizedDesc("Vivaldi.Vivaldi") },
        new() { Name = "Tor Browser", Id = "TorProject.TorBrowser", Categories = ["browser"], Desc = GetLocalizedDesc("TorProject.TorBrowser") },

        // Archive
        new() { Name = "WinRAR", Id = "RARLab.WinRAR", Categories = ["archive"], Desc = GetLocalizedDesc("RARLab.WinRAR") },
        new() { Name = "PeaZip", Id = "Giorgiotani.Peazip", Categories = ["archive"], Desc = GetLocalizedDesc("Giorgiotani.Peazip") },
        new() { Name = "NanaZip", Id = "M2Team.NanaZip", Categories = ["archive"], Desc = GetLocalizedDesc("M2Team.NanaZip") },

        // Media
        new() { Name = "PotPlayer", Id = "Daum.PotPlayer", Categories = ["media"], Desc = GetLocalizedDesc("Daum.PotPlayer") },
        new() { Name = "K-Lite Codec Pack", Id = "CodecGuide.K-LiteCodecPack.Full", Categories = ["media"], Desc = GetLocalizedDesc("CodecGuide.K-LiteCodecPack.Full") },
        new() { Name = "Spotify", Id = "Spotify.Spotify", Categories = ["media"], Desc = GetLocalizedDesc("Spotify.Spotify") },
        new() { Name = "AIMP", Id = "AIMP.AIMP", Categories = ["media"], Desc = GetLocalizedDesc("AIMP.AIMP") },
        new() { Name = "foobar2000", Id = "PeterPawlowski.foobar2000", Categories = ["media"], Desc = GetLocalizedDesc("PeterPawlowski.foobar2000") },
        new() { Name = "OBS Studio", Id = "OBSProject.OBSStudio", Categories = ["media"], Desc = GetLocalizedDesc("OBSProject.OBSStudio") },
        new() { Name = "HandBrake", Id = "HandBrake.HandBrake", Categories = ["media"], Desc = GetLocalizedDesc("HandBrake.HandBrake") },

        // Office
        new() { Name = "Adobe Acrobat Reader", Id = "Adobe.Acrobat.Reader.64-bit", Categories = ["office"], Desc = GetLocalizedDesc("Adobe.Acrobat.Reader.64-bit") },
        new() { Name = "SumatraPDF", Id = "SumatraPDF.SumatraPDF", Categories = ["office"], Desc = GetLocalizedDesc("SumatraPDF.SumatraPDF") },
        new() { Name = "Foxit PDF Reader", Id = "Foxit.FoxitReader", Categories = ["office"], Desc = GetLocalizedDesc("Foxit.FoxitReader") },
        new() { Name = "Obsidian", Id = "Obsidian.Obsidian", Categories = ["office"], Desc = GetLocalizedDesc("Obsidian.Obsidian") },

        // Dev
        new() { Name = "Visual Studio Code", Id = "Microsoft.VisualStudioCode", Categories = ["dev"], Desc = GetLocalizedDesc("Microsoft.VisualStudioCode") },
        new() { Name = "Git", Id = "Git.Git", Categories = ["dev"], Desc = GetLocalizedDesc("Git.Git") },
        new() { Name = "Node.js LTS", Id = "OpenJS.NodeJS.LTS", Categories = ["dev"], Desc = GetLocalizedDesc("OpenJS.NodeJS.LTS") },
        new() { Name = "Python 3", Id = "Python.Python.3.12", Categories = ["dev"], Desc = GetLocalizedDesc("Python.Python.3.12") },
        new() { Name = "Windows Terminal", Id = "Microsoft.WindowsTerminal", Categories = ["dev"], Desc = GetLocalizedDesc("Microsoft.WindowsTerminal") },
        new() { Name = "PowerShell 7", Id = "Microsoft.PowerShell", Categories = ["dev"], Desc = GetLocalizedDesc("Microsoft.PowerShell") },
        new() { Name = "Docker Desktop", Id = "Docker.DockerDesktop", Categories = ["dev"], Desc = GetLocalizedDesc("Docker.DockerDesktop") },
        new() { Name = "Postman", Id = "Postman.Postman", Categories = ["dev"], Desc = GetLocalizedDesc("Postman.Postman") },
        new() { Name = "FileZilla", Id = "TimKosse.FileZilla.Client", Categories = ["dev"], Desc = GetLocalizedDesc("TimKosse.FileZilla.Client") },
        new() { Name = "WinSCP", Id = "WinSCP.WinSCP", Categories = ["dev"], Desc = GetLocalizedDesc("WinSCP.WinSCP") },

        // Communication
        new() { Name = "Discord", Id = "Discord.Discord", Categories = ["comm"], Desc = GetLocalizedDesc("Discord.Discord") },
        new() { Name = "Telegram", Id = "Telegram.TelegramDesktop", Categories = ["comm"], Desc = GetLocalizedDesc("Telegram.TelegramDesktop") },
        new() { Name = "Zoom", Id = "Zoom.Zoom", Categories = ["comm"], Desc = GetLocalizedDesc("Zoom.Zoom") },
        new() { Name = "Microsoft Teams", Id = "Microsoft.Teams", Categories = ["comm"], Desc = GetLocalizedDesc("Microsoft.Teams") },
        new() { Name = "Slack", Id = "SlackTechnologies.Slack", Categories = ["comm"], Desc = GetLocalizedDesc("SlackTechnologies.Slack") },
        new() { Name = "Skype", Id = "Microsoft.Skype", Categories = ["comm"], Desc = GetLocalizedDesc("Microsoft.Skype") },

        // Utility
        new() { Name = "Everything", Id = "voidtools.Everything", Categories = ["utility"], Desc = GetLocalizedDesc("voidtools.Everything") },
        new() { Name = "ShareX", Id = "ShareX.ShareX", Categories = ["utility"], Desc = GetLocalizedDesc("ShareX.ShareX") },
        new() { Name = "PowerToys", Id = "Microsoft.PowerToys", Categories = ["utility"], Desc = GetLocalizedDesc("Microsoft.PowerToys") },
        new() { Name = "TreeSize Free", Id = "JAMSoftware.TreeSize.Free", Categories = ["utility"], Desc = GetLocalizedDesc("JAMSoftware.TreeSize.Free") },
        new() { Name = "Bulk Crap Uninstaller", Id = "Klocman.BulkCrapUninstaller", Categories = ["utility"], Desc = GetLocalizedDesc("Klocman.BulkCrapUninstaller") },
        new() { Name = "CPU-Z", Id = "CPUID.CPU-Z", Categories = ["utility"], Desc = GetLocalizedDesc("CPUID.CPU-Z") },
        new() { Name = "HWiNFO", Id = "REALiX.HWiNFO", Categories = ["utility"], Desc = GetLocalizedDesc("REALiX.HWiNFO") },
        new() { Name = "Rufus", Id = "Rufus.Rufus", Categories = ["utility"], Desc = GetLocalizedDesc("Rufus.Rufus") },
        new() { Name = "WizTree", Id = "AntibodySoftware.WizTree", Categories = ["utility"], Desc = GetLocalizedDesc("AntibodySoftware.WizTree") },

        // Gaming
        new() { Name = "Steam", Id = "Valve.Steam", Categories = ["gaming"], Desc = GetLocalizedDesc("Valve.Steam") },
        new() { Name = "Epic Games Launcher", Id = "EpicGames.EpicGamesLauncher", Categories = ["gaming"], Desc = GetLocalizedDesc("EpicGames.EpicGamesLauncher") },
        new() { Name = "GOG Galaxy", Id = "GOG.Galaxy", Categories = ["gaming"], Desc = GetLocalizedDesc("GOG.Galaxy") },
        new() { Name = "EA App", Id = "ElectronicArts.EADesktop", Categories = ["gaming"], Desc = GetLocalizedDesc("ElectronicArts.EADesktop") },

        // Security
        new() { Name = "Bitwarden", Id = "Bitwarden.Bitwarden", Categories = ["security"], Desc = GetLocalizedDesc("Bitwarden.Bitwarden") },
        new() { Name = "KeePassXC", Id = "KeePassXCTeam.KeePassXC", Categories = ["security"], Desc = GetLocalizedDesc("KeePassXCTeam.KeePassXC") },
        new() { Name = "Malwarebytes", Id = "Malwarebytes.Malwarebytes", Categories = ["security"], Desc = GetLocalizedDesc("Malwarebytes.Malwarebytes") },
    ];

    public static List<CategoryInfo> GetCategories() =>
    [
        new() { Key = "all", Label = LocalizationService.Get("cat_all"), Icon = "📦", Color = "#58A6FF" },
        new() { Key = "musthave", Label = LocalizationService.Get("cat_musthave"), Icon = "⭐", Color = "#F0883E" },
        new() { Key = "browser", Label = LocalizationService.Get("cat_browser"), Icon = "🌐", Color = "#3FB950" },
        new() { Key = "archive", Label = LocalizationService.Get("cat_archive"), Icon = "📁", Color = "#A371F7" },
        new() { Key = "media", Label = LocalizationService.Get("cat_media"), Icon = "🎵", Color = "#F778BA" },
        new() { Key = "office", Label = LocalizationService.Get("cat_office"), Icon = "📝", Color = "#79C0FF" },
        new() { Key = "dev", Label = LocalizationService.Get("cat_dev"), Icon = "💻", Color = "#D2A8FF" },
        new() { Key = "comm", Label = LocalizationService.Get("cat_comm"), Icon = "💬", Color = "#56D364" },
        new() { Key = "utility", Label = LocalizationService.Get("cat_utility"), Icon = "🔧", Color = "#E3B341" },
        new() { Key = "gaming", Label = LocalizationService.Get("cat_gaming"), Icon = "🎮", Color = "#FF7B72" },
        new() { Key = "security", Label = LocalizationService.Get("cat_security"), Icon = "🛡️", Color = "#7EE787" },
    ];
}
