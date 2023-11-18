(**********************************************************************)
(*                                                                    *)
(*                         Inventaire Efface                          *)
(*                             1992/05/16                             *)
(*                                                                    *)
(**********************************************************************)

Unit IEfface;

(**********************************************************************)
                               Interface
(**********************************************************************)

Uses DOS,     { Gestion DOS }
     Drivers,
     Print,
     Fichier,
     EcrMono,
     IDescr,
     IChaine,
     IClavier,
     IVisuel,
     IMenu,
     IClient,
     IFichier,
     IEnreg,
     ISlcPce;

Procedure Efface(Menu:Byte);

(**********************************************************************)
                             Implementation
(**********************************************************************)

Const TailleEcran = 4000;

Procedure Efface(Menu:Byte);
Const Couleur   = #3;
      Multiplie = #4;
Type NumeroSerieType = String[20];
Var Touche : Word;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Function NumeroSerie(Var Numero:NumeroSerieType;CoulDcr:Byte):Byte;
 Var Tableau : Pointer;
     Escape  : Byte;
     Chaine  : String;
 Begin
  NumeroSerie := 0;
   { Pr‚paration ‚cran }
  SauvegardeEcran(Tableau);
  FixeFormatDouble;
  FixeCadrePlain(20,10,71,14,CoulDcr);
  EcritSpecial(22,12,Couleur+Chr(CoulDcr)+
                     'Entrez le num‚ro de serie ['#4+#20' ]');
   { Lecture du num‚ro du client }
  FillChar(Numero,SizeOf(Numero),0);
  FillChar(Chaine,SizeOf(Chaine),0);
  Repeat
   FixeLocalise(49,12,20,Chaine,Escape);
   Numero := Maj(Chaine);
   If(Escape = 1)Then
   Begin
    NumeroSerie := 1;
    RestituteEcran(Tableau);
    Exit;
   End;
  Until (Numero<>'');
  RestituteEcran(Tableau);
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _EffacePiece;
 Label Debut,V10,Fin;
 Var Reponse        : Byte;
     Enregistrement : EnregistrementType;
     Tableau        : Pointer;
     Position       : Byte;
     Temp           : Byte;
     Numero         : NumeroSerieType;
     Descr          : DescrType;
     Pos            : LongInt;
     Handle         : Integer;

  (*+-+*-*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*+-+*)

  Procedure FixeEnregistrement(Var Enregistrement:EnregistrementType;
                               Position,Reponse:Byte;Pos:LongInt);
  Var Handle : Integer;
  Begin
   Handle := Ouvre('INVENT.DAT',2);
   With Enregistrement do
   Begin
    Case Position of
     0 : If(Devant.AvantComplet.DevantComplet = 2)Then
         Begin
          Devant.AvantComplet.DevantComplet := 0;
         End
          else
         Begin
          Devant.Actif[Reponse]  := 0;
         End;
     1 : Cowl.DataActif[Reponse] := 0;
     2 : Porte.Actif[Reponse]    := 0;
     3 : If(Derriere.DataDerriereComplete.DerriereComplete = 2)Then
         Begin
          Derriere.DataDerriereComplete.DerriereComplete := 0;
         End
          else
         Begin
          Derriere.DataActif[Reponse] := 0;
         End;
     4 : If(Moteur.MoteurComplet.MoteurComplet = 2)Then
         Begin
          Moteur.MoteurComplet.MoteurComplet := 0;
         End
          else
         Begin
          Moteur.Actif[Reponse]     := 0;
         End;
     5 : PieceMoteur.Actif[Reponse] := 0;
     6 : If(Trans.Ass = 2)Then
         Begin
          Trans.Ass                 := 0;
         End
          else
         Begin
          Trans.Actif[Reponse]      := 0;
         End;
     7 : Frein.Actif[Reponse]       := 0;
     8 : Suspension.Actif[Reponse]  := 0;
     9 : Axle.Actif[Reponse]        := 0;
        End;
   End;
   ModifieEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
   Ferme(Handle);
  End;

 Begin { Main EffacePiece }
         Position := 0;
 Debut : FillChar(Enregistrement,SizeOf(Enregistrement),0);
         MenuEfface;
         BarSelecteHori(43,3,50,CoulSlc);
         Position := _SelectePiece(43,4,Position);
         BarSelecteHori(43+1,5+Position,43+15,CoulSlc);
         If(Position = 12)Then { Pneus ? }
         Begin
          Exit;
         End;
         SauvegardeEcran(Tableau);
         If(Position = 255)Then
         Begin
          RestituteEcran(Tableau);
          Exit;
         End;
   V10 : Temp := NumeroSerie(Numero,CoulDcr);
         If(Temp = 1)Then
         Begin
          RestituteEcran(Tableau);
          Goto Debut;
         End;
         Descr.NumSerie := Numero;
         Pos := RechercheDescription(Descr,1);
         If(Pos = -1)Then
         Begin
          EffaceLigne(24,32,CoulErr);
          Ecrit(2,24,'Auto introuvable, presse une touche pour retourner...',CoulErr);
          Touche := LitClavier;
          Goto Fin;
         End
          else
         Begin
          Handle := Ouvre('INVENT.DAT',0);
          FillChar(Enregistrement,TailleEnregistrement,0);
          LitEnregistrement(Handle,Pos,TailleEnregistrement,Enregistrement);
          Ferme(Handle);
         End;
         Reponse := ChoisiePiece(44,6,Position,Enregistrement);
         If(Reponse = 255)Then
         Begin
          RestituteEcran(Tableau);
          Goto V10;
         End;
         If(Position in [0..9])Then FixeEnregistrement(Enregistrement,Position,Reponse,Pos);
     Fin:FreeMem(Tableau,TailleEcran);
 End;

 (*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*)

 Procedure _EffaceAuto;
 Var Numero   : NumeroSerieType;
     Reponse  : Byte;
     Descr    : DescrType;
     Position : LongInt;
     Handle   : Integer;
 Begin
  Reponse := NumeroSerie(Numero,CoulErr);
  If(Reponse = 1)Then Exit;
  Descr.NumSerie := Numero;
  Position := RechercheDescription(Descr,1);
  If(Position <> -1)Then
  Begin
   Descr.NumSerie := 'å'+Copy(Descr.NumSerie,2,19);
   Handle := Ouvre('FILES.DAT',2);
   ModifieEnregistrement(Handle,Position,SizeOf(Descr),Descr);
   Ferme(Handle);
  End
   else
  Begin
   EffaceLigne(24,32,CoulErr);
   Ecrit(2,24,'Auto introuvable, presse une touche pour retourner...',CoulErr);
   Touche := LitClavier;
  End;
 End;

Begin { Main Efface }
 Case Menu of
   EffaceAuto : _EffaceAuto;
  EffacePiece : _EffacePiece;
 EffaceClient : SoustraitClient; { Voir unit‚ "ICLIENT" }
 End;
End;

BEGIN { Main Unit }
END.