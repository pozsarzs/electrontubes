{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_15.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_15;
{$MODE OBJFPC}{$H+}
interface
var
  NameModule: string;                                          // Name of module
  ValueActiveElements: array[0..15] of real;    // Parameters of active elements
  ValueDataIn: array[0..15] of real;                           // Initial values
  ValueDataOut: array[0..15] of real;                           // Result values
  NameActiveElements: array[0..15] of string;           // Description of values
  NameDataIn: array[0..15] of string;                   // Description of values
  NameDataOut: array[0..15] of string;                  // Description of values
  ErrorCode: byte;                                          // Actual error code
  ErrorMessages: array[0..15] of string;                       // Error messages
  HowToSetLinkActive: boolean;            //Enable/disable "How to set it?" link
const
  MODULE_ID='e15';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Cathodyne phase inverter #2';
  // Active elements:
  MESSAGE02='V1|Ugk0|V|quiescent grid-cathode voltage of triode with correct sign';
  MESSAGE03='V1|Uak0|V|quiescent anode-cathode voltage of triode';
  MESSAGE04='V1|Ia0|mA|quiescent anode current of triode';
  // Input data:
  MESSAGE05='Ups|V|power supply voltage';
  MESSAGE06='Rg|kohm|grid-leak resistor (from datasheet)';
  MESSAGE07='Rk-Ra|kohm|anode and cathode resistors';
  // Output data:
  MESSAGE08='R1|kohm|voltage divider resistor';
  MESSAGE09='PR1|W|quiescent dissipation of the divider resistor';
  MESSAGE10='Rb|kohm|bias resistor';
  MESSAGE11='PRb|W|quiescent dissipation of the bias resistor';
  MESSAGE12='PRa-PRk|W|quiescent dissipation of anode and cathode resistors';
  // Messages:
  MESSAGE13='Calculation error, please check values!';

function GetName: string;
function GetID: string;
procedure SetActiveElements(num: byte; value: real);
procedure SetDataIn(num: byte; value: real);
function GetDataOut(num: byte): real;
function GetNameActiveElements(num: byte): string;
function GetNameDataIn(num: byte): string;
function GetNameDataOut(num: byte): string;
function GetErrorMessage(num: byte): string;
function GetHowToSetLinkActive: boolean;
function GetErrorCode: byte;
function Calculate: byte;

Implementation
function log(x:real): real; forward;

// Calculation
function Calculate: byte;
var
  //Active elements:
  Ugk0, Uak0, Ia0: real;
  //Input data:
  Ups, Rg, RkRa: real;
  //Output data:
  R1, PR1, Rb, PRb, PRaRk: real;
  // Other data:
  Uk0, Ug0: real;
begin
  try
    // Active elements:
    Ugk0:=ValueActiveElements[0];
    Uak0:=ValueActiveElements[1];
    Ia0:=ValueActiveElements[2]/1000;
    // Input data:
    Ups:=ValueDataIn[0];
    Rg:=ValueDataIn[1]*1000;
    RkRa:=ValueDataIn[2]*1000;
    // Calculations:
    Uk0:=(Ups-Uak0)/2;
    if Ugk0>0 then Ugk0:=Ugk0*(-1);
    Ug0:=Uk0+Ugk0;
    R1:=((Ups*Rg)/Ug0)-Rg;
    PR1:=Ups*Ups/(R1+Rg);
    Rb:=((-1)*Ugk0)/Ia0;
    PRb:=Ia0*Ia0*Rb;
    PRaRk:=Ia0*Ia0*RkRa;
    // Output data:
    ValueDataOut[0]:=R1/1000;
    ValueDataOut[1]:=PR1;
    ValueDataOut[2]:=PRaRk;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
    ValueDataOut[2]:=0;
    ErrorCode:=1;
    Result:=ErrorCode;
    exit;
  end;
  ErrorCode:=0;
  Result:=ErrorCode;
end;

{$I module_commonproc.inc}

initialization
  ErrorCode:=0;
  HowToSetLinkActive:=true;
  // Module name:
  NameModule:=MESSAGE01;
  // Active elements:
  NameActiveElements[0]:=MESSAGE02;
  NameActiveElements[1]:=MESSAGE03;
  NameActiveElements[2]:=MESSAGE04;
  // Input data:
  NameDataIn[0]:=MESSAGE05;
  NameDataIn[1]:=MESSAGE06;
  NameDataIn[2]:=MESSAGE07;
  // Output data:
  NameDataOut[0]:=MESSAGE08;
  NameDataOut[1]:=MESSAGE09;
  NameDataOut[2]:=MESSAGE12;
  // Error messages
  ErrorMessages[0]:=MESSAGE13;
end.
