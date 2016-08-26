{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_08.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_08;
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
  MODULE_ID='e08';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Shunt regulated push-pull (SRPP) amplifier with triodes';
  // Active elements:
  MESSAGE02='V1|Ri|kohm|internal resistance (from datasheet)';
  MESSAGE03='V1|u|-|voltage gain (from datasheet)';
  // Input data:
  MESSAGE04='Ups|V|power supply voltage';
  MESSAGE05='Rg|Mohm|grid-leak resistor (from datasheet)';
  MESSAGE06='Rl|kohm|load resistor (from datasheet)';
  MESSAGE07='fl|Hz|lower frequency range';
  // Output data:
  MESSAGE08='Rk|ohm|cathode resistor';
  MESSAGE09='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE10='Ck|uF|cathode capacitor';
  MESSAGE11='Zin|kohm|input impedance';
  MESSAGE12='Zout|kohm|output impedance';
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
  Ri, Mu: real;
  //Input data:
  Ups, Rg, Rl, fl: real;
  //Output data:
  Rk, PRk, Ck, Zin, Zout: real;
  // Other data:
  Ia0: real;
begin
  try
    // Active elements:
    Ri:=ValueActiveElements[0]*1000;
    Mu:=ValueActiveElements[1];
    // Input data:
    Ups:=ValueDataIn[0];
    Rg:=ValueDataIn[1]*1000000;
    Rl:=ValueDataIn[2]*1000;
    fl:=ValueDataIn[3];
    // Calculations:
    Rk:=(Ri+(2*Rl))/Mu;
    Ck:=1/(2*pi*fl*Rk);
    Zin:=Rg;
    Ia0:=Ups/((2*Ri)+(2*Mu*Rk));
    PRk:=Ia0*Ia0*Rk;
    Zout:=((2*Rk)+Ri)*(Ri+(Rk*(Mu+2)))/((2*Ri)+(2*Rk*(Mu+2)));
    // Output data:
    ValueDataOut[0]:=Rk;
    ValueDataOut[1]:=PRk;
    ValueDataOut[2]:=Ck*1000000;
    ValueDataOut[3]:=Zin/1000;
    ValueDataOut[4]:=Zout/1000;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
    ValueDataOut[2]:=0;
    ValueDataOut[3]:=0;
    ValueDataOut[4]:=0;
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
  HowToSetLinkActive:=false;
  // Module name:
  NameModule:=MESSAGE01;
  // Active elements:
  NameActiveElements[0]:=MESSAGE02;
  NameActiveElements[1]:=MESSAGE03;
  // Input data:
  NameDataIn[0]:=MESSAGE04;
  NameDataIn[1]:=MESSAGE05;
  NameDataIn[2]:=MESSAGE06;
  NameDataIn[3]:=MESSAGE07;
  // Output data:
  NameDataOut[0]:=MESSAGE08;
  NameDataOut[1]:=MESSAGE09;
  NameDataOut[2]:=MESSAGE10;
  NameDataOut[3]:=MESSAGE11;
  NameDataOut[4]:=MESSAGE12;
  // Error messages
  ErrorMessages[0]:=MESSAGE13;
end.
