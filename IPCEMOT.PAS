(***********************************************************************)
(*                                                                     *)
(*                     Inventaire Piece ratache au moteur              *)
(*                             1992/05/15                              *)
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

Unit IPceMot;

{$V-}

(***********************************************************************)
                                 Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Type
      CarType            = String[6];

Const

      TempIntercooler    = 'Intercooler';

      Intercooler        : String[Length(TempIntercooler)] = TempIntercooler;

      TempOilCooler      = 'Oil cooler';

      OilCooler          : String[Length(TempOilCooler)] = TempOilCooler;

      TempTurbine        = 'Turbine';

      Turbine            : String[Length(TempTurbine)] = TempTurbine;

      TempPompeInjection = 'Pompe injection';

      PompeInjection     : String[Length(TempPompeInjection)]
                             = TempPompeInjection;

      TempModuleElectronique = 'Module ‚lectronique';

      ModuleElectronique : String[Length(TempModuleElectronique)] =
                             TempModuleElectronique;

      TempAlternateur    = 'Alternateur';

      Alternateur        : String[Length(TempAlternateur)] = TempAlternateur;

      TempStarter        = 'Starter';

      Starter            : String[Length(TempStarter)] = TempStarter;

      TempDistributeur   = 'Distributeur';

      Distributeur       : String[Length(TempDistributeur)] =
                             TempDistributeur;

      TempBindesPoulies  = 'Bindes poulies';

      BindesPoulies      : String[Length(TempBindesPoulies)] =
                             TempBindesPoulies;

      MinChxCarburant  = 0;
      MaxChxCarburant  = 1;

      BIOSinRAM        = $0040;
      BIOSRAM          = BIOSinRAM;
      SegmentBIOSinRAM = BIOSRAM;
      BR               = SegmentBIOSinRAM;

      ChoixCarburant : Array[MinChxCarburant..MaxChxCarburant] of CarType =
                                                              ('Gaz   ',
                                                               'Diesel');

      MinPieceMoteur   = 0;
      MinPieceMotor    = MinPieceMoteur;
      MinPceMot        = MinPieceMoteur;
      MinPceMtr        = MinPieceMoteur;

      MaxPieceMoteur   = 9;
      MaxPieceMotor    = MaxPieceMoteur;
      MaxPceMot        = MaxPieceMoteur;
      MaxPceMtr        = MaxPieceMoteur;

      SauteLigne       = #1;
      Couleur          = #3;
      Swich            = #18;
      Transparent      = #28;
      Color            = Couleur;

      Nul              = 0;
      Null             = Nul;
      Nulle            = Nul;

Type
      CodeHollanderType = String[7];
      CodeType          = String[7];
      PieceMoteurType   = Record
                           Actif      : Array[0..MaxPceMtr] of Byte;
                           Prix       : Array[0..MaxPceMtr] of Word;
                           Cent       : Array[0..MaxPceMtr] of Byte;
                           Loc        : Array[0..MaxPceMtr] of CodeType;
                           Code       : Array[0..MaxPceMtr] of CodeType;
                           Pompe      : Byte;
                           Module     : Byte;
                           Starter    : Byte;
                           Decommande : Byte;
                           Amperage   : Word;
                           Modele     : String[10];
                          End;
      PceMotType        = PieceMoteurType;
      PceMotorType      = PceMotType;

Procedure AffichePieceRatacheMoteur(X,Y,Couleur:Byte);
Procedure FixePieceMotor(Var PieceMotor:PieceMoteurType;Var Escape:Boolean);

(***********************************************************************)
                            Implementation
(***********************************************************************)

Procedure AffichePieceRatacheMoteur(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,Color + Chr(Couleur)+
             Intercooler + SauteLigne +
             OilCooler + SauteLigne +
             Turbine + SauteLigne +
             PompeInjection + SauteLigne +
             ModuleElectronique + SauteLigne +
             Alternateur + SauteLigne +
             Starter + SauteLigne +
             Distributeur + SauteLigne +
             'Compr air conditi.' + SauteLigne +
             BindesPoulies);
End;

Procedure FixePieceMotor(Var PieceMotor:PieceMoteurType;Var Escape:Boolean);
Label V0,V1,V3,V7,V8;
Const
      Position : Byte = 0;
      XPos     : Byte = 0;
      XD       = 2;
      YD       = 2;
      TabBar   : Array[0..14] of Byte = (XD+1,YD+3,XD+21,
                                         XD+23,YD+3,XD+32,
                                         XD+34,YD+3,XD+46,
                                         XD+48,YD+3,XD+57,
                                         XD+59,YD+3,XD+74);
      SerieVer : Array[0..11] of Byte = (XD+22,YD,YD+13,
                                         XD+33,YD,YD+13,
                                         XD+47,YD,YD+13,
                                         XD+58,YD,YD+13);
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Compteur : Byte;
    kbAncien : Word Absolute BR:$1A;

 Procedure GazDiesel(X,Y:Byte;Var Result:Byte);
 Var Touche  : Word;
     Couleur : Byte;
     Tableau : Pointer;
 Begin
  Inc(Y);
  SauvegardeEcran(Tableau);
  Result := 0;
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+13,Y+5,CoulDcr);
  EcritSpecial(X+1,Y+1,Transparent+
                       'Carburant :' + SauteLigne +
                       SauteLigne+
                       ' Gaz' + SauteLigne +
                       ' Diesel');
  Repeat
   BarSelecteHori(X+1,Y+3+Result,X+12,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+3+Result,X+12,CoulDcr);
   TraiteScanCode(Result,1,Touche);
   Case Touche of
    kbESC : Begin
             RestituteEcran(Tableau);
             Result := 255;
             Exit;
            End;
   End;
  Until (Touche = kbEnter);
  RestituteEcran(Tableau);
  Dec(Y);
  Ecrit(X,Y,ChoixCarburant[Result],15);
 End;

Begin
  { Initialise donnee }
 For Compteur := MinPceMtr to MaxPceMtr do
 Begin
  If(PieceMotor.Actif[Compteur] > 1)or
    (PieceMotor.Cent[Compteur] > 100)or
    (Length(PieceMotor.Code[Compteur]) > 7)or
    (Length(PieceMotor.Loc[Compteur]) > 7)Then
  Begin
   PieceMotor.Actif[Compteur] := Nulle;
   PieceMotor.Prix[Compteur]  := Nulle;
   PieceMotor.Cent[Compteur]  := Nulle;
   FillChar(PieceMotor.Code[Compteur],SizeOf(PieceMotor.Code[Compteur]),Nul);
   FillChar(PieceMotor.Loc[Compteur],SizeOf(PieceMotor.Loc[Compteur]),Null);
  End;
 End;
 FixeFormatBar(5,TabBar);
 Escape := False;
 With PieceMotor do
 Begin
   { Initialise Ecran }
  BaseVisuel(XD,YD,XD+75,YD+13,4,SerieVer,XD+24,XD+49,XD+60);
  Ecrit(XD+35,YD+1,'Description',14);
  AffichePieceRatacheMoteur(XD+2,YD+3,7);
  Repeat
   Ancien  := kbAncien;
   Touche  := AfficheBarTouche(Position,XPos,$F0,Actif[Position] * 8 + 7);
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
         ToucheTab(MaxPceMtr,4,Touche,Position,XPos,Actif[Position]);
         If(Hi(Touche) = 82)Then
         Begin
          Case XPos of
           0 : Max(Actif[Position],1);
           1 : Begin
             V0:FixeDollar(XD+24,YD+3+Position,9,Prix[Position],Cent[Position],Basse);
               End;
           2 : Begin
                Case Position of
                 3 : Begin
                      GazDiesel(XD+35,YD+6,Basse);
                      If(Basse < 255)Then Pompe := Basse;
                     End;
                 4 : Begin
                      GazDiesel(XD+35,YD+7,Basse);
                      If(Basse < 255)Then Module := Basse;
                     End;
                 6 : Begin
                      GazDiesel(XD+35,YD+9,Basse);
                      If(Basse < 255)Then Starter := Basse;
                     End;
                End;
                Basse := 0;
               End;
           3 : Begin
             V3:FixeLocalise(XD+49,YD+3+Position,7,Loc[Position],Basse);
               End;
           4 : Begin
             V7:FixeLocalise(XD+60,YD+3+Position,7,Code[Position],Basse);
               End;
          End;
          If(XPos > 0)and(Basse = 0)Then Actif[Position] := 1;
          AfficheBar(Position,7 + Actif[Position] * 8);
          Max(Position,MaxPceMtr);
          V8:
         End;
        End;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then Escape := True;
 End;
End;

BEGIN { Main Unit }
END.
