(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Cowl                            *)
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

Unit ICOWL;

{$V-}

(***********************************************************************)
                               Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Const WindShield            = 0;
      Dash                  = 1;
      SpedoMetre            = 2;
      Radio                 = 3;
      ComboSwich            = 4;
      IgnitionSwich         = 5;
      RadiateurChaufferette = 6;
      MoteurChaufferette    = 7;
      RadiateurWhiper       = 8;
      MoteurWhiper          = 9;
      WiperTransmission     = 10;

Type CowlType = Record
                 DataActif : Array[0..10] of Byte;
                 DataPrix  : Array[0..10] of Word;
                 DataCent  : Array[0..10] of Byte;
                 DataPos   : Array[0..10] of String[7];
                 DataCode  : Array[0..10] of String[7];
                End;

Procedure AffichePieceCowl(X,Y,Couleur:Byte);
Procedure FixeCowl(Var Cowl:CowlType;Var Escape:Boolean);

(***********************************************************************)
                           Implementation
(***********************************************************************)

Procedure AffichePieceCowl(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
              'Windshield'+#1+
              'Dash'+#1+
              'SpedomŠtre'+#1+
              'Radio'+#1+
              'Combo swich'+#1+
              'Ignition swich'+#1+
              'Radiateur chaufferette'+#1+
              'Moteur chaufferette'+#1+
              'Radiateur whiper'+#1+
              'Moteur whiper'+#1+
              'Whiper transmission');
End;

(***********************************************************************)

Procedure FixeCowl(Var Cowl:CowlType;Var Escape:Boolean);
Label V0,V1,V2,V3;
Const TabBar   : Array[0..11] of Byte = (1,4,24,26,4,36,38,4,46,48,4,62);
      TabSerie : Array[0..8] of Byte = (25,1,15,37,1,15,47,1,15);
      Position : Byte = 0;
      XPos     : Byte = 0;
Var Basse    : Byte;
    Touche   : Word;
    Ancien   : Word;
    Erreur   : Word;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;
Begin
  { Initialise le data : }
 FixeFormatBar(4,TabBar);
 For Compteur := 0 to 10 do
 Begin
  If(Cowl.DataActif[Compteur] > 1)or
    (Cowl.DataCent[Compteur] > 100)or
    (Length(Cowl.DataPos[Compteur]) > 7)or
    (Length(Cowl.DataCode[Compteur]) > 7)Then
  Begin
   Cowl.DataActif[Compteur] := 0;
   Cowl.DataPrix[Compteur]  := 0;
   Cowl.DataCent[Compteur]  := 0;
   FillChar(Cowl.DataPos[Compteur],SizeOf(Cowl.DataPos[Compteur]),0);
   FillChar(Cowl.DataCode[Compteur],SizeOf(Cowl.DataCode[Compteur]),0);
  End;
 End;
 Escape := False;
 With Cowl do
 Begin
    { Initialise Ecran : }
  BaseVisuel(0,1,63,15,3,TabSerie,27,39,48);
  AffichePieceCowl(2,4,7);
   { Affiche les donnees }
  For Compteur := 0 to 10 do
  Begin
   IF(DataPrix[Compteur] > 0)and(DataCent[Compteur] > 0)Then
   Begin
    Ecrit(27,4+Compteur,Strg(DataPrix[Compteur])+','+
          Strg(DataCent[Compteur]),7 + DataActif[Compteur] * 8);
   End
    else
   If(DataPrix[Compteur] > 0)Then
   Begin
    Ecrit(27,4+Compteur,Strg(DataPrix[Compteur]),7 + DataActif[Compteur] * 8);
   End;
   Ecrit(39,4+Compteur,DataPos[Compteur],7 + DataActif[Compteur] * 8);
   Ecrit(48,4+Compteur,DataCode[Compteur],7 + DataActif[Compteur] * 8);
   AfficheBar(Compteur,7 + DataActif[Compteur] * 8);
  End;
  Repeat
   FixeUneBar(Position,XPos,$F0);
   Ancien  := kbAncien;
   Touche  := LitClavier;
   Basse   := Touche and $FF;
   FixeUneBar(Position,XPos,DataActif[Position] * 8 + 7);
   Case Basse of
    0 : Begin
         Case Hi(Touche) of
          71 : Position := 0;
          72 : Min(Position,10);
          75 : Min(XPos,3);
          77 : Max(XPos,3);
          79 : Position := 10;
          80 : Max(Position,10);
          82 : Begin
                Case XPos of
                 0 : Max(DataActif[Position],1);
                 1 : Begin
                   V0:FixeDollar(27,4+Position,10,DataPrix[Position],DataCent[Position],Basse);
                      If(Basse = 0)Then DataActif[Position] := 1;
                     End;
                 2 : Begin
                   V1:FixeLocalise(39,4+Position,7,DataPos[Position],Basse);
                      If(Basse = 0)Then DataActif[Position] := 1;
                     End;
                 3 : Begin
                   V2:FixeLocalise(48,4+Position,7,DataCode[Position],Basse);
                      If(Basse = 0)Then DataActif[Position] := 1;
                     End;
                End;
                AfficheBar(Position,DataActif[Position]*8+7);
                Max(Position,10);
               End;
          83 : Begin
                DataActif[Position] := 0;
                AfficheBar(Position,7);
                Min(Position,10);
               End;
         End;
        End;
    9 : Max(XPos,3);
    48..57 : If(XPos = 1)Then
             Begin
              MemW[$0040:$1A] := Ancien;
              Goto V0;
             End
              else
          V3:If(XPos = 2)Then
             Begin
              MemW[$0040:$1A] := Ancien;
              Goto V1;
             End
              else
             If(XPos = 3)Then
             Begin
              MemW[$0040:$1A] := Ancien;
              Goto V2;
             End;
    65..90,97..122 : Goto V3;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then Escape := True;
 End;
End;

END.
