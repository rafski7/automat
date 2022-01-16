'/*
  Automatic Drilling Machine 
  Setup Here https://github.com/rafski7/automat/blob/main/automatwiertarskizestrz.jpg .
  Code was developed initially as IEC LAD using OpenPLC.

  To test it is best to use pneumatic cylinders with proximity sensors showing positions of the cylinders.
  It is also possible to test by hand by forcing inputs true.
  
  One cycle consist of drilling four holes. Item placed by hand by operator. Cycle started by pressing Start.
  After a number of cycles (here 15) machine will stop and raise alarm. This is for the operator to change drill.
  Operator will need to reset machine.
  
  TODO: Safety / Emergency system

  2022 - Rafal Kwiatkowski aka Rafski
*/'



TYPE
  datatype0 : INT := 15;
END_TYPE

PROGRAM function0
  VAR_INPUT
    I1 : BOOL; 'cyl A retracted'
    I2 : BOOL; 'cyl B extended'
    I3 : BOOL; 'cyl B retracted'
    I4 : BOOL; 'cyl C extended'
    I5 : BOOL; 'cyl C retracted'
    I6 : BOOL; 'START'
    I7 : BOOL; 'RESET'
    I0 : BOOL; 'cyl A extended'
    I8 : BOOL; 'Emergency stop'
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL; 'Extend A'
    Q1 : BOOL; 'Extend B'
    Q2 : BOOL; 'Extend C'
    Q3 : BOOL; 'ALARM lamp'
    Q4 : BOOL; 'Emergency Lamp'
  END_VAR
  VAR
    M0 : BOOL;
    M1 : BOOL;
    M2 : BOOL;
    M3 : BOOL;
    M4 : BOOL;
    M5 : BOOL;
    M6 : BOOL;
    M7 : BOOL;
    M8 : BOOL;
    M9 : BOOL;
    M10 : BOOL;
    M11 : BOOL;
    M12 : BOOL;
    M13 : BOOL;
    M14 : BOOL;
    M15 : BOOL;
    CTU0 : CTU;
    R_TRIG1 : R_TRIG;
  END_VAR

  IF NOT(M13) AND I6 AND I2 THEN
    M0 := TRUE; (*set*)
  END_IF;
  IF M13 THEN
    M0 := FALSE; (*reset*)
  END_IF;
  M1 := I4;
  IF M0 AND M1 THEN
    M2 := TRUE; (*set*)
  END_IF;
  IF NOT(M0) THEN
    M2 := FALSE; (*reset*)
  END_IF;
  M3 := NOT(I5);
  IF M2 AND NOT(M15) AND M3 THEN
    M4 := TRUE; (*set*)
  END_IF;
  IF NOT(M2) THEN
    M4 := FALSE; (*reset*)
  END_IF;
  IF M4 AND I1 THEN
    M5 := TRUE; (*set*)
  END_IF;
  IF NOT(M4) THEN
    M5 := FALSE; (*reset*)
  END_IF;
  IF M5 AND M1 THEN
    M6 := TRUE; (*set*)
  END_IF;
  IF NOT(M5) THEN
    M6 := FALSE; (*reset*)
  END_IF;
  IF M6 AND NOT(M15) AND M3 THEN
    M7 := TRUE; (*set*)
  END_IF;
  IF NOT(M6) THEN
    M7 := FALSE; (*reset*)
  END_IF;
  IF M7 AND I3 THEN
    M8 := TRUE; (*set*)
  END_IF;
  IF NOT(M7) THEN
    M8 := FALSE; (*reset*)
  END_IF;
  IF M8 AND M1 THEN
    M9 := TRUE; (*set*)
  END_IF;
  IF NOT(M8) THEN
    M9 := FALSE; (*reset*)
  END_IF;
  IF M9 AND M15 AND M3 THEN
    M10 := TRUE; (*set*)
  END_IF;
  IF NOT(M9) THEN
    M10 := FALSE; (*reset*)
  END_IF;
  IF M10 AND I0 THEN
    M11 := TRUE; (*set*)
  END_IF;
  IF NOT(M10) THEN
    M11 := FALSE; (*reset*)
  END_IF;
  IF M11 AND M1 THEN
    M12 := TRUE; (*set*)
  END_IF;
  IF NOT(M11) THEN
    M12 := FALSE; (*reset*)
  END_IF;
  M13 := M12 AND NOT(M15) AND M3;
  R_TRIG1(CLK := I4);
  CTU0(CU := R_TRIG1.Q, R := I7, PV := 15);
  M14 := CTU0.Q;
  M15 := M14;
  Q4 := M14;
  Q0 := NOT(M10) AND M4;
  Q1 := M7;
  Q2 := NOT(M2) AND M0;
  Q2 := NOT(M6) AND M5;
  Q2 := NOT(M9) AND M8;
  Q2 := NOT(M12) AND M11;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : function0;
  END_RESOURCE
END_CONFIGURATION
