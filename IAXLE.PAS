(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Axle                            *)
(*                             1992/04/09                              *)
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

Unit IAxle;

{$V-}

(***********************************************************************)
                                Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Const
      MinAxle = 0;
      MaxAxle = 4;

      SauteLigne = #1;
      Couleur    = #3;
      Color      = Couleur;

Type
     LocaliseType      = String[7];
     CodeType          = String[7];
     CodeHollanderType = CodeType;
     AxleType          = Record
                          Actif       : Array[MinAxle..MaxAxle] of Byte;
                          Prix        : Array[MinAxle..MaxAxle] of Word;
                          Cent        : Array[MinAxle..MaxAxle] of Byte;
                          Loc         : Array[MinAxle..MaxAxle] of LocaliseType;
                          Code        : Array[MinAxle..MaxAxle] of CodeType;
                          Cardan      : Byte;
                          Essieu      : Byte;
                          Integral    : Byte;
                          DriveShaft  : Byte;
                         End;

Procedure AffichePieceAxle(X,Y,Couleur:Byte);
Procedure FixeAxle(Var Axle:AxleType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

Procedure AffichePieceAxle(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,Color + Chr(Couleur)+
              'Cadran' + SauteLigne +
              'Essieu' + SauteLigne +
              'Dif‚rentiel' + SauteLigne +
              'Cochon de dif‚rentiel' + SauteLigne +
              'Drive shaft');
End;

(***********************************************************************)

Procedure FixeAxle(Var Axle:AxleType;Var Escape:Boolean);
Const Serie : Array[0..11] of Byte = (24,1,9,
                                      35,1,9,
                                      51,1,9,
                                      62,1,9);
      Tabar : Array[0..14] of Byte = (1,4,23,
                                      25,4,34,
                                      36,4,50,
                                      52,4,61,
                                      63,4,78);
      Position : Byte = 0;
      XPos     : Byte = 0;
Var Basse    : Byte;
    Touche   : Word;
    Ancien   : Word;
    Tmp      : Byte;
    kbAncien : Word Absolute $0040:$1A;
Begin
 Escape := False;
 BaseVisuel(0,1,79,9,4,Serie,26,53,64);
 Ecrit(37,2,'Description',14);
 AffichePieceAxle(2,4,7);
 FixeFormatBar(5,Tabar);
 Repeat
  Ancien := kbAncien;
  Touche := AfficheBarTouche(Position,XPos,$F0,Axle.Actif[Position]*8+7);
  Basse  := Lo(Touche);
  Case Basse of
   0 : Begin
        ToucheTab(MaxAxle,4,Touche,Position,XPos,Axle.Actif[Position]);
        If(Hi(Touche) = 82)Then
        Begin
         Tmp := 4 + Position;
         Case XPos of
          0 : Max(Axle.Actif[Position],1);
          1 : FixeDollar(26,Tmp,7,Axle.Prix[Position],Axle.Cent[Position],Basse);
          3 : FixeLocalise(53,Tmp,7,Axle.Loc[Position],Basse);
          4 : FixeLocalise(64,Tmp,7,Axle.Code[Position],Basse);
         End;
         AfficheBar(Position,Axle.Actif[Position]*8+7);
         Max(Position,MaxAxle);
        End;
       End;
  End;
 Until (Touche = kbEnter)or(Touche = kbESC);
 If(Touche = kbESC)Then Escape := True;
End;

(***********************************************************************)

BEGIN { Main Unit }
END.
