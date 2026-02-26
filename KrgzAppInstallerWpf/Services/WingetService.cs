using System.Diagnostics;
using System.IO;
using System.Net.Http;
using KrgzAppInstaller.Models;

namespace KrgzAppInstaller.Services;

public class InstallProgress
{
    public int CurrentIndex { get; set; }
    public int TotalCount { get; set; }
    public string CurrentApp { get; set; } = "";
    public string Status { get; set; } = "";
}

public class InstallResult
{
    public List<string> Completed { get; } = [];
    public List<string> Failed { get; } = [];
    public bool WasCancelled { get; set; }
}

public class AppStatusResult
{
    public HashSet<string> InstalledIds { get; } = new(StringComparer.OrdinalIgnoreCase);
    public HashSet<string> UpgradeIds { get; } = new(StringComparer.OrdinalIgnoreCase);
}

public static class WingetService
{
    public static bool IsWingetAvailable()
    {
        try
        {
            var psi = new ProcessStartInfo("winget", "--version")
            {
                CreateNoWindow = true,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };
            using var proc = Process.Start(psi);
            proc?.WaitForExit(5000);
            return proc?.ExitCode == 0;
        }
        catch
        {
            return false;
        }
    }

    public static async Task<bool> InstallWingetAsync()
    {
        // Method 1: RegisterByFamilyName
        try
        {
            var psi = new ProcessStartInfo("powershell", "-Command \"Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\"")
            {
                CreateNoWindow = true,
                UseShellExecute = false
            };
            using var proc = Process.Start(psi);
            if (proc != null)
            {
                await proc.WaitForExitAsync();
                await Task.Delay(3000);
                if (IsWingetAvailable()) return true;
            }
        }
        catch { }

        // Method 2: Download from aka.ms/getwinget
        try
        {
            var tempPath = Path.Combine(Path.GetTempPath(), "Microsoft.DesktopAppInstaller.msixbundle");
            using var http = new HttpClient();
            var data = await http.GetByteArrayAsync("https://aka.ms/getwinget");
            await File.WriteAllBytesAsync(tempPath, data);

            var psi = new ProcessStartInfo("powershell", $"-Command \"Add-AppxPackage -Path '{tempPath}'\"")
            {
                CreateNoWindow = true,
                UseShellExecute = false
            };
            using var proc = Process.Start(psi);
            if (proc != null)
            {
                await proc.WaitForExitAsync();
                await Task.Delay(3000);
            }
            File.Delete(tempPath);
            return IsWingetAvailable();
        }
        catch
        {
            return false;
        }
    }

    public static async Task<InstallResult> InstallAppsAsync(
        List<AppInfo> apps,
        bool silent,
        IProgress<InstallProgress> progress,
        CancellationToken ct)
    {
        var result = new InstallResult();
        var total = apps.Count;

        for (int i = 0; i < apps.Count; i++)
        {
            if (ct.IsCancellationRequested)
            {
                result.WasCancelled = true;
                break;
            }

            var app = apps[i];
            progress.Report(new InstallProgress
            {
                CurrentIndex = i + 1,
                TotalCount = total,
                CurrentApp = app.Name,
                Status = $"[{i + 1}/{total}] Yükleniyor: {app.Name}"
            });

            try
            {
                var args = $"install --id {app.Id} --accept-package-agreements --accept-source-agreements --source winget";
                if (silent) args += " --silent";

                var psi = new ProcessStartInfo("winget", args)
                {
                    CreateNoWindow = true,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };

                using var proc = Process.Start(psi);
                if (proc != null)
                {
                    await proc.WaitForExitAsync(ct);
                    // 0 = success, -1978335189 = already installed
                    if (proc.ExitCode == 0 || proc.ExitCode == -1978335189)
                        result.Completed.Add(app.Name);
                    else
                        result.Failed.Add($"{app.Name} (kod: {proc.ExitCode})");
                }
            }
            catch (OperationCanceledException)
            {
                result.WasCancelled = true;
                break;
            }
            catch (Exception ex)
            {
                result.Failed.Add($"{app.Name} (hata: {ex.Message})");
            }
        }

        return result;
    }

    public static async Task<AppStatusResult> CheckAppStatusAsync()
    {
        var result = new AppStatusResult();

        // Get installed apps
        try
        {
            var output = await RunWingetCommandAsync("list --accept-source-agreements");
            ParseWingetOutput(output, result.InstalledIds);
        }
        catch { }

        // Get available upgrades
        try
        {
            var output = await RunWingetCommandAsync("upgrade --accept-source-agreements");
            ParseWingetOutput(output, result.UpgradeIds);
        }
        catch { }

        return result;
    }

    private static async Task<string> RunWingetCommandAsync(string args)
    {
        var psi = new ProcessStartInfo("winget", args)
        {
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true
        };

        using var proc = Process.Start(psi);
        if (proc == null) return "";

        var output = await proc.StandardOutput.ReadToEndAsync();
        await proc.WaitForExitAsync();
        return output;
    }

    private static void ParseWingetOutput(string output, HashSet<string> ids)
    {
        if (string.IsNullOrWhiteSpace(output)) return;

        var lines = output.Split('\n', StringSplitOptions.RemoveEmptyEntries);
        foreach (var line in lines)
        {
            var parts = System.Text.RegularExpressions.Regex.Split(line.Trim(), @"\s{2,}");
            if (parts.Length >= 2)
            {
                var id = parts[1].Trim();
                if (!string.IsNullOrEmpty(id) && id != "Id" && id.Contains('.'))
                {
                    ids.Add(id);
                }
            }
        }
    }
}
