Unit IReseau;

Interface

Uses DOS,
     Reseau,
     IFichier,
     IDescr,
     IEnreg;

Implementation

Const Titre : String[4] = '   '#0;

Var Enregistrement : Record
                      Inst : DescrType;
                      Data : EnregistrementType;
                     End;

Procedure Interruption28;
Interrupt;
Var Escape : Boolean;
Begin
 InLine($CD/$80);
 If(Config.Mode = Maitre)Then
 Begin
  If(Call('   ','   ',0) = 0)Then
  Begin
   Receive;
   Hand_Up(0);
   If(ErreurReseau = 0)Then
   Begin
    SauveEnregistrement(Enregistrement.Inst,Enregistrement.Data,Escape);
   End;
  End;
 End;
End;

BEGIN
 Move(Titre[1],Recoit.CallName,4);
 Move(Titre[2],Recoit.Name,4);
 Move(Titre[1],Envoi.CallName,4);
 Move(Titre[2],Envoi.Name,4);
 Recoit.Length := SizeOf(Enregistrement);
 Envoi.Length  := SizeOf(Enregistrement);
 Recoit.Buffer := @Enregistrement;
 Envoi.Buffer  := @Enregistrement;
 SetIntVec($28,@Interruption28);
END.