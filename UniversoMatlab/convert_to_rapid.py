import csv

def export_to_rapid(x, y, z, rX, rY, rZ,myspeed,restart):
    move_joint = "move {},{},{},{},{},{},{},{};\n".format(x,z,rX,rY,rZ,y,myspeed,restart)#"MoveJ RelTool (starting_position, {},0, {} \Rx:={}, \Ry:={}, \Rz:={}), v200, z200, Tooldata_7;\n".format(x, z, rX, rY, rZ)
    #joints = "joints := CJointT(\TaskName:=\"T_ROB1\");\njoints.robax.rax_1 := ({});\n".format(y)
    #move_absjoint = "MoveAbsJ (joints),v100,z200,Tooldata_7;\n"

    with open('C:\\Users\\grazianige\\Documents\\GitHub\\universo\\rapid_code.txt', 'a') as movement_file:
        movement_file.write(move_joint)#+joints+move_absjoint)

open('C:\\Users\\grazianige\\Documents\\GitHub\\universo\\rapid_code.txt', 'w').close()
source_file = open('C:\\Users\\grazianige\\Documents\\GitHub\\universo\\rotationvalues.csv', 'r')
source_data = csv.reader(source_file)

for row in source_data:
    rX, rY,rZ,X,Y,Z,speed,res = row[0], row[1], row[2],row[3],row[4],row[5],row[6],row[7]
    export_to_rapid(X, Y, Z, rX, rY, rZ,speed,res)