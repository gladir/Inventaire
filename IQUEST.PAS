(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Question                        *)
(*                             1992/04/08                              *)
(*                                                                     *)
(* Compagnie   : Les Chevaliers de Malte                               *)
(* Concepteur  : Sylvain Maltais                                       *)
(* Programmeur : Sylvain Maltais                                       *)
(*                                                                     *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).   *)
(*                 en mode texte monochrome (07h).                     *)
(*               þ Turbo Pascal 6 ou post‚rieur.                       *)
(*                                                                     *)
(***********************************************************************)

Unit IQuest;

(***********************************************************************)
                                 Interface
(***********************************************************************)

Uses Drivers,EcrMono,IVisuel,IClavier,IChaine;

Const Ecran      = 0;
      Imprimante = 1;

Procedure Quitte(Var Oui:Byte);
Procedure Sortie(Var Peripherique,Escape:Byte);
Procedure TesteComplet(Var Oui:Byte);

(***********************************************************************)
                              Implementation
(***********************************************************************)

Procedure Sortie(Var Peripherique,Escape:Byte);
Const Position : Byte = 0;
Var Touche  : Word;
    Tableau : Pointer;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(26,12-2,52,16-2,CoulDcr);
 CentreEcriture(13-2,'Affiche les donn‚es …',CoulDcr);
 Ecrit(31,15-2,'Ecran',CoulDcr);
 Ecrit(38,15-2,'Imprimante',CoulDcr);
 EcritDerLigne('Utilis‚ <'#27#32#26'> pour s‚lectionner, <ENTER> pour confirmer ou <ESC> pour retourner.');
 Repeat
  Case Position of
   0 : BarSelecteHori(30,15-2,36,CoulSlc);
   1 : BarSelecteHori(37,15-2,48,CoulSlc);
  End;
  Touche := LitClavier;
  Case Position of
   0 : BarSelecteHori(30,15-2,36,CoulDcr);
   1 : BarSelecteHori(37,15-2,48,CoulDcr);
  End;
  Case Touche of
kbHome : Position := 0;
kbLeft : Min(Position,1);
kbRight: Max(Position,1);
 kbEnd : Position := 1;
  End;
 Until (Touche = kbEnter)or(Touche = kbESC);
 RestituteEcran(Tableau);
 Peripherique := Position;
 If(Touche = kbEnter)Then Escape := 0
                     Else Escape := 1;
End;

(***********************************************************************)

Procedure Quitte(Var Oui:Byte);
Const Position : Byte = 0;
Var Touche  : Word;
    Tableau : Pointer;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(18,12-3,61,16-1,CoulErr);
 CentreEcriture(13-2,'Etes-vous certain de vouloir quitter ?',CoulErr);
 Ecrit(31+3,15-2,'Oui',CoulErr);
 Ecrit(38+3,15-2,'Non',CoulErr);
 EcritDerLigne('Utilis‚ <'#27#32#26'> pour s‚lectionner, <ENTER> pour confirmer ou <ESC> pour retourner.');
 Repeat
  Case Position of
   0 : BarSelecteHori(30+3,15-2,36+3-2,CoulSlc);
   1 : BarSelecteHori(37+3,15-2,48+3-7,CoulSlc);
  End;
  Touche := LitClavier;
  Case Position of
   0 : BarSelecteHori(30+3,15-2,36+3-2,CoulErr);
   1 : BarSelecteHori(37+3,15-2,48+3-7,CoulErr);
  End;
  Case Touche of
kbHome : Position := 0;
kbLeft : Min(Position,1);
kbRight: Max(Position,1);
 kbEnd : Position := 1;
  End;
 Until (Touche = kbEnter)or(Touche = kbESC)or(Lo(Touche) in [78,79,110,111]);
 RestituteEcran(Tableau);
 If((Touche = kbEnter)and(Position = 0))or
    (Lo(Touche) in [79,111])Then Oui := 1
                            Else Oui := 0;
End;

(***********************************************************************)

Procedure TesteComplet(Var Oui:Byte);
Const Position : Byte = 0;
Var Touche  : Word;
    Tableau : Pointer;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(18,12-2,61,16-2,CoulDcr);
 CentreEcriture(13-2,'Est-ce complet ?',CoulDcr);
 Ecrit(31+3,15-2,'Oui',CoulDcr);
 Ecrit(38+3,15-2,'Non',CoulDcr);
 EcritDerLigne('Utilis‚ <'#27#32#26'> pour s‚lectionner, <ENTER> pour confirmer ou <ESC> pour retourner.');
 Repeat
  Case Position of
   0 : BarSelecteHori(30+3,15-2,36+3-2,CoulSlc);
   1 : BarSelecteHori(37+3,15-2,48+3-7,CoulSlc);
  End;
  Touche := LitClavier;
  Case Position of
   0 : BarSelecteHori(30+3,15-2,36+3-2,CoulDcr);
   1 : BarSelecteHori(37+3,15-2,48+3-7,CoulDcr);
  End;
  Case Touche of
kbHome : Position := 0;
kbLeft : Min(Position,1);
kbRight: Max(Position,1);
 kbEnd : Position := 1;
  End;
 Until (Touche = kbEnter)or(Touche = kbESC);
 RestituteEcran(Tableau);
 If(Touche = kbEnter)and(Position = 0)Then Oui := 1
                                      Else Oui := 0;
End;

BEGIN
END.
