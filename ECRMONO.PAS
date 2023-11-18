(************************************************************************)
(*  Unit‚        : Ecran Mono                                           *)
(*  Version      : pour IBM, 1.01                                       *)
(*  Description  : Gestion de l'‚cran texte monochrome                  *)
(************************************************************************)
(*  Groupe       : Les Chevaliers de Malte                              *)
(*  Auteur       : Sylvain Maltais                                      *)
(*  Date cr‚e    : 1991/03/17                                           *)
(*  Date modifi‚ : 1992/03/17                                           *)
(************************************************************************)
(*  RequŠre      : þ Turbo Pascal 6                                     *)
(*                 þ Carte vid‚o monochrome                             *)
(************************************************************************)

Unit EcrMono;

{$L+}

(*******************************************)
		 Interface
(*******************************************)

Type Binaire   = 0..1;
     TypeCadre = Array[0..8] of Byte;

Const OmbreEcrMono       : Binaire = 1;
      EspaceCadreEcrMono : Binaire = 0;

 { Gestion Mode Video }

Procedure FixeModeVideo(Mode:Byte);
Function  DetermineModeInitiale:Byte;

 { Gestion du Curseur }

Procedure DetermineFormatCurseur(Var Debut,Fin:Byte);
Procedure FixeCurseurFermer;
Procedure FixeFormatCurseur(Debut,Fin:Byte);
Procedure FixePositionCurseur(X,Y:Byte);
Procedure PositionCurseurDebut;
Procedure FixeCurseurOuvert;

Function XPosition:Byte;
Function YPosition:Byte;

 { Ecrit du texte }

Procedure CentreEcriture(Y:Byte;Phrase:String;Couleur:Byte);
Procedure Ecrit(X,Y:Byte;Phrase:String;Couleur:Byte);
Procedure EcritChoix(X,Y:Byte;Phrase:String;Couleur1,Couleur2:Byte);
Procedure EcritNombre(X,Y:Byte;Nombre:Word;Couleur:Byte);
Procedure EcritSpecial(X,Y:Byte;Phrase:String);
Procedure FixeUnCaractere(X,Y,Caractere:Byte);
Procedure FixeUnCube(X,Y,Caractere,Couleur:Byte);
Procedure FixeUnAttribut(X,Y,Couleur:Byte);

 { Gestion des palettes }

Procedure FixeClignotement(Nombre:Byte);

 { Cadre }

Procedure FixeCadrePlain(X1,Y1,X2,Y2,Couleur:Byte);
Procedure FixeCadreVide(X1,Y1,X2,Y2,Couleur:Byte);
Procedure FixeFormatCadre(Format:TypeCadre);

 { Figure }

Procedure BarSelecteHori(X1,Y,X2,Couleur:Byte);
Procedure BarSelecteVert(X,Y1,Y2,Couleur:Byte);
Procedure BarTexteHori(X1,Y,X2,Caractere,Couleur:Byte);
Procedure BarTexteVert(X,Y1,Y2,Caractere,Couleur:Byte);
Procedure EffaceFenetre(X1,Y1,X2,Y2,Couleur:Byte);
Procedure EffaceColonne(Colonne,Caractere,Couleur:Byte);
Procedure EffaceLigne(Ligne,Caractere,Couleur:Byte);
Procedure EffaceLigneTransparent(Ligne,Caractere:Byte);
Procedure FenetreTapiserie(X1,Y1,X2,Y2,MotifA,MotifB,AttributA,AttributB:Byte);
Procedure MouveFenetre(X1,Y1,X2,Y2,Couleur:Byte;Direction:Integer);
Procedure FixeTapiserie(Y1,Y2,MotifA,MotifB,AttributA,AttributB:Byte);

(*******************************************)
	       Implementation
(*******************************************)

Const Adresse     : Word = $B000;
      ColorNormal : Byte = 15;
      CadreFormat : TypeCadre = (218,196,191,179,179,192,196,217,196);

Procedure EcritNombre(X,Y:Byte;Nombre:Word;Couleur:Byte);
Var Chaine : String;
Begin
 Str(Nombre,Chaine);
 Ecrit(X,Y,Chaine,Couleur);
End;

Procedure DetermineFormatCurseur(Var Debut,Fin:Byte);
Begin
 Debut := Mem[$0040:$60];
 Fin   := Mem[$0040:$61];
End;

Procedure FixeFormatCurseur(Debut,Fin:Byte);
Assembler;
ASM MOV AX,$0040;
    MOV ES,AX;
    MOV DX,ES:[$63];
    MOV AL,$0A;
    MOV AH,Debut;
    OUT DX,AX;
    INC AL;
    MOV AH,Fin;
    OUT DX,AX;
End;

Function ModeActuel:Byte;
Begin
 ModeActuel := Mem[$0040:$49];
End;

Function Paire(Nombre:Word):Byte;
Begin
 Paire := Nombre and 1;
End;

Function Impaire(Nombre:Word):Byte;
Begin
 Impaire := 1 - (Nombre and 1);
End;

Function XPosition:Byte;
Begin
 XPosition := Mem[$0040:$50];
End;

Function YPosition:Byte;
Begin
 YPosition := Mem[$0040:$51];
End;

Procedure FixePositionCurseur(X,Y:Byte);
Assembler;
ASM MOV AX,$0040;
    MOV ES,AX;
    MOV AL,Y;
    MOV AH,80;
    MUL AH;
    XOR DH,DH;
    MOV DL,X;
    ADD AX,DX;
    MOV DX,ES:[$63];
    MOV BX,AX;
    MOV AH,BH;
    MOV AL,$0E;
    OUT DX,AX;
    INC AL;
    MOV AH,BL;
    OUT DX,AX;
End;

Procedure FixeCurseurFermer;
Assembler;
ASM MOV AX,$0040;
    MOV ES,AX;
    MOV DX,ES:[$63];
    MOV AX,$200A;
    OUT DX,AX;
    INC AL;
    OUT DX,AX;
END;

Procedure FixeCurseurOuvert;
Assembler;
Label V10,V20;
ASM MOV AX,$0040;
    MOV ES,AX;
    MOV DX,ES:[$63];
    CMP DX,$3B4;
    JNE V10;
    MOV AX,$0B0A;
    JMP V20;
V10:MOV AX,$060A;
V20:OUT DX,AX;
    INC AL;
    INC AH;
    OUT DX,AX;
END;

Procedure BarSelecteHori(X1,Y,X2,Couleur:Byte);
Var X : Byte;
Begin
 For X := X1 to X2 do FixeUnAttribut(X,Y,Couleur);
End;

Procedure BarSelecteVert(X,Y1,Y2,Couleur:Byte);
Var Y : Byte;
Begin
 For Y := Y1 to Y2 do FixeUnAttribut(X,Y,Couleur);
End;

Procedure EffaceFenetre(X1,Y1,X2,Y2,Couleur:Byte);
Assembler;
Label V0,V1,V2,V3;
ASM MOV DL,$20;
    MOV DH,Couleur;
    MOV DI,DX;
    MOV DL,X1;
    MOV DH,$50;
    MOV AX,Adresse;
    MOV ES,AX;
    MOV BL,X2;
    MOV BH,Y2;
    MOV CH,Y1;
 V0:MOV CL,DL;
    MOV AL,CH;
    MUL DH;
    MOV SI,AX;
    XOR AH,AH;
    MOV AL,CL;
    ADD SI,AX;
    SHL SI,1;
 V1:MOV ES:[SI],DI;
    CMP CL,BL;
    JGE V2;
    INC CL;
    INC SI;
    INC SI;
    JMP V1;
 V2:CMP CH,BH;
    JGE V3;
    INC CH;
    JMP V0;
 V3:
End;

Procedure FixeUnCaractere(X,Y,Caractere:Byte);
Assembler;
ASM MOV AL,Y;
    MOV AH,80;
    MUL AH;
    MOV BX,AX;
    XOR AH,AH;
    MOV AL,X;
    ADD BX,AX;
    SHL BX,1;
    MOV DL,Caractere;
    MOV AX,Adresse;
    MOV ES,AX;
    MOV ES:[BX],DL;
End;

Procedure FixeUnCube(X,Y,Caractere,Couleur:Byte);
Assembler;
ASM MOV AL,Y;
    MOV AH,80;
    MUL AH;
    MOV BX,AX;
    XOR AH,AH;
    MOV AL,X;
    ADD BX,AX;
    SHL BX,1;
    MOV DL,Caractere;
    MOV DH,Couleur;
    MOV AX,Adresse;
    MOV ES,AX;
    MOV ES:[BX],DX;
End;

Procedure EcritSpecial(X,Y:Byte;Phrase:String);
Var Compteur  : Byte;
    Boucle    : Byte;
    XPos      : Word;
    YPos      : Byte;
    Longeur   : Byte;
    Carac     : Byte;
    DerColor  : Byte;
    FixColor  : Byte;
    Caract    : Byte;
Begin
 XPos   := X;
 YPos   := Y;
 FixColor := 1;
 For Compteur := 0 to Length(Phrase)-1 do
 Begin
  Caract := Ord(Phrase[Compteur+1]);
  If(Caract > 31)Then
  Begin
   If(FixColor = 1)Then
   Begin
    FixeUnCube(XPos,YPos,Caract,ColorNormal);
   End
    else
   FixeUnCaractere(XPos,YPos,Caract);
   Inc(XPos);
  End
   else
  Case Phrase[Compteur+1] of
   #1 : Begin
         XPos := X;
         Inc(YPos);
        End;
   #3 : Begin
         Inc(Compteur);
         DerColor := ColorNormal;
         ColorNormal := Ord(Phrase[Compteur+1]);
        End;
   #4 : Begin
         Inc(Compteur,2);
         Longeur := Ord(Phrase[Compteur]);
         Carac   := Ord(Phrase[Compteur+1]);
         If(Longeur > 0)Then
         Begin
          For Boucle := 1 to Longeur do
          Begin
           FixeUnCube(XPos+Boucle,YPos,Carac,ColorNormal);
          End;
         End;
         Inc(XPos,Longeur);
        End;
   #9 : Begin
         For Boucle := 1 to 8 do FixeUnCube(XPos+Boucle,YPos,32,ColorNormal);
         Inc(XPos,7);
        End;
  #16 : Begin
         Inc(Compteur,2);
         XPos := Ord(Phrase[Compteur]);
         YPos := Ord(Phrase[Compteur+1]);
        End;
  #18 : Begin
         Boucle := ColorNormal;
         ColorNormal := DerColor;
         DerColor := Boucle;
        End;
  #28 : FixColor := 0;
  #29 : EffaceLigne(YPos,32,ColorNormal);
  #30 : Begin
         Inc(Compteur);
         Carac := Ord(Phrase[Compteur+1]);
         FixeUnCaractere(XPos,YPos,Carac);
         Inc(XPos);
        End;
  #31 : FixeUnAttribut(XPos,YPos,ColorNormal);
  End;
 End;
End;

Procedure BarTexteHori(X1,Y,X2,Caractere,Couleur:Byte);
Assembler;
Label V1,V2;
ASM MOV DL,Caractere;
    MOV DH,Couleur;
    MOV DI,DX;
    MOV DH,$50;
    MOV AX,Adresse;
    MOV ES,AX;
    MOV CL,X1;
    MOV BL,X2;
    MOV AL,Y;
    MUL DH;
    MOV SI,AX;
    XOR AH,AH;
    MOV AL,CL;
    ADD SI,AX;
    SHL SI,1;
 V1:MOV ES:[SI],DI;
    CMP CL,BL;
    JGE V2;
    INC CL;
    INC SI;
    INC SI;
    JMP V1;
 V2:
End;

Procedure BarTexteVert(X,Y1,Y2,Caractere,Couleur:Byte);
Assembler;
Label V0,V3;
ASM MOV DL,Caractere;
    MOV DH,Couleur;
    MOV DI,DX;
    MOV DL,X;
    MOV DH,$50;
    MOV AX,Adresse;
    MOV ES,AX;
    MOV BH,Y2;
    MOV CH,Y1;
 V0:MOV CL,DL;
    MOV AL,CH;
    MUL DH;
    MOV SI,AX;
    XOR AH,AH;
    MOV AL,CL;
    ADD SI,AX;
    SHL SI,1;
    MOV ES:[SI],DI;
    CMP CH,BH;
    JGE V3;
    INC CH;
    JMP V0;
 V3:
End;

Procedure FixeUnAttribut(X,Y,Couleur:Byte);
Begin
 Mem[Adresse:(X+Y*80)*2+1] := Couleur;
End;

Procedure Ecrit(X,Y:Byte;Phrase:String;Couleur:Byte);
Var Compteur : Byte;
    Color    : Word;
    Base     : Word;
Begin
 Base  := (X + Y * 80) * 2;
 Color := Couleur * 256;
 For Compteur := 1 to Length(Phrase) do
 Begin
  MemW[Adresse:Base] := Ord(Phrase[Compteur]) + Color;
  Inc(Base,2);
 End;
End;

Procedure EcritChoix(X,Y:Byte;Phrase:String;Couleur1,Couleur2:Byte);
Begin
 FixeUnCube(X,Y,Ord(Phrase[1]),Couleur1);
 Ecrit(X+1,Y,Copy(Phrase,2,255),Couleur2);
End;

Procedure CentreEcriture(Y:Byte;Phrase:String;Couleur:Byte);
Begin
 Ecrit((80 - Length(Phrase)) div 2,Y,Phrase,Couleur);
End;

Procedure FixeCadreVide(X1,Y1,X2,Y2,Couleur:Byte);
Begin
 BarTexteVert(X1,Y1+1,Y2-1,CadreFormat[3],Couleur);
 BarTexteVert(X2,Y1+1,Y2-1,CadreFormat[4],Couleur);
 BarTexteHori(X1+1,Y1,X2-1,CadreFormat[1],Couleur);
 BarTexteHori(X1+1,Y2,X2-1,CadreFormat[6],Couleur);
 FixeUnCube(X1,Y1,CadreFormat[0],Couleur);
 FixeUnCube(X1+1,Y1,CadreFormat[8],Couleur);
 FixeUnCube(X1,Y2,CadreFormat[5],Couleur);
 FixeUnCube(X2,Y1,CadreFormat[2],Couleur);
 FixeUnCube(X2,Y2,CadreFormat[7],Couleur);
End;

Procedure FixeCadrePlain(X1,Y1,X2,Y2,Couleur:Byte);
Begin
 EffaceFenetre(X1,Y1,X2,Y2,Couleur);
 If(OmbreEcrMono = 1)Then
 Begin
  BarSelecteHori(X1+2,Y2+1,X2+2,7);
  BarSelecteVert(X2+1,Y1+1,Y2+1,7);
  BarSelecteVert(X2+2,Y1+1,Y2+1,7);
 End;
 If(EspaceCadreEcrMono = 1)Then FixeCadreVide(X1+2,Y1+1,X2-2,Y2-1,Couleur)
		       	   Else FixeCadreVide(X1,Y1,X2,Y2,Couleur);
End;

Procedure EffaceColonne(Colonne,Caractere,Couleur:Byte);
Var Compteur : Byte;
Begin
 For Compteur := 0 to 24 do FixeUnCube(Colonne,Compteur,Caractere,Couleur);
End;

Procedure EffaceLigne(Ligne,Caractere,Couleur:Byte);
Begin
 BarTexteHori(0,Ligne,79,Caractere,Couleur);
End;

Procedure EffaceLigneTransparent(Ligne,Caractere:Byte);
Var Compteur : Byte;
    Base     : Word;
Begin
 Base := Ligne * 160;
 For Compteur := 0 to 79 do
 Begin
  Mem[Adresse:Base] := Caractere;
  Inc(Base,2);
 End;
End;

Procedure MouveFenetre(X1,Y1,X2,Y2,Couleur:Byte;Direction:Integer);
Var Longeur : Byte;
    XTemp   : Byte;

 Procedure BasVersHaut(X1,Y1,X2,Y2,Couleur:Byte);
 Var Compteur : Byte;
 Begin
  Longeur := (X2-X1{-1}) * 2;
  XTemp   := X1 + 1;
  For Compteur := Y1 to Y2-1 do
  Begin
   Move(Mem[Adresse:(XTemp+(Compteur+1)*80)*2],
        Mem[Adresse:(XTemp+Compteur*80)*2],
        Longeur);
  End;
  BarTexteHori(X1,Y2,X2,32,Couleur);
 End;

 Procedure HautVersBas(X1,Y1,X2,Y2,Couleur:Byte);
 Var Compteur : Byte;
 Begin
  Longeur := (X2-X1{-1}) * 2;
  XTemp   := X1 + 1;
  For Compteur := Y2-1 downto Y1 do
  Begin
   Move(Mem[Adresse:(XTemp+Compteur*80)*2],
        Mem[Adresse:(XTemp+(Compteur+1)*80)*2],
        Longeur);
  End;
  BarTexteHori(X1,Y1,X2,32,Couleur);
 End;

Begin
 If(Direction = -1)Then HautVersBas(X1,Y1,X2,Y2,Couleur) else
 If(Direction = +1)Then BasVersHaut(X1,Y1,X2,Y2,Couleur);
End;

Procedure FixeClignotement(Nombre:Byte);

 Procedure Clignotement(Nombre:Byte);
 Assembler;
 ASM MOV AX,$1003;
     MOV BL,Nombre;
     AND BL,1;
     INT $10
 End;

Begin
 Port[$3B8] := 8 + (Nombre and 1) * $20;
 Port[$3D8] := 1 + 4 + 8 + (Nombre and 1) * $20;
 Clignotement(Nombre);
End;

Procedure FixeModeVideo(Mode:Byte);
Assembler;
ASM MOV AL,Mode;
    XOR AH,AH;
    INT $10;
End;

Procedure FixeTapiserie(Y1,Y2,MotifA,MotifB,AttributA,AttributB:Byte);
Var Ligne    : Byte;
    Base     : Word;
    TempA    : Word;
    TempB    : Word;
    Compteur : Byte;
Begin
 TempA := MotifA + 256 * AttributA;
 TempB := MotifB + 256 * AttributB;
 For Ligne := Y1 to Y2 do
 Begin
  For Compteur := 0 to 39 do
  Begin
   Base  := Ligne * 80 + Compteur * 2;
   MemW[Adresse:(Base + Paire(Ligne))*2]   := TempA;
   MemW[Adresse:(Base + Impaire(Ligne))*2] := TempB;
  End;
 End;
End;

Procedure FenetreTapiserie(X1,Y1,X2,Y2,MotifA,MotifB,AttributA,AttributB:Byte);
Var Ligne    : Byte;
    Base     : Word;
    TempA    : Word;
    TempB    : Word;
    Deb      : Byte;
    Fin      : Byte;
    TLigne   : Word;
    Compteur : Byte;
Begin
 Deb   := X1 div 2;
 Fin   := X2 div 2;
 TempA := MotifA + 256 * AttributA;
 TempB := MotifB + 256 * AttributB;
 For Ligne := Y1 to Y2 do
 Begin
  TLigne := Ligne * 80;
  For Compteur := Deb to Fin do
  Begin
   Base := TLigne + Compteur * 2;
   MemW[Adresse:(Base+Paire(Ligne))*2]   := TempA;
   MemW[Adresse:(Base+Impaire(Ligne))*2] := TempB;
  End;
 End;
End;

Function DetermineModeInitiale:Byte;
Begin
 If(MemW[$0040:$10] and 48 in [16,32])Then DetermineModeInitiale := 3 else
 If(MemW[$0040:$10] and 48 = 48)Then DetermineModeInitiale := 7
  else
 Begin
  If(MemW[$0040:$63] = $3D4)Then DetermineModeInitiale := 3
			    Else DetermineModeInitiale := 7;
 End;
End;

Procedure PositionCurseurDebut;
Assembler;
ASM MOV AX,$0040;
    MOV ES,AX;
    MOV DX,ES:[$63];
    MOV AL,$0E;
    OUT DX,AL;
    INC DX;
    MOV AL,0;
    OUT DX,AL;
    DEC DX;
    MOV AL,$0F;
    OUT DX,AL;
    INC DX;
    MOV AL,0;
    OUT DX,AL;
End;

Procedure FixeFormatCadre(Format:TypeCadre);
Begin
 Move(Format,CadreFormat,9);
End;

BEGIN
 If(MemW[$0040:$63] = $3D4)Then Adresse := $B800;
END.