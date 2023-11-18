Unit Reseau;

Interface

Uses DOS,EcrMono,IVisuel,IChaine;

Const ErreurReseau : Byte = 0;

      ReseauOk           = $00;
      ReseauCmdInconnu   = $03;
      ReseauIntOccupe    = $21;
      ReseauAdaptorError = $23;
      ReseauCmdAnnule    = $24;
      ReseauReserved     = $25;
      ReseauNotAnnule    = $26;
      ReseauExptError    = $40;
      ReseauErrorAdaptor = $50;

Type WaitType = 0..1;
     NCB = Record
            Comm     : Byte;
            RetCode  : Byte;
            LSN      : Byte;
            Num      : Byte;
            Buffer   : Pointer;
            Length   : Word;
            CallName : Array[0..15] of Byte;
            Name     : Array[0..15] of Byte;
            RTO      : Byte;
            STO      : Byte;
            Post     : Pointer;
            Lana     : Byte;
            Cmd      : Byte;
            Reserve  : Array[0..13] of Byte;
           End;

Var Recoit      : NCB;
    Envoi       : NCB;
    Nom_Local   : Char;
    Nom_Distant : Char;
    Caremis     : Byte;
    SaveInt28   : Pointer;
    SaveInt2A   : Pointer;
    SaveInt2F   : Pointer;
    SaveInt44   : Pointer;
    SaveInt5C   : Pointer;
    SaveInt7A   : Pointer;
    SaveInt80   : Pointer;

Procedure Receive;
Procedure Send;
Procedure SetWait(Etat:WaitType);
Procedure Hand_Up(Numero:Byte);
Procedure OpenReseau;
Procedure CloseReseau;

Function Listen:Byte;
Function Call(Nom,Local:String;Numero:Byte):Byte;

Implementation

Const Wait : WaitType = 1;

Function Appelle(Base,Deplacement:Word):Byte;
Assembler;
ASM MOV AX,Base;
    MOV ES,AX;
    MOV BX,Deplacement;
    INT $5C;
End;

Procedure Receive;
Var Tableau : Pointer;
Begin
 SauveDerniereLigne(Tableau);
 EffaceLigne(24,32,$F0);
 Ecrit(2,24,'Un instant S.V.P., je recoit les donn‚es...',$F0);
 Recoit.Comm   := $15 + Wait * $80;
 Recoit.Lana   := 0; { Num‚ro adapteur, Nø1 = 0, Nø2 = 1,... }
 Recoit.Post   := Ptr(0,0);
 ErreurReseau  := Appelle(Seg(Recoit),Ofs(Recoit));
 RestitueDerniereLigne(Tableau);
End;

Procedure Send;
Var Tableau : Pointer;
Begin
 SauveDerniereLigne(Tableau);
 EffaceLigne(24,32,$F0);
 Ecrit(2,24,'Un instant S.V.P., j''envoit les donn‚es...',$F0);
 Recoit.Comm   := $14 + Wait * $80;
 Recoit.Lana   := 0; { Num‚ro adapteur, Nø1 = 0, Nø2 = 1,... }
 Recoit.Post   := Ptr(0,0);
 ErreurReseau  := Appelle(Seg(Recoit),Ofs(Recoit));
 RestitueDerniereLigne(Tableau);
End;

Procedure SetWait(Etat:WaitType);
Begin
 Wait := Etat;
End;

Procedure Hand_Up(Numero:Byte);
Var Ferme_Session : NCB;
    Tableau       : Pointer;
Begin
 SauveDerniereLigne(Tableau);
 EffaceLigne(24,32,$F0);
 Ecrit(2,24,'HangUp en cours...',$F0);
 Ferme_Session.Comm := $12;
 Ferme_Session.LSN  := Numero;
 Ferme_Session.Lana := 0;
 ErreurReseau       := Appelle(Seg(Ferme_Session),Ofs(Ferme_Session));
 RestitueDerniereLigne(Tableau);
End;

Function Listen:Byte;
Begin
End;

Function Call(Nom,Local:String;Numero:Byte):Byte;
Var Emetteur : NCB;
    Tableau  : Pointer;
Begin
 SauveDerniereLigne(Tableau);
 EffaceLigne(24,32,$F0);
 Ecrit(2,24,'Ouverture en cours...',$F0);
 IncStr(Nom,#0);
 IncStr(Local,#0);
 Move(Nom[1],Emetteur.CallName[0],16);
 Move(Local[1],Emetteur.Name[0],16);
 Emetteur.Comm := $10 + Wait * $80;
 Emetteur.RTO  := 0;
 Emetteur.STO  := 6;
 Emetteur.Lana := 0;
 Emetteur.LSN  := Numero;
 ErreurReseau  := Appelle(Seg(Emetteur),Ofs(Emetteur));
 RestitueDerniereLigne(Tableau);
End;

Procedure Faut28h(Var Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Assembler;
ASM INT $80;
End;

Procedure Faut2Ah(Var Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Assembler;
Label Fin;
ASM CMP AH,0;
    JNE Fin;
    MOV AH,$FF;
Fin:
End;

Procedure Faut5Ch(Var Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Assembler;
ASM MOV AL,$FE;
End;

Procedure OpenReseau;
Begin
 SetIntVec($80,SaveInt28);
 SetIntVec($28,@Faut28h);
 If(SaveInt2A = Ptr(0,0))Then SetIntVec($2A,@Faut2Ah);
 If(SaveInt5C = Ptr(0,0))Then SetIntVec($5C,@Faut5Ch);
End;

Procedure CloseReseau;
Begin
 SetIntVec($28,SaveInt28);
 SetIntVec($2A,SaveInt2A);
 SetIntVec($2F,SaveInt2F);
 SetIntVec($44,SaveInt44);
 SetIntVec($5C,SaveInt5C);
 SetIntVec($7A,SaveInt7A);
 SetIntVec($80,SaveInt80);
End;

BEGIN
 GetIntVec($28,SaveInt28);
 GetIntVec($2A,SaveInt2A);
 GetIntVec($2F,SaveInt2F);
 GetIntVec($44,SaveInt44);
 GetIntVec($5C,SaveInt5C);
 GetIntVec($7A,SaveInt7A);
 GetIntVec($80,SaveInt80);
END.