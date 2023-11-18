(************************************************************************)
(*                                                                      *)
(*                          Inventaire Porte                            *)
(*                             1992/05/14                               *)
(*                                                                      *)
(* Compagnie   : Les Chevaliers de Malte                                *)
(* Concepteur  : Sylvain Maltais                                        *)
(* Programmeur : Sylvain Maltais                                        *)
(*                                                                      *)
(* Description : þ Cette proc‚dure fixe le donn‚ de l'utilisateur vers  *)
(*                 m‚moire.                                             *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).    *)
(*                 en mode texte monochrome (07h).                      *)
(*               þ Turbo Pascal 6 ou post‚rieur.                        *)
(*                                                                      *)
(************************************************************************)

Unit IPorte;

{$V-}

(************************************************************************)
                                Interface
(************************************************************************)

Uses Drivers,EcrMono,IVisuel,IChaine,IClavier,IQuest;

Const CadreSimple : TypeCadre = (218,196,191,179,179,192,196,217,196);
      EC  = 0;
      ET  = 1;
      MC  = 2;
      MT  = 3;

Type PorteType = Record
                  Ass       : Byte;
                  Prix      : Word;
                  Cent      : Byte;
                  Actif     : Array[0..3] of Byte;
                  Poteau    : Byte;
                  Regulator : Byte;
                  KeyLess   : Byte;
                  VitreVent : Array[0..1] of Byte;
                  TCVitrVen : Array[0..1] of Byte;
                  CeinPorte : Array[0..1] of Byte;
                  TypeP     : Array[0..3] of Byte;
                  TC        : Array[0..3] of Byte;
                  Loc       : Array[0..3] of String[7];
                  Code      : Array[0..3] of String[7];
                  Endom     : Array[0..3] of String[31];
                  Prx       : Array[0..3] of Word;
                  Cnt       : Array[0..3] of Byte;
                 End;

Procedure AffichePiecePorte(X,Y,Couleur:Byte);
Procedure FixePorte(Var Porte:PorteType;Var Escape:Boolean);

(************************************************************************)
                             Implementation
(************************************************************************)

Const Logique : Array[0..1] of String[3] = ('Non','Oui');

Type PorteAsmType = Record
                     Ass    : Byte;
                     Poteau : Byte;
                     Prix   : Word;
                     Cent   : Byte;
                    End;

Procedure AffichePiecePorte(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+'AVG'#1'AVD'#1'ARG'#1'ARD');
End;

(************************************************************************)
(*                                                                      *)
(* Description    : þ Demande si vous d‚sirez des portes assembl‚e ou   *)
(*                    d‚sassembl‚e et ensuite il demande s'il y a un    *)
(*                    poteau au centre, si oui, il demande le prix.     *)
(* Note           : þ La proc‚dure ne restitue pas l'‚cran original.    *)
(*                  þ Cette proc‚dure est cach‚, il n'y a aucun raison  *)
(*                    de la d‚clarer.                                   *)
(* Image produite :                                                     *)
(*                                                                      *)
(*    0123456789012345678901234567890123                                *)
(*   0ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿0                               *)
(*   1³                                ³1                               *)
(*   2³             Portes             ³2                               *)
(*   3³                                ³3                               *)
(*   4³ Porte assembl‚ (O/N) ? _       ³4                               *)
(*   5³ Poteau centre (O/N) ? _        ³5                               *)
(*   6³ Prix : _____.__                ³6                               *)
(*   7³                                ³7                               *)
(*   8ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ8                               *)
(*    0123456789012345678901234567890123                                *)
(*                                                                      *)
(************************************************************************)

Procedure DemandePorteAsm(Var PorteAsm:PorteAsmType;Var Escape:Byte);
Const X = 0;
      Y = 1;
Begin
 FixeFormatDouble;
 FixeCadrePlain(X,Y,X+33,Y+8,15);
 Ecrit(X+14,Y+2,'Portes',15);
 Ecrit_OuiNon(X+2,Y+4,'Porte assembl‚ (O/N) ?');
 With PorteAsm do
 Begin
  Escape := RepOuiNon(X+25,Y+4); { 0 = Non, 1 = Oui, 2 = Escape }
  If(Escape = 2)Then
  Begin
   Escape := 1;
   Exit;
  End;
  Ass := Escape;
  Ecrit_OuiNon(X+2,Y+5,'Poteau centre (O/N) ?');
  Escape := RepOuiNon(X+23,Y+5);
  If(Escape < 2)Then Poteau := Escape
   else
  Begin
   Escape := 1;
   Exit;
  End;
  Escape := 0;
  If(Poteau = 1)Then
  Begin
   Ecrit(X+2,Y+6,'Prix :',15);
   FixeDollar(X+9,Y+6,8,Prix,Cent,Escape);
  End;
 End;
End;

(************************************************************************)
(*                                                                      *)
(* Description    : þ GenŠre une tableau de lexique avec comme          *)
(*                    coordonn‚ du coin sup‚rieur gauche X et Y (pour   *)
(*                    l'image, voir image produite.                     *)
(* Note           : þ La proc‚dure ne restitue pas l'‚cran original.    *)
(*                  þ Cette proc‚dure est cach‚, il n'y a aucun raison  *)
(*                    de la d‚clarer.                                   *)
(* Image produite :                                                     *)
(*                                                                      *)
(*       012345678901234567890123456789012345678901234567890123         *)
(*      0ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿0        *)
(*      1³  Lexique  ³                                        ³1        *)
(*      2ÃÄÄÄÄÄÄÄÄÄÄÄÙ                                        ³2        *)
(*      3³  ARG : ArriŠre Gauche        ARD : ArriŠre Droite  ³3        *)
(*      4³  AVD : Avant Droite          AVG : Avant Gauche    ³4        *)
(*      5³  CP  : Ceinture dans porte   KLE : Keyless Entry   ³5        *)
(*      6³  VV  : Vitre de ventilation                        ³6        *)
(*      7ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ7        *)
(*                                                                      *)
(************************************************************************)

Procedure Lexique(X,Y:Byte);
Begin
 FixeFormatCadre(CadreSimple);
 FixeCadrePlain(X,Y,X+57,Y+9,CoulHlp);
 FixeUnCaractere(X+12,Y,194);
 FixeUnCaractere(X+12,Y+1,179);
 FixeUnCaractere(X+12,Y+2,217);
 BarTexteHori(X+1,Y+2,X+11,196,CoulHlp);
 FixeUnCaractere(X,Y+2,195);
 EcritSpecial(X+3,Y+1,#3+Chr(CoulHlp)+'Lexique'#1#1+
                      'ARG : ArriŠre Gauche'#4#8' ARD : ArriŠre Droite'+#1+
                      'AVD : Avant Droite'#4#10' AVG : Avant Gauche'#1+
                      'CP  : Ceinture dans porte   KLE : Keyless Entry'#1+
                      'VV  : Vitre de ventilation  EC  : Electrique-Claire'#1+
                      'ET  : Electrique-tint‚      MC  : Manuel-Claire'#1+
                      'MT  : Manuel-tint‚');
End;

(************************************************************************)
(*                                                                      *)
(*                            Porte assembl‚                            *)
(*                                                                      *)
(* Image produite :                                                     *)
(*                                                                      *)
(*ÚÄÄÄÄÄÂÄÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ¿*)
(*³Porte³Type³VV ³CP ³KLE³Endommag‚                   ³Localise³Code h.³*)
(*ÃÄÄÄÄÄÅÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´*)
(*³AVG  ³    ³   ³   ³   ³                            ³        ³       ³*)
(*³AVD  ³    ³   ³   ³   ³                            ³        ³       ³*)
(*³ARG  ³    ³   ³   ³   ³                            ³        ³       ³*)
(*³ARD  ³    ³   ³   ³   ³                            ³        ³       ³*)
(*ÀÄÄÄÄÄÁÄÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÙ*)
(*                                                                      *)
(*  ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿              *)
(*  ³  Lexique  ³                                        ³              *)
(*  ÃÄÄÄÄÄÄÄÄÄÄÄÙ                                        ³              *)
(*  ³  ARG : ArriŠre Gauche        ARD : ArriŠre Droite  ³              *)
(*  ³  AVD : Avant Droite          AVG : Avant Gauche    ³              *)
(*  ³  CP  : Ceinture dans porte   KLE : Keyless Entry   ³              *)
(*  ³  VV  : Vitre de ventilation                        ³              *)
(*  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ              *)
(*                                                                      *)
(************************************************************************)

Procedure FixePorteAssemble(Var Porte:PorteType;Var Escape:Byte);
Const X      = 3;
      Y      = 4;
      NomBar = 6;

      Position : Byte = 0;
      XPos     : Byte = 0;

      Serie : Array[0..NomBar,0..2] of Byte = ((X+6,Y,Y+7),
                                               (X+11,Y,Y+7),
                                               (X+15,Y,Y+7),
                                               (X+19,Y,Y+7),
                                               (X+23,Y,Y+7),
                                               (X+52,Y,Y+7),
                                               (X+61,Y,Y+7));
      TabBar : Array[0..NomBar+1,0..2] of Byte = ((X+1,Y+3,X+5),
                                                  (X+7,Y+3,X+10),
                                                  (X+12,Y+3,X+14),
                                                  (X+16,Y+3,X+18),
                                                  (X+20,Y+3,X+22),
                                                  (X+24,Y+3,X+51),
                                                  (X+53,Y+3,X+60),
                                                  (X+62,Y+3,X+68));
Var Touche   : Word;
    Ancien   : Word;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;

 Procedure TypePorte;
 Const DataType : Array[0..3] of String[2] = ('EC','ET','MC','MT');
       PosY     : Byte = 0;
       XP = X + 20;
       YP = Y + 10;
 Var Compteur : Byte;
     Tableau  : Pointer;
     Touche   : Word;
 Begin
  SauvegardeEcran(Tableau);
  FixeCadrePlain(XP,YP,XP+10,YP+7,$F0);
  Ecrit(XP+2,YP+1,'Type :',$F0);
  For Compteur := 0 to 3 do Ecrit(XP+2,YP+3+Compteur,DataType[Compteur],$F0);
  Repeat
   BarSelecteHori(XP+1,YP+3+PosY,XP+9,31);
   Touche := LitClavier;
   BarSelecteHori(XP+1,YP+3+PosY,XP+9,$F0);
   TraiteScanCode(PosY,3,Touche);
  Until (Touche = kbEsc)or(Touche = kbEnter);
  RestituteEcran(Tableau);
  If(Touche = kbEnter)Then
  Begin
   Porte.TypeP[Position] := PosY;
   Ecrit(X+12,Y+3,DataType[Position],31);
  End;
 End;

 Procedure KeyLessEntry;
 Begin
  If(Position = 0)Then
  Begin
   Max(Porte.KeyLess,1);
   Ecrit(X+16,Y+3+Position,Logique[Porte.KeyLess],31);
  End
   else
  Write(^G);
 End;

 Procedure CeinturePorte;
 Begin
  If(Position < 2)Then
  Begin
   Max(Porte.CeinPorte[Position],1);
   Ecrit(X+16,Y+3+Position,Logique[Porte.CeinPorte[Position]],31);
  End
   else
  Write(^G);
 End;

 Procedure VentilationVitre;
 Begin
  If(Position < 2)Then
  Begin
   Max(Porte.VitreVent[Position],1);
   Ecrit(X+12,Y+3+Position,Logique[Porte.VitreVent[Position]],31);
  End
   else
  Write(^G);
 End;

Begin
 With Porte do
 Begin
   { Initialise Donnee }
  For Compteur := 0 to 3 do
  Begin
   If(Actif[Compteur] > 1)or
     (TypeP[Compteur] > 3)or
     (Length(Code[Compteur]) > 7)or
     (Length(Loc[Compteur]) > 7)or
     (Length(Endom[Compteur]) > 31)Then
   Begin
    Actif[Compteur] := 0;
    TypeP[Compteur] := 0;
    FillChar(Loc[Compteur],SizeOf(Loc[Compteur]),0);
    FillChar(Code[Compteur],SizeOf(Code[Compteur]),0);
    FillChar(Endom[Compteur],SizeOf(Endom[Compteur]),0);
   End;
  End;
  Escape := 0;
   { Initialise ecran }
  FixeCurseurFermer;
  FixeFormatBar(NomBar+2,TabBar);
  Lexique(X+2,Y+9);
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+69,Y+7,31);
  Ecrit(X+1,Y+1,'Porte Type VV  CP  KLE Endommag‚',31);
  Ecrit(X+53,Y+1,'Localise Code h.',31);
  BarTableHori(X,Y+2,X+69,31);
  BarSerieVert(NomBar+1,Serie,31);
  AffichePiecePorte(X+1,Y+3,7+16);
  BarDeplacement;
  Repeat
   Ancien := kbAncien;
   Touche := AfficheBarTouche(Position,XPos,$F0,Actif[Position]*8+7+16);
   ToucheTab(3,NomBar+1,Touche,Position,XPos,Actif[Position]);
   Case Touche of
    kbTab : Max(XPos,NomBar+1);
    kbIns : Begin
             Escape := 0;
             Case XPos of
              0 : Max(Actif[Position],1);
              1 : TypePorte;
              2 : VentilationVitre;
              3 : CeinturePorte;
              4 : KeyLessEntry;
              5 : FixeLocalise(X+24,Y+3+Position,27,Endom[Position],Escape);
              6 : FixeLocalise(X+53,Y+3+Position,7,Loc[Position],Escape);
              7 : FixeLocalise(X+62,Y+3+Position,7,Code[Position],Escape);
             End;
             If(Escape = 0)and(XPos > 0)Then Actif[Position] := 1;
             BarSelecteHori(X+1,Y+3+Position,X+69,Actif[Position]*8+7+16);
            End;
   End;
  Until (Touche = kbEsc)or(Touche = kbEnter);
  If(Touche = kbEsc)Then Escape := 1;
 End;
End;

(************************************************************************)
(*                                                                      *)
(*                          Porte d‚sassembl‚                           *)
(*                                                                      *)
(* Image produite :                                                     *)
(*                                                                      *)
(*                  01234567890123456789012345678901234                 *)
(*                  ÉÍÍÍÍÍÑÍÍÍÑÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»--------+                 *)
(*                  ºVitre³T/C³VV ³RegulateurºPrix    |                 *)
(*                  ÇÄÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄ¶--------+                 *)
(*                  ºAVG  ³   ³   ³          º        |                 *)
(*                  ºAVD  ³   ³   ³          º        |                 *)
(*                  ºARG  ³   ³   ³          º        |                 *)
(*                  ºARD  ³   ³   ³          º        |                 *)
(*                  ÈÍÍÍÍÍÏÍÍÍÏÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¼--------+                 *)
(*                                                                      *)
(************************************************************************)

Procedure FixePorteDesassemble(Var Porte:PorteType;Var Escape:Byte);
Label Debut;
Const X       = 20;
      Y       = 4;
      NomBar  = 3;
      Hauteur = 3;
      MaxX    = X + 33;

      Position : Byte = 0;
      XPos     : Byte = 0;

      Serie  : Array[0..NomBar,0..2] of Byte = ((X+6,Y,Y+4+Hauteur),
                                                (X+10,Y,Y+4+Hauteur),
                                                (X+14,Y,Y+4+Hauteur),
                                                (X+25,Y,Y+4+Hauteur));
      TabBar : Array[0..NomBar+1,0..2] of Byte = ((X+1,Y+3,X+5),
                                                  (X+7,Y+3,X+9),
                                                  (X+11,Y+3,X+13),
                                                  (X+15,Y+3,X+24),
                                                  (X+26,Y+3,MaxX));
      Choix : Array[0..2] of String[3] = ('Non','T  ','C  ');

Var Touche   : Word;
    Ancien   : Word;
    kbAncien : Word Absolute $0040:$1A;
    Complet  : Byte;
    Compteur : Byte;

 Procedure TCPorte;
 Begin
  Max(Porte.TC[Position],2);
  Ecrit(X+7,Y+3+Position,Choix[Porte.TC[Position]],31);
 End;

 Procedure VitreVentialation;
 Begin
  If(Position < 2)Then
  Begin
   Max(Porte.VitreVent[Position],2);
   Ecrit(X+11,Y+3+Position,Choix[Porte.VitreVent[Position]],31);
  End
   else
  Write(^G);
 End;

 Procedure RegulateurPorte;
 Const Reg : Array[0..2] of String[10] = ('Non       ',
                                          'Electrique',
                                          'Manuel    ');
 Begin
  If(Position = 0)Then
  Begin
   Max(Porte.Regulator,2);
   Ecrit(X+15,Y+3+Position,Reg[Porte.Regulator],31);
  End
   else
  Write(^G);
 End;

 Procedure TPrix;
 Var Basse : Byte;
 Begin
  FixeDollar(X+26,Y+3+Position,8,Porte.Prx[Position],Porte.Cnt[Position],Basse);
 End;

Begin
 With Porte do
 Begin
   { Initialise donnee }
  For Compteur := 0 to 3 do
  Begin
   If(Actif[Compteur] > 1)or
     (Cnt[Compteur] > 100)Then
   Begin
    Actif[Compteur] := 0;
    Prx[Compteur]   := 0;
    Cnt[Compteur]   := 0;
    TC[Compteur]    := 0;
   End;
  End;
Debut:Escape := 0;
   { Initialise ecran }
  FixeCurseurFermer;
  FixeFormatBar(NomBar+2,TabBar);
  Lexique(X-2,Y+6+Hauteur);
  FixeFormatDouble;
  FixeCadrePlain(X,Y,MaxX+1,Y+4+Hauteur,31);
  Ecrit(X+1,Y+1,'Vitre T/C VV  Regulateur Prix',30);
  BarTableHori(X,Y+2,MaxX+1,31);
  BarSerieVert(NomBar+1,Serie,31);
  AffichePiecePorte(X+1,Y+3,23);
  BarDeplacement;
  Repeat
   Ancien := kbAncien;
   Touche := AfficheBarTouche(Position,XPos,$F0,Actif[Position]*8+7+16);
   ToucheTab(Hauteur,NomBar+1,Touche,Position,XPos,Actif[Position]);
   Case Touche of
    kbTab : Max(XPos,NomBar+1);
    kbIns : Begin
             Escape := 0;
             Case XPos of
              0 : Max(Actif[Position],1);
              1 : TCPorte;
              2 : VitreVentialation;
              3 : RegulateurPorte;
              4 : TPrix;
             End;
             If(Escape = 0)and(XPos > 0)Then Actif[Position] := 1;
             BarSelecteHori(X+1,Y+3+Position,MaxX,7+Actif[Position]*8+16);
            End;
   End;
  Until (Touche = kbEsc)or(Touche = kbEnter);
  If(Touche = kbEsc)Then Escape := 1;
 End;
End;

(************************************************************************)

Procedure FixePorte(Var Porte:PorteType;Var Escape:Boolean);
Label Debut;
Const X = 3;
      Y = 2;
Var PorteAsm : PorteAsmType;
    EscapeB  : Byte;
    Tableau  : Pointer;
Begin
 FillChar(PorteAsm,SizeOf(PorteAsm),0);
 EscapeB := 0;
Debut:DemandePorteAsm(PorteAsm,EscapeB);
 If(EscapeB = 0)Then
 Begin
  Porte.Ass    := PorteAsm.Ass;
  Porte.Poteau := PorteAsm.Poteau;
  Porte.Prix   := PorteAsm.Prix;
  Porte.Cent   := PorteAsm.Cent;
  SauvegardeEcran(Tableau);
  Case Porte.Ass of
   0 : FixePorteDesassemble(Porte,EscapeB);
   1 : FixePorteAssemble(Porte,EscapeB);
  End;
  RestituteEcran(Tableau);
  If(EscapeB = 1)Then Goto Debut;
  Escape := False;
 End
  Else
 Escape := True;
End;

BEGIN
END.
