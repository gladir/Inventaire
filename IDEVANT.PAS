(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Devant                          *)
(*                             1992/04/08                              *)
(*                                                                     *)
(* Compagnie   : Les Chevaliers de Malte                               *)
(* Concepteur  : Sylvain Maltais                                       *)
(* Programmeur : Sylvain Maltais                                       *)
(*                                                                     *)
(* Description : þ Cette proc‚dure fixe le donn‚ de l'utilisateur vers *)
(*                 m‚moire.                                            *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).   *)
(*                 en mode texte monochrome (07h).                     *)
(*               þ Turbo Pascal 6 ou post‚rieur.                       *)
(*                                                                     *)
(***********************************************************************)

Unit IDevant;

{$V-}

(***********************************************************************)
                              Interface
(***********************************************************************)

Uses Drivers,EcrMono,IChaine,IClavier,IVisuel;

Const Aucun             = 0;
      Droite            = 1;
      Gauche            = 2;
      Deux              = 3;
      Manuel            = 0;
      Automatique       = 1;
      Electrique        = 0;
      Thermo            = 1;

      Bumper            = 0;
      Valence           = 1;
      Grille            = 2;
      HeaderPannel      = 3;
      HeadLampDor       = 4;
      HeadLamp          = 5;
      HeadLampMotor     = 6;
      ParkLamp          = 7;
      CondenseurAir     = 8;
      Radiateur         = 9;
      FanRadiateur      = 10;
      AileGauche        = 11;
      AileDroite        = 12;
      FrameRail         = 13;
      Frame             = 14;
      Capot             = 15;

Type DevantCompletType = Record
                          DevantComplet : Byte;
                          Prix          : Word;
                          Cent          : Byte;
                          Localise      : String[7];
                          Code          : String[7];
                         End;
     DevantType  = Record
                    AvantComplet : DevantCompletType;
                    Actif        : Array[0..15] of Byte;
                    Prix         : Array[0..15] of Word;
                    Cent         : Array[0..15] of Byte;
                    Pos          : Array[0..15] of String[7];
                    Code         : Array[0..15] of String[7];
                    Radiateur    : Manuel..Automatique;
                    FanRadiateur : Electrique..Thermo;
                    FrameRail    : Aucun..Deux;
                   End;

Procedure AffichePieceDevant(X,Y,Couleur:Byte);
Procedure FixeDevant(Var Devant:DevantType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure WriteLn(Chaine:String);
Begin
End;

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure Write(Chaine:String);
Begin
End;

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure GotoXY(X,Y:Byte);
Begin
End;

Procedure AffichePieceDevant(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
              'Bumper avant'+#1+
              'Valence'+#1+
              'Grille'+#1+
              'Header panel'+#1+
              'Headlamp dor'+#1+
              'Headlamp'+#1+
              'Headlamp motor'+#1+
              'Parklamp'+#1+
              'Condenseur d''air'+#1+
              'Radiateur'+#1+
              'Fan radiateur'+#1+
              'Aile gauche'+#1+
              'Aile droite'+#1+
              'Frame'+#1+
              'Frame rail'+#1+
              'Capot');
End;

Procedure FixeDevant(Var Devant:DevantType;Var Escape:Boolean);
Label Debut,10,V0,V1,V3,V7,V8,20,30;
Const Position : Byte = 0;
      XPos     : Byte = 0;
      XD       = 2;
      YD       = 2;
      TabBar   : Array[0..14] of Byte = (XD+2,YD+4,XD+19,XD+22,YD+4,XD+31,
                                         XD+33,YD+4,XD+42,XD+44,YD+4,XD+52,
                                         XD+54,YD+4,XD+67);
      SerieVer : Array[0..11] of Byte = (XD+21,YD+1,YD+20,XD+32,YD+1,YD+20,
                                         XD+43,YD+1,YD+20,XD+53,YD+1,YD+20);
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Tableau  : Pointer;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;

 Procedure FixeFrameRail;
 Const X     = 33 + XD;
       Y     = 10 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+13);
 Var Pos      : ShortInt;
     Chaine   : String[7];
 Begin
  Pos := MiniMenu(X,Y,X+15,Y+7,Serie,'Frame Rail :','Aucun'#1'Droite'#1'Gauche'#1'Deux');
  If(Pos <> -1)Then
  Begin
   Devant.FrameRail := Pos;
   Case Pos of
    Aucun  : Chaine := 'Aucun';
    Droite : Chaine := 'Droite';
    Gauche : Chaine := 'Gauche';
    Deux   : Chaine := 'Deux';
   End;
   Ecrit(XD+33,YD+18,Chaine,15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,7 + Devant.Actif[Position] * 8);
  End;
  Basse := 0;
 End;

 Procedure FixeRadiateur;
 Const X = 33 + XD;
       Y = 14 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+14);
 Var Pos : ShortInt;
 Begin
  Pos := MiniMenu(X,Y,X+16,Y+5,Serie,'Radiateur :','Manuel'#1'Automatique');
  If(Pos <> -1)Then
  Begin
   Devant.Radiateur := Pos;
   If(Pos = 0)Then Ecrit(XD+33,YD+13,'Manuel',15)
              Else Ecrit(XD+33,YD+13,'Automatic',15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,7 + Devant.Actif[Position] * 8);
  End;
  Basse := 0;
 End;

 Procedure FixeFanRadiateur;
 Const X = 33 + XD;
       Y = 15 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+16);
 Var Pos : ShortInt;
 Begin
  Pos := MiniMenu(X,Y,X+18,Y+5,Serie,'Fan Radiateur :','Electrique'#1'Thermo');
  If(Pos <> -1)Then
  Begin
   Devant.FanRadiateur := Pos;
   If(Pos = 0)Then Ecrit(XD+33,YD+14,'Electrique',15)
              Else Ecrit(XD+33,YD+14,'Thermo',15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,Devant.Actif[Position] * 8 + 7);
  End;
  Basse := 0;
 End;

Begin
 If(Devant.AvantComplet.DevantComplet > 2)Then
 Begin
  FillChar(Devant,SizeOf(Devant),0);
 End;
Debut:FixeFormatBar(5,TabBar);
 Escape := False;
 FixeCurseurFermer;
 FixeClignotement(0);
 FixeFormatDouble;
 FixeCadrePlain(0,1,39,8,15);
 Ecrit_OuiNon(2,2,'Devant Complet (O/N) ?');
 If(Devant.AvantComplet.DevantComplet > 0)Then
 Begin
  Basse := Devant.AvantComplet.DevantComplet - 1;
  FixeUnCaractere(25,2,78+Basse);
 End
  else
10:Basse := RepOuiNon(25,2);
 If(Basse = 2)Then
 Begin
  Escape := True;
  Exit;
 End
  else
 If(Basse = 0)Then
 Begin
  SauvegardeEcran(Tableau);
  For Compteur := 0 to 15 do
  Begin
   If((Devant.Actif[Compteur] > 1)or
      (Length(Devant.Code[Compteur]) > 7)or
      (Length(Devant.Pos[Compteur]) > 7)or
      (Devant.Cent[Compteur] > 100))Then
   Begin
    Devant.Actif[Compteur] := 0;
    Devant.Prix[Compteur]  := 0;
    Devant.Cent[Compteur]  := 0;
    FillChar(Devant.Pos[Compteur],SizeOf(Devant.Pos[Compteur]),0);
    FillChar(Devant.Code[Compteur],SizeOf(Devant.Code[Compteur]),0);
    Devant.Radiateur       := 0;
    Devant.FanRadiateur    := 0;
    Devant.FrameRail       := 0;
   End;
  End;
  Devant.AvantComplet.DevantComplet := 1;
  BaseVisuel(XD,YD+1,XD+68,YD+20,4,SerieVer,XD+22,XD+44,XD+54);
  Ecrit(XD+33,YD+2,'Descrip.',14);
  AffichePieceDevant(XD+2,YD+4,7);
  For Compteur := 0 to 15 do
  Begin
   If(Devant.Prix[Compteur] > 0)or
     (Devant.Cent[Compteur] > 0)Then
   Begin
    Ecrit(XD+22,YD+4+Compteur,Strg(Devant.Prix[Compteur])+','+
                              Strg(Devant.Cent[Compteur]),7+Devant.Actif[Compteur] * 8);
   End;
   Ecrit(XD+44,YD+4+Compteur,Devant.Pos[Compteur],7+Devant.Actif[Compteur] * 8);
   Ecrit(XD+54,YD+4+Compteur,Devant.Code[Compteur],7+Devant.Actif[Compteur] * 8);
   AfficheBar(Compteur,7+Devant.Actif[Compteur] * 8);
  End;
  Repeat
   Ancien  := kbAncien;
   Touche  := AfficheBarTouche(Position,XPos,$F0,Devant.Actif[Position] * 8 + 7);
   Basse   := Lo(Touche);
   Case Basse of
    9 : Max(XPos,4);
48..57,65..90,97..112 : Begin
                         If(XPos in [1,3,4])Then kbAncien := Ancien;
                         Case XPos of
                          1 : Goto V0;
                          3 : Goto V3;
                          4 : Begin
                               If(Basse in [48..57])Then Goto V7
                                                    Else Touche := LitClavier;
                              End;
                         End;
                        End;
    0 : Begin
         ToucheTab(15,4,Touche,Position,XPos,Devant.Actif[Position]);
         If(Hi(Touche) = 82)Then
         Begin
          Case XPos of
           0 : Max(Devant.Actif[Position],1);
           1 : Begin
             V0:FixeDollar(XD+22,YD+4+Position,10,
                Devant.Prix[Position],Devant.Cent[Position],Basse);
                Ecrit(XD+22,YD+4+Position,Strg(Devant.Prix[Position])+','+
                                          Strg(Devant.Cent[Position]),15);
               End;
           2 : Begin
                Case Position of
                  9 : FixeRadiateur;
                 10 : FixeFanRadiateur;
                 14 : FixeFrameRail;
                End;
                If(Devant.Prix[Position] = 0)Then Dec(XPos) else
                If(Devant.Pos[Position] = '')Then Inc(XPos)
                                             Else Max(Position,15);
                Goto V8;
               End;
           3 : Begin
             V3:FixeLocalise(XD+44,YD+4+Position,7,Devant.Pos[Position],Basse);
               End;
           4 : Begin
             V7:FixeLocalise(XD+54,YD+4+Position,7,Devant.Code[Position],Basse);
               End;
          End;
          If(XPos > 0)and(Basse = 0)Then Devant.Actif[Position] := 1;
          AfficheBar(Position,7 + Devant.Actif[Position] * 8);
          Max(Position,15);
          V8:
         End;
        End;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then
  Begin
   RestituteEcran(Tableau);
   Devant.AvantComplet.DevantComplet := 0;
   Goto Debut;
  End
   else
  FreeMem(Tableau,4000);
 End
  else
 Begin
  Devant.AvantComplet.DevantComplet := 2;
  Ecrit(2,3,'Combien (Prix) ?',15);
20:FixeDollar(19,3,10,Devant.AvantComplet.Prix,
                     Devant.AvantComplet.Cent,Basse);
  If(Basse = 1)Then Goto 10
   else
  Begin
   Ecrit(2,4,'Localisation ?',15);
   FixeLocalise(17,4,10,Devant.AvantComplet.Localise,Basse);
30:If(Basse = 1)Then Goto 20
    else
   Begin
    Ecrit(2,5,'Code Hollander ?',15);
    FixeLocalise(19,5,7,Devant.AvantComplet.Code,Basse);
    If(Basse = 1)Then Goto 30;
   End;
  End;
 End;
End;

BEGIN
END.







































































































































(***********************************************************************)                 }
(*                                                                     *)
(*                          Inventaire Devant                          *)
(*                             1992/04/08                              *)
(*                                                                     *)
(* Compagnie   : SystŠme                                               *)
(* Concepteur  : Sylvain Maltais                                     *)
(* Programmeur : Sylvain Maltais                                       *)
(*                                                                     *)
(* Description : þ Cette proc‚dure fixe le donn‚ de l'utilisateur vers *)
(*                 m‚moire.                                            *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).   *)
(*                 en mode texte monochrome (07h).                     *)
(*               þ Turbo Pascal 6 ou post‚rieur.                       *)
(*                                                                     *)
(***********************************************************************)

Unit IDevant;

(***********************************************************************)
                              Interface
(***********************************************************************)

Uses Drivers,EcrMono,IChaine,IClavier,IVisuel;

Const Aucun             = 0;
      Droite            = 1;
      Gauche            = 2;
      Deux              = 3;
      Manuel            = 0;
      Automatique       = 1;
      Electrique        = 0;
      Thermo            = 1;

       { Constante devant }

      Bumper            = 0;
      Valence           = 1;
      Grille            = 2;
      HeaderPannel      = 3;
      HeadLampDor       = 4;
      HeadLamp          = 5;
      HeadLampMotor     = 6;
      ParkLamp          = 7;
      CondenseurAir     = 8;
      Radiateur         = 9;
      FanRadiateur      = 10;
      AileGauche        = 11;
      AileDroite        = 12;
      FrameRail         = 13;
      Frame             = 14;
      Capot             = 15;

Type DevantCompletType = Record
                          DevantComplet : Byte;
                          Prix          : Word;
                          Cent          : Byte;
                          Localise      : String[7];
                          Code          : String[7];
                         End;
     DevantType  = Record
                    AvantComplet : DevantCompletType;
                    Actif        : Array[0..15] of Byte;
                    Prix         : Array[0..15] of Word;
                    Cent         : Array[0..15] of Byte;
                    Pos          : Array[0..15] of String[7];
                    Code         : Array[0..15] of String[7];
                    Radiateur    : Manuel..Automatique;
                    FanRadiateur : Electrique..Thermo;
                    FrameRail    : Aucun..Deux;
                   End;

Procedure AffichePieceDevant(X,Y,Couleur:Byte);
Procedure FixeDevant(Var Devant:DevantType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure WriteLn(Chaine:String);
Begin
End;

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure Write(Chaine:String);
Begin
End;

(***********************************************************************)
(*                                                                     *)
(* Attention : Cette procedure ne doit jamais etre modifie sous risque *)
(*             de faire plainter le systeme!!                          *)
(*             Si vous desirer changer cette procedure, alors vous     *)
(*             devez mettre cette instruction avant chaque autre que   *)
(*             vous utilisez!!                                         *)
(*                                                                     *)
(*             Exemple :                                               *)
(*                                                                     *)
(*             Procedure X;                                            *)
(*             Begin                                                   *)
(*              Port[$20] := Port[$20] or 1;                           *)
(*              .                                                      *)
(*              .                                                      *)
(*             End;                                                    *)
(*                                                                     *)
(***********************************************************************)

Procedure GotoXY(X,Y:Byte);
Begin
End;

Procedure AffichePieceDevant(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
              'Bumper avant'+#1+
              'Valence'+#1+
              'Grille'+#1+
              'Header panel'+#1+
              'Headlamp dor'+#1+
              'Headlamp'+#1+
              'Headlamp motor'+#1+
              'Parklamp'+#1+
              'Condenseur d''air'+#1+
              'Radiateur'+#1+
              'Fan radiateur'+#1+
              'Aile gauche'+#1+
              'Aile droite'+#1+
              'Frame'+#1+
              'Frame rail'+#1+
              'Capot');
End;

Procedure FixeDevant(Var Devant:DevantType;Var Escape:Boolean);
Label Debut,10,V0,V1,V3,V7,V8,20,30;
Const Position : Byte = 0;
      XPos     : Byte = 0;
      XD       = 2;
      YD       = 2;
      TabBar   : Array[0..14] of Byte = (XD+2,YD+4,XD+19,XD+22,YD+4,XD+31,
                                         XD+33,YD+4,XD+42,XD+44,YD+4,XD+52,
                                         XD+54,YD+4,XD+67);
      SerieVer : Array[0..11] of Byte = (XD+21,YD+1,YD+20,XD+32,YD+1,YD+20,
                                         XD+43,YD+1,YD+20,XD+53,YD+1,YD+20);
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Tableau  : Pointer;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;

 Procedure FixeFrameRail;
 Const X     = 33 + XD;
       Y     = 10 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+13);
 Var Pos      : ShortInt;
     Chaine   : String[7];
 Begin
  Pos := MiniMenu(X,Y,X+15,Y+7,Serie,'Frame Rail :','Aucun'#1'Droite'#1'Gauche'#1'Deux');
  If(Pos <> -1)Then
  Begin
   Devant.FrameRail := Pos;
   Case Pos of
    Aucun  : Chaine := 'Aucun';
    Droite : Chaine := 'Droite';
    Gauche : Chaine := 'Gauche';
    Deux   : Chaine := 'Deux';
   End;
   Ecrit(XD+33,YD+18,Chaine,15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,7 + Devant.Actif[Position] * 8);
  End;
  Basse := 0;
 End;

 Procedure FixeRadiateur;
 Const X = 33 + XD;
       Y = 14 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+14);
 Var Pos : ShortInt;
 Begin
  Pos := MiniMenu(X,Y,X+16,Y+5,Serie,'Radiateur :','Manuel'#1'Automatique');
  If(Pos <> -1)Then
  Begin
   Devant.Radiateur := Pos;
   If(Pos = 0)Then Ecrit(XD+33,YD+13,'Manuel',15)
              Else Ecrit(XD+33,YD+13,'Automatic',15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,7 + Devant.Actif[Position] * 8);
  End;
  Basse := 0;
 End;

 Procedure FixeFanRadiateur;
 Const X = 33 + XD;
       Y = 15 + YD;
       Serie : Array[0..2] of Byte = (X+2,Y+3,X+16);
 Var Pos : ShortInt;
 Begin
  Pos := MiniMenu(X,Y,X+18,Y+5,Serie,'Fan Radiateur :','Electrique'#1'Thermo');
  If(Pos <> -1)Then
  Begin
   Devant.FanRadiateur := Pos;
   If(Pos = 0)Then Ecrit(XD+33,YD+14,'Electrique',15)
              Else Ecrit(XD+33,YD+14,'Thermo',15);
   Devant.Actif[Position] := 1;
   AfficheBar(Position,Devant.Actif[Position] * 8 + 7);
  End;
  Basse := 0;
 End;

Begin
 If(Devant.AvantComplet.DevantComplet > 2)Then
 Begin
  FillChar(Devant,SizeOf(Devant),0);
 End;
Debut:FixeFormatBar(5,TabBar);
 Escape := False;
  { Initialise Ecran }
 FixeCurseurFermer;
 FixeClignotement(0);
 FixeFormatDouble;
 FixeCadrePlain(0,1,39,8,15);
  { Fixe les paramŠtres }
 Ecrit_OuiNon(2,2,'Devant Complet (O/N) ?');
 If(Devant.AvantComplet.DevantComplet > 0)Then
 Begin
  Basse := Devant.AvantComplet.DevantComplet - 1;
  FixeUnCaractere(25,2,78+Basse);
 End
  else
10:Basse := RepOuiNon(25,2);
 If(Basse = 2)Then
 Begin
  Escape := True;
  Exit;
 End
  else
 If(Basse = 0)Then { Non, D‚sassembl‚ }
 Begin
  SauvegardeEcran(Tableau);
  For Compteur := 0 to 15 do
  Begin
   If((Devant.Actif[Compteur] > 1)or
      (Length(Devant.Code[Compteur]) > 7)or
      (Length(Devant.Pos[Compteur]) > 7)or
      (Devant.Cent[Compteur] > 100))Then { Erreur donnee ? }
   Begin
    Devant.Actif[Compteur] := 0;
    Devant.Prix[Compteur]  := 0;
    Devant.Cent[Compteur]  := 0;
    FillChar(Devant.Pos[Compteur],SizeOf(Devant.Pos[Compteur]),0);
    FillChar(Devant.Code[Compteur],SizeOf(Devant.Code[Compteur]),0);
    Devant.Radiateur       := 0;
    Devant.FanRadiateur    := 0;
    Devant.FrameRail       := 0;
   End;
  End;
  Devant.AvantComplet.DevantComplet := 1;
   { Initialise Ecran }
  BaseVisuel(XD,YD+1,XD+68,YD+20,4,SerieVer,XD+22,XD+44,XD+54);
  Ecrit(XD+33,YD+2,'Descrip.',14);
  AffichePieceDevant(XD+2,YD+4,7);
  For Compteur := 0 to 15 do
  Begin
   If(Devant.Prix[Compteur] > 0)or
     (Devant.Cent[Compteur] > 0)Then
   Begin
    Ecrit(XD+22,YD+4+Compteur,Strg(Devant.Prix[Compteur])+','+
                              Strg(Devant.Cent[Compteur]),7+Devant.Actif[Compteur] * 8);
   End;
   Ecrit(XD+44,YD+4+Compteur,Devant.Pos[Compteur],7+Devant.Actif[Compteur] * 8);
   Ecrit(XD+54,YD+4+Compteur,Devant.Code[Compteur],7+Devant.Actif[Compteur] * 8);
   Ecrit(XD+54,YD+4+Compteur,Devant.Code[Compteur],7+Devant.Actif[Compteur] * 8);
   AfficheBar(Compteur,7+Devant.Actif[Compteur] * 8);
  End;
  Repeat
   Ancien  := kbAncien;
   Touche  := AfficheBarTouche(Position,XPos,$F0,Devant.Actif[Position] * 8 + 7);
   Basse   := Lo(Touche);
   Case Basse of
    9 : Max(XPos,4);
48..57,65..90,97..112 : Begin
                         If(XPos in [1,3,4])Then kbAncien := Ancien;
                         Case XPos of
                          1 : Goto V0;
                          3 : Goto V3;
                          4 : Begin
                               If(Basse in [48..57])Then Goto V7
                                                    Else Touche := LitClavier;
                              End;
                         End;
                        End;
    0 : Begin
         ToucheTab(15,4,Touche,Position,XPos,Devant.Actif[Position]);
         If(Hi(Touche) = 82)Then
         Begin
          Case XPos of
           0 : Max(Devant.Actif[Position],1);
           1 : Begin
             V0:FixeDollar(XD+22,YD+4+Position,10,
                Devant.Prix[Position],Devant.Cent[Position],Basse);
                Ecrit(XD+22,YD+4+Position,Strg(Devant.Prix[Position])+','+
                                          Strg(Devant.Cent[Position]),15);
               End;
           2 : Begin
                Case Position of
                  9 : FixeRadiateur;
                 10 : FixeFanRadiateur;
                 14 : FixeFrameRail;
                End;
                If(Devant.Prix[Position] = 0)Then Dec(XPos) else
                If(Devant.Pos[Position] = '')Then Inc(XPos)
                                             Else Max(Position,15);
                Goto V8;
               End;
           3 : Begin
             V3:FixeLocalise(XD+44,YD+4+Position,7,Devant.Pos[Position],Basse);
               End;
           4 : Begin
             V7:FixeLocalise(XD+54,YD+4+Position,7,Devant.Code[Position],Basse);
               End;
          End;
          If(XPos > 0)and(Basse = 0)Then Devant.Actif[Position] := 1;
          AfficheBar(Position,7 + Devant.Actif[Position] * 8);
          Max(Position,15);
          V8:
         End;
        End;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then
  Begin
   RestituteEcran(Tableau);
   Devant.AvantComplet.DevantComplet := 0;
   Goto Debut;
  End
   else
  FreeMem(Tableau,4000);
 End
  else
 Begin { Oui, Complet }
  Devant.AvantComplet.DevantComplet := 2;
  Ecrit(2,3,'Combien (Prix) ?',15);
20:FixeDollar(19,3,10,Devant.AvantComplet.Prix,
                     Devant.AvantComplet.Cent,Basse);
  If(Basse = 1)Then Goto 10
   else
  Begin
   Ecrit(2,4,'Localisation ?',15);
   FixeLocalise(17,4,10,Devant.AvantComplet.Localise,Basse);
30:If(Basse = 1)Then Goto 20
    else
   Begin
    Ecrit(2,5,'Code Hollander ?',15);
    FixeLocalise(19,5,7,Devant.AvantComplet.Code,Basse);
    If(Basse = 1)Then Goto 30;
   End;
  End;
 End;
End;

BEGIN
END.
