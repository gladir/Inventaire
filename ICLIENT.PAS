(****************************************************************)
(*                                                              *)
(*                      Inventaire Client                       *)
(*               (Grandes factures 8"1/2' par 7")               *)
(*                          1992/04/15                          *)
(*                                                              *)
(* Compagnie   : Les Chevaliers de Malte                        *)
(* Concepteur  : Sylvain Maltais                                *)
(* Programmeur : Sylvain Maltais                                *)
(*                                                              *)
(* Description : Cette unit‚ est divis‚ en 10 fonctions de      *)
(*               gestion des clients :                          *)
(*                                                              *)
(*               þ Il y a la proc‚dure d'initialise de fichier  *)
(*                 client (CLIENT.DAT).                         *)
(*               þ La proc‚dure de v‚rification si le fichier   *)
(*                 client existe et le cr‚er dans le cas ou il  *)
(*                 n'est pas trouv‚.                            *)
(*               þ La proc‚dure de demande d'un nouveau client. *)
(*               þ La proc‚dure de sauve dernier/ancien client. *)
(*               þ Lecture ancien/dernier client.               *)
(*               þ Recherche un client dans le fichier CLIENT.  *)
(*               þ Initialise le fichier "CLIENT.DAT".          *)
(*               þ Modifie un client existant.                  *)
(*               þ Soustraction d'un client.                    *)
(*               þ Imprime client.                              *)
(* Note        : þ Cette unit‚ est une renovation du fichier    *)
(*                 "NFACTURE.PAS" de l'ancien programme         *)
(*                 inventaire (1.02).                           *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small     *)
(*                 Wonder) en mode texte monochrome (07h).      *)
(*               þ Turbo Pascal 6 ou post‚rieur.                *)
(*               þ Un imprimante compatible a IBM.              *)
(*                                                              *)
(****************************************************************)

Unit IClient;

{$V-}

(****************************************************************)
                             Interface
(****************************************************************)

Uses DOS,      { Gestion de Base du DOS                  }
     Drivers,  { Gestion compl‚mentaire du contr“ler     }
     BIOS_PRN, { Gestion imprimante                      }
     Fichier,  { Gestion fichier                         }
     IChaine,  { Gestion chaine/donn‚e                   }
     IClavier, { Gestion clavier                         }
     EcrMono,  { Gestion ‚cran monochrome                }
     IVisuel;  { Gestion compl‚mentaire ‚cran monochrome }

Const TitreNFact : String[44] = 'Fichier Inventaire 1.01 de nombre de facture';
      NomCIE     : String[26] = 'C.D.M.';
      Centre     : Byte = 0;

      VenteComptant   = 0;
      VenteClient     = 1;
      NouvelleFacture = 0;
      AncienFacture   = 1;

       { Constante de taxe en mode r‚el }

      TVQ             = 0.08;
      TPS             = 0.07;

Type StrNumero  = String[7];
     ClientType = Record
                   Numero     : StrNumero;
                   NomCIE     : String[25];
                   Adresse    : String[30];
                   Ville      : String[20];
                   Province   : String[3];
                   CodePostal : String[7];
                   Telephone  : String[8];
                   NumeroTax  : String[15];
                  End;

Procedure ImprCli;
Procedure LitToutClient;
Procedure LitUnClient;
Procedure ModifieClient;
Procedure SauveAncienClient(Client:ClientType);
Procedure SoustraitClient;

Function AdditionClient(Var Client:ClientType):Byte;
Function InitFicC:Byte;
Function LectureAncienClient(Var Client:ClientType):Byte;
Function LookUpFC:Byte;
Function NouveauClient(Var Client:ClientType):Byte;
Function NumeroClient(Var VNOClient:StrNumero):Byte;
Function RechercheClient(Numero:StrNumero;Var Client:ClientType):Byte;

(****************************************************************)
                         Implementation
(****************************************************************)

{$I LTC.INV } { Lit Tout Client }

Procedure LitUnClient;
Label Fin,De;
Var Handle    : Integer;
    Escape    : Byte;
    Taille    : LongInt;
    SClient   : Word;
    Tableau   : Pointer;
    Compteur  : Word;
    VNOClient : String[7];
    Client    : ClientType;

 Procedure AfficheClient(Var Client:ClientType);
 Label 10,20,30,40,50,60,70,Fin;
 Const X = 2;
       Y = 2;
 Var Tableau : Pointer;
 Begin
   { Pr‚paration ‚cran }
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+50,Y+10,$F0);
  Ecrit(X+1,Y+1,'Consultation d''un client',$F0);
  With Client do
  Begin
   EcritSpecial(X+1,Y+3,#28+'Nom compagnie : '+NomCIE+#1+
                        'Adresse : '+Adresse+#1+
                        'Ville : '+Ville+#1+
                        'Province : '+Province+#1+
                        'Code postal : '+CodePostal+#1+
                        'T‚l‚phone : '+Telephone+#1+
                        'Num‚ro tax : '+NumeroTax);
  End;
  Pause;
  RestituteEcran(Tableau);
 End;

 Procedure ClientNonTrouver;
 Var Touche  : Word;
     Tableau : Pointer;
 Begin
  SauveDerniereLigne(Tableau);
  EffaceLigne(24,32,CoulErr);
  Ecrit(2,24,'Client non-trouv‚, presse une touche pour retourner',CoulErr);
  Touche := LitClavier;
  RestitueDerniereLigne(Tableau);
 End;

Begin
 FixeFormatDouble;
 FixeCadrePlain(15,9,64,15,CoulDcr);
 Ecrit(20,11,'Entrez le num‚ro du client a consulter :',CoulDcr);
 FillChar(VNOClient,SizeOf(VNOClient),0);
 FixeLocalise(20,13,7,VNOClient,Escape);
 If(Escape = 1)or(VNOClient = '0')Then Exit;
 VNOClient := Maj(VNOClient);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Recherche du client en cours...');
 Handle := Ouvre('CLIENT.DAT',2);
 If(Handle = -1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  ClientNonTrouver;
  Exit;
 End;
 SClient := SizeOf(Client);
 Taille := TailleFichier(Handle);
 If(Taille > 0)Then Taille := Taille div SClient;
 For Compteur := 0 to Taille do
 Begin
  FillChar(Client,SClient,0);
  LitEnregistrement(Handle,Compteur,SClient,Client);
  If(Client.Numero = VNOClient)Then Goto Fin;
 End;
 RestitueDerniereLigne(Tableau);
 ClientNonTrouver;
 Goto De;
Fin:EcritDerLigne('Presse une touche pour retourner...');
 AfficheClient(Client);
 RestitueDerniereLigne(Tableau);
De:Ferme(Handle);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Demande le num‚ro du client.                 *)
(* Note        : þ Si un problŠme a eu lieu "NumeroClient"      *)
(*                 retourne 1.                                  *)
(*                                                              *)
(****************************************************************)

Function NumeroClient(Var VNOClient:StrNumero):Byte;
Var Tableau : Pointer;
    Escape  : Byte;
    Chaine  : String;
Begin
 NumeroClient := 0;
  { Pr‚paration ‚cran }
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(20,10,60,14,CoulDcr);
 Ecrit(22,12,'Entrez le num‚ro du client  [.......]',CoulDcr);
  { Lecture du num‚ro du client }
 FillChar(VNOClient,SizeOf(VNOClient),0);
 FillChar(Chaine,SizeOf(Chaine),0);
 Repeat
  FixeLocalise(51,12,7,Chaine,Escape);
  VNOClient := Maj(Chaine);
  If(Escape = 1)Then
  Begin
   NumeroClient := 1;
   RestituteEcran(Tableau);
   Exit;
  End;
 Until (VNOClient<>'');
 RestituteEcran(Tableau);
End;

{$I TSTPRN.INV  } { Teste imprimante      }
{$I EXTRA.INV   } { "Cross" de chaine     }
{$I NCLIENT.INV } { Nouveau Client        }
{$I SAC.INV     } { Sauve ancien client   }
{$I LAC.INV     } { Lecture ancien client }
{$I IMPRCLI.INV } { Imprime client        }

(****************************************************************)
(*                                                              *)
(*                         RechercheClient                      *)
(*                                                              *)
(* Description   : þ Recherche un client dans le fichier        *)
(*                   "CLIENT.DAT".                              *)
(* Note          : þ Si le num‚ro de client est inconnu il      *)
(*                   retourne dans la variable "CLIENT.NUMERO"  *)
(*                   la valeur "-+0".                           *)
(*                 þ Le fichier de lecture est "CLIENT.DAT" et  *)
(*                   est lu dans le r‚pertoire courant.         *)
(* Message       : þ Ecrit en derniŠre ligne qu'il recherche le *)
(*                   le client sp‚cifi‚.                        *)
(* Avertissement : þ Il n'y aucun reprise en cas d'absence de   *)
(*                   fichier.                                   *)
(*                                                              *)
(****************************************************************)

Function RechercheClient(Numero:StrNumero;Var Client:ClientType):Byte;
Label Fin;
Var Handle   : Integer;
    Taille   : LongInt;
    SClient  : Word;
    Tableau  : Pointer;
    Compteur : Word;
Begin
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Recherche du client en cours...');
 Handle := Ouvre('CLIENT.DAT',0);
 If(Handle = -1)Then
 Begin
  RechercheClient := 1;
  Client.Numero   := '-+0';
  RestitueDerniereLigne(Tableau);
  Exit;
 End;
 SClient := SizeOf(Client);
 Taille := TailleFichier(Handle);
 If(Taille > 0)Then Taille := Taille div SClient;
 For Compteur := 0 to Taille do
 Begin
  FillChar(Client,SClient,0);
  LitEnregistrement(Handle,Compteur,SClient,Client);
  If(Client.Numero = Numero)Then Goto Fin;
 End;
 FillChar(Client,SClient,0);
 Client.Numero := '-+0';
Fin:Ferme(Handle);
 RechercheClient := 0;
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure recherche une place de libre *)
(*                 le fichier "CLIENT.DAT".                     *)
(*                                                              *)
(****************************************************************)

Function LibreClient:LongInt;
Label Fin;
Var Handle   : Integer;
    Taille   : LongInt;
    SClient  : Word;
    Tableau  : Pointer;
    Compteur : Word;
    Client   : ClientType;
Begin
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Recherche d''un place de libre en cours...');
 Handle := Ouvre('CLIENT.DAT',0);
 If(Handle = -1)Then
 Begin
  LibreClient := 0;
  RestitueDerniereLigne(Tableau);
  Exit;
 End;
 SClient := SizeOf(Client);
 Taille := TailleFichier(Handle);
 If(Taille > 0)Then Taille := Taille div SClient;
 For Compteur := 0 to Taille do

 Begin
  FillChar(Client,SClient,0);
  LitEnregistrement(Handle,Compteur,SClient,Client);
  If(Client.Numero = '-X-X-X-')Then
  Begin
   LibreClient := Compteur;
   Goto Fin;
  End;
 End;
 LibreClient := Taille;
Fin:Ferme(Handle);
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure initialise le fichier client *)
(*                 (CLIENT.DAT).                                *)
(*                                                              *)
(****************************************************************)

Function InitFicC:Byte;
Label 10;
Var Handle  : Integer;
    Tableau : Pointer;
    Nombre  : Byte;
    Touche  : Word;
Begin
 InitFicC := 0;
 Nombre := 0;
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Initialisation du fichier client en cours...');
10:Handle := Cree('CLIENT.DAT');
 If(Handle = -1)Then
 Begin
  If(Nombre = 0)Then
  Begin
   EcritDerLigne('Un instant S.V.P., presse <ESC> pour retourner');
   Nombre := 1;
  End;
  If(ClavierPrete = 1)Then
  Begin
   Touche := LitClavier;
   If(Touche = kbEsc)Then
   Begin
    InitFicC := 1;
    RestitueDerniereLigne(Tableau);
    Exit;
   End
    else
   Goto 10;
  End
   else
  Goto 10;
 End
  else
 Ferme(Handle);
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure v‚rifie si le fichier client *)
(*                 existe et le cr‚er dans le cas ou il n'est   *)
(*                 pas trouv‚.                                  *)
(*                                                              *)
(****************************************************************)

Function LookUpFC:Byte;
Var Handle : Integer;
    Retour : Byte;
Begin
 Retour := 0;
 Handle := Ouvre('CLIENT.DAT',0);
 If(ErreurFichier in [2, { Fichier non-trouv‚ }
                      3, { Chemin non-trouv‚  }
                      5])Then { AccŠs refus‚  }
 Begin
  Retour := InitFicC;
 End;
 LookUpFC := Retour;
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Addition un client par n'importe quelle      *)
(*                 m‚thode imaginable ou pas trŠs loyal dans le *)
(*                 fichi‚ "CLIENT.DAT".                         *)
(* Note        : þ Si un problŠme a eu lieu (style le vendeur   *)
(*                 change d'id‚e) la fonction "AdditionClient"  *)
(*                 retourne 1 comme valeur.                     *)
(*                                                              *)
(****************************************************************)

Function AdditionClient(Var Client:ClientType):Byte;
Var Position : LongInt;
    Handle   : Integer;
    Tableau  : Pointer;
    Touche   : Word;

  {  1   = Numero }

 Function RechercheClient(Var DescrOrg:ClientType;TypeRech:Byte):LongInt;
 Label 10,20,30;
 Var Compteur : Byte;
     Tableau  : Pointer;
     Taille   : LongInt;
     Descr    : ClientType;
     Handle   : Integer;
 Begin
  RechercheClient := -1;
  SauveDerniereLigne(Tableau);
  EcritDerLigne('Recherche l''existance du client en cours...');
  Repeat Handle := Ouvre('CLIENT.DAT',0); Until (Handle <> -1);
  Taille := TailleFichier(Handle);
  If(Taille > 0)Then Taille := Taille div SizeOf(Descr);
  Compteur := 0;
 10:LitEnregistrement(Handle,Compteur,SizeOf(Descr),Descr);
  Case TypeRech of
   1 : If(Descr.Numero = DescrOrg.Numero)Then Goto 20;
  End;
  If(Compteur <= Taille)Then
  Begin
   Inc(Compteur);
   Goto 10;
  End
   else
  Goto 30;
 20:RechercheClient := Compteur;
 30:RestitueDerniereLigne(Tableau);
 End;

Begin
 FillChar(Client.Numero,SizeOf(Client.Numero),0);
 If(NumeroClient(Client.Numero) = 1)Then
 Begin
  AdditionClient := 1;
  Exit;
 End;
 If(RechercheClient(Client,1) = -1)Then
 Begin
  If(NouveauClient(Client) = 1)Then
  Begin
   AdditionClient := 1;
   Exit;
  End;
  Position := LibreClient;
  Handle := Ouvre('CLIENT.DAT',2);
  If(Handle = -1)Then
  Begin
   Repeat
    Handle := Cree('CLIENT.DAT');
   Until (Handle <> -1);
  End;
  ModifieEnregistrement(Handle,Position,SizeOf(Client),Client);
  Ferme(Handle);
  AdditionClient := 0;
 End
  else
 Begin
  AdditionClient := 2;
  SauveDerniereLigne(Tableau);
  EffaceLigne(24,32,CoulErr);
  Ecrit(2,24,'Num‚ro client existant, presse une touche pour retourner...',CoulErr);
  Write(^G);
  Touche := LitClavier;
  RestitueDerniereLigne(Tableau);
 End;
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Modifie un client dans la liste existante.   *)
(*               þ Si le fichier n'existe pas il suppose que le *)
(*                 client n'existe pas.                         *)
(*                                                              *)
(****************************************************************)

Procedure ModifieClient;
Label Fin,De;
Var Handle    : Integer;
    Escape    : Byte;
    Taille    : LongInt;
    SClient   : Word;
    Tableau   : Pointer;
    Compteur  : Word;
    VNOClient : String[7];
    Client    : ClientType;

 Function NouveauClient(Var Client:ClientType):Byte;
 Label 10,20,30,40,50,60,70,Fin;
 Const X = 2;
       Y = 2;
 Var Escape  : Byte;
     Tableau : Pointer;
 Begin
  NouveauClient := 0;
  Escape := 0;
  { Pr‚paration ‚cran }
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+50,Y+10,$F0);
  Ecrit(X+1,Y+1,'Client a modifi‚',$F0);
  With Client do
  Begin
   EcritSpecial(X+1,Y+3,#28+'Nom compagnie : '+NomCIE+#1+
                        'Adresse : '+Adresse+#1+
                        'Ville : '+Ville+#1+
                        'Province : '+Province+#1+
                        'Code postal : '+CodePostal+#1+
                        'T‚l‚phone : '+Telephone+#1+
                        'Num‚ro tax : '+NumeroTax);
    { Pose les question }
 10:FixeLocaliseUD(X+17,Y+3,24,NomCIE,Escape);
   If(Escape = 1)Then Goto Fin;
   If(Escape = 2)Then Goto 70;
   If(NomCIE = '')Then Goto 10;
 20:FixeLocaliseUD(X+11,Y+4,30,Adresse,Escape);
   If(Escape = 1)Then Goto Fin;
   If(Escape = 2)Then Goto 10;
   If(Adresse = '')Then Goto 20;
 30:FixeLocaliseUD(X+9,Y+5,20,Ville,Escape);
   If(Escape = 1)Then Goto Fin;
   If(Escape = 2)Then Goto 20;
   If(Ville = '')Then Goto 30;
 40:FixeLocaliseUD(X+12,Y+6,3,Province,Escape);
   If(Escape = 1)Then Goto Fin;
   If(Escape = 2)Then Goto 30;
   If(Province = '')Then Goto 40;
 50:Repeat
    FixeLocaliseUD(X+15,Y+7,7,CodePostal,Escape);
    If(Escape = 1)Then Goto Fin;
    CodePostal := Maj(CodePostal);
   Until((CodePostal[1] in ['A'..'Z'])and
         (CodePostal[2] in ['0'..'9'])and
         (CodePostal[3] in ['A'..'Z'])and
         (CodePostal[4] in [' ','-'])and
         (CodePostal[5] in ['0'..'9'])and
         (CodePostal[6] in ['A'..'Z'])and
         (CodePostal[7] in ['0'..'9']));
   If(Escape = 2)Then Goto 40;
 60:Repeat
    FixeLocaliseUD(X+13,Y+8,8,Telephone,Escape);
    If(Escape = 1)Then Goto Fin;
   Until(((Length(Telephone)=8)and
         (Telephone[1] in ['0'..'9'])and
         (Telephone[2] in ['0'..'9'])and
         (Telephone[3] in ['0'..'9'])and
         (Telephone[4] in ['-',' '])and
         (Telephone[5] in ['0'..'9'])and
         (Telephone[6] in ['0'..'9'])and
         (Telephone[7] in ['0'..'9'])and
         (Telephone[8] in ['0'..'9'])));
   If(Escape = 2)Then Goto 50;
 70:FixeLocaliseUD(X+14,Y+9,15,NumeroTax,Escape);
   If(Escape = 1)Then Goto Fin;
   If(Escape = 2)Then Goto 60;
   If(NumeroTax = '')Then Goto 70;
  End;
 Fin:NouveauClient := Escape;
  RestituteEcran(Tableau);
 End;

 Procedure ClientNonTrouver;
 Var Touche  : Word;
     Tableau : Pointer;
 Begin
  SauveDerniereLigne(Tableau);
  EffaceLigne(24,32,CoulErr);
  Ecrit(2,24,'Client non-trouv‚, presse une touche pour retourner',CoulErr);
  Touche := LitClavier;
  RestitueDerniereLigne(Tableau);
 End;

Begin
 FixeFormatDouble;
 FixeCadrePlain(15,9,64,15,CoulDcr);
 Ecrit(20,11,'Entrez le num‚ro du client a modifier :',CoulDcr);
 FillChar(VNOClient,SizeOf(VNOClient),0);
 FixeLocalise(20,13,7,VNOClient,Escape);
 If(Escape = 1)or(VNOClient = '0')Then Exit;
 VNOClient := Maj(VNOClient);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Recherche du client en cours...');
 Handle := Ouvre('CLIENT.DAT',2);
 If(Handle = -1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  ClientNonTrouver;
  Exit;
 End;
 SClient := SizeOf(Client);
 Taille := TailleFichier(Handle);
 If(Taille > 0)Then Taille := Taille div SClient;
 For Compteur := 0 to Taille do
 Begin
  FillChar(Client,SClient,0);
  LitEnregistrement(Handle,Compteur,SClient,Client);
  If(Client.Numero = VNOClient)Then Goto Fin;
 End;
 RestitueDerniereLigne(Tableau);
 ClientNonTrouver;
 Goto De;
Fin:RestitueDerniereLigne(Tableau);
 Escape := NouveauClient(Client);
 If(Escape = 1)Then Goto De;
  { Sauvegarde des donn‚es }
 FixeUnCaractere(79,0,65);
 ModifieEnregistrement(Handle,Compteur,SClient,Client);
De:Ferme(Handle);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure soustrait un client.         *)
(*                                                              *)
(****************************************************************)

Procedure SoustraitClient;
Label Fin,De;
Var Handle    : Integer;
    Escape    : Byte;
    Taille    : LongInt;
    SClient   : Word;
    Tableau   : Pointer;
    Compteur  : Word;
    VNOClient : String[7];
    Client    : ClientType;

 Procedure ClientNonTrouver;
 Var Touche  : Word;
     Tableau : Pointer;
 Begin
  SauveDerniereLigne(Tableau);
  EffaceLigne(24,32,CoulErr);
  Ecrit(2,24,'Client non-trouv‚, presse une touche pour retourner',CoulErr);
  Touche := LitClavier;
  RestitueDerniereLigne(Tableau);
 End;

Begin
 FixeFormatDouble;
 FixeCadrePlain(10,9,69,15,CoulErr);
 Ecrit(20,11,'Entrez le num‚ro du client a effacer :',CoulErr);
 FillChar(VNOClient,SizeOf(VNOClient),0);
 FixeLocalise(20,13,7,VNOClient,Escape);
 If(Escape = 1)or(VNOClient = '0')Then Exit;
 VNOClient := Maj(VNOClient);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Recherche du client en cours...');
 Handle := Ouvre('CLIENT.DAT',2);
 If(Handle = -1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  ClientNonTrouver;
  Exit;
 End;
 SClient := SizeOf(Client);
 Taille := TailleFichier(Handle);
 If(Taille > 0)Then Taille := Taille div SClient;
 For Compteur := 0 to Taille do
 Begin
  FillChar(Client,SClient,0);
  LitEnregistrement(Handle,Compteur,SClient,Client);
  If(Client.Numero = VNOClient)Then Goto Fin;
 End;
 RestitueDerniereLigne(Tableau);
 ClientNonTrouver;
 Goto De;
Fin:RestitueDerniereLigne(Tableau);
 If(Escape = 1)Then Goto De;
  { Sauvegarde des donn‚es }
 Client.Numero := '-X-X-X-';
 ModifieEnregistrement(Handle,Compteur,SClient,Client);
De:Ferme(Handle);
End;

BEGIN { Main Unit }
 Centre := 16 - (Length(NomCIE) div 2);
END.
