using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using KrgzAppInstaller.Services;

namespace KrgzAppInstaller;

public partial class AppRemovalWindow : Window
{
    private readonly Dictionary<string, CheckBox> _checkBoxes = new();
    private readonly Dictionary<string, Border> _borders = new();
    private readonly Dictionary<string, AppxPackageInfo> _packages = new();

    private static readonly SolidColorBrush BgDefault = Freeze("#0D1117");
    private static readonly SolidColorBrush BgHover = Freeze("#161B22");
    private static readonly SolidColorBrush FgName = Freeze("#F0F6FC");
    private static readonly SolidColorBrush FgVersion = Freeze("#6E7681");
    private static readonly SolidColorBrush FgType = Freeze("#484F58");

    private static SolidColorBrush Freeze(string hex)
    {
        var b = new SolidColorBrush((Color)ColorConverter.ConvertFromString(hex));
        b.Freeze();
        return b;
    }

    public AppRemovalWindow()
    {
        InitializeComponent();
        ContentRendered += async (_, _) => await LoadPackagesAsync();
    }

    private async Task LoadPackagesAsync()
    {
        pnlApps.Children.Clear();
        _checkBoxes.Clear();
        _borders.Clear();
        _packages.Clear();

        txtStatus.Text = "Uygulamalar yükleniyor...";

        var pkgs = await AppRemovalService.GetInstalledPackagesAsync();

        foreach (var pkg in pkgs)
        {
            var border = new Border
            {
                Background = BgDefault,
                CornerRadius = new CornerRadius(4),
                Margin = new Thickness(0, 1, 0, 1),
                Padding = new Thickness(10, 7, 10, 7),
                Cursor = Cursors.Hand
            };

            var grid = new Grid();
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            var cb = new CheckBox
            {
                VerticalAlignment = VerticalAlignment.Center,
                Margin = new Thickness(0, 0, 10, 0)
            };
            Grid.SetColumn(cb, 0);
            cb.Checked += (_, _) => UpdateSelectedCount();
            cb.Unchecked += (_, _) => UpdateSelectedCount();

            var textPanel = new StackPanel { VerticalAlignment = VerticalAlignment.Center };
            Grid.SetColumn(textPanel, 1);

            var nameBlock = new TextBlock
            {
                Text = pkg.Name,
                FontSize = 12.5,
                FontWeight = FontWeights.SemiBold,
                Foreground = FgName,
                TextTrimming = TextTrimming.CharacterEllipsis
            };

            var versionBlock = new TextBlock
            {
                Text = $"v{pkg.Version}",
                FontSize = 10.5,
                Foreground = FgVersion,
                Margin = new Thickness(0, 1, 0, 0)
            };

            textPanel.Children.Add(nameBlock);
            textPanel.Children.Add(versionBlock);

            var typeBlock = new TextBlock
            {
                Text = pkg.IsFramework ? "Framework" : "App",
                VerticalAlignment = VerticalAlignment.Center,
                FontSize = 10,
                Foreground = FgType
            };
            Grid.SetColumn(typeBlock, 2);

            grid.Children.Add(cb);
            grid.Children.Add(textPanel);
            grid.Children.Add(typeBlock);
            border.Child = grid;

            // Hover
            border.MouseEnter += (s, _) => ((Border)s!).Background = BgHover;
            border.MouseLeave += (s, _) => ((Border)s!).Background = BgDefault;

            // Click to toggle
            border.Tag = cb;
            border.MouseLeftButtonUp += (s, e) =>
            {
                if (e.OriginalSource is not CheckBox)
                {
                    var chk = (CheckBox)((Border)s!).Tag;
                    chk.IsChecked = !chk.IsChecked;
                }
            };

            pnlApps.Children.Add(border);
            _checkBoxes[pkg.Name] = cb;
            _borders[pkg.Name] = border;
            _packages[pkg.Name] = pkg;
        }

        txtStatus.Text = $"{pkgs.Count} uygulama listelendi.";
    }

    private void UpdateSelectedCount()
    {
        var count = _checkBoxes.Values.Count(cb => cb.IsChecked == true);
        txtSelected.Text = $"{count} seçili";
    }

    private void FilterApps()
    {
        var query = txtSearch.Text.Trim().ToLowerInvariant();
        foreach (var kv in _borders)
        {
            var visible = string.IsNullOrEmpty(query) || kv.Key.ToLowerInvariant().Contains(query);
            kv.Value.Visibility = visible ? Visibility.Visible : Visibility.Collapsed;
        }
    }

    // Events
    private void TxtSearch_TextChanged(object sender, TextChangedEventArgs e)
    {
        txtSearchHint.Visibility = string.IsNullOrEmpty(txtSearch.Text) ? Visibility.Visible : Visibility.Collapsed;
        FilterApps();
    }

    private void BtnSelectAll_Click(object sender, RoutedEventArgs e)
    {
        foreach (var kv in _borders)
        {
            if (kv.Value.Visibility == Visibility.Visible)
                _checkBoxes[kv.Key].IsChecked = true;
        }
    }

    private void BtnDeselectAll_Click(object sender, RoutedEventArgs e)
    {
        foreach (var cb in _checkBoxes.Values)
            cb.IsChecked = false;
    }

    private async void BtnRefresh_Click(object sender, RoutedEventArgs e)
    {
        await LoadPackagesAsync();
    }

    private void BtnClose_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private async void BtnRemove_Click(object sender, RoutedEventArgs e)
    {
        var toRemove = _checkBoxes
            .Where(kv => kv.Value.IsChecked == true)
            .Select(kv => _packages[kv.Key])
            .ToList();

        if (toRemove.Count == 0)
        {
            MessageBox.Show("Lütfen kaldırmak için en az bir uygulama seçin.", "Uyarı", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        var confirm = MessageBox.Show(
            $"{toRemove.Count} uygulama kaldırılacak. Devam edilsin mi?\n\nNot: Bu işlem sadece mevcut kullanıcı için geçerlidir (güvenli mod).",
            "Onay",
            MessageBoxButton.YesNo,
            MessageBoxImage.Warning);

        if (confirm != MessageBoxResult.Yes) return;

        btnRemove.IsEnabled = false;
        btnSelectAll.IsEnabled = false;
        btnDeselectAll.IsEnabled = false;

        var progress = new Progress<string>(s => txtStatus.Text = s);

        var (success, failed) = await AppRemovalService.RemovePackagesAsync(toRemove, progress, CancellationToken.None);

        txtStatus.Text = $"Tamamlandı. {success} başarılı, {failed} başarısız.";
        MessageBox.Show($"{success} uygulama başarıyla kaldırıldı.\n{failed} başarısız.", "Sonuç", MessageBoxButton.OK, MessageBoxImage.Information);

        btnRemove.IsEnabled = true;
        btnSelectAll.IsEnabled = true;
        btnDeselectAll.IsEnabled = true;

        await LoadPackagesAsync();
    }
}
