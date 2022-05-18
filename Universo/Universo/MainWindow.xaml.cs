using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Shapes;

namespace Universo
{
    /* MainWindow
     * This window is responsible for displaying the pages
     * of our application. It does not contain any robot-related
     * tasks, only a toolbar and a frame which renders the pages.
     */
    public partial class MainWindow : Window
    {

        public MainWindow()
        {
            /* Initializes the window with a new page */
            InitializeComponent();
            InitialPage initialPage = new InitialPage();
            DisplayPage(this, initialPage);
        }

        private void DisplayPage(object sender, Page requestedPage)
        {
            /* Listener - receives a page request and display it on the MainWindow */
            this.Title = requestedPage.Title;
            MainWindowFrame.Content = requestedPage;
        }

        private void MinimizeMainWindow(object sender, RoutedEventArgs e)
        {
            /* Listener - Minimizes the main window then the minize button is used */
            this.WindowState = WindowState.Minimized;
        }

        private void CloseMainWindow(object sender, RoutedEventArgs e)
        {
            /* Listener - Closes the main window then the close button is used */
            this.Close();
        }

        private void dragWindow(object sender, MouseButtonEventArgs e)
        {
            DragMove();
        }
    }
}
