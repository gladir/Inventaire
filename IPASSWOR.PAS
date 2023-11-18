(**********************************************************************)
(*                                                                    *)
(*                    Inventaire Mots de Passe                        *)
(*                           1992/04/08                               *)
(*                                                                    *)
(* Concepteur  : Les Chevaliers de Malte                              *)
(* Programmeur : Sylvain Maltais                                      *)
(* Concepteur  : Sylvain Maltais                                      *)
(*                                                                    *)
(* Description : þ Unit‚ testant la validit‚ du mots de passe entr‚   *)
(*                 et modification du mots de passe.                  *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small Wonder)   *)
(*                 en mode texte monochrome (07h).                    *)
(*               þ Turbo Pascal 6 ou post‚rieur.                      *)
(*                                                                    *)
(**********************************************************************)

Unit IPassWor;

{$V-}

(**********************************************************************)
                              Interface
(**********************************************************************)

Uses Drivers,IClavier,Crt,EcrMono,IVisuel,IFichier,IChaine;

Procedure NouveauPassWord;
Function TestePassWord:Byte;

(**********************************************************************)
                           Implementation
(**********************************************************************)

Const SEcran : Word = $B000;

 { Attention : Cette proc‚dure ne doit pas ˆtre d‚clar‚ dans la partie
               "Interface" sous risque de perturb‚ le bon d‚roulement du
               programme maitre -> Inventaire.

   Note : Retourne 0 dans Escape s'il y a terminaison par <ENTER>,
          retourne 1 dans Escape s'il y a terminaison par <ESC>,
          retourne 254 dans Escape s'il y a un erreur de donn‚ ou
          retourne 255 dans Escape s'il y a terminaison annormale. }

Procedure Question(X,Y:Byte;Var Chaine:String;Longeur:Byte;Var Escape:Byte);
Var Phrase   : String;
    Temp     : String;
    XPos     : Byte;
    LonPhr   : Byte;
    SegPhr   : Word;
    OfsPhr   : Word;
    Compteur : Byte;
    ToucheBy : Byte;
    Touche   : Char;
    OK       : Boolean;
    Quitter  : Boolean;

 Procedure FixeUnCaractere(X,Y,Caractere:Byte);
 Begin
  If(Caractere in [0,32])Then Mem[SEcran:(X+Y*80)*2] := 32
                         Else Mem[SEcran:(X+Y*80)*2] := 42; { * }
 End;

 Procedure Ecrit(X,Y:Byte;Chaine:String);
 Var Compteur : Byte;
 Begin
  For Compteur := 0 to Length(Chaine) - 1 do
  Begin
   FixeUnCaractere(X+Compteur,Y,Ord(Chaine[Compteur+1]));
  End;
 End;

 Procedure ClaireBoard;
 Var Compteur : Byte;
 Begin
  For Compteur := 0 to Longeur-1 do
  Begin
   FixeUnCube(X+Compteur,Y,$20,7);
  End;
 End;

 Procedure AutoInsert;
 Begin
  If((Mem[$0040:$17] and $80)<>0)Then FixeFormatCurseur(7,13)
                                 Else FixeCurseurOuvert;
 End;

 { Initiation }

 Procedure Init;
 Var Compteur : Byte;
     Carac    : Char;
 Begin
  ClaireBoard;
  Phrase := '';
  If(Chaine <> '')Then
  Begin
   For Compteur := 0 to Length(Chaine)-1 do
   Begin
    Carac := Chaine[Compteur+1];
    If(Carac > #32)Then IncStr(Phrase,Carac);
   End;
  End;
  If(Phrase <> '')Then
  Begin
   Ecrit(X,Y,Phrase);
   LonPhr := Length(Phrase);
   XPos   := LonPhr;
  End
   else
  Begin
   LonPhr := 0;
   XPos   := 0;
  End;
 End;

 Procedure Delete1;
 Begin
  Delete(Phrase,XPos+1,1);
  Dec(LonPhr);
 End;

 { Commande d'‚dition }

 Procedure CtrlLeftKey;
 Begin
  Ok       := False;
  Compteur := XPos;
  Repeat
   Dec(Compteur);
   ToucheBy := Ord(Phrase[Compteur]);
   If(ToucheBy < 42)or(ToucheBy in [91,93])Then
   Begin
    XPos := Compteur;
    Ok   := True;
   End
    else
   If(Compteur < 1)Then
   Begin
    XPos := 0;
    OK   := True;
   End;
  Until Ok;
 End;

 Procedure CtrlRightKey;
 Begin
  Ok       := False;
  Compteur := XPos;
  Repeat
   Inc(Compteur);
   ToucheBy := Ord(Phrase[Compteur]);
   If(ToucheBy < 42)or(ToucheBy in [91,93])Then
   Begin
    XPos := Compteur;
    Ok   := True;
   End
    else
   If(Compteur > LonPhr)Then
   Begin
    XPos := LonPhr;
    OK   := True;
   End;
  Until Ok;
 End;

 Procedure DeleteLineKey;
 Begin
  ClaireBoard;
  Phrase := '';
  LonPhr := 0;
  XPos   := 0;
 End;

 Procedure BackSpaceKey;
 Begin
  If(LonPhr > 1)Then
  Begin
   Delete(Phrase,XPos,1);
   Dec(XPos);
   Ecrit(X+XPos,Y,Copy(Phrase,XPos+1,255) + ' ');
   LonPhr := Length(Phrase);
  End
   else
  If(LonPhr = 1)Then DeleteLineKey
                Else Write(^G);
 End;

 Procedure DeleteKey;
 Begin
  If(LonPhr > 1)Then
  Begin
   Delete(Phrase,XPos+1,1);
   Ecrit(X+XPos,Y,Copy(Phrase,XPos+1,255) + ' ');
   LonPhr := Length(Phrase);
  End
   else
  If(LonPhr = 1)Then DeleteLineKey
                Else Write(^G);
 End;

 Procedure DeleteEOLKey;
 Var Compteur : Byte;
 Begin
  Delete(Phrase,XPos,255);
  For Compteur := XPos to LonPhr do
  Begin
   FixeUnCaractere(X+Compteur,Y,32);
  End;
  LonPhr := Length(Phrase);
 End;

 Procedure DeleteMotsKey;
 Begin
  If(XPos+1<LonPhr)Then
  Begin
   Ok := False;
   ToucheBy := LonPhr;
   Repeat
    If(Phrase[XPos+1] in [#32,#65..#90,#97..#122])and(XPos+1<LonPhr)Then Delete1
     Else Ok := True;
    If(XPos>=LonPhr)Then Ok := True;
   Until Ok;
   If(LonPhr = 1)Then DeleteLineKey
    else
   If(LonPhr = XPos + 1)Then
   Begin
    Phrase := Copy(Phrase,1,XPos);
    Dec(LonPhr);
   End;
   If(ToucheBy = LonPhr)Then Delete1;
  End;
  ClaireBoard;
  Ecrit(X,Y,Phrase);
 End;

 Procedure LeftKey;
 Begin
  If(XPos > 0)Then Dec(XPos)
              Else Write(^G);
 End;

 Procedure RightKey;
 Begin
  If(XPos < LonPhr)Then Inc(XPos)
                   Else Write(^G);
 End;

 { Insertion d'un caractŠre dans un phrase }

 Procedure EntreCar;
 Begin
  If(Longeur > LonPhr)Then
  Begin
   If((Mem[$0040:$17] and $80)<>0)Then { Insert On ? }
   Begin
    If(XPos < LonPhr)Then
    Begin
     Move(Phrase[XPos],Phrase[XPos+1],LonPhr-XPos+1);
     Mem[Seg(Phrase[XPos+1]):Ofs(Phrase[XPos+1])] := Ord(Touche);
     Mem[SegPhr:OfsPhr] := LonPhr + 1;
     Ecrit(X,Y,Phrase);
    End
     else
    Begin
     Mem[Seg(Phrase[XPos+1]):Ofs(Phrase[XPos+1])] := Ord(Touche);
     Mem[SegPhr:OfsPhr] := LonPhr + 1;
    End;
    FixeUnCaractere(X+XPos,Y,Ord(Touche));
    Inc(XPos);
    LonPhr := Length(Phrase);
   End
    else
   Begin
    Mem[Seg(Phrase[XPos+1]):Ofs(Phrase[XPos+1])] := Ord(Touche);
    If(XPos >= LonPhr)Then
    Begin
     Mem[SegPhr:OfsPhr] := LonPhr + 1;
    End;
    FixeUnCaractere(X+XPos,Y,Ord(Touche));
    Inc(XPos);
    LonPhr := Length(Phrase);
   End;
  End
   else
  Write(^G);
 End;

 { Traite le(s) Scan(s) Code(s) }

 Procedure TraiteScanCode;
 Begin
  Touche := ReadKey;
  Case Touche of
         #71 : XPos := 0;
         #75 : LeftKey;
         #77 : RightKey;
         #79 : XPos := LonPhr;
         #82 : AutoInsert;
         #83 : DeleteKey;
        #115 : CtrlLeftKey;
        #116 : CtrlRightKey;
    else
   Write(^G);
  End;
  Touche := #00;
 End;

Begin { Main Question }
 Quitter := False;
 Escape := 255;
 SegPhr := Seg(Phrase[0]);
 OfsPhr := Ofs(Phrase[0]);
 Init;
 AutoInsert;
 Repeat
  FixePositionCurseur(X+XPos,Y);
  Touche := ReadKey;
  If(KeyPressed)Then TraiteScanCode
   else
  Begin
   Case Touche of
           #8 : BackSpaceKey;
           ^Q : Begin
                 Touche := ReadKey;
                 If(KeyPressed)Then TraiteScanCode
                  else
                 Case Touche of
                  ^B : XPos := 0;
                  ^K : XPos := LonPhr;
                  ^L : Init;
                  ^Y : DeleteEOLKey;
           #32..#255 : EntreCar;
                   else
                  Write(^G);
                 End;
                 Touche := #0;
                End;
           ^T : DeleteMotsKey;
           ^Y : DeleteLineKey;
      #13,#27 : Begin End;
    #32..#255 : EntreCar;
     else
    Write(^G);
   End;
  End;
 Until (Touche in [#13,#27]);
 If(Touche = #13)Then
 Begin
  Chaine := Phrase;
  Escape := 0;
 End
  else
 If(Quitter = False)Then Escape := 1;
End;

Function TestePassWord:Byte;
Var VraiPassWord : String[14];
    Compteur     : Byte;
    Nombre       : Byte;
    Chaine       : String[14];
    Escape       : Byte;
    Tableau      : Pointer;
    Touche       : Word;
Begin
 SauvegardeEcran(Tableau);
  { Traite le mots de passe pour obtenir le mots r‚el }
 FillChar(VraiPassWord,SizeOf(VraiPassWord),0);
 For Compteur := 1 to Length(Config.PassWord) do
 Begin
  Nombre := Ord(Config.PassWord[Compteur]);
  IncStr(VraiPassWord,Chr(Nombre shl 4 + Nombre shr 4));
 End;
 Chaine := '';
 FixeFormatDouble;
 FIxeCadrePlain(10,8,40,14,CoulDcr);
 Ecrit(12,10,'Entr‚e le mots passe :',CoulDcr);
 Question(12,12,Chaine,14,Escape);
 Chaine := Maj(Chaine);
 FixeCurseurFermer;
 If(Chaine = VraiPassWord)and(Escape = 0)Then TestePassWord := 1
  Else
 Begin
  TestePassWord := 0;
  If(Escape = 0)Then
  Begin
   EffaceLigne(24,32,CoulErr);
   Ecrit(2,24,'Mots de passe invalide, presse une touche pour retourner...',CoulErr);
   Touche := LitClavier;
  End;
 End;
 RestituteEcran(Tableau);
End;

Procedure NouveauPassWord;
Label 10;
Var VraiPassWord : String[14];
    Compteur     : Byte;
    Nombre       : Byte;
    Chaine       : String[14];
    Escape       : Byte;
    Tableau      : Pointer;
    Touche       : Word;
Begin
 SauvegardeEcran(Tableau);
  { Traite le mots de passe pour obtenir le mots r‚el }
 FillChar(VraiPassWord,SizeOf(VraiPassWord),0);
 For Compteur := 1 to Length(Config.PassWord) do
 Begin
  Nombre := Ord(Config.PassWord[Compteur]);
  IncStr(VraiPassWord,Chr(Nombre shl 4 + Nombre shr 4));
 End;
 Config.PassWord := Maj(Config.PassWord);
 Chaine := '';
 FixeFormatDouble;
 FixeCadrePlain(10,8,50,14,$F0);
 Ecrit(12,10,'Entr‚e l''ancien mots passe :',$F0);
 Question(12,12,Chaine,14,Escape);
 Chaine := Maj(Chaine);
 FixeCurseurFermer;
 If(Chaine = VraiPassWord)and(Escape = 0)Then
 Begin
10:Chaine := '';
  FixeCadrePlain(10,8,50,14,$F0);
  Ecrit(12,10,'Entr‚e le nouveau mots passe :',$F0);
  Question(12,12,Chaine,14,Escape);
  Chaine := Maj(Chaine);
  If(Escape = 0)Then
  Begin
   VraiPassWord := '';
   FixeCadrePlain(10,8,70,14,$F0);
   Ecrit(12,10,'Entr‚e le nouveau mots passe (v‚rification) :',$F0);
   Question(12,12,VraiPassWord,14,Escape);
   If(Escape = 0)Then
   Begin
    If(Chaine <> VraiPassWord)Then Goto 10;
    VraiPassWord  := Maj(VraiPassWord);
     { Traite le mots de passe pour obtenir le mots r‚el }
    FillChar(Config.PassWord,SizeOf(Config.PassWord),0);
    For Compteur := 1 to Length(VraiPassWord) do
    Begin
     Nombre := Ord(VraiPassWord[Compteur]);
     IncStr(Config.PassWord,Chr(Nombre shl 4 + Nombre shr 4));
    End;
    EcritConfiguration(Config);
   End;
  End;
 End
  else
 If(Escape = 0)Then
 Begin
  EffaceLigne(24,32,CoulErr);
  Ecrit(2,24,'Erreur mots de passe invalide, presse une touche pour retouner...',CoulErr);
  Write(^G);
  Touche := LitClavier;
 End;
 FixeCurseurFermer;
 RestituteEcran(Tableau);
End;

BEGIN
 If(MemW[$0040:$63] = $3D4)Then SEcran := $B800;
END.
