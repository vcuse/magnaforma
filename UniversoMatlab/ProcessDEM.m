clc, clear, close all, clear variables;

%% Process DEM
% This code aims to plot the surface of a DEM and find the rotation values of the surface planes
% in addition, these values are translated onto a scale that can be used
% for robotic movement
    
%% Import Data

olddata = imread("marscyl2.tif");
figure;
data = olddata(400:403,300:360);%6000:511
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
 
 Ry = zeros([1 numCols]);
 Rx = zeros([1 numCols]);
 Depth = data(myrow,:);
 
 
 for i = 1:numCols
    vec = [nx(myrow,i),ny(myrow,i),nz(myrow,i)];
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
 


%% Compute Rotation for longer distance by averaging

% startrange = 1;
% range = 3;
% newCols = floor(numCols/range);
% Ry_avg = zeros([1 newCols]);
% Rx_avg = zeros([1 newCols]);
% 
% for i = range:range:numCols
%     index = i/range;
%     Ry_avg(index) = mean(Ry(startrange:i));
%     Rx_avg(index) = mean(Rx(startrange:i));
%     startrange = startrange + range;
% end 
 

%% Change Depth

%adj determines the scale of the adjacent side of the triangle...this can
%be used to increase or decrease the value of delta Z and can be any
%number.

 adj = 5;
 delta_Z = zeros([1 numCols]);
 delta_Z(1) = 0;
 
 %calculate delta Z from Ry value 
 for i = 2:numCols
 delta_Z(i) = adj*tand(Ry(i-1));
 end
 
 %Compute maximum and minimum Z displacement
 sum = zeros([1 numCols]);
 sum(1) = 1166;
 for i = 2:numCols
     sum(i) = delta_Z(i)+sum(i-1); 
 end
 
 Zmax = max(sum);
 Zmin = min(sum);
%  
%  
totaldelta = 3*round(sum-sum(1));
 
 
  %% Scale Rx and Ry between - maxangle and + maxangle degrees
 
 maxangle = 15;
 values = [max(Rx) abs(min(Rx)) max(Ry) abs(min(Ry))];
 Max = max(values);
 scale = maxangle/Max;

 Rx = round(scale*Rx);
 Ry = -1*round(scale*Ry);

 
 Rotation = [Rx;Ry;totaldelta]'; 
 csvwrite('rotationvalues.csv',Rotation) %first column is Rx (Roll), second column is Ry (Pitch)
 
 

%% Extra Code 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Compute Rotation for longer distances by scanning (only works for Ry atm)

%  myrow = 2;
%  prev_z = data(myrow,1);
%  range = 5;
%  RyCols = floor(numCols/range);
%  Ry_avg = zeros([1 RyCols]);
%  
%  for i = range:range:numCols
%      cur_z = data(myrow,i);
%      Ryindex = i/range;
%      opp = double(cur_z)-double(prev_z);
%      Ry_avg(Ryindex) = atand(opp/range);
%      prev_z = cur_z;
%  end