(***********************************************************************)
(*                                                                     *)
(*                        Inventaire 1.01                              *)
(*                          1992/04/12                                 *)
(*                                                                     *)
(*  Compagnie    : Les Chevaliers de Malte                             *)
(*  Concepteur   : Sylvain Maltais                                     *)
(*  Programmeur  : Sylvain Maltais                                     *)
(*  Debugger     : Sylvain Maltais                                     *)
(*  Date cr‚e    : 1992/03/20                                          *)
(*                                                                     *)
(*  Description  : þ Gestion d'un cimetiŠre de voiture.                *)
(*  RequŠres     : þ Une carte graphics solution d'ATI (Small Wonder)  *)
(*                   en mode texte monochrome (07h).                   *)
(*                 þ Turbo Pascal 6 ou post‚rieur.                     *)
(*                                                                     *)
(***********************************************************************)

Program Inventaire;

{$M 65520,60000,221000 }
{$F+}
{$I-}
{$L+}
{$R-}
{$S-}
{$V-}
{$X-}
{$E+,N+}

Uses EcrMono,    { Gestion Ecran Monochrome                       }
     Intro,      { Intro du programme                             }
     Reseau,     { Gestion R‚seau                                 }

     IFichier,   { Gestion des op‚rations fichiers                }
     IVisuel,    { Fonction Optionnel de Gestion Ecran Monochrome }
     IClavier,   { Gestion Clavier                                }
     IChaine,    { Gestion Chaine octet                           }
     IMenu,      { Gestion Menu                                   }
     IDescr,     { Gestion Description                            }
     IQuest,     { Gestion Menu Question                          }
     IPassWor,   { Demande le PassWord                            }
     IClient,    { Gestion Client                                 }
     IVente,     { Gestion Vente et des factures                  }
     IEfface,    { Gestion Efface                                 }
     IModifie,   { Gestion Modification                           }
     IGetFile,   { Gestion Consultation                           }
     IRapport,   { Gestion Rapport                                }

     IEnreg,     { Gestion Enregistrement                         }
     IReseau;    { Gestion R‚seau                                 }

Var Escape         : Boolean;
    Rep            : Byte;

BEGIN
 OpenReseau;
 Repeat
  BarMenu;
  Tapiserie(TextureFont);
  BarRemarque;
  Rep := Menu;
  Case Rep of
                             SpaceIntro : PIntro;
                              SpaceInfo : PComplementaire;
LectureLocalise,LectureCode,LectureAuto : Lecture(Rep);
                           AdditionAuto : PAdditionAuto;
                         AdittionClient : NewClient;
                          AdditionPorte : PAdditionPorte;
                      ModificationPorte : PModificationPorte;
                   AdditionTransmission : PAdditionTransmission;
               ModificationTransmission : PModificationTransmission;
                         AdditionDevant : PAdditionDevant;
                           AdditionCowl : PAdditionCowl;
                       AdditionDerriere : PAdditionDerriere;
                         AdditionMoteur : PAdditionMoteur;
                    AdditionPieceMoteur : PAdditionPieceMoteur;
                         AdditionFreins : PAdditionFrein;
                     AdditionSuspension : PAdditionSuspension;
                           AdditionAxle : PAdditionAxle;
                          AdditionPneus : PAdditionPneus;
                      ModificationPneus : PModificationPneus;
                        LectureUnClient : LitUnClient;
                      LectureToutClient : LitToutClient;
   ModificationAuto..ModificationClient,
                     ModificationDevant,
                       ModificationCowl,
                   ModificationDerriere,
                     ModificationMoteur,
                ModificationPieceMoteur,
                     ModificationFreins,
                 ModificationSuspension,
                       ModificationAxle  : Modifie(Rep);
               EffaceAuto..EffaceClient  : Efface(Rep);
                                 25..26  : Vente(Rep);
                                     30  : Rapport(Rep);
                                Quitter  : PQuitte;
  End;
 Until False = True;
END.
