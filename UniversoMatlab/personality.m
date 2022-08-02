%clc, clear, close all, clear variables;
function [X_index,Y_index,mySlope]= personality()

% Import data
import_data = imread("marscyl2.tif");
figure;
data = 0.3*import_data(1000:1700,1000:1700);%2048x4096
imshow(data); 
[numRows,numCols] = size(data);

data = smoothdata(data,'gaussian',20);

 %Plots the entire terrain
 figure
 [X,Y] = meshgrid(1:numCols,1:numRows);
 mars = surf(X,Y,double(data))
 mars.EdgeColor = 'none';
 view(3)
 title("Terrain");
 xlabel("xaxis - columns")
 ylabel("yaxis - rows")
 zlabel("zaxis")
 axis equal
 

 
[Gdatax,Gdatay] = gradient(data);

 %Plots the Y Gradient
 
 figure
 mars_diff = surf(X,Y,Gdatay);
 mars_diff.EdgeColor = 'none';
 title("Gradient-Y");
 xlabel("xaxis - columns")
 ylabel("yaxis - rows")
 zlabel("zaxis")

 %Length determines how many times the path will corner
 length = 10;
 [rows,cols] = size(data);
 iteration = floor(rows/length);
  
 clear mars;
 clear mars_diff;
  
 currentX = 1;
 currentY = 1;
 
 %myPath = zeros([1 1]);
 myPathX = zeros([1 1]);
 myPathY = zeros([1 1]);
 mySlope = zeros([1 1]);
 
  for myi = 1:iteration
     
    traverse = length*(myi-1); 
    lookahead = data((1+traverse):(length+traverse),1:numCols);  
    sealevel = mean(data,'all'); 
    hill = max(lookahead,[],'all');
    valley= min(lookahead,[],'all');
    options = [hill-sealevel sealevel-valley;hill valley]; 
    [~,index] = max(options(1,:));
    target = options(2,index);
    [target_x,target_y] = find(lookahead==target); 
    target_x = target_x(1)+(1+traverse); 
    run = target_x - currentX;
    rise = target_y(1) - currentY;
    slope = floor(rise/run);
    
  
    
  %  path = zeros([1 abs(run)]);
    j = currentY;
    if(target_x>currentX)
        increment = 1;
    else
        increment = -1;
    end
    for i = 1:abs(run)
        if(j+slope <=0 || j+slope>numCols)
            slope = -1*slope;
            j = j+slope;
        end
        
    %   path(i) = data(currentX,j);
        myPathX = [myPathX currentX];
        myPathY = [myPathY j];
        data(currentX,j) = 0;
        currentX = currentX +increment;
        j = j+slope;
        mySlope = [mySlope slope];
  
    end
     currentY = j;
  end
  myPathX(1) = [];
  myPathY(1) = [];
  X_index = myPathX;
  Y_index = myPathY;
  
  

  mySlope(1) = [];
  
  [~, replace] = size(find(mySlope>20));

  
  mySlope(find(mySlope>20))=ones([1 replace])*20;
  
 figure;
 lookahead_plot = surf(X,Y,data);
 lookahead_plot.EdgeColor = 'none';
 title('snippet2');
 xlabel("xaxis - columns")
 ylabel("yaxis - rows")
 axis equal
end
 
 