from math import pi,cos,sin,exp
from numpy import round, arange
import re

#Scale is a constant used to scale and cap translational movement
#Max angle is the largest angle observed during movement
#Cycles is used for number of iterations calculated
#Delay is used to introduce a delay between angle of plane and translational movement

def waverider(scale = -250, maxangle =  20, cycles = 4, delay = .5):
    tS = arange(0,cycles*2*pi,.09) #t is used as the independent variables for these movements and also represents "time"

    #Initializing all of the output lists(translational x,y,z; rotational x,y,z; speed, and restart linking parameter)
    dX,dY,dZ,rX,rY,rZ,speed,restart = [],[],[],[],[],[],[],[]

    #Setting values 
    for t in tS:
        dX.append(round(scale*cos(t) - scale,2))
        dY.append(0)
        dZ.append(round(scale*sin(t) - scale,2))

        rX.append(0)
        rY.append(round(maxangle*cos(t + delay),2))
        rZ.append(0)
        
        #For the waverider movement, the speed should increase as the robot descends and should lessen as the robot climbs
        if rY[-1] <= -.5*maxangle:
            speed.append(800)
        elif rY[-1] > .7*maxangle:
            speed.append(400)
        else:
            speed.append(500)

        restart.append(0)

    restart[0] = 1

    wr_csv = [rX, rY, rZ, dX, dY, dZ, speed, restart]

    return wr_csv

def sidewinder(scale = 20, maxangle =  1.5, delay = 2): 
    tS = arange(0,15,.09) #t is used as the independent variables for these movements and also represents "time"

    #Initializing all of the output lists (translational x,y,z; rotational x,y,z; speed, and restart linking parameter)
    dX,dY,dZ,rX,rY,rZ,speed,restart = [],[],[],[],[],[],[],[]

    for t in tS:
        dX.append(25*t)
        dY.append(round(scale*sin(t),2))
        dZ.append(0)

        rX.append(0)
        rY.append(0)
        rZ.append(round(maxangle*sin(t + delay),2))
        
        #For the Sidewinder movement, the speed increases as the robot rounds a bend 
        if rZ[-1] <= .9*scale:
            speed.append(700)
        else:
            speed.append(500)

        restart.append(0)

    restart[0] = 1

    sw_csv = [rX, rY, rZ, dX, dY, dZ, speed, restart]

    return sw_csv

def tree(scale = 60,maxangle =  30, delay = .3): 
    tS = arange(0,30,.09) #t is used as the independent variables for these movements and also represents "time"

    #Initializing all of the output lists (translational x,y,z; rotational x,y,z; speed, and restart linking parameter)
    dX,dY,dZ,rX,rY,rZ,speed,restart = [],[],[],[],[],[],[],[]

    for t in tS:
        rX.append(round(30*sin(t)*exp(-0.01*t)))
        rY.append(0)
        rZ.append(0)

        dX.append(0)
        dY.append(round(scale/3*sin(t + delay)*exp(-0.01*(t + delay)),2))
        dZ.append(round(scale/5*rX[-1] + scale/4*(t + delay),2))

        if abs(dY[-1]) >= 0.6*maxangle*exp(-0.01*(t + delay)):
            speed.append(200)
        else:
            speed.append(400)

        restart.append(0)

    restart[0] = 1

    t_csv = [rX, rY, rZ, dX, dY, dZ, speed, restart]

    return t_csv

def leaf(maxangle =  25, delay = .3): 
    tS = arange(0,5,.09) #t is used as the independent variables for these movements and also represents "time"

    #Initializing all of the output lists (translational x,y,z; rotational x,y,z; speed, and restart linking parameter)
    dX,dY,dZ,rX,rY,rZ,speed,restart = [],[],[],[],[],[],[],[]

    for t in tS:
        rX.append(round(-30*cos(2*(t + delay))))
        rY.append(0)
        rZ.append(0)

        dX.append(0)
        dY.append(round(25*sin(2*t),2))
        dZ.append(round((-140*sin(4*t) - 180*t),2))
        
        if abs(dY[-1]) >= .8*maxangle:
            speed.append(300)
        elif abs(dY[-1]) >= 0.7*maxangle:
            speed.append(700)
        else:
            speed.append(100)
        
        restart.append(0)

    restart[0] = 1

    l_csv = [rX, rY, rZ, dX, dY, dZ, speed, restart]

    return l_csv

def export_to_rapid(dir,mp):
    #dir = "C:\\Users\Logan\\Documents\\GitHub\\Universo\\universo\\Universo_Python\\rapid_code.txt"
    written = False
    dX,dY,dZ,rX,rY,rZ,speed,restart = mp[0],mp[1],mp[2],mp[3],mp[4],mp[5],mp[6],mp[7]
    with open(dir,'r') as fr:
        get_all = fr.readlines()
        fr.close()
    
    with open(dir,'w') as fw:
        for i,line in enumerate(get_all,1):
            if re.sub(r"[^a-zA-Z]+", "", line) == "move" and written == False:
                for i in range(len(dX)):
                    move_joint = "move {},{},{},{},{},{},{},{};\n".format(dX[i],dY[i],dZ[i],rX[i],rY[i],rZ[i],speed[i],restart[i])
                    fw.write('\t' + move_joint)
                written = True    
            elif re.sub(r"[^a-zA-Z]+", "", line) == "move" and written == True:
                continue
            else:
                fw.write(line)