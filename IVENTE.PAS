(**********************************************************************)                   {
(*                                                                    *)
(*                        Inventaire Vente                            *)
(*                           1992/05/03                               *)
(*                                                                    *)
(* Description : þ Gestion des ventes et des factures.                *)
(*                                                                    *)
(**********************************************************************)

Unit IVente;

(**********************************************************************)
                               Interface
(**********************************************************************)

Uses DOS,
     Drivers,
     BIOS_PRN,
     Fichier,
     EcrMono,
     IChaine,
     IClavier,
     IVisuel,
     IMenu,
     IClient,
     IEnreg,
     IFIchier,
     IDescr,
     ISlcPce;

Const
      NomAncienFacture     = 'AFACTURE.DAT';
      NomDerniereFacture   = NomAncienFacture;
      NomInventaire        = 'INVENT.DAT';
      NomDescription       = 'FILES.DAT';

      VentePiece           = 25;
      VenteDerniereFacture = 26;

Type
      FactureType = Record
                    CodeArt  : String[20];
                    NumSerie : String[20];
                    Descr    : String[70];
                    Modele   : String[20];
                    Couleur  : String[10];
                    Milage   : LongInt;
                    Prix     : Word;
                    Cent     : Byte;
                    Jour     : Byte;
                    Mois     : Byte;
                    Annee    : Byte;
                    TVQ      : Byte;
                    TPS      : Byte;
                   End;
      NFactType  = Record
                    Titre : String[44];
                    NFact : LongInt;
                   End;

Var NFact : LongInt;

Procedure Entete(Page,Vente,CNAFact:Byte;Client:ClientType);
Procedure Fac(Vente:Byte;CNAFact:Byte);
Procedure LectureAncienFacture(Facture:FactureType);
Procedure LectureNFact;
Procedure LitEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Procedure LitFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Procedure ModifieEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Procedure ModifieFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Procedure ReturnDescription(Position:LongInt;Descr:DescrType);
Procedure ReturnEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Procedure SauveAncienFacture(Facture:FactureType);
Procedure SauveEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Procedure SauveFacture(Position:LongInt;Facture:FactureType);
Procedure SauveNFAct;
Procedure Vente(Menu:Byte);

(**********************************************************************)
                             Implementation
(**********************************************************************)

Procedure LitEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Begin
 FillChar(Enregistrement,SizeOf(Enregistrement),0);
 LitEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
End;

(**********************************************************************)

Procedure LitFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Begin
 FillChar(Facture,SizeOf(Facture),0);
 LitEnregistrement(Handle,Position,SizeOf(Facture),Facture);
End;

(**********************************************************************)

Procedure ModifieEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Begin
 ModifieEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
End;

(**********************************************************************)

Procedure ModifieFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Begin
 ModifieEnregistrement(Handle,Position,SizeOf(Facture),Facture);
End;

(**********************************************************************)

Procedure ReturnDescription(Position:LongInt;Descr:DescrType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomDescription,0);
 LitEnregistrement(Handle,Position,SizeOf(Descr),Descr);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure ReturnEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomInventaire,0);
 LitEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure SauveEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomInventaire,2);
 ModifieEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure SauveFacture(Position:LongInt;Facture:FactureType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomDerniereFacture,2);
 ModifieEnregistrement(Handle,Position,SizeOf(Facture),Facture);
 Ferme(Handle);
End;

BEGIN
 LectureNFact;
END.

























































(**********************************************************************)
(*                                                                    *)
(*                        Inventaire Vente                            *)
(*                           1992/05/03                               *)
(*                                                                    *)
(* Description : þ Gestion des ventes et des factures.                *)
(*                                                                    *)
(**********************************************************************)                       }

Unit IVente;

(**********************************************************************)
                               Interface
(**********************************************************************)

Uses DOS,     { Gestion DOS }
     Drivers,
     BIOS_PRN,
     Fichier,
     EcrMono,
     IChaine,
     IClavier,
     IVisuel,
     IMenu,
     IClient,
     IEnreg,
     IFIchier,
     IDescr,
     ISlcPce;

Const
      NomAncienFacture     = 'AFACTURE.DAT';
      NomDerniereFacture   = NomAncienFacture;
      NomInventaire        = 'INVENT.DAT';
      NomDescription       = 'FILES.DAT';

      VentePiece           = 25;
      VenteDerniereFacture = 26;

Type
      FactureType = Record
                    CodeArt  : String[20];
                    NumSerie : String[20];
                    Descr    : String[70];
                    Modele   : String[20];
                    Couleur  : String[10];
                    Milage   : LongInt;
                    Prix     : Word;
                    Cent     : Byte;
                    Jour     : Byte;
                    Mois     : Byte;
                    Annee    : Byte;
                    TVQ      : Byte;
                    TPS      : Byte;
                   End;
      NFactType  = Record
                    Titre : String[44];
                    NFact : LongInt;
                   End;

Var NFact : LongInt;

Procedure Entete(Page,Vente,CNAFact:Byte;Client:ClientType);
Procedure Fac(Vente:Byte;CNAFact:Byte);
Procedure LectureAncienFacture(Facture:FactureType);
Procedure LectureNFact;
Procedure LitEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Procedure LitFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Procedure ModifieEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Procedure ModifieFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Procedure ReturnDescription(Position:LongInt;Descr:DescrType);
Procedure ReturnEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Procedure SauveAncienFacture(Facture:FactureType);
Procedure SauveEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Procedure SauveFacture(Position:LongInt;Facture:FactureType);
Procedure SauveNFAct;
Procedure Vente(Menu:Byte);

(**********************************************************************)
                             Implementation
(**********************************************************************)

Procedure LitEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Begin
 FillChar(Enregistrement,SizeOf(Enregistrement),0);
 LitEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
End;

(**********************************************************************)

Procedure LitFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Begin
 FillChar(Facture,SizeOf(Facture),0);
 LitEnregistrement(Handle,Position,SizeOf(Facture),Facture);
End;

(**********************************************************************)

Procedure ModifieEnreg(Handle:Integer;Position:LongInt;Enregistrement:EnregistrementType);
Begin
 ModifieEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
End;

(**********************************************************************)

Procedure ModifieFacture(Handle:Integer;Position:LongInt;Facture:FactureType);
Begin
 ModifieEnregistrement(Handle,Position,SizeOf(Facture),Facture);
End;

(**********************************************************************)

Procedure ReturnDescription(Position:LongInt;Descr:DescrType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomDescription,0);
 LitEnregistrement(Handle,Position,SizeOf(Descr),Descr);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure ReturnEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomInventaire,0);
 LitEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure SauveEnregistrement(Position:LongInt;Enregistrement:EnregistrementType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomInventaire,2);
 ModifieEnregistrement(Handle,Position,SizeOf(Enregistrement),Enregistrement);
 Ferme(Handle);
End;

(**********************************************************************)

Procedure SauveFacture(Position:LongInt;Facture:FactureType);
Var Handle : Integer;
Begin
 Handle := Ouvre(NomDerniereFacture,2);
 ModifieEnregistrement(Handle,Position,SizeOf(Facture),Facture);
 Ferme(Handle);
End;

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

{$I EXTRA.INV    } { "Cross" de chaine               }
{$I TSTPRN.INV   } { Teste imprimante                }
{$I ENTETE.INV   } { Affiche une entete de facture   }
{$I FAC.INV      } { Affiche la facture elle-meme    }
{$I NOFACT.INV   } { Lecture/Ecriture numero facture }
{$I SAF.INV      } { Sauve Ancien Facture            }
{$I LAF.INV      } { Lecture Ancien Facture          }
{$I VENTE.INV    } { Gestion des ventes              }

BEGIN
 LectureNFact;
END.