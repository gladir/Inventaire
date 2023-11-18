Unit Speed;

Interface

Uses DOS;

Procedure SetKeyboard(Etat:Byte);
Function GetLPT1:Byte;       { IRQ7 }
Function GetFloppyDisk:Byte; { IRQ6 }
Function GetKeyBoard:Byte;   { IRQ1 }
Function GetClock:Byte;      { IRQ0 }

Implementation

Procedure SetKeyboard(Etat:Byte);
Assembler;
ASM IN  AL,$21;
    AND AL,$FD;
    MOV AH,Etat;
    NOT AH;
    AND AH,1;
    SHL AH,1;
    ADD AL,AH;
    OUT $21,AL;
End;

Function GetLPT1:Byte;
Assembler;
ASM IN  AL,$21;
    ROL AL,1;
    NOT AL;
    AND AL,1;
End;

Function GetFloppyDisk:Byte;
Assembler;
ASM IN  AL,$21;
    ROL AL,1;
    ROL AL,1;
    NOT AL;
    AND AL,1;
End;

Function GetKeyBoard:Byte;
Assembler;
ASM IN  AL,$21;
    NOT AL;
    AND AL,2;
    SHR AL,1;
End;

Function GetClock:Byte;
Assembler;
ASM IN  AL,$21;
    NOT AL;
    AND AL,1;
End;

Procedure DivisionZero;
Interrupt;
Begin
End;

BEGIN
 SetIntVec($00,@DivisionZero);
END.