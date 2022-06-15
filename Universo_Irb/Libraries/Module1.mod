MODULE Module1
    ! ## =========================================================================== ## 
    ! MIT License
    ! Copyright (c) 2021 Roman Parak
    ! Permission is hereby granted, free of charge, to any person obtaining a copy
    ! of this software and associated documentation files (the "Software"), to deal
    ! in the Software without restriction, including without limitation the rights
    ! to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    ! copies of the Software, and to permit persons to whom the Software is
    ! furnished to do so, subject to the following conditions:
    ! The above copyright notice and this permission notice shall be included in all
    ! copies or substantial portions of the Software.
    ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    ! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    ! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    ! OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    ! SOFTWARE.
    ! ## =========================================================================== ## 
    ! Author   : Roman Parak
    ! Email    : Roman.Parak@outlook.com
    ! Github   : https://github.com/rparak
    ! File Name: T_ROB1/Module1.mod
    ! ## =========================================================================== ## 
    
    ! ############### EGM Initialization Parameters ############### !
    ! Identifier for the EGM correction.
    VAR robtarget starting_robot_position;
    VAR robtarget current_robot_position;


    ! ################################## Externally Guided motion (EGM) - Main Cycle ################################## !
    PROC main()

        ! ##### Cartesian Move  ##### !
        ConfJ\Off;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 230, -619.57 \Rx:=-19, \Ry:=10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -46.427 \Rx:=-0, \Ry:=-20, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=5, \Ry:=-4, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 73.407 \Rx:=1, \Ry:=14, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-1, \Ry:=14, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -73.407 \Rx:=14, \Ry:=-6, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -32.829 \Rx:=-0, \Ry:=-8, \Rz:=0), v100, z1, Tooldata_7;
        
        
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-0, \Ry:=-8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=18, \Ry:=8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=1, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-38, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=2, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=8, \Rz:=0), v100, z1, Tooldata_7;
        
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=19, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-19, \Ry:=-3, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 65.657 \Rx:=-0, \Ry:=13, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=19, \Ry:=10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -46.427 \Rx:=-0, \Ry:=-20, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-19, \Ry:=-3, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 65.657 \Rx:=-20, \Ry:=-1, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 73.407 \Rx:=1, \Ry:=4, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=2, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=-5, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 65.657 \Rx:=-16, \Ry:=-3, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 92.853 \Rx:=-2, \Ry:=16, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-1, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=5, \Ry:=-4, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 73.407 \Rx:=-5, \Ry:=4, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-19, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=2, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-18, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-1, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-1, \Ry:=-4, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 73.407 \Rx:=4, \Ry:=-2, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 92.853 \Rx:=2, \Ry:=30, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -73.407 \Rx:=-6, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, -73.407 \Rx:=20, \Ry:=-14, \Rz:=0), v100, z1, Tooldata_7;
        
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-0, \Ry:=-8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=-5, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 65.657 \Rx:=-19, \Ry:=3, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=2, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-18, \Ry:=8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-1, \Ry:=-10, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 46.427 \Rx:=19, \Ry:=10, \Rz:=0), v100, z1, Tooldata_7;
        
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 0 \Rx:=-0, \Ry:=-8, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=0, \Rz:=0), v100, z1, Tooldata_7;
        MoveJ RelTool (CRobT(\Tool:=Tooldata_7\wobj:=wobj0), 0, 0, 32.829 \Rx:=-0, \Ry:=16, \Rz:=0), v100, z1, Tooldata_7;








     
        !MoveJ [ [0, 0, 1225], [-0.282, 0.072, 0.956, 0.021], [0, -1,-1, 1], [0, 9E9, 9E9, 9E9, 9E9, 9E9] ],v20,z1,Tooldata_7;
        !MoveJ [ [0, 0, 1000], [-0.282, 0.072, 0.956, 0.021], [0, -1,-1, 1], [0, 9E9, 9E9, 9E9, 9E9, 9E9] ],v20,z1,Tooldata_7;
        !EGM_CARTESIAN_MOVE;
       ! RAPID_MOVE;
       
    ENDPROC
 
    

ENDMODULE