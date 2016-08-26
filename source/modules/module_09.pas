{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_09.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_09;
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
  MODULE_ID='e09';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Mu-follower amplifier with triodes';
  // Active elements:
  MESSAGE02='V1|u|-|voltage gain (from datasheet)';
  MESSAGE03='V1|Ug0|V|quiescent grid voltage of triode with correct sign';
  MESSAGE04='V1|Ua0|V|quiescent anode voltage of triode';
  MESSAGE05='V2|Ug0|V|quiescent grid voltage of triode with correct sign';
  MESSAGE06='V2|Ua0|V|quiescent anode voltage of triode';
  MESSAGE07='V1-2|Ia0|mA|common quiescent anode current';
  MESSAGE08='V2|UB|V|maximal anode voltage ("B" point on characteristic)';
  MESSAGE09='V2|IA|mA|maximal anode current ("A" point on characteristic)';
  // Input data:
  MESSAGE10='Ups|V|power supply voltage';
  MESSAGE11='Rg1|kohm|grid-leak resistor (from datasheet)';
  MESSAGE12='Rg2|kohm|grid-leak resistor (from datasheet)';
  MESSAGE13='fl|Hz|lower frequency range';
  // Output data:
  MESSAGE14='Rk1|ohm|cathode resistor';
  MESSAGE15='PRk1|W|quiescent dissipation of the cathode resistor';
  MESSAGE16='Ck|uF|cathode capacitor';
  MESSAGE17='Rk2|ohm|cathode resistor';
  MESSAGE18='PRk2|W|quiescent dissipation of the cathode resistor';
  MESSAGE19='Rl|kohm|load resistor';
  MESSAGE20='PRl|W|quiescent dissipation of the load resistor';
  MESSAGE21='Cg2|nF|grid capacitor';
  // Messages:
  MESSAGE22='Calculation error, please check values!';

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
  V1Mu, V1Ug0, V1Ua0, V2Ug0, V2Ua0, V12Ia0, V2UB, V2IA: real;
  //Input data:
  Ups, Rg1, Rg2, fl: real;
  //Output data:
  Rk1, PRk1, Ck, Rk2, PRk2, Rl, PRl, Cg2: real;
  // Other data:
  Au, rccs, Zin: real;
begin
  try
    // Active elements:
    V1Mu:=ValueActiveElements[0];
    V1Ug0:=ValueActiveElements[1];
    V1Ua0:=ValueActiveElements[2];
    V2Ug0:=ValueActiveElements[3];
    V2Ua0:=ValueActiveElements[4];
    V12Ia0:=ValueActiveElements[5]/1000;
    V2UB:=ValueActiveElements[6];
    V2IA:=ValueActiveElements[7]/1000;
    if V1Ug0<0 then V1Ug0:=(-1)*V1Ug0;
    if V2Ug0<0 then V2Ug0:=(-1)*V2Ug0;
    // Input data:
    Ups:=ValueDataIn[0];
    Rg1:=ValueDataIn[1]*1000;
    Rg2:=ValueDataIn[2]*1000;
    fl:=ValueDataIn[3];
    // Calculations:
    Rk1:=V1Ug0/V12Ia0;
    PRk1:=V12Ia0*V12Ia0*Rk1;
    Ck:=1/(2*pi*fl*Rk1);
    Rk2:=V2Ug0/V12Ia0;
    PRk2:=V12Ia0*V12Ia0*Rk2;
    Rl:=(V2UB/V2IA)-Rk2;
    PRl:=V12Ia0*V12Ia0*Rl;
    Au:=V1Mu/(V1Mu+1);
    rccs:=(Rl+Rk2)/(1-Au);
    Zin:=Rg2/(1-(Au*(Rl/(Rl+Rk2))));
    Cg2:=1/(2*pi*fl*(Zin/6));
    // Output data:
    ValueDataOut[0]:=Rk1;
    ValueDataOut[1]:=PRk1;
    ValueDataOut[2]:=Ck*1000000;
    ValueDataOut[3]:=Rk2;
    ValueDataOut[4]:=PRk2;
    ValueDataOut[5]:=Rl/1000;
    ValueDataOut[6]:=PRl;
    ValueDataOut[7]:=Cg2*1000000000;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
    ValueDataOut[2]:=0;
    ValueDataOut[3]:=0;
    ValueDataOut[4]:=0;
    ValueDataOut[5]:=0;
    ValueDataOut[6]:=0;
    ValueDataOut[7]:=0;
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
  NameActiveElements[6]:=MESSAGE08;
  NameActiveElements[7]:=MESSAGE09;
  // Input data:
  NameDataIn[0]:=MESSAGE10;
  NameDataIn[1]:=MESSAGE11;
  NameDataIn[2]:=MESSAGE12;
  NameDataIn[3]:=MESSAGE13;
  // Output data:
  NameDataOut[0]:=MESSAGE14;
  NameDataOut[1]:=MESSAGE15;
  NameDataOut[2]:=MESSAGE16;
  NameDataOut[3]:=MESSAGE17;
  NameDataOut[4]:=MESSAGE18;
  NameDataOut[5]:=MESSAGE19;
  NameDataOut[6]:=MESSAGE20;
  NameDataOut[7]:=MESSAGE21;
  // Error messages
  ErrorMessages[0]:=MESSAGE22;
end.
