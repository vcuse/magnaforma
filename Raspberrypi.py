from math import *
import board
import time
import neopixel

pixel_pin = board.D18
num_pixels = 240
ORDER = neopixel.GRB

pixels = neopixel.NeoPixel(
    pixel_pin, num_pixels, brightness=1, auto_write=False, pixel_order=ORDER
)

ROTATE_SPEED = 0.001

projection_matrix = [[1, 0, 0],
                     [0, 1, 0],
                     [0, 0, 0]]

# Setting points
cube_points = [n for n in range(240)]
# Front side
y = 30
for x in range(-30, 31):
    if y == -1:
        y = y + 240

    print(y)
    cube_points[y] = [[x * ((1 / 60) * 2)], [0], [1]]
    y = y - 1

# Left Side
y = 30
for x in range(-30, 30):
    print(y)
    cube_points[y] = [[-1], [0], [x * -((1 / 60) * 2)]]
    y = y + 1

for x in range(-30, 30):
    print("back", y)
    cube_points[y] = [[x * ((1 / 60) * 2)], [0], [-1]]
    y = y + 1

for x in range(-30, 30):
    print(y)
    cube_points[y] = [[1], [0], [x * ((1 / 60) * 2)]]
    y = y + 1


def multiply_m(a, b):
    a_rows = len(a)
    a_cols = len(a[0])
    b_rows = len(b)
    b_cols = len(b[0])
    # Dot product matrix dimensions = a_rows x b_cols
    product = [[0 for _ in range(b_cols)] for _ in range(a_rows)]

    if a_cols == b_rows:
        for i in range(a_rows):
            for j in range(b_cols):
                for k in range(b_rows):
                    product[i][j] += a[i][k] * b[k][j]
    else:
        print("INCOMPATIBLE MATRIX SIZES")
    return product


# Main Loop
scale = 100
angle_x = angle_y = angle_z = 0
while True:
    rotation_x = [[1, 0, 0],
                  [0, cos(angle_x), -sin(angle_x)],
                  [0, sin(angle_x), cos(angle_x)]]

    rotation_y = [[cos(angle_y), 0, sin(angle_y)],
                  [0, 1, 0],
                  [-sin(angle_y), 0, cos(angle_y)]]

    rotation_z = [[cos(angle_z), -sin(angle_z), 0],
                  [sin(angle_z), cos(angle_z), 0],
                  [0, 0, 1]]

    points = [0 for _ in range(len(cube_points))]
    i = 0
    for point in cube_points:
        rotate_x = multiply_m(rotation_x, point)
        rotate_y = multiply_m(rotation_y, rotate_x)
        rotate_z = multiply_m(rotation_z, rotate_y)
        point_2d = multiply_m(projection_matrix, rotate_z)

        x = (point_2d[0][0] * scale) + 800 / 2
        y = (point_2d[1][0] * scale) + 800 / 2
        points[i] = (x, y)
        bb = (points[i][1]) * 2 - 710

        if bb > 255:
            bb = 255
        if bb < 0:
            bb = 0
        print(i, ":", bb)
        pixels[i] = (255 - int(bb), 86, int(bb))

        i += 1
        angle_x = 90
        angle_z += ROTATE_SPEED
    time.sleep(.02)
    pixels.show()
