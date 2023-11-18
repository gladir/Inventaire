(*************************************************************************)
(*                                                                       *)
(*                          Inventaire Rapport                           *)
(*                              1992/05/14                               *)
(*                                                                       *)
(*  Programmeur : Sylvain Maltais                                        *)
(*                                                                       *)
(*************************************************************************)

Unit IRapport;

(*************************************************************************)
                                 Interface
(*************************************************************************)

Uses Drivers,
     EcrMono,
     Fichier,
     BIOS_PRN,
     IChaine,
     IClavier,
     IVisuel,
     IEnreg,
     IDescr,
     IDerr,
     IMotor,
     IPceMot;

 { Procedure }

Procedure Rapport(Menu:Byte);
Procedure RapportComplet;

 { Fonction }

Function MessageRapport:Byte;

(*************************************************************************)
                               Implementation
(*************************************************************************)

{$I TSTPRN.INV } { Teste imprimante }

Procedure MessageErreur(P:String);
Label 10;
Var K   : Word;
    Ligne    : Byte;
    I : Byte;
    Chaine1  : String[40];
    Chaine2  : String[40];
Begin
 FillChar(Chaine1,SizeOf(Chaine1),0);
 FillChar(Chaine2,SizeOf(Chaine2),0);
 If(Length(P) > 38)Then
 Begin
  For I := 38 downto 1 do
  Begin
   If(P[I] = ' ')Then
   Begin
    Chaine1 := Copy(P,1,I-1);
    Chaine2 := Copy(P,I+1,255);
    Goto 10;
   End;
  End;
 End
  else
 Chaine1 := P;
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
  K := LitClavier;
 Until (K = kbEnter)or(K = kbESC);
End;

(*************************************************************************)
(*                                                                       *)
(* Description þ Cette fonction retourne 0 s'il ne veux plus faire       *)
(*               imprimer le rapport et avertie egalement de ce qu'il    *)
(*               l'attend.                                               *)
(*                                                                       *)
(*************************************************************************)

Function MessageRapport:Byte;
Var Tableau : Pointer;
    K       : Word;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatSimple;
 FixeCadrePlain(2,2,77,20,CoulDcr);
 CentreEcriture(4,'Rapport complet',CoulDcr);
 Ecrit(5,7,'Avertissement! Le rapport complet est une commande qui imprime',CoulDcr);
 Ecrit(4,8,'tout les donnees contenues dans le fichier d''auto. Par',CoulDcr);
 Ecrit(4,9,'consequant cela necessite beaucoup de papier et de temps (en',CoulDcr);
 Ecrit(4,10,'therme d''heure). Il est a noter egalement que cette commande',CoulDcr);
 Ecrit(4,11,'interrompe la communication dans un systeme reseau.',CoulDcr);
 Ecrit(4,14,'Etes-vous toujours certain de bien vouloir imprimer ce rapport ?',CoulDcr);
 Ecrit(4,16,'Presse <ENTER> pour oui ou n''importe quelle autre touche pour',CoulDcr);
 Ecrit(4,17,'annuler cette commande!',CoulDcr);
 EffaceLigne(24,32,CoulBar);
 EcritSpecial(2,24,#3+Chr(CoulTch)+'ENTER'+#3+Chr(CoulBar)+' Continuer'+#18+
                   '  ESC'+#18+' Retourner');
 K := LitClavier;
 If(K = kbEnter)Then MessageRapport := 1
                Else MessageRapport := 0;
 RestituteEcran(Tableau);
End;

(*************************************************************************)

Function StrPrix(Prix:Word;Cent:Byte):String;
Begin
 StrPrix := 'Prix : ' + Strg(Prix) + ',' + Strg(Cent) + '$';
End;

(*************************************************************************)

Function StrLocalise(Localise:String):String;
Var I : Byte;
Begin
 Localise := Copy(Localise,1,7);
 For I := 0 to 7 do
 Begin
  If(Localise[I] < #32)Then Localise[I] := #32;
 End;
 StrLocalise := 'Localise : ' + Localise;
End;

(*************************************************************************)

Function StrCode(Code:String):String;
Var I : Byte;
Begin
 Code := Copy(Code,1,7);
 For I := 0 to 7 do
 Begin
  If(Code[I] < #32)Then Code[I] := #32;
 End;
 StrCode := 'Code hollander : ' + Code;
End;

(*************************************************************************)
(*                                                                       *)
(* Description : þ Cette procedure imprime un rapport complet sur les    *)
(*                 pieces d'automobile contenue dans le fichier          *)
(*                 "INVENT.DAT" et "FILES.DAT".                          *)
(*                                                                       *)
(*************************************************************************)

Procedure RapportComplet;
Var Taille         : LongInt;
    Handle         : Integer;
    Files          : Integer;
    I              : LongInt;
    Enregistrement : EnregistrementType;
    Descr          : DescrType;
    Result         : Boolean;

 Procedure PrintDevant;
 Begin
  Begin
   With Enregistrement.Devant do
   Begin

    (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
    (*                                                               *)
    (* Imprime : þ Devant, Bumper                                    *)
    (*                                                               *)
    (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

    Result := PrintLn('Devant, Bumper',LPT1);
    Result := Print(#13+#10,LPT1);
    If(Actif[0] = 1)Then
    Begin
     Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
     Result := PrintLN(StrLocalise(Pos[0]),LPT1);
     Result := PrintLN(StrCode(Code[0]),LPT1);
    End
     else
    Begin
     Result := PrintLn('Absent',LPT1);
    End;
    Result := Print(#13+#10,LPT1);

    (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Valence                                           *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Valence',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[1] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
          Result := PrintLN(StrLocalise(Pos[1]),LPT1);
          Result := PrintLn(StrCode(Code[1]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Grille                                    *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Grille',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[2] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
          Result := PrintLn(StrLocalise(Pos[2]),LPT1);
          Result := PrintLn(StrCode(Code[2]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Header panel                              *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Header panel',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[3] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
          Result := PrintLn(StrLocalise(Pos[3]),LPT1);
          Result := PrintLn(StrCode(Code[3]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Headlamp dor                              *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Headlamp dor',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[4] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
          Result := PrintLn(StrLocalise(Pos[4]),LPT1);
          Result := PrintLn(StrCode(Code[4]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Headlamp                                          *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Headlamp',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[5] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[5],Cent[5]),LPT1);
          Result := PrintLn(StrLocalise(Pos[5]),LPT1);
          Result := PrintLn(StrCode(Code[5]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Headlamp motor                                    *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Headlamp motor',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[6] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[6],Cent[6]),LPT1);
          Result := PrintLn(StrLocalise(Pos[6]),LPT1);
          Result := PrintLn(StrCode(Code[6]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Parklamp                                          *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Parklamp',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[7] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[7],Cent[7]),LPT1);
          Result := PrintLn(StrLocalise(Pos[7]),LPT1);
          Result := PrintLn(StrCode(Code[7]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Condenseur d'air                          *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Condenseur d''air',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[8] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[8],Cent[8]),LPT1);
          Result := PrintLn(StrLocalise(Pos[8]),LPT1);
          Result := PrintLn(StrCode(Code[8]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Radiateur                                 *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Radiateur',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[9] = 1)Then
         Begin
          Case Radiateur of
           0 : Result := PrintLn('Manuel',LPT1);
           1 : Result := PrintLn('Automatique',LPT1);
          End;
          Result := PrintLn(StrPrix(Prix[9],Cent[9]),LPT1);
          Result := PrintLn(StrLocalise(Pos[9]),LPT1);
          Result := PrintLn(StrCode(Code[9]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Fan radiateur                             *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Fan radiateur',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[10] = 1)Then
         Begin
          Case FanRadiateur of
           0 : Result := PrintLn('Electronique',LPT1);
           1 : Result := PrintLn('Thermo',LPT1);
          End;
          Result := PrintLn(StrPrix(Prix[10],Cent[10]),LPT1);
          Result := PrintLn(StrLocalise(Pos[10]),LPT1);
          Result := PrintLn(StrCode(Code[10]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Aile gauche                               *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Aile gauche',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[11] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[11],Cent[11]),LPT1);
          Result := PrintLn(StrLocalise(Pos[11]),LPT1);
          Result := PrintLn(StrCode(Code[11]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Aile droite                               *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Aile droite',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[12] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[12],Cent[12]),LPT1);
          Result := PrintLn(StrLocalise(Pos[12]),LPT1);
          Result := PrintLn(StrCode(Code[12]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Frame                                     *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Frame',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[13] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[13],Cent[13]),LPT1);
          Result := PrintLn(StrLocalise(Pos[13]),LPT1);
          Result := PrintLn(StrCode(Code[13]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Frame rail                                *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Frame rail',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[14] = 1)Then
         Begin
          Case FrameRail of
           0 : Result := PrintLn('Aucun',LPT1);
           1 : Result := PrintLn('Droite',LPT1);
           2 : Result := PrintLn('Gauche',LPT1);
           3 : Result := PrintLn('Deux',LPT1);
          End;
          Result := PrintLn(StrPrix(Prix[14],Cent[14]),LPT1);
          Result := PrintLn(StrLocalise(Pos[14]),LPT1);
          Result := PrintLn(StrCode(Code[14]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := Print(#13+#10,LPT1);

         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
         (*                                                               *)
         (* Imprime : þ Devant, Capot                                     *)
         (*                                                               *)
         (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

         Result := PrintLn('Devant, Capot',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[15] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[15],Cent[15]),LPT1);
          Result := PrintLn(StrLocalise(Pos[15]),LPT1);
     Result := PrintLn(StrCode(Code[15]),LPT1);
    End
     else
    Begin
     Result := PrintLn('Absent',LPT1);
    End;
    Result := Print(#13+#10,LPT1);
   End;
  End;
  Result := Print(#13+#10+#13+#10,LPT1);
 End;

Begin
 If(MessageRapport = 0)Then Exit;
 If(TesteImprimante = 27)Then Exit;
 EcritDerLigne('Impression de la liste d''inventaire en cours...');
 Handle := Ouvre('INVENT.DAT',0);
 If(Handle = -1)Then
 Begin
  MessageErreur('Erreur : Le fichier d''inventaire est introuvable!');
 End
  else
 Begin
  Taille := TailleFichier(Handle);
  If(Taille = 0)Then
  Begin
   MessageErreur('Erreur : Le fichier d''inventaire est vide!');
  End
   else
  Begin
   Taille := Taille div SizeOf(Enregistrement);
   Files := Ouvre('FILES.DAT',0);
   If(Handle = -1)Then
   Begin
    MessageErreur('Erreur : Le fichier de description est introuvable!');
   End
    else
   Begin
    If(TailleFichier(Files) <> Taille * SizeOf(Descr))Then
    Begin
     MessageErreur('Erreur : Le fichier de description est trouqu‚!');
    End
     else
    Begin
     For I := 0 to Taille-1 do
     Begin
      FillChar(Descr,SizeOf(Descr),0);
      LitEnregistrement(Files,I,SizeOf(Descr),Descr);
      FillChar(Enregistrement,SizeOf(Enregistrement),0);
      LitEnregistrement(Handle,I,SizeOf(Enregistrement),Enregistrement);
      If(Descr.NumSerie[1] in ['-','å'])Then { Enregistrement Efface ? }
      Begin
      End
       else
      Begin
       Result := PrintLn('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -',LPT1);
       Result := Print(#13+#10+#13+#10,LPT1);
       Result := PrintLn('Description :',LPT1);
       Result := Print(#13+#10,LPT1);
       Result := PrintLn('Numero serie : '+Descr.NumSerie,LPT1);
       Result := PrintLn('Modele       : '+Descr.Modele,LPT1);
       Result := PrintLn('Body         : '+FormatBody(Descr.Body),LPT1);
       Result := PrintLn('Couleur      : '+Descr.Couleur,LPT1);
       Result := PrintLn('Milage       : '+Strg(Descr.Milage),LPT1);
       Result := PrintLn('Date         : '+Date(Descr.Jour,Descr.Mois,Descr.Annee),LPT1);
       Result := Print(#13+#10+#13+#10,LPT1);
       If(Enregistrement.Devant.AvantComplet.DevantComplet = 0)Then
       Begin
        Result := PrintLn('Piece Devant :',LPT1);
        Result := Print(#13+#10,LPT1);
        Result := PrintLn('Aucun',LPT1);
       End
        else
       If(Enregistrement.Devant.AvantComplet.DevantComplet = 2)Then
       Begin
        With Enregistrement.Devant.AvantComplet do
        Begin
         Result := PrintLn('Devant, Complet :',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix,Cent),LPT1);
         Result := PrintLn(StrLocalise(Localise),LPT1);
         Result := PrintLn(StrCode(Code),LPT1);
        End;
       End
        else
       PrintDevant;

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : þ Cowl, Wind shield                                 *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Wind shield',LPT1);
       If(Enregistrement.Cowl.DataActif[0] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[0],
                          Enregistrement.Cowl.DataCent[0]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[0]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[0]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : þ Cowl, Dash                                        *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Dash',LPT1);
       If(Enregistrement.Cowl.DataActif[1] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[1],
                          Enregistrement.Cowl.DataCent[1]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[1]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[1]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : þ Cowl, Spedometre                                  *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Spedometre',LPT1);
       If(Enregistrement.Cowl.DataActif[2] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[2],
                          Enregistrement.Cowl.DataCent[2]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[2]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[2]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Radio                                         *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Radio',LPT1);
       If(Enregistrement.Cowl.DataActif[3] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[3],
                          Enregistrement.Cowl.DataCent[3]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[3]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[3]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Combo swich                                   *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Combo swich',LPT1);
       If(Enregistrement.Cowl.DataActif[4] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[4],
                          Enregistrement.Cowl.DataCent[4]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[4]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[4]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Ignition swich                                *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Ignition swich',LPT1);
       If(Enregistrement.Cowl.DataActif[5] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[5],
                          Enregistrement.Cowl.DataCent[5]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[5]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[5]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Radiateur chaufferette                        *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Radiateur chaufferette',LPT1);
       If(Enregistrement.Cowl.DataActif[6] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[6],
                          Enregistrement.Cowl.DataCent[6]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[6]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[6]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Moteur chaufferette                           *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Moteur chaufferette',LPT1);
       If(Enregistrement.Cowl.DataActif[7] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[7],
                          Enregistrement.Cowl.DataCent[7]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[7]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[7]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Moteur whiper                                 *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Moteur whiper',LPT1);
       If(Enregistrement.Cowl.DataActif[8] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[8],
                          Enregistrement.Cowl.DataCent[8]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[8]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[8]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Cowl, Whiper transmission                           *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       Result := PrintLn('Cowl, Whiper transmission',LPT1);
       If(Enregistrement.Cowl.DataActif[9] = 1)Then
       Begin
        Result := PrintLn(StrPrix(Enregistrement.Cowl.DataPrix[9],
                          Enregistrement.Cowl.DataCent[9]),LPT1);
        Result := PrintLn(StrLocalise(Enregistrement.Cowl.DataPos[9]),LPT1);
        Result := PrintLn(StrCode(Enregistrement.Cowl.DataCode[9]),LPT1);
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Porte Avant gauche                                  *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       If(Enregistrement.Porte.Actif[0] = 1)Then
       Begin
        With Enregistrement.Porte do
        Begin
         Ass    := Ass and 1;
         Poteau := Poteau and 1;
         Result := PrintLn('Porte, Avant gauche',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Poteau = 1)Then Result := PrintLn('Poteau',LPT1);
         Case Ass of
          1 : Result := Print('Assembler',LPT1);
          2 : Result := Print('Desassembler',LPT1);
         End;
         Result := Print(StrPrix(Prx[0],Cnt[0]),LPT1);
         Result := Print(Loc[0],LPT1);
         Result := Print(Code[0],LPT1);
         If(VitreVent[0] = 1)Then Result := Print('Vitre ventilation',LPT1);
         If(Ass = 0)Then
         Begin
          Case TC[0] of
           1 : Result := PrintLn('T',LPT1);
           2 : Result := PrintLn('C',LPT1);
          End;
          If(Regulator = 1)Then Result := PrintLn('Regulateur',LPT1);
         End
          else
         Begin
          Result := Print('Type : ',LPT1);
          Case TypeP[0] of
           0 : Result := PrintLn('EC',LPT1);
           1 : Result := PrintLn('ET',LPT1);
           2 : Result := PrintLn('MC',LPT1);
           3 : Result := PrintLn('MT',LPT1);
          End;
          If(CeinPorte[0] = 1)Then Result := PrintLn('Ceinture porte',LPT1);
          Result := PrintLn('Endommager : '+Endom[0],LPT1);
          If(KeyLess = 1)Then Result := PrintLn('Keyless Entry',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
        End;
       End;

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Porte avant droite                                  *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       If(Enregistrement.Porte.Actif[1] = 1)Then
       Begin
        With Enregistrement.Porte do
        Begin
         Ass    := Ass and 1;
         Poteau := Poteau and 1;
         Result := PrintLn('Porte, Avant droite',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Poteau = 1)Then Result := PrintLn('Poteau',LPT1);
         Case Ass of
          1 : Result := Print('Assembler',LPT1);
          2 : Result := Print('Desassembler',LPT1);
         End;
         Result := Print(StrPrix(Prx[1],Cnt[1]),LPT1);
         Result := Print(Loc[1],LPT1);
         Result := Print(Code[1],LPT1);
         If(VitreVent[1] = 1)Then Result := Print('Vitre ventilation',LPT1);
         If(Ass = 0)Then
         Begin
          Case TC[1] of
           1 : Result := PrintLn('T',LPT1);
           2 : Result := PrintLn('C',LPT1);
          End;
         End
          else
         Begin
          Result := Print('Type : ',LPT1);
          Case TypeP[1] of
           0 : Result := PrintLn('EC',LPT1);
           1 : Result := PrintLn('ET',LPT1);
           2 : Result := PrintLn('MC',LPT1);
           3 : Result := PrintLn('MT',LPT1);
          End;
          If(CeinPorte[1] = 1)Then Result := PrintLn('Ceinture porte',LPT1);
          Result := PrintLn('Endommager : '+Endom[1],LPT1);
         End;
         Result := Print(#13+#10,LPT1);
        End;
       End;

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Porte arriere droite                                *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       If(Enregistrement.Porte.Actif[2] = 1)Then
       Begin
        With Enregistrement.Porte do
        Begin
         Ass    := Ass and 1;
         Poteau := Poteau and 1;
         Result := PrintLn('Porte, Arriere gauche',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Poteau = 1)Then Result := PrintLn('Poteau',LPT1);
         Case Ass of
          1 : Result := Print('Assembler',LPT1);
          2 : Result := Print('Desassembler',LPT1);
         End;
         Result := Print(StrPrix(Prx[2],Cnt[2]),LPT1);
         Result := Print(Loc[2],LPT1);
         Result := Print(Code[2],LPT1);
         If(Ass = 0)Then
         Begin
          Case TC[2] of
           1 : Result := PrintLn('T',LPT1);
           2 : Result := PrintLn('C',LPT1);
          End;
         End
          else
         Begin
          Result := Print('Type : ',LPT1);
          Case TypeP[2] of
           0 : Result := PrintLn('EC',LPT1);
           1 : Result := PrintLn('ET',LPT1);
           2 : Result := PrintLn('MC',LPT1);
           3 : Result := PrintLn('MT',LPT1);
          End;
          Result := PrintLn('Endommager : '+Endom[2],LPT1);
         End;
         Result := Print(#13+#10,LPT1);
        End;
       End;

       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       (*                                                               *)
       (* Imprime : Porte Arriere droite                                *)
       (*                                                               *)
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

       If(Enregistrement.Porte.Actif[3] = 1)Then
       Begin
        With Enregistrement.Porte do
        Begin
         Ass    := Ass and 1;
         Poteau := Poteau and 1;
         Result := PrintLn('Porte, Arriere droite',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Poteau = 1)Then Result := PrintLn('Poteau',LPT1);
         Case Ass of
          1 : Result := Print('Assembler',LPT1);
          2 : Result := Print('Desassembler',LPT1);
         End;
         Result := Print(StrPrix(Prx[3],Cnt[3]),LPT1);
         Result := Print(Loc[3],LPT1);
         Result := Print(Code[3],LPT1);
         If(Ass = 0)Then
         Begin
          Case TC[3] of
           1 : Result := PrintLn('T',LPT1);
           2 : Result := PrintLn('C',LPT1);
          End;
         End
          else
         Begin
          Result := Print('Type : ',LPT1);
          Case TypeP[3] of
           0 : Result := PrintLn('EC',LPT1);
           1 : Result := PrintLn('ET',LPT1);
           2 : Result := PrintLn('MC',LPT1);
           3 : Result := PrintLn('MT',LPT1);
          End;
          Result := PrintLn('Endommager : '+Endom[3],LPT1);
         End;
         Result := Print(#13+#10,LPT1);
        End;
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       If(Enregistrement.Derriere.DataDerriereComplete.DerriereComplete = 2)Then
       Begin
        With Enregistrement.Derriere.DataDerriereComplete do
        Begin
         Result := PrintLn('Derriere complet',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix,Cent),LPT1);
         Result := PrintLn(StrLocalise(Localise),LPT1);
         Result := PrintLn(StrCode(Code),LPT1);
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       If(Enregistrement.Derriere.DataDerriereComplete.DerriereComplete = 1)Then
       Begin
        With Enregistrement.Derriere do
        Begin
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Toit',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[0] = 1)Then
         Begin
          Result := PrintLn(ChoixToit[TypeToit],LPT1);
          Result := PrintLn(StrPrix(DataPrix[0],DataCent[0]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[0]),LPT1);
          Result := PrintLn(StrCode(DataCode[0]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Quarter pannel',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[1] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[1],DataCent[1]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[1]),LPT1);
          Result := PrintLn(StrCode(DataCode[1]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Quarter glass',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[2] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[2],DataCent[2]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[2]),LPT1);
          Result := PrintLn(StrCode(DataCode[2]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Back glass',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[3] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[3],DataCent[3]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[3]),LPT1);
          Result := PrintLn(StrCode(DataCode[3]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Valise',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[4] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[4],DataCent[4]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[4]),LPT1);
          Result := PrintLn(StrCode(DataCode[4]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Haillon',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[5] = 1)Then
         Begin
          Case TypeHaillon of
           1 : Result := PrintLn('Vitre chauffante',LPT1);
           2 : Result := PrintLn('Whiper',LPT1);
           3 : Result := PrintLn('Vitre chauffante & Whiper',LPT1);
          End;
          Result := PrintLn(StrPrix(DataPrix[5],DataCent[5]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[5]),LPT1);
          Result := PrintLn(StrCode(DataCode[5]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Tank a gaz',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[6] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[6],DataCent[6]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[6]),LPT1);
          Result := PrintLn(StrCode(DataCode[6]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Rear finish panel',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[7] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[7],DataCent[7]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[7]),LPT1);
          Result := PrintLn(StrCode(DataCode[7]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Tailgate',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[8] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[8],DataCent[8]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[8]),LPT1);
          Result := PrintLn(StrCode(DataCode[8]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Tail lite',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[9] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[9],DataCent[9]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[9]),LPT1);
          Result := PrintLn(StrCode(DataCode[9]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Bumper',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[10] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[10],DataCent[10]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[10]),LPT1);
          Result := PrintLn(StrCode(DataCode[10]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         (*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)
         Result := PrintLn('Derriere, Boite camion',LPT1);
         Result := Print(#13+#10,LPT1);
         If(DataActif[11] = 1)Then
         Begin
          Result := PrintLn(StrPrix(DataPrix[11],DataCent[11]),LPT1);
          Result := PrintLn(StrLocalise(DataPos[11]),LPT1);
          Result := PrintLn(StrCode(DataCode[11]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Begin
        Result := PrintLn('Derriere',LPT1);
        Result := Print(#13+#10,LPT1);
        Result := PrintLn('Aucun',LPT1);
       End;
       Result := Print(#13+#10+#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       If(Enregistrement.Moteur.MoteurComplet.MoteurComplet = 2)Then { Moteur Complet ? }
       Begin
        With Enregistrement.Moteur.MoteurComplet do
        Begin
         Result := PrintLn('Moteur assembl‚e',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Turbo = 1)Then Result := PrintLn('Turbo',LPT1);
         Result := Print('Carburant : ',LPT1);
         Case Carburant of
          0 : Result := PrintLn('Gaz',LPT1);
          1 : Result := PrintLn('Diesel',LPT1);
         End;
         Result := Print('Nombre cylindre : ',LPT1);
         Case NombreCylindre of
          0 : Result := PrintLn('3',LPT1);
          1 : Result := PrintLn('4',LPT1);
          2 : Result := PrintLn('5',LPT1);
          3 : Result := PrintLn('6L',LPT1);
          4 : Result := PrintLn('V6',LPT1);
          5 : Result := PrintLn('V8',LPT1);
         End;
         Result := Print('Nombre de ',LPT1);
         Case Mesure of
          0 : Result := Print('CC',LPT1);
          1 : Result := Print('litre',LPT1);
         End;
         Result := Print(' : '+Strg(Nombre)+','+Strg(SousNombre),LPT1);
         Result := Print('Vales par cylindre : '+Strg(ValesParCylindre),LPT1);
         Case Categorie of
          0 : Result := PrintLn('Coil pack',LPT1);
          1 : Result := PrintLn('Distributeur',LPT1);
         End;
         Result := PrintLn('Milage : '+Strg(Milage),LPT1);
         Result := PrintLn(StrPrix(Prix,Cent),LPT1);
         Result := PrintLn(StrLocalise(Localise),LPT1);
         Result := PrintLn(StrCode(Code),LPT1);
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       If(Enregistrement.Moteur.MoteurComplet.MoteurComplet = 1)Then
       Begin
        With Enregistrement.Moteur do
        Begin
         Result := PrintLn('Moteur, Cam shaft',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[0] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
          Result := PrintLn(StrLocalise(Pos[0]),LPT1);
          Result := PrintLn(StrCode(Code[0]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Tˆte',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[1] = 1)Then
         Begin
          Result := PrintLn(ChoixInjCar[MoteurTete],LPT1);
          Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
          Result := PrintLn(StrLocalise(Pos[1]),LPT1);
          Result := PrintLn(StrCode(Code[1]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Timing couer',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[2] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
          Result := PrintLn(StrLocalise(Pos[2]),LPT1);
          Result := PrintLn(StrCode(Code[2]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Pane huile',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[3] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
          Result := PrintLn(StrLocalise(Pos[3]),LPT1);
          Result := PrintLn(StrCode(Code[3]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Carburateur',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[4] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
          Result := PrintLn(StrLocalise(Pos[4]),LPT1);
          Result := PrintLn(StrCode(Code[4]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Injection',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[5] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[5],Cent[5]),LPT1);
          Result := PrintLn(StrLocalise(Pos[5]),LPT1);
          Result := PrintLn(StrCode(Code[5]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Pompe a gaz',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[6] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[6],Cent[6]),LPT1);
          Result := PrintLn(StrLocalise(Pos[6]),LPT1);
          Result := PrintLn(StrCode(Code[6]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Pompe a eau',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[7] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[7],Cent[7]),LPT1);
          Result := PrintLn(StrLocalise(Pos[7]),LPT1);
          Result := PrintLn(StrCode(Code[7]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Manifault exhaust',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[8] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[8],Cent[8]),LPT1);
          Result := PrintLn(StrLocalise(Pos[8]),LPT1);
          Result := PrintLn(StrCode(Code[8]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
         Result := PrintLn('Moteur, Manifault intake',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[9] = 1)Then
         Begin
          Result := PrintLn(StrPrix(Prix[9],Cent[9]),LPT1);
          Result := PrintLn(StrLocalise(Pos[9]),LPT1);
          Result := PrintLn(StrCode(Code[9]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Aucun',LPT1);
         End;
         Result := Print(#13+#10,LPT1);
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Begin
        Result := PrintLn('Aucun',LPT1);
       End;
       Result := Print(#13+#10+#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Intercooler',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[0] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
         Result := PrintLn(StrLocalise(Loc[0]),LPT1);
         Result := PrintLn(StrCode(Code[0]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Oil cooler',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[1] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
         Result := PrintLn(StrLocalise(Loc[1]),LPT1);
         Result := PrintLn(StrCode(Code[1]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Turbine',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[2] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
         Result := PrintLn(StrLocalise(Loc[2]),LPT1);
         Result := PrintLn(StrCode(Code[2]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Pompe injection',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[3] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Case Pompe of
          0 : Result := PrintLn('Gaz',LPT1);
          1 : Result := PrintLn('Diesel',LPT1);
         End;
         Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
         Result := PrintLn(StrLocalise(Loc[3]),LPT1);
         Result := PrintLn(StrCode(Code[3]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Module electronique',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[4] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Case Module of
          0 : Result := PrintLn('Gaz',LPT1);
          1 : Result := PrintLn('Diesel',LPT1);
         End;
         Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
         Result := PrintLn(StrLocalise(Loc[4]),LPT1);
         Result := PrintLn(StrCode(Code[4]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Alternateur',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[5] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn('Amperage : '+Strg(Amperage),LPT1);
         Result := PrintLn('# Modele : '+Modele,LPT1);
         Result := PrintLn(StrPrix(Prix[5],Cent[5]),LPT1);
         Result := PrintLn(StrLocalise(Loc[5]),LPT1);
         Result := PrintLn(StrCode(Code[5]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Starter',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[6] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Case Starter of
          0 : Result := PrintLn('Gaz',LPT1);
          1 : Result := PrintLn('Diesel',LPT1);
         End;
         Result := PrintLn(StrPrix(Prix[6],Cent[6]),LPT1);
         Result := PrintLn(StrLocalise(Loc[6]),LPT1);
         Result := PrintLn(StrCode(Code[6]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Distributeur',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[7] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[7],Cent[7]),LPT1);
         Result := PrintLn(StrLocalise(Loc[7]),LPT1);
         Result := PrintLn(StrCode(Code[7]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Compresseur d''air conditionne',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[8] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[8],Cent[8]),LPT1);
         Result := PrintLn(StrLocalise(Loc[8]),LPT1);
         Result := PrintLn(StrCode(Code[8]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Piece ratache au moteur, Bindes poulies',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.PieceMoteur.Actif[9] = 1)Then
       Begin
        With Enregistrement.PieceMoteur do
        Begin
         Result := PrintLn(StrPrix(Prix[9],Cent[9]),LPT1);
         Result := PrintLn(StrLocalise(Loc[9]),LPT1);
         Result := PrintLn(StrCode(Code[9]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := Print(#13+#10+#13+#10,LPT1);
       If(Enregistrement.Trans.Ass = 2)Then
       Begin
        With Enregistrement.Trans do
        Begin
         Result := PrintLn('Transmission complete',LPT1);
         Result := Print(#13+#10,LPT1);
         Case Automat of
          0 : Result := PrintLn('Automatique Normal',LPT1);
          1 : Result := PrintLn('Automatique over drive',LPT1);
          2 : Result := PrintLn('Manuel 3 vitesses',LPT1);
          3 : Result := PrintLn('Manuel 4 vitesses',LPT1);
          4 : Result := PrintLn('Manuel 5 vitesses',LPT1);
          5 : Result := PrintLn('Manuel 6 vitesses',LPT1);
         End;
         Case Traction of
          0 : Result := PrintLn('Traction avant',LPT1);
          1 : Result := PrintLn('Propultion arriŠre',LPT1);
         End;
         Case XxX of
          0 : Result := PrintLn('2x4',LPT1);
          1 : Result := PrintLn('4x4',LPT1);
         End;
         Case Turbo of
          0 : Result := PrintLn('Automatique',LPT1);
          1 : Result := PrintLn('Turbo',LPT1);
         End;
         If(Detail <> '')Then Result := PrintLn(Detail,LPT1)
                         Else Result := PrintLn('Pas de detail',LPT1);
         Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
         Result := PrintLn(StrLocalise(Loc[0]),LPT1);
         Result := PrintLn(StrCode(Code[0]),LPT1);
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       If(Enregistrement.Trans.Ass = 1)Then
       Begin
        With Enregistrement.Trans do
        Begin
         Result := PrintLn('Transmission, Pressure piate',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[0] = 1)Then
         Begin
          If(Clush = 1)Then Result := PrintLn('Clush',LPT1);
          Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
          Result := PrintLn(StrLocalise(Loc[0]),LPT1);
          Result := PrintLn(StrCode(Code[0]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := PrintLn('Transmission, Fly wheel',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[1] = 1)Then
         Begin
          Case FlyWheel of
           0 : Result := PrintLn('Automatique',LPT1);
           1 : Result := PrintLn('Manuel',LPT1);
          End;
          Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
          Result := PrintLn(StrLocalise(Loc[1]),LPT1);
          Result := PrintLn(StrCode(Code[1]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
         Result := PrintLn('Transmission, Transfer case',LPT1);
         Result := Print(#13+#10,LPT1);
         If(Actif[2] = 1)Then
         Begin
          Result := PrintLn(Modele,LPT1);
          Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
          Result := PrintLn(StrLocalise(Loc[2]),LPT1);
          Result := PrintLn(StrCode(Code[2]),LPT1);
         End
          else
         Begin
          Result := PrintLn('Absent',LPT1);
         End;
        End;
       End
        else
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Begin
        Result := PrintLn('Transmission',LPT1);
        Result := Print(#13+#10,LPT1);
        Result := PrintLn('Absent',LPT1);
       End;
       Result := Print(#13+#10+#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Rotor',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[0] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         If(Rotor and 1 = 1)Then Result := Print('Avant Gauche ',LPT1);
         If(Rotor and 2 = 2)Then Result := Print('& Avant droite ',LPT1);
         If(Rotor and 4 = 4)Then Result := Print('& Arriere gauche ',LPT1);
         If(Rotor and 8 = 8)Then Result := Print('& Arriere droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
         Result := PrintLn(StrLocalise(Loc[0]),LPT1);
         Result := PrintLn(StrCode(Code[0]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Galiper',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[1] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         If(Galiper and 1 = 1)Then Result := Print('Avant Gauche ',LPT1);
         If(Galiper and 2 = 2)Then Result := Print('& Avant droite ',LPT1);
         If(Galiper and 4 = 4)Then Result := Print('& Arriere gauche ',LPT1);
         If(Galiper and 8 = 8)Then Result := Print('& Arriere droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
         Result := PrintLn(StrLocalise(Loc[1]),LPT1);
         Result := PrintLn(StrCode(Code[1]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Rear drum',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[2] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         If(RearDrm and 1 = 1)Then Result := Print('Gauche ',LPT1);
         If(RearDrm and 2 = 2)Then Result := Print('& droite ',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
         Result := PrintLn(StrLocalise(Loc[2]),LPT1);
         Result := PrintLn(StrCode(Code[2]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Master cylindre',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[3] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         If(MasCyl = 1)Then Result := PrintLn('Power brake',LPT1);
         Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
         Result := PrintLn(StrLocalise(Loc[3]),LPT1);
         Result := PrintLn(StrCode(Code[3]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Booster',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[4] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
         Result := PrintLn(StrLocalise(Loc[4]),LPT1);
         Result := PrintLn(StrCode(Code[4]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Freins, Antiskid',LPT1);
       Result := Print(#13+#10,LPT1);
       If(Enregistrement.Frein.Actif[5] = 1)Then
       Begin
        With Enregistrement.Frein do
        Begin
         Result := PrintLn(StrPrix(Prix[5],Cent[5]),LPT1);
         Result := PrintLn(StrLocalise(Loc[5]),LPT1);
         Result := PrintLn(StrCode(Code[5]),LPT1);
        End;
       End
        else
       Begin
        Result := PrintLn('Absent',LPT1);
       End;
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Spindel',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[0] = 1)Then
        Begin
         If(Spindel and 1 = 1)Then Result := Print('Avant gauche',LPT1);
         If(Spindel and 2 = 2)Then Result := Print(' & Avant droite',LPT1);
         If(Spindel and 4 = 4)Then Result := Print(' & Arriere gauche',LPT1);
         If(Spindel and 8 = 8)Then Result := Print(' & Arriere droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
         Result := PrintLn(StrLocalise(Loc[0]),LPT1);
         Result := PrintLn(StrCode(Code[0]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Tab',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[1] = 1)Then
        Begin
         If(Tab and 1 = 1)Then Result := Print('Haut gauche',LPT1);
         If(Tab and 2 = 2)Then Result := Print(' & Haut droite',LPT1);
         If(Tab and 4 = 4)Then Result := Print(' & Bas gauche',LPT1);
         If(Tab and 8 = 8)Then Result := Print(' & Bas droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
         Result := PrintLn(StrLocalise(Loc[1]),LPT1);
         Result := PrintLn(StrCode(Code[1]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Strut',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[2] = 1)Then
        Begin
         If(Strut and 1 = 1)Then Result := Print('Avant gauche',LPT1);
         If(Strut and 2 = 2)Then Result := Print(' & Avant droite',LPT1);
         If(Strut and 4 = 4)Then Result := Print(' & Arriere gauche',LPT1);
         If(Strut and 8 = 8)Then Result := Print(' & Arriere droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
         Result := PrintLn(StrLocalise(Loc[2]),LPT1);
         Result := PrintLn(StrCode(Code[2]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, IBeam',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[3] = 1)Then
        Begin
         If(Ibeam and 1=1)Then Result := Print('2x4 gauche',LPT1);
         If(Ibeam and 2=2)Then Result := Print(' & 2x4 droite',LPT1);
         If(Ibeam and 4=4)Then Result := Print(' & 4x4 gauche',LPT1);
         If(Ibeam and 8=8)Then Result := Print(' & 4x4 droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
         Result := PrintLn(StrLocalise(Loc[3]),LPT1);
         Result := PrintLn(StrCode(Code[3]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Bar tortion',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[4] = 1)Then
        Begin
         If(BarTortion and 1 = 1)Then Result := Print('Gauche',LPT1);
         If(BarTortion and 2 = 2)Then Result := Print(' & droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
         Result := PrintLn(StrLocalise(Loc[4]),LPT1);
         Result := PrintLn(StrCode(Code[4]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Bar stabilisatrice',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[5] = 1)Then
        Begin
         If(BarStabilisatrice and 1 = 1)Then Result := Print('Avant',LPT1);
         If(BarStabilisatrice and 2 = 2)Then Result := Print(' & Arriere',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[5],Cent[5]),LPT1);
         Result := PrintLn(StrLocalise(Loc[5]),LPT1);
         Result := PrintLn(StrCode(Code[5]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Axle beam',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[6] = 1)Then
        Begin
         Result := PrintLn(StrPrix(Prix[6],Cent[6]),LPT1);
         Result := PrintLn(StrLocalise(Loc[6]),LPT1);
         Result := PrintLn(StrCode(Code[6]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Rear stub',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[7] = 1)Then
        Begin
         If(RearStub and 1 = 1)Then Result := Print('Gauche',LPT1);
         If(RearStub and 2 = 2)Then Result := Print(' & Droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[7],Cent[7]),LPT1);
         Result := PrintLn(StrLocalise(Loc[7]),LPT1);
         Result := PrintLn(StrCode(Code[7]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Spring',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[8] = 1)Then
        Begin
         If(Spring and 1 = 1)Then Result := Print('Avant',LPT1);
         If(Spring and 2 = 2)Then Result := Print(' & Arriere',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[8],Cent[8]),LPT1);
         Result := PrintLn(StrLocalise(Loc[8]),LPT1);
         Result := PrintLn(StrCode(Code[8]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Lames',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[9] = 1)Then
        Begin
         If(Lames and 1 = 1)Then Result := Print('Avant',LPT1);
         If(Lames and 2 = 2)Then Result := Print(' & Arriere',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[9],Cent[9]),LPT1);
         Result := PrintLn(StrLocalise(Loc[9]),LPT1);
         Result := PrintLn(StrCode(Code[9]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Box stering',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[10] = 1)Then
        Begin
         Case Box of
          0 : Result := PrintLn('Manuel',LPT1);
          1 : Result := PrintLn('Power',LPT1);
         End;
         Result := PrintLn(StrPrix(Prix[10],Cent[10]),LPT1);
         Result := PrintLn(StrLocalise(Loc[10]),LPT1);
         Result := PrintLn(StrCode(Code[10]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Cremaillere',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[11] = 1)Then
        Begin
         Case Cremail of
          0 : Result := PrintLn('Manuel',LPT1);
          1 : Result := PrintLn('Power',LPT1);
         End;
         Result := PrintLn(StrPrix(Prix[11],Cent[11]),LPT1);
         Result := PrintLn(StrLocalise(Loc[11]),LPT1);
         Result := PrintLn(StrCode(Code[11]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Pompe a power stering',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[12] = 1)Then
        Begin
         Result := PrintLn(StrPrix(Prix[12],Cent[12]),LPT1);
         Result := PrintLn(StrLocalise(Loc[12]),LPT1);
         Result := PrintLn(StrCode(Code[12]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Suspension, Colonne stering',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Suspension do
       Begin
        If(Actif[13] = 1)Then
        Begin
         If(Cruise = 1)Then Result := PrintLn('Cruise controle',LPT1);
         If(Couleur <> '')Then Result := PrintLn(Couleur,LPT1);
         Result := PrintLn(StrPrix(Prix[13],Cent[13]),LPT1);
         Result := PrintLn(StrLocalise(Loc[13]),LPT1);
         Result := PrintLn(StrCode(Code[13]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Axle, Cardan',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Axle do
       Begin
        If(Actif[0] = 1)Then
        Begin
         If(Cardan and 1 = 1)Then Result := Print('Avant gauche',LPT1);
         If(Cardan and 2 = 2)Then Result := Print(' & Avant droite',LPT1);
         If(Cardan and 4 = 4)Then Result := Print(' & Arriere gauche',LPT1);
         If(Cardan and 8 = 8)Then Result := Print(' & Arriere droire',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[0],Cent[0]),LPT1);
         Result := PrintLn(StrLocalise(Loc[0]),LPT1);
         Result := PrintLn(StrCode(Code[0]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Axle, Essieu',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Axle do
       Begin
        If(Actif[1] = 1)Then
        Begin
         If(Essieu and 1 = 1)Then Result := Print('gauche',LPT1);
         If(Essieu and 2 = 2)Then Result := Print(' & droite',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[1],Cent[1]),LPT1);
         Result := PrintLn(StrLocalise(Loc[1]),LPT1);
         Result := PrintLn(StrCode(Code[1]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Axle, Diferentiel',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Axle do
       Begin
        If(Actif[2] = 1)Then
        Begin
         If(Integral = 1)Then Result := PrintLn('Integral',LPT1);
         Result := PrintLn(StrPrix(Prix[2],Cent[2]),LPT1);
         Result := PrintLn(StrLocalise(Loc[2]),LPT1);
         Result := PrintLn(StrCode(Code[2]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Axle, Cochon de diferentiel',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Axle do
       Begin
        If(Actif[3] = 1)Then
        Begin
         Result := PrintLn(StrPrix(Prix[3],Cent[3]),LPT1);
         Result := PrintLn(StrLocalise(Loc[3]),LPT1);
         Result := PrintLn(StrCode(Code[3]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := PrintLn('Axle, Drive shaft',LPT1);
       Result := Print(#13+#10,LPT1);
       With Enregistrement.Axle do
       Begin
        If(Actif[4] = 1)Then
        Begin
         If(DriveShaft and 1 = 1)Then Result := Print('Avant',LPT1);
         If(DriveShaft and 2 = 2)Then Result := Print('Arriere',LPT1);
         Result := Print(#13+#10,LPT1);
         Result := PrintLn(StrPrix(Prix[4],Cent[4]),LPT1);
         Result := PrintLn(StrLocalise(Loc[4]),LPT1);
         Result := PrintLn(StrCode(Code[4]),LPT1);
        End
         else
        Begin
         Result := PrintLn('Absent',LPT1);
        End;
       End;
       Result := Print(#13+#10,LPT1);
       (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)
       Result := Print(#13+#10+#13+#10,LPT1);
      End;
     End;
    End;
    Ferme(Files);
   End;
  End;
  Ferme(Handle);
 End;
End;

(*************************************************************************)

Procedure Rapport(Menu:Byte);
Begin
 Case Menu of
  30 : RapportComplet;
 End;
End;

(*************************************************************************)

BEGIN { Main Unit }
END.
