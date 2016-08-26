{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_14.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_14;
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
  MODULE_ID='e14';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Grounded cathode amplifier with triode cascode #2';
  // Active elements:
  MESSAGE02='V1|Ug0|V|quiescent grid voltage of lower triode with correct sign';
  MESSAGE03='V1|Ua0|V|quiescent anode voltage of lower triode';
  MESSAGE04='V1|Ia0|mA|quiescent anode current of lower triode';
  MESSAGE05='V2|Ug0|V|quiescent grid voltage of upper triode with correct sign';
  // Input data:
  MESSAGE06='Ups|V|power supply voltage';
  MESSAGE07='Ra|kohm|anode resistor (from datasheet)';
  MESSAGE08='fl|Hz|low frequency range';
  // Output data:
  MESSAGE09='Rk|ohm|cathode resistor';
  MESSAGE10='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE11='Ck|uF|cathode capacitor';
  MESSAGE12='UCk|V|voltage of cathode capacitor';
  MESSAGE13='PRa|W|quiescent dissipation of the anode resistor';
  MESSAGE14='Rg2|Mohm|grid-leak resistor of upper triode';
  MESSAGE15='C1|nF|V2 grid capacitor';
  MESSAGE16='UC1|V|voltage of C1 capacitor';
  // Messages:
  MESSAGE17='Calculation error, please check values!';
  MESSAGE18='fl must be bigger than zero!';

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
  V1Ug0, V1Ua0, V1Ia0, V2Ug0: real;
  //Input data:
  Ups, Ra, fl: real;
  //Output data:
  Rk, PRk, Ck, Uck, PRa, R1, C1, Uc1: real;
  // Other data:
  V2Ug: real;
begin
  try
    // Active elements:
    V1Ug0:=ValueActiveElements[0];
    if V1Ug0<0 then V1Ug0:=(-1)*V1Ug0;
    V1Ua0:=ValueActiveElements[1];
    V1Ia0:=ValueActiveElements[2]/1000;
    V2Ug0:=ValueActiveElements[3];
    // Input data:
    Ups:=ValueDataIn[0];
    Ra:=ValueDataIn[1]*1000;
    fl:=ValueDataIn[2];
    // Calculations:
    if fl<=0 then 
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    Rk:=V1Ug0/V1Ia0;
    PRk:=V1Ia0*V1Ia0*Rk;
    Ck:=1/(2*pi*fl*Rk);
    UCk:=sqrt(2)*V1Ug0;
    V2Ug:=V1Ua0-V2Ug0;
    R1:=1000000;
    C1:=(1/fl)/R1;
    PRa:=V1Ia0*V1Ia0*Ra;
    UC1:=V2Ug*sqrt(2);
    // Output data:
    ValueDataOut[0]:=Rk;
    ValueDataOut[1]:=PRk;
    ValueDataOut[2]:=Ck*1000000;
    ValueDataOut[3]:=UCk;
    ValueDataOut[4]:=PRa;
    ValueDataOut[5]:=R1/1000000;
    ValueDataOut[6]:=C1*1000000000;
    ValueDataOut[7]:=UC1;
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
  // Input data:
  NameDataIn[0]:=MESSAGE06;
  NameDataIn[1]:=MESSAGE07;
  NameDataIn[2]:=MESSAGE08;
  // Output data:
  NameDataOut[0]:=MESSAGE09;
  NameDataOut[1]:=MESSAGE10;
  NameDataOut[2]:=MESSAGE11;
  NameDataOut[3]:=MESSAGE12;
  NameDataOut[4]:=MESSAGE13;
  NameDataOut[5]:=MESSAGE14;
  NameDataOut[6]:=MESSAGE15;
  NameDataOut[7]:=MESSAGE16;
  // Error messages:
  ErrorMessages[0]:=MESSAGE17;
  ErrorMessages[1]:=MESSAGE18;
end.
