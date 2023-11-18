(**********************************************************************)
(*                                                                    *)
(*                    Inventaire Selection Piece                      *)
(*                           1992/05/03                               *)
(*                                                                    *)
(* Description : þ Choisie une piece dans un menu de piece.           *)
(*                                                                    *)
(**********************************************************************)

Unit ISlcPce;

(**********************************************************************)
                                Interface
(**********************************************************************)

Uses EcrMono,
     Drivers,
     IClavier,
     IVisuel,

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
     IPneus,     { Gestion des pneus         }
     IEnreg;

Function ChoisiePiece(XP,YP,Menu:Byte;Enregistrement:EnregistrementType):Byte;

(**********************************************************************)
                              Implementation
(**********************************************************************)

{ ChoisiePiece retourne ...
   0..X : Type de piece
   254  : Section Complet
   255  : Frappe de la touche <ESC>
}

Function ChoisiePiece(XP,YP,Menu:Byte;Enregistrement:EnregistrementType):Byte;
Var Touche : Word;
    X,Y    : Byte;

 Procedure Devant;
 Var Position : Byte;
 Begin
  If(Enregistrement.Devant.AvantComplet.DevantComplet <> 2)Then { Desassemblee ? }
  Begin
   FixeFormatSimple;
   FixeCadrePlain(X,Y,X+20,Y+17,CoulMnu);
   AffichePieceDevant(X+2,Y+1,CoulMnu);
   Position := 0;
   Repeat
    BarSelecteHori(X+1,Y+1+Position,X+19,CoulSlc);
    Touche := LitClavier;
    BarSelecteHori(X+1,Y+1+Position,X+19,CoulMnu);
    TraiteScanCode(Position,15,Touche);
   Until (Touche = kbESC)or(Touche = kbEnter);
   ChoisiePiece := Position;
  End
   else
  ChoisiePiece := 254;
 End;

 Procedure Cowl;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+25,Y+12,CoulMnu);
  AffichePieceCowl(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+24,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+24,CoulMnu);
   TraiteScanCode(Position,10,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

 Procedure Porte;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+20,Y+5,CoulMnu);
  EcritSpecial(X+2,Y+1,#28'Avant gauche'+#1+
                          'Avant droite'+#1+
                          'Arriere gauche'+#1+
                          'Arriere droite');
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+19,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+19,CoulMnu);
   TraiteScanCode(Position,3,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position + Enregistrement.Porte.Poteau * $40 +
                             Enregistrement.Porte.Ass * $20;
 End;

 Procedure Derriere;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+25,Y+12,CoulMnu);
  AffichePieceCowl(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+24,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+24,CoulMnu);
   TraiteScanCode(Position,10,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

 Procedure Moteur;
 Var Position : Byte;
 Begin
  If(Enregistrement.Moteur.MoteurComplet.MoteurComplet = 1)Then
  Begin
   FixeFormatSimple;
   FixeCadrePlain(X,Y,X+20,Y+11,CoulMnu);
   AfficheMoteur(X+2,Y+1,CoulMnu);
   Position := 0;
   Repeat
    BarSelecteHori(X+1,Y+1+Position,X+19,CoulSlc);
    Touche := LitClavier;
    BarSelecteHori(X+1,Y+1+Position,X+19,CoulMnu);
    TraiteScanCode(Position,9,Touche);
   Until (Touche = kbESC)or(Touche = kbEnter);
   ChoisiePiece := Position;
  End
   else
  ChoisiePiece := 254;
 End;

 Procedure PieceMoteur;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+23,Y+11,CoulMnu);
  AffichePieceRatacheMoteur(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulMnu);
   TraiteScanCode(Position,9,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

 Procedure Transmission;
 Var Position : Byte;
 Begin
  If(Enregistrement.Trans.Ass = 1)Then
  Begin
   FixeFormatSimple;
   FixeCadrePlain(X,Y,X+18,Y+4,CoulMnu);
   AffichePieceTransmission(X+2,Y+1,CoulMnu);
   Position := 0;
   Repeat
    BarSelecteHori(X+1,Y+1+Position,X+17,CoulSlc);
    Touche := LitClavier;
    BarSelecteHori(X+1,Y+1+Position,X+17,CoulMnu);
    TraiteScanCode(Position,2,Touche);
   Until (Touche = kbESC)or(Touche = kbEnter);
   ChoisiePiece := Position;
  End
   else
  ChoisiePiece := 254;
 End;

 Procedure Freins;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+19,Y+7,CoulMnu);
  AffichePieceFreins(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+18,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+18,CoulMnu);
   TraiteScanCode(Position,5,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

 Procedure Suspension;
 Var Position : Byte;
 Begin
  If(Y+15 > 25)Then
  Begin
   X := 20;
   Y := 2;
  End;
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+23,Y+15,CoulMnu);
  AffichePieceSuspension(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulMnu);
   TraiteScanCode(Position,13,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

 Procedure Axle;
 Var Position : Byte;
 Begin
  FixeFormatSimple;
  FixeCadrePlain(X,Y,X+23,Y+6,CoulMnu);
  AffichePieceAxle(X+2,Y+1,CoulMnu);
  Position := 0;
  Repeat
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulSlc);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+1+Position,X+22,CoulMnu);
   TraiteScanCode(Position,4,Touche);
  Until (Touche = kbESC)or(Touche = kbEnter);
  ChoisiePiece := Position;
 End;

Begin
 X := XP;
 Y := YP + Menu;
 ChoisiePiece := 0;
 Case Menu of
  0 : Devant;
  1 : Cowl;
  2 : Porte;
  3 : Derriere;
  4 : Moteur;
  5 : PieceMoteur;
  6 : Transmission;
  7 : Freins;
  8 : Suspension;
  9 : Axle;
 End;
 If(Touche = kbESC)Then ChoisiePiece := 255;
End;

BEGIN
END.