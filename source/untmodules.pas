{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | modules.pas                                                              | }
{ | Module collector (for v0.3.1+)                                           | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit untmodules;
{$MODE OBJFPC}{$H+}
interface
uses
  module_01, module_02, module_03, module_04, module_05, module_06, module_07,
  module_08, module_09, module_10, module_14, module_15;
var
  NameDataIn: array[0..63,0..15] of string;
  NameDataOut: array[0..63,0..15] of string;
  NameModule: array[0..63] of string;
  ModuleID: array[0..63] of string;
  NameActiveElements: array[0..63,0..15] of string;
  HTSLActive: array[0..63] of boolean;
  EMessages: array[0..63,0..15] of string;
  EMessage: string;

procedure CollectNames;
procedure SetActiveElementParameters(modnum: byte; num: byte; value: real);
procedure SetInputData(modnum: byte; num: byte; value: real);
function Calculate(modnum: byte): boolean;
function GetOutputData(modnum: byte; num: byte): real;

implementation

procedure CollectNames;
var
 b: byte;
begin
  for b:=0 to 15 do
  begin
    NameActiveElements[0,b]:=Module_01.GetNameActiveElements(b);
    NameDataIn[0,b]:=Module_01.GetNameDataIn(b);
    NameDataOut[0,b]:=Module_01.GetNameDataOut(b);
    NameModule[0]:=Module_01.GetName;
    ModuleID[0]:=Module_01.GetID;
    EMessages[0,b]:=Module_01.GetErrorMessage(b);
    HTSLActive[0]:=Module_01.GetHowToSetLinkActive;

    NameActiveElements[1,b]:=Module_02.GetNameActiveElements(b);
    NameDataIn[1,b]:=Module_02.GetNameDataIn(b);
    NameDataOut[1,b]:=Module_02.GetNameDataOut(b);
    NameModule[1]:=Module_02.GetName;
    ModuleID[1]:=Module_02.GetID;
    EMessages[1,b]:=Module_02.GetErrorMessage(b);
    HTSLActive[1]:=Module_02.GetHowToSetLinkActive;
    
    NameActiveElements[2,b]:=Module_03.GetNameActiveElements(b);
    NameDataIn[2,b]:=Module_03.GetNameDataIn(b);
    NameDataOut[2,b]:=Module_03.GetNameDataOut(b);
    NameModule[2]:=Module_03.GetName;
    ModuleID[2]:=Module_03.GetID;
    EMessages[2,b]:=Module_03.GetErrorMessage(b);
    HTSLActive[2]:=Module_03.GetHowToSetLinkActive;

    NameActiveElements[3,b]:=Module_04.GetNameActiveElements(b);
    NameDataIn[3,b]:=Module_04.GetNameDataIn(b);
    NameDataOut[3,b]:=Module_04.GetNameDataOut(b);
    NameModule[3]:=Module_04.GetName;
    ModuleID[3]:=Module_04.GetID;
    EMessages[3,b]:=Module_04.GetErrorMessage(b);
    HTSLActive[3]:=Module_04.GetHowToSetLinkActive;

    NameActiveElements[4,b]:=Module_05.GetNameActiveElements(b);
    NameDataIn[4,b]:=Module_05.GetNameDataIn(b);
    NameDataOut[4,b]:=Module_05.GetNameDataOut(b);
    NameModule[4]:=Module_05.GetName;
    ModuleID[4]:=Module_05.GetID;
    EMessages[4,b]:=Module_05.GetErrorMessage(b);
    HTSLActive[4]:=Module_04.GetHowToSetLinkActive;

    NameActiveElements[5,b]:=Module_06.GetNameActiveElements(b);
    NameDataIn[5,b]:=Module_06.GetNameDataIn(b);
    NameDataOut[5,b]:=Module_06.GetNameDataOut(b);
    NameModule[5]:=Module_06.GetName;
    ModuleID[5]:=Module_06.GetID;
    EMessages[5,b]:=Module_06.GetErrorMessage(b);
    HTSLActive[5]:=Module_06.GetHowToSetLinkActive;

    NameActiveElements[6,b]:=Module_07.GetNameActiveElements(b);
    NameDataIn[6,b]:=Module_07.GetNameDataIn(b);
    NameDataOut[6,b]:=Module_07.GetNameDataOut(b);
    NameModule[6]:=Module_07.GetName;
    ModuleID[6]:=Module_07.GetID;
    EMessages[6,b]:=Module_07.GetErrorMessage(b);
    HTSLActive[6]:=Module_07.GetHowToSetLinkActive;

    NameActiveElements[7,b]:=Module_08.GetNameActiveElements(b);
    NameDataIn[7,b]:=Module_08.GetNameDataIn(b);
    NameDataOut[7,b]:=Module_08.GetNameDataOut(b);
    NameModule[7]:=Module_08.GetName;
    ModuleID[7]:=Module_08.GetID;
    EMessages[7,b]:=Module_08.GetErrorMessage(b);
    HTSLActive[7]:=Module_08.GetHowToSetLinkActive;

    NameActiveElements[8,b]:=Module_09.GetNameActiveElements(b);
    NameDataIn[8,b]:=Module_09.GetNameDataIn(b);
    NameDataOut[8,b]:=Module_09.GetNameDataOut(b);
    NameModule[8]:=Module_09.GetName;
    ModuleID[8]:=Module_09.GetID;
    EMessages[8,b]:=Module_09.GetErrorMessage(b);
    HTSLActive[8]:=Module_09.GetHowToSetLinkActive;

    NameActiveElements[9,b]:=Module_10.GetNameActiveElements(b);
    NameDataIn[9,b]:=Module_10.GetNameDataIn(b);
    NameDataOut[9,b]:=Module_10.GetNameDataOut(b);
    NameModule[9]:=Module_10.GetName;
    ModuleID[9]:=Module_10.GetID;
    EMessages[9,b]:=Module_10.GetErrorMessage(b);
    HTSLActive[9]:=Module_10.GetHowToSetLinkActive;

    NameActiveElements[13,b]:=Module_14.GetNameActiveElements(b);
    NameDataIn[13,b]:=Module_14.GetNameDataIn(b);
    NameDataOut[13,b]:=Module_14.GetNameDataOut(b);
    NameModule[13]:=Module_14.GetName;
    ModuleID[13]:=Module_14.GetID;
    EMessages[13,b]:=Module_14.GetErrorMessage(b);
    HTSLActive[13]:=Module_14.GetHowToSetLinkActive;

    NameActiveElements[14,b]:=Module_15.GetNameActiveElements(b);
    NameDataIn[14,b]:=Module_15.GetNameDataIn(b);
    NameDataOut[14,b]:=Module_15.GetNameDataOut(b);
    NameModule[14]:=Module_15.GetName;
    ModuleID[14]:=Module_15.GetID;
    EMessages[14,b]:=Module_15.GetErrorMessage(b);
    HTSLActive[14]:=Module_15.GetHowToSetLinkActive;
  end;
end;

procedure SetActiveElementParameters(modnum: byte; num: byte; value: real);
begin
  case modnum of
     0: Module_01.SetActiveElements(num, value);
     1: Module_02.SetActiveElements(num, value);
     2: Module_03.SetActiveElements(num, value);
     3: Module_04.SetActiveElements(num, value);
     4: Module_05.SetActiveElements(num, value);
     5: Module_06.SetActiveElements(num, value);
     6: Module_07.SetActiveElements(num, value);
     7: Module_08.SetActiveElements(num, value);
     8: Module_09.SetActiveElements(num, value);
     9: Module_10.SetActiveElements(num, value);
    13: Module_14.SetActiveElements(num, value);
    14: Module_15.SetActiveElements(num, value);
  end;
end;

procedure SetInputData(modnum: byte; num: byte; value: real);
begin
  case modnum of
     0: Module_01.SetDataIn(num, value);
     1: Module_02.SetDataIn(num, value);
     2: Module_03.SetDataIn(num, value);
     3: Module_04.SetDataIn(num, value);
     4: Module_05.SetDataIn(num, value);
     5: Module_06.SetDataIn(num, value);
     6: Module_07.SetDataIn(num, value);
     7: Module_08.SetDataIn(num, value);
     8: Module_09.SetDataIn(num, value);
     9: Module_10.SetDataIn(num, value);
    13: Module_14.SetDataIn(num, value);
    14: Module_15.SetDataIn(num, value);
  end;
end;

function Calculate(modnum: byte): boolean;
var ec: byte;
begin
  ec:=0;
  case modnum of
     0: ec:=Module_01.Calculate;
     1: ec:=Module_02.Calculate;
     2: ec:=Module_03.Calculate;
     3: ec:=Module_04.Calculate;
     4: ec:=Module_05.Calculate;
     5: ec:=Module_06.Calculate;
     6: ec:=Module_07.Calculate;
     7: ec:=Module_08.Calculate;
     8: ec:=Module_09.Calculate;
     9: ec:=Module_10.Calculate;
    13: ec:=Module_14.Calculate;
    14: ec:=Module_15.Calculate;
  end;
  if ec>0 then
  begin
    EMessage:=EMessages[modnum,ec-1];
    Result:=false;
  end else Result:=true;
end;

function GetOutputData(modnum: byte; num: byte): real;
begin
  case modnum of
     0: Result:=Module_01.GetDataOut(num);
     1: Result:=Module_02.GetDataOut(num);
     2: Result:=Module_03.GetDataOut(num);
     3: Result:=Module_04.GetDataOut(num);
     4: Result:=Module_05.GetDataOut(num);
     5: Result:=Module_06.GetDataOut(num);
     6: Result:=Module_07.GetDataOut(num);
     7: Result:=Module_08.GetDataOut(num);
     8: Result:=Module_09.GetDataOut(num);
     9: Result:=Module_10.GetDataOut(num);
    13: Result:=Module_14.GetDataOut(num);
    14: Result:=Module_15.GetDataOut(num);
  end;
end;

end.

