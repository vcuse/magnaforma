clc, clear, close all, clear variables;


%% Stationary Waverider
scale = -250;  %constant used to scale translational movements. 
               %Also denotes the max value that delta_X and delta_Z will be displaced from starting position

maxangle = 20; %max angle that will take place during movements
cycles = 4; %constant used to control the amount of times movement will take place
delay = 0.5; %constant used to implement a small delay between angle of plane and its translational movement
             %this will introduce an almost organic effect in the movement

t = 0:0.09:cycles*2*pi; %t is used as the independent variables for these movements and also represents "time".
                        

restart = zeros([1 length(t)]); %restart is set to one at the beginning of each movement.
restart(1) = 1;                 %This variable is only important when linking together different movements.



delta_X = round(scale*cos(t)-scale,2); %delta_X controls the x movement of the robot
delta_Z = round(scale*sin(t),2); %delta_Z controls the z movement of the robot
Ry = round(maxangle*cos(t+delay),2); %Ry controls the robot's rotation about the y axis


speed = 500*ones([1 length(t)]); %all speed values are initialized to 500 mm/s

%The following for loop is used to make the speed of the robot dynamic
%For the waverider movement, the speed should increase as the robot
%descends and should lessen as the robot climbs
for i = 1:length(t)
     if(Ry(i)<=(-0.5*maxangle)) %if angle is lower than a certain angle
         speed(i) =800;   %set speed to high
     elseif(Ry(i)>(0.7*maxangle)) %if angle is higher than a certain angle
         speed(i) = 400; %set speed to low
     end
end


%make all other movement values zero
delta_Y = zeros([1 length(t)]);
Rz = zeros([1 length(t)]);
Rx = zeros([1 length(t)]);

mycsv = [Rx;Ry;Rz;delta_X;delta_Y;delta_Z;speed;restart]'; %place all matrices in a larger matrix
csvwrite('rotationvalues.csv',mycsv) %write matrix to csv file titled: 'rotationvalues.csv'

%The rotation values csv should be copied and pasted into the general
%universo folder where 'convert_to_rapid.py' may be used to convert the csv
%file to rapid code and place it in a text file titled "rapid_code.txt"
%This rapid code can then be copy and pasted into the Proc main function of
%rapid

%% Side Winder
% %make rotational speed 60
% 
% scale = 20; %constant used to scale translational movements. 
%             %Also denotes the max value that delta_X and delta_Z will be displaced from starting position
% maxangle = 1.5*scale; %max angle that will take place during movements
% delay = 2;
% 
% t = 0:0.09:15; %t is used as the independent variables for these movements and also represents "time".
% 
% delta_Y = round(scale*sin(t),2); %delta_Y controls the y movement of the robot
% delta_X= t*25; %delta_Y controls the y movement of the robot
% Rz = maxangle*sin(t+delay); %Rz controls the robot's rotation about the z axis
% 
% speed = 800*ones([1 length(t)]); %all speed values are initialized to 500 mm/s
% 
% %The following for loop is used to make the speed of the robot dynamic
% %For the Sidewinder movement, the speed increases as the robot rounds a
% %bend 
% for i = 1:length(t)
%     if(abs(Rz(i))<=(0.9*scale))
%         speed(i) =700;       
%     end
%     
% end
% 
% 
% 
% 
% Rx = zeros([1 length(t)]);
% Ry = zeros([1 length(t)]);
% %Rz = zeros([1 length(x)]);
% delta_Z = zeros([1 length(t)]);
% %delta_X = zeros([1 length(x)]);
% 
% restart = zeros([1 length(t)]);
% restart(1) = 1;
% 
% mycsv = [Rx;Ry;Rz;delta_X;delta_Y;delta_Z;speed;restart]';
% dlmwrite('rotationvalues.csv',mycsv,'delimiter',',','-append');

%% Tree

% x = 0:0.09:30;
% max = 30;
% delay = 0.3;
% 
% Rx = 30*sin(x).*exp(-0.01.*x);
% delta_Y = 20*sin(x+delay).*exp(-0.01.*(x+delay));
% newdelta_Z = 4*Rx+15*(x+delay);
% 
% figure;
% plot(x,delta_Y);
% hold on;
%     
% Ry = zeros([1 length(Rx)]);
% Rz = zeros([1 length(Rx)]);
% delta_X = zeros([1 length(Rx)]);
% delta_Y = round(delta_Y,2);
% 
% Rx = round(Rx,2);
% 
% speed = 400*ones([1 length(x)]);
% 
% for i = 1:length(Rx)
%     if(abs(delta_Y(i))>=(0.6*max*exp(-0.01*(x(i)+delay))))
%         speed(i) =200;       
%     end
%     
% end
% plot(x,speed);
% 
% restart = zeros([1 length(x)]);
% restart(1) = 1;
% 
% 
% mycsv = [Rx;Ry;Rz;delta_X;delta_Y;newdelta_Z;speed;restart]';
% csvwrite('rotationvalues.csv',mycsv) %first column is Rx (Roll), second column is Ry (Pitch)




%% Leaf
% max = 25;
% x = 0:0.09:5;
% delay = 0.3; 
% 
% delta_Y = round(25.*sin(2.*x),2);
% newdelta_Z = round(-1.*(140.*sin(4.*x)+180*x),2);
% Rx = -30*cos(2.*(x+delay));
% 
% 
% speed = 100*ones([1 length(x)]);
% %Rx = zeros([1 length(x)]);
% Ry = zeros([1 length(x)]);
% delta_X = zeros([1 length(x)]);
% Rz = zeros([1 length(x)]);
% 
% restart = zeros([1 length(x)]);
% restart(1) = 1;
% 
% 
% speed = 800*ones([1 length(x)]);
% 
% for i = 1:length(x)
%      if(abs(delta_Y(i))>=(.8*max))
%          speed(i) =300;   
%      elseif(abs(delta_Y(i))<(.8*max)&& abs(delta_Y(i))>=(0.7*max))
%          speed(i) = 700;
%      end
% end
% 
% 
% starting_Z = 1120;
% sum = newdelta_Z+1120;
% plot(x, delta_Y);
% 
% mycsv = [Rx;Ry;Rz;delta_X;delta_Y;newdelta_Z;speed;restart]';

%dlmwrite('rotationvalues.csv',mycsv,'delimiter',',','-append');
%csvwrite('rotationvalues.csv',mycsv)

 