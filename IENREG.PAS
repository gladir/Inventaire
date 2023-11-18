(**************************************************************************)
(*                                                                        *)
(*                        Inventaire Enregistrement                       *)
(*                               22/04/1992                               *)
(*                                                                        *)
(**************************************************************************)

Unit IEnreg;

(**************************************************************************)
                                Interface
(**************************************************************************)

Uses EcrMono,    { Gestion Base ‚cran monochrome }
     Intro   ,
     ICLavier,
     IVisuel,    { Gestion complementaire ‚cran monochrome }
     Reseau,     { Gestion r‚seau }
     IFichier,   { Gestion compl‚mentaire fichier }
     IDescr,     { Gestion Description }
     IClient,    { Gestion Client }
     IPassWor,   { Gestion PassWord }
     IQuest,     { Gestion question }
     IMenu,      { Gestion Menu }

     IDevant,    { Gestion du Devant }
     ICowl,      { Gestion du Cowl }
     IPorte,     { Gestion des portes }
     IDerr,      { Gestion du DerriŠre }
     IMotor,     { Gestion du Moteur }
     IPceMot,    { Gestion des PiŠces Moteur }
     IFreins,    { Gestion des Freins }
     ISuspens,   { Gestion des Suspensions }
     IAxle,      { Gestion des Axles }
     ITrans,     { Gestion de transmission }
     IPneus;     { Gestion des pneus }

Const Nul               = 0;
      Null              = Nul;
      Nulle             = Null;

Type
     LocaliseType       = String[7];
     CodeHollanderType  = String[7];
     CodeType           = CodeHollanderType;
     TypeCode           = CodeType;
     LocType            = LocaliseType;
     CodeHolType        = TypeCode;

     EnregistrementType = Record
                           Devant       : DevantType;
                           Cowl         : CowlType;
                           Porte        : PorteType;
                           Derriere     : DerriereType;
                           Moteur       : MoteurType;
                           PieceMoteur  : PieceMoteurType;
                           Trans        : TransmissionType;
                           Frein        : FreinType;
                           Suspension   : SuspensionType;
                           Axle         : AxleType;
                           Localisation : LocaliseType;
                           Code         : CodeType;
                          End;

 { Procedure }

Procedure NewClient;
Procedure PAdditionAuto;
Procedure PAdditionAxle;
Procedure PAdditionCowl;
Procedure PAdditionDerriere;
Procedure PAdditionDevant;
Procedure PAdditionFrein;
Procedure PAdditionMoteur;
Procedure PAdditionPieceMoteur;
Procedure PAdditionPneus;
Procedure PAdditionPorte;
Procedure PAdditionSuspension;
Procedure PAdditionTransmission;
Procedure PComplementaire;
Procedure PIntro;
Procedure PLectureAuto;
Procedure PModificationAuto;
Procedure PModificationAxle;
Procedure PModificationCowl;
Procedure PModificationDerriere;
Procedure PModificationDevant;
Procedure PModificationFreins;
Procedure PModificationMoteur;
Procedure PModificationPieceMoteur;
Procedure PModificationPneus;
Procedure PModificationPorte;
Procedure PModificationSuspension;
Procedure PModificationTransmission;
Procedure PQuitte;
Procedure PTailleEnregistrement;

(**************************************************************************)
                               Implementation
(**************************************************************************)

Const TailleEcran = 4000;

       { Constante d'ajustement des couleurs }

      Couleur     = #3;
      Color       = Couleur;
      Transparent = #28;
      Noir        = 0;
      Bleu        = 1;
      Vert        = 2;
      Cyan        = 3;
      Rouge       = 4;
      Magent      = 5;
      Brun        = 6;
      Gris        = 7;
      Jaune       = 14;
      Blanc       = 15;

      FondNoir  = 16 * Noir;
      FondBleu  = 16 * Bleu;
      FondVert  = 16 * Vert;
      FondCyan  = 16 * Cyan;
      FondRouge = 16 * Rouge;


Procedure FixeAuto(Var Enregistrement:EnregistrementType;Var Descr:DescrType);
Label 10,20,30,40,50,60,70,80,90,100;
Var Temp      : EnregistrementType;
    TempDescr : DescrType;
    Escape    : Boolean;
    Rep       : Byte;
    TabDevant : Pointer;
    TabCowl   : Pointer;
    TabPorte  : Pointer;
Begin
 FillChar(TempDescr,SizeOf(TempDescr),0);
 FillChar(Temp,SizeOf(Temp),0);
 With Temp do
 Begin
10:Description(TempDescr,Rep);
  If(Rep = 1)Then Exit;
20:SauvegardeEcran(TabDevant);
  FixeDevant(Devant,Escape); { 0 }
  If(Escape)Then
  Begin
   RestituteEcran(TabDevant);
   Goto 10;
  End;
  SauvegardeEcran(TabCowl);
30:FixeCowl(Cowl,Escape); { 1 }
  If(Escape)Then
  Begin
   RestituteEcran(TabCowl);
   RestituteEcran(TabDevant);
   Goto 20;
  End;
  SauvegardeEcran(TabPorte);
40:FixePorte(Porte,Escape); { 2 }
  If(Escape)Then
  Begin
   RestituteEcran(TabPorte);
   Goto 30;
  End;
50:FixeDerriere(Derriere,Escape); { 3 }
  If(Escape)Then Goto 40;
60:FixeMotor(Moteur,Escape); { 4 }
  If(Escape)Then Goto 50;
70:FixePieceMotor(PieceMoteur,Escape); { 5 }
  If(Escape)Then Goto 60;
80:FixeTransmission(Trans,Escape); { 6 }
  If(Escape)Then Goto 70;
90:FixeFreins(Frein,Escape); { 7 }
  If(Escape)Then Goto 80;
100:FixeSuspension(Suspension,Escape); { 8 }
  If(Escape)Then Goto 90;
  FixeAxle(Axle,Escape); { 9 }
  If(Escape)Then Goto 100;
  FreeMem(TabDevant,TailleEcran);
  EcritNombre(73,0,MaxAvail,CoulMnu);
  Descr          := TempDescr;
  Enregistrement := Temp;
  SauveEnregistrement(Descr,Enregistrement,Escape);
 End;
End;

(**************************************************************************)

Procedure NewClient;
Var Client  : ClientType;
    Escape  : Byte;
Begin
 Escape := AdditionClient(Client);
End;

(**************************************************************************)

Procedure PAdditionAuto;
Var Descr          : DescrType;
    Enregistrement : EnregistrementType;
Begin
 FillChar(Descr,SizeOf(Descr),0);
 FillChar(Enregistrement,SizeOf(Enregistrement),0);
 FixeAuto(Enregistrement,Descr);
End;

(**************************************************************************)

Procedure PAdditionAxle;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeAxle(Axle,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionCowl;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeCowl(Cowl,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionDerriere;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeDerriere(Derriere,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionDevant;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeDevant(Devant,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionFrein;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 FillChar(Enregistrement,SizeOf(Enregistrement),0);
 With Enregistrement do
 Begin
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeFreins(Frein,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionMoteur;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeMotor(Moteur,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionPieceMoteur;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixePieceMotor(PieceMoteur,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionPneus;
Begin
 AdditionPneus;
End;

(**************************************************************************)

Procedure PAdditionPorte;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixePorte(Porte,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionSuspension;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeSuspension(Suspension,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PAdditionTransmission;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  FillChar(Enregistrement,SizeOf(Enregistrement),0);
  NouveauDescription(Descr,Rep);
  If(Rep <> 1)Then
  Begin
   FixeTransmission(Trans,Escape);
   If(Escape = False)Then
   Begin
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PComplementaire;
Begin
End;

(**************************************************************************)

Procedure PLectureAuto;
Begin
 LectureEnregistrement(GetAuto);
End;

(**************************************************************************)

Procedure PIntro;
Var Touche : Word;
Begin
 Introduction;
 EcritDerLigne('Intro termin‚, presse une touche pour retourner...');
 Touche := LitClavier;
 BarMenu;
 Tapiserie(TextureFont);
 BarRemarque;
End;

(**************************************************************************)

Procedure PModificationAuto;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
Begin
 FixeAuto(Enregistrement,Descr);
End;

(**************************************************************************)

Procedure PModificationAxle;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeAxle(Axle,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationCowl;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeCowl(Cowl,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationDerriere;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeDerriere(Derriere,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationDevant;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeDevant(Devant,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationFreins;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeFreins(Frein,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationMoteur;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeMotor(Moteur,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationPieceMoteur;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixePieceMotor(PieceMoteur,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationPneus;
Begin
 ModificationPneus;
End;

(**************************************************************************)

Procedure PModificationPorte;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixePorte(Porte,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationSuspension;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeSuspension(Suspension,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)

Procedure PModificationTransmission;
Var Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Rep            : Byte;
    Escape         : Boolean;
Begin
 With Enregistrement do
 Begin
  If(TestePassWord = 1)Then
  Begin
   Description(Descr,Rep);
   If(Rep <> 1)Then
   Begin
    FixeTransmission(Trans,Escape);
    SauveEnregistrement(Descr,Enregistrement,Escape);
   End;
  End;
 End;
End;

(**************************************************************************)
(*                                                                        *)
(*                             Proc‚dure Quitte                           *)
(*                                1992/05/08                              *)
(*                                                                        *)
(* Description : þ Cette procedure provoque l'arret du programme et rend  *)
(*                 le controle au DOS.                                    *)
(* Note        : þ Il n'est pas n‚cessaire d'ajouter une proc‚dure de     *)
(*                 teste de si il est certain de bien vouloir quitter,    *)
(*                 car il fait le teste lui-meme.
(*                                                                        *)
(**************************************************************************)

Procedure PQuitte;
Var Rep : Byte;

 Procedure Locate(X,Y:Byte);
 Assembler;
 ASM MOV AH,$0F;
     INT $10;
     MOV AH,$02;
     MOV DL,X;
     MOV DH,Y;
     INT $10;
 End;

Begin { Main PQuitte }
 Quitte(Rep);
 If(Rep = Oui)Then
 Begin
  CloseReseau;
  EffaceEcran;
  EffaceLigne(0,32,FondBleu);
  EcritSpecial(2,0,Couleur+Chr(FondBleu+Gris)+
                   'Merci d''utiliser le '+
                   Couleur+Chr(FondBleu+Blanc)+
                   'SystŠme    '+
                   Couleur+Chr(FondBleu+Gris)+'!');
  Locate(0,2);
  FixeCurseurOuvert;
  Halt;
 End;
End;

(**************************************************************************)
(*                                                                        *)
(*                    Proc‚dure Taille Enregistrement                     *)
(*                               1992/05/08                               *)
(*                                                                        *)
(* Description : þ Cette proc‚dure mes dans la constante                  *)
(*                 "TailleEnregistrement" la longeur (en octet) occupe en *)
(*                 memoire du record "EnregistrementType".                *)
(*                                                                        *)
(**************************************************************************)

Procedure PTailleEnregistrement;
Var Enregistrement : EnregistrementType;
Begin
 TailleEnregistrement := SizeOf(Enregistrement);
End;

BEGIN
 PTailleEnregistrement;
END.