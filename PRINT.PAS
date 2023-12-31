(*******************************************************************)
(*                                                                 *)
(*                         Unit� Imprimante                        *)
(*                            1992/04/14                           *)
(*                                                                 *)
(* Programmeur : Sylvain Maltais                                   *)
(*                                                                 *)
(* Description : � Gestion de l'imprimante (LPT1:).                *)
(*                                                                 *)
(* Requ�re     : � Turbo Pascal 6 ou post�rieur.                   *)
(*               � Une Imprimante branch� sur LPT1:.               *)
(*                                                                 *)
(* Note        : � Cette unit� est a 100% autonome des autres      *)
(*                 unit�s.                                         *)
(*                                                                 *)
(*******************************************************************)

Unit Print;

(*******************************************************************)
                              Interface
(*******************************************************************)

Const

      Return = #13 + #10;

      PrnError : Byte = $00;

Procedure Prn(Chaine:String);
Procedure PrnLn(Chaine:String);

Function PrnChar(Char:Byte):Byte;
Function PrnReady:Byte;

(*******************************************************************)
                           Implementation
(*******************************************************************)

(*******************************************************************)
(*                                                                 *)
(* Description : � Imprime un seul caract�re sur LPT1:.            *)
(* Note        : � La fonction "ImprimeCaractere" retourne 1 si il *)
(*                 y eu erreur d'impression.                       *)
(*                                                                 *)
(*******************************************************************)

Function PrnChar(Char:Byte):Byte;
Assembler;
ASM XOR AH,AH;
    MOV AL,Char;
    XOR DX,DX;
    INT $17;
    MOV AL,$01;
    CMP AH,$90;
    JE  @@2;
    JMP @@1;
@@1:XOR AL,AL;
@@2:
End;

(*******************************************************************)
(*                                                                 *)
(* Description : � Retourne l'�tat de l'imprimante.                *)
(* Note        : � La fonction "ImprimantePrete" retourne 1 si     *)
(*                 l'imprimante est pr�te.                         *)
(*                                                                 *)
(*******************************************************************)

Function PrnReady:Byte;
Assembler;
ASM MOV AH,$02;
    XOR DX,DX;
    INT $17;
    XOR AL,AL;
    CMP AH,$90;
    JE  @@1;
    JMP @@2;
@@1:MOV AL,$01;
@@2:
End;

(*******************************************************************)
(*                                                                 *)
(* Description : � Imprime un chaine de caractere.                 *)
(* Note        : � La constante "ErreurImprimante" retourne le bon *)
(*                 fonctionnement de cette proc�dure.              *)
(*                                                                 *)
(*******************************************************************)

Procedure Prn(Chaine:String);
Var I,J : Byte;
Begin
 If(PrnReady = 1)Then
 Begin
  PrnError := 1-PrnReady;
  I := Length(Chaine);
  J := 1;
  While(J<=I)do
  Begin
   PrnError := PrnChar(Byte(Chaine[J]));
   Inc(J);
  End;
 End
  else
 PrnError := 1;
End;

(*******************************************************************)
(*                                                                 *)
(* Description : � Imprime un chaine de caractere, mais avec un    *)
(*                 certaine diff�rence de la proc�dure "Imprime"   *)
(*                 car il y a retour du chariot.                   *)
(* Note        : � La constante "ErreurImprimante" retourne le bon *)
(*                 fonctionnement de cette proc�dure.              *)
(*                                                                 *)
(*******************************************************************)

Procedure PrnLn(Chaine:String);
Begin
 Prn(Chaine+#13+#10);
End;

BEGIN
 PrnError := 0;
END.