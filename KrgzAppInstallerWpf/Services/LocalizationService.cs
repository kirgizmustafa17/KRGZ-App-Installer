using System.IO;
using System.Text.Json;

namespace KrgzAppInstaller.Services;

public class LanguageInfo
{
    public required string Code { get; set; }
    public required string Name { get; set; }
    public required string FilePath { get; set; }
}

public static class LocalizationService
{
    private static Dictionary<string, string> _strings = new();
    private static string _currentLang = "tr";
    private static readonly List<LanguageInfo> _availableLanguages = [];

    public static event Action? LanguageChanged;

    public static string CurrentLanguage => _currentLang;
    public static IReadOnlyList<LanguageInfo> AvailableLanguages => _availableLanguages;

    /// <summary>
    /// Get a localized string by key. Supports {0}, {1}... placeholders via args.
    /// Usage: L["key"] or L("key", arg1, arg2)
    /// </summary>
    public static string Get(string key, params object[] args)
    {
        if (_strings.TryGetValue(key, out var value))
        {
            return args.Length > 0 ? string.Format(value, args) : value;
        }
        return $"[{key}]"; // Missing key indicator
    }

    /// <summary>
    /// Shorthand access: L.S["key"] or L.S.Format("key", arg1)
    /// </summary>
    public static readonly Localizer S = new();

    public class Localizer
    {
        public string this[string key] => Get(key);
        public string Format(string key, params object[] args) => Get(key, args);
    }

    /// <summary>
    /// Discover all language files in the Languages folder and load the default language.
    /// </summary>
    public static void Initialize(string? preferredLang = null)
    {
        DiscoverLanguages();

        var lang = preferredLang ?? "tr";
        if (!_availableLanguages.Any(l => l.Code == lang))
            lang = _availableLanguages.FirstOrDefault()?.Code ?? "tr";

        LoadLanguage(lang);
    }

    /// <summary>
    /// Switch to a different language at runtime.
    /// </summary>
    public static void SetLanguage(string langCode)
    {
        if (langCode == _currentLang) return;
        LoadLanguage(langCode);
        LanguageChanged?.Invoke();
    }

    private static void DiscoverLanguages()
    {
        _availableLanguages.Clear();

        var langDir = GetLanguagesDirectory();
        if (!Directory.Exists(langDir)) return;

        foreach (var file in Directory.GetFiles(langDir, "*.json"))
        {
            try
            {
                var json = File.ReadAllText(file);
                var dict = JsonSerializer.Deserialize<Dictionary<string, string>>(json);
                if (dict == null) continue;

                var code = dict.GetValueOrDefault("_lang_code", Path.GetFileNameWithoutExtension(file));
                var name = dict.GetValueOrDefault("_lang_name", code);

                _availableLanguages.Add(new LanguageInfo
                {
                    Code = code,
                    Name = name,
                    FilePath = file
                });
            }
            catch { }
        }
    }

    private static void LoadLanguage(string langCode)
    {
        var langInfo = _availableLanguages.FirstOrDefault(l => l.Code == langCode);
        if (langInfo == null) return;

        try
        {
            var json = File.ReadAllText(langInfo.FilePath);
            var dict = JsonSerializer.Deserialize<Dictionary<string, string>>(json);
            if (dict != null)
            {
                _strings = dict;
                _currentLang = langCode;
            }
        }
        catch { }
    }

    private static string GetLanguagesDirectory()
    {
        // Check next to the executable first
        var exeDir = AppDomain.CurrentDomain.BaseDirectory;
        var langDir = Path.Combine(exeDir, "Languages");
        if (Directory.Exists(langDir)) return langDir;

        // Fallback: check project directory (for development)
        var devDir = Path.Combine(Directory.GetCurrentDirectory(), "Languages");
        if (Directory.Exists(devDir)) return devDir;

        return langDir;
    }
}
