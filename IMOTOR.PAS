(***********************************************************************)
(*                                                                     *)
(*                          Inventaire Moteur                          *)
(*                             1992/04/08                              *)
(*                                                                     *)
(* Compagnie   : Les Chevaliers de Malte                               *)
(* Concepteur  : Sylvain Maltais                                       *)
(* Programmeur : Sylvain Maltais                                       *)
(*                                                                     *)
(* Description : þ Cette proc‚dure fixe le donn‚ de l'utilisateur vers *)
(*                 m‚moire.                                            *)
(* RequŠres    : þ Une carte graphics solution d'ATI (Small wonder).   *)
(*                 en mode texte monochrome (07h).                     *)
(*               þ Turbo Pascal 6 ou post‚rieur.                       *)
(*                                                                     *)
(***********************************************************************)

Unit IMotor;

{$V-}

(***********************************************************************)
                                Interface
(***********************************************************************)

Uses Drivers,EcrMono,IChaine,IClavier,IVisuel;

Const

      Nul              = 0;
      Nulle            = Nul;

      MinMoteur        = 0;
      MaxMoteur        = 9;
      MaxMotor         = MaxMoteur;
      MaxMotr          = MaxMoteur;
      MaxMot           = MaxMoteur;
      MaxMtr           = MaxMoteur;
      MinMotor         = MinMoteur;
      MinMotr          = MinMoteur;
      MinMot           = MinMoteur;
      MinMtr           = MinMoteur;

      SauteLigne       = #1;
      Couleur          = #3;
      Color            = Couleur;
      Transparent      = #28;
      Trans            = Transparent;

      LongeurCarburant = 6;
      LengthCarburant  = LongeurCarburant;

      GazStr           = 'Gaz   ';
      DieselStr        = 'Diesel';
      CarburateurStr   = 'Carburateur';

Type
      InjCarType       = String[11];
      CarburantType    = String[LongeurCarburant];
      CarType          = CarburantType;
      StrCarburant     = CarburantType;
      CarburantStr     = CarburantType;
      StrCar           = CarburantType;

Const

      ChoixInjCar    : Array[0..1] of InjCarType = ('Injection  ',
                                                    CarburateurStr);
      ChoixCarburant : Array[0..1] of CarburantType = (GazStr,DieselStr);

Type
     LocaliseType      = String[7];
     CodeHollanderType = String[7];
     CodeType          = CodeHollanderType;
     LocalisationType  = LocaliseType;
     MoteurCompletType = Record
                          MoteurComplet    : Byte;
                          Modele           : Byte;
                          Turbo            : Byte;
                          Carburant        : Byte;
                          NombreCylindre   : Byte;
                          Mesure           : Byte;
                          Nombre           : Word;
                          SousNombre       : Byte;
                          ValesParCylindre : Byte;
                          Categorie        : Byte;
                          Milage           : LongInt;
                          Localise         : LocaliseType;
                          Prix             : Word;
                          Cent             : Byte;
                          Code             : CodeHollanderType;
                         End;
     MoteurType = Record
                   MoteurComplet : MoteurCompletType;
                   Actif         : Array[MinMtr..MaxMtr] of Byte;
                   Prix          : Array[MinMot..MaxMot] of Word;
                   Cent          : Array[MinMotr..MaxMotr] of Byte;
                   Pos           : Array[MinMotor..MaxMotor] of LocalisationType;
                   Code          : Array[MinMoteur..MaxMoteur] of CodeType;
                   MoteurTete    : Byte;
                  End;

Procedure AfficheMoteur(X,Y,Couleur:Byte);
Procedure FixeMotor(Var Moteur:MoteurType;Var Escape:Boolean);

(***********************************************************************)
                           Implementation
(***********************************************************************)

Procedure AfficheMoteur(X,Y,Couleur:Byte);
Begin
 EcritSpecial(X,Y,Color + Chr(Couleur) +
                  'Cam Shaft' + SauteLigne +
                  'Tˆte moteur' + SauteLigne +
                  'Timing couer' + SauteLigne +
                  'Pane huile' + SauteLigne +
                  'Carburateur' + SauteLigne +
                  'Injection' + SauteLigne +
                  'Pompe essence' + SauteLigne +
                  'Pompe eau' + SauteLigne +
                  'Manifault Exhaust' + SauteLigne +
                  'Manifault Intake');
End;

(***********************************************************************)

Procedure MoteurAssembler(Var Moteur:MoteurType;Var Escape:Boolean);
Label 10,20,30,40,50,60,70,80,90,100,110,120;
Const ChoixX : Array[0..1] of String[12] = ('Coil Pack   ',
                                            'Distributeur');
      ChoixM : Array[0..1] of String[30] = ('Japon  Nombre : úúúúú.úú CC   ',
                                            'U.S.   Nombre : úúúúú.úú Litre');
      STurbo  : Array[0..1] of String[6] = ('Turbo ','Normal');
Var Touche : Word;
    Basse  : Byte;

 Procedure FixeMilage(X,Y:Byte;Var Milage:LongInt;Var Escape:Byte);
 Label 10;
 Var Key      : KeyQuestionType;
     Chaine   : String;
     Erreur   : Word;
 Begin
  Escape := 0;
   { Initiation data }
  FillChar(Key,SizeOf(Key),0);
  If(Milage > 0)Then Str(Milage,Chaine)
                Else Chaine := '';
10:Question(X,Y,Chaine,7,Key,False,Escape);
  FixeCurseurFermer;
  If(Escape = 0)Then
  Begin
   Val(Chaine,Milage,Erreur);
   If(Erreur <> 0)Then Goto 10;
   If(Milage < 0)Then Goto 10;
  End;
 End;

Begin
 Escape := False;
 EcritSpecial(2,4,#28'Injection'#1+
              'Turbo'#1+
              'Diezel'#1+
              ' 3  4  5  6L V6 V8 <- Nombre cylindre'#1+
              'Japan Nombre : úúúúú.úú CC'#1+
              ' 2  3  4  <- Vales par cylindre'#1+
              'Distributeur'#1+
              'Milage : úúúúúúú'#1+
              'Prix : úúúúú.úúú'#1+
              'Localisation : úúúúúúú'#1+
              'Code hollander : úúúúúúú');
10:Repeat
  FixeUnCaractere(1,4,16);
  Ecrit(2,4,ChoixInjCar[Moteur.MoteurComplet.Modele],$F0);
  Touche := LitClavier;
  Ecrit(2,4,ChoixInjCar[Moteur.MoteurComplet.Modele],15);
  FixeUnCaractere(1,4,32);
  Case Touche of
         kbESC : Begin
                  Escape := True;
                  Exit;
                 End;
        kbLeft : Min(Moteur.MoteurComplet.Modele,1);
 kbRight,kbIns : Max(Moteur.MoteurComplet.Modele,1);
          kbUp : Goto 120;
  End;
 Until (Touche = kbEnter)or(Touche = kbDown);
20:Repeat
  FixeUnCaractere(1,5,16);
  Ecrit(2,5,STurbo[Moteur.MoteurComplet.Turbo],$F0);
  Touche := LitClavier;
  Ecrit(2,5,STurbo[Moteur.MoteurComplet.Turbo],15);
  FixeUnCaractere(1,5,32);
  Case Touche of
           kbESC : Begin
                    Escape := True;
                    Exit;
                   End;
          kbLeft : Min(Moteur.MoteurComplet.Turbo,1);
   kbRight,kbIns : Max(Moteur.MoteurComplet.Turbo,1);
            kbUp : Goto 10;
  End;
 Until (Touche = kbEnter)or(Touche = kbDown);
30:Repeat
  FixeUnCaractere(1,6,16);
  Ecrit(2,6,ChoixCarburant[Moteur.MoteurComplet.Carburant],$F0);
  Touche := LitClavier;
  Ecrit(2,6,ChoixCarburant[Moteur.MoteurComplet.Carburant],15);
  FixeUnCaractere(1,6,32);
  Case Touche of
           kbESC : Begin
                    Escape := True;
                    Exit;
                   End;
          kbLeft : Min(Moteur.MoteurComplet.Carburant,1);
   kbRight,kbIns : Max(Moteur.MoteurComplet.Carburant,1);
            kbUp : Goto 20;
  End;
 Until (Touche = kbEnter)or(Touche = kbDown);
40:Repeat
  FixeUnCaractere(2+Moteur.MoteurComplet.NombreCylindre*3,7,62);
  BarSelecteHori(2+Moteur.MoteurComplet.NombreCylindre*3,7,
                 4+Moteur.MoteurComplet.NombreCylindre*3,$F0);
  Touche := LitClavier;
  BarSelecteHori(2+Moteur.MoteurComplet.NombreCylindre*3,7,
                 4+Moteur.MoteurComplet.NombreCylindre*3,15);
  Case Touche of
        kbESC : Begin
                 Escape := True;
                 Exit;
                End;
       kbLeft : Begin
                 FixeUnCaractere(2+Moteur.MoteurComplet.NombreCylindre*3,7,32);
                 Min(Moteur.MoteurComplet.NombreCylindre,5);
                End;
kbRight,kbIns : Begin
                 FixeUnCaractere(2+Moteur.MoteurComplet.NombreCylindre*3,7,32);
                 Max(Moteur.MoteurComplet.NombreCylindre,5);
                End;
         kbUp : Goto 30;
  End;
 Until (Touche = kbEnter)or(Touche = kbDown);
50:Repeat
  FixeUnCaractere(1,8,16);
  Ecrit(2,8,ChoixM[Moteur.MoteurComplet.Mesure],$F0);
  Touche := LitClavier;
  Ecrit(2,8,ChoixM[Moteur.MoteurComplet.Mesure],15);
  FixeUnCaractere(1,8,32);
  Case Touche of
           kbESC : Begin
                    Escape := True;
                    Exit;
                   End;
          kbLeft : Min(Moteur.MoteurComplet.Mesure,1);
   kbRight,kbIns : Max(Moteur.MoteurComplet.Mesure,1);
            kbUp : Goto 40;
  End;
 Until (Touche = kbEnter)or(Touche = kbDown);
60:FixeUnCaractere(1,8,16);
 FixeDollarUD(18,8,8,Moteur.MoteurComplet.Nombre,
                     Moteur.MoteurComplet.SousNombre,Basse);
 FixeUnCaractere(1,8,32);
 If(Basse = 2)Then Goto 50;
 If(Basse = 3)Then Basse := 0;
 If(Basse = 1)Then Escape := True
  else
 Begin
70:Repeat
   FixeUnCaractere(2+Moteur.MoteurComplet.ValesParCylindre*3,9,62);
   BarSelecteHori(2+Moteur.MoteurComplet.ValesParCylindre*3,9,
                  4+Moteur.MoteurComplet.ValesParCylindre*3,$F0);
   Touche := LitClavier;
   BarSelecteHori(2+Moteur.MoteurComplet.ValesParCylindre*3,9,
                  4+Moteur.MoteurComplet.ValesParCylindre*3,15);
   Case Touche of
        kbESC : Begin
                 Escape := True;
                 Exit;
                End;
       kbLeft : Begin
                 FixeUnCaractere(2+Moteur.MoteurComplet.ValesParCylindre*3,9,32);
                 Min(Moteur.MoteurComplet.ValesParCylindre,2);
                End;
kbRight,kbIns : Begin
                 FixeUnCaractere(2+Moteur.MoteurComplet.ValesParCylindre*3,9,32);
                 Max(Moteur.MoteurComplet.ValesParCylindre,2);
                End;
         kbUp : Goto 60;
   End;
  Until (Touche = kbEnter)or(Touche = kbDown);
80:Repeat
   FixeUnCaractere(1,10,16);
   Ecrit(2,10,ChoixX[Moteur.MoteurComplet.Categorie],$F0);
   Touche := LitClavier;
   Ecrit(2,10,ChoixX[Moteur.MoteurComplet.Categorie],15);
   FixeUnCaractere(1,10,32);
   Case Touche of
            kbESC : Begin
                     Escape := True;
                     Exit;
                    End;
           kbLeft : Min(Moteur.MoteurComplet.Categorie,1);
    kbRight,kbIns : Max(Moteur.MoteurComplet.Categorie,1);
             kbUp : Goto 70;
   End;
  Until (Touche = kbEnter)or(Touche = kbDown);
90:FixeUnCaractere(1,11,16);
  FixeMilageUD(11,11,Moteur.MoteurComplet.Milage,Basse);
  FixeUnCaractere(1,11,32);
  If(Basse = 2)Then Goto 80;
  If(Basse = 3)Then Basse := 0;
  If(Basse = 1)Then Escape := True
   else
  Begin
100:FixeUnCaractere(1,12,16);
   FixeDollarUD(9,12,9,Moteur.MoteurComplet.Prix,Moteur.MoteurComplet.Cent,Basse);
   FixeUnCaractere(1,12,32);
   If(Basse = 2)Then Goto 90;
   If(Basse = 3)Then Basse := 0;
   If(Basse = 1)Then Escape := True
    else
   Begin
110:FixeUnCaractere(1,13,16);
    FixeLocaliseUD(17,13,7,Moteur.MoteurComplet.Localise,Basse);
    FixeUnCaractere(1,13,32);
    If(Basse = 2)Then Goto 100;
    If(Basse = 3)Then Basse := 0;
    If(Basse = 1)Then Escape := True
     else
    Begin
120: FixeUnCaractere(1,14,16);
     FixeLocaliseUD(19,14,7,Moteur.MoteurComplet.Code,Basse);
     FixeUnCaractere(1,14,32);
     If(Basse = 2)Then Goto 110;
     If(Basse = 3)Then Goto 10;
     If(Basse = 1)Then Escape := True;
     If(Basse = 0)Then Escape := False;
    End;
   End;
  End;
 End;
End;

(***********************************************************************)

Procedure FixeMotor(Var Moteur:MoteurType;Var Escape:Boolean);
Label V0,V1,V3,V7,V8;
Const Position : Byte = 0;
      XPos     : Byte = 0;
      XD       = 2;
      YD       = 2;
      TabBar   : Array[0..14] of Byte = (XD+1,YD+4,XD+19,XD+21,YD+4,XD+29,
                                         XD+31,YD+4,XD+43,XD+45,YD+4,XD+54,
                                         XD+56,YD+4,XD+71);
      SerieVer : Array[0..11] of Byte = (XD+20,YD+1,YD+14,XD+30,YD+1,YD+14,
                                         XD+44,YD+1,YD+14,XD+55,YD+1,YD+14);
Var Touche   : Word;
    Basse    : Byte;
    Ancien   : Word;
    Couleur  : Byte;
    Compteur : Byte;
    kbAncien : Word Absolute $0040:$1A;

 Procedure TeteMoteur(X,Y:Byte;Var Result:Byte);
 Var Touche  : Word;
     Tableau : Pointer;
 Begin
  Result := 0;
  Inc(Y);
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(X,Y,X+20,Y+5,$F0);
  EcritSpecial(X+1,Y+1,Trans+'Tˆte de moteur :' + SauteLigne +
                       SauteLigne +
                       ' ' + ChoixInjCar[0] + SauteLigne +
                       ' ' + ChoixInjCar[1]);
  Repeat
   BarSelecteHori(X+1,Y+3+Result,X+19,7);
   Touche := LitClavier;
   BarSelecteHori(X+1,Y+3+Result,X+19,$F0);
   TraiteScanCode(Result,1,Touche);
   Case Touche of
    kbESC : Begin
             RestituteEcran(Tableau);
             Result := 255;
             Exit;
            End;
   End;
  Until (Touche = kbEnter);
  RestituteEcran(Tableau);
  Dec(Y);
  Ecrit(X,Y,ChoixInjCar[Result],15);
 End;

Begin

  { Initialise donnee }
 If(Moteur.MoteurComplet.MoteurComplet > 2)Then
 Begin
  FillChar(Moteur.MoteurComplet,SizeOf(Moteur.MoteurComplet),Nulle);
 End;
 FixeFormatBar(5,TabBar);
 Escape := False;

  { Initialise Ecran }
 FixeCurseurFermer;
 FixeClignotement(0);
 FixeFormatDouble;
 FixeCadrePlain(0,1,39,15,15);
  { Fixe les paramŠtres }
 Ecrit_OuiNon(2,2,'Moteur Complet (O/N) ?');
 Basse := RepOuiNon(25,2);
 FixeCurseurFermer;
 If(Basse = 2)Then
 Begin
  Escape := True;
  Exit;
 End
  else
 If(Basse = 0)Then { Non, D‚sassembl‚ }
 Begin
   { Initialise donnee }
  For Compteur := 0 to 9 do
  Begin
   If(Moteur.Actif[Compteur] > 1)or
     (Moteur.Cent[Compteur] > 100)or
     (Length(Moteur.Pos[Compteur]) > 7)or
     (Length(Moteur.Code[Compteur]) > 7)Then
   Begin
    Moteur.Actif[Compteur] := Nul;
    Moteur.Prix[Compteur]  := Nul;
    Moteur.Cent[Compteur]  := Nul;
    FillChar(Moteur.Pos[Compteur],SizeOf(Moteur.Pos[Compteur]),Nulle);
    FillChar(Moteur.Code[Compteur],SizeOf(Moteur.Code[Compteur]),Nulle);
   End;
  End;
  Moteur.MoteurComplet.MoteurComplet := 1;
   { Initialise Ecran }
  BaseVisuel(XD,YD+1,XD+72,YD+14,4,SerieVer,XD+22,XD+46,XD+57);
  Ecrit(XD+32,YD+2,'Description',14);
  AfficheMoteur(XD+2,YD+4,7);
  For Compteur := 0 to 9 do
  Begin
   If(Moteur.Prix[Compteur] > 0)or
     (Moteur.Cent[Compteur] > 0)Then
   Begin
    Ecrit(XD+22,YD+4+Compteur,Strg(Moteur.Prix[Compteur])+','+
                              Strg(Moteur.Cent[Compteur]),7+Moteur.Actif[Compteur] * 8);
   End
    else
   If(Moteur.Prix[Compteur] > 0)Then
   Begin
    Ecrit(XD+22,YD+4+Compteur,Strg(Moteur.Prix[Compteur])+'$',
                              7 + Moteur.Actif[Compteur] * 8);
   End;
   Ecrit(XD+44,YD+4+Compteur,Moteur.Pos[Compteur],7+Moteur.Actif[Compteur] * 8);
   Ecrit(XD+54,YD+4+Compteur,Moteur.Code[Compteur],7+Moteur.Actif[Compteur] * 8);
   AfficheBar(Compteur,7+Moteur.Actif[Compteur] * 8);
  End;
  Repeat
   Ancien  := kbAncien;
   Touche  := AfficheBarTouche(Position,XPos,$F0,Moteur.Actif[Position] * 8 + 7);
   Basse   := Lo(Touche);
   Case Basse of
    9 : Max(XPos,4);
48..57,65..90,97..112 : Begin
                         If(XPos in [1,3,4])Then kbAncien := Ancien;
                         Case XPos of
                          1 : Goto V0;
                          3 : Goto V3;
                          4 : Begin
                               If(Basse in [48..57])Then Goto V7
                                                    Else Touche := LitClavier;
                              End;
                         End;
                        End;
    0 : Begin
         ToucheTab(9,4,Touche,Position,XPos,Moteur.Actif[Position]);
         If(Hi(Touche) = 82)Then
         Begin
          Case XPos of
           0 : Max(Moteur.Actif[Position],1);
           1 : Begin
             V0:FixeDollar(XD+22,YD+4+Position,8,
                Moteur.Prix[Position],Moteur.Cent[Position],Basse);
               End;
           2 : Begin
                Case Position of
                 1 : Begin
                      TeteMoteur(XD+32,YD+5,Basse);
                      If(Basse < 255)Then Moteur.MoteurTete := Basse;
                     End;
                End;
               End;
           3 : Begin
             V3:FixeLocalise(XD+46,YD+4+Position,7,Moteur.Pos[Position],Basse);
               End;
           4 : Begin
             V7:FixeLocalise(XD+57,YD+4+Position,7,Moteur.Code[Position],Basse);
               End;
          End;
          If(XPos > 0)and(Basse = 0)Then Moteur.Actif[Position] := 1;
          AfficheBar(Position,7 + Moteur.Actif[Position] * 8);
          Max(Position,MaxMoteur);
          V8:
         End;
        End;
   End;
  Until (Touche = kbEnter)or(Touche = kbESC);
  If(Touche = kbESC)Then Escape := True;
 End
  else
 Begin { Oui, Complet }
  Moteur.MoteurComplet.MoteurComplet := 2;
  MoteurAssembler(Moteur,Escape);
 End;
End;

(***********************************************************************)

BEGIN
END.
