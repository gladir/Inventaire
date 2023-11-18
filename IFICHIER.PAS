(**********************************************************************)
(*                                                                    *)
(*                        Inventaire Fichier                          *)
(*                            1992/04/08                              *)
(*                                                                    *)
(* Compagnie   : Les Chevaliers de Malte                              *)
(* Concepteur  : Sylvain Maltais                                      *)
(* Programmeur : Sylvain Maltais                                      *)
(*                                                                    *)
(* Description : þ Unit‚ g‚rant les fichi‚es des piŠces d'autos, des  *)
(*                 pneus, etc...                                      *)
(*               þ Il gŠre ‚galement le fichier de configuration,     *)
(*                 (INVENT.CFG).                                      *)
(*               þ Et il teste la pr‚sence des fichi‚es de donn‚es    *)
(*                 automatiquement en int‚grant simplement cette      *)
(*                 de le programme maitre.                            *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small Wonder)   *)
(*                 en mode texte monochrome (07h).                    *)
(*               þ Turbo Pascal 6 ou post‚rieur.                      *)
(*               þ Une inclusion d'un fichier GETFILES.INV.           *)
(*                                                                    *)
(* Note        : þ Bien lire les remarques indiqu‚s de cette unit‚    *)
(*                 avant de modifier quoi que ce soit!!               *)
(*                                                                    *)
(**********************************************************************)

Unit IFichier;

(**********************************************************************)
                             Interface
(**********************************************************************)

Uses Crt,      { Gestion de base du contr“ller        }
     Drivers,  { Gestion compl‚mentaire du contr“ller }
     EcrMono,  { Gestion vid‚o (‚cran monochrome)     }
     IVisuel,  { Inventaire Visuel -> Gestion vid‚o   }
     IClavier, { Inventaire Clavier                   }
     Fichier,  { Gestion des fichiers                 }
     Reseau,   { Gestion du r‚seau                    }
     Speed,    { M‚thode d'acc‚l‚ration               }
     IDescr,   { Inventaire Description               }
     IChaine,  { Gestion des chaines et donn‚es       }
     IMenu,    { Gestion des Menus                    }

     IDevant,  { Gestion du Devant                    }
     ICowl,    { Gestion du Cowl                      }
     IPorte,   { Gestion des portes                   }
     IDerr,    { Gestion du DerriŠre                  }
     IMotor,   { Gestion du Moteur                    }
     IPceMot,  { Gestion des PiŠces Moteur            }
     IFreins,  { Gestion des Freins                   }
     ISuspens, { Gestion des Suspensions              }
     IAxle,    { Gestion des Axles                    }
     ITrans,   { Gestion de transmission              }
     IPneus;   { Gestion des pneus                    }

 {  TrŠs important de sp‚cifi‚ la taille de l'enregistrement
   au d‚but du programme main sinon les donn‚es seront ‚gar‚
   entre les deux unit‚s! }

Const TailleEnregistrement : Word = 0;

       { Constante de rang }

      Maitre  = 0;
      Esclave = 1;

       { Constante de lecture }

      GetAuto = 1;

Type StrPassWord = String[14];
     StrTitre    = String[43];
     TypeLecture = Byte;
     ConfigType  = Record
                    Titre    : StrTitre;    { Titre du fichier }
                    Wait     : WaitType;    { Attente }
                    Mode     : Byte;        { Rang }
                    PassWord : StrPassWord; { Mots de passe }
                   End;

Var Config : ConfigType; { Variable initialis‚ au d‚part! }

Procedure EcritConfiguration(Buffer:ConfigType);
Procedure LectureConfiguration;
Procedure SauveEnregistrement(Var Descr:DescrType;Var Buffer;Var Escape:Boolean);
Procedure LectureEnregistrement(Mode:TypeLecture);
Procedure TesteFichierData; {  Ne jamais utilis‚ cette proc‚dure pour autre
                              chose que le "SETUP" }

Function RechercheDescription(Var DescrOrg:DescrType;TypeRech:Byte):LongInt;

(**********************************************************************)
                            Implementation
(**********************************************************************)

Procedure TesteNombre(Tableau:Pointer;Var Nombre:Byte); { Proc‚dure cach‚ }
Begin
 If(Nombre = 0)Then
 Begin
  SauveDerniereLigne(Tableau);
  EcritDerLigne('Un moment S.V.P. ou presse <ESC> pour retourner...');
 End;
 Nombre := 1;
End;

{$I GETFILES.INV } { Fichier de lecture des piŠces d'auto }

Procedure SauveEnregistrement(Var Descr:DescrType;Var Buffer;Var Escape:Boolean);
Var Handle   : Integer;
    Touche   : Word;
    Nombre   : Byte;
    Tableau  : Pointer;
    Position : LongInt;
    Taille   : LongInt;
Begin
 Escape := False;
 Nombre := 0;
 Repeat
  Handle := Ouvre('FILES.DAT',0);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Taille := TailleFichier(Handle);
  If(Taille > 0)Then Position := Taille div SizeOf(Descr)
                Else Position := 0;
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Ferme(Handle);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Handle := Ouvre('INVENT.DAT',2);
  If(Handle = -1)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (Handle <> -1);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  ModifieEnregistrement(Handle,Position,TailleEnregistrement,Buffer);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Ferme(Handle);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Handle := Ouvre('FILES.DAT',2);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  ModifieEnregistrement(Handle,Position,SizeOf(Descr),Descr);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
 Repeat
  Ferme(Handle);
  If(ErreurFichier <> 0)Then
  Begin
   TesteNombre(Tableau,Nombre);
   If(ClavierPrete = 1)Then
   Begin
    Touche := LitClavier;
    If(Touche = kbEsc)Then
    Begin
     Escape := True;
     Exit;
    End;
   End;
  End;
 Until (ErreurFichier = 0);
 If(Nombre = 1)Then
 Begin
  RestitueDerniereLigne(Tableau);
  Nombre := 0;
 End;
End;

Procedure EcritConfiguration(Buffer:ConfigType);
Var Handle  : Integer;
    Tableau : Pointer;
    Touche  : Word;
Begin
 Handle := Cree('INVENT.CFG');
 If(Handle = -1)Then
 Begin
  SauveDerniereLigne(Tableau);
  EcritDerLigne('Erreur d''‚criture, presse une touche pour retourner');
  Touche := LitClavier;
  RestitueDerniereLigne(Tableau);
 End
  else
 Begin
  ModifieEnregistrement(Handle,0,SizeOf(Buffer),Buffer);
  Ferme(Handle);
 End;
End;

Procedure LectureConfiguration;
Label 10;
Const Nombre : Byte = 0;
Var Handle  : Integer;
    Tableau : Pointer;
    Touche  : Word;
Begin
 SetKeyboard(0); { D‚branche le clavier }
 FixeClignotement(0);
 FixeCurseurOuvert;
 PositionCurseurDebut;
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Lecture de la configuration...');
 Handle := Ouvre('INVENT.CFG',0);
 SetKeyboard(1); { Rebranche le clavier }
 If(Handle = -1)Then
 Begin
  EcritDerLigne('Erreur de lecture de la configuration, presse une touche pour retourner...');
  Touche := LitClavier;
  If(Nombre = 0)Then
  Begin
   EcritDerLigne('Presse <F1> pour en cr‚er un ou <ESC> pour retourner...');
10:Touche := LitClavier;
   If(Touche = kbF1)Then EcritConfiguration(Config) else
   If(Touche <> kbEsc)Then Goto 10;
  End;
 End
  else
 Begin
  If(TailleFichier(Handle) <> SizeOf(Config))Then
  Begin
   EcritDerLigne('Erreur de fichier tronqu‚, presse une touche pour retourner...');
   Touche := LitClavier;
  End
   else
  Begin
   LitEnregistrement(Handle,0,SizeOf(Config),Config);
   SetWait(Config.Wait);
   If(ClavierPrete = 0)Then Delay(300);
  End;
  Ferme(Handle);
 End;
 Nombre := 1;
 RestitueDerniereLigne(Tableau);
End;

 { Avertissement : "TesteFichierData" est une proc‚dure cach‚ qui ne doit
                   doit JAMAIS ˆtre d‚clar‚ dans la partie "Interface"
                   sous risque de perte de donn‚e dans le cas d'un systŠme
                   r‚seau! }

Procedure TesteFichierData;
Var Handle  : Integer;
    Tableau : Pointer;
    Touche  : Word;
Begin
 Handle := Ouvre('FILES.DAT',0);
 If(Handle = -1)Then
 Begin
  SauveDerniereLigne(Tableau);
  EcritDerLigne('Table des autos absentes, presse une touche pour en cr‚er un!');
  Touche := LitClavier;
  EcritDerLigne('Cr‚ation de la table de voiture en cours...');
  Repeat Handle := Cree('FILES.DAT'); Until (Handle <> -1);
  RestitueDerniereLigne(Tableau);
 End;
 Ferme(Handle);
 Handle := Ouvre('INVENT.DAT',0);
 If(Handle = -1)Then
 Begin
  SauveDerniereLigne(Tableau);
  EcritDerLigne('Fichier de donn‚e absente, presse une touche pour en cr‚er un!');
  Touche := LitClavier;
  EcritDerLigne('Cr‚ation du fichier de donn‚e en cours...');
  Repeat Handle := Cree('INVENT.DAT'); Until (Handle <> -1);
  RestitueDerniereLigne(Tableau);
 End;
 Ferme(Handle);
End;

{ Le titre est ce qui va apparaitre lorsque l'on tape avec le
  prompt du DOS :

  C>TYPE INVENT.CFG <ENTER>
  +Fichier de configuration d'Inventaire 1.01

  Note : Le titre doit avoir une longeur sup‚rieur ou inf‚rieur
         … 26 caractŠre. [If(Titre[0] = #26)Then Write('Erreur');] }

BEGIN { Main Unit }
 With Config do
 Begin
  Titre := 'Fichier de configuration d''Inventaire 1.01'+#26;
  Wait  := 1;
  Mode  := Maitre;
  FillChar(PassWord,SizeOf(PassWord),0);
 End;
 LectureConfiguration;
 TesteFichierData;
END.
