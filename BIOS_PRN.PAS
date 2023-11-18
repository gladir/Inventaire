(**********************************************************************)
(*                                                                    *)
(*                           BIOS PRINTER                             *)
(*                            1991/04/06                              *)
(*                                                                    *)
(*  Programmeur : Sylvain Maltais                                     *)
(*                                                                    *)
(**********************************************************************)

Unit BIOS_PRN;

(**********************************************************************)
                              INTERFACE
(**********************************************************************)

Const

      LPT1 = 0;
      LPT2 = 1;
      LPT3 = 2;
      LPT4 = 3;

Var

    PrinterError : Byte;

Function Print(Chaine:String;Numero:Word):Boolean;
Function PrintChar(Chr:Char;Numero:Word):Boolean;
Function PrintLn(Chaine:String;Numero:Word):Boolean;
Function CheckPrinter(Numero:Word):Boolean;

(**********************************************************************)
                            IMPLEMENTATION
(**********************************************************************)

Function PrintChar(Chr:Char;Numero:Word):Boolean;
Var Stool : Byte;
Begin
 ASM
  XOR AH,AH;
  MOV AL,Chr;
  MOV DX,Numero;
  INT $17;
  MOV Stool,AH;
 END;
 If((Stool and $21) <> 0)Then
 Begin
  PrinterError := Stool;
  PrintChar := False;
 End
  else
 PrintChar := True;
End;

Function Print(Chaine:String;Numero:Word):Boolean;
Var I  : Byte;
    Ok : Boolean;
Begin
 I := 1;
 Repeat
  Ok := PrintChar(Chaine[I],Numero);
  Inc(I);
 Until Not(Ok) or (I > Length(Chaine));
 Print := Ok;
End;

Function PrintLn(Chaine:String;Numero:Word):Boolean;
Begin
 PrintLn := Print(Chaine + #13 + #10,Numero);
End;

Function CheckPrinter(Numero:Word):Boolean;
Var Stool : Byte;
Begin
 ASM
  MOV AH,$02;
  MOV DX,Numero;
  INT $17;
  MOV Stool,AH;
 END;
 If(Stool <> $90)Then
 Begin
  PrinterError := Stool;
  CheckPrinter := False;
 End
  else
 CheckPrinter := True;
End;

BEGIN
 PrinterError := 0;
END.