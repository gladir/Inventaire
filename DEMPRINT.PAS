(*******************************************************************)
(*                                                                 *)
(*                          Demo Imprimante                        *)
(*                            1992/04/14                           *)
(*                                                                 *)
(*  Programmeur : Sylvain Maltais                                  *)
(*                                                                 *)
(*******************************************************************)

Uses BIOS_PRN;

{Uses Print;}

Var Ok : Boolean;

BEGIN { Main program }
 WriteLn(CheckPrinter(LPT1));
{  WriteLn(PrnReady);}
{ Ok := PrintLn('Ceci est un message!',LPT1);
 Ok := Print('Merde, Ceci est un message!',LPT1);}
END.