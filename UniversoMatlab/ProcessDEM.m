clc, clear, close all, clear variables;

%% Process DEM
% This code aims to plot the surface of a DEM and find the rotation values of the surface planes
% in addition, these values are translated onto a scale that can be used
% for robotic movement
    
%% Import Data

olddata = imread("marscyl2.tif");
figure;
data = olddata(400:500,1:3000);%6000:511
imshow(data); 
[numRows,numCols] = size(data);




%% Path and Delta Y

myrow = 50;



x = linspace(0,5,numCols);
mypath = round(10*sin(x));




%% Display Surface with normal vectors
%data= smooth(0.5*data); %scaling for different .tif 
 figure
 [X,Y] = meshgrid(1:numCols,1:numRows);
 [nx, ny,nz]= surfnorm(double(data));
 mars = surf(X,Y,double(data))
 mars.EdgeAlpha = 0.1;
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
 
 xaxis = [1 0 0];
 yaxis = [0 1 0];
 zaxis = [0 0 1];
 
 Ry = zeros([1 numCols]);
 Rx = zeros([1 numCols]);
  
 
 %create and fill normal matrix according to path
 normal = zeros([numCols 3]);
 normal(1,:) = [nx(myrow,1),ny(myrow,1),nz(myrow,1)];
 
 for i = 2:numCols
     normal(i,:) = [nx(myrow+mypath(i),i),ny(myrow+mypath(i),i),nz(myrow+mypath(i),i)];
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

 
 
%% Compute Rotation for longer distance by averaging

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

%adj determines the scale of the adjacent side of the triangle...this can
%be used to increase or decrease the value of delta Z and can be any
%number.

 adj = 5;
 delta_Z = zeros([1 numCols]);
 delta_Z(1) = double(data(1));
 startingZ = 1122;
 
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

sum = 900*rescale(sum)+500;

%Plot noisy and filtered data
figure;
plot(1:numCols,sum);
hold on;
plot(1:numCols,smoothdata(sum,'gaussian',50));


sum = round(smoothdata(sum,'gaussian',50));

newdelta_Z = sum-startingZ;
 
  %% Scale Rx and Ry between - maxangle and + maxangle degrees and smooth
 
 maxangleX = 25;
 maxangleY = 45;
 valuesX = [max(Rx) abs(min(Rx))];
 valuesY = [max(Ry) abs(min(Ry))];
 Max = [max(valuesX) max(valuesY)];
 
 scaleX = maxangleX/Max(1);
 scaleY = maxangleY/Max(2);
 Rx = -1*round(scaleX*Rx);
 Ry = round(scaleY*Ry);
 
 %smoothdata
 Rx = round(smoothdata(Rx,'gaussian',50),1);
 Ry = -3*round(smoothdata(Ry,'gaussian',80),1);
 
 
 
 delta_Y = round(smoothdata(30*mypath,'gaussian',80),1);
 plot(1:numCols,delta_Y);
 hold off;
 
 figure;
 plot(1:numCols,Ry);
 hold on;
 plot(1:numCols,Rx);
 hold off;
 
%% Delta X

startingX = 1555;

moveX = 400*rescale(Ry)+1500;

moveX = round(smoothdata(moveX,'gaussian',10));

delta_X = moveX-startingX;


%% Find extent of Ry 


% height = 200:1100;
% RyRx_Range = 0.00002*height.^2+0.0695*height-17.164;
% 
% for i = 1:numCols
%     if(sum(i)<=1100)
%        % index = find(height == sum(i));
%         if(Ry(i)>(-0.00002*sum(i).^2+0.0695*sum(i)-17.164))
%             Ry(i) = (-0.00002*sum(i).^2+0.0695*sum(i)-17.164);
%             disp('hello')
%             
%         end
%         if(Rx(i)>(-0.00002*sum(i).^2+0.0695*sum(i)-17.164))
%             Rx(i) = (-0.00002*sum(i).^2+0.0695*sum(i)-17.164);
%         end
%     end
% end




%% Create CSV File
 mycsv = [Rx;Ry; delta_X;delta_Y;newdelta_Z]';
 csvwrite('rotationvalues.csv',mycsv) %first column is Rx (Roll), second column is Ry (Pitch)
 
 