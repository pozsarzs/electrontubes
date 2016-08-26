{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_07.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_07;
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
  MODULE_ID='e07';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='AC coupled cathode follower with triode';
  // Active elements:
  MESSAGE02='V1|Ug0|V|quiescent grid voltage of triode with correct sign';
  MESSAGE03='V1|Ua0|V|quiescent anode voltage of triode';
  MESSAGE04='V1|Ia0|mA|quiescent anode current of triode';
  MESSAGE05='V1|Ri|kohm|internal resistance (from datasheet)';
  MESSAGE06='V1|u|-|voltage gain (from datasheet)';
  // Input data:
  MESSAGE07='Ups|V|power supply voltage';
  MESSAGE08='Rk1|kohm|load resistor (from datasheet)';
  MESSAGE09='Rg|kohm|grid-leak resistor (from datasheet)';
  // Output data:
  MESSAGE10='PRk1|W|quiescent dissipation of the lower cathode resistor';
  MESSAGE11='Rk2|kohm|upper cathode resistor';
  MESSAGE12='PRk2|W|quiescent dissipation of the upper cathode resistor';
  MESSAGE13='Zin|kohm|input impedance';
  MESSAGE14='Zout|ohm|output impedance';
  MESSAGE15='Au|-|calculated voltage gain';
  MESSAGE16='Au|dB|calculated voltage gain';
  // Messages:
  MESSAGE17='Calculation error, please check values!';

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
  Ug0, Ua0, Ia0, Ri, Mu: real;
  //Input data:
  Ups, Rk1, Rg: real;
  //Output data:
  PRk1, Rk2, PRk2, Zin, Zout, Au, AudB: real;
  // Other data:
  Uk, Ug: real;
begin
  try
    // Active elements:
    Ug0:=ValueActiveElements[0];
    Ua0:=ValueActiveElements[1];
    Ia0:=ValueActiveElements[2]/1000;
    Ri:=ValueActiveElements[3]*1000;
    Mu:=ValueActiveElements[4];
    // Input data:
    Ups:=ValueDataIn[0];
    Rk1:=ValueDataIn[1]*1000;
    Rg:=ValueDataIn[2]*1000;
    // Calculations:
    Uk:=Ups-Ua0;
    Ug:=Uk+Ug0;
    Rk2:=Ug/Ia0;
    PRk2:=Ia0*Ia0*Rk2;
    PRk1:=Ia0*Ia0*Rk1;
    Au:=Mu/(Mu+1);
    AudB:=20*log(Au);
    Zin:=Rg/(1-(Au*Rk1/(Rk1+Rk2)));
    Zout:=Ri/Mu;
    // Output data:
    ValueDataOut[0]:=PRk1;
    ValueDataOut[1]:=Rk2/1000;
    ValueDataOut[2]:=PRk2;
    ValueDataOut[3]:=Zin/1000;
    ValueDataOut[4]:=Zout;
    ValueDataOut[5]:=Au;
    ValueDataOut[6]:=AudB;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
    ValueDataOut[2]:=0;
    ValueDataOut[3]:=0;
    ValueDataOut[4]:=0;
    ValueDataOut[5]:=0;
    ValueDataOut[6]:=0;
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
  NameActiveElements[3]:=MESSAGE05;
  NameActiveElements[4]:=MESSAGE06;
  // Input data:
  NameDataIn[0]:=MESSAGE07;
  NameDataIn[1]:=MESSAGE08;
  NameDataIn[2]:=MESSAGE09;
  // Output data:
  NameDataOut[0]:=MESSAGE10;
  NameDataOut[1]:=MESSAGE11;
  NameDataOut[2]:=MESSAGE12;
  NameDataOut[3]:=MESSAGE13;
  NameDataOut[4]:=MESSAGE14;
  NameDataOut[5]:=MESSAGE15;
  NameDataOut[6]:=MESSAGE16;
  // Error messages:
  ErrorMessages[0]:=MESSAGE17;
end.
