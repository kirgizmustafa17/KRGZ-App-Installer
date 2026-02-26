using System.Globalization;
using System.Windows;
using System.Windows.Data;
using System.Windows.Media;
using KrgzAppInstaller.Models;

namespace KrgzAppInstaller.Converters;

public class BoolToVisibilityConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        bool bValue = (bool)value;
        if (parameter?.ToString() == "Invert") bValue = !bValue;
        return bValue ? Visibility.Visible : Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return (Visibility)value == Visibility.Visible;
    }
}

public class StatusToColorConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value is AppStatus status)
        {
            return status switch
            {
                AppStatus.Installed => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#238636")),
                AppStatus.UpdateAvailable => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#E3B341")),
                AppStatus.JustInstalled => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#58A6FF")),
                AppStatus.Installing => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#A371F7")),
                AppStatus.Failed => new SolidColorBrush((Color)ColorConverter.ConvertFromString("#FF7B72")),
                _ => Brushes.Transparent
            };
        }
        return Brushes.Transparent;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}

public class StringNotEmptyToVisibilityConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return string.IsNullOrEmpty(value as string) ? Visibility.Visible : Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
