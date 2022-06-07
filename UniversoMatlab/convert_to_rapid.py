import csv

def export_to_rapid(x, y, z, rX, rY, rZ):
    move_joint = "MoveJ RelTool (current_robot_position, {}, {}, {} \Rx:={}, \Ry:={}, \Rz:={}), v10, fine, tool0;\n".format(x, y, z, rX, rY, rZ)

    with open('rapid.txt', 'a') as movement_file:
        movement_file.write(move_joint)

source_file = open('rotationvalues.csv', 'r')
source_data = csv.reader(source_file)

for row in source_data:
    rX, rY = row[0], row[1]
    export_to_rapid(0, 0, 0, rX, rY, 0)