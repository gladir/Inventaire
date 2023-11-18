(*********************************************************)
(* Description : Gestion des donn‚es du programme        *)
(*               Inventaire (0001).                      *)
(*********************************************************)

Unit IData;

(*********************************************************)
                        Interface
(*********************************************************)

Uses EcrMono,IVisuel,IClavier;

Procedure FixeDollar(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Procedure FixeLocalise(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);

(*********************************************************)
                      Implementation
(*********************************************************)

Procedure FixeDollar(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Label V1;
Var Chaine   : String;
    Key      : KeyQuestionType;
    Compteur : Byte;
    Basse    : Byte;
    TCent    : Byte;
    Erreur   : Integer;
    Tableau  : Pointer;
Begin
 Escape := 0;
 Chaine := '';
 For Compteur := 0 to 25 do
 Begin
  Key[Compteur].Alt    := '';
  Key[Compteur].Ctrl   := '';
  Key[Compteur].Action := 0;
 End;
 SauveDerniereLigne(Tableau);
 Ecrit(2,24,'Entr‚ le nombre et appuyer sur <ENTER> ou <ESC> pour retourner',$F0);
V1:Question(X,Y,Chaine,Longeur,Key,False,Basse);
 FixeCurseurFermer;
 If(Basse = 0)Then
 Begin
  Basse := Pos('.',Chaine);
  If(Basse = 0)Then
  Begin
   Basse := Length(Chaine);
   TCent := 0;
  End
   else
  Begin
   Val(Copy(Chaine,Basse+1,255),TCent,Erreur);
   If(Erreur <> 0)or(TCent > 99)Then
   Begin
    Write(^G);
    Goto V1;
   End;
  End;
  Val(Copy(Chaine,1,Basse-1),Prix,Erreur);
  If(Erreur <> 0)Then
  Begin
   Write(^G);
   Goto V1;
  End;
  Cent := TCent;
 End
  else
 Escape := 1;
 RestitueDerniereLigne(Tableau);
End;

Procedure FixeLocalise(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);
Var Chaine  : String;
    Key     : KeyQuestionType;
    Basse   : Byte;
    Tableau : Pointer;
Begin
 Escape := 0;
 Chaine := '';
 SauveDerniereLigne(Tableau);
 Ecrit(2,24,'Entr‚ le code et appuyer sur <ENTER> ou <ESC> pour retourner',$F0);
 Question(X,Y,Chaine,Longeur,Key,False,Basse);
 FixeCurseurFermer;
 If(Basse = 0)Then Localise := Chaine
              Else Escape := 1;
 RestitueDerniereLigne(Tableau);
End;

End.