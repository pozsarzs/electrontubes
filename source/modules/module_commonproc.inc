{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | module_commonproc.pas                                                    | }
{ | Common procedures                                                        | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

// Get module name
function GetName: string;
begin
  GetName:=NameModule;
end;

// Get module ID
function GetID: string;
begin
  GetID:=MODULE_ID;
end;

// Set value of active elements
procedure SetActiveElements(num: byte; value: real);
begin
  ValueActiveElements[num]:=value;
end;

// Set value of input data
procedure SetDataIn(num: byte; value: real);
begin
  ValueDataIn[num]:=value;
end;

// Get value of output data
function GetDataOut(num: byte): real;
begin
  GetDataOut:=ValueDataOut[num];
end;

// Get name of active elements
function GetNameActiveElements(num: byte): string;
begin
  GetNameActiveElements:=NameActiveElements[num];
end;

// Get name of input data
function GetNameDataIn(num: byte): string;
begin
  GetNameDataIn:=NameDataIn[num];
end;

// Get name of output data
function GetNameDataOut(num: byte): string;
begin
  GetNameDataOut:=NameDataOut[num];
end;

// Get error message
function GetErrorMessage(num: byte): string;
begin
  GetErrorMessage:=ErrorMessages[num];
end;

// Get error code
function GetErrorCode: byte;
begin
  GetErrorCode:=ErrorCode;
end;

function GetHowToSetLinkActive: boolean;
begin
  GetHowToSetLinkActive:=HowToSetLinkActive;
end;

// 10 base logarithm
function log(x:real):real;
begin
  log:=ln(x)/ln(10);
end;
