clc, clear, close all, clear variables;

%% Universo Control Code
%Authored by: Gabriella Graziani
%Summer 2022

%% Process DEM
% This code aims to plot the surface of a DEM and find the rotation values of the surface planes
% in addition, these values are translated onto a scale that can be used
% for robotic movement
    
%% Import Data
%input data from .tif file labeled in the imread() function
%select range of larger data file to use
%output image of selected data and measure its size

import_data = imread("marscyl2.tif");
figure;
data = 0.5*import_data(1000:1700,1000:1700);
imshow(data); 
[numRows,numCols] = size(data);

%% Path and Delta Y
%Use personality function to create path
%Define the size of the path so that matrices may be traversed.

[X_index,Y_index,mySlopeData] = personality();
path_length = length(Y_index);
mypath = zeros([1 path_length]);

%Calculate the slope of path so that Rz can be scaled accordingly
 slope_path = diff(mySlopeData);
 

%% Display Surface with normal vectors
%Displays data as a surface plot
%quiver3 may be uncommented to show the normal vectors on the plot

 figure
 [X,Y] = meshgrid(1:numCols,1:numRows);
 [nx, ny,nz]= surfnorm(double(data));
 mars = surf(X,Y,double(data))
 mars.EdgeColor = 'none';
 view(3)
 hold on
 %quiver3(X,Y,double(data),nx,ny,nz)
 axis equal
 grid minor
 xlabel("xaxis - columns")
 ylabel("yaxis - rows")
 zlabel("zaxis")
 hold off
 
%% Compute Rotation 
%Calculate Ry and Rx rotations using normal vectors found in previous section and
%the dot product formula 
% To find Ry: normal  plane vector (dot) z axis = cos(Ry)
% To find Rx: normal plane vector (dot) yaxis = cos(Rx+180)
% Rx and Ry are solved for in the second for loop below
 
 xaxis = [1 0 0];
 yaxis = [0 1 0];
 zaxis = [0 0 1];
 
 Ry = zeros([1 path_length]);
 Rx = zeros([1 path_length]);
 
 %create and fill normal matrix 
 normal = zeros([path_length 3]);

 for i = 1:path_length
     normal(i,:) = [nx(X_index(i),Y_index(i)),ny(X_index(i),Y_index(i)),nz(X_index(i),Y_index(i))];
 end
 
 %Calculate Rx and Ry
 
 for i = 1:path_length
    vec = normal(i,:);
    if (vec(1) < 0)
      Ry(i)=acosd(dot(vec,zaxis));
    elseif (vec(1) > 0)
      Ry(i)=-1*acosd(dot(vec,zaxis));
    elseif (vec(1) ==0)
        Ry(i) = 0;
    end
    if(vec(2) <0)  %Rx is technically Rz on the graph, but is Rx for the robot
      Rx(i) = -1*(180-acosd(dot(vec,yaxis)));
    elseif (vec(2)>0)
      Rx(i) = acosd(dot(vec,yaxis)); 
    elseif(vec(2)==0)
      Rx(i) = 0;
    end
 end

%% Delta Z
%All of the robot's Z movement is determined by the value of Ry.
%As Ry is increased, the next movement requires Z to displace so that the
%flange connector is level with where the tip of the plane was in the
%previous movement
%sum is used to visualize the delta movements as a whole

 adj = 1000;
 delta_Z = zeros([1 path_length]);
 delta_Z(1) = double(data(1));
 startingZ = 1120;
 
 %calculate delta Z from Ry value 
 for i = 2:path_length
 delta_Z(i) = adj*tand(Ry(i-1));
 end
 

 
%Compute maximum and minimum Z displacement
 sum = zeros([1 path_length]);
 sum(1) = startingZ; %starting Z
 
 for i = 2:path_length
     sum(i) = delta_Z(i)+sum(i-1); 
 end
 
 Zmax = max(sum);
 Zmin = min(sum);

% Stretch Z displacement

sum = 400*rescale(sum)+150;

%Plot noisy and filtered data
figure;
%plot(1:numCols,sum);
%hold on;
plot(1:path_length,smoothdata(sum,'gaussian',50),'linewidth',2);
title("Elevation Plot",'fontsize',15);
ylabel("Height (mm)",'fontsize',10);
xlabel("Path Length (pixels)",'fontsize',10);
hold on;

sum = round(smoothdata(sum,'gaussian',50),1);

newdelta_Z = sum-startingZ;


 
  %% Scale Rx and Ry between - maxangle and + maxangle degrees and smooth
 
 maxangleX = 25;
 maxangleY = 45;
 valuesX = [max(Rx) abs(min(Rx))];
 valuesY = [max(Ry) abs(min(Ry))];
 Max = [max(valuesX) max(valuesY)];
 
 scaleX = maxangleX/Max(1);
 scaleY = maxangleY/Max(2);
 
 Rx = round(scaleX*Rx);
 Ry = round(scaleY*Ry);
 
 %smoothdata
 Rx =round(smoothdata(-1*Rx,'gaussian',100),1); 
 Ry = -2*round(smoothdata(Ry,'gaussian',150),1);
 
 
 
 delta_Y = round(smoothdata(mySlopeData,'gaussian',150),1);

 
 
 %plot(1:path_length,delta_Y);
 %hold off;
 
 figure;
 plot(1:path_length,Ry);
 hold on;
 plot(1:path_length,Rx);
 title("Ry");
 hold off;
 
 
%% Delta X

startingX = 1307;

moveX = 600*rescale(Ry)+1300;

moveX = round(smoothdata(moveX,'gaussian',20));

delta_X = moveX-startingX;

  %Compute maximum and minimum Z displacement
%  sum = zeros([1 path_length]);
%  sum(1) = 1300; %starting Z
%  
%  for i = 2:path_length
%      sum(i) = delta_X(i)+sum(i-1); 
%  end
%  
%  sum = -1*sum;
 
  figure;
 plot(1:path_length,delta_X+1300);
 title('Sum of X');

%% Delta Rz
Rz = zeros([1 path_length]);

Rz(1) = 0;
Rz(2:path_length) = round(15*rescale(slope_path,-1, 1),1);
%Rz = round(smoothdata(Rz,'gaussian',50),1);
for i = 1:path_length
    if(sum(i)>650 && Ry(i)>10)
        Rz(i) = 0;
    end
end


Rz = round(20*smoothdata(Rz,'gaussian',80)+2,1);

%% Plot Rx, Ry, and Rz on the same figure

figure;
plot(1:path_length,Ry);
hold on
plot(1:path_length,Rx);
plot(1:path_length,Rz);
hold off;
title("All angles");
legend('Ry','Rx','Rz');


%% Create CSV File
 mycsv = [Rx;Ry;Rz;delta_X;delta_Y;newdelta_Z]';
 csvwrite('rotationvalues.csv',mycsv) %first column is Rx (Roll), second column is Ry (Pitch)