(*************************************************************************)
(*                                                                       *)
(*                          Inventaire Intro                             *)
(*                               1992/04/28                              *)
(*                                                                       *)
(* Avertissement : þ Les constantes techniques ne doive pas ˆtre modifi‚ *)
(*                   si vous n'avez pas un connaisse complŠte du systŠme *)
(*                   et des cartes vid‚o.                                *)
(*                                                                       *)
(*************************************************************************)

Unit Intro   ;

(*************************************************************************)
                                  Interface
(*************************************************************************)

Uses Crt,EcrMono,IChaine,IVisuel,IMenu;

Procedure Introduction;

(*************************************************************************)
                               Implementation
(*************************************************************************)

Const  { Constante effet sp‚ciaux }

      Titre        = 'Inventaire';
      Version      = '1.1';
      Compagnie    = 'Les Chevaliers de Malte';
      NombreEtoile = 100;
      TypeEtoile   = 250;{ Code ASCII }
      NombreExplos = 5;  { Nombre Explosion }
      Clignotement = 0;  { 0 = Inactif, 1 = Actif }
      Delai        = 10; { Delai en microseconde  }
      DelaiPause   = 255; { Delai de la pause a la fin de l'affichage }

       { Constante Technique :

        Attention! Si vous ne savez avec exactitude se que cela signifie
                   ne modifiez surtout pas ces constantes sous risque de
                   provoqu‚ des confusions et mˆme de plant‚ le systŠme! }

      Adresse     : Word = $B000; { Segment vid‚o }
      Colonne     = 80;
      Ligne       = 25;
      TailleEcran = 4000;
      Espc        = 32;    { CaractŠre espace }
      BIOSRAM     = $0040; { Segment de la zone RAM du BIOS }
      PortMono    = $3B4;  { Porte monochrome }

 { Note : þ Intro produit sur un ‚cran de taille 80x25 texte }

Procedure Introduction;
Label Exit;
Var Compteur : Byte;
    Y,X      : Byte;
    Tableau  : Pointer;
Begin
 FixeCurseurFermer;
 EffaceFenetre(0,0,Colonne-1,Ligne-1,15);
 FixeClignotement(1);
 For Compteur := 0 to NombreEtoile do
 Begin
  FixeUnCube(Random(Colonne),
             Random(Ligne),
             (TypeEtoile-1) + Random(2),
             (Random(2) * 8) + 7);
 End;
 GetMem(Tableau,4000);
 Move(Mem[Adresse:0],Tableau^,4000);
 For Compteur := 0 to (Colonne div 2)-1 do
 Begin
  Y := Trunc(Compteur * (Ligne/Colonne));
  X := (Colonne-1) - Compteur;
  FixeUnCaractere(Compteur,Y,TypeEtoile);
  FixeUnCaractere(X,Y,TypeEtoile);
  FixeUnCaractere(Compteur,(Ligne-1) - Y,TypeEtoile);
  FixeUnCaractere(X,(Ligne-1) - Y,TypeEtoile);
  Delay(Delai);
  FixeUnCaractere(Compteur,Y,Espc);
  FixeUnCaractere(X,Y,Espc);
  FixeUnCaractere(Compteur,(Ligne-1) - Y,Espc);
  FixeUnCaractere(X,(Ligne-1) - Y,Espc);
  If(MemW[BIOSRAM:$1A] <> MemW[BIOSRAM:$1C])Then Goto Exit; { Presse un touche ? }
 End;
 FixeClignotement(Clignotement);
 For Compteur := 0 to NombreExplos do
 Begin
  EffaceFenetre(0,0,Colonne-1,(Ligne-1),$F0);
  Delay(Delai);
  Move(Tableau^,Mem[Adresse:0],TailleEcran);
  Delay(Delai);
  If(MemW[BIOSRAM:$1A] <> MemW[BIOSRAM:$1C])Then Goto Exit; { Presse un touche ? }
 End;
 For Compteur := 0 to (Colonne div 4)-1 do
 Begin
  Y := Trunc(Compteur * (Ligne/Colonne));
  EffaceFenetre(((Colonne div 2)-1)-Compteur,12-Y,
                ((Colonne div 2)-1)+Compteur,Y+12,CoulDcr);
  Delay(Delai);
  If(MemW[BIOSRAM:$1A] <> MemW[BIOSRAM:$1C])Then Goto Exit; { Presse un touche ? }
 End;
 FixeCadreVide(((Colonne div 2)-1)-Compteur,12-Y,
               ((Colonne div 2)-1)+Compteur,12+Y,CoulDcr);
 CentreEcriture(9,Titre,CoulDcr);
 CentreEcriture(11,'Version '+Version,CoulDcr);
 CentreEcriture(13,'par',CoulDcr);
 CentreEcriture(15,Compagnie,CoulDcr);
 EcritDerLigne('Presse une touche ou attend 3 secondes...');
 For Compteur := 0 to DelaiPause do
 Begin
  If(MemW[BIOSRAM:$1A] <> MemW[BIOSRAM:$1C])Then Goto Exit; { Presse un touche ? }
  Delay(Delai);
 End;
 Exit : FreeMem(Tableau,TailleEcran);
 BarMenu;
 EffaceLigne(24,32,CoulBar);
End;

BEGIN
 If(MemW[BIOSRAM:$63] <> PortMono)Then Adresse := $B800;
 Introduction;
END.
