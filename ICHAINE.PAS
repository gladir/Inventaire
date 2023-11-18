(*******************************************************************)
(*                                                                 *)
(*                        Inventaire Chaine                        *)
(*                           1992/04/12                            *)
(*                                                                 *)
(*******************************************************************)

Unit IChaine;

{$V-}

(*******************************************************************)
                             Interface
(*******************************************************************)

Procedure FixeBit8(Var Tableau,Valeur,Position:Byte);
Procedure FixeBit16(Var Tableau:Word;Valeur,Position:Byte);
Procedure FixeBit32(Var Tableau:LongInt;Valeur,Position:Byte);
Procedure IncStr(Var Chaine:String;Complement:String);
Procedure Min(Var Variable:Byte;Max:Byte);
Procedure Max(Var Variable:Byte;Maximum:Byte);

Function Bin2(Nombre:Byte):String;
Function Bin4(Nombre:Word):String;
Function Date(Jour,Mois,Annee:Byte):String;
Function EffaceStr(Chaine:String;Pos,Num:Byte):String;
Function FormatBody(Numero:Byte):String;
Function GetAlphaDecimal(Nombre:Byte):Byte;
Function GetStrAlphaDec(Chaine:String):LongInt;
Function GetBit8(Tableau,Position:Byte):Byte;
Function GetBit16(Tableau:Word;Position:Byte):Byte;
Function GetBit32(Tableau:LongInt;Position:Byte):Byte;
Function Hex2(Nombre:Byte):String;
Function Hex4(Nombre:Word):String;
Function MajChar(Carac:Char):Char;
Function Maj(Chaine:String):String;
Function Strg(Nombre:LongInt):String;

(*******************************************************************)
                         Implementation
(*******************************************************************)

Const PaletteHex : Array[0..15] of Char = '0123456789ABCDEF';

Function EffaceStr(Chaine:String;Pos,Num:Byte):String;
Begin
 If(Chaine <> '')and(Length(Chaine) > 1)Then
 Begin
  If(Pos+Num > Length(Chaine))Then EffaceStr := Copy(Chaine,1,Pos-1)
   else
  Begin
   Delete(Chaine,Pos,Num);
   EffaceStr := Chaine;
  End;
 End
  else
 EffaceStr := '';
End;

Procedure IncStr(Var Chaine:String;Complement:String);
Begin
 Chaine := Chaine + Complement;
End;

Function MajChar(Carac:Char):Char;
Begin
 If(Carac > #96)and(Carac < #123)Then MajChar := Chr(Ord(Carac) - 32) else
 If(Carac in ['€','‡'])Then MajChar := 'C' else
 If(Carac in ['','–','—','š','£'])Then MajChar := 'U' else
 If(Carac in ['‚','ˆ','‰','Š',''])Then MajChar := 'E' else
 If(Carac in ['ƒ','„','…','†','Ž','',' ','¦'])Then MajChar := 'A' else
 If(Carac in ['‹','Œ','','¡'])Then MajChar := 'I' else
 If(Carac in ['“','”','•','™','¢','§'])Then MajChar := 'O' else
 If(Carac in ['¤','¥'])Then MajChar := 'N' else
 If(Carac = '˜')Then MajChar := 'Y' else
 If(Carac = '‘')Then MajChar := '’'
  else
 MajChar := Carac;
End;

Function Maj(Chaine:String):String;
Var Compteur : Byte;
    Phrase   : String;
    Carac    : Char;
Begin
 Phrase := '';
 For Compteur := 1 to Length(Chaine) do
 Begin
  IncStr(Phrase,MajChar(Chaine[Compteur]));
 End;
 Maj := Phrase;
End;

Function Hex2(Nombre:Byte):String;
Begin
 Hex2 := PaletteHex[Nombre shr 4] +
         PaletteHex[Nombre and 15];
End;

Function Hex4(Nombre:Word):String;
Begin
 Hex4 := PaletteHex[Nombre shr 12] +
         PaletteHex[(Nombre shr 8) and 15] +
         PaletteHex[(Nombre shr 4) and 15] +
         PaletteHex[Nombre and 15];
End;

Function Bin2(Nombre:Byte):String;
Var Temp     : String;
    Compteur : Byte;
Begin
 Temp := '';
 For Compteur := 7 downto 0 do
 Begin
  Temp := Chr(((Nombre shr Compteur) and 1)+48);
 End
End;

Function Bin4(Nombre:Word):String;
Var Temp     : String;
    Compteur : Byte;
Begin
 Temp := '';
 For Compteur := 15 downto 0 do
 Begin
  Temp := Chr(((Nombre shr Compteur) and 1)+48);
 End
End;

Function GetAlphaDecimal(Nombre:Byte):Byte;
Begin
 If(Nombre > 64)Then GetAlphaDecimal := Nombre - 55
                Else GetAlphaDecimal := Nombre - 48;
End;

Function GetStrAlphaDec(Chaine:String):LongInt;
Var Tableau  : Array[0..255] of Byte;
    Compteur : Byte;
    Temp     : LongInt;

 Function Fois37(Nombre,Fois:Byte):LongInt;
 Var Temp     : LongInt;
     Compteur : Byte;
 Begin
  Temp := Nombre;
  For Compteur := Fois downto 0 do Temp := Temp * 37;
  Fois37 := Temp;
 End;

Begin
 Temp := 0;
 Move(Chaine,Tableau,SizeOf(Chaine));
 For Compteur := Tableau[0] downto 1 do
 Begin
  Temp := Temp + Fois37(GetAlphaDecimal(Tableau[Compteur]),Compteur);
 End;
 GetStrAlphaDec := Temp;
End;

Procedure FixeBit8(Var Tableau,Valeur,Position:Byte);
Var Masque : Byte;
Begin
 Masque := Not(1 shl Position);
 Tableau := (Tableau and Masque) + ((Valeur and 1) shl Position);
End;

Function GetBit8(Tableau,Position:Byte):Byte;
Begin
 GetBit8 := (Tableau shr Position) and 1;
End;

Procedure FixeBit16(Var Tableau:Word;Valeur,Position:Byte);
Var Masque : Word;
Begin
 Masque  := Not(1 shl Position);
 Tableau := (Tableau and Masque) + ((Valeur and 1) shl Position);
End;

Function GetBit16(Tableau:Word;Position:Byte):Byte;
Begin
 GetBit16 := (Tableau shr Position) and 1;
End;

Procedure FixeBit32(Var Tableau:LongInt;Valeur,Position:Byte);
Var Masque : LongInt;
Begin
 Masque  := Not(1 shl Position);
 Tableau := (Tableau and Masque) + ((Valeur and 1) shl Position);
End;

Function GetBit32(Tableau:LongInt;Position:Byte):Byte;
Begin
 GetBit32 := (Tableau shr Position) and 1;
End;

Procedure Min(Var Variable:Byte;Max:Byte);
Begin
 If(Variable > 0)Then Dec(Variable)
                 Else Variable := Max;
End;

Procedure Max(Var Variable:Byte;Maximum:Byte);
Begin
 If(Variable < Maximum)Then Inc(Variable)
                       Else Variable := 0;
End;

Function FormatBody(Numero:Byte):String;
Begin
 Case Numero of
  1 : FormatBody := 'Familiale';
  2 : FormatBody := 'Hatch Back 5P';
  3 : FormatBody := 'Hatch Back 3P';
  4 : FormatBody := 'Pickup';
  5 : FormatBody := 'Sedan 2P';
  6 : FormatBody := 'Sedan 4P';
   else
  FormatBody := 'Inconnu';
 End;
End;

Function Strg(Nombre:LongInt):String;
Var Chaine : String;
Begin
 Str(Nombre,Chaine);
 Strg := Chaine;
End;

Function Date(Jour,Mois,Annee:Byte):String;
Var Chaine : String[31];
    Temp   : String[31];
Begin
 FillChar(Chaine,SizeOf(Chaine),0);
 FillChar(Temp,SizeOf(Temp),0);
 If(Jour = 0)Then Date := 'Absente'
  else
 Begin
  Str(Jour:2,Chaine);
  Temp := Chaine + '/';
  Str(Mois:2,Chaine);
  IncStr(Temp,Chaine + '/');
  Str(Annee+1902:4,Chaine);
  IncStr(Temp,Chaine);
  Date := Temp;
 End;
End;

End.
