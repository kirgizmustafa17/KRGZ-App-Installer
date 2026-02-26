using System.Diagnostics;
using System.IO;
using System.Net.Http;

namespace KrgzAppInstaller.Services;

public class OfficeComponent
{
    public required string Name { get; set; }
    public required string DisplayName { get; set; }
    public bool IsSelected { get; set; }
}

public static class OfficeService
{
    public static List<OfficeComponent> GetComponents() =>
    [
        new() { Name = "Word", DisplayName = "Word - Kelime işlemci", IsSelected = true },
        new() { Name = "Excel", DisplayName = "Excel - Hesap tablosu", IsSelected = true },
        new() { Name = "PowerPoint", DisplayName = "PowerPoint - Sunum", IsSelected = true },
        new() { Name = "Outlook", DisplayName = "Outlook - E-posta istemcisi", IsSelected = false },
        new() { Name = "Access", DisplayName = "Access - Veritabanı", IsSelected = false },
        new() { Name = "Publisher", DisplayName = "Publisher - Masaüstü yayıncılık", IsSelected = false },
        new() { Name = "OneNote", DisplayName = "OneNote - Not alma", IsSelected = false },
        new() { Name = "Visio", DisplayName = "Visio - Diyagram oluşturma", IsSelected = false },
        new() { Name = "Project", DisplayName = "Project - Proje yönetimi", IsSelected = false },
    ];

    public static async Task<string> InstallOfficeAsync(
        List<OfficeComponent> selected,
        List<OfficeComponent> excluded,
        string channel,
        string arch,
        IProgress<string> progress,
        CancellationToken ct)
    {
        var odtDir = Path.Combine(Path.GetTempPath(), "ODT_KRGZ");
        Directory.CreateDirectory(odtDir);

        string? setupExe = null;

        // Check known paths
        var knownPaths = new[]
        {
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "OfficeDeploymentTool", "setup.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "OfficeDeploymentTool", "setup.exe"),
            Path.Combine(odtDir, "setup.exe")
        };

        foreach (var p in knownPaths)
        {
            if (File.Exists(p)) { setupExe = p; break; }
        }

        if (setupExe == null)
        {
            progress.Report("ODT kuruluyor (winget ile)...");

            // Method 1: winget
            try
            {
                var psi = new ProcessStartInfo("winget",
                    "install --id Microsoft.OfficeDeploymentTool --accept-package-agreements --accept-source-agreements --source winget --silent")
                {
                    CreateNoWindow = true,
                    UseShellExecute = false
                };
                using var proc = Process.Start(psi);
                if (proc != null) await proc.WaitForExitAsync(ct);
                await Task.Delay(2000, ct);

                foreach (var p in knownPaths)
                {
                    if (File.Exists(p)) { setupExe = p; break; }
                }
            }
            catch { }

            // Method 2: Download
            if (setupExe == null)
            {
                progress.Report("ODT indiriliyor (web)...");
                try
                {
                    var odtExe = Path.Combine(Path.GetTempPath(), "ODTSetup.exe");
                    using var http = new HttpClient();
                    var data = await http.GetByteArrayAsync("https://aka.ms/ODT", ct);
                    if (data.Length < 500_000)
                        return "İndirilen dosya geçersiz. Lütfen https://aka.ms/ODT adresinden manuel indirin.";

                    await File.WriteAllBytesAsync(odtExe, data, ct);

                    var extractPsi = new ProcessStartInfo("cmd.exe",
                        $"/c \"{odtExe}\" /quiet /extract:\"{odtDir}\"")
                    {
                        CreateNoWindow = true,
                        UseShellExecute = false
                    };
                    using var extractProc = Process.Start(extractPsi);
                    if (extractProc != null) await extractProc.WaitForExitAsync(ct);
                    File.Delete(odtExe);

                    var candidate = Path.Combine(odtDir, "setup.exe");
                    if (File.Exists(candidate)) setupExe = candidate;
                }
                catch (Exception ex)
                {
                    return $"ODT indirilemedi: {ex.Message}";
                }
            }

            if (setupExe == null)
                return "ODT setup.exe bulunamadı. Lütfen https://aka.ms/ODT adresinden manuel indirin.";
        }

        var odtFolder = Path.GetDirectoryName(setupExe)!;

        // Build config XML
        var excludeXml = string.Join("\n",
            excluded.Select(e => $"        <ExcludeApp ID=\"{e.Name}\" />"));

        var configXml = $"""
            <Configuration>
              <Add OfficeClientEdition="{arch}" Channel="{channel}">
                <Product ID="O365ProPlusRetail">
                  <Language ID="tr-TR" />
                  <Language ID="en-US" />
            {excludeXml}
                </Product>
              </Add>
              <Display Level="Full" AcceptEULA="TRUE" />
              <Updates Enabled="TRUE" />
            </Configuration>
            """;

        var configPath = Path.Combine(odtFolder, "configuration.xml");
        await File.WriteAllTextAsync(configPath, configXml, ct);

        // Download
        progress.Report("Office indiriliyor... (Bu işlem uzun sürebilir)");
        try
        {
            var dlPsi = new ProcessStartInfo(setupExe, $"/download \"{configPath}\"")
            {
                CreateNoWindow = false,
                UseShellExecute = false
            };
            using var dlProc = Process.Start(dlPsi);
            if (dlProc != null)
            {
                await dlProc.WaitForExitAsync(ct);
                if (dlProc.ExitCode != 0)
                    return $"İndirme hatası (kod: {dlProc.ExitCode})";
            }
        }
        catch (Exception ex)
        {
            return $"İndirme hatası: {ex.Message}";
        }

        // Install
        progress.Report("Office kuruluyor...");
        try
        {
            var instPsi = new ProcessStartInfo(setupExe, $"/configure \"{configPath}\"")
            {
                CreateNoWindow = false,
                UseShellExecute = false
            };
            using var instProc = Process.Start(instPsi);
            if (instProc != null)
            {
                await instProc.WaitForExitAsync(ct);
                if (instProc.ExitCode == 0)
                    return "OK";
                return $"Kurulum hatası (kod: {instProc.ExitCode})";
            }
        }
        catch (Exception ex)
        {
            return $"Kurulum hatası: {ex.Message}";
        }

        return "Bilinmeyen hata.";
    }
}
