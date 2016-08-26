{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_05.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_05;
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
  MODULE_ID='e05';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Grounded cathode amplifier with triode with negative feedback';
  // Active elements:
  MESSAGE02='V1|Ug0|V|quiescent grid voltage with correct sign';
  MESSAGE03='V1|Ua0|V|quiescent anode voltage';
  MESSAGE04='V1|Ia0|mA|quiescent anode current';
  MESSAGE05='V1|Ri|kohm|internal resistance (from datasheet)';
  MESSAGE06='V1|u|-|voltage gain (from datasheet)';
  // Input data:
  MESSAGE07='Ups|V|power supply voltage';
  MESSAGE08='Ra|kohm|anode resistor (from datasheet)';
  MESSAGE09='Rf|kohm|feedback resistor (min. 3 x Ra!)';
  MESSAGE10='fl|Hz|low frequency range';
  MESSAGE11='Av|-|requested voltage gain with feedback';
  // Output data:
  MESSAGE12='Rg|kohm|grid resistor';
  MESSAGE13='Rk|ohm|cathode resistor';
  MESSAGE14='PRk|W|quiescent dissipation of the cathode resistor';
  MESSAGE15='PRa|W|quiescent dissipation of the anode resistor';
  MESSAGE16='A0|-|gain without feedback';
  MESSAGE17='A0|dB|gain without feedback';
  MESSAGE18='Av''|-|calculated voltage gain with feedback';
  MESSAGE19='Av''|dB|calculated voltage gain with feedback';
  MESSAGE20='Zin|Mohm|input impedance';
  MESSAGE21='Zout|kohm|output impedance';
  MESSAGE22='Ck|uF|cathode capacitor';
  MESSAGE23='UCk|V|voltage of cathode capacitor';
  MESSAGE24='Cc|uF|couple capacitor';
  // Messages:
  MESSAGE25='Calculation error, please check values!';
  MESSAGE26='Rf must be equal or bigger than 3xRa!';
  MESSAGE27='Av must be bigger than zero!';
  MESSAGE28='fl must be bigger than zero!';

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
  Ups, Ra, Rf, fl, Av: real;
  //Output data:
  Rg, Rk, PRk, PRa, A0, A0dB, Avv, AvvdB, Zin, Zout, Ck, UCk, Cc: real;
  // Other data:
  Z0a: real;
begin
  try
    // Active elements:
    Ug0:=ValueActiveElements[0];
    if Ug0<0 then Ug0:=Ug0*(-1);
    Ua0:=ValueActiveElements[1];
    Ia0:=ValueActiveElements[2]/1000;
    Ri:=ValueActiveElements[3]*1000;
    Mu:=ValueActiveElements[4];
    // Input data:
    Ups:=ValueDataIn[0];
    Ra:=ValueDataIn[1]*1000;
    Rf:=ValueDataIn[2]*1000;
    fl:=ValueDataIn[3];
    Av:=ValueDataIn[4];
    // Calculations:
    if Rf<Ra then 
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    if Av<=0 then 
    begin
      ErrorCode:=3;
      Result:=ErrorCode;
      exit;
    end;
    if fl<=0 then 
    begin
      ErrorCode:=4;
      Result:=ErrorCode;
      exit;
    end;
    Rk:=Ug0/Ia0;
    PRk:=Ia0*Ia0*Rk;
    Ck:=1/(2*pi*fl*Rk);
    UCk:=sqrt(2)*Ug0;
    A0:=-1*(Ra*Mu)/(Ra+Ri);
    A0dB:=20*log((-1)*A0);
    Rg:=Rf/Av;
    Cc:=1/(2*pi*fl*Rf);
    Zout:=((Rg+Rf)*Ri)/(Rg+Rf+(Ri*(Mu+1)));
    Zin:=Ri*(Rg+Ra)+((Ra*(Ri+Rg+Rf+(Mu*Rg)))/(Ri+Ra+(Mu*Ra)));
    PRa:=Ia0*Ia0*Ra;
    Z0a:=(Ra+Ri)/(Ra*Ri);
    Avv:=(Z0a+(A0*Rf))/(Rg+Rf+Z0a-(Rg*A0));
    AvvdB:=20*log((-1)*Avv);
    // Output data:
    ValueDataOut[0]:=Rg/1000;
    ValueDataOut[1]:=Rk;
    ValueDataOut[2]:=PRk;
    ValueDataOut[3]:=PRa;
    ValueDataOut[4]:=A0;
    ValueDataOut[5]:=A0dB;
    ValueDataOut[6]:=Avv;
    ValueDataOut[7]:=AvvdB;
    ValueDataOut[8]:=Zin/1000000;
    ValueDataOut[9]:=Zout/1000;
    ValueDataOut[10]:=Ck*1000000;
    ValueDataOut[11]:=UCk;
    ValueDataOut[12]:=Cc*1000000;
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
    ValueDataOut[12]:=0;
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
  NameDataIn[3]:=MESSAGE10;
  NameDataIn[4]:=MESSAGE11;
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
  NameDataOut[12]:=MESSAGE24;
  // Error messages:
  ErrorMessages[0]:=MESSAGE25;
  ErrorMessages[1]:=MESSAGE26;
  ErrorMessages[2]:=MESSAGE27;
  ErrorMessages[3]:=MESSAGE28;
end.
