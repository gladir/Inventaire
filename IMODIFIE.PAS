Unit IModifie;

Interface

Uses EcrMono,
     Fichier,
     IChaine,
     IClavier,
     IVisuel,
     IMenu,
     IFichier,
     IPassWor,
     IDescr,
     IEnreg,
     IClient,

     IDevant,    { Gestion du Devant         }
     ICowl,      { Gestion du Cowl           }
     IPorte,     { Gestion des portes        }
     IDerr,      { Gestion du DerriŠre       }
     IMotor,     { Gestion du Moteur         }
     IPceMot,    { Gestion des PiŠces Moteur }
     IFreins,    { Gestion des Freins        }
     ISuspens,   { Gestion des Suspensions   }
     IAxle,      { Gestion des Axles         }
     ITrans,     { Gestion de transmission   }
     IPneus;     { Gestion des pneus         }

Procedure Modifie(Choix:Byte);

Implementation

Procedure Modifie(Choix:Byte);
Const EcranTaille = 4000;
      TailleEcran = EcranTaille;
      Couleur     = #3;
Type NumeroSerieType = String[20];

 Function NumeroSerie(Var Numero:NumeroSerieType;CoulDcr:Byte):Byte;
 Var Tableau : Pointer;
     Escape  : Byte;
     Chaine  : String;
 Begin
  NumeroSerie := 0;
   { Pr‚paration ‚cran }
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(20,10,71,14,CoulDcr);
  EcritSpecial(22,12,Couleur+Chr(CoulDcr)+
                     'Entrez le num‚ro de serie ['#4+#20' ]');
   { Lecture du num‚ro du client }
  FillChar(Numero,SizeOf(Numero),0);
  FillChar(Chaine,SizeOf(Chaine),0);
  Repeat
   FixeLocalise(49,12,20,Chaine,Escape);
   Numero := Maj(Chaine);
   If(Escape = 1)Then
   Begin
    NumeroSerie := 1;
    RestituteEcran(Tableau);
    Exit;
   End;
  Until (Numero<>'');
  RestituteEcran(Tableau);
 End;

 Procedure _ModifieAuto;
 Label 10,20,30,40,50,60,70,80,90,100;
 Var Temp           : EnregistrementType;
     TempDescr      : DescrType;
     Escape         : Boolean;
     Rep            : Byte;
     TabDevant      : Pointer;
     TabCowl        : Pointer;
     TabPorte       : Pointer;
     Numero         : NumeroSerieType;
     Pos            : LongInt;
     Descr          : DescrType;
     Enregistrement : EnregistrementType;
     Touche         : Word;
     Handle         : Integer;
 Begin
  If(TestePassWord <> 1)Then Exit;
  If(NumeroSerie(Numero,CoulDcr) = 1)Then Exit;
  Numero := Maj(Numero);
  Pos := RechercheDescription(Descr,1);
  If(Pos = -1)Then
  Begin
   EffaceLigne(24,32,CoulErr);
   Ecrit(2,24,'Numero de s‚rie introuvable, presse une touche pour retourner...',CoulErr);
   Touche := LitClavier;
   Exit;
  End;
  Handle := Ouvre('INVENT.DAT',0);
  LitEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
  Ferme(Handle);
  FillChar(TempDescr,SizeOf(TempDescr),0);
  FillChar(Temp,SizeOf(Temp),0);
  Temp      := Enregistrement;
  TempDescr := Descr;
  With Temp do
  Begin
20:SauvegardeEcran(TabDevant);
   FixeDevant(Devant,Escape); { 0 }
   If(Escape)Then
   Begin
    RestituteEcran(TabDevant);
    Exit;
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
   Descr          := TempDescr;
   Enregistrement := Temp;
   Handle := Ouvre('INVENT.DAT',2);
   ModifieEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
   Ferme(Handle);
  End;
 End;

 Procedure _ModifiePiece;
 Var Handle         : Integer;
     Pos            : LongInt;
     Enregistrement : EnregistrementType;
     Descr          : DescrType;
     Escape         : Boolean;
     Numero         : NumeroSerieType;
     Touche         : Word;

  Procedure _ModifieDevant;
  Begin
   With Enregistrement do
   Begin
    FixeDevant(Devant,Escape);
   End;
  End;

  Procedure _ModifieCowl;
  Begin
   With Enregistrement do
   Begin
    FixeCowl(Cowl,Escape);
   End;
  End;

  Procedure _ModifiePorte;
  Begin
   With Enregistrement do
   Begin
    FixePorte(Porte,Escape);
   End;
  End;

  Procedure _ModifieDerriere;
  Begin
   With Enregistrement do
   Begin
    FixeDerriere(Derriere,Escape);
   End;
  End;

  Procedure _ModifieMoteur;
  Begin
   With Enregistrement do
   Begin
    FixeMotor(Moteur,Escape);
   End;
  End;

  Procedure _ModifiePieceMoteur;
  Begin
   With Enregistrement do
   Begin
    FixePieceMotor(PieceMoteur,Escape);
   End;
  End;

  Procedure _ModifieTransmission;
  Begin
   With Enregistrement do
   Begin
    FixeTransmission(Trans,Escape);
   End;
  End;

  Procedure _ModifieFrein;
  Begin
   With Enregistrement do
   Begin
    FixeFreins(Frein,Escape);
   End;
  End;

  Procedure _ModifieSuspension;
  Begin
   With Enregistrement do
   Begin
    FixeSuspension(Suspension,Escape);
   End;
  End;

  Procedure _ModifieAxle;
  Begin
   With Enregistrement do
   Begin
    FixeAxle(Axle,Escape);
   End;
  End;

 Begin
  If(TestePassWord <> 1)Then Exit;
  If(NumeroSerie(Numero,CoulDcr) = 1)Then Exit;
  Numero := Maj(Numero);
  Pos := RechercheDescription(Descr,1);
  If(Pos = -1)Then
  Begin
   EffaceLigne(24,32,CoulErr);
   Ecrit(2,24,'Numero serie introuvable, presse une touche pour retourner...',CoulErr);
   Touche := LitClavier;
   Exit;
  End;
  Handle := Ouvre('INVENT.DAT',0);
  LitEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
  Ferme(Handle);
  Escape := False;
  Case Choix of
         ModificationDevant : _ModifieDevant;
           ModificationCowl : _ModifieCowl;
          ModificationPorte : _ModifiePorte;
       ModificationDerriere : _ModifieDerriere;
         ModificationMoteur : _ModifieMoteur;
    ModificationPieceMoteur : _ModifiePieceMoteur;
   ModificationTransmission : _ModifieTransmission;
         ModificationFreins : _ModifieFrein;
     ModificationSuspension : _ModifieSuspension;
           ModificationAxle : _ModifieAxle;
  End;
  If(Escape)Then Exit;
  Handle := Ouvre('INVENT.DAT',2);
  ModifieEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
  Ferme(Handle);
 End;

Begin
 Case Choix of
                      ModificationAuto : _ModifieAuto;
                    ModificationClient : ModifieClient;
                  ModificationPassWord : NouveauPassWord;
  ModificationDevant..ModificationAxle : _ModifiePiece;
 End;
End;

BEGIN
END.
