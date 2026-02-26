using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using KrgzAppInstaller.Models;
using KrgzAppInstaller.Services;
using L = KrgzAppInstaller.Services.LocalizationService;

namespace KrgzAppInstaller;

public partial class MainWindow : Window
{
    private List<AppInfo> _apps = null!;
    private List<CategoryInfo> _categories = null!;
    private string _currentCategory = "all";
    private bool _isInstalling;
    private CancellationTokenSource? _installCts;

    // UI element maps
    private readonly Dictionary<string, Border> _appBorders = new();
    private readonly Dictionary<string, CheckBox> _appCheckBoxes = new();
    private readonly Dictionary<string, Border> _appStatusDots = new();
    private readonly Dictionary<string, TextBlock> _appDescBlocks = new();
    private readonly Dictionary<string, Button> _sidebarButtons = new();

    // Status data
    private AppStatusResult? _statusResult;
    private readonly HashSet<string> _justInstalled = new(StringComparer.OrdinalIgnoreCase);

    // Brushes — WinUI Dark Theme
    private static readonly SolidColorBrush BgCard = Br("#2D2D2D");
    private static readonly SolidColorBrush BgCardHover = Br("#383838");
    private static readonly SolidColorBrush BgSidebarActive = Br("#2D2D2D");
    private static readonly SolidColorBrush BorderDefault = Br("#3D3D3D");
    private static readonly SolidColorBrush BorderHover = Br("#5D5D5D");
    private static readonly SolidColorBrush FgPrimary = Br("#FFFFFF");
    private static readonly SolidColorBrush FgSecondary = Br("#9E9E9E");
    private static readonly SolidColorBrush FgMuted = Br("#6E6E6E");
    private static readonly SolidColorBrush StatusGreen = Br("#6CCB5F");
    private static readonly SolidColorBrush StatusYellow = Br("#FCE100");
    private static readonly SolidColorBrush StatusBlue = Br("#60CDFF");
    private static readonly SolidColorBrush StatusRed = Br("#FF99A4");
    private static readonly SolidColorBrush TransparentBrush = Brushes.Transparent;

    private static SolidColorBrush Br(string hex)
    {
        var b = new SolidColorBrush((Color)ColorConverter.ConvertFromString(hex));
        b.Freeze();
        return b;
    }

    public MainWindow()
    {
        InitializeComponent();

        // Setup language selector
        SetupLanguageSelector();

        // Build UI
        RebuildUI();

        // Listen for language changes
        L.LanguageChanged += OnLanguageChanged;

        Loaded += async (_, _) => await CheckAppStatusAsync();
    }

    private void SetupLanguageSelector()
    {
        cmbLang.Items.Clear();
        foreach (var lang in L.AvailableLanguages)
        {
            cmbLang.Items.Add(new ComboBoxItem { Content = lang.Name, Tag = lang.Code });
        }
        // Select current
        for (int i = 0; i < cmbLang.Items.Count; i++)
        {
            if (((ComboBoxItem)cmbLang.Items[i]).Tag as string == L.CurrentLanguage)
            {
                cmbLang.SelectedIndex = i;
                break;
            }
        }
    }

    private void CmbLang_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (!IsLoaded) return;
        if (cmbLang.SelectedItem is ComboBoxItem item && item.Tag is string code)
        {
            L.SetLanguage(code);
        }
    }

    private void OnLanguageChanged()
    {
        RebuildUI();
        ApplyStaticTexts();
        // Re-apply status
        if (_statusResult != null)
            UpdateStatusBar();
    }

    private void RebuildUI()
    {
        // Reload catalog with new language
        _apps = AppCatalog.GetAllApps();
        _categories = AppCatalog.GetCategories();
        _currentCategory = "all";

        // Clear and rebuild
        pnlSidebar.Children.Clear();
        pnlApps.Children.Clear();
        _appBorders.Clear();
        _appCheckBoxes.Clear();
        _appStatusDots.Clear();
        _appDescBlocks.Clear();
        _sidebarButtons.Clear();

        BuildSidebar();
        BuildAppCards();
        ApplyStaticTexts();
        UpdateSelectedCount();

        // Re-apply status dots if available
        if (_statusResult != null)
            UpdateAppStatusUI();
    }

    private void ApplyStaticTexts()
    {
        Title = L.Get("app_title");
        txtTitle.Text = L.Get("app_title");
        txtVersion.Text = L.Get("version_badge");
        txtSilent.Text = L.Get("silent_install");
        txtSearchHint.Text = L.Get("search_placeholder");

        // Filter combobox
        var filterIdx = cmbFilter.SelectedIndex;
        cmbFilter.Items.Clear();
        cmbFilter.Items.Add(new ComboBoxItem { Content = L.Get("filter_all") });
        cmbFilter.Items.Add(new ComboBoxItem { Content = L.Get("filter_installed") });
        cmbFilter.Items.Add(new ComboBoxItem { Content = L.Get("filter_not_installed") });
        cmbFilter.Items.Add(new ComboBoxItem { Content = L.Get("filter_update") });
        cmbFilter.SelectedIndex = filterIdx >= 0 ? filterIdx : 0;

        btnSelectAll.Content = L.Get("btn_select_all");
        btnDeselectAll.Content = L.Get("btn_deselect");
        if (!_isInstalling)
            btnInstall.Content = L.Get("btn_install");
        btnCancel.Content = L.Get("btn_cancel");
        txtStatus.Text = L.Get("status_ready");
    }

    // ═══════════════════════════════════════════
    // SIDEBAR
    // ═══════════════════════════════════════════
    private void BuildSidebar()
    {
        foreach (var cat in _categories)
        {
            var count = cat.Key == "all"
                ? _apps.Count
                : _apps.Count(a => a.Categories.Contains(cat.Key));

            var btn = new Button
            {
                Content = $"{cat.Icon}  {cat.Label} ({count})",
                Tag = cat.Key,
                Style = (Style)FindResource("BtnSidebar"),
                Background = cat.Key == "all" ? BgSidebarActive : TransparentBrush,
                BorderBrush = cat.Key == "all" ? Br(cat.Color) : TransparentBrush,
                Foreground = cat.Key == "all" ? FgPrimary : FgSecondary
            };

            btn.Click += (s, _) =>
            {
                var clickedKey = (string)((Button)s!).Tag;
                _currentCategory = clickedKey;

                foreach (var kv in _sidebarButtons)
                {
                    var info = _categories.First(c => c.Key == kv.Key);
                    if (kv.Key == clickedKey)
                    {
                        kv.Value.Background = BgSidebarActive;
                        kv.Value.BorderBrush = Br(info.Color);
                        kv.Value.Foreground = FgPrimary;
                    }
                    else
                    {
                        kv.Value.Background = TransparentBrush;
                        kv.Value.BorderBrush = TransparentBrush;
                        kv.Value.Foreground = FgSecondary;
                    }
                }
                UpdateAppVisibility();
            };

            pnlSidebar.Children.Add(btn);
            _sidebarButtons[cat.Key] = btn;
        }

        // Separator
        var sep = new Separator
        {
            Margin = new Thickness(8, 12, 8, 12),
            Background = BorderDefault
        };
        pnlSidebar.Children.Add(sep);

        // Microsoft Office Button
        var btnOffice = new Button
        {
            Content = L.Get("sidebar_office"),
            Style = (Style)FindResource("BtnSidebar"),
            Background = TransparentBrush,
            BorderBrush = TransparentBrush,
            Foreground = Br("#60CDFF")
        };
        btnOffice.Click += (_, _) =>
        {
            var officeWindow = new OfficeInstallWindow { Owner = this };
            officeWindow.ShowDialog();
        };
        pnlSidebar.Children.Add(btnOffice);

        // App Removal Button
        var btnRemove = new Button
        {
            Content = L.Get("sidebar_remove"),
            Style = (Style)FindResource("BtnSidebar"),
            Background = TransparentBrush,
            BorderBrush = TransparentBrush,
            Foreground = StatusRed
        };
        btnRemove.Click += (_, _) =>
        {
            var removalWindow = new AppRemovalWindow { Owner = this };
            removalWindow.ShowDialog();
        };
        pnlSidebar.Children.Add(btnRemove);
    }

    // ═══════════════════════════════════════════
    // APP CARDS
    // ═══════════════════════════════════════════
    private void BuildAppCards()
    {
        foreach (var app in _apps)
        {
            var key = GetAppKey(app);

            var border = new Border
            {
                Background = BgCard,
                CornerRadius = new CornerRadius(6),
                Margin = new Thickness(0, 3, 0, 3),
                Padding = new Thickness(0, 0, 14, 0),
                BorderBrush = BorderDefault,
                BorderThickness = new Thickness(1),
                Cursor = Cursors.Hand
            };

            var grid = new Grid();
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(4) });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            // Status dot (left strip)
            var statusDot = new Border
            {
                Width = 4,
                CornerRadius = new CornerRadius(2),
                Background = TransparentBrush,
                VerticalAlignment = VerticalAlignment.Stretch
            };
            Grid.SetColumn(statusDot, 0);

            // Checkbox
            var cb = new CheckBox
            {
                VerticalAlignment = VerticalAlignment.Center,
                Margin = new Thickness(10, 0, 12, 0)
            };
            Grid.SetColumn(cb, 1);
            cb.Checked += (_, _) => UpdateSelectedCount();
            cb.Unchecked += (_, _) => UpdateSelectedCount();

            // Text panel
            var textPanel = new StackPanel { VerticalAlignment = VerticalAlignment.Center };
            Grid.SetColumn(textPanel, 2);

            var nameBlock = new TextBlock
            {
                Text = app.Name,
                FontSize = 14,
                FontWeight = FontWeights.SemiBold,
                Foreground = FgPrimary
            };

            var descBlock = new TextBlock
            {
                Text = app.Desc,
                FontSize = 11.5,
                Foreground = FgSecondary,
                Margin = new Thickness(0, 2, 0, 0)
            };

            textPanel.Children.Add(nameBlock);
            textPanel.Children.Add(descBlock);

            // ID block
            var idBlock = new TextBlock
            {
                Text = app.Id,
                VerticalAlignment = VerticalAlignment.Center,
                FontSize = 11,
                Foreground = FgMuted
            };
            Grid.SetColumn(idBlock, 3);

            grid.Children.Add(statusDot);
            grid.Children.Add(cb);
            grid.Children.Add(textPanel);
            grid.Children.Add(idBlock);
            border.Child = grid;

            // Hover
            border.MouseEnter += (s, _) =>
            {
                var b = (Border)s!;
                b.Background = BgCardHover;
                b.BorderBrush = BorderHover;
            };
            border.MouseLeave += (s, _) =>
            {
                var b = (Border)s!;
                b.Background = BgCard;
                b.BorderBrush = BorderDefault;
            };

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
            _appBorders[key] = border;
            _appCheckBoxes[key] = cb;
            _appStatusDots[key] = statusDot;
            _appDescBlocks[key] = descBlock;
        }
    }

    // ═══════════════════════════════════════════
    // FILTERING
    // ═══════════════════════════════════════════
    private void UpdateAppVisibility()
    {
        if (txtSearch == null || cmbFilter == null) return;
        var searchText = txtSearch.Text.Trim().ToLowerInvariant();
        var filterIndex = cmbFilter.SelectedIndex;

        foreach (var app in _apps)
        {
            var key = GetAppKey(app);
            if (!_appBorders.TryGetValue(key, out var border)) continue;

            var catMatch = _currentCategory == "all" || app.Categories.Contains(_currentCategory);
            var searchMatch = string.IsNullOrEmpty(searchText) ||
                              app.Name.Contains(searchText, StringComparison.OrdinalIgnoreCase) ||
                              app.Desc.Contains(searchText, StringComparison.OrdinalIgnoreCase) ||
                              app.Id.Contains(searchText, StringComparison.OrdinalIgnoreCase);

            var filterMatch = true;
            if (filterIndex > 0 && _statusResult != null)
            {
                var isInstalled = _statusResult.InstalledIds.Contains(app.Id);
                var hasUpgrade = _statusResult.UpgradeIds.Contains(app.Id);
                filterMatch = filterIndex switch
                {
                    1 => isInstalled,
                    2 => !isInstalled,
                    3 => hasUpgrade,
                    _ => true
                };
            }

            border.Visibility = catMatch && searchMatch && filterMatch
                ? Visibility.Visible
                : Visibility.Collapsed;
        }
    }

    private void UpdateSelectedCount()
    {
        var count = _appCheckBoxes.Values.Count(cb => cb.IsChecked == true);
        txtSelected.Text = L.Get("selected_count", count);
    }

    // ═══════════════════════════════════════════
    // EVENTS
    // ═══════════════════════════════════════════
    private void TxtSearch_TextChanged(object sender, TextChangedEventArgs e)
    {
        if (txtSearchHint == null || txtSearch == null) return;
        txtSearchHint.Visibility = string.IsNullOrEmpty(txtSearch.Text)
            ? Visibility.Visible
            : Visibility.Collapsed;
        UpdateAppVisibility();
    }

    private void CmbFilter_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (!IsLoaded) return;
        UpdateAppVisibility();
    }

    private void BtnSelectAll_Click(object sender, RoutedEventArgs e)
    {
        foreach (var app in _apps)
        {
            var key = GetAppKey(app);
            if (_appBorders.TryGetValue(key, out var border) &&
                border.Visibility == Visibility.Visible &&
                _appCheckBoxes.TryGetValue(key, out var cb))
            {
                cb.IsChecked = true;
            }
        }
    }

    private void BtnDeselectAll_Click(object sender, RoutedEventArgs e)
    {
        foreach (var cb in _appCheckBoxes.Values)
            cb.IsChecked = false;
    }

    private void BtnCancel_Click(object sender, RoutedEventArgs e)
    {
        _installCts?.Cancel();
    }

    private async void BtnInstall_Click(object sender, RoutedEventArgs e)
    {
        if (_isInstalling) return;

        // Collect selected apps
        var selectedApps = new List<AppInfo>();
        var seenIds = new HashSet<string>();

        foreach (var app in _apps)
        {
            var key = GetAppKey(app);
            if (_appCheckBoxes.TryGetValue(key, out var cb) && cb.IsChecked == true)
            {
                if (seenIds.Add(app.Id))
                    selectedApps.Add(app);
            }
        }

        if (selectedApps.Count == 0)
        {
            MessageBox.Show(L.Get("msg_select_app"), L.Get("msg_warning"), MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        // Check winget
        if (!WingetService.IsWingetAvailable())
        {
            var result = MessageBox.Show(
                L.Get("msg_winget_not_found"),
                L.Get("msg_winget_required"),
                MessageBoxButton.YesNo,
                MessageBoxImage.Question);

            if (result == MessageBoxResult.Yes)
            {
                txtStatus.Text = L.Get("msg_winget_installing");
                var installed = await WingetService.InstallWingetAsync();
                if (!installed)
                {
                    MessageBox.Show(L.Get("msg_winget_failed"),
                        L.Get("msg_error"), MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }
            else return;
        }

        // Prepare UI
        _isInstalling = true;
        btnInstall.IsEnabled = false;
        btnInstall.Content = L.Get("btn_installing");
        btnCancel.Visibility = Visibility.Visible;
        btnSelectAll.IsEnabled = false;
        btnDeselectAll.IsEnabled = false;

        prgProgress.Maximum = selectedApps.Count;
        prgProgress.Value = 0;

        _installCts = new CancellationTokenSource();

        var progress = new Progress<InstallProgress>(p =>
        {
            txtStatus.Text = p.Status;
            prgProgress.Value = p.CurrentIndex;
        });

        bool silent = chkSilent.IsChecked == true;

        // Run installation
        var installResult = await Task.Run(() =>
            WingetService.InstallAppsAsync(selectedApps, silent, progress, _installCts.Token));

        // Finish UI
        prgProgress.Value = selectedApps.Count;

        var cCount = installResult.Completed.Count;
        var fCount = installResult.Failed.Count;

        if (installResult.WasCancelled)
            txtStatus.Text = L.Get("status_cancelled", cCount, fCount);
        else
            txtStatus.Text = L.Get("status_completed", cCount, fCount);

        var summary = L.Get("msg_install_done") + "\n";
        if (cCount > 0) summary += L.Get("msg_install_success", cCount, string.Join(", ", installResult.Completed)) + "\n";
        if (fCount > 0) summary += L.Get("msg_install_failed", fCount, string.Join(", ", installResult.Failed));

        MessageBox.Show(summary, L.Get("msg_install_result"), MessageBoxButton.OK, MessageBoxImage.Information);

        _isInstalling = false;
        btnInstall.IsEnabled = true;
        btnInstall.Content = L.Get("btn_install");
        btnCancel.Visibility = Visibility.Collapsed;
        btnSelectAll.IsEnabled = true;
        btnDeselectAll.IsEnabled = true;

        // Clear selections
        foreach (var cb in _appCheckBoxes.Values)
            cb.IsChecked = false;
        UpdateSelectedCount();

        // Mark just installed
        _justInstalled.Clear();
        foreach (var name in installResult.Completed)
            _justInstalled.Add(name);

        // Refresh status
        await CheckAppStatusAsync();
    }

    // ═══════════════════════════════════════════
    // APP STATUS
    // ═══════════════════════════════════════════
    private async Task CheckAppStatusAsync()
    {
        txtStatus.Text = L.Get("status_checking");

        _statusResult = await Task.Run(WingetService.CheckAppStatusAsync);

        UpdateAppStatusUI();
        UpdateStatusBar();
    }

    private void UpdateStatusBar()
    {
        if (_statusResult == null || _isInstalling) return;
        var catalogIds = _apps.Select(a => a.Id).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var installedCount = _statusResult.InstalledIds.Count(id => catalogIds.Contains(id));
        var upgradeCount = _statusResult.UpgradeIds.Count(id => catalogIds.Contains(id));
        txtStatus.Text = L.Get("status_ready_detail", installedCount, upgradeCount);
    }

    private void UpdateAppStatusUI()
    {
        foreach (var app in _apps)
        {
            var key = GetAppKey(app);
            if (!_appStatusDots.TryGetValue(key, out var dot)) continue;

            if (_justInstalled.Contains(app.Name))
                dot.Background = StatusBlue;
            else if (_statusResult?.UpgradeIds.Contains(app.Id) == true)
                dot.Background = StatusYellow;
            else if (_statusResult?.InstalledIds.Contains(app.Id) == true)
                dot.Background = StatusGreen;
            else
                dot.Background = TransparentBrush;
        }
    }

    // ═══════════════════════════════════════════
    // HELPERS
    // ═══════════════════════════════════════════
    private static string GetAppKey(AppInfo app)
        => $"{app.Id}_{string.Join("_", app.Categories)}";
}