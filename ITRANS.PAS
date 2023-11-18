(***********************************************************************)
(*                                                                     *)
(*                        Inventaire Transmission                      *)
(*                                                                     *)
(***********************************************************************)

Unit ITrans;

{$V-}

(***********************************************************************)
                               Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Type TransmissionType = Record
                         Ass      : Byte;
                         APrix    : Word;
                         ACent    : Byte;
                         Automat  : Byte;
                         Manuel   : Byte;
                         Traction : Byte;
                         Detail   : String[31];
                         XxX      : Byte;
                         Turbo    : Byte;
                         Actif    : Array[0..2] of Byte;
                         Prix     : Array[0..2] of Word;
                         Cent     : Array[0..2] of Byte;
                         Code     : Array[0..2] of String[7];
                         Loc      : Array[0..2] of String[7];
                         Clush    : Byte;
                         FlyWheel : Byte;
                         Modele   : String[21];
                        End;

Procedure AffichePieceTransmission(X,Y,Couleur:Byte);
Procedure FixeTransmission(Var Trans:TransmissionType;Var Escape:Boolean);

(***********************************************************************)
                              Implementation
(***********************************************************************)

Procedure AffichePieceTransmission(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
              'Pressure piate'+#1+
              'Fly wheel'+#1+
              'Transfer case');
End;

(***********************************************************************)

{
012345678901234567890123456789012345
ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»0
º                                  º1
º      Transmission complŠte       º2
º                                  º3
º  Automatique                     º4
º  Propultion arriŠre              º5
º  2x4                             º6
º  Turbo                           º7
º  Detail : _____________________  º8
º  Prix : _____.__                 º9
º  Localise : _______              º10
º  Code hollander : _______        º11
º                                  º12
ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼13
}

Procedure TransAssemble(Var Trans:TransmissionType;Var Escape:Byte);
Label 10,20,30,40,50,60,70,80,90;
Const X     = 2;
      Y     = 4;
      Ligne = 24;
      Auto : Array[0..5] of String[16] = ('Automatique Nor.',
                                          'Auto. Over Drive',
                                          'Manuel 3 vitesse',
                                          'Manuel 4 vitesse',
                                          'Manuel 5 vitesse',
                                          'Manuel 6 vitesse');
      Depl : Array[0..1] of String[18] = ('Traction avant    ',
                                          'Propultion arriŠre');
      YxY  : Array[0..1] of String[3] = ('2x4','4x4');
      TTur : Array[0..1] of String[11] = ('Automatique',
                                          'Turbo      ');
Var Touche : Word;
Begin
 With Trans do
 Begin
   { Initialise ‚cran }
  FixeCurseurFermer;
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+35,Y+13,15);
  Ecrit(X+7,Y+2,'Transmission complŠte',15);
  EcritSpecial(X+3,Y+4,#28'Automatique Nor.'#1'Traction avant'#1'2x4'#1+
  'Automatique'#1'D‚tail :'#1'Prix :'#1'Localise :'#1'Code hollander :');
  BarDeplacement;
10:Repeat
  Ecrit(X+3,Y+4,Auto[Automat],15);
  FixeUnCaractere(X+2,Y+4,16);
  Touche := LitClavier;
  FixeUnCaractere(X+2,Y+4,32);
  Case Touche of
   kbESC : Exit;
   kbIns : Max(Automat,5);
  kbDown : Goto 20;
    kbUp : Goto 80;
  End;
 Until (Touche = kbEnter);
20:Repeat
  FixeUnCaractere(X+2,Y+5,16);
  Ecrit(X+3,Y+5,Depl[Traction],15);
  Touche := LitClavier;
  FixeUnCaractere(X+2,Y+5,32);
  Case Touche of
   kbESC : Exit;
   kbIns : Max(Traction,1);
    kbUp : Goto 10;
  kbDown : Goto 30;
  End;
 Until (Touche = kbEnter);
30:Repeat
  FixeUnCaractere(X+2,Y+6,16);
  Ecrit(X+3,Y+6,YxY[XxX],15);
  Touche := LitClavier;
  FixeUnCaractere(X+2,Y+6,32);
  Case Touche of
   kbESC : Exit;
   kbIns : Max(XxX,1);
    kbUp : Goto 20;
  kbDown : Goto 40;
  End;
 Until (Touche = kbEnter);
40:Repeat
  FixeUnCaractere(X+2,Y+7,16);
  Ecrit(X+3,Y+7,TTur[Turbo],15);
  Touche := LitClavier;
  FixeUnCaractere(X+2,Y+7,32);
  Case Touche of
   kbESC : Exit;
   kbIns : Max(Turbo,1);
    kbUp : Goto 30;
  kbDown : Goto 50;
  End;
 Until (Touche = kbEnter);
50:FixeUnCaractere(X+2,Y+8,16);
  FixeLocaliseUD(X+12,Y+8,21,Detail,Escape);
  FixeUnCaractere(X+2,Y+8,32);
  Case Escape of
   1 : Exit;
   2 : Goto 40;
  End;
60:FixeUnCaractere(X+2,Y+9,16);
  FixeDollarUD(X+10,Y+9,8,APrix,ACent,Escape);
  FixeUnCaractere(X+2,Y+9,32);
  Case Escape of
   1 : Exit;
   2 : Goto 50;
  End;
70:FixeUnCaractere(X+2,Y+10,16);
  FixeLocaliseUD(X+14,Y+10,7,Loc[0],Escape);
  FixeUnCaractere(X+2,Y+10,32);
  Case Escape of
   1 : Exit;
   2 : Goto 60;
  End;
80:FixeUnCaractere(X+2,Y+11,16);
  FixeLocaliseUD(X+20,Y+11,7,Code[0],Escape);
  FixeUnCaractere(X+2,Y+11,32);
  Case Escape of
   1 : Exit;
   2 : Goto 70;
   3 : Goto 10;
  End;
90:
 End;
End;

{         1         2         3         4         5         6         7
01234567890123456789012345678901234567890123456789012345678901234567890123456
ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»0
º PiŠce          ³ Prix     ³ Description            ³ Localise ³ Code hol. º1
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ¶2
º Pressure piate ³ xxxxx.xx ³                        ³          ³           º3
º Fly wheel      ³ xxxxx.xx ³                        ³          ³           º4
º Transfer case  ³ xxxxx.xx ³                        ³          ³           º5
ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¼6}

Procedure TransDesassemble(Var Trans:TransmissionType;Var Escape:Byte);
Const X       = 2;
      Y       = 4;
      Hauteur = 2;
      NomBar  = 3;

      Position : Byte = 0;
      XPos     : Byte = 0;

      Serie  : Array[0..NomBar,0..2] of Byte = ((X+17,Y,Y+4+Hauteur),
                                                (X+28,Y,Y+4+Hauteur),
                                                (X+53,Y,Y+4+Hauteur),
                                                (X+64,Y,Y+4+Hauteur));
      TabBar : Array[0..NomBar+1,0..2] of Byte = ((X+1,Y+3,X+16),
                                                  (X+18,Y+3,X+27),
                                                  (X+29,Y+3,X+52),
                                                  (X+54,Y+3,X+63),
                                                  (X+65,Y+3,X+75));
Var Touche   : Word;
    Ancien   : Word;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;


 Procedure TClush;
 Const Choix : Array[0..1] of String[6] = ('Normal','Clush ');
 Begin
  Max(Trans.Clush,1);
  Ecrit(X+30,Y+3,Choix[Trans.Clush],15);
 End;

 Procedure TFlyWheel;
 Const Choix : Array[0..2] of String[11] = ('Non        ',
                                            'Automatique',
                                            'Manuel     ');
 Begin
  Max(Trans.FlyWheel,2);
  Ecrit(X+30,Y+4,Choix[Trans.FlyWheel],15);
 End;

 Procedure TModele;
 Var Escape : Byte;
 Begin
  FixeLocalise(X+30,Y+5,21,Trans.Modele,Escape);
 End;

Begin
 With Trans do
 Begin
  For Compteur := 0 to 2 do
  Begin
   If(Actif[Compteur] > 2)and
     (Cent[Compteur] > 100)and
     (Length(Code[Compteur]) > 7)and
     (Length(Loc[Compteur]) > 7)Then
   Begin
    Actif[Compteur] := 0;
    Prix[Compteur]  := 0;
    Cent[Compteur]  := 0;
    FillChar(Code[Compteur],SizeOf(Code[Compteur]),0);
    FillChar(Loc[Compteur],SizeOf(Loc[Compteur]),0);
   End;
  End;
  Escape := 0;
  BaseVisuel(X,Y,X+76,Y+6,NomBar+1,Serie,X+19,X+55,X+66);
  FixeFormatBar(NomBar+2,TabBar);
  Ecrit(X+30,Y+1,'Description',14);
  AffichePieceTransmission(X+2,Y+3,7);
  For Compteur := 0 to 2 do
  Begin
   If(Prix[Compteur] > 0)and(Cent[Compteur] > 0)Then
   Begin
    Ecrit(X+19,Y+3+Compteur,Strg(Prix[Compteur])+','+
                            Strg(Cent[Compteur])+'$',7+Actif[Compteur]*8);
   End
    else
   If(Prix[Compteur] > 0)Then
   Begin
    Ecrit(X+19,Y+3+Compteur,Strg(Prix[Compteur])+'$',Actif[Compteur]*8);
   End;
   Ecrit(X+55,Y+3+Compteur,Loc[Compteur],7+Actif[Compteur]*8);
   Ecrit(X+66,Y+3+Compteur,Code[Compteur],7+Actif[Compteur]*8);
   AfficheBar(Compteur,7+Actif[Compteur]*8);
  End;
  Repeat
   Ancien := kbAncien;
   Touche := AfficheBarTouche(Position,XPos,$F0,Actif[Position]*8+7);
   ToucheTab(2,4,Touche,Position,XPos,Actif[Position]);
   Case Touche of
    kbIns : Begin
             Case XPos of
              0 : Max(Actif[Position],1);
              1 : FixeDollar(X+19,Y+3+Position,8,Prix[Position],Cent[Position],Escape);
              2 : Case Position of
                   0 : TClush;
                   1 : TFlyWheel;
                   2 : TModele;
                  End;
              3 : FixeLocalise(X+55,Y+3+Position,7,Loc[Position],Escape);
              4 : FixeLocalise(X+66,Y+3+Position,7,Code[Position],Escape);
             End;
             If(Position > 0)Then Actif[Position] := 1;
             BarSelecteHori(X+1,Y+3+Position,X+75,Actif[Position]*8+7);
            End;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then Escape := 1;
 End;
End;

{ 0123456789012345678901234567890123456
  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»0
  º                                   º1
  º  Transmission complŠte (O/N) ? _  º2
  º                                   º3
  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼4 }

Function DemandeAssemble:Byte;
Const X = 0;
      Y = 1;
Begin
 FixeFormatDouble;
 FixeCadrePlain(X,Y,X+36,Y+4,15);
 Ecrit_OuiNon(X+3,Y+2,'Transmission complŠte (O/N) ?');
 DemandeAssemble := RepOuiNon(X+33,Y+2);
End;

Procedure FixeTransmission(Var Trans:TransmissionType;Var Escape:Boolean);
Var Reponse : Byte;
Begin
 Escape := False;
 Reponse := DemandeAssemble;
 Trans.Ass := Reponse + 1;
 Case Reponse of
  0 : TransDesassemble(Trans,Reponse);
  1 : TransAssemble(Trans,Reponse);
 End;
 If(Reponse > 0)Then Escape := True;
End;

BEGIN
END.
