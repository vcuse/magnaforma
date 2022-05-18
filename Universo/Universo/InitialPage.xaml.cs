using System;
using System.Windows;
using System.Windows.Controls;

namespace Universo
{
    /* InitialPage
     * Displays all the pages
     * and options for this application */

    public partial class InitialPage : Page
    {
        public InitialPage()
        {
            InitializeComponent();
        }

        private void OpenJoggingPage(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new Uri("Jogging.xaml", UriKind.Relative));
        }

    }
}
