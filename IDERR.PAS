(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Derriere                        *)
(*                             1992/05/14                              *)
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

Unit IDerr;

{$V-}

(***********************************************************************)
                              Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,ICLavier,IChaine;

Const ChoixToit        : Array[0..3] of String[11] = ('Plain      ',
                                                      'TTop       ',
                                                      'SunRoof    ',
                                                      'Convertible');
      ChoixHaillon     : Array[0..3] of String[16] = ('Aucun           ',
                                                      'Vitre chauffante',
                                                      'Whiper          ',
                                                      'Deux            ');

      Non              = 0;
      Oui              = 1;
      MaxDerriere      = 11;

       { Constante derriere }

      Toit             = 0;
      QuarterPannel    = 1;
      QuarterGlass     = 2;
      BackGlass        = 3;
      Valise           = 4;
      Haillon          = 5;
      TankGaz          = 6;
      RearFinishPannel = 7;
      Tailgate         = 8;
      Taillite         = 9;
      BumperArriere    = 10;
      BoiteCamion      = 11;

Type LogiqueType          = Byte;
     LocaliseType         = String[7];
     CodeHollanderType    = String[7];
     BoiteCamionType      = String[20];
     DerriereCompleteType = Record
                             DerriereComplete : LogiqueType;
                             Prix             : Word;
                             Cent             : Byte;
                             Localise         : LocaliseType;
                             Code             : CodeHollanderType;
                            End;
     DerriereType     = Record
                         DataDerriereComplete : DerriereCompleteType;
                         DataActif            : Array[0..MaxDerriere] of Byte;
                         DataPrix             : Array[0..MaxDerriere] of Word;
                         DataCent             : Array[0..MaxDerriere] of Byte;
                         DataPos              : Array[0..MaxDerriere] of LocaliseType;
                         DataCode             : Array[0..MaxDerriere] of CodeHollanderType;
                         TypeHaillon          : Byte;
                         TypeToit             : Byte;
                         Aileron              : Byte;
                         Description          : BoiteCamionType;
                        End;

Procedure AffichePieceDerriere(X,Y,Couleur:Byte);
Procedure FixeDerriere(Derriere:DerriereType;Var Escape:Boolean);

(***********************************************************************)
                             Implementation
(***********************************************************************)

Procedure AffichePieceDerriere(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,#3+Chr(Couleur)+
              'Toit'+#1+
              'Quarter pannel'+#1+
              'Quarter glass'+#1+
              'Back glass'+#1+
              'Valise'+#1+
              'Haillon'+#1+
              'Tank … gaz'+#1+
              'Rear finish pannel'+#1+
              'Tailgate'+#1+
              'TailLite'+#1+
              'Bumper arriŠre'+#1+
              'Boite camion');
End;

(***********************************************************************)
(*                                                                     *)
(*  Description : Cette proc‚dure fixe le donn‚ de l'utilisateur vers  *)
(*                la m‚moire.                                          *)
(*                                                                     *)
(***********************************************************************)

Procedure FixeDerriere(Derriere:DerriereType;Var Escape:Boolean);
Label Debut,V3,V4,V5,V6;
Const Tabbar : Array[0..14] of Byte = (3,7,22,24,7,34,36,7,59,61,7,70,32,7,47);
      Serie  : Array[0..11] of Byte = (23,4,19,35,4,19,60,4,19,71,4,19);
      Position : Byte = 0;
      XPos     : Byte = 0;
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Compteur : Byte;
    Tableau  : Pointer;
    kbAncien : Word Absolute $0040:$1A;

 Procedure FixeToit;
 Const X = 36;
       Y = 8;
       TTabBar : Array[0..2] of Byte = (X+2,Y+3,X+14);
 Var TPos    : ShortInt;
     Chaine  : String[15];
 Begin
  TPos := MiniMenu(X,Y,X+15,Y+7,TTabBar,'Toit :','Plain'+#1+'TTop'+#1+'SunRoof'+#1+'Convertible');
  If(TPos <> -1)Then
  Begin
   Derriere.TypeToit := TPos;
   BarTexteHori(36,7,59,32,15);
   Ecrit(36,7,ChoixToit[TPos],15);
  End;
  Basse := 0;
  FixeFormatBar(5,TabBar);
 End;

 Procedure FixeAileron;
 Var Chaine : String[10];
 Begin
  Max(Derriere.Aileron,1);
  Case Derriere.Aileron of
   0 : Chaine := '       ';
   1 : Chaine := 'Aileron';
  End;
  Ecrit(36,11,Chaine,14);
 End;

 Procedure FixeHaillon;
 Const X = 36;
       Y = 13;
       HTabBar : Array[0..2] of Byte = (X+2,Y+3,X+19);
 Var TPos   : ShortInt;
     Chaine : String[15];
 Begin
  TPos := MiniMenu(X,Y,X+20,Y+7,HTabBar,'Haillon :','Aucun'#1'Vitre chauffante'#1'Whiper'#1'Deux');
  If(TPos <> -1)Then
  Begin
   Derriere.TypeHaillon := TPos;
   BarTexteHori(36,12,59,32,15);
   Ecrit(36,12,ChoixHaillon[TPos],15);
  End;
  Basse := 0;
  FixeFormatBar(5,TabBar);
 End;

 Procedure FixeBoiteCamion;
 Var Basse : Byte;
 Begin
  FixeLocalise(36,6+MaxDerriere,25,Derriere.Description,Basse);
 End;

 Procedure Extension;
 Var Compteur : Byte;
 Begin
  With Derriere do
  Begin
   If(XPos = 4)Then
   Begin
    DeplacementFenetre(Tableau);
    DemiCadre(40,4,48,19,15);
    BarTexteHori(40,6,48,196,15);
    FixeUnCube(48,6,182,15);
    Ecrit(40,5,'llander',14);
    For Compteur := 0 to 11 do
    Begin
     Ecrit(33,6+Compteur,DataCode[Compteur],DataActif[Compteur]*8+7);
    End;
   End;
  End;
 End;

 Procedure RestoreExtension;
 Var Compteur : Byte;
 Begin
  With Derriere do
  Begin
   If(XPos = 4)Then RestituteEcran(Tableau);
   For Compteur := 0 to MaxDerriere do
   Begin
    Ecrit(73,6+Compteur,Copy(DataCode[Compteur],1,6),DataActif[Compteur]*8+7);
   End;
  End;
 End;

Begin
  { Initialise Data }
 Tableau := Nil;
 If(Derriere.DataDerriereComplete.DerriereComplete > 2)or
   (Derriere.DataDerriereComplete.Cent > 100)or
   (Length(Derriere.DataDerriereComplete.Localise) > 7)or
   (Length(Derriere.DataDerriereComplete.Code) > 7)Then
 Begin
  Derriere.DataDerriereComplete.DerriereComplete := 0;
  Derriere.DataDerriereComplete.Prix             := 0;
  Derriere.DataDerriereComplete.Cent             := 0;
  FillChar(Derriere.DataDerriereComplete.Localise,
           SizeOf(Derriere.DataDerriereComplete.Localise),0);
  FillChar(Derriere.DataDerriereComplete.Code,
           SizeOf(Derriere.DataDerriereComplete.Code),0);
 End;
Debut:FixeFormatBar(5,TabBar);
 Escape := False;
  { Initialise Ecran }
 FixeClignotement(0);
 FixeCurseurFermer;
 FixeFormatDouble;
 FixeCadrePlain(0,1,35,7,15);
 Ecrit_OuiNon(2,3,'DerriŠre complet (O/N) ?');
 Basse := RepOuiNon(27,3);
 If(Basse = 2)Then Escape := True else
 If(Basse = 0)Then { Non }
 Begin
   { Initialise donnee }
  For Compteur := 0 to MaxDerriere do
  Begin
   If(Derriere.DataActif[Compteur] > 1)or
     (Derriere.DataCent[Compteur] > 100)or
     (Length(Derriere.DataPos[Compteur]) > 7)or
     (Length(Derriere.DataCode[Compteur]) > 7)Then
   Begin
    Derriere.DataActif[Compteur] := 0;
    Derriere.DataPrix[Compteur]  := 0;
    Derriere.DataCent[Compteur]  := 0;
    FillChar(Derriere.DataPos[Compteur],SizeOf(Derriere.DataPos[Compteur]),0);
    FillChar(Derriere.DataCode[Compteur],SizeOf(Derriere.DataCode[Compteur]),0)
   End;
  End;
  Derriere.DataDerriereComplete.DerriereComplete := 1;
   { Initialise Ecran }
  BaseVisuel(2,4,79,19,4,Serie,25,63,-1);
  Ecrit(37,5,'Description',14);
  Ecrit(73,5,'Code ho',14);
  AffichePieceDerriere(4,7,7);
  BarDeplacement;
  For Compteur := 0 to MaxDerriere do
  Begin
   If(Derriere.DataPrix[Compteur] > 0)and(Derriere.DataCent[Compteur] > 0)Then
   Begin
    Ecrit(25,7+Compteur,Strg(Derriere.DataPrix[Compteur])+','+
                        Strg(Derriere.DataCent[Compteur])+'$',
                        Derriere.DataActif[Compteur]*8+7);
   End
    else
   If(Derriere.DataPrix[Compteur] > 0)Then
   Begin
    Ecrit(25,7+Compteur,Strg(Derriere.DataPrix[Compteur])+'$',
                        Derriere.DataActif[Compteur]*8+7);
   End;
   Ecrit(61,7+Compteur,Derriere.DataPos[Compteur],
                       Derriere.DataActif[Compteur]*8+7);
   AfficheBar(Compteur,Derriere.DataActif[Compteur]*8+7);
  End;
  Repeat
   Ancien := kbAncien;
   Touche := AfficheBarTouche(Position,XPos,$F0,Derriere.DataActif[Position] * 8 + 7);
   Basse  := Lo(Touche);
   Case Basse of
    0 : Begin
         TraiteScanCode(Position,MaxDerriere,Touche);
         Case Hi(Touche) of
          75 : Begin
                RestoreExtension;
                Min(XPos,4);
                Extension;
               End;
          77 : Begin
                RestoreExtension;
                Max(XPos,4);
                Extension;
               End;
          82 : Case XPos of
                0 : Begin
                     Max(Derriere.DataActif[Position],1);
                     AfficheBar(Position,7+Derriere.DataActif[Position]*8);
                     Max(Position,MaxDerriere);
                    End;
                1 : Begin
                  V3:FixeDollar(25,7+Position,8,Derriere.DataPrix[Position],
                                Derriere.DataCent[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxDerriere);
                    End;
                2 : Begin
                     Case Position of
                      00 : FixeToit;
                      04 : FixeAileron;
                      05 : FixeHaillon;
                      11 : FixeBoiteCamion;
                     End;
                     Max(Position,MaxDerriere);
                    End;
                3 : Begin
                  V4:FixeLocalise(61,7+Position,7,Derriere.DataPos[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxDerriere);
                    End;
                4 : Begin
                  V5:FixeLocalise(33,7+Position,7,Derriere.DataCode[Position],Basse);
                     If(Basse = 0)Then Max(Position,MaxDerriere);
                    End;
               End;
          83 : Begin
                AfficheBar(Position,7);
                Derriere.DataActif[Position] := 0;
                Max(Position,MaxDerriere);
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
  If(Touche = kbESC)Then Goto Debut;
  RestoreExtension;
 End
  else
 Begin { Oui }
  Derriere.DataDerriereComplete.DerriereComplete := 1;
  With Derriere.DataDerriereComplete do
  Begin
   Ecrit(2,4,'Combien (prix) ?',15);
   FixeDollar(19,4,15,Prix,Cent,Basse);
   If(Basse = 0)Then
   Begin
    Ecrit(2,5,'Localisation ?',15);
    FixeLocalise(17,5,7,Localise,Basse);
    If(Basse = 0)Then
    Begin
     Ecrit(2,6,'Code hollander ?',15);
     FixeLocalise(20,6,7,Code,Basse);
    End
     Else
    Goto Debut;
   End
    else
   Goto Debut;
  End;
 End;
End;

END.
