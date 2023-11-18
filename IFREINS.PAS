(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Freins                          *)
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

Unit IFreins;

{$V-}

(***********************************************************************)
                               Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Type FreinType = Record
                  Actif   : Array[0..5] of Byte;
                  Prix    : Array[0..5] of Word;
                  Cent    : Array[0..5] of Byte;
                  Loc     : Array[0..5] of String[7];
                  Code    : Array[0..5] of String[7];
                  Rotor   : Byte;
                  Galiper : Byte;
                  RearDrm : Byte;
                  MasCyl  : Byte;
                 End;

Procedure AffichePieceFreins(X,Y,Couleur:Byte);
Procedure FixeFreins(Var Freins:FreinType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

Procedure AffichePieceFreins(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
                  'Rotor'+#1+
                  'Galiper'+#1+
                  'Rear drum'+#1+
                  'Master cylindre'+#1+
                  'Booster'+#1+
                  'Antiskid');
End;

Procedure FixeFreins(Var Freins:FreinType;Var Escape:Boolean);
Const Serie : Array[0..11] of Byte = (18,1,10,29,1,10,45,1,10,56,1,10);
      Tabar : Array[0..14] of Byte = (1,4,17,19,4,28,30,4,44,46,4,55,57,4,73);
      Position : Byte = 0;
      XPos     : Byte = 0;
Var Basse    : Byte;
    Touche   : Word;
    Ancien   : Word;
    Tmp      : Byte;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;
Begin
  { Initialise data }
 Escape := False;
 For Compteur := 0 to 5 do
 Begin
  If(Freins.Actif[Compteur] > 1)or
    (Freins.Cent[Compteur] > 100)or
    (Length(Freins.Code[Compteur]) > 7)or
    (Length(Freins.Loc[Compteur]) > 7)Then
  Begin
   Freins.Actif[Compteur] := 0;
   Freins.Prix[Compteur]  := 0;
   Freins.Cent[Compteur]  := 0;
   FillChar(Freins.Code[Compteur],SizeOf(Freins.Code[Compteur]),0);
   FillChar(Freins.Loc[Compteur],SizeOf(Freins.Loc[Compteur]),0);
  End;
 End;
  { Initialise ecran }
 BaseVisuel(0,1,74,10,4,Serie,20,47,58);
 Ecrit(31,2,'Description',14);
 AffichePieceFreins(2,4,7);
 FixeFormatBar(5,Tabar);
 For Compteur := 0 to 5 do
 Begin
  If(Freins.Prix[Compteur] > 0)and(Freins.Cent[Compteur] > 0)Then
  Begin
   Ecrit(20,4+Compteur,Strg(Freins.Prix[Compteur])+','+
                       Strg(Freins.Cent[Compteur])+'$',
                       7+Freins.Actif[Compteur]*8);
  End
   else
  If(Freins.Prix[Compteur] > 0)Then
  Begin
   Ecrit(20,4+Compteur,Strg(Freins.Prix[Compteur])+'$',
                       7+Freins.Actif[Compteur]*8);
  End;
  AfficheBar(Compteur,Freins.Actif[Compteur]*8+7);
 End;
 Repeat
  Ancien := kbAncien;
  Touche := AfficheBarTouche(Position,XPos,$F0,Freins.Actif[Position]*8+7);
  ToucheTab(5,4,Touche,Position,XPos,Freins.Actif[Position]);
  Case Touche of
kbIns : Begin
         Tmp := 4 + Position;
         Case XPos of
          0 : Max(Freins.Actif[Position],1);
          1 : FixeDollar(20,Tmp,7,Freins.Prix[Position],Freins.Cent[Position],Basse);
          3 : FixeLocalise(47,Tmp,7,Freins.Loc[Position],Basse);
          4 : FixeLocalise(58,Tmp,7,Freins.Code[Position],Basse);
         End;
         AfficheBar(Position,Freins.Actif[Position]*8+7);
         Max(Position,5);
        End;
  End;
 Until (Touche = kbESC)or(Touche = kbEnter);
 If(Touche = kbESC)Then Escape := True;
End;

END.
