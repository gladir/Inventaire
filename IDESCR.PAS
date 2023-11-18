(*********************************************************************)
(* Description : Unit‚ de fixant la description du v‚hicule.         *)
(*********************************************************************)

Unit IDescr;

{$V-}

Interface

Uses EcrMono,IChaine,IClavier,IVisuel;

Type DescrType = Record
                  NumSerie : String[20];
                  Modele   : String[20];
                  Body     : Byte;
                  Couleur  : String[10];
                  Milage   : LongInt;
                  Jour     : Byte;
                  Mois     : Byte;
                  Annee    : Byte; { 1902 + Annee < 2158 }
                 End;

Procedure Description(Var Data:DescrType;Var Basse:Byte);
Procedure NouveauDescription(Var Data:DescrType;Var Basse:Byte);

Implementation

Procedure Description(Var Data:DescrType;Var Basse:Byte);
Label 10,20,30,40,50,60;
Const X = 20;
      Y = 2;
Var Chaine : String;
Begin
 With Data do
 Begin
  Basse := 0;
   { Initialise Ecran }
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+38,Y+9,CoulDcr);
  Ecrit(X+2,Y+1,'Description :',CoulDcr);
  If(Body > 1)Then Chaine := FormatBody(Body)
              Else Chaine := '';
  EcritSpecial(X+2,Y+3,#28'Num‚ro s‚rie : '+NumSerie+#1+
                       'ModŠle : '+Modele+#1+
                       'Body : '+Chaine+#1+
                       'Couleur : '+Couleur+#1+
                       'Milage : '+Strg(Milage)+#1+
                       'Date : JJ/MM/AAAA');
10:FixeLocaliseUD(X+17,Y+3,20,NumSerie,Basse);
  If(Basse = 2)Then Goto 60;
  If(Basse in [0,3])Then
  Begin
20:FixeLocaliseUD(X+11,Y+4,20,Modele,Basse);
   If(Basse = 2)Then Goto 10;
   If(Basse in [0,3])Then
   Begin
30: FixeBodyUD(X+9,Y+5,15,Body,Basse);
    If(Basse = 2)Then Goto 20;
    If(Basse in [0,3])Then
    Begin
40 : FixeLocaliseUD(X+12,Y+6,10,Couleur,Basse);
     If(Basse = 2)Then Goto 30;
     If(Basse in [0,3])Then
     Begin
50 :  FixeMilageUD(X+11,Y+7,Milage,Basse);
      If(Basse = 2)Then Goto 40;
      If(Basse in [0,3])Then
      Begin
60 :   FixeDateUD(X+9,Y+8,Jour,Mois,Annee,Basse);
       If(Basse = 2)Then Goto 50;
       If(Basse = 3)Then Goto 10;
      End;
     End;
    End;
   End;
  End;
 End;
End;

Procedure NouveauDescription(Var Data:DescrType;Var Basse:Byte);
Begin
 FillChar(Data,SizeOf(Data),0);
 Description(Data,Basse)
End;

End.
