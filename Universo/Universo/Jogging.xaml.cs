using System;
using System.Windows.Controls;

namespace Universo
{
    /* JoggingPage
     * Implements buttons that 
     * manually control the robot */

    public partial class JoggingPage : Page
    {
        RobotCommander robotCommander;
        public JoggingPage()
        {
            InitializeComponent();
            robotCommander = new RobotCommander(6511);
        }

        private void onButtonClick(object sender, System.Windows.RoutedEventArgs e)
        {
            updatePositionLabels();
            Button _button = (Button) sender;
            int translationSpeed = Convert.ToInt32(TranslationSpeed.Text);
            int rotationSpeed = Convert.ToInt32(RotationSpeed.Text);

            switch (_button.Tag.ToString())
            {
                case "TranslateX+":
                    robotCommander.TranslateRobot(translationSpeed, 0, 0);
                    break;
                case "TranslateX-":
                    robotCommander.TranslateRobot(-translationSpeed, 0, 0);
                    break;
                case "TranslateY+":
                    robotCommander.TranslateRobot(0, translationSpeed, 0);
                    break;
                case "TranslateY-":
                    robotCommander.TranslateRobot(0, -translationSpeed, 0);
                    break;
                case "TranslateZ+":
                    robotCommander.TranslateRobot(0, 0, translationSpeed);
                    break;
                case "TranslateZ-":
                    robotCommander.TranslateRobot(0, 0, -translationSpeed);
                    break;
                case "RotateX+":
                    robotCommander.RotateRobot(rotationSpeed, 0, 0);
                    break;
                case "RotateX-":
                    robotCommander.RotateRobot(-rotationSpeed, 0, 0);
                    break;
                case "RotateY+":
                    robotCommander.RotateRobot(0, rotationSpeed, 0);
                    break;
                case "RotateY-":
                    robotCommander.RotateRobot(0, -rotationSpeed, 0);
                    break;
                case "RotateZ+":
                    robotCommander.RotateRobot(0, 0, rotationSpeed);
                    break;
                case "RotateZ-":
                    robotCommander.RotateRobot(0, 0, -rotationSpeed);
                    break;
            }
        }

        private void updatePositionLabels()
        {
            var (x, y, z, rX, rY, rZ) = robotCommander.GetRobotPosition();
            TranslationValues.Text = "X: " + Convert.ToInt32(x).ToString() + " Y: " + Convert.ToInt32(y).ToString() + " Z: " + Convert.ToInt32(z).ToString();
            RotationValues.Text = "X: " + Convert.ToInt32(rX).ToString() + " Y: " + Convert.ToInt32(rY).ToString() + " Z: " + Convert.ToInt32(rZ).ToString();
        }

    }
}
