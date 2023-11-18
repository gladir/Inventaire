(************************************************************************)
(*                                                                      *)
(*                           Inventaire Menu                            *)
(*                             13/04/1992                               *)
(*                                                                      *)
(* Compagnie   : Les Chevaliers de Malte                                *)
(* Concepteur  : Sylvain Maltais                                        *)
(* Programmeur : Sylvain Maltais                                        *)
(*                                                                      *)
(* Description : ˛ Cette unitÇ gere les menus.                          *)
(* Requäres    : ˛ Une carte graphics solution d'ATI (Small wonder).    *)
(*                 en mode texte monochrome (07h).                      *)
(*               ˛ Turbo Pascal 6 ou postÇrieur.                        *)
(*                                                                      *)
(************************************************************************)

Unit IMenu;

(************************************************************************)
                                Interface
(************************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Const  { Constante de la function "Menu" }

      SpaceIntro               = 0;
      SpaceInfo                = 1;
      SpaceRestore             = 2;
      AdditionAuto             = 5;
      AdditionPiece            = 6;
      AdittionClient           = 7;
      ModificationAuto         = 10;
      ModificationPiece        = 11;
      ModificationPassWord     = 12;
      ModificationClient       = 13;
      LectureAuto              = 15;
      LecturePiece             = 16;
      LectureCode              = 17;
      LectureLocalise          = 18;
      LectureClient            = 19;
      EffaceAuto               = 20;
      EffacePiece              = 21;
      EffaceClient             = 22;
      AdditionDevant           = 75;
      AdditionCowl             = 76;
      AdditionPorte            = 77;
      AdditionDerriere         = 78;
      AdditionMoteur           = 79;
      AdditionPieceMoteur      = 80;
      AdditionTransmission     = 81;
      AdditionFreins           = 82;
      AdditionSuspension       = 83;
      AdditionAxle             = 84;
      AdditionCapsRoues        = 85;
      AdditionMags             = 86;
      AdditionPneus            = 87;
      ModificationDevant       = 88;
      ModificationCowl         = 89;
      ModificationPorte        = 90;
      ModificationDerriere     = 91;
      ModificationMoteur       = 92;
      ModificationPieceMoteur  = 93;
      ModificationTransmission = 94;
      ModificationFreins       = 95;
      ModificationSuspension   = 96;
      ModificationAxle         = 97;
      ModificationCapsRoues    = 98;
      ModificationMags         = 99;
      ModificationPneus        = 100;
      LectureUnClient          = 110;
      LectureToutClient        = 111;
      Quitter                  = 255;

       { Constante de la function "SelectePiece" }

      Devant                   = 0;
      Cowl                     = 1;
      Porte                    = 2;
      Derriere                 = 3;
      Moteur                   = 4;
      PieceMoteur              = 5;
      Transmission             = 6;
      Freins                   = 7;
      Suspension               = 8;
      Axle                     = 9;

Procedure BarMenu;
Procedure BarRemarque;
Procedure MenuSpace;
Procedure MenuAddition;
Procedure MenuModification;
Procedure MenuLecture;
Procedure MenuEfface;
Procedure MenuVente;

Function Menu:Byte;
Function SelectePiece:ShortInt;
Function _SelectePiece(X,Y,Position:Byte):Byte;

(************************************************************************)
                               Implementation
(************************************************************************)

Const Adresse : Word = $B000;

      TEcran  = 4000;
      Colonne = 80;

Function SelectePiece:ShortInt;
Var Position : Byte;
    Touche   : Word;
Begin
 Position := 0;
  { Affiche Menu }
 FixeCadrePlain(32,5,47,22,CoulMnu);
 CentreEcriture(7,'Piäce',CoulMnu);
 CentreEcriture(9,'Devant',CoulMnu);
 CentreEcriture(10,'Cowl',CoulMnu);
 CentreEcriture(11,'Porte',CoulMnu);
 CentreEcriture(12,'Derriäre',CoulMnu);
 CentreEcriture(13,'Moteur',CoulMnu);
 CentreEcriture(14,'Piäce moteur',CoulMnu);
 CentreEcriture(15,'Transmission',CoulMnu);
 CentreEcriture(16,'Freins',CoulMnu);
 CentreEcriture(17,'Suspension',CoulMnu);
 CentreEcriture(18,'Axle',CoulMnu);
 CentreEcriture(19,'Caps de roues',CoulMnu);
 CentreEcriture(20,'Mags',CoulMnu);
 CentreEcriture(21,'Pneus',CoulMnu);
 Repeat
  BarSelecteHori(33,9+Position,46,CoulSlc);
  Touche := LitClavier;
  BarSelecteHori(33,9+Position,46,CoulMnu);
  TraiteScanCode(Position,12,Touche);
 Until (Touche = kbEnter)or(Touche = kbESC);
 If(Touche = kbEnter)Then SelectePiece := Position
                     Else SelectePiece := -1;
End;

Procedure BarMenu;
Begin
 FixeCurseurFermer;
 FixeClignotement(0);
 EffaceLigne(0,32,CoulMnu);
 FixeUnCube(2,0,240,CoulMnu);
 EcritChoix(5,0,'Addition',CoulMnu,CoulMnu);
 EcritChoix(15,0,'Modification',CoulMnu,CoulMnu);
 EcritChoix(29,0,'Consultation',CoulMnu,CoulMnu);
 EcritChoix(43,0,'Efface',CoulMnu,CoulMnu);
 EcritChoix(51,0,'Vente',CoulMnu,CoulMnu);
 EcritChoix(58,0,'Rapport',CoulMnu,CoulMnu);
End;

Procedure BarRemarque;
Begin
 EffaceLigne(24,32,CoulBar);
End;

Procedure MenuSpace;
Begin
 BarSelecteHori(1,0,3,CoulSlc);
 FixeCadrePlain(1,1,18,4,CoulMnu);
 Ecrit(3,2,'Intro',CoulMnu);
 Ecrit(3,3,'ComplÇmentaire',CoulMnu);
End;

Procedure MenuAddition;
Begin
 BarSelecteHori(4,0,13,CoulSlc);
 FixeCadrePlain(4,1,13,5,CoulMnu);
 Ecrit(6,2,'Auto',CoulMnu);
 Ecrit(6,3,'Piäce',CoulMnu);
 Ecrit(6,4,'Client',CoulMnu);
End;

Procedure MenuModification;
Begin
 BarSelecteHori(14,0,27,CoulSlc);
 FixeCadrePlain(14,1,27,6,CoulMnu);
 Ecrit(16,2,'Automobile',CoulMnu);
 Ecrit(16,3,'Piäce',CoulMnu);
 Ecrit(16,4,'Mots passe',CoulMnu);
 Ecrit(16,5,'Client',CoulMnu);
End;

Procedure MenuLecture;
Var CoulMnuUnSelecte : Byte;
Begin
 If(MemW[$0040:$63] = $3D4)Then CoulMnuUnSelecte := $FF
                           Else CoulMnuUnSelecte := $FF;
 BarSelecteHori(28,0,41,CoulSlc);
 FixeCadrePlain(28,1,45,7,CoulMnu);
 Ecrit(30,2,'Automobile',CoulMnu);
 Ecrit(30,3,'Piäce',CoulMnuUnSelecte);
 Ecrit(30,4,'Code hollander',CoulMnu);
 Ecrit(30,5,'Localise',CoulMnu);
 Ecrit(30,6,'Client',CoulMnu);
End;

Procedure MenuEfface;
Begin
 BarSelecteHori(42,0,49,CoulSlc);
 FixeCadrePlain(42,1,51,5,CoulMnu);
 Ecrit(44,2,'Auto',CoulMnu);
 Ecrit(44,3,'Piäce',CoulMnu);
 Ecrit(44,4,'Client',CoulMnu);
End;

Procedure MenuVente;
Var CoulMnuUnSelecte : Byte;
Begin
 If(MemW[$0040:$63] = $3B4)Then CoulMnuUnSelecte := $FF
                           Else CoulMnuUnSelecte := $FF;
 BarSelecteHori(50,0,56,CoulSlc);
 FixeCadrePlain(50,1,67,5,CoulMnu);
 Ecrit(52,2,'Piäce',CoulMnu);
 Ecrit(52,3,'Derniäre vente',CoulMnu);
 Ecrit(52,4,'Statistique',CoulMnuUnSelecte);
End;

Procedure MenuRapport;
Begin
 BarSelecteHori(57,0,65,CoulSlc);
 FixeCadrePlain(57,1,67,3,CoulMnu);
 Ecrit(59,2,'Complet',CoulMnu);
End;

Function _SelectePiece(X,Y,Position:Byte):Byte;
Var Touche : Word;
Begin
  { Affiche Menu }
 FixeCadrePlain(X,Y,X+16,Y+14,CoulMnu);
 EcritSpecial(X+2,Y+1,#3+Chr(CoulMnu)+'Devant'+#1+
                    'Cowl'+#1+
                    'Porte'+#1+
                    'Derriäre'+#1+
                    'Moteur'+#1+
                    'Piäce moteur'+#1+
                    'Transmission'+#1+
                    'Freins'+#1+
                    'Suspension'+#1+
                    'Axle'+#1+
                    'Caps de roues'+#1+
                    'Mags'+#1+
                    'Pneus');
 Repeat
  BarSelecteHori(X+1,Y+1+Position,X+15,CoulSlc);
  Touche := LitClavier;
  BarSelecteHori(X+1,Y+1+Position,X+15,CoulMnu);
  TraiteScanCode(Position,12,Touche);
 Until (Touche = kbEnter)or(Touche = kbESC);
 If(Touche = kbEnter)Then _SelectePiece := Position
                     Else _SelectePiece := 255;
End;

Function Menu:Byte;
Label 10;
Const Pos  : Array[0..6] of Byte = (0,0,0,0,0,0,0);
      YMax : Array[0..6] of Byte = (1,2,3,4,2,2,0);
      Bar  : Array[0..6,0..2] of Byte = ((2,2,17),(5,2,12),(15,2,26),
                                         (29,2,44),(43,2,50),(51,2,66),
                                         (58,2,66));
      XPos : Byte = 1;
Var Tableau : Pointer;
    Touche  : Word;
    Temp    : ShortInt;
    CoulMnuUnSelecte : Byte;

 Procedure AfficheMenu(Numero:Byte);
 Begin
  Case Numero of
   0 : MenuSpace;
   1 : MenuAddition;
   2 : MenuModification;
   3 : MenuLecture;
   4 : MenuEfface;
   5 : MenuVente;
   6 : MenuRapport;
  End;
 End;

 Function ConsultationClient:Byte;
 Const X = 29;
       Y = 7;

       Position : Byte = 0;
 Var Tableau : Pointer;
 Begin
  SauvegardeEcran(Tableau);
  FixeCadrePlain(X,Y,X+19,Y+3,CoulMnu);
  EcritSpecial(X+2,Y+1,#3+Chr(CoulMnu)+
                       'Un Client'+#1+
                       'Tous les clients');
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+18,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+18,CoulMnu);
   TraiteScanCode(Position,1,Touche);
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbEnter)Then
  Begin
   FreeMem(Tableau,TEcran);
   ConsultationClient := Position;
  End
   Else
  Begin
   RestituteEcran(Tableau);
   ConsultationClient := 255;
  End;
 End;

Begin
 If(MemW[$0040:$63] = $3D4)Then CoulMnuUnSelecte := $FF
                           Else CoulMnuUnSelecte := $FF;
 FixeFormatSimple;
 BarRemarque;
 EcritDerLigne('UtilisÇ les fläches pour les dÇplacements et <ENTER> pour sÇlectionner.');
 SauvegardeEcran(Tableau);
 FixeFormatBar(7,Bar);
10:AfficheMenu(XPos);
 Repeat
  Touche := AfficheBarTouche(Pos[XPos],XPos,CoulSlc,CoulMnu);
  If((Pos[XPos] = 1)and(XPos = 3))or((Pos[XPos]=2)and(XPos = 5))Then
  Begin
   BarSelecteHori(Bar[XPos,0],2+Pos[XPos],Bar[XPos,2],CoulMnuUnSelecte);
  End;
  TraiteScanCode(Pos[XPos],YMax[XPos],Touche);
  Case Touche of
kbLeft : Begin
          Move(Tableau^,Mem[Adresse:0],TEcran);
          Min(XPos,6);
          AfficheMenu(XPos);
         End;
kbRight: Begin
          Move(Tableau^,Mem[Adresse:0],TEcran);
          Max(XPos,6);
          AfficheMenu(XPos);
         End;
  End;
 Until (Touche = kbEnter)or(Touche = kbESC);
 If(Touche = kbESC)Then Menu := 255
  else
 Begin
  BarSelecteHori(Bar[XPos,0],Bar[XPos,1]+Pos[XPos],Bar[XPos,2],CoulSlc);
  If(XPos = 1)and(Pos[XPos] = 1)Then
  Begin
   Temp := _SelectePiece(5,4,0);
   If(Temp = -1)Then
   Begin
    Move(Tableau^,Mem[Adresse:0],TEcran);
    Goto 10;
   End
    Else
   Menu := 75 + Temp;
  End
   else
  If(XPos = 2)and(Pos[XPos] = 1)Then
  Begin
   Temp := _SelectePiece(15,4,0);
   If(Temp = -1)Then
   Begin
    Move(Tableau^,Mem[Adresse:0],TEcran);
    Goto 10;
   End
    Else
   Menu := 88 + Temp;
  End
   Else
  If(XPos = 3)and(Pos[XPos] = 4)Then
  Begin
   Temp := ConsultationClient;
   If(Temp = 255)Then Goto 10
    else
   Menu := 110 + Temp;
  End
   Else
  Menu := XPos * 5 + Pos[XPos];
 End;
 RestituteEcran(Tableau);
 BarRemarque;
End;

BEGIN
 If(MemW[$0040:$63] = $3D4)Then
 Begin
  Adresse := $B800;
 End;
END.
