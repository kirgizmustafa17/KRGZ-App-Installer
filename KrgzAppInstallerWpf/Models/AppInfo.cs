namespace KrgzAppInstaller.Models;

public class AppInfo
{
    public required string Name { get; set; }
    public required string Id { get; set; }
    public required string[] Categories { get; set; }
    public required string Desc { get; set; }

    // UI state
    public bool IsSelected { get; set; }
    public AppStatus Status { get; set; } = AppStatus.Unknown;
}

public enum AppStatus
{
    Unknown,
    NotInstalled,
    Installed,
    UpdateAvailable,
    JustInstalled,
    Installing,
    Failed
}

public class CategoryInfo
{
    public required string Key { get; set; }
    public required string Label { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
}
