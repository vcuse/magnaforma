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
data = 0.5*import_data(300:600,1:3000);%6000:511
imshow(data); 
[numRows,numCols] = size(data);

%% Path and Delta Y
%set center row that path will traverse
%create x domain that will be used to create path
%path is created using a mathematical function, in this case, a sine
%function. 
%Noise is added to path by adding an additional sine function

center_row = 200;

x = linspace(0,5,numCols);
mypath = 5*sin(5*x);
mypath = mypath + 2 * sin(8*x); %noise added


%Calculate the slope of path so that Rz can be scaled accordingly
slope_path = diff(mypath);
mypath = round(mypath);

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
%Calculate Ry and Rx rotations using normal vectors found previously and
%the dot product formula 
% To find Ry: normal  plane vector (dot) z axis = cos(Ry)
% To find Rx: normal plane vector (dot) yaxis = cos(Rx+180)
 
 xaxis = [1 0 0];
 yaxis = [0 1 0];
 zaxis = [0 0 1];
 
 Ry = zeros([1 numCols]);
 Rx = zeros([1 numCols]);
  
 
 %create and fill normal matrix according to path

 normal = zeros([numCols 3]);
 normal(1,:) = [nx(center_row,1),ny(center_row,1),nz(center_row,1)];
 
 for i = 2:numCols
     normal(i,:) = [nx(center_row+mypath(i),i),ny(center_row+mypath(i),i),nz(center_row+mypath(i),i)];
end
 
 
 for i = 1:numCols
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

 
 
%% Compute Rotation for longer distance by averaging - Unused

% startrange = 1;
% range = 3;
% newCols = floor(numCols/range);
% Ry = zeros([1 newCols]);
% Rx = zeros([1 newCols]);
% 
% for i = range:range:numCols
%     index = i/range;
%     Ry(index) = mean(Ry(startrange:i));
%     Rx(index) = mean(Rx(startrange:i));
%     startrange = startrange + range;
% end 
 

%% Delta Z
%All of the robot's Z movement is determined by the value of Ry.
%As Ry is increased, the next movement requires Z to displace so that the
%flange connector is level with where the tip of the plane was in the
%previous movement
%Delta 
 adj = 1000;
 delta_Z = zeros([1 numCols]);
 delta_Z(1) = double(data(1));
 startingZ = 1120;
 
 %calculate delta Z from Ry value 
 for i = 2:numCols
 delta_Z(i) = adj*tand(Ry(i-1));
 end
 

 
%Compute maximum and minimum Z displacement
 sum = zeros([1 numCols]);
 sum(1) = startingZ; %starting Z
 
 for i = 2:numCols
     sum(i) = delta_Z(i)+sum(i-1); 
 end
 
 Zmax = max(sum);
 Zmin = min(sum);

% Stretch Z displacement

sum = 900*rescale(sum)+400;

%Plot noisy and filtered data
figure;
%plot(1:numCols,sum);
%hold on;
plot(1:numCols,smoothdata(sum,'gaussian',50));
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
 Rx = -1*round(smoothdata(Rx,'gaussian',150),1);
 Ry = -4*round(smoothdata(Ry,'gaussian',150),1);
 
 
 
 delta_Y = round(smoothdata(mypath,'gaussian',80),1);
 %delta_Y = 4*delta_Y;
 plot(1:numCols,delta_Y);
 hold off;
 
 figure;
 plot(1:numCols,Ry);
 hold on;
 plot(1:numCols,Rx);
 hold off;
 
%% Delta X

startingX = 1307;

moveX = 500*rescale(Ry)+1100;

moveX = round(smoothdata(moveX,'gaussian',20));

delta_X = moveX-startingX;


%% Delta Rz
Rz = zeros([1 numCols]);

Rz(1) = 0;
Rz(2:numCols) = round(15*rescale(slope_path,-1, 1),1);
%Rz = round(smoothdata(Rz,'gaussian',50),1);
for i = 1:numCols
    if(sum(i)>650 && Ry(i)>10)
        Rz(i) = 0;
    end
end

figure;
plot(1:numCols,Rz);


%% Create CSV File
 mycsv = [Rx;Ry;Rz;delta_X;delta_Y;newdelta_Z]';
 csvwrite('rotationvalues.csv',mycsv) %first column is Rx (Roll), second column is Ry (Pitch)
 
 