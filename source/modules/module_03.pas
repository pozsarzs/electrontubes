{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_02.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_03;
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
  MODULE_ID='e03';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Grounded cathode amplifier with triode';
  // Active elements:
  MESSAGE02='V1|Ug0|V|quiescent grid voltage with correct sign';
  MESSAGE03='V1|Ua0|V|quiescent anode voltage';
  MESSAGE04='V1|Ia0|mA|quiescent anode current';
  MESSAGE05='V1|DUg|V|grid voltage change';
  MESSAGE06='V1|DUa|V|anode voltage change';
  MESSAGE07='V1|DIa|mA|anode current change';
  // Input data:
  MESSAGE08='Ups|V|power supply voltage';
  MESSAGE09='Rg|Mohm|grid-leak resistor (from datasheet)';
  MESSAGE10='Ra|kohm|anode resistor (from datasheet)';
  // Output data:
  MESSAGE11='Rk|ohm|cathode resistor';
  MESSAGE12='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE13='PRg|W|quiescent dissipation of the grid-leak resistor';
  MESSAGE14='PRa|W|quiescent dissipation of the anode resistor';
  MESSAGE15='u|-|voltage gain';
  MESSAGE16='Au|dB|voltage gain';
  MESSAGE17='Ri|kohm|internal resistance';
  MESSAGE18='gm|mA/V|mutual conductance';
  MESSAGE19='Zin|Mohm|input impedance';
  MESSAGE20='Zout|kohm|output impedance';
  // Messages:
  MESSAGE21='Calculation error, please check values!';

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
  Ug0, Ua0, Ia0, DUamax, DUgmax, DIamax: real;
  //Input data:
  Up, Rg, Ra: real;
  //Output data:
  Rk, PRk, PRg, PRa, Au, AudB, Ri, gm, Zin, Zout: real;
begin
  try
    // Active elementes:
    Ug0:=ValueActiveElements[0];
    if Ug0<0 then Ug0:=Ug0*(-1);
    Ua0:=ValueActiveElements[1];
    Ia0:=ValueActiveElements[2]/1000;
    DUgmax:=ValueActiveElements[3];
    DUamax:=ValueActiveElements[4];
    DIamax:=ValueActiveElements[5];
    // Input data:
    Up:=ValueDataIn[0];
    Rg:=ValueDataIn[1]*1000000;
    Ra:=ValueDataIn[2]*1000;
    // Calculations:
    Rk:=Ug0/Ia0;
    PRk:=Ia0*Ia0*Rk;
    PRg:=(Ug0*Ug0)/Rg;
    PRa:=Ia0*Ia0*Ra;
    Au:=DUamax/Dugmax;
    AudB:=20*log(Au);
    Ri:=DUamax/Diamax;
    gm:=DIamax/DUgmax;
    Zin:=Rg;
    Zout:=(Ra*(Ri+(Rk*(Au+1))))/(Ra+Ri+(Rk*(Au+1)));
    // Output data:
    ValueDataOut[0]:=Rk;
    ValueDataOut[1]:=PRk;
    ValueDataOut[2]:=PRg;
    ValueDataOut[3]:=PRa;
    ValueDataOut[4]:=Au;
    ValueDataOut[5]:=AudB;
    ValueDataOut[6]:=Ri;
    ValueDataOut[7]:=gm;
    ValueDataOut[8]:=Zin/1000;
    ValueDataOut[9]:=Zout/1000;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
    ValueDataOut[2]:=0;
    ValueDataOut[3]:=0;
    ValueDataOut[4]:=0;
    ValueDataOut[5]:=0;
    ValueDataOut[6]:=0;
    ValueDataOut[7]:=0;
    ValueDataOut[8]:=0;
    ValueDataOut[9]:=0;
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
  NameActiveElements[5]:=MESSAGE07;
  // Input data:
  NameDataIn[0]:=MESSAGE08;
  NameDataIn[1]:=MESSAGE09;
  NameDataIn[2]:=MESSAGE10;
  // Output data:
  NameDataOut[0]:=MESSAGE11;
  NameDataOut[1]:=MESSAGE12;
  NameDataOut[2]:=MESSAGE13;
  NameDataOut[3]:=MESSAGE14;
  NameDataOut[4]:=MESSAGE15;
  NameDataOut[5]:=MESSAGE16;
  NameDataOut[6]:=MESSAGE17;
  NameDataOut[7]:=MESSAGE18;
  NameDataOut[8]:=MESSAGE19;
  NameDataOut[9]:=MESSAGE20;
  // Error messages:
  ErrorMessages[0]:=MESSAGE21;
end.
