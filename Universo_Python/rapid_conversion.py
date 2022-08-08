import ProcessDEM as PD

dir = "C:\\Users\Logan\\Documents\\GitHub\\Universo\\universo\\Universo_Python\\rapid_code.txt"

g = {
    'waverider': PD.waverider(),
    'sidewinder': PD.sidewinder(),
    'leaf': PD.leaf(),
    'tree': PD.tree()
}

PD.export_to_rapid(dir,g["leaf"])