{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | electrontubes.lpr                                                        | }
{ | Projec file                                                              | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

program electrontubes;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}cthreads, {$ENDIF}{$ENDIF}
  Interfaces, Forms, DefaultTranslator, printer4lazarus,
  // own forms:
  frmmain, frmabout, frmserial, frmpref,
  // own units:
  untmodules, untcommonproc, untchkregkey, frmactivehelp, module_01, module_02,
  module_03, module_04, module_05, module_06, module_07, module_14, module_08,
  module_09, module_10, module_11, module_12, module_13, module_15;

{$R *.res}

begin
  if (Application.Params[1]='-h') or (Application.Params[1]='--help')
  then
  begin
    writeln('Useable parameters:');
    writeln(#9+'"-o" or "--offline"'+#9+'full off-line mode;');
    writeln(#9+'"-v" or "--version"'+#9+'version information.');
    Halt(0);
  end;
  if (Application.Params[1]='-v') or (Application.Params[1]='--version') then
  begin
    writeln('Electrontubes v'+untcommonproc.VERSION);
    Halt(0);
  end;
  Application.Title:='Electrontubes';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
