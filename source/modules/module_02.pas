{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
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

unit module_02;
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
  MODULE_ID='e02';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Current stabilised heating circuit with baretter (Fe-H resistor)';
  // Active elements:
  MESSAGE02='V1|Ubmin|V|minimal baretter voltage';
  MESSAGE03='V1|Ubmax|V|maximal baretter voltage';
  MESSAGE04='V1|Ib|A|nominal baretter current';
  // Input data:
  MESSAGE05='Uin|V|input voltage';
  MESSAGE06='Uh|V|total heating voltage';
  MESSAGE07='Ih|A|heating current';
  // Output data:
  MESSAGE08='R1|ohm|ballast resistor';
  MESSAGE09='PR1|W|power of the ballast resistor';
  // Error messages:
  MESSAGE10='Calculation error, please check values!';
  MESSAGE11='Please select another baretter: Ih and Ib must be equal!';
  MESSAGE12='Bad values: Uin must be bigger than Ubmax!';

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

// Calculation
function Calculate: byte;
var
  //Active elements:
  V1Ubmin, V1Ubmax, V1Ib: real;
  //Input data:
  Uin, Uh, Ih: real;
  //Output data:
  R1, PR1: real;
  //Other data:
  Ub, UR: real;
begin
  try
    // Active elements:
    V1Ubmin:=ValueActiveElements[0];
    V1Ubmax:=ValueActiveElements[1];
    V1Ib:=ValueActiveElements[2];
    // Input data:
    Uin:=ValueDataIn[0];
    Uh:=ValueDataIn[1];
    Ih:=ValueDataIn[2];
    // Calculation:
    if V1Ib<>Ih then
    begin
      ErrorCode:=2;
      Result:=ErrorCode;
      exit;
    end;
    Ub:=(V1Ubmax+V1Ubmin)/2;
    if Uin<=Ub then
    begin
      ErrorCode:=3;
      Result:=ErrorCode;
      exit;
    end;
    // Output data:
    UR:=Uin-(Uh+Ub);
    R1:=UR/Ih;
    PR1:=(UR*UR)/R1;
    ValueDataOut[0]:=R1;
    ValueDataOut[1]:=PR1;
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
  // Error messages:
  ErrorMessages[0]:=MESSAGE10;
  ErrorMessages[1]:=MESSAGE11;
  ErrorMessages[2]:=MESSAGE12;
end.
