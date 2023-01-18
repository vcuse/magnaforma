'''
Author: Miles Popiela
Contact: popielamc@vcu.edu

Description: Creating LED visualization of 3D Point rotation
matrix with rotation input being rotational and Y-Axis values
of a game object within unity using UDP sockets
'''

from math import *
import board
import time
import neopixel
import socket
import math

'''
Setting Up UDP Server
'''
IP = "192.168.0.50"
PORT =  8000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((IP, PORT))
print("Binded")


'''
Setting up NeoPixels
'''
pixel_pin = board.D18
num_pixels = 120
ORDER = neopixel.GRB

pixels = neopixel.NeoPixel(
    pixel_pin, num_pixels, brightness=100, auto_write=False, pixel_order=ORDER
)

pixels.fill((0, 255, 0))
pixels.show()

# Setting points
cube_points = [n for n in range(num_pixels)]

projection_matrix = [[1, 0, 0],
                     [0, 1, 0],
                     [0, 0, 0]]


'''
Setting Up Virtual Points

TODO!!!
We need to make two more cube_points for inner,top, and bottom faces of the planchette
TODO!!!
'''
# Front side
y = 15
for x in range(-15, 16):
    if y == -1:
        y = y + 120
    cube_points[y] = [[x * ((1 / (num_pixels/4)) * 2)], [0], [1]]
    y = y - 1

# Left Side
y = 15
for x in range(-15, 15):
    cube_points[y] = [[-1], [0], [x * -((1 / (num_pixels/4)) * 2)]]
    y = y + 1

#Backside
for x in range(-15, 15):
    cube_points[y] = [[x * ((1 / (num_pixels/4)) * 2)], [0], [-1]]
    y = y + 1

#Rightside
for x in range(-15, 15):
    cube_points[y] = [[1], [0], [x * ((1 / (num_pixels/4)) * 2)]]
    y = y + 1

# Matrix multiplication function
def multiply_m(a, b):
    a_rows = len(a)
    a_cols = len(a[0])
    b_rows = len(b)
    b_cols = len(b[0])
    # Dot product matrix dimensions = a_rows x b_cols
    product = [[0 for _ in range(b_cols)] for _ in range(a_rows)]

    for i in range(a_rows):
        for j in range(b_cols):
            for k in range(b_rows):
                product[i][j] += a[i][k] * b[k][j]

    return product

#Scaling for later use
scale = 250 #Because half the hieght of the square is 250mm
angle_x = angle_y = angle_z = 0

'''
Main Loop
'''
while True:

    # Get values from Unity
    pac, address = sock.recvfrom(35)
    data = [float(k) for k in str(pac, 'UTF-8').split(',')]


    # Matching up data by converting degrees to radian
    angle_x = math.radians(data[0])
    angle_y = math.radians(data[1])
    angle_z = math.radians(data[2])


    Uy = data[3]

    # Setup for alg
    points = [0 for _ in range(len(cube_points))]
    i = 0

    rotation_x = [[1, 0, 0],
                  [0, cos(angle_x), -sin(angle_x)],
                  [0, sin(angle_x), cos(angle_x)]]

    rotation_y = [[cos(angle_y), 0, sin(angle_y)],
                  [0, 1, 0],
                  [-sin(angle_y), 0, cos(angle_y)]]

    rotation_z = [[cos(angle_z), -sin(angle_z), 0],
                  [sin(angle_z), cos(angle_z), 0],
                  [0, 0, 1]]


    '''
    Rotation of Points

    TODO!!!
    We need to make 2 more for loops that correlate with the other faces so far we only have the outwards face completed
    TODO!!!
    '''
    for point in cube_points:

        rotate_x = multiply_m(rotation_x, point)
        rotate_y = multiply_m(rotation_y, rotate_x)
        rotate_z = multiply_m(rotation_z, rotate_y)
        point_2d = multiply_m(projection_matrix, rotate_z)

        '''
        Takes virtual plot points and combineds them with

        must think of method of simplification ~ ** The robots' Y-axis ** ~ must think of method of simplification

        '''
        Local_y = ((point_2d[1][0] * scale) + (Uy * 1000) + 150)
        Color = Local_y #Nedds to be out of 255

        if Color > 255:
            Color = 255
        if Color < 0:
            Color = 0
        pixels[i] = (255 - int(Color), 70, int(Color))
        i += 1
    time.sleep(.02)
    pixels.show()
