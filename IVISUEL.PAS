(****************************************************************)
(*                                                              *)
(*                      Inventaire Visuel                       *)
(*                         1992/04/08                           *)
(*                                                              *)
(* Compagnie   : Les Chevaliers de Malte                        *)
(* Concepteur  : Sylvain Maltais                                *)
(* Programmeur : Sylvain Maltais                                *)
(*                                                              *)
(* Description : þ Gestion visuel compl‚mentaire du programme   *)
(*                 Inventaire.                                  *)
(* RequŠres    : þ Une carte graphics solution d'ATI.           *)
(*                 en mode texte monochrome (07h).              *)
(*               þ Turbo Pascal 6 ou post‚rieur.                *)
(*                                                              *)
(****************************************************************)

Unit IVisuel;

{$V-}

(****************************************************************)
                            Interface
(****************************************************************)

Uses EcrMono,IClavier,IChaine;

 { La texture du peut ˆtre change avec un simple mots.

   Exemple :

    si vous d‚sirez avoir une testure avec B.Jutras, il suffit de marquer
   TextureFont := 'B.Jutras' et de demander la tapiserie et le tour est
   jou‚. }

Const Colonne     = 80;

      TextureFont : String[Colonne] = '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±';
      CoulHlp     : Byte = $F0;
      CoulMnu     : Byte = $F0;
      CoulTap     : Byte = $70;
      CoulDcr     : Byte = $F0;
      CoulErr     : Byte = $F0;
      CoulBar     : Byte = $F0;
      CoulSlc     : Byte = $07;
      CoulTch     : Byte = $F0;

Type StrNumSerie = String[20];

Procedure AfficheBar(Position,Couleur:Byte);
Procedure BarDeplacement;
Procedure BarOuiouNon;
Procedure BarSerieVert(Nombre:Byte;Var Buffer;Couleur:Byte);
Procedure BarTableHori(X1,Y,X2,Couleur:Byte);
Procedure BarTableVert(X,Y1,Y2,Couleur:Byte);
Procedure BaseVisuel(X1,Y1,X2,Y2,Nombre:Byte;Var Buffer;Prix,Localise,Code:ShortInt);
Procedure CadreGauche(X1,Y1,X2,Y2,Couleur:Byte);
Procedure DemiCadre(X1,Y1,X2,Y2,Couleur:Byte);
Procedure DeplacementFenetre(Var Tableau:Pointer);
Procedure DetermineFormatBar(Var Nombre:Byte;Var Buffer);
Procedure EcritDerLigne(Chaine:String);
Procedure Ecrit_OuiNon(X,Y:Byte;Chaine:String);
Procedure EffaceEcran;
Procedure FixeBodyUD(X,Y,Longeur:Byte;Var Body,Escape:Byte);
Procedure FixeDateUD(X,Y:Byte;Var Jour,Mois,Annee,Escape:Byte);
Procedure FixeDollar(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Procedure FixeDollarUD(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Procedure FixeLocalise(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);
Procedure FixeLocaliseUD(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);
Procedure FixeMilageUD(X,Y:Byte;Var Milage:LongInt;Var Escape:Byte);
Procedure FixeFormatBar(Nombre:Byte;Var Buffer);
Procedure FixeFormatDouble;
Procedure FixeFormatSimple;
Procedure FixeUneBar(Position,Numero,Couleur:Byte);
Procedure RestituteEcran(Var Tableau:Pointer);
Procedure RestitueDerniereLigne(Var Tableau:Pointer);
Procedure SauveDerniereLigne(Var Tableau:Pointer);
Procedure SauvegardeEcran(Var Tableau:Pointer);
Procedure Tapiserie(Mots:String);
Procedure ToucheTab(YMax,XMax:Byte;Touche:Word;Var Position,XPos,Actif:Byte);

Function AfficheBarTouche(Position,Numero,CouleurA,CouleurB:Byte):Word;
Function MiniMenu(X1,Y1,X2,Y2:Byte;Var XTabBar;Titre,Choix:String):ShortInt;
Function NumeroSerie(Var NumSerie:StrNumSerie):ShortInt;
Function RepOuiNon(X,Y:Byte):Byte;

(****************************************************************)
                          Implementation
(****************************************************************)

Const FormatCadreDouble : TypeCadre = (201,205,187,186,186,200,205,188,205);

      Ligne   = 24;     { Nombre ligne -1 }
      Adresse  : Word = $B800;  { Segment Ecran }
      TEcran  = 4000;   { Taille ‚cran }

Var TabBar : Array[0..26] of Byte;
    BarNum : Byte;

(****************************************************************)
(*                                                              *)
(* Description : þ Affiche la bar sp‚cifi‚ par                  *)
(*                 "DetermineFormatBar"                         *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure AfficheBar(Position,Couleur:Byte);
Begin
 BarSelecteHori(TabBar[0],TabBar[1]+Position,TabBar[(BarNum-1)*3 + 2],Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Function AfficheBarTouche(Position,Numero,CouleurA,CouleurB:Byte):Word;
Begin
 FixeUneBar(Position,Numero,CouleurA);
 AfficheBarTouche := LitClavier;
 FixeUneBar(Position,Numero,CouleurB);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure efface en blanc claire la    *)
(*                 derniŠre ligne et y affiche un message :     *)
(*                 "Utilis‚ les flŠches pour les d‚placements   *)
(*                 et <Insert> pour ajouter."                   *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BarDeplacement;
Begin
 EffaceLigne(Ligne,32,CoulBar);
 Ecrit(2,Ligne,'Utilis‚ les flŠches pour les d‚placements et <Insert> pour ajouter.',CoulBar);
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure efface en blanc claire la    *)
(*                 derniŠre ligne et y affiche un message :     *)
(*                 "Taper <O> pour Oui, <N> pour Non ou <ESC>   *)
(*                 pour retourner."                             *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BarOuiouNon;
Begin
 EffaceLigne(Ligne,32,CoulBar);
 Ecrit(2,Ligne,'Taper <O> pour Oui, <N> pour Non ou <ESC> pour retourner.',CoulBar);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BarTableHori(X1,Y,X2,Couleur:Byte);
Begin
 FixeUnCube(X1,Y,199,Couleur);
 BarTexteHori(X1+1,Y,X2-1,196,Couleur);
 FixeUnCube(X2,Y,182,Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BarTableVert(X,Y1,Y2,Couleur:Byte);
Begin
 FixeUnCube(X,Y1,209,Couleur);
 BarTexteVert(X,Y1+1,Y2-1,179,Couleur);
 FixeUnCube(X,Y1+2,197,Couleur);
 FixeUnCube(X,Y2,207,Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BarSerieVert(Nombre:Byte;Var Buffer;Couleur:Byte);
Var Compteur : Byte;
    Temp     : Word;
    BSeg     : Word;
    BOfs     : Word;
Begin
 BSeg := Seg(Buffer);
 BOfs := Ofs(Buffer);
 For Compteur := 0 to Nombre - 1 do
 Begin
  Temp := BOfs + (Compteur * 3);
  BarTableVert(Mem[BSeg:Temp],Mem[BSeg:Temp+1],Mem[BSeg:Temp+2],Couleur);
 End;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure BaseVisuel(X1,Y1,X2,Y2,Nombre:Byte;Var Buffer;Prix,Localise,Code:ShortInt);
Begin
 FixeCurseurFermer;
 If(Code > 0)Then
 Begin
  FixeFormatCadre(FormatCadreDouble);
  FixeCadrePlain(X1,Y1,X2,Y2,15);
  BarTableHori(X1,Y1+2,X2,15);
  Ecrit(Code,Y1+1,'Code hollander',14);
 End
  Else
 Begin
  CadreGauche(X1,Y1,X2,Y2,15);
  FixeUnCube(X1,Y1+2,199,15);
  BarTexteHori(X1+1,Y1+2,X2,196,15);
 End;
 BarSerieVert(Nombre,Buffer,15);
 Ecrit(X1+2,Y1+1,'PiŠce',14);
 Ecrit(Prix,Y1+1,'Prix',14);
 Ecrit(Localise,Y1+1,'Localise',14);
 BarDeplacement;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure CadreGauche(X1,Y1,X2,Y2,Couleur:Byte);
Begin
 EffaceFenetre(X1+1,Y1+1,X2,Y2-1,Couleur);
 BarTexteHori(X1+1,Y1,X2,205,Couleur);
 FixeUnCube(X1,Y1,201,Couleur);
 BarTexteVert(X1,Y1+1,Y2-1,186,Couleur);
 FixeUnCube(X1,Y2,200,Couleur);
 BarTexteHori(X1+1,Y2,X2,205,Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure DemiCadre(X1,Y1,X2,Y2,Couleur:Byte);
Begin
 EffaceFenetre(X1,Y1+1,X2-1,Y2-1,Couleur);
 BarTexteHori(X1,Y1,X2-1,205,Couleur);
 FixeUnCube(X2,Y1,187,Couleur);
 BarTexteVert(X2,Y1+1,Y2-1,186,Couleur);
 FixeUnCube(X2,Y2,188,Couleur);
 BarTexteHori(X1,Y2,X2-1,205,Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure DeplacementFenetre(Var Tableau:Pointer);
Var Compteur : Byte;
    Segment  : Word;
    OffSet   : Word;
    Temp     : Word;
    Chaine   : String;
    Longeur  : Byte;
    Decalage : Byte;
Begin
 SauvegardeEcran(Tableau);
 OffSet  := Ofs(Tableau^);
 Segment := Seg(Tableau^) + OffSet shr 4;
 OffSet  := (OffSet and 15) + Colonne;
 For Compteur := 1 to Ligne-1 do
 Begin
  Temp := Compteur * (Colonne*2);
  Move(Mem[Segment:Offset+Temp],Mem[Adresse:Temp],Colonne);
 End;
 Chaine := '';
 Longeur := (Colonne div Length(TextureFont)) + 1;
 For Compteur := 1 to Longeur do IncStr(Chaine,TextureFont);
 Decalage := 1;
 Chaine := Copy(Chaine,1,Colonne);
 For Compteur := 1 to Ligne-1 do
 Begin
  Ecrit(40,Compteur,Copy(Copy(Chaine,Decalage * Compteur,Colonne)+
                    Copy(Chaine,1,Decalage * Compteur),
                    Colonne div 2,Colonne div 2),CoulTap);
 End;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure DetermineFormatBar(Var Nombre:Byte;Var Buffer);
Begin
 If(Nombre > 8)Then Nombre := 8;
 Move(TabBar,Buffer,Nombre*3);
 Nombre := BarNum;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure EcritDerLigne(Chaine:String);
Begin
 EffaceLigne(Ligne,32,CoulBar);
 Ecrit(2,Ligne,Chaine,CoulBar);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure Ecrit_OuiNon(X,Y:Byte;Chaine:String);
Var Compteur : Byte;
    Couleur  : Byte;
Begin
 For Compteur := 0 to Length(Chaine)-1 do
 Begin
  If(Chaine[Compteur+1] in ['O','N'])Then Couleur := 9
                                     Else Couleur := 15;
  FixeUnCube(X+Compteur,Y,Ord(Chaine[Compteur+1]),Couleur);
 End;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure EffaceEcran;
Begin
 EffaceFenetre(0,0,Colonne-1,Ligne,7);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeFormatBar(Nombre:Byte;Var Buffer);
Begin
 If(Nombre > 8)Then Nombre := 8;
 Move(Buffer,TabBar,Nombre*3);
 BarNum := Nombre;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeUneBar(Position,Numero,Couleur:Byte);
Begin
 Numero := Numero * 3;
 BarSelecteHori(TabBar[Numero],Position+TabBar[Numero+1],TabBar[Numero+2],Couleur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeFormatSimple;
Const Cadre : TypeCadre = (218,196,191,179,179,192,196,217,196);
Begin
 FixeFormatCadre(Cadre);
End;

Procedure FixeFormatDouble;
Begin
 FixeFormatCadre(FormatCadreDouble);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Function RepOuiNon(X,Y:Byte):Byte;
Var Touche : Word;
    Basse  : Byte;
Begin
 FixePositionCurseur(X,Y);
 FixeCurseurOuvert;
 BarOuiouNon;
 Repeat
  Touche := AfficheTouche(X,Y);
  Basse  := Ord(MajChar(Chr(Lo(Touche))));
 Until (Basse in [27,78,79]);
 If(Basse = 78)Then RepOuiNon := 0 else
 If(Basse = 79)Then RepOuiNon := 1
               Else RepOuiNon := 2;
 FixeCurseurFermer;
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure transfŠre le contenu de la   *)
(*                 m‚moire vers ‚cran texte monochrome de 80x25.*)
(*                                                              *)
(*                  Ecran                  Buffer               *)
(*                   0 1    2 3 ...         0 1    2 3 ...      *)
(*                  ÚÄÂÄÄÄÄÂÄÂÄÄúú         ÚÄÂÄÄÄÄÂÄÂÄÄúú       *)
(*                 0³A³Bleu³l³Blanc  ÄÄ>  0³A³Bleu³l³Blanc      *)
(*                  ÃÄÅÄÄÄÄÅÄÅÄúú          ÃÄÅÄÄÄÄÅÄÅÄúú        *)
(*                 1³T³Bleu³o³Blanc       1³T³Bleu³o³Blanc      *)
(*                                                              *)
(* Note        : þ Les caractŠres et son attribut sont          *)
(*                 restitu‚s.                                   *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure RestituteEcran(Var Tableau:Pointer);
Begin
 Move(Tableau^,Mem[Adresse:0],TEcran);
 FreeMem(Tableau,TEcran);
 Tableau := Nil;
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure transfŠre le contenu d'un    *)
(*                 ‚cran texte monochrome de 80x25 en m‚moire.  *)
(*                                                              *)
(*                  Ecran                  Buffer               *)
(*                   0 1    2 3 ...         0 1    2 3 ...      *)
(*                  ÚÄÂÄÄÄÄÂÄÂÄÄúú         ÚÄÂÄÄÄÄÂÄÂÄÄúú       *)
(*                 0³A³Bleu³l³Blanc  ÄÄ>  0³A³Bleu³l³Blanc      *)
(*                  ÃÄÅÄÄÄÄÅÄÅÄúú          ÃÄÅÄÄÄÄÅÄÅÄúú        *)
(*                 1³T³Bleu³o³Blanc       1³T³Bleu³o³Blanc      *)
(*                                                              *)
(* Note        : þ Cette proc‚dure n'efface pas le contenu de   *)
(*                 l'‚cran.                                     *)
(*               þ Les caractŠres et son attribut sont          *)
(*                 sauvegard‚s.                                 *)
(*               þ Pour afficher le contenu en m‚moire …        *)
(*                 l'‚cran, voir "RestituteEcran".              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure SauvegardeEcran(Var Tableau:Pointer);
Begin
 Tableau := Nil;
 GetMem(Tableau,TEcran);
 Move(Mem[Adresse:0],Tableau^,TEcran);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure SauveDerniereLigne(Var Tableau:Pointer);
Begin
 Tableau := Nil;
 GetMem(Tableau,Colonne*2);
 Move(Mem[Adresse:TEcran-Colonne*2],Tableau^,Colonne*2);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure RestitueDerniereLigne(Var Tableau:Pointer);
Begin
 Move(Tableau^,Mem[Adresse:TEcran-Colonne*2],Colonne*2);
 FreeMem(Tableau,Colonne*2);
 Tableau := Nil;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Function MiniMenu(X1,Y1,X2,Y2:Byte;Var XTabBar;Titre,Choix:String):ShortInt;
Var Tableau  : Pointer;
    Serie    : Pointer;
    Touche   : Word;
    Basse    : Byte;
    Position : Byte;
    Longeur  : Byte;
    Nombre   : Byte;
Begin
 Nombre  := (Y2 - Y1) - 4;
 Longeur := (BarNum * 3) + 2;
 GetMem(Serie,Longeur);
 Move(TabBar,Serie^,Longeur);
 FixeFormatBar(1,XTabBar);
 SauvegardeEcran(Tableau);
 FixeFormatCadre(FormatCadreDouble);
 FixeCadrePlain(X1,Y1,X2,Y2,$F0);
 Ecrit(X1+2,Y1+1,Titre,$F0);
 EcritSpecial(X1+3,Y1+3,#3+'ð'+Choix);
 Position := 0;
 Repeat
  Touche := AfficheBarTouche(Position,0,15,$F0);
  Basse  := Lo(Touche);
  If(Basse = 0)Then TraiteScanCode(Position,Nombre,Touche);
 Until (Basse in [13,27]);
 If(Basse = 27)Then MiniMenu := -1
               Else MiniMenu := Position;
 RestituteEcran(Tableau);
 Move(Serie^,TabBar,Longeur);
 FreeMem(Serie,Longeur);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeDollar(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Label V1;
Var Chaine   : String;
    Key      : KeyQuestionType;
    Compteur : Byte;
    Basse    : Byte;
    TCent    : Byte;
    Erreur   : Integer;
    Tableau  : Pointer;
    Stool    : Boolean;
Begin
 Escape := 0;
 FillChar(Chaine,SizeOf(Chaine),0);
 FillChar(Key,SizeOf(Key),0);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Entr‚ le nombre et appuyer sur <ENTER> ou <ESC> pour retourner');
 If(Prix = 0)and(Cent = 0)Then Chaine := '' else
 If(Cent > 0)Then Chaine := Strg(Prix) + '.' + Strg(Cent)
             Else Chaine := Strg(Prix);
V1:Question(X,Y,Chaine,Longeur,Key,False,Basse);
 FixeCurseurFermer;
 If(Basse = 0)Then
 Begin
  If(Length(Chaine)=1)Then
  Begin
   Val(Chaine,Prix,Erreur);
   If(Erreur <> 0)Then
   Begin
    Write(^G);
    Goto V1;
   End;
  End
   else
  Begin
   Stool := False;
   For Compteur := 1 to Length(Chaine) do
   Begin
    If(Chaine[Compteur] = ',')Then
    Begin
     Chaine[Compteur] := '.';
     Stool := True;
    End;
    If(Chaine[Compteur] = '.')Then Stool  := True;
   End;
   If(Stool = False)Then
   Begin
    Erreur := 0;
    Prix   := 0;
    Val(Chaine,Prix,Erreur);
    Escape := 0;
    Exit;
   End;
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
  End;
  Cent := TCent;
 End
  else
 Escape := 1;
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeDollarUD(X,Y,Longeur:Byte;Var Prix:Word;Var Cent,Escape:Byte);
Label V1;
Var Chaine   : String[15];
    Temp     : String[15];
    Key      : KeyQuestionType;
    Compteur : Byte;
    Basse    : Byte;
    TCent    : Byte;
    Erreur   : Integer;
    Tableau  : Pointer;
    Stool    : Boolean;
Begin
 Escape := 0;
 FillChar(Key,SizeOf(Key),0);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Entr‚ le nombre et appuyer sur <ENTER> ou <ESC> pour retourner');
 If(Prix = 0)and(Cent = 0)Then Chaine := '' else
 If(Cent > 0)Then Chaine := Strg(Prix) + '.' + Strg(Cent)
             Else Chaine := Strg(Prix);
V1:Question(X,Y,Chaine,Longeur,Key,True,Basse);
 FixeCurseurFermer;
 If(Basse = 0)Then
 Begin
  If(Length(Chaine)=1)Then
  Begin
   Val(Chaine,Prix,Erreur);
   If(Erreur <> 0)Then
   Begin
    Write(^G);
    Goto V1;
   End;
  End
   else
  Begin
   Stool := False;
   For Compteur := 1 to Length(Chaine) do
   Begin
    If(Chaine[Compteur] = ',')Then
    Begin
     Chaine[Compteur] := '.';
     Stool := True;
    End;
    If(Chaine[Compteur] = '.')Then Stool  := True;
   End;
   If(Stool = False)Then
   Begin
    Erreur := 0;
    Prix   := 0;
    Val(Chaine,Prix,Erreur);
    Escape := 0;
    Exit;
   End;
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
  End;
  Cent := TCent;
 End
  else
 Escape := Basse;
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeLocalise(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);
Label 10;
Var Chaine   : String;
    Key      : KeyQuestionType;
    Basse    : Byte;
    Tableau  : Pointer;
    Compteur : Byte;
Begin
 Escape := 0;
 FillChar(Chaine,SizeOf(Chaine),0);
 Chaine := Localise;
 FillChar(Key,SizeOf(Key),0);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Entr‚ le code et appuyer sur <ENTER> ou <ESC> pour retourner');
10:Question(X,Y,Chaine,Longeur,Key,False,Basse);
 FixeCurseurFermer;
 If(Basse = 0)Then
 Begin
  Longeur := Length(Chaine);
  Chaine  := Maj(Chaine);
  For Compteur := Longeur downto 1 do
  Begin
   If Not(Chaine[Compteur] in ['0'..'9',' ','-','(',')','A'..'Z'])Then Goto 10;
  End;
  Localise := Chaine;
 End
  Else
 Escape := 1;
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeLocaliseUD(X,Y,Longeur:Byte;Var Localise:String;Var Escape:Byte);
Label 10;
Var Chaine   : String;
    Key      : KeyQuestionType;
    Basse    : Byte;
    Tableau  : Pointer;
    Compteur : Byte;
Begin
 FillChar(Chaine,SizeOf(Chaine),0);
 Chaine := Localise;
 Escape := 0;
 FillChar(Key,SizeOf(Key),0);
 SauveDerniereLigne(Tableau);
 EcritDerLigne('Entr‚ le code et appuyer sur <ENTER> ou <ESC> pour retourner');
10:Question(X,Y,Chaine,Longeur,Key,True,Escape);
 Basse := Escape;
 FixeCurseurFermer;
 If(Basse <> 1)Then
 Begin
  Longeur := Length(Chaine);
  Chaine  := Maj(Chaine);
  If(Basse = 0)Then
  Begin
   For Compteur := Longeur downto 1 do
   Begin
    If Not(Chaine[Compteur] in ['0'..'9',' ','-','(',')','A'..'Z'])Then Goto 10;
   End;
  End;
  Localise := Chaine;
 End
  Else
 Escape := 1;
 RestitueDerniereLigne(Tableau);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure Tapiserie(Mots:String);
Var Chaine   : String;
    Compteur : Byte;
    Longeur  : Byte;
    Decalage : Byte;
Begin
 Chaine := '';
 Longeur := (Colonne div Length(Mots)) + 1;
 For Compteur := 1 to Longeur do IncStr(Chaine,Mots);
 Decalage := 1;
 Chaine := Copy(Chaine,1,Colonne);
 For Compteur := 1 to Ligne do
 Begin
  Ecrit(0,Compteur,Copy(Copy(Chaine,Decalage * Compteur,Colonne)+
                   Copy(Chaine,1,Decalage * Compteur),1,Colonne),CoulTap);
 End;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure ToucheTab(YMax,XMax:Byte;Touche:Word;Var Position,XPos,Actif:Byte);
Begin
 TraiteScanCode(Position,YMax,Touche);
 Case Hi(Touche) of
  75 : Min(XPos,XMax);
  77 : Max(XPos,XMax);
  83 : Begin
        Actif := 0;
        AfficheBar(Position,7);
        Max(Position,YMax);
       End;
 End;
End;

(****************************************************************)
(*                                                              *)
(* Description : þ Cette proc‚dure demande le num‚ro s‚rie.     *)
(* Note        : þ Une fois la question pos‚ il ne laisse pas   *)
(*                 trace … l'‚cran.                             *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Function NumeroSerie(Var NumSerie:StrNumSerie):ShortInt;
Var Tableau : Pointer;
    Escape  : Byte;
Begin
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain((Colonne-36) div 2,12,((Colonne-36) div 2)+36,14,$F0);
 Ecrit(((Colonne-36) div 2)+1,13,'Num‚ro s‚rie :',$F0);
 FixeLocalise(((Colonne-36) div 2)+16,13,20,NumSerie,Escape);
 RestituteEcran(Tableau);
 If(Escape = 0)Then NumeroSerie := 0
               Else NumeroSerie := -1;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeBodyUD(X,Y,Longeur:Byte;Var Body,Escape:Byte);
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
 Key[1].Alt   := 'HATCH BACK 3P';
 Key[15].Alt  := 'PICKUP';
 Key[15].Ctrl := 'PICKUP';
 Key[18].Alt  := 'SEDAN 2P';
 Key[0].Alt   := 'SEDAN 4P';
 SauvegardeEcran(Tableau);
 FixeFormatDouble;
 FixeCadrePlain(XH,YH,XH+31,YH+9,CoulHlp);
 Ecrit(XH+2,YH+1,'Aide : ',CoulHlp);
 EcritSpecial(XH+2,YH+3,#28'Alt-F  = Familliale'#1'Alt-H  = Hatch Back 5 portes'+
                  #1'Alt-B  = Hatch Back 3 portes'#1'Alt-P  = Pickup'#1+
                  'Alt-S  = Sedan 2 portes'#1'Alt-A  = Sedan 4 portes');
 If(Body > 1)Then Chaine := FormatBody(Body)
             Else Chaine := '';
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
   Else
  If(Escape = 0)Then Goto 10;
 End;
 RestituteEcran(Tableau);
 Ecrit(X,Y,Chaine,7);
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeMilageUD(X,Y:Byte;Var Milage:LongInt;Var Escape:Byte);
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
 End
  else
 Begin
  Val(Chaine,Milage,Erreur);
 End;
End;

(****************************************************************)
(*                                                              *)
(* RequŠre     : þ Une carte vid‚o graphics Solutions.          *)
(*                                                              *)
(****************************************************************)

Procedure FixeDateUD(X,Y:Byte;Var Jour,Mois,Annee,Escape:Byte);
Label 10,20,30;
Var Chaine : String;
    Erreur : Word;
    Temp   : Word;
Begin
10:If(Jour > 0)Then Chaine := Strg(Jour)
               Else Chaine := '';
 FixeLocaliseUD(X,Y,2,Chaine,Escape);
 If(Escape = 0)Then
 Begin
  Val(Chaine,Jour,Erreur);
  If(Erreur <> 0)Then Goto 10;
  If(Jour > 31)or(Jour = 0)Then Goto 10;
20:If(Mois > 0)Then Chaine := Strg(Mois)
               Else Chaine := '';
  FixeLocaliseUD(X+3,Y,2,Chaine,Escape);
  If(Escape = 0)Then
  Begin
   Val(Chaine,Mois,Erreur);
   If(Erreur <> 0)Then Goto 20;
   If(Mois > 12)or(Mois = 0)Then Goto 20;
30:If(Annee > 0)Then Chaine := Strg(Annee+1902)
                Else Chaine := '';
   FixeLocaliseUD(X+6,Y,4,Chaine,Escape);
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

(****************************************************************)

Begin { Main Unit }
 BarNum := 0;
 FillChar(TabBar,SizeOf(TabBar),0);
 If(MemW[$0040:$63] = $3D4)Then { Ecran Couleur ? }
 Begin
  Adresse := $B800;
  CoulTap := $1B;
  CoulMnu := $F9;
  CoulHlp := $2F;
  CoulDcr := $9F;
  CoulErr := $CF;
  CoulBar := $F9;
  CoulSlc := $0B;
  CoulTch := $FC;
 End;
End.
