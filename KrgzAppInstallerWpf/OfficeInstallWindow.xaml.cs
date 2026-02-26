using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using KrgzAppInstaller.Services;

namespace KrgzAppInstaller;

public partial class OfficeInstallWindow : Window
{
    private readonly List<OfficeComponent> _components;
    private readonly Dictionary<string, CheckBox> _checkBoxes = new();

    public OfficeInstallWindow()
    {
        InitializeComponent();
        _components = OfficeService.GetComponents();
        BuildComponentList();
    }

    private void BuildComponentList()
    {
        foreach (var comp in _components)
        {
            var cb = new CheckBox
            {
                Content = $"  {comp.DisplayName}",
                Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#C9D1D9")),
                Margin = new Thickness(0, 6, 0, 6),
                FontSize = 14,
                IsChecked = comp.IsSelected
            };
            pnlOfficeApps.Children.Add(cb);
            _checkBoxes[comp.Name] = cb;
        }
    }

    private void BtnCancel_Click(object sender, RoutedEventArgs e)
    {
        DialogResult = false;
        Close();
    }

    private async void BtnInstall_Click(object sender, RoutedEventArgs e)
    {
        var selected = new List<OfficeComponent>();
        var excluded = new List<OfficeComponent>();

        foreach (var comp in _components)
        {
            if (_checkBoxes.TryGetValue(comp.Name, out var cb))
            {
                if (cb.IsChecked == true)
                    selected.Add(comp);
                else
                    excluded.Add(comp);
            }
        }

        if (selected.Count == 0)
        {
            txtStatus.Text = "En az bir uygulama seçmelisiniz!";
            txtStatus.Foreground = Brushes.Red;
            return;
        }

        var channelMap = new Dictionary<int, string>
        {
            { 0, "Current" },
            { 1, "MonthlyEnterprise" },
            { 2, "SemiAnnual" }
        };

        var channel = channelMap[cmbChannel.SelectedIndex];
        var arch = cmbArch.SelectedIndex == 0 ? "64" : "32";

        btnInstall.IsEnabled = false;
        btnCancel.IsEnabled = false;

        var progress = new Progress<string>(s =>
        {
            txtStatus.Text = s;
            txtStatus.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#E3B341"));
        });

        var result = await OfficeService.InstallOfficeAsync(selected, excluded, channel, arch, progress, CancellationToken.None);

        if (result == "OK")
        {
            txtStatus.Text = "Office başarıyla kuruldu!";
            txtStatus.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#3FB950"));
            MessageBox.Show("Microsoft Office başarıyla kuruldu!", "Başarılı", MessageBoxButton.OK, MessageBoxImage.Information);
        }
        else
        {
            txtStatus.Text = result;
            txtStatus.Foreground = Brushes.Red;
        }

        btnInstall.IsEnabled = true;
        btnCancel.IsEnabled = true;
    }
}
