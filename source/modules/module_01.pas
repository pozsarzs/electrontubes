{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_01.pas                                                            | }
{ | Module (static, fp unit - v0.3+)                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit module_01;
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
  MODULE_ID='e01';                                                  // Module ID

Resourcestring
  // Module name
  MESSAGE01='Voltage regulator with gas filled voltage stabiliser tube';
  // Parameters of active elements
  MESSAGE02='V1|Ui|V|ignition voltage';
  MESSAGE03='V1|Uamin|V|minimal anode voltage';
  MESSAGE04='V1|Uamax|V|maximal anode voltage';
  MESSAGE05='V1|Iamin|mA|minimal anode current';
  MESSAGE06='V1|Iamax|mA|maximal anode current';
  // Input data
  MESSAGE07='Uinmin|V|minimal input voltage';
  MESSAGE08='Uinmax|V|maximal input voltage';
  MESSAGE09='Uout|V|output voltage';
  MESSAGE10='Iout|mA|output current';
  // Output data
  MESSAGE11='Rbmin|kohm|minimal ballast resistor';
  MESSAGE12='Rbmax|kohm|maximal ballast resistor';
  // Messages
  MESSAGE13='Calculation error, please check values!';
  MESSAGE14='Increase the input voltage!';
  
function GetName: string;
function GetID: string;
procedure SetActiveElements(num: byte; value: real);
procedure SetDataIn(num: byte; value: real);
function GetDataOut(num: byte): real;
function GetNameActiveElements(num: byte): string;
function GetNameDataIn(num: byte): string;
function GetNameDataOut(num: byte): string;
function GetErrorMessage(num: byte): string;
function GetErrorCode: byte;
function GetHowToSetLinkActive: boolean;
function Calculate: byte;

Implementation

// Calculation
function Calculate: byte;
var
  // Parameters of active elements:
  V1Ui, V1Uamin, V1Uamax, V1Iamin, V1Iamax: real;
  // Input data:
  Uinmin, Uinmax, Uout, Iout: real;
  // Output data:
  Rbmin, Rbmax, Rbmaxx: real;
begin
  try
    // Parameters of active elements:
    V1Ui:=ValueActiveElements[0];
    V1Uamin:=ValueActiveElements[1];
    V1Uamax:=ValueActiveElements[2];
    V1Iamin:=ValueActiveElements[3];
    V1Iamax:=ValueActiveElements[4];
    // Input data:
    Uinmin:=ValueDataIn[0];
    Uinmax:=ValueDataIn[1];
    Uout:=ValueDataIn[2];
    Iout:=ValueDataIn[3];
    Rbmin:=(Uinmax-V1Uamin)/(V1Iamax+Iout);
    Rbmax:=(Uinmin-V1Uamax)/(V1Iamin+Iout);
    Rbmaxx:=((Uinmin-V1Ui)/V1Ui)*(Uout/Iout);
    // Calculations: 
    if Rbmaxx<Rbmin then
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    // Output data:
    ValueDataOut[0]:=Rbmin;
    ValueDataOut[1]:=Rbmax;
  except
    ValueDataOut[0]:=0;
    ValueDataOut[1]:=0;
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
  // Parameters of active elements:
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
  // Output data:
  NameDataOut[0]:=MESSAGE11;
  NameDataOut[1]:=MESSAGE12;
  // Error messages:
  ErrorMessages[0]:=MESSAGE13;
  ErrorMessages[1]:=MESSAGE14;
end.
