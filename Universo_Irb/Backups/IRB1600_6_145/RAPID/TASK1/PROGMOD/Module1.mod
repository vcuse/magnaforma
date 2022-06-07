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
    LOCAL VAR egmident egm_id;
    ! EGM pose frames.
    LOCAL CONST pose egm_correction_frame := [[0, 0, 0], [1, 0, 0, 0]];
    LOCAL CONST pose egm_sensor_frame     := [[0, 0, 0], [1, 0, 0, 0]];
    ! The work object. Base Frame.
    LOCAL PERS wobjdata egm_wobj := [FALSE, TRUE, "", [[0, 0, 0],[1, 0, 0, 0]], [[0, 0, 0],[1, 0, 0, 0]]];
    ! Limits for convergance.
    LOCAL VAR egm_minmax egm_condition := [-0.1, 0.1];

    ! ################################## Externally Guided motion (EGM) - Main Cycle ################################## !
    PROC main()
        ! ##### Cartesian Move  ##### !
        EGM_CARTESIAN_MOVE;
    ENDPROC
    
    ! ################################## Externally Guided motion (EGM) - Cartesian Control ################################## !
    PROC EGM_CARTESIAN_MOVE()
        ! Home Position
        ! EGM While {Cartesian}
        WHILE TRUE DO
            ! Register an EGM id.
            EGMGetId egm_id;
            
            ! Setup the EGM communication.
            EGMSetupUC ROB_1, egm_id, "default", "EGMdevice", \Pose; 

            ! Prepare for an EGM communication session.
            ! \WObj:=egm_wobj,
            EGMActPose egm_id\Tool:=tool0, 
                       egm_correction_frame,
                       EGM_FRAME_BASE,
                       egm_sensor_frame,
                       EGM_FRAME_BASE
                       \x:=egm_condition
                       \y:=egm_condition
                       \z:=egm_condition
                       \rx:=egm_condition
                       \ry:=egm_condition
                       \rz:=egm_condition
                       \LpFilter:= 20 
                       \MaxSpeedDeviation:=10;
                        
            ! Start the EGM communication session.
            EGMRunPose egm_id, EGM_STOP_HOLD \x \y \z \rx \ry \rz \CondTime:=2\RampInTime:=0.05;
            ! Release the EGM id.
         !   EGMReset egm_id;
            ! Wait 2 seconds {No data from EGM sensor}
            WaitTime 2;
        ENDWHILE
        
        ERROR
        IF ERRNO = ERR_UDPUC_COMM THEN
            TPWrite "Communication timedout";
            TRYNEXT;
        ENDIF
    ENDPROC
    

ENDMODULE