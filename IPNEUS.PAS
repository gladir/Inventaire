(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Pneus                           *)
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

Unit IPneus;

{$V-}

(***********************************************************************)
                                 Interface
(***********************************************************************)

Uses Crt,Drivers,EcrMono,Fichier,IVisuel,IClavier,IChaine;

Const
      NomPneus    = 'PNEUS.DAT';
      NomPneu     = NomPneus;

      Dimension   = 1;
      Marque      = 2;
      Usure       = 4;
      Modele      = 8;
      Lettre      = 16;
      FlancBlanc  = 32;

Type
     DimensionType     = String[11];
     MarqueType        = String[20];
     LocaliseType      = String[7];
     CodeType          = String[7];
     CodeHollanderType = String[7];
     PneusType         = Record
                          Dimension  : DimensionType;
                          Marque     : MarqueType;
                          Usure      : Byte;
                          Modele     : Byte;
                          Lettre     : Byte;
                          FlancBlanc : Byte;
                          Prix       : Word;
                          Cent       : Byte;
                          Localise   : LocaliseType;
                          Code       : CodeHollanderType;
                         End;

Procedure AdditionPneus;
Procedure CreationFichierPneus;
Procedure FixePneus(Var Pneus:PneusType;Var Sort:Boolean);
Procedure LitPneus(Handle:Integer;Position:LongInt;Pneus:PneusType);
Procedure ModificationPneus;
Procedure ReturnPneus(Position:LongInt;Var Pneus:PneusType);
Procedure SauveLibrePneus(Pneus:PneusType);
Procedure SauvePneus(Position:LongInt;Pneus:PneusType);

Function FichierPneusExiste:Byte;

(***********************************************************************)
                            Implementation
(***********************************************************************)

Function FichierPneusExiste:Byte;
Var Handle : Integer;
Begin
 Handle := Ouvre(NomPneus,0);
 If(Handle = -1)Then FichierPneusExiste := 0
  else
 Begin
  Ferme(Handle);
  FichierPneusExiste := 1;
 End;
End;

(***********************************************************************)

Procedure LitPneus(Handle:Integer;Position:LongInt;Pneus:PneusType);
Begin
 FillChar(Pneus,SizeOf(Pneus),0);
 LitEnregistrement(Handle,Position,SizeOf(Pneus),Pneus);
End;

(***********************************************************************)

Procedure ReturnPneus(Position:LongInt;Var Pneus:PneusType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomPneus,0);
 LitPneus(Handle,Position,Pneus);
 Ferme(Handle);
End;

(***********************************************************************)

Procedure SauvePneus(Position:LongInt;Pneus:PneusType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomPneus,2);
 ModifieEnregistrement(Handle,Position,SizeOf(Pneus),Pneus);
 Ferme(Handle);
End;

 { 1 = Dimension
   2 = Marque
   4 = Usure
   8 = Modele
   16 = Lettre
   32 = FlancBlanc
 }

Function RecherchePneus(Var PneusOrg:PneusType;TypeRecherche:Byte):LongInt;
Var Handle   : Integer;
    Compteur : LongInt;
    Taille   : LongInt;
    Pneus    : PneusType;
Begin
 If(FichierPneusExiste = 1)Then
 Begin
  Handle := Ouvre(NomPneus,0);
  Taille := TailleFichier(Handle);
  If(Taille > 0)Then Taille := Taille div SizeOf(Pneus);
  For Compteur := 0 to Taille do
  Begin
   LitPneus(Handle,Compteur,Pneus);
   Case TypeRecherche of
    Dimension : If(Pneus.Dimension = PneusOrg.Dimension)Then
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
    Marque    : If(Pneus.Marque = PneusOrg.Marque)Then
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
    Usure     : If(Pneus.Usure = PneusOrg.Usure)Then
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
    Modele    : If(Pneus.Modele = PneusOrg.Modele)Then
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
    Lettre    : If(Pneus.Lettre = PneusOrg.Lettre)Then
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
    FlancBlanc: If(Pneus.FlancBlanc = PneusOrg.FlancBlanc)THen
                Begin
                 Ferme(Handle);
                 RecherchePneus := Compteur;
                 Exit;
                End;
   End;
  End;
  Ferme(Handle);
  RecherchePneus := -1;
 End
  else
 Begin
  RecherchePneus := -1;
 End;
End;

(***********************************************************************)

Procedure ModificationPneus;
Begin
End;

(***********************************************************************)

Procedure SauveLibrePneus(Pneus:PneusType);
Var Handle    : Integer;
    Compteur  : LongInt;
    Taille    : LongInt;
    PneusTemp : PneusType;
Begin
 EcritDerLigne('Ouverture du fichier pneus en cours...');
 If(FichierPneusExiste = 1)Then
 Begin
  EcritDerLigne('Recherche une place de libre en cours...');
  Handle := Ouvre(NomPneus,2);
  Taille := TailleFichier(Handle);
  If(Taille > 0)Then
  Begin
   Taille := Taille div SizeOf(Pneus);
   For Compteur := 0 to Taille do
   Begin
    LitPneus(Handle,Compteur,PneusTemp);
    If(PneusTemp.Dimension[1] = 'å')Then
    Begin
     EcritDerLigne('Sauve du pneus en cours...');
     ModifieEnregistrement(Handle,Compteur,SizeOf(Pneus),Pneus);
     Ferme(Handle);
     Exit;
    End;
   End;
   EcritDerLigne('Aucun place de libre, sauvegarde a la fin du fichier en cours...');
   ModifieEnregistrement(Handle,Taille,SizeOf(Pneus),Pneus);
   Ferme(Handle);
  End
   else
  Begin
   EcritDerLigne('Sauvegarde le pneus en cours...');
   ModifieEnregistrement(Handle,0,SizeOf(Pneus),Pneus);
   Ferme(Handle);
  End;
 End
  else
 Begin
  EcritDerLigne('Creation du fichier pneus en cours...');
  Handle := Cree(NomPneus);
  EcritDerLigne('Sauvegarde le pneus en cours...');
  ModifieEnregistrement(Handle,0,SizeOf(Pneus),Pneus);
  Ferme(Handle);
 End;
End;

(***********************************************************************)

Procedure AdditionPneus;
Var Pneus  : PneusType;
    Escape : Boolean;
Begin
 FillChar(Pneus,SizeOf(Pneus),0);
 FixePneus(Pneus,Escape);
 SauveLibrePneus(Pneus);
End;

(***********************************************************************)

Procedure FixeModelePneus(X,Y,Longeur:Byte;Var Modele,Escape:Byte);
Label 10;
Const XH = 24;
      YH = 13;
Var Key      : KeyQuestionType;
    Chaine   : String;
    Tableau  : Pointer;
    Compteur : Byte;
Begin
  { Initiation data }
 FillChar(Key,SizeOf(Key),0);
 Key[0].Alt := '4 SAISON';
 Key[4].Alt := 'ETE';
 Key[7].Alt := 'HIVER';
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(XH,YH,XH+31,YH+6,CoulHlp);
 Ecrit(XH+2,YH+1,'Aide : ',CoulHlp);
 EcritSpecial(XH+2,YH+3,#3+Chr(CoulHlp)+
                        'Alt-E = Et‚'+#1+
                        'Alt-H = Hiver'+#1+
                        'Alt-A = 4 Saisons');
 Chaine := '';
10:Question(X,Y,Chaine,Longeur,Key,True,Escape);
 FixeCurseurFermer;
 Chaine := Maj(Chaine);
 If(Escape <> 1)Then
 Begin
  If(Chaine = Key[0].Alt)Then Modele := 1 else
  If(Chaine = Key[4].Alt)Then Modele := 2 else
  If(Chaine = Key[7].Alt)Then Modele := 3
   Else If(Escape = 0)Then Goto 10;
 End;
 RestituteEcran(Tableau);
 Ecrit(X,Y,Chaine,7);
End;

(***********************************************************************)

Procedure FixePneus(Var Pneus:PneusType;Var Sort:Boolean);
Label 10,20,30,40,50,60;
Const X = 15;
      Y = 2;
Var Temp   : LongInt;
    Chaine : String;
    Escape : Byte;

 Procedure FixeOui(X,Y:Byte;Var Modele,Escape:Byte);
 Label 10;
 Const XH = 24;
       YH = 16;
 Var Key      : KeyQuestionType;
     Chaine   : String;
     Tableau  : Pointer;
     Compteur : Byte;
 Begin
   { Initiation data }
  FillChar(Key,SizeOf(Key),0);
  Chaine := '';
10:Question(X,Y,Chaine,3,Key,True,Escape);
  FixeCurseurFermer;
  Chaine := Maj(Chaine);
  If(Escape <> 1)Then
  Begin
   If(Chaine = 'N')or(Chaine = 'NON')Then Modele := 0 else
   If(Chaine = 'O')or(Chaine = 'OUI')Then Modele := 1 else
   If(Escape = 0)Then Goto 10;
  End;
  Ecrit(X,Y,Chaine,7);
 End;

Begin
 Temp   := 0;
 Chaine := '';
 FixeFormatDouble;
 FixeCadrePlain(X,Y,X+32,Y+9,CoulDcr);
 Ecrit(X+2,Y+1,'Pneus',CoulDcr);
 EcritSpecial(X+2,Y+3,#28+'Dimensions :'#1'Marque :'#1'Usure en % :'#1+
                      'ModŠle :'#1'Lettr‚ :'#1'Flanc Blanc :'#1);
                     { 'Prix :'#1'Localise :'#1'Code hollander :');}
 With Pneus do
 Begin
10:FixeLocaliseUD(X+15,Y+3,11,Dimension,Escape);
  If(Escape = 2)Then Goto 60;
  If(Escape in [0,3])Then
  Begin
20: FixeLocaliseUD(X+11,Y+4,20,Marque,Escape);
   If(Escape = 2)Then Goto 10;
   If(Escape in [0,3])Then
   Begin
30: FixeMilageUD(X+15,Y+5,Temp,Escape);
    If(Escape = 2)Then Goto 20;
    If(Temp > 100)or(Temp < 0)Then Goto 30;
    Usure := Temp;
    If(Escape in [0,3])Then
    Begin
40:  FixeModelePneus(X+11,Y+6,10,Modele,Escape);
     If(Escape = 2)Then Goto 30;
     If(Escape in [0,3])Then
     Begin
50:   FixeOui(X+11,Y+7,Lettre,Escape);
      If(Escape = 2)Then Goto 40;
      If(Escape in [0,3])Then
      Begin
60:    FixeOui(X+16,Y+8,FlancBlanc,Escape);
       If(Escape = 2)Then Goto 50;
       If(Escape = 3)Then Goto 10;
      End;
     End;
    End;
   End;
  End;
 End;
 If(Escape <> 1)Then Sort := True
                Else Sort := False;
End;

(***********************************************************************)

Procedure CreationFichierPneus;
Var Handle : Integer;
Begin
 If(FichierPneusExiste = 0)Then
 Begin
  EcritDerLigne('Creation du fichier pneus en cours...');
  Handle := Cree(NomPneus);
  Ferme(Handle);
  If(ClavierPrete = 0)Then Delay(300);
 End;
End;

(***********************************************************************)

BEGIN { Main Unit }
 CreationFichierPneus;
END.
