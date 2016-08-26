{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_04.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_04;
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
  MODULE_ID='e04';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Grounded cathode amplifier with triode (with bypassed cathode resistor)';
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
  MESSAGE11='fl|Hz|low frequency range';
  // Output data:
  MESSAGE12='Rk|ohm|cathode resistor';
  MESSAGE13='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE14='PRg|W|quiescent dissipation of the grid-leak resistor';
  MESSAGE15='PRa|W|quiescent dissipation of the anode resistor';
  MESSAGE16='u|-|voltage gain';
  MESSAGE17='Au|dB|voltage gain';
  MESSAGE18='Ri|kohm|internal resistance';
  MESSAGE19='gm|mA/V|mutual conductance';
  MESSAGE20='Zin|Mohm|input impedance';
  MESSAGE21='Zout|kohm|output impedance';
  MESSAGE22='Ck|uF|cathode capacitor';
  MESSAGE23='UCk|V|voltage of cathode capacitor';
  // Messages:
  MESSAGE24='Calculation error, please check values!';
  MESSAGE25='fl must be bigger than zero!';

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
  Ug0, Ua0, Ia0, DUamax, DUgmax, DIamax, fl: real;
  //Input data:
  Up, Rg, Ra: real;
  //Output data:
  Rk, PRk, PRg, PRa, Au, AudB, Ri, gm, Zin, Zout, Ck, UCk: real;
  //Other data:
begin
  try
    if fl<=0 then 
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    // Active elements:
    Ug0:=ValueActiveElements[0];
    If Ug0<0 then Ug0:=Ug0*(-1);
    Ua0:=ValueActiveElements[1];
    Ia0:=ValueActiveElements[2]/1000;
    DUgmax:=ValueActiveElements[3];
    DUamax:=ValueActiveElements[4];
    DIamax:=ValueActiveElements[5];
    // Input data:
    Up:=ValueDataIn[0];
    Rg:=ValueDataIn[1]*1000000;
    Ra:=ValueDataIn[2]*1000;
    fl:=ValueDataIn[3];
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
    Ck:=(1/(2*pi*fl*Rk))*sqrt(1+((Rk*(Au+1))/((2*(Ra+Ri))+(0.5*Rk*(Au+1)))));
    UCk:=sqrt(2)*Ug0;
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
    ValueDataOut[10]:=Ck*1000000;
    ValueDataOut[11]:=UCk;
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
    ValueDataOut[11]:=0;
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
  NameDataIn[3]:=MESSAGE11;
  // Output data:
  NameDataOut[0]:=MESSAGE12;
  NameDataOut[1]:=MESSAGE13;
  NameDataOut[2]:=MESSAGE14;
  NameDataOut[3]:=MESSAGE15;
  NameDataOut[4]:=MESSAGE16;
  NameDataOut[5]:=MESSAGE17;
  NameDataOut[6]:=MESSAGE18;
  NameDataOut[7]:=MESSAGE19;
  NameDataOut[8]:=MESSAGE20;
  NameDataOut[9]:=MESSAGE21;
  NameDataOut[10]:=MESSAGE22;
  NameDataOut[11]:=MESSAGE23;
  // Error messages:
  ErrorMessages[0]:=MESSAGE24;
  ErrorMessages[1]:=MESSAGE25;
end.
