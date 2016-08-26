{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_06.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_06;
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
  MODULE_ID='e06';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Grounded cathode amplifier with triode cascode #1';
  // Active elements:
  MESSAGE02='V1|Ug0|V|quiescent grid voltage of lower triode with correct sign';
  MESSAGE03='V1|Ua0|V|quiescent anode voltage of lower triode';
  MESSAGE04='V1|Ia0|mA|quiescent anode current of lower triode';
  MESSAGE05='V2|Ug0|V|quiescent grid voltage of upper triode with correct sign';
  // Input data:
  MESSAGE06='Ups|V|power supply voltage';
  MESSAGE07='Ra|kohm|anode resistor (from datasheet)';
  MESSAGE08='R1|kohm|upper resistor of voltage divider (default is 560 kohm)';
  MESSAGE09='fl|Hz|low frequency range';
  // Output data:
  MESSAGE10='Rk|ohm|cathode resistor';
  MESSAGE11='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE12='Ck|uF|cathode capacitor';
  MESSAGE13='UCk|V|voltage of cathode capacitor';
  MESSAGE14='PRa|W|quiescent dissipation of the anode resistor';
  MESSAGE15='R1|kohm|upper resistor of voltage divider';
  MESSAGE16='PR1|W|dissipation of R1 resistor';
  MESSAGE17='R2|kohm|lower resistor of voltage divider';
  MESSAGE18='PR2|W|dissipation of R2 resistor';
  MESSAGE19='C1|nF|V2 grid capacitor';
  MESSAGE20='UC1|V|voltage of C1 capacitor';
  // Messages:
  MESSAGE21='Calculation error, please check values!';
  MESSAGE22='fl must be bigger than zero!';
  MESSAGE23='R1 must be bigger than zero!';

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
  Ups, Ra, R1, fl: real;
  //Output data:
  Rk, PRk, Ck, Uck, PRa, PR1, R2, PR2, C1, Uc1: real;
  // Other data:
  I12, R12, V2Ug: real;
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
    R1:=ValueDataIn[2]*1000;
    fl:=ValueDataIn[3];
    // Calculations:
    if fl<=0 then 
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    if R1<0 then 
    begin
      ErrorCode:=3;
      Result:=ErrorCode;
      exit;
    end;
    if R1=0 then R1:=560000;
    Rk:=V1Ug0/V1Ia0;
    PRk:=V1Ia0*V1Ia0*Rk;
    Ck:=1/(2*pi*fl*Rk);
    UCk:=sqrt(2)*V1Ug0;
    V2Ug:=V1Ua0-V2Ug0;
    R2:=(R1*V2Ug)/(Ups-V2Ug);
    R12:=(R1*R2)/(R1+R2);
    C1:=1/(2*pi*fl*R12);
    PRa:=V1Ia0*V1Ia0*Ra;
    I12:=Ups/(R1+R2);
    PR1:=I12*I12*R1;
    PR2:=I12*I12*R2;
    UC1:=V2Ug*sqrt(2);
    // Output data:
    ValueDataOut[0]:=Rk;
    ValueDataOut[1]:=PRk;
    ValueDataOut[2]:=Ck*1000000;
    ValueDataOut[3]:=UCk;
    ValueDataOut[4]:=PRa;
    ValueDataOut[5]:=R1/1000;
    ValueDataOut[6]:=PR1;
    ValueDataOut[7]:=R2/1000;
    ValueDataOut[8]:=PR2;
    ValueDataOut[9]:=C1*1000000000;
    ValueDataOut[10]:=UC1;
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
    ValueDataOut[10]:=0;
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
  NameDataIn[3]:=MESSAGE09;
  // Output data:
  NameDataOut[0]:=MESSAGE10;
  NameDataOut[1]:=MESSAGE11;
  NameDataOut[2]:=MESSAGE12;
  NameDataOut[3]:=MESSAGE13;
  NameDataOut[4]:=MESSAGE14;
  NameDataOut[5]:=MESSAGE15;
  NameDataOut[6]:=MESSAGE16;
  NameDataOut[7]:=MESSAGE17;
  NameDataOut[8]:=MESSAGE18;
  NameDataOut[9]:=MESSAGE19;
  NameDataOut[10]:=MESSAGE20;
  // Error messages:
  ErrorMessages[0]:=MESSAGE21;
  ErrorMessages[1]:=MESSAGE22;
  ErrorMessages[2]:=MESSAGE23;
end.
