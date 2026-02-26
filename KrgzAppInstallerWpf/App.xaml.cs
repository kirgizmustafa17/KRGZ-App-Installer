using System.Windows;
using KrgzAppInstaller.Services;

namespace KrgzAppInstaller;

public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        // Initialize localization FIRST
        try
        {
            LocalizationService.Initialize("tr");
        }
        catch
        {
            // Fallback — localization files might not be found
        }

        // Global exception handler
        DispatcherUnhandledException += (s, args) =>
        {
            var ex = args.Exception;
            var msg = ex.Message;
            while (ex.InnerException != null)
            {
                ex = ex.InnerException;
                msg += $"\n→ {ex.Message}";
            }
            msg += $"\n\n{args.Exception.StackTrace}";
            MessageBox.Show(msg, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            args.Handled = true;
        };
    }
}
