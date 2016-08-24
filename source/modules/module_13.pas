{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | module_13.pas                                                            | }
{ | Module (static, fp unit - v3)                                            | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

unit module_13;
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
  MODULE_ID='e13';                                                  // Module ID

Resourcestring
  // Module name:
  MESSAGE01='Single-ended power amplifier with pentode';
  // Active elements:
  MESSAGE02='|||';
  // Input data:
  MESSAGE03='||';
  // Output data:
  MESSAGE04='||';
  // Messages:
  MESSAGE05='Calculation error, please check values!';

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
//var
  //Active elements:
  //: real;
  //Input data:
  //: real;
  //Output data:
  //: real;
  // Other data:
  //: real;
begin
  try
    // Active elements:
    //:=ValueActiveElements[0];
    // Input data:
    //:=ValueDataIn[0];
    // Calculations:
    // Output data:
    //ValueDataOut[0]:=;
  except
    ValueDataOut[0]:=0;
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
  // Input data:
  NameDataIn[0]:=MESSAGE03;
  // Output data:
  NameDataOut[0]:=MESSAGE04;
  // Error messages
  ErrorMessages[0]:=MESSAGE05;
end.
