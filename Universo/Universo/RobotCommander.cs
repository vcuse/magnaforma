using System;
using System.Net.Sockets;
using System.Net;
using System.IO;
using Abb.Egm;
using Google.Protobuf;

namespace Universo
{
    public class RobotCommander
    {
        //initiate variables for setting up server communication

        int egmPort; // Port where communication is established
        private UdpClient egmClient; // Client instance listening to the robot controller
        private IPEndPoint egmController; // Network endpoint representing the robot controller
        private EgmRobot egmRobot;

        private uint messageNumber = 0; // Used to identify the sequence of messages sent

        public RobotCommander(int port)
        /*
         Description: 
            Class constructor which initializes ipaddress and port values
         Inputs: 
            myport - UDP port which matches the UDP port setup in Robot Studio

         */
        {
            egmPort = port;
            InitializeRobotCommunication();
        }

        private void InitializeRobotCommunication()
        /*
         Description: 
           Opens up a UDP server on the designated port.
         */
        {
            egmClient = new UdpClient(egmPort);
            egmController = new IPEndPoint(IPAddress.Any, egmPort);
        }

        private void GetRobotInformation()
        /*
         Description: 
            Function utilized to read position data from the robot. 
            Variables xC, yC, and ZC denote the cartesian position of the robot. 
            Variables xR, yR, and zR denote the rotational position of the robot about the 
            designated axis.   
         */
        {
            // get the message from robot
            byte[] datagram = egmClient.Receive(ref egmController);

            if (datagram != null)
            {
                // de-serialize inbound message from robot
                egmRobot = new EgmRobot();
                egmRobot.MergeFrom(datagram); //needs Google.Protobuf
            }
        }

        public string GetRobotState()
        {
            GetRobotInformation();
            return egmRobot.MciState.State.ToString();
        }

        public (double, double, double, double, double, double) GetRobotPosition()
        {
            double x, y, z, rX, rY, rZ;

            GetRobotInformation();

            if (egmRobot.Header.HasSeqno && egmRobot.Header.HasTm && egmRobot.Header.HasMtype)
            {
                x = egmRobot.FeedBack.Cartesian.Pos.X;
                y = egmRobot.FeedBack.Cartesian.Pos.Y;
                z = egmRobot.FeedBack.Cartesian.Pos.Z;
                rX = egmRobot.FeedBack.Cartesian.Euler.X;
                rY = egmRobot.FeedBack.Cartesian.Euler.Y;
                rZ = egmRobot.FeedBack.Cartesian.Euler.Z;

                return (x, y, z, rX, rY, rZ);
            }

            return (0, 0, 0, 0, 0, 0);
        }

        private void SendRobotInformation(EgmSensor sensor)
        /*
         Description:
           Function utilized to send a data packet created using the CreateSensorMessage() function. 
           This data packet is sent on the UDP port opened in the SensorThread() function. 
         */
        {
            MemoryStream memoryStream;

            using (memoryStream = new MemoryStream())
            {
                EgmSensor _sensor = sensor;
                _sensor.WriteTo(memoryStream);

                try
                {
                    int bytesSent = egmClient.Send(memoryStream.ToArray(), (int)memoryStream.Length, egmController);
                }
                catch (Exception e)
                {
                    Console.WriteLine("An exception was found while sending message to robot:" + e.ToString());
                }
            }
        }

        private EgmSensor BuildMovementMessage(double x, double y, double z, double rX, double rY, double rZ)
        /*
         Description: 
            Function utilized to create a UDP data packet that includes: 
                1. Header -- Sequence Number (Seqno),TimeStamp (Tm), MessageType (Mtype)
                2. Body -- Data
         This data contains a Translational Cartesian movement and a Euler Cartesian movement.
             Translational x = tcp_p.X
             Translational y = tcp_p.Y
             Translational z = tcp_p.Z
             Rotational x = ea_p.X
             Rotational y = ea_p.Y
             Rotational z = ea_p.Z
         
         Inputs: 
         empty UDP packet (of type EgmSensor)
         Outputs:
         Returns filled version of UDP packet (sensor)
         */
        {
            EgmSensor sensor = new EgmSensor();

            EgmHeader header = new EgmHeader();
            header.Seqno = messageNumber++;
            header.Tm = (uint) DateTime.Now.Ticks;
            header.Mtype = EgmHeader.Types.MessageType.MsgtypeCorrection;

            EgmCartesian translation = new EgmCartesian(); // Based on the tool center point
            EgmEuler rotation = new EgmEuler();

            translation.X = x;
            translation.Y = y;
            translation.Z = z;

            rotation.X = rX;
            rotation.Y = rY;
            rotation.Z = rZ;

            EgmPose cartesian_values = new EgmPose();
            cartesian_values.Pos = translation;
            cartesian_values.Euler = rotation;

            EgmPlanned planned_trajectory = new EgmPlanned();
            planned_trajectory.Cartesian = cartesian_values;

            sensor.Header = header;
            sensor.Planned = planned_trajectory;

            return sensor;
        }

        /*
         All function below have a similar use case. 
        The name denotes the type of movement and axis that this movement will take place on.
        move = translational movement
        rotate = rotational movement (euler)
        Inputs: 
        All function take an int input called deviation. 
        The magnitude of int deviation denotes how quickly the robot will move 
        and the sign of int deviation denotes which direction the robot will move.        
         
        Each function receives the current position status of the robot and then 
        creates new coordinates that are separated by int deviation from the current position/
        The function then sends a datapacket that instructs Robot studio to move to this new position
        The stay function holds the robot in its current position 
         */

        public void TranslateRobot(double dX, double dY, double dZ)
        {
            var (x, y, z, rX, rY, rZ) = GetRobotPosition();

            x = x + dX;
            y = y + dY;
            z = z + dZ;

            EgmSensor sensor = BuildMovementMessage(x, y, z, rX, rY, rZ);
            SendRobotInformation(sensor);
        }

        public void RotateRobot(double dX, double dY, double dZ)
        {
            var (x, y, z, rX, rY, rZ) = GetRobotPosition();

            rX = rX + dX;
            rY = rY + dY;
            rZ = rZ + dZ;

            EgmSensor sensor = BuildMovementMessage(x, y, z, rX, rY, rZ);
            SendRobotInformation(sensor);
        }
    }
}
