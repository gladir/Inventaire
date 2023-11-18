(*************************************************************************)
(*                                                                       *)
(*                          Inventaire Get Files                         *)
(*                              1992/05/16                               *)
(*                                                                       *)
(* Programmeur : Sylvain Maltais                                         *)
(*                                                                       *)
(* Description : þ Cette procedure affiche un consultation des pieces    *)
(*                 Automobiles.                                          *)
(*                                                                       *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).     *)
(*                 en mode texte monochrome (07h).                       *)
(*               þ Turbo Pascal 6 ou post‚rieur.                         *)
(*                                                                       *)
(*************************************************************************)

Unit IGetFile;

{$V-}

(*************************************************************************)
                                 Interface
(*************************************************************************)

Uses Drivers,    { Gestion complementaire du DOS       }
     EcrMono,    { Gestion de video                    }
     Fichier,    { Gestion des fichiers                }
     IChaine,    { Gestion des chaines                 }
     IClavier,   { Gestion du clavier                  }
     IVisuel,    { Gestion complementaire du video     }
     IMenu,      { Gestion des menus                   }
     IFichier,   { Gestion complementaire des fichiers }
     IPassWor,   { Gestion du PassWord                 }
     IDescr,     { Gestion des descriptions            }
     IEnreg,     { Gestion des enregistrements         }
     IClient,    { Gestion des clients                 }
     ISlcPce,    { Gestion de selection d'un piece     }

     IDevant,    { Gestion du Devant                   }
     ICowl,      { Gestion du Cowl                     }
     IPorte,     { Gestion des portes                  }
     IDerr,      { Gestion du DerriŠre                 }
     IMotor,     { Gestion du Moteur                   }
     IPceMot,    { Gestion des PiŠces Moteur           }
     IFreins,    { Gestion des Freins                  }
     ISuspens,   { Gestion des Suspensions             }
     IAxle,      { Gestion des Axles                   }
     ITrans,     { Gestion de transmission             }
     IPneus;     { Gestion des pneus                   }

Type NumeroSerieType = String[20];
     StrModele       = String[20];

Procedure AfficheString(X,Y,Longeur:Byte;Chaine:String);
{Procedure AxleCardan(Enregistrement:EnregistrementType);
Procedure AxleEssieu(Enregistrement:EnregistrementType);
Procedure AxleDiferentiel(Enregistrement:EnregistrementType);
Procedure AxleCochonDiferentiel(Enregistrement:EnregistrementType);
Procedure AxleDriveShaft(Enregistrement:EnregistrementType);
Procedure CowlWindShield(Enregistrement:EnregistrementType);
Procedure CowlDash(Enregistrement:EnregistrementType);
Procedure CowlSpedometre(Enregistrement:EnregistrementType);
Procedure CowlRadio(Enregistrement:EnregistrementType);
Procedure CowlComboSwich(Enregistrement:EnregistrementType);
Procedure CowlIgnitionSwich(Enregistrement:EnregistrementType);
Procedure CowlRadiateurChaufferette(Enregistrement:EnregistrementType);
Procedure CowlMoteurChaufferette(Enregistrement:EnregistrementType);
Procedure CowlMoteurWhiper(Enregistrement:EnregistrementType);
Procedure CowlWhiperTransmission(Enregistrement:EnregistrementType);
Procedure DerriereComplet(Enregistrement:EnregistrementType);
Procedure DerriereToit(Enregistrement:EnregistrementType);
Procedure DerriereQuarterPannel(Enregistrement:EnregistrementType);
Procedure DerriereQuarterGlass(Enregistrement:EnregistrementType);
Procedure DerriereBackGlass(Enregistrement:EnregistrementType);
Procedure DerriereValise(Enregistrement:EnregistrementType);
Procedure DerriereHaillon(Enregistrement:EnregistrementType);
Procedure DerriereTankGaz(Enregistrement:EnregistrementType);
Procedure DerriereRearFinishPanel(Enregistrement:EnregistrementType);
Procedure DerriereTailgate(Enregistrement:EnregistrementType);
Procedure DerriereTaillite(Enregistrement:EnregistrementType);
Procedure DerriereBumper(Enregistrement:EnregistrementType);
Procedure DerriereBoiteCamion(Enregistrement:EnregistrementType);
Procedure DevantComplet(Enregistrement:EnregistrementType);
Procedure DevantBumper(Enregistrement:EnregistrementType);
Procedure DevantValence(Enregistrement:EnregistrementType);
Procedure DevantGrille(Enregistrement:EnregistrementType);
Procedure DevantHeaderPanel(Enregistrement:EnregistrementType);
Procedure DevantHeadLampDor(Enregistrement:EnregistrementType);
Procedure DevantHeadLamp(Enregistrement:EnregistrementType);
Procedure DevantHeadLampMotor(Enregistrement:EnregistrementType);
Procedure DevantParkLamp(Enregistrement:EnregistrementType);
Procedure DevantCondenseurAir(Enregistrement:EnregistrementType);
Procedure DevantRadiateur(Enregistrement:EnregistrementType);
Procedure DevantFanRadiateur(Enregistrement:EnregistrementType);
Procedure DevantAileGauche(Enregistrement:EnregistrementType);
Procedure DevantAileDroite(Enregistrement:EnregistrementType);
Procedure DevantFrame(Enregistrement:EnregistrementType);
Procedure DevantFrameRail(Enregistrement:EnregistrementType);
Procedure DevantCapot(Enregistrement:EnregistrementType);
Procedure FreinsRotor(Enregistrement:EnregistrementType);
Procedure FreinsGaliper(Enregistrement:EnregistrementType);
Procedure FreinsRearDrum(Enregistrement:EnregistrementType);
Procedure FreinsMasterCylindre(Enregistrement:EnregistrementType);
Procedure FreinsBooster(Enregistrement:EnregistrementType);
Procedure FreinsAntiskid(Enregistrement:EnregistrementType);}
Procedure Lecture(Menu:Byte);
Procedure _LectureAuto;
Procedure _LecturePiece;
Procedure _LectureCode;
Procedure _LectureLocalise;
Procedure LitDescription(Handle:Integer;Position:LongInt;Var Descr:DescrType);
Procedure LitEnreg(Handle:Integer;Position:LongInt;Var Enregistrement:EnregistrementType);
Procedure MessageErreur(Phrase:String);
{Procedure MoteurComplet(Enregistrement:EnregistrementType);
Procedure MoteurCamShaft(Enregistrement:EnregistrementType);
Procedure MoteurTeteMoteur(Enregistrement:EnregistrementType);
Procedure MoteurTimingCouer(Enregistrement:EnregistrementType);
Procedure MoteurPaneHuile(Enregistrement:EnregistrementType);
Procedure MoteurCarburateur(Enregistrement:EnregistrementType);
Procedure MoteurInjection(Enregistrement:EnregistrementType);
Procedure MoteurPompeGaz(Enregistrement:EnregistrementType);
Procedure MoteurPompeEau(Enregistrement:EnregistrementType);
Procedure MoteurManifaultExhaust(Enregistrement:EnregistrementType);
Procedure MoteurManifaultIntake(Enregistrement:EnregistrementType);
Procedure PieceMoteurIntercooler(Enregistrement:EnregistrementType);
Procedure PieceMoteurOilCooler(Enregistrement:EnregistrementType);
Procedure PieceMoteurTurbine(Enregistrement:EnregistrementType);
Procedure PieceMoteurPompeInjection(Enregistrement:EnregistrementType);
Procedure PieceMoteurModuleElectronique(Enregistrement:EnregistrementType);
Procedure PieceMoteurAlternateur(Enregistrement:EnregistrementType);
Procedure PieceMoteurStarter(Enregistrement:EnregistrementType);
Procedure PieceMoteurDistributeur(Enregistrement:EnregistrementType);
Procedure PieceMoteurCompresseurAirConditionne(Enregistrement:EnregistrementType);
Procedure PieceMoteurBindesPoulies(Enregistrement:EnregistrementType);
Procedure PorteAvantGauche(Enregistrement:EnregistrementType);
Procedure PorteAvantDroite(Enregistrement:EnregistrementType);
Procedure PorteArriereGauche(Enregistrement:EnregistrementType);
Procedure PorteArriereDroite(Enregistrement:EnregistrementType);}
Procedure ReturnTempDescr(Position:LongInt;Var Descr:DescrType);
Procedure ReturnEnregistrement(Position:LongInt;Var Enregistrement:EnregistrementType);
{Procedure SuspensionSpindel(Enregistrement:EnregistrementType);
Procedure SuspensionTab(Enregistrement:EnregistrementType);
Procedure SuspensionStrut(Enregistrement:EnregistrementType);
Procedure SuspensionIBeam(Enregistrement:EnregistrementType);
Procedure SuspensionBarTortion(Enregistrement:EnregistrementType);
Procedure SuspensionBarStabilisatrice(Enregistrement:EnregistrementType);
Procedure SuspensionAxleBeam(Enregistrement:EnregistrementType);
Procedure SuspensionRearStub(Enregistrement:EnregistrementType);
Procedure SuspensionSpring(Enregistrement:EnregistrementType);
Procedure SuspensionLames(Enregistrement:EnregistrementType);
Procedure SuspensionBoxStering(Enregistrement:EnregistrementType);
Procedure SuspensionCremaillere(Enregistrement:EnregistrementType);
Procedure SuspensionPompePowerStering(Enregistrement:EnregistrementType);
Procedure SuspensionColoneStering(Enregistrement:EnregistrementType);
Procedure TransmissionAssemble(Enregistrement:EnregistrementType);
Procedure TransmissionPressurePiate(Enregistrement:EnregistrementType);
Procedure TransmissionFlyWheel(Enregistrement:EnregistrementType);
Procedure TransmissionTransferCase(Enregistrement:EnregistrementType);}

Function NumeroSerie(Var Numero:NumeroSerieType;CoulDcr:Byte):Byte;
Function Modele(Var Mode:StrModele):ShortInt;
Function StrPrix(Prix:Word;Cent:Byte):String;
Function StrLocalise(Localise:String):String;
Function StrCode(Code:String):String;

(*************************************************************************)
                              Implementation
(*************************************************************************)

Const Logique   : Array[0..1] of String[3] = ('Non','Oui');
      Assem     : Array[0..1] of String[12] = ('Desassembler','Assembler   ');
      TCChoix   : Array[0..2] of String[3] = ('Non','T  ','C  ');
      TypePorte : Array[0..3] of String[2] = ('EC','ET','MC','MT');

      TailleEcran = 4000;
      EcranTaille = TailleEcran;
      Couleur     = #3;

{$I EXTRA.INV }

(*************************************************************************)

Procedure MessageErreur(Phrase:String);
Label 10;
Var Touche   : Word;
    Ligne    : Byte;
    Compteur : Byte;
    Chaine1  : String[40];
    Chaine2  : String[40];
Begin
 FillChar(Chaine1,SizeOf(Chaine1),0);
 FillChar(Chaine2,SizeOf(Chaine2),0);
 If(Length(Phrase) > 38)Then
 Begin
  For Compteur := 38 downto 1 do
  Begin
   If(Phrase[Compteur] = ' ')Then
   Begin
    Chaine1 := Copy(Phrase,1,Compteur-1);
    Chaine2 := Copy(Phrase,Compteur+1,255);
    Goto 10;
   End;
  End;
 End
  else
 Chaine1 := Phrase;
 10:If(Chaine2 <> '')Then Ligne := 17
                     Else Ligne := 18;
 FixeFormatDouble;
 FixeCadrePlain(20,10,60,Ligne,CoulErr);
 Ecrit(22,12,Chaine1,CoulErr);
 If(Chaine2 <> '')Then Ecrit(22,13,Chaine2,CoulErr);
 Ecrit(36,Ligne-2,' Correcte ',CoulSlc);
 EffaceLigne(24,32,CoulBar);
 EcritSpecial(2,24,#3+Chr(CoulTch)+'ENTER'+#3+Chr(CoulBar)+' Retourner'+#18+
                   '  ESC'+#18+' Retourner');
 Write(^G);
 Repeat
  Touche := LitClavier;
 Until (Touche = kbEnter)or(Touche = kbESC);
End;

(*************************************************************************)

Procedure LitEnreg(Handle:Integer;Position:LongInt;Var Enregistrement:EnregistrementType);
Begin
 FillChar(Enregistrement,SizeOf(Enregistrement),0);
 LitEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
End;

(*************************************************************************)

Procedure LitDescription(Handle:Integer;Position:LongInt;Var Descr:DescrType);
Begin
 FillChar(Descr,SizeOf(Descr),0);
 LitEnregistrement(Handle,Position,SizeOf(Descr),Descr);
End;

(*************************************************************************)

Procedure ReturnEnregistrement(Position:LongInt;Var Enregistrement:EnregistrementType);
Var Handle : Integer;
Begin
 Handle := Ouvre('INVENT.DAT',0);
 LitEnreg(Handle,Position,Enregistrement);
 Ferme(Handle);
End;

(*************************************************************************)

Procedure ReturnTempDescr(Position:LongInt;Var Descr:DescrType);
Var Handle : Integer;
Begin
 Handle := Ouvre('FILES.TMP',0);
 LitDescription(Handle,Position,Descr);
 Ferme(Handle);
End;

(*************************************************************************)

Procedure AfficheString(X,Y,Longeur:Byte;Chaine:String);
Var Compteur : Byte;
Begin
 For Compteur := 1 to Longeur do
 Begin
  If(Chaine[Compteur] < #32)Then Chaine[Compteur] := #32;
 End;
 If(Length(Chaine) > 0)Then Ecrit(X,Y,Copy(Chaine,1,Longeur),7)
                       Else Ecrit(X,Y,Espace(Longeur),7);
End;

(*************************************************************************)

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

(*************************************************************************)

Function Modele(Var Mode:StrModele):ShortInt;
Var Tableau : Pointer;
    Escape  : Byte;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain((Colonne-30) div 2,12,((Colonne-30) div 2)+30,14,CoulDcr);
 Ecrit(((Colonne-30) div 2)+1,13,'ModŠle :',CoulDcr);
 FixeLocalise(((Colonne-30) div 2)+10,13,20,Mode,Escape);
 RestituteEcran(Tableau);
 If(Escape = 0)Then Modele := 0
               Else Modele := -1;
End;

(*************************************************************************)

Function StrPrix(Prix:Word;Cent:Byte):String;
Begin
 If(Cent < 100)and(Cent > 0)Then
 Begin
  StrPrix := 'Prix : ' + Strg(Prix) + ',' + Strg(Cent) + '$';
 End
  else
 Begin
  StrPrix := 'Prix : ' + Strg(Prix) + '$'
 End;
End;

(*************************************************************************)

Function StrLocalise(Localise:String):String;
Var Compteur : Byte;
Begin
 For Compteur := 0 to 7 do
 Begin
  If(Localise[Compteur] < #32)Then Localise[Compteur] := #32;
 End;
 StrLocalise := 'Localise : ' + Copy(Localise,1,7);
End;

(*************************************************************************)

Function StrCode(Code:String):String;
Var Compteur : Byte;
Begin
 For Compteur := 0 to 7 do
 Begin
  If(Code[Compteur] < #32)Then Code[Compteur] := #32;
 End;
 StrCode := 'Code hollander : ' + Copy(Code,1,7);
End;

(*************************************************************************)

Procedure Lecture(Menu:Byte);
Begin
 Case Menu of
      LectureAuto : _LectureAuto;
     LecturePiece : _LecturePiece;
      LectureCode : _LectureCode;
  LectureLocalise : _LectureLocalise;
  LectureUnClient : LitUnClient;
LectureToutClient : LitToutClient;
 End;
End;

{*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
(*                                                                   *)
(* Affiche : þ                                                       *)
(*                                                                   *)
(* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
(*             qu'une touche soit enfonce ce pour quitte.            *)
(*           þ Il est egalement important a noter que cette          *)
(*             procedure ne sauvegarde ni ne restitute environnement *)
(*             video.                                                *)
(*           þ Et pour finir il y a un petite detail insignifiant a  *)
(*             prendre en note, ce qu'il n'affiche nullement de      *)
(*             message d'enfoncer tel ou tel touche...               *)
(*                                                                   *)
(*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

Procedure DevantComplet(Enregistrement:EnregistrementType);
Const X = 2;
      Y = 2;
Begin
      With Enregistrement.Devant.AvantComplet do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+7,CoulDcr);
       Ecrit(X+2,Y+2,'Devant complet :',CoulDcr);
       Ecrit(X+3,Y+4,'Prix : '+Strg(Prix)+','+Strg(Cent)+'$',CoulDcr);
       Ecrit(X+3,Y+5,'Localise : '+Copy(Localise,1,7),CoulDcr);
       Ecrit(X+3,Y+6,'Code hollander : '+Copy(Code,1,7),CoulDcr);
      End;
End;

(*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
(*                                                                   *)
(* Affiche : þ                                                       *)
(*                                                                   *)
(* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
(*             qu'une touche soit enfonce ce pour quitte.            *)
(*           þ Il est egalement important a noter que cette          *)
(*             procedure ne sauvegarde ni ne restitute environnement *)
(*             video.                                                *)
(*           þ Et pour finir il y a un petite detail insignifiant a  *)
(*             prendre en note, ce qu'il n'affiche nullement de      *)
(*             message d'enfoncer tel ou tel touche...               *)
(*                                                                   *)
(*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantBumper(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Bumper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantValence(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Valence',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Valence])+','+Strg(Cent[Valence])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Valence],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Valence],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantGrille(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Grille',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Grille])+','+Strg(Cent[Grille])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Grille],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Grille],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeaderPanel(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Header panel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeaderPannel])+','+Strg(Cent[HeaderPannel])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeaderPannel],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeaderPannel],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLampDor(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp dor',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLampDor])+','+Strg(Cent[HeadLampDor])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLampDor],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLampDor],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLamp(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLamp])+','+Strg(Cent[HeadLamp])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLamp],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLamp],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLampMotor(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp moteur',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLampMotor])+','+Strg(Cent[HeadLampMotor])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLampMotor],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLampMotor],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantParkLamp(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Parklamp',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[ParkLamp])+','+Strg(Cent[ParkLamp])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[ParkLamp],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[ParkLamp],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantCondenseurAir(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Condenseur d''air',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[CondenseurAir])+','+Strg(Cent[CondenseurAir])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[CondenseurAir],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[CondenseurAir],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantRadiateur(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;

           Choix : Array[0..1] of String[6] = ('Manuel','Auto. ');
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
       Ecrit(X+2,Y+4,'Type : '+Choix[Radiateur],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[Radiateur])+','+Strg(Cent[Radiateur])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[Radiateur],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[Radiateur],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFanRadiateur(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;

           Choix : Array[0..1] of String[10] = ('Electrique','Thermo.   ');
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
       Ecrit(X+2,Y+4,'Type : '+Choix[FanRadiateur],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[FanRadiateur])+','+Strg(Cent[FanRadiateur])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[FanRadiateur],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[FanRadiateur],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantAileGauche(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile gauche',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[AileGauche])+','+Strg(Cent[AileGauche])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[AileGauche],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[AileGauche],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantAileDroite(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[AileDroite])+','+Strg(Cent[AileDroite])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[AileDroite],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[AileDroite],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFrame(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[13])+','+Strg(Cent[13])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[13],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[13],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFrameRail(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;

           Choix : Array[0..3] of String[6] = ('Aucun ',
                                               'Droite',
                                               'Gauche',
                                               'Deux  ');
     Begin
      FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
      Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
      Ecrit(X+2,Y+4,Choix[Enregistrement.Devant.FrameRail],CoulDcr);
      With Enregistrement.Devant do
      Begin
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[14])+','+Strg(Cent[14])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[14],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[14],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantCapot(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Capot])+','+Strg(Cent[Capot])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Capot],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Capot],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlWindShield(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Wind shield',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[0])+','+Strg(DataCent[0])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[0],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[0],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlDash(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Dash',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[1])+','+Strg(DataCent[1])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[1],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[1],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlSpedometre(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Spedometre',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[2])+','+Strg(DataCent[2])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[2],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[2],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlRadio(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Radio',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[3])+','+Strg(DataCent[3])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[3],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[3],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlComboSwich(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 4;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Combo swich',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlIgnitionSwich(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 5;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Ignition swich',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlRadiateurChaufferette(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 6;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Radiateur chauffrette',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlMoteurChaufferette(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 7;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Moteur chauffrette',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlMoteurWhiper(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 8;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Moteur whiper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlWhiperTransmission(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 9;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Whiper transmission',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteAvantGauche(Enregistrement:EnregistrementType);
     Const Reg : Array[0..2] of String[10] = ('Non       ',
                                              'Electrique',
                                              'Manuel    ');
           X = 2;
           Y = 2;
           Pos = 0;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+12+Ass*2,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+9,'Vitre ventilation : '+Logique[VitreVent[Pos]],CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+10,TCChoix[TC[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Regulateur : '+Reg[Regulator and 1],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+10,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Ceinture porte : '+Logique[CeinPorte[Pos]],CoulDcr);
        Ecrit(X+2,Y+12,'Endommager : '+Endom[Pos],CoulDcr);
        Ecrit(X+2,Y+13,'Keyless Entry : '+Logique[KeyLess],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteAvantDroite(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 1;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+11+Ass*2,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+9,'Vitre ventilation : '+Logique[VitreVent[Pos]],CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+10,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+10,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Ceinture porte : '+Logique[CeinPorte[Pos]],CoulDcr);
        Ecrit(X+2,Y+12,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteArriereGauche(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 2;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+10+Ass,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+9,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+9,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+10,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteArriereDroite(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 3;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+10+Ass,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+9,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+9,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+10,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereComplet(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Derriere.DataDerriereComplete do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+7,CoulDcr);
       Ecrit(X+2,Y+2,'Devant complet :',CoulDcr);
       Ecrit(X+3,Y+4,'Prix : '+Strg(Prix)+','+Strg(Cent)+'$',CoulDcr);
       Ecrit(X+3,Y+5,'Localise : '+Copy(Localise,1,7),CoulDcr);
       Ecrit(X+3,Y+6,'Code hollander : '+Copy(Code,1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereToit(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
      Ecrit(X+2,Y+2,'Derriere, Toit',CoulDcr);
      Ecrit(X+2,Y+4,ChoixToit[Enregistrement.Derriere.TypeToit],CoulDcr);
      With Enregistrement.Derriere do
      Begin
       Ecrit(X+2,Y+5,'Prix : '+Strg(DataPrix[0])+','+Strg(DataCent[0])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(DataPos[0],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(DataCode[0],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereQuarterPannel(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Quarter pannel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[1])+','+Strg(DataCent[1])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[1],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[1],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereQuarterGlass(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 2;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Quarter glass',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBackGlass(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 3;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Back glass',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereValise(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 4;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Back glass',CoulDcr);
       Ecrit(X+2,Y+4,'Aileron : '+Logique[Aileron],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereHaillon(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 5;
     Var Chaine : String[15];
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Haillon',CoulDcr);
       Case TypeHaillon of
        1 : Chaine := 'Vitre chauffante';
        2 : Chaine := 'Whiper';
        3 : Chaine := 'Vitre chauffante & Whiper';
         else
        Chaine := 'Aucun';
       End;
       Ecrit(X+2,Y+2,Chaine,CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTankGaz(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 6;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tank a gaz',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereRearFinishPanel(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 7;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Rear finish panel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTailgate(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 8;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tailgate',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTaillite(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 9;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tail lite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBumper(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 10;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Bumper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Derriere, Boite a camion                              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBoiteCamion(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           Pos = 11;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Boite camion',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur complet                                        *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurComplet(Enregistrement:EnregistrementType);
     Const Car : Array[0..1] of String[6] = ('Gaz   ',
                                             'Diesel');

           X = 2;
           Y = 2;

     Var Chaine : String[15];
     Begin
      With Enregistrement.Moteur.MoteurComplet do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+15,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur assemblee',CoulDcr);
       Ecrit(X+2,Y+4,'Turbo : '+Logique[Turbo],CoulDcr);
       Ecrit(X+2,Y+5,'Carburant : '+Car[Carburant],CoulDcr);
       Case NombreCylindre of
        0 : Chaine := '3';
        1 : Chaine := '4';
        2 : Chaine := '5';
        3 : Chaine := '6L';
        4 : Chaine := 'V6';
        5 : Chaine := 'V8';
       End;
       Ecrit(X+2,Y+6,'Nombre cylindre : '+Chaine,CoulDcr);
       Case Mesure of
        0 : Chaine := 'CC';
        1 : Chaine := 'litre';
       End;
       Ecrit(X+2,Y+7,'Nombre de '+Chaine+' : '+
                     Strg(Nombre)+','+Strg(SousNombre),CoulDcr);
       Ecrit(X+2,Y+8,'Vales par cylindre : '+Strg(ValesParCylindre),CoulDcr);
       Case Categorie of
        0 : Chaine := 'Coil pack';
        1 : Chaine := 'Distributeur';
       End;
       Ecrit(X+2,Y+9,Chaine,CoulDcr);
       Ecrit(X+2,Y+10,'Milage : '+Strg(Milage),CoulDcr);
       Ecrit(X+2,Y+11,'Prix : '+Strg(Prix)+','+Strg(Cent),CoulDcr);
       Ecrit(X+2,Y+12,'Localisation : '+Localise,CoulDcr);
       Ecrit(X+2,Y+13,'Code hollander : '+Code,CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Cam shaft                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurCamShaft(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Cam Shaft',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Tete moteur                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurTeteMoteur(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 1;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Tete moteur',CoulDcr);
       Ecrit(x+2,Y+4,ChoixInjCar[MoteurTete],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Timing couer                                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurTimingCouer(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Timing Couer',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pane huile                                    *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPaneHuile(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 3;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pane huile',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Carburateur                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurCarburateur(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 4;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Carburateur',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Injection                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurInjection(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Injection',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pompe a gaz                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPompeGaz(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 6;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pompe a gaz',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pompe a eau                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPompeEau(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 7;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pompe a eau',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Manifault, Exhaust                            *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurManifaultExhaust(Enregistrement:EnregistrementType);
     Const X = 2;
           Y = 2;
           P = 8;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Manifault Exhaust',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Manifauld Intake                              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurManifaultIntake;
     Const X = 2;
           Y = 2;
           P = 9;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Manifault Intake',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Intercooler                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurIntercooler;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Intercooler',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Loc[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Oil cooler                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurOilCooler;
     Const X = 2;
           Y = 2;
           P = 1;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Oil cooler',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Loc[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Turbine                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurTurbine;
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Turbine',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Pompe a injection            *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurPompeInjection;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Pompe injection',CoulDcr);
       Case Pompe of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Module Electronique          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurModuleElectronique;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Module electronique',CoulDcr);
       Case Module of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Alternateur                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurAlternateur;
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+10,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Alternateur',CoulDcr);
       Ecrit(X+2,Y+4,'Amperage : '+Strg(Amperage),CoulDcr);
       Ecrit(X+2,Y+5,'# modele : '+Modele,CoulDcr);
       Ecrit(X+2,Y+6,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+8,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Starter                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurStarter;
     Const X = 2;
           Y = 2;
           P = 6;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Module electronique',CoulDcr);
       Case Starter of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Distributeur                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurDistributeur;
     Const X = 2;
           Y = 2;
           P = 7;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Distributeur',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Compresseur air conditionne  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurCompresseurAirConditionne;
     Const X = 2;
           Y = 2;
           P = 8;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Compr. air conditi.',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratacher au moteur, Bindes poulies              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurBindesPoulies;
     Const X = 2;
           Y = 2;
           P = 9;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Bindes Poulies',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission assemble                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionAssemble;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+13,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission assemble',CoulDcr);
       Case Automat of
        0 : Chaine := 'Automatique Normal';
        1 : Chaine := 'Automatique over drive';
        2 : Chaine := 'Manuel 3 vitesses';
        3 : Chaine := 'Manuel 4 vitesses';
        4 : Chaine := 'Manuel 5 vitesses';
        5 : Chaine := 'Manuel 6 vitesses';
         else
        Chaine := 'Aucun';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Case Traction of
        0 : Chaine := 'Traction avant';
        1 : Chaine := 'Propultion arriere';
       End;
       Ecrit(X+2,Y+5,Chaine,CoulDcr);
       Case XxX of
        0 : Chaine := '2x4';
        1 : Chaine := '4x4';
       End;
       Ecrit(X+2,Y+6,Chaine,CoulDcr);
       Case Turbo of
        0 : Chaine := 'Automatique';
        1 : Chaine := 'Turbo';
       End;
       Ecrit(X+2,Y+7,Chaine,CoulDcr);
       Ecrit(X+2,Y+8,Detail,CoulDcr);
       Ecrit(X+2,Y+9,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+10,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+11,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Pressure piate                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionPressurePiate;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Pressure piate',CoulDcr);
       If(Clush = 1)Then Ecrit(X+2,Y+4,'Clush',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Fly Wheel                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionFlyWheel;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String[15];
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Fly wheel',CoulDcr);
       Case FlyWheel of
        0 : Chaine := 'Automatique';
        1 : Chaine := 'Manuel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Transfer Case                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionTransferCase;
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Transfer case',CoulDcr);
       Ecrit(X+2,Y+4,Modele,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Rotor                                         *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsRotor;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Transfer case',CoulDcr);
       If(Rotor and 1 = 1)Then Chaine := 'Avant gauche';
       If(Rotor and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Rotor and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Rotor and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Galiper                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsGaliper;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Transfer case',CoulDcr);
       If(Galiper and 1 = 1)Then Chaine := 'Avant gauche';
       If(Galiper and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Galiper and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Galiper and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Rear Drum                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsRearDrum;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Rear drum',CoulDcr);
       If(RearDrm and 1 = 1)Then Chaine := 'Gauche';
       If(RearDrm and 2 = 2)Then IncStr(Chaine,' & Droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Master cylindre                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsMasterCylindre;
     Const X = 2;
           Y = 2;
           P = 3;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Master cylindre',CoulDcr);
       If(MasCyl = 1)Then Ecrit(X+2,Y+4,'Power Brake',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Booster                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsBooster;
     Const X = 2;
           Y = 2;
           P = 4;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Booster',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Antiskid                                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsAntiskid;
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Antiskid',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Spindel                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionSpindel;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Spindel',CoulDcr);
       If(Spindel and 1 = 1)Then Chaine := 'Avant gauche';
       If(Spindel and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Spindel and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Spindel and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Tab                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionTab;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Tab',CoulDcr);
       If(Tab and 1 = 1)Then Chaine := 'Haut gauche';
       If(Tab and 2 = 2)Then IncStr(Chaine,' & Haut droite');
       If(Tab and 4 = 4)Then IncStr(Chaine,' & Bas gauche');
       If(Tab and 8 = 8)Then IncStr(Chaine,' & Bas droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Strut                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionStrut;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Strut',CoulDcr);
       If(Strut and 1 = 1)Then Chaine := 'Avant gauche';
       If(Strut and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Strut and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Strut and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, IBeam                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionIBeam;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, IBeam',CoulDcr);
       If(IBeam and 1 = 1)Then Chaine := '2x4 Gauche';
       If(IBeam and 2 = 2)Then IncStr(Chaine,' & 2x4 droite');
       If(IBeam and 4 = 4)Then IncStr(Chaine,' & 4x4 gauche');
       If(IBeam and 8 = 8)Then IncStr(Chaine,' & 4x4 droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Bar tortion                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBarTortion;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Bar Tortion',CoulDcr);
       If(BarTortion and 1 = 1)Then Chaine := 'Gauche';
       If(BarTortion and 2 = 2)Then IncStr(Chaine,' & droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Bar stabilisation                         *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBarStabilisatrice;
     Const X = 2;
           Y = 2;
           P = 5;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Bar Stabilisatrice',CoulDcr);
       If(BarStabilisatrice and 1 = 1)Then Chaine := 'Avant';
       If(BarStabilisatrice and 2 = 2)Then IncStr(Chaine,' & Arriere');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Axle beam                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionAxleBeam;
     Const X = 2;
           Y = 2;
           P = 6;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Axle beam',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Rear stub                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionRearStub;
     Const X = 2;
           Y = 2;
           P = 7;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Rear stub',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Spring                                    *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionSpring;
     Const X = 2;
           Y = 2;
           P = 8;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Spring',CoulDcr);
       If(Spring and 1 = 1)Then Chaine := 'Avant';
       If(Spring and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Lames                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionLames;
     Const X = 2;
           Y = 2;
           P = 9;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Lames',CoulDcr);
       If(Lames and 1 = 1)Then Chaine := 'Avant';
       If(Lames and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Box stering                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBoxStering;
     Const X = 2;
           Y = 2;
           P = 10;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Stering',CoulDcr);
       Case Box of
        0 : Chaine := 'Manuel';
        1 : Chaine := 'Power';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Cremaillere                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionCremaillere;
     Const X = 2;
           Y = 2;
           P = 11;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Cremaillere',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Pompe a power stering                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionPompePowerStering;
     Const X = 2;
           Y = 2;
           P = 12;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Pompe a power stering',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Colonne stering                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionColoneStering;
     Const X = 2;
           Y = 2;
           P = 13;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+10,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Colone stering',CoulDcr);
       If(Cruise = 1)Then Ecrit(X+2,Y+4,'Cruise controle',CoulDcr);
       Ecrit(X+2,Y+5,Couleur,CoulDcr);
       Ecrit(X+2,Y+6,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+8,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Cardan                                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleCardan;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Cardan',CoulDcr);
       If(Cardan and 1 = 1)Then Chaine := 'Avant gauche';
       If(Cardan and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Cardan and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Cardan and 8 = 8)Then IncSTr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Essieu                                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleEssieu;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Essieu',CoulDcr);
       If(Essieu and 1 = 1)Then Chaine := 'Gauche';
       If(Essieu and 2 = 2)Then IncStr(Chaine,' & droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Diferentiel                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleDiferentiel;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Diferentiel',CoulDcr);
       If(Integral = 1)Then Ecrit(X+2,Y+4,'Integral',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Cochon de Diferentiel                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleCochonDiferentiel;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Cochon de diferentiel',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Drive shaft                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleDriveShaft;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Drive shaft',CoulDcr);
       If(DriveShaft and 1 = 1)Then Chaine := 'Avant';
       If(DriveShaft and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

(*************************************************************************)                                         {

{ Affichage de l'‚cran :
0         1         2         3         4         5         6         7
01234567890123456789012345678901234567890123456789012345678901234567890123456789
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºNum‚ro s‚rie        ³ModŠle              ³Body         ³Milage ³Date      º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ¶±±
±±ºxxxxxxxxxxxxxxxxxxxx³xxxxxxxxxxxxxxxxxxxx³xxxxxxxxxxxxx³xxxxxxx³JJ/MM/AAAAº±±
±±º.                   ³.                   ³.            ³.      ³.         º±±
±±º.                   ³.                   ³.            ³.      ³.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛF2 Date F3 Milage F4 Body F5 ModŠle F6 Num‚ro s‚rie F7 Info F10 AnnuleÛÛÛÛÛÛÛÛ
01234567890123456789012345678901234567890123456789012345678901234567890123456789
0         1         2         3         4         5         6         7 }
(*************************************************************************)

Procedure _LectureAuto;
Const Serie : Array[0..11] of Byte = (23,2,22,44,2,22,58,2,22,66,2,22);

       { Constante de tri local }

      TriDate        = 1;
      TriMilage      = 2;
      TriBody        = 3;
      TriModele      = 4;
      TriNumSerie    = 5;
      TriInfDate     = 6;
      TriInfMilage   = 7;
      TriInfBody     = 8;
      TriInfModele   = 9;
      TriInfNumSerie = 10;
      TriSupDate     = 11;
      TriSupMilage   = 12;
      TriSupBody     = 13;
      TriSupModele   = 14;
      TriSupNumSerie = 15;
      AncunTri       = 255;

Var Descr        : DescrType;
    Tri          : DescrType;
    TriPos       : Byte;
    Handle       : Integer;
    Touche       : Word;
    Compteur     : Byte;
    Taille       : LongInt;
    TailleTemp   : LongInt;
    Tableau      : Pointer;
    TabEcran     : Pointer;
    Position     : Word;
    YPos         : Byte;
    Sortie       : ShortInt;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure FixeBody(X,Y,Longeur:Byte;Var Body,Escape:Byte);
 Label 10;
 Const XH = 24;
       YH = 13;
 Var Key      : KeyQuestionType;
     Chaine   : String;
     Compteur : Byte;
 Begin
   { Initiation data }
  FillChar(Key,SizeOf(Key),0);
  Key[5].Alt   := 'FAMILLIALE';
  Key[5].Ctrl  := 'FAMILLIALE';
  Key[7].Alt   := 'HATCH BACK 5P';
  Key[1].Alt   := 'HATCH BACK 3P';
  Key[15].Alt  := 'PICKUP';
  Key[15].Ctrl := 'PICKUP';
  Key[18].Alt  := 'SEDAN 2P';
  Key[0].Alt   := 'SEDAN 4P';
  FixeFormatDouble;
  FixeCadrePlain(XH,YH,XH+31,YH+9,CoulHlp);
  Ecrit(XH+2,YH+1,'Aide : ',CoulHlp);
  EcritSpecial(XH+2,YH+3,#28+'Alt-F = Familliale'#1+
                         'Alt-H = Hatch Back 5 portes'#1+
                         'Alt-B = Hatch Back 3 portes'#1+
                         'Alt-P = Pickup'#1+
                         'Alt-S = Sedan 2 portes'#1+
                         'Alt-A = Sedan 4 portes');
  Chaine := '';
10:Question(X,Y,Chaine,Longeur,Key,False,Escape);
  FixeCurseurFermer;
  Chaine := Maj(Chaine);
  If(Escape <> 1)Then
  Begin
   If(Chaine = Key[5].Alt)Then Body := 1 else { Familiale }
   If(Chaine = Key[7].Alt)Then Body := 2 else { Hatch Back 5P }
   If(Chaine = Key[1].Alt)Then Body := 3 else { Hatch Back 3P }
   If(Chaine = Key[15].Alt)Then Body := 4 else { Pickup }
   If(Chaine = Key[18].Alt)Then Body := 5 else { Sedan 2P }
   If(Chaine = Key[0].Alt)Then Body := 6 { Sedan 4P }
    Else If(Escape = 0)Then Goto 10;
  End;
  Ecrit(X,Y,Chaine,7);
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure FixeMilage(X,Y:Byte;Var Milage:LongInt;Var Escape:Byte);
 Label 10;
 Var Key      : KeyQuestionType;
     Chaine   : String;
     Erreur   : Word;
     Compteur : Byte;
 Begin
   { Initiation data }
  FillChar(Key,SizeOf(Key),0);
  If(Milage > 0)Then Str(Milage,Chaine)
               Else Chaine := '';
10:Question(X,Y,Chaine,15,Key,False,Escape);
  FixeCurseurFermer;
  If(Escape = 0)Then
  Begin
   Val(Chaine,Milage,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Milage < 0)Then Goto 10;
  End
   else
  Begin
   Val(Chaine,Milage,Erreur);
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure FixeDate(X,Y:Byte;Var Jour,Mois,Annee,Escape:Byte);
 Label 10,20,30;
 Var Chaine : String;
     Erreur : Word;
     Temp   : Word;
 Begin
10:If(Jour > 0)Then Chaine := Strg(Jour)
                Else Chaine := '';
  FixeLocalise(X,Y,2,Chaine,Escape);
  If(Escape = 0)Then
  Begin
   Val(Chaine,Jour,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Jour > 31)or(Jour = 0)Then Goto 10;
20:If(Mois > 0)Then Chaine := Strg(Mois)
                Else Chaine := '';
   FixeLocalise(X+3,Y,2,Chaine,Escape);
   If(Escape = 0)Then
   Begin
    Val(Chaine,Mois,Erreur);
    If(Erreur <> 0)Then Goto 20;
    If(Mois > 12)or(Mois = 0)Then Goto 20;
30:If(Annee > 0)Then Chaine := Strg(Annee+1902)
                Else Chaine := '';
    FixeLocalise(X+6,Y,4,Chaine,Escape);
    If(Escape = 0)Then
    Begin
     Val(Chaine,Temp,Erreur);
     If(Erreur <> 0)Then Goto 30;
     If(Temp < 1902)or(Temp > 2158)Then Goto 30;
     Annee := Temp - 1902;
    End;
   End;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Function Body(Var Mode:Byte):ShortInt;
 Var Tableau : Pointer;
     Escape  : Byte;
 Begin
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(40-(24 div 2),8,40-(24 div 2)+24,10,$F0);
  Ecrit(40-(24 div 2)+1,9,'Body :',$F0);
  FixeBody(40-(24 div 2)+8,9,15,Mode,Escape);
  RestituteEcran(Tableau);
  If(Escape = 0)Then Body := 0
                Else Body := -1;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Function Milage(Var Mode:LongInt):ShortInt;
 Var Tableau : Pointer;
     Escape  : Byte;
 Begin
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(40-(18 div 2),12,40-(18 div 2)+18,14,$F0);
  Ecrit(40-(18 div 2)+1,13,'Milage :',$F0);
  FixeMilage(40-(18 div 2)+10,13,Mode,Escape);
  RestituteEcran(Tableau);
  If(Escape = 0)Then Milage := 0
                Else Milage := -1;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Function _Date(Var Jour,Mois,Annee:Byte):ShortInt;
 Var Tableau : Pointer;
     Escape  : Byte;
 Begin
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(((Colonne-18) div 2),12,((Colonne-18) div 2)+18,14,CoulDcr);
  Ecrit(((Colonne-18) div 2)+1,13,'Date : JJ/MM/AAAA',CoulDcr);
  FixeDate(((Colonne-18) div 2)+8,13,Jour,Mois,Annee,Escape);
  RestituteEcran(Tableau);
  If(Escape = 0)Then _Date := 0
                Else _Date := -1;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure Bar(YPos,Couleur:Byte);
 Begin
  BarSelecteHori(3,5+YPos,22,Couleur);
  BarSelecteHori(24,5+YPos,43,Couleur);
  BarSelecteHori(45,5+YPos,57,Couleur);
  BarSelecteHori(59,5+YPos,65,Couleur);
  BarSelecteHori(67,5+YPos,76,Couleur);
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure ReinitialiseListe;
 Var HandleTemporaire : Integer;
     OK               : Byte;
     ReelPosition     : LongInt;
     Compteur         : Word;
 Begin
  EffaceFenetre(3,5,22,21,7);
  EffaceFenetre(24,5,43,21,7);
  EffaceFenetre(45,5,57,21,7);
  EffaceFenetre(59,5,65,21,7);
  EffaceFenetre(67,5,76,21,7);
  EcritDerLigne('Lecture en cours...');
  Repeat
   Handle := Ouvre('FILES.DAT',0);
   If(Handle = -1)Then
   Begin
    EcritDerLigne('Erreur de lecture, presse une touche pour continuer ou <ESC> pour retourner');
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     RestitueDerniereLigne(Tableau);
     Exit;
    End;
   End;
  Until (Handle <> -1);
  Repeat
   Taille := TailleFichier(Handle) div SizeOf(Descr);
   If(Handle = -1)Then
   Begin
    EcritDerLigne('Erreur de lecture, presse une touche pour continuer ou <ESC> pour retourner');
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     RestitueDerniereLigne(Tableau);
     Exit;
    End;
   End;
  Until (Handle <> -1);
  ReelPosition := 0;
  TailleTemp   := 0;
  HandleTemporaire := Cree('FILES.TMP');
  For Compteur := 0 to Taille do
  Begin
   LitDescription(Handle,Compteur,Descr);
   OK := 0;
   Case TriPos of
       TriDate : If(Descr.Annee = Tri.Annee)and(Descr.Mois = Tri.Mois)and
                   (Descr.Jour = Tri.Jour)Then OK := 1;
     TriMilage : If(Tri.Milage = Descr.Milage)Then OK := 1;
       TriBody : If(Tri.Body = Descr.Body)Then OK := 1;
     TriModele : If(Tri.Modele = Descr.Modele)Then OK := 1;
   TriNumSerie : If(Tri.NumSerie = Descr.NumSerie)Then OK := 1;
    TriInfDate : If(Descr.Annee <= Tri.Annee)and
                   (Descr.Mois <= Tri.Mois)and
                   (Descr.Jour <= Tri.Jour)Then OK := 1;
  TriInfMilage : If(Tri.Milage <= Descr.Milage)Then OK := 1;
    TriInfBody : If(Tri.Body <= Descr.Body)Then OK := 1;
  TriInfModele : If(Tri.Modele <= Descr.Modele)Then OK := 1;
TriSupNumSerie : If(Tri.NumSerie <= Descr.NumSerie)Then OK := 1;
    TriSupDate : If(Descr.Annee >= Tri.Annee)and
                   (Descr.Mois >= Tri.Mois)and
                   (Descr.Jour >= Tri.Jour)Then OK := 1;
  TriSupMilage : If(Tri.Milage >= Descr.Milage)Then OK := 1;
    TriSupBody : If(Tri.Body >= Descr.Body)Then OK := 1;
  TriSupModele : If(Tri.Modele >= Descr.Modele)Then OK := 1;
TriSupNumSerie : If(Tri.NumSerie >= Descr.NumSerie)Then OK := 1;
      AncunTri : If(Descr.NumSerie <> '')and
                   (Descr.NumSerie[1] <> 'å')and
                   (Descr.NumSerie[1] <> '-')Then OK := 1;
   End;
   If(OK = 1)Then
   Begin
    ModifieEnregistrement(HandleTemporaire,ReelPosition,SizeOf(Descr),Descr);
    Inc(ReelPosition);
    Inc(TailleTemp);
   End;
  End;
  Ferme(Handle);
  Dec(TailleTemp);
  For Compteur := 0 to 16 do
  Begin
   If(TailleTemp >= Compteur)Then
   Begin
    With Descr do
    Begin
     LitDescription(HandleTemporaire,Compteur,Descr);
     AfficheString(3,5+Compteur,20,NumSerie);
     AfficheString(24,5+Compteur,20,Modele);
     Ecrit(45,5+Compteur,FormatBody(Body),7);
     Ecrit(59,5+Compteur,Strg(Milage),7);
     Ecrit(67,5+Compteur,Date(Jour,Mois,Annee),7);
    End;
   End;
  End;
  Ferme(HandleTemporaire);
  EcritSpecial(2,24,#3+Chr(CoulTch)+'F2'+#3+Chr(CoulBar)+' Date  '+#18+'F3'+
               #18+' Milage  '+#18+'F4'+#18+' Body  '+#18+'F5'+#18+' ModŠle '+
               #18+' F6 '+#18+'Num‚ro s‚rie '+#18+' F10'+#18+' Annule');
  Position := 0;
  YPos     := 0;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure AfficheLigne(Ligne:Byte;Direction:ShortInt;Descr:DescrType);
 Begin
  With Descr do
  Begin
   MouveFenetre(2,5,22,21,7,Direction);
   MouveFenetre(23,5,43,21,7,Direction);
   MouveFenetre(44,5,57,21,7,Direction);
   MouveFenetre(58,5,65,21,7,Direction);
   MouveFenetre(66,5,76,21,7,Direction);
   FixeUnCube(2,Ligne,186,15);
   FixeUnCube(23,Ligne,179,15);
   FixeUnCube(44,Ligne,179,15);
   FixeUnCube(58,Ligne,179,15);
   FixeUnCube(66,Ligne,179,15);
   FixeUnCube(77,Ligne,186,15);
   If(Length(NumSerie) > 0)Then Ecrit(3,Ligne,Copy(NumSerie,1,20),7);
   If(Length(Modele) > 0)Then Ecrit(24,Ligne,Copy(Modele,1,20),7);
   Ecrit(45,Ligne,FormatBody(Body),7);
   Ecrit(59,Ligne,Strg(Milage),7);
   Ecrit(67,Ligne,Date(Jour,Mois,Annee),7);
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure UpKey;
 Begin
  If(Position > 0)Then
  Begin
   Dec(Position);
   If(YPos = 0)Then
   Begin
    ReturnTempDescr(Position,Descr);
    AfficheLigne(5,-1,Descr);
   End
    else
   If(YPos > 0)Then Dec(YPos);
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure DownKey;
 Begin
  If(Position < TailleTemp)Then
  Begin
   Inc(Position);
   If(YPos = 16)Then
   Begin
    ReturnTempDescr(Position,Descr);
    AfficheLigne(21,1,Descr);
   End
    else
   If(YPos < 16)Then Inc(YPos);
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _Date_(TriDate:Byte);
 Begin
  Sortie := _Date(Tri.Jour,Tri.Mois,Tri.Annee);
  If(Sortie = 0)Then
  Begin
   TriPos := TriDate;
   ReinitialiseListe;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _Milage_(TriMilage:Byte);
 Begin
  Sortie := Milage(Tri.Milage);
  If(Sortie = 0)Then
  Begin
   TriPos := TriMilage;
   ReinitialiseListe;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _Body_(TriBody:Byte);
 Begin
  Sortie := Body(Tri.Body);
  If(Sortie = 0)Then
  Begin
   TriPos := TriBody;
   ReinitialiseListe;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _Modele_(TriModele:Byte);
 Begin
  Sortie := Modele(Tri.Modele);
  If(Sortie = 0)Then
  Begin
   TriPos := TriModele;
   ReinitialiseListe;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _NumeroSerie_(TriNumSerie:Byte);
 Begin
  Sortie := NumeroSerie(Tri.NumSerie,CoulDcr);
  If(Sortie = 0)Then
  Begin
   TriPos := TriNumSerie;
   ReinitialiseListe;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _AucunTri_;
 Begin
  FillChar(Tri,SizeOf(Tri),0);
  TriPos := AncunTri;
  ReinitialiseListe;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure LectureEnr;
 Const Complet  = 254;
       Assemble = Complet;
 Var PosCategorie   : Byte;
     PosPiece       : Byte;
     Enregistrement : EnregistrementType;
     Numero         : StrNumSerie;
     Reponse        : Byte;
     Pos            : LongInt;
     Handle         : Integer;
     Tableau        : Pointer;
     Touche         : Word;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantComplet;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant.AvantComplet do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+7,CoulDcr);
       Ecrit(X+2,Y+2,'Devant complet :',CoulDcr);
       Ecrit(X+3,Y+4,'Prix : '+Strg(Prix)+','+Strg(Cent)+'$',CoulDcr);
       Ecrit(X+3,Y+5,'Localise : '+Copy(Localise,1,7),CoulDcr);
       Ecrit(X+3,Y+6,'Code hollander : '+Copy(Code,1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantBumper;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Bumper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantValence;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Valence',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Valence])+','+Strg(Cent[Valence])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Valence],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Valence],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantGrille;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Grille',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Grille])+','+Strg(Cent[Grille])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Grille],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Grille],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeaderPanel;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Header panel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeaderPannel])+','+Strg(Cent[HeaderPannel])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeaderPannel],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeaderPannel],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLampDor;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp dor',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLampDor])+','+Strg(Cent[HeadLampDor])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLampDor],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLampDor],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLamp;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLamp])+','+Strg(Cent[HeadLamp])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLamp],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLamp],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantHeadLampMotor;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Headlamp moteur',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[HeadLampMotor])+','+Strg(Cent[HeadLampMotor])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[HeadLampMotor],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[HeadLampMotor],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantParkLamp;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Parklamp',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[ParkLamp])+','+Strg(Cent[ParkLamp])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[ParkLamp],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[ParkLamp],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantCondenseurAir;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Condenseur d''air',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[CondenseurAir])+','+Strg(Cent[CondenseurAir])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[CondenseurAir],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[CondenseurAir],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantRadiateur;
     Const X = 2;
           Y = 2;

           Choix : Array[0..1] of String[6] = ('Manuel','Auto. ');
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
       Ecrit(X+2,Y+4,'Type : '+Choix[Radiateur],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[Radiateur])+','+Strg(Cent[Radiateur])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[Radiateur],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[Radiateur],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFanRadiateur;
     Const X = 2;
           Y = 2;

           Choix : Array[0..1] of String[10] = ('Electrique','Thermo.   ');
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
       Ecrit(X+2,Y+4,'Type : '+Choix[FanRadiateur],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[FanRadiateur])+','+Strg(Cent[FanRadiateur])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[FanRadiateur],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[FanRadiateur],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantAileGauche;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile gauche',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[AileGauche])+','+Strg(Cent[AileGauche])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[AileGauche],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[AileGauche],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantAileDroite;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[AileDroite])+','+Strg(Cent[AileDroite])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[AileDroite],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[AileDroite],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFrame;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[13])+','+Strg(Cent[13])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[13],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[13],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantFrameRail;
     Const X = 2;
           Y = 2;

           Choix : Array[0..3] of String[6] = ('Aucun ',
                                               'Droite',
                                               'Gauche',
                                               'Deux  ');
     Begin
      FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
      Ecrit(X+2,Y+2,'Devant, Radiateur',CoulDcr);
      Ecrit(X+2,Y+4,Choix[Enregistrement.Devant.FrameRail],CoulDcr);
      With Enregistrement.Devant do
      Begin
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[14])+','+Strg(Cent[14])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[14],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[14],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DevantCapot;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Devant do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Devant, Aile droite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[Capot])+','+Strg(Cent[Capot])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[Capot],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[Capot],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlWindShield;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Wind shield',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[0])+','+Strg(DataCent[0])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[0],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[0],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlDash;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Dash',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[1])+','+Strg(DataCent[1])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[1],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[1],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlSpedometre;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Spedometre',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[2])+','+Strg(DataCent[2])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[2],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[2],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlRadio;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Radio',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[3])+','+Strg(DataCent[3])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[3],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[3],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlComboSwich;
     Const X = 2;
           Y = 2;
           Pos = 4;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Combo swich',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlIgnitionSwich;
     Const X = 2;
           Y = 2;
           Pos = 5;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Ignition swich',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlRadiateurChaufferette;
     Const X = 2;
           Y = 2;
           Pos = 6;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Radiateur chauffrette',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlMoteurChaufferette;
     Const X = 2;
           Y = 2;
           Pos = 7;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Moteur chauffrette',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlMoteurWhiper;
     Const X = 2;
           Y = 2;
           Pos = 8;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Moteur whiper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure CowlWhiperTransmission;
     Const X = 2;
           Y = 2;
           Pos = 9;
     Begin
      With Enregistrement.Cowl do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Cowl, Whiper transmission',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteAvantGauche;
     Const Reg : Array[0..2] of String[10] = ('Non       ',
                                              'Electrique',
                                              'Manuel    ');
           X = 2;
           Y = 2;
           Pos = 0;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+12+Ass*2,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+9,'Vitre ventilation : '+Logique[VitreVent[Pos]],CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+10,TCChoix[TC[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Regulateur : '+Reg[Regulator and 1],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+10,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Ceinture porte : '+Logique[CeinPorte[Pos]],CoulDcr);
        Ecrit(X+2,Y+12,'Endommager : '+Endom[Pos],CoulDcr);
        Ecrit(X+2,Y+13,'Keyless Entry : '+Logique[KeyLess],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteAvantDroite;
     Const X = 2;
           Y = 2;
           Pos = 1;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+11+Ass*2,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+9,'Vitre ventilation : '+Logique[VitreVent[Pos]],CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+10,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+10,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+11,'Ceinture porte : '+Logique[CeinPorte[Pos]],CoulDcr);
        Ecrit(X+2,Y+12,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteArriereGauche;
     Const X = 2;
           Y = 2;
           Pos = 2;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+10+Ass,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+9,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+9,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+10,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PorteArriereDroite;
     Const X = 2;
           Y = 2;
           Pos = 3;
     Begin
      With Enregistrement.Porte do
      Begin
       Ass    := Ass and 1;
       Poteau := Poteau and 1;
       FixeCadrePlain(X,Y,X+59,Y+10+Ass,CoulDcr);
       Ecrit(X+2,Y+2,'Porte, Avant gauche',CoulDcr);
       Ecrit(X+2,Y+5,'Poteau : '+Logique[Poteau],CoulDcr);
       Ecrit(X+2,Y+4,Assem[Ass],CoulDcr);
       Ecrit(X+2,Y+6,'Prix : '+Strg(Prx[Pos])+','+Strg(Cnt[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+7,'Localise : '+Copy(Loc[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+8,'Code hollander : '+Copy(Code[Pos],1,7),CoulDcr);
       If(Ass = 0)Then
       Begin
        Ecrit(X+2,Y+9,TCChoix[TC[Pos]],CoulDcr);
       End
        else
       Begin
        Ecrit(X+2,Y+9,'Type : '+TypePorte[TypeP[Pos]],CoulDcr);
        Ecrit(X+2,Y+10,'Endommager : '+Endom[Pos],CoulDcr);
       End;
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereComplet;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Derriere.DataDerriereComplete do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+7,CoulDcr);
       Ecrit(X+2,Y+2,'Devant complet :',CoulDcr);
       Ecrit(X+3,Y+4,'Prix : '+Strg(Prix)+','+Strg(Cent)+'$',CoulDcr);
       Ecrit(X+3,Y+5,'Localise : '+Copy(Localise,1,7),CoulDcr);
       Ecrit(X+3,Y+6,'Code hollander : '+Copy(Code,1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereToit;
     Const X = 2;
           Y = 2;
     Begin
      FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
      Ecrit(X+2,Y+2,'Derriere, Toit',CoulDcr);
      Ecrit(X+2,Y+4,ChoixToit[Enregistrement.Derriere.TypeToit],CoulDcr);
      With Enregistrement.Derriere do
      Begin
       Ecrit(X+2,Y+5,'Prix : '+Strg(DataPrix[0])+','+Strg(DataCent[0])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(DataPos[0],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(DataCode[0],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereQuarterPannel;
     Const X = 2;
           Y = 2;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Quarter pannel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[1])+','+Strg(DataCent[1])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[1],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[1],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereQuarterGlass;
     Const X = 2;
           Y = 2;
           Pos = 2;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Quarter glass',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBackGlass;
     Const X = 2;
           Y = 2;
           Pos = 3;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Back glass',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereValise;
     Const X = 2;
           Y = 2;
           Pos = 4;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Back glass',CoulDcr);
       Ecrit(X+2,Y+4,'Aileron : '+Logique[Aileron],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereHaillon;
     Const X = 2;
           Y = 2;
           Pos = 5;
     Var Chaine : String[15];
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Haillon',CoulDcr);
       Case TypeHaillon of
        1 : Chaine := 'Vitre chauffante';
        2 : Chaine := 'Whiper';
        3 : Chaine := 'Vitre chauffante & Whiper';
         else
        Chaine := 'Aucun';
       End;
       Ecrit(X+2,Y+2,Chaine,CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTankGaz;
     Const X = 2;
           Y = 2;
           Pos = 6;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tank a gaz',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereRearFinishPanel;
     Const X = 2;
           Y = 2;
           Pos = 7;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Rear finish panel',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTailgate;
     Const X = 2;
           Y = 2;
           Pos = 8;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tailgate',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereTaillite;
     Const X = 2;
           Y = 2;
           Pos = 9;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Tail lite',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ                                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBumper;
     Const X = 2;
           Y = 2;
           Pos = 10;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Bumper',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Derriere, Boite a camion                              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure DerriereBoiteCamion;
     Const X = 2;
           Y = 2;
           Pos = 11;
     Begin
      With Enregistrement.Derriere do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Derriere, Boite camion',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(DataPrix[Pos])+','+Strg(DataCent[Pos])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(DataPos[Pos],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(DataCode[Pos],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur complet                                        *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurComplet;
     Const Car : Array[0..1] of String[6] = ('Gaz   ',
                                             'Diesel');

           X = 2;
           Y = 2;

     Var Chaine : String[15];
     Begin
      With Enregistrement.Moteur.MoteurComplet do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+15,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur assemblee',CoulDcr);
       Ecrit(X+2,Y+4,'Turbo : '+Logique[Turbo],CoulDcr);
       Ecrit(X+2,Y+5,'Carburant : '+Car[Carburant],CoulDcr);
       Case NombreCylindre of
        0 : Chaine := '3';
        1 : Chaine := '4';
        2 : Chaine := '5';
        3 : Chaine := '6L';
        4 : Chaine := 'V6';
        5 : Chaine := 'V8';
       End;
       Ecrit(X+2,Y+6,'Nombre cylindre : '+Chaine,CoulDcr);
       Case Mesure of
        0 : Chaine := 'CC';
        1 : Chaine := 'litre';
       End;
       Ecrit(X+2,Y+7,'Nombre de '+Chaine+' : '+
                     Strg(Nombre)+','+Strg(SousNombre),CoulDcr);
       Ecrit(X+2,Y+8,'Vales par cylindre : '+Strg(ValesParCylindre),CoulDcr);
       Case Categorie of
        0 : Chaine := 'Coil pack';
        1 : Chaine := 'Distributeur';
       End;
       Ecrit(X+2,Y+9,Chaine,CoulDcr);
       Ecrit(X+2,Y+10,'Milage : '+Strg(Milage),CoulDcr);
       Ecrit(X+2,Y+11,'Prix : '+Strg(Prix)+','+Strg(Cent),CoulDcr);
       Ecrit(X+2,Y+12,'Localisation : '+Localise,CoulDcr);
       Ecrit(X+2,Y+13,'Code hollander : '+Code,CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Cam shaft                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurCamShaft;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Cam Shaft',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Tete moteur                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurTeteMoteur;
     Const X = 2;
           Y = 2;
           P = 1;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Tete moteur',CoulDcr);
       Ecrit(x+2,Y+4,ChoixInjCar[MoteurTete],CoulDcr);
       Ecrit(X+2,Y+5,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+6,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+7,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Timing couer                                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurTimingCouer;
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Timing Couer',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pane huile                                    *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPaneHuile;
     Const X = 2;
           Y = 2;
           P = 3;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pane huile',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Carburateur                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurCarburateur;
     Const X = 2;
           Y = 2;
           P = 4;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Carburateur',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Injection                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurInjection;
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Injection',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pompe a gaz                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPompeGaz;
     Const X = 2;
           Y = 2;
           P = 6;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pompe a gaz',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Pompe a eau                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurPompeEau;
     Const X = 2;
           Y = 2;
           P = 7;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Pompe a eau',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Manifault, Exhaust                            *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurManifaultExhaust;
     Const X = 2;
           Y = 2;
           P = 8;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Manifault Exhaust',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Moteur, Manifauld Intake                              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure MoteurManifaultIntake;
     Const X = 2;
           Y = 2;
           P = 9;
     Begin
      With Enregistrement.Moteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Moteur, Manifault Intake',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Pos[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Intercooler                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurIntercooler;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Intercooler',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Loc[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Oil cooler                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurOilCooler;
     Const X = 2;
           Y = 2;
           P = 1;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Oil cooler',CoulDcr);
       Ecrit(X+2,Y+4,'Prix : '+Strg(Prix[P])+','+Strg(Cent[P])+'$',CoulDcr);
       Ecrit(X+2,Y+5,'Localise : '+Copy(Loc[P],1,7),CoulDcr);
       Ecrit(X+2,Y+6,'Code hollander : '+Copy(Code[P],1,7),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Turbine                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurTurbine;
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Turbine',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Pompe a injection            *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurPompeInjection;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Pompe injection',CoulDcr);
       Case Pompe of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Module Electronique          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurModuleElectronique;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Module electronique',CoulDcr);
       Case Module of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Alternateur                  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurAlternateur;
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+10,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Alternateur',CoulDcr);
       Ecrit(X+2,Y+4,'Amperage : '+Strg(Amperage),CoulDcr);
       Ecrit(X+2,Y+5,'# modele : '+Modele,CoulDcr);
       Ecrit(X+2,Y+6,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+8,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Starter                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurStarter;
     Const X = 2;
           Y = 2;
           P = 6;
     Var Chaine : String[10];
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Module electronique',CoulDcr);
       Case Starter of
        0 : Chaine := 'Gaz';
        1 : Chaine := 'Diesel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Distributeur                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurDistributeur;
     Const X = 2;
           Y = 2;
           P = 7;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Distributeur',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratache au moteur, Compresseur air conditionne  *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurCompresseurAirConditionne;
     Const X = 2;
           Y = 2;
           P = 8;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Compr. air conditi.',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Piece ratacher au moteur, Bindes poulies              *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceMoteurBindesPoulies;
     Const X = 2;
           Y = 2;
           P = 9;
     Begin
      With Enregistrement.PieceMoteur do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Piece ratache au moteur, Bindes Poulies',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission assemble                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionAssemble;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+13,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission assemble',CoulDcr);
       Case Automat of
        0 : Chaine := 'Automatique Normal';
        1 : Chaine := 'Automatique over drive';
        2 : Chaine := 'Manuel 3 vitesses';
        3 : Chaine := 'Manuel 4 vitesses';
        4 : Chaine := 'Manuel 5 vitesses';
        5 : Chaine := 'Manuel 6 vitesses';
         else
        Chaine := 'Aucun';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Case Traction of
        0 : Chaine := 'Traction avant';
        1 : Chaine := 'Propultion arriere';
       End;
       Ecrit(X+2,Y+5,Chaine,CoulDcr);
       Case XxX of
        0 : Chaine := '2x4';
        1 : Chaine := '4x4';
       End;
       Ecrit(X+2,Y+6,Chaine,CoulDcr);
       Case Turbo of
        0 : Chaine := 'Automatique';
        1 : Chaine := 'Turbo';
       End;
       Ecrit(X+2,Y+7,Chaine,CoulDcr);
       Ecrit(X+2,Y+8,Detail,CoulDcr);
       Ecrit(X+2,Y+9,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+10,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+11,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Pressure piate                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionPressurePiate;
     Const X = 2;
           Y = 2;
           P = 0;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Pressure piate',CoulDcr);
       If(Clush = 1)Then Ecrit(X+2,Y+4,'Clush',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Fly Wheel                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionFlyWheel;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String[15];
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Fly wheel',CoulDcr);
       Case FlyWheel of
        0 : Chaine := 'Automatique';
        1 : Chaine := 'Manuel';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Transmission, Transfer Case                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure TransmissionTransferCase;
     Const X = 2;
           Y = 2;
           P = 2;
     Begin
      With Enregistrement.Trans do
      Begin
       FixeCadrePlain(X,Y,X+39,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Transmission, Transfer case',CoulDcr);
       Ecrit(X+2,Y+4,Modele,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Rotor                                         *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsRotor;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Transfer case',CoulDcr);
       If(Rotor and 1 = 1)Then Chaine := 'Avant gauche';
       If(Rotor and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Rotor and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Rotor and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Galiper                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsGaliper;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Transfer case',CoulDcr);
       If(Galiper and 1 = 1)Then Chaine := 'Avant gauche';
       If(Galiper and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Galiper and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Galiper and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Rear Drum                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsRearDrum;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Rear drum',CoulDcr);
       If(RearDrm and 1 = 1)Then Chaine := 'Gauche';
       If(RearDrm and 2 = 2)Then IncStr(Chaine,' & Droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Master cylindre                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsMasterCylindre;
     Const X = 2;
           Y = 2;
           P = 3;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Master cylindre',CoulDcr);
       If(MasCyl = 1)Then Ecrit(X+2,Y+4,'Power Brake',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Booster                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsBooster;
     Const X = 2;
           Y = 2;
           P = 4;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Booster',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Freins, Antiskid                                      *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure FreinsAntiskid;
     Const X = 2;
           Y = 2;
           P = 5;
     Begin
      With Enregistrement.Frein do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Freins, Antiskid',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Spindel                                   *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionSpindel;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Spindel',CoulDcr);
       If(Spindel and 1 = 1)Then Chaine := 'Avant gauche';
       If(Spindel and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Spindel and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Spindel and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Tab                                       *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionTab;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Tab',CoulDcr);
       If(Tab and 1 = 1)Then Chaine := 'Haut gauche';
       If(Tab and 2 = 2)Then IncStr(Chaine,' & Haut droite');
       If(Tab and 4 = 4)Then IncStr(Chaine,' & Bas gauche');
       If(Tab and 8 = 8)Then IncStr(Chaine,' & Bas droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Strut                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionStrut;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Strut',CoulDcr);
       If(Strut and 1 = 1)Then Chaine := 'Avant gauche';
       If(Strut and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Strut and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Strut and 8 = 8)Then IncStr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, IBeam                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionIBeam;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, IBeam',CoulDcr);
       If(IBeam and 1 = 1)Then Chaine := '2x4 Gauche';
       If(IBeam and 2 = 2)Then IncStr(Chaine,' & 2x4 droite');
       If(IBeam and 4 = 4)Then IncStr(Chaine,' & 4x4 gauche');
       If(IBeam and 8 = 8)Then IncStr(Chaine,' & 4x4 droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Bar tortion                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBarTortion;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Bar Tortion',CoulDcr);
       If(BarTortion and 1 = 1)Then Chaine := 'Gauche';
       If(BarTortion and 2 = 2)Then IncStr(Chaine,' & droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Bar stabilisation                         *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBarStabilisatrice;
     Const X = 2;
           Y = 2;
           P = 5;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Bar Stabilisatrice',CoulDcr);
       If(BarStabilisatrice and 1 = 1)Then Chaine := 'Avant';
       If(BarStabilisatrice and 2 = 2)Then IncStr(Chaine,' & Arriere');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Axle beam                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionAxleBeam;
     Const X = 2;
           Y = 2;
           P = 6;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Axle beam',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Rear stub                                 *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionRearStub;
     Const X = 2;
           Y = 2;
           P = 7;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Rear stub',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Spring                                    *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionSpring;
     Const X = 2;
           Y = 2;
           P = 8;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Spring',CoulDcr);
       If(Spring and 1 = 1)Then Chaine := 'Avant';
       If(Spring and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Lames                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionLames;
     Const X = 2;
           Y = 2;
           P = 9;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Lames',CoulDcr);
       If(Lames and 1 = 1)Then Chaine := 'Avant';
       If(Lames and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Box stering                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionBoxStering;
     Const X = 2;
           Y = 2;
           P = 10;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Stering',CoulDcr);
       Case Box of
        0 : Chaine := 'Manuel';
        1 : Chaine := 'Power';
       End;
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Cremaillere                               *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionCremaillere;
     Const X = 2;
           Y = 2;
           P = 11;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Cremaillere',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Pompe a power stering                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionPompePowerStering;
     Const X = 2;
           Y = 2;
           P = 12;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Pompe a power stering',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Suspension, Colonne stering                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure SuspensionColoneStering;
     Const X = 2;
           Y = 2;
           P = 13;
     Var Chaine : String;
     Begin
      With Enregistrement.Suspension do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+10,CoulDcr);
       Ecrit(X+2,Y+2,'Suspension, Colone stering',CoulDcr);
       If(Cruise = 1)Then Ecrit(X+2,Y+4,'Cruise controle',CoulDcr);
       Ecrit(X+2,Y+5,Couleur,CoulDcr);
       Ecrit(X+2,Y+6,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+8,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Cardan                                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleCardan;
     Const X = 2;
           Y = 2;
           P = 0;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Cardan',CoulDcr);
       If(Cardan and 1 = 1)Then Chaine := 'Avant gauche';
       If(Cardan and 2 = 2)Then IncStr(Chaine,' & Avant droite');
       If(Cardan and 4 = 4)Then IncStr(Chaine,' & Arriere gauche');
       If(Cardan and 8 = 8)Then IncSTr(Chaine,' & Arriere droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Essieu                                          *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleEssieu;
     Const X = 2;
           Y = 2;
           P = 1;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Essieu',CoulDcr);
       If(Essieu and 1 = 1)Then Chaine := 'Gauche';
       If(Essieu and 2 = 2)Then IncStr(Chaine,' & droite');
       Ecrit(X+2,Y+4,Chaine,CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Diferentiel                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleDiferentiel;
     Const X = 2;
           Y = 2;
           P = 2;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+9,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Diferentiel',CoulDcr);
       If(Integral = 1)Then Ecrit(X+2,Y+4,'Integral',CoulDcr);
       Ecrit(X+2,Y+5,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+7,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Cochon de Diferentiel                           *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleCochonDiferentiel;
     Const X = 2;
           Y = 2;
           P = 3;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Cochon de diferentiel',CoulDcr);
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Axle, Drive shaft                                     *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure AxleDriveShaft;
     Const X = 2;
           Y = 2;
           P = 4;
     Var Chaine : String;
     Begin
      With Enregistrement.Axle do
      Begin
       FixeCadrePlain(X,Y,X+50,Y+8,CoulDcr);
       Ecrit(X+2,Y+2,'Axle, Drive shaft',CoulDcr);
       If(DriveShaft and 1 = 1)Then Chaine := 'Avant';
       If(DriveShaft and 2 = 2)Then Chaine := 'Arriere';
       Ecrit(X+2,Y+4,StrPrix(Prix[P],Cent[P]),CoulDcr);
       Ecrit(X+2,Y+5,StrLocalise(Loc[P]),CoulDcr);
       Ecrit(X+2,Y+6,StrCode(Code[P]),CoulDcr);
      End;
     End;

     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
     (*                                                                   *)
     (* Affiche : þ Un message d'abence de la piece demander.             *)
     (*                                                                   *)
     (* Notes   : þ Cette procedure ne fait ni de pause ou n'attend nulle *)
     (*             qu'une touche soit enfonce ce pour quitte.            *)
     (*           þ Il est egalement important a noter que cette          *)
     (*             procedure ne sauvegarde ni ne restitute environnement *)
     (*             video.                                                *)
     (*           þ Et pour finir il y a un petite detail insignifiant a  *)
     (*             prendre en note, ce qu'il n'affiche nullement de      *)
     (*             message d'enfoncer tel ou tel touche...               *)
     (*                                                                   *)
     (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

     Procedure PieceAbsent;
     Const X = 20;
           Y = 10;
     Begin
      FixeCadrePlain(X,Y,X+40,Y+4,CoulErr);
      Ecrit(X+2,Y+2,'Erreur : Piece absent',CoulErr);
     End;

 Begin { Main Lecture Auto }
  ReturnTempDescr(Position,Descr);
  Pos := RechercheDescription(Descr,1);
  ReturnEnregistrement(Pos,Enregistrement);
  SauvegardeEcran(Tableau);
  FixeFormatSimple;
  PosCategorie := SelectePiece;
  If(PosCategorie = 255)Then
  Begin
   RestituteEcran(Tableau);
   Exit;
  End;
  PosPiece := ChoisiePiece(1,2,PosCategorie,Enregistrement);
  If(PosPiece = 255)Then
  Begin
   RestituteEcran(Tableau);
   Exit;
  End;
   { Affiche individuel de la piece }
  Case PosCategorie of
   0 : Begin
    {    If(Enregistrement.Devant.Actif[PosPiece] = 0)and(PosPiece < 16)Then PieceAbsent
         else}
        Case PosPiece of
         000 : DevantBumper;
         001 : DevantValence;
         002 : DevantGrille;
         003 : DevantHeaderPanel;
         004 : DevantHeadLampDor;
         005 : DevantHeadLamp;
         006 : DevantHeadLampMotor;
         007 : DevantParkLamp;
         008 : DevantCondenseurAir;
         009 : DevantRadiateur;
         010 : DevantFanRadiateur;
         011 : DevantAileGauche;
         012 : DevantAileDroite;
         013 : DevantFrame;
         014 : DevantFrameRail;
         015 : DevantCapot;
         254 : DevantComplet;
        End;
       End;
   1 : Begin
        If(Enregistrement.Cowl.DataActif[PosPiece] <> 1)Then PieceAbsent
         else
        Case PosPiece of
         000 : CowlWindShield;
         001 : CowlDash;
         002 : CowlSpedometre;
         003 : CowlRadio;
         004 : CowlComboSwich;
         005 : CowlIgnitionSwich;
         006 : CowlRadiateurChaufferette;
         007 : CowlMoteurChaufferette;
         008 : CowlMoteurWhiper;
         009 : CowlWhiperTransmission;
        End;
       End;
   2 : Case PosPiece and 3 of
        000 : PorteAvantGauche;
        001 : PorteAvantDroite;
        002 : PorteArriereGauche;
        003 : PorteArriereDroite;
       End;
   3 : Case PosPiece of
        000 : DerriereToit;
        001 : DerriereQuarterPannel;
        002 : DerriereQuarterGlass;
        003 : DerriereBackGlass;
        004 : DerriereValise;
        005 : DerriereHaillon;
        006 : DerriereTankGaz;
        007 : DerriereRearFinishPanel;
        008 : DerriereTailGate;
        009 : DerriereTailLite;
        010 : DerriereBumper;
        011 : DerriereBoiteCamion;
        254 : DerriereComplet;
       End;
   4 : Case PosPiece of
        000 : MoteurCamShaft;
        001 : MoteurTeteMoteur;
        002 : MoteurTimingCouer;
        003 : MoteurPaneHuile;
        004 : MoteurCarburateur;
        005 : MoteurInjection;
        006 : MoteurPompeGaz;
        007 : MoteurPompeEau;
        008 : MoteurManifaultExhaust;
        009 : MoteurManifaultIntake;
        254 : MoteurComplet;
       End;
   5 : Case PosPiece of
        000 : PieceMoteurIntercooler;
        001 : PieceMoteurOilCooler;
        002 : PieceMoteurTurbine;
        003 : PieceMoteurPompeInjection;
        004 : PieceMoteurModuleElectronique;
        005 : PieceMoteurAlternateur;
        006 : PieceMoteurStarter;
        007 : PieceMoteurDistributeur;
        008 : PieceMoteurCompresseurAirConditionne;
        009 : PieceMoteurBindesPoulies;
       End;
   6 : Case PosPiece of
        000 : TransmissionPressurePiate;
        001 : TransmissionFlyWheel;
        002 : TransmissionTransferCase;
        254 : TransmissionAssemble;
       End;
   7 : Case PosPiece of
        000 : FreinsRotor;
        001 : FreinsGaliper;
        002 : FreinsRearDrum;
        003 : FreinsMasterCylindre;
        004 : FreinsBooster;
        005 : FreinsAntiskid;
       End;
   8 : Case PosPiece of
        000 : SuspensionSpindel;
        001 : SuspensionTab;
        002 : SuspensionStrut;
        003 : SuspensionIBeam;
        004 : SuspensionBarTortion;
        005 : SuspensionBarStabilisatrice;
        006 : SuspensionAxleBeam;
        007 : SuspensionRearStub;
        008 : SuspensionSpring;
        009 : SuspensionLames;
        010 : SuspensionBoxStering;
        011 : SuspensionCremaillere;
        012 : SuspensionPompePowerStering;
        013 : SuspensionColoneStering;
       End;
   9 : Case PosPiece of
        000 : AxleCardan;
        001 : AxleEssieu;
        002 : AxleDiferentiel;
        003 : AxleCochonDiferentiel;
        004 : AxleDriveShaft;
       End;
  End;
  EcritDerLigne('Presse une touche pour retourner...');
  Touche := LitClavier;
  RestituteEcran(Tableau);
 End;

Begin
 FillChar(Tri,SizeOf(Tri),0);
 TriPos := 255;
 Begin
  FixeFormatDouble;
  FixeCurseurFermer;
  FixeCadrePlain(2,2,77,22,15);
  Ecrit(3,3,'Num‚ro s‚rie',14);
  Ecrit(24,3,'ModŠle',14);
  Ecrit(45,3,'Body',14);
  Ecrit(59,3,'Milage  Date',14);
  BarTableHori(2,4,77,15);
  BarSerieVert(4,Serie,15);
  SauveDerniereLigne(Tableau);
  ReinitialiseListe;
  Repeat
   Bar(YPos,$F0);
   Touche := LitClavier;
   Bar(YPos,7);
   Case Touche of
    kbUp : UpKey;
  kbDown : DownKey;
    kbF2 : _Date_(TriDate);
    kbF3 : _Milage_(TriMilage);
    kbF4 : _Body_(TriBody);
    kbF5 : _Modele_(TriModele);
    kbF6 : _NumeroSerie_(TriNumSerie);
 kbEnter : LectureEnr;
   kbF10 : _AucunTri_;
kbCtrlF2 : _Date_(TriInfDate);
kbCtrlF3 : _Milage_(TriInfMilage);
kbCtrlF4 : _Body_(TriInfBody);
kbCtrlF5 : _Modele_(TriInfModele);
kbCtrlF6 : _NumeroSerie_(TriInfNumSerie);
kbCtrlF10: _AucunTri_;
 kbAltF2 : _Date_(TriSupDate);
 kbAltF3 : _Milage_(TriSupMilage);
 kbAltF4 : _Body_(TriSupBody);
 kbAltF5 : _Modele_(TriSupModele);
 kbAltF6 : _NumeroSerie_(TriSupNumSerie);
kbAltF10 : _AucunTri_;
   End;
  Until (Touche = kbEsc);
  RestitueDerniereLigne(Tableau);
   { Efface le fichier temporaire }
  Handle := Efface('FILES.TMP');
 End;
End;

(*************************************************************************)

Procedure _LecturePiece;
Begin
End;

(*************************************************************************)

Procedure _LectureCode;
Begin
End;

(*************************************************************************)
(*                                                                       *)
(* Description : þ Affiche une consultation bas‚ sur la localisation du  *)
(*                 piece.                                                *)
(*                                                                       *)
(*************************************************************************)

Procedure _LectureLocalise;
Const SrchModele = 2;
      SrchDate   = 32;
Var Position : Byte;
    Temp     : Byte;
    Pos      : LongInt;
    Descr    : DescrType;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure FixeDate(X,Y:Byte;Var Jour,Mois,Annee,Escape:Byte);
 Label 10,20,30;
 Var Chaine : String;
     Erreur : Word;
     Temp   : Word;
 Begin
10:If(Jour > 0)Then Chaine := Strg(Jour)
                Else Chaine := '';
  FixeLocalise(X,Y,2,Chaine,Escape);
  If(Escape = 0)Then
  Begin
   Val(Chaine,Jour,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Jour > 31)or(Jour = 0)Then Goto 10;
20:If(Mois > 0)Then Chaine := Strg(Mois)
                Else Chaine := '';
   FixeLocalise(X+3,Y,2,Chaine,Escape);
   If(Escape = 0)Then
   Begin
    Val(Chaine,Mois,Erreur);
    If(Erreur <> 0)Then Goto 20;
    If(Mois > 12)or(Mois = 0)Then Goto 20;
30:If(Annee > 0)Then Chaine := Strg(Annee+1902)
                Else Chaine := '';
    FixeLocalise(X+6,Y,4,Chaine,Escape);
    If(Escape = 0)Then
    Begin
     Val(Chaine,Temp,Erreur);
     If(Erreur <> 0)Then Goto 30;
     If(Temp < 1902)or(Temp > 2158)Then Goto 30;
     Annee := Temp - 1902;
    End;
   End;
  End;
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Function _Date(Var Jour,Mois,Annee:Byte):ShortInt;
 Var Tableau : Pointer;
     Escape  : Byte;
 Begin
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(((Colonne-18) div 2),12,((Colonne-18) div 2)+18,14,CoulDcr);
  Ecrit(((Colonne-18) div 2)+1,13,'Date : JJ/MM/AAAA',CoulDcr);
  FixeDate(((Colonne-18) div 2)+8,13,Jour,Mois,Annee,Escape);
  RestituteEcran(Tableau);
  If(Escape = 0)Then _Date := 0
                Else _Date := 1;
 End;

Begin { Main _LectureLocalise }
  { Initialise les donnees }
 Position := 0;
 FillChar(Descr,SizeOf(Descr),0);
  { Selectionne dans les menus }
 MenuLecture;
 BarSelecteHori(29,5,44,CoulSlc);
 Position := _SelectePiece(29,6,Position);
 BarSelecteHori(29+1,7+Position,29+15,CoulSlc);
  { Posent les questions du modele qu'il veut... }
 Temp := Modele(Descr.Modele);
 If(Temp = 255)Then Exit;
 Temp := _Date(Descr.Jour,Descr.Mois,Descr.Annee);
 If(Temp = 1)Then Exit;
 Pos  := RechercheDescription(Descr,SrchDate+SrchModele);
 If(Pos = -1)Then
 Begin
  MessageErreur('Erreur : Il n''y a aucune piece correspondante!');
 End
  else
 Begin
 End;
End;

(*************************************************************************)

BEGIN { Main Unit }
END.
