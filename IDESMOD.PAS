(************************************************************************)
(*                                                                      *)
(*                 Inventaire Description Modification                  *)
(*                              1992/04/24                              *)
(*                                                                      *)
(************************************************************************)

Unit IDesMod;

(************************************************************************)
                                Interface
(************************************************************************)

(************************************************************************)
                              Implementation
(************************************************************************)

Procedure ModifieDescription(Var Data:DescrType;Var Basse:Byte);
Label 10,20,30,40,50,60;
Const X = 20;
      Y = 2;
      Coul : Byte = $F0;
Var Position : LongInt;

 Procedure FixeLocalise(X,Y,Longeur:Byte;Var Chaine:String;Var Escape:Byte);
 Var Key      : KeyQuestionType;
     Basse    : Byte;
     Tableau  : Pointer;
 Begin
  FillChar(Key,SizeOf(Key),0);
  Escape := 0;
  SauveDerniereLigne(Tableau);
  Ecrit(2,24,'Entr‚ le code et appuyer sur <ENTER> ou <ESC> pour retourner',$F0);
  Question(X,Y,Chaine,Longeur,Key,True,Basse);
  FixeCurseurFermer;
  Escape := Basse;
  RestitueDerniereLigne(Tableau);
 End;

 Procedure FixeBody(X,Y,Longeur:Byte;Var Body,Escape:Byte);
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
  Key[5].Alt   := 'FAMILLIALE';
  Key[5].Ctrl  := 'FAMILLIALE';
  Key[7].Alt   := 'HATCH BACK 5P';
  Key[1].Alt  := 'HATCH BACK 3P';
  Key[15].Alt  := 'PICKUP';
  Key[15].Ctrl := 'PICKUP';
  Key[18].Alt  := 'SEDAN 2P';
  Key[0].Alt   := 'SEDAN 4P';
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(XH,YH,XH+31,YH+9,Coul);
  Ecrit(XH+2,YH+1,'Aide : ',Coul);
  EcritSpecial(XH+2,YH+3,#28'Alt-F  = Familliale'#1'Alt-H  = Hatch Back 5 portes'+
                   #1'Alt-B  = Hatch Back 3 portes'#1'Alt-P  = Pickup'#1+
                   'Alt-S  = Sedan 2 portes'#1'Alt-A  = Sedan 4 portes');
10:Question(X,Y,Chaine,Longeur,Key,True,Escape);
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
  RestituteEcran(Tableau);
  Ecrit(X,Y,Chaine,7);
 End;

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
10:Question(X,Y,Chaine,15,Key,True,Escape);
  FixeCurseurFermer;
  If(Escape = 0)Then
  Begin
   Val(Chaine,Milage,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Milage < 0)Then Goto 10;
  End;
 End;

 Procedure FixeDate(X,Y:Byte;Var Jour,Mois,Annee,Escape:Byte);
 Label 10,20,30;
 Var Chaine : String;
     Erreur : Word;
     Temp   : Word;
 Begin
10:FixeLocalise(X,Y,2,Chaine,Escape);
  If(Escape = 0)Then
  Begin
   Val(Chaine,Jour,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Jour > 31)or(Jour = 0)Then Goto 10;
 20:FixeLocalise(X+3,Y,2,Chaine,Escape);
   If(Escape = 0)Then
   Begin
    Val(Chaine,Mois,Erreur);
    If(Erreur <> 0)Then Goto 20;
    If(Mois > 12)or(Mois = 0)Then Goto 20;
  30:FixeLocalise(X+6,Y,4,Chaine,Escape);
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

 Procedure ActualiseEcran;
 Begin
  EcritSpecial(X+2,Y+3,#28'Num‚ro s‚rie :'+Data.NumSerie+#1+
                       'ModŠle : '+Modele+#1+
                       'Body :'+FormatBody(Data.Body)+#1+
                       'Couleur :'+Data.Couleur+#1+
                       'Milage :'+Strg(Milage)+#1+
                       'Date : 'Date(Data.Jour,Data.Mois,Data.Annee);
 End;

Begin
 If(MemW[$0040:$63] = $3B4)Then Coul := $F0
                           Else Coul := $9F;
 FillChar(Data,SizeOf(Data),0);
 With Data do
 Begin
  Basse := 0;
   { Initialise Ecran }
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+38,Y+9,Coul);
  Ecrit(X+2,Y+1,'Description :',Coul);
  EcritSpecial(X+2,Y+3,#28'Num‚ro s‚rie :'#1'ModŠle : '#1'Body :'#1+
                       'Couleur :'#1'Milage :'#1'Date : JJ/MM/AAAA');
10:FixeLocalise(X+17,Y+3,20,NumSerie,Basse);
  If(NumSerie <> '')Then
  Begin
   Position := RechercheDescription(Data,1);
   If(Position <> -1)Then ActualiseEcran;
  End;
  If(Basse = 2)Then Goto 60;
  If(Basse in [0,3])Then
  Begin
20:FixeLocalise(X+11,Y+4,20,Modele,Basse);
   If(Basse = 2)Then Goto 10;
   If(Basse in [0,3])Then
   Begin
30: FixeBody(X+9,Y+5,15,Body,Basse);
    If(Basse = 2)Then Goto 20;
    If(Basse in [0,3])Then
    Begin
40 : FixeLocalise(X+12,Y+6,10,Couleur,Basse);
     If(Basse = 2)Then Goto 30;
     If(Basse in [0,3])Then
     Begin
50 :  FixeMilage(X+11,Y+7,Milage,Basse);
      If(Basse = 2)Then Goto 40;
      If(Basse in [0,3])Then
      Begin
60 :   FixeDate(X+9,Y+8,Jour,Mois,Annee,Basse);
       If(Basse = 2)Then Goto 50;
      End;
     End;
    End;
   End;
  End;
 End;
End;

BEGIN
END.