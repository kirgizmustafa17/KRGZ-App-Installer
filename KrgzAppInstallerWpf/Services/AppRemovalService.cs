using System.Diagnostics;

namespace KrgzAppInstaller.Services;

public class AppxPackageInfo
{
    public required string Name { get; set; }
    public required string Version { get; set; }
    public required string PackageFullName { get; set; }
    public bool IsFramework { get; set; }
}

public static class AppRemovalService
{
    public static async Task<List<AppxPackageInfo>> GetInstalledPackagesAsync()
    {
        return await Task.Run(() =>
        {
            var packages = new List<AppxPackageInfo>();
            try
            {
                var psi = new ProcessStartInfo("powershell",
                    "-Command \"Get-AppxPackage | Select-Object Name,Version,PackageFullName,IsFramework | ConvertTo-Json -Compress\"")
                {
                    CreateNoWindow = true,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };

                using var proc = Process.Start(psi);
                if (proc == null) return packages;

                var output = proc.StandardOutput.ReadToEnd();
                proc.WaitForExit();

                if (string.IsNullOrWhiteSpace(output)) return packages;

                // Parse JSON
                var items = System.Text.Json.JsonSerializer.Deserialize<List<AppxJsonItem>>(output);
                if (items == null) return packages;

                foreach (var item in items)
                {
                    if (string.IsNullOrEmpty(item.Name)) continue;
                    packages.Add(new AppxPackageInfo
                    {
                        Name = item.Name,
                        Version = item.Version ?? "",
                        PackageFullName = item.PackageFullName ?? "",
                        IsFramework = item.IsFramework
                    });
                }
            }
            catch { }

            return packages.OrderBy(p => p.Name).ToList();
        });
    }

    public static async Task<(int success, int failed)> RemovePackagesAsync(
        List<AppxPackageInfo> packages,
        IProgress<string> progress,
        CancellationToken ct)
    {
        int success = 0;
        int failed = 0;
        int total = packages.Count;

        for (int i = 0; i < packages.Count; i++)
        {
            if (ct.IsCancellationRequested) break;

            var pkg = packages[i];
            progress.Report($"[{i + 1}/{total}] Kaldırılıyor: {pkg.Name}");

            try
            {
                var psi = new ProcessStartInfo("powershell",
                    $"-Command \"Remove-AppxPackage -Package '{pkg.PackageFullName}'\"")
                {
                    CreateNoWindow = true,
                    UseShellExecute = false
                };
                using var proc = Process.Start(psi);
                if (proc != null)
                {
                    await proc.WaitForExitAsync(ct);
                    if (proc.ExitCode == 0) success++;
                    else failed++;
                }
            }
            catch
            {
                failed++;
            }
        }

        return (success, failed);
    }

    private class AppxJsonItem
    {
        public string? Name { get; set; }
        public string? Version { get; set; }
        public string? PackageFullName { get; set; }
        public bool IsFramework { get; set; }
    }
}
