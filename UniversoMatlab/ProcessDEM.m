clc, clear, close all, clear variables;

%% Process DEM
% This code aims to plot the surface of a DEM and find the rotation values of the surface planes
% in addition, these values are translated onto a scale that can be used
% for robotic movement
    
%% Import Data

olddata = imread("marscyl2.tif");
figure;
data = olddata(509:512,700:739);%6000:511
imshow(data); 
[numRows,numCols] = size(data);

%% Display Surface with normal vectors
%data= smooth(0.5*data); %scaling for different .tif 
figure
 [X,Y] = meshgrid(1:numCols,1:numRows);
 [nx, ny,nz]= surfnorm(double(data));
 surf(X,Y,double(data))
 view(3)
 hold on
 quiver3(X,Y,double(data),nx,ny,nz)
 axis equal
 grid minor
 xlabel("xaxis - columns")
 ylabel("yaxis - rows")
 zlabel("zaxis")
 hold off
 

 
%% Compute Rotation 
 
 xaxis = [1 0 0];
 yaxis = [0 1 0];
 zaxis = [0 0 1];
 myrow = 2;
 
 
 Rx = zeros([1 numCols]);
 Ry = zeros([1 numCols]);
 Depth = data(myrow,:);
 
 
 for i = 1:numCols
    vec = [nx(myrow,i),ny(myrow,i),nz(myrow,i)];
    if (vec(1) < 0)
      Rx(i)=acosd(dot(vec,zaxis));
    elseif (vec(1) > 0)
      Rx(i)=-1*acosd(dot(vec,zaxis));
    elseif (vec(1) ==0)
        Rx(i) = 0;
    end
    if(vec(2) <0)  %Ry is technically Rz on the graph, but is Ry for the robot
      Ry(i) = -1*(180-acosd(dot(vec,yaxis)));
    elseif (vec(2)>0)
      Ry(i) = acosd(dot(vec,yaxis)); 
    elseif(vec(2)==0)
      Ry(i) = 0;
    end
 end
 %% Scale Rx and Ry between -45 and 45 degrees
 
 maxangle = 45;
 values = [max(Rx) abs(min(Rx)) max(Ry) abs(min(Ry))];
 Max = max(values);
 scale = maxangle/Max;

 Rx = round(scale*Rx);
 Ry = round(scale*Ry);
 
 
 Rotation = [Rx;Ry]';
 csvwrite('rotationvalues.csv',Rotation)

%% Change Depth

%zrange = -50;
 
 %Depth = zrange*rescale(Depth);
 
 
 %or
 %length_object = 6;
 %riseZ = sind(Rx)*length_object;
 
 
 
