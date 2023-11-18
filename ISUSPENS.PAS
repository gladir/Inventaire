(***********************************************************************)
(*                                                                     *)
(*                        Inventaire Suspension                        *)
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
(*                                                                     *)
(***********************************************************************)

Unit ISuspens;

{$V-}

(***********************************************************************)
                               Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Const
      MaxSuspension    = 13;
      MinSuspension    = 0;
      MaxSuspens       = MaxSuspension;
      MinSuspens       = MinSuspension;

      SauteLigne       = #1;
      Couleur          = #3;
      Color            = Couleur;

Type
     CodeType          = String[7];
     LocaliseType      = String[7];
     CodeHollanderType = CodeType;
     SuspensionType    = Record
                          Actif             : Array[MinSuspension..
                                                    MaxSuspension] of Byte;
                          Prix              : Array[MinSuspension..
                                                    MaxSuspension] of Word;
                          Cent              : Array[MinSuspension..
                                                    MaxSuspension] of Byte;
                          Loc               : Array[MinSuspension..
                                                    MaxSuspension] of
                                                       LocaliseType;
                          Code              : Array[MinSuspension..
                                                    MaxSuspension] of
                                                       CodeType;
                          Spindel           : Byte;
                          Tab               : Byte;
                          Strut             : Byte;
                          Ibeam             : Byte;
                          BarTortion        : Byte;
                          BarStabilisatrice : Byte;
                          AxleBeam          : Byte;
                          RearStub          : Byte;
                          Spring            : Byte;
                          Lames             : Byte;
                          Box               : Byte;
                          Cremail           : Byte;
                          Couleur           : String[10];
                          Cruise            : Byte;
                         End;

Procedure AffichePieceSuspension(X,Y,Couleur:Byte);
Procedure FixeSuspension(Suspension:SuspensionType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

Procedure AffichePieceSuspension(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,Color + Chr(Couleur) +
               'Spindel' + SauteLigne +                { 0  }
               'Tab' + SauteLigne +                    { 1  }
               'Strut' + SauteLigne +                  { 2  }
               'IBeam' + SauteLigne +                  { 3  }
               'Bar Tortion' + SauteLigne +            { 4  }
               'Bar Stabilitation' + SauteLigne +      { 5  }
               'Axle beam' + SauteLigne +              { 6  }
               'Rear stub' + SauteLigne +              { 7  }
               'Spring' + SauteLigne +                 { 8  }
               'Lames' + SauteLigne +                  { 9  }
               'Box Stering' + SauteLigne +            { 10 }
               'Pompe … power stering' + SauteLigne +  { 12 }
               'Colone stering');                      { 13 }
End;

(***********************************************************************)
(*  Description : Cette proc‚dure fixe le donn‚ de l'utilisateur vers  *)
(*                la m‚moire.                                          *)
(***********************************************************************)

Procedure FixeSuspension(Suspension:SuspensionType;Var Escape:Boolean);
Label V3,V4,V5,V6;
Const X = 0;
      Y = 2;
      Tabbar : Array[0..17] of Byte = (X+1,Y+3,X+23,
                                       X+25,Y+3,X+34,
                                       X+36,Y+3,X+53,
                                       X+55,Y+3,X+64,
                                       X+66,Y+3,X+75,
                                       X+37,Y+3,X+52);
      Serie  : Array[0..14] of Byte = (X+24,Y,Y+17,
                                       X+35,Y,Y+17,
                                       X+54,Y,Y+17,
                                       X+65,Y,Y+17,
                                       X+76,Y,Y+17);
      Position : Byte = 0;
      XPos     : Byte = 0;
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Tableau  : Pointer;
    kbAncien : Word Absolute $0040:$1A;
    Compteur : Byte;

 Procedure Extension;
 Var Compteur : Byte;
 Begin
  With Suspension do
  Begin
   If(XPos = 5)Then
   Begin
    DeplacementFenetre(Tableau);
    DemiCadre(40,Y,53,Y+17,15);
    BarTexteHori(40,Y+2,53,196,15);
    FixeUnCube(53,Y+2,182,15);
    Ecrit(40,Y+1,'de hollander',14);
    For Compteur := 0 to MaxSuspension do
    Begin
     Ecrit(37,Y+3+Compteur,Code[Compteur],Actif[Compteur]*8+7);
    End;
   End;
  End;
 End;

 Procedure RestoreExtension;
 Var Compteur : Byte;
 Begin
  With Suspension do
  Begin
   If(XPos = 5)Then RestituteEcran(Tableau);
   For Compteur := 0 to 13 do
   Begin
    Ecrit(77,Y+3+Compteur,Copy(Code[Compteur],1,3),Actif[Compteur]*8+7);
   End;
  End;
 End;

Begin
  { Initialise Data }
 FixeFormatBar(6,TabBar);
 Escape := False;
 For Compteur := 0 to MaxSuspension do
 Begin
  If(Suspension.Actif[Compteur] > 2)or
    (Suspension.Cent[Compteur]  > 100)or
    (Length(Suspension.Code[Compteur]) > 7)or
    (Length(Suspension.Loc[Compteur]) > 7)Then
  Begin
   Suspension.Prix[Compteur] := 0;
   Suspension.Cent[Compteur] := 0;
   FillChar(Suspension.Code[Compteur],SizeOf(Suspension.Code[Compteur]),0);
   FillChar(Suspension.Loc[Compteur],SizeOf(Suspension.Loc[Compteur]),0);
  End;
 End;
  { Initialise Ecran }
 FixeClignotement(0);
 FixeCurseurFermer;
 FixeFormatDouble;
 With Suspension do
 Begin
   { Initialise Ecran }
  BaseVisuel(0,Y,79,Y+17,5,Serie,25,67,-1);
  Ecrit(37,Y+1,'Description',14);
  Ecrit(56,Y+1,'Couleur',14);
  Ecrit(78,Y+1,'Co',14);
  AffichePieceSuspension(2,Y+3,7);
  BarDeplacement;
  For Compteur := 0 to MaxSuspension do
  Begin
   If(Prix[Compteur] > 0)or
     (Cent[Compteur] > 0)Then
   Begin
    Ecrit(26,Y+2+Compteur,Strg(Prix[Compteur])+','+
                              Strg(Cent[Compteur]),7+Actif[Compteur] * 8);
   End
    else
   If(Prix[Compteur] > 0)Then
   Begin
    Ecrit(26,Y+2+Compteur,Strg(Prix[Compteur])+'$',7+Actif[Compteur] * 8);
   End;
   Ecrit(66,Y+2+Compteur,Loc[Compteur],7+Actif[Compteur] * 8);
   AfficheBar(Compteur,7+Actif[Compteur] * 8);
  End;
  Repeat
   Ancien := kbAncien;
   Touche := AfficheBarTouche(Position,XPos,$F0,Actif[Position] * 8 + 7);
   Basse  := Lo(Touche);
   Case Basse of
    0 : Begin
         TraiteScanCode(Position,MaxSuspension,Touche);
         Case Hi(Touche) of
          75 : Begin
                RestoreExtension;
                Min(XPos,5);
                Extension;
               End;
          77 : Begin
                RestoreExtension;
                Max(XPos,5);
                Extension;
               End;
          82 : Case XPos of
                0 : Begin
                     Max(Actif[Position],1);
                     AfficheBar(Position,Y+2+Actif[Position]*8);
                     Max(Position,MaxSuspension);
                    End;
                1 : Begin
                  V3:FixeDollar(26,Y+2+Position,8,Prix[Position],
                                                Cent[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxSuspension);
                    End;
                2 : Begin
                     Max(Position,MaxSuspension);
                    End;
                3 : Begin
                     FixeLocalise(55,Y+16,10,Couleur,Basse);
                     If(Basse = 0)Then Max(Position,MaxSuspension);
                    End;
                4 : Begin
                  V4:FixeLocalise(66,Y+2+Position,7,Loc[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxSuspension);
                    End;
                5 : Begin
                  V5:FixeLocalise(38,Y+2+Position,7,Code[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxSuspension);
                    End;
               End;
          83 : Begin
                AfficheBar(Position,7);
                Actif[Position] := 0;
                Max(Position,MaxSuspension);
               End;
         End;
        End;
    48..57 : If(XPos=1)Then
             Begin
              kbAncien := Ancien;
              Goto V3;
             End
              else
          V6:If(XPos=3)Then
             Begin
              kbAncien := Ancien;
              Goto V4;
             End
              else
             If(XPos=4)Then
             Begin
              kbAncien := Ancien;
              Goto V5;
             End;
    65..90,97..122 : If(XPos in [3,4])Then Goto V6;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then Escape := True;
  RestoreExtension;
 End;
End;

END.
