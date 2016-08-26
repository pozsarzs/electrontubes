{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | electrontubes.lpr                                                        | }
{ | Projec file                                                              | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

program electrontubes;
{$MODE OBJFPC}{$H+}
uses
  Dialogs, Interfaces, Forms, SysUtils,
 {$IFDEF UseFHS} unttranslator, {$ELSE} DefaultTranslator,{$ENDIF}
  Printer4Lazarus, crt, frmmain, frmabout, frmactivehelp, frmpref,
  untcommonproc;
var
  b: byte;
  fn: string;
const
  params: array[1..3,1..3] of string=
  (
    ('-h','--help','show help'),
    ('-v','--version','show version and build information'),
    ('-o','--offline','off-line mode')
  );

{$R *.res}

procedure help(mode: boolean);
var
  b: byte;
begin
  if mode then
    showmessage('There are one or more bad parameters in command line.') else
    begin
     {$IFDEF UNIX} 
      writeln('Usage:');
      writeln(' ',fn,{$IFDEF WIN32}'.',fe,{$ENDIF}' [parameter]');
      writeln;
      writeln('parameters:');
      for b:=1 to 3 do
      begin
        write('  ',params[b,1]);
        gotoxy(8,wherey); write(params[b,2]);
        gotoxy(30,wherey); writeln(params[b,3]);
      end;
      writeln;
     {$ENDIF}
     {$IFDEF WIN32}
      s:='Usage:'+#13+#10;
      s:=s+' '+fn+' [parameter]'+#13+#10+#13+#10;
      s:=s+'parameters:';
      for b:=1 to 3 do
        s:=s+#13+#10+'  '+params[b,1]+', '+params[b,2]+': '+params[b,3];
      showmessage(s);
     {$ENDIF}
    end;
  halt(0);
end;

procedure verinfo;
begin
 {$IFDEF UNIX}
  writeln(untcommonproc.APPNAME+' v'+untcommonproc.VERSION);
  writeln;
  writeln('This application was compiled at ',{$I %TIME%},' on ',{$I %DATE%},' by ',{$I %USER%});
  writeln('FPC version: ',{$I %FPCVERSION%});
  writeln('Target OS:   ',{$I %FPCTARGETOS%});
  writeln('Target CPU:  ',{$I %FPCTARGETCPU%});
 {$ENDIF}
 {$IFDEF WIN32}    
  s:=untcommonproc.APPNAME+' v'+untcommonproc.VERSION+#13+#10+#13+#10;
  s:=s+'This was compiled at '+{$I %TIME%}+' on '+{$I %DATE%}+' by '+{$I %USERNAME%}+'.'+#13+#10+#13+#10;
  s:=s+'FPC version: '+{$I %FPCVERSION%}+#13+#10;
  s:=s+'Target OS:   '+{$I %FPCTARGETOS%}+#13+#10;
  s:=s+'Target CPU:  '+{$I %FPCTARGETCPU%};
  showmessage(s);
 {$ENDIF}
  halt(0);
end;

begin
  fn:=extractfilename(paramstr(0));
  appmode:=0;
  if length(paramstr(1))=0 then appmode:=1 else
  begin
    for b:=1 to 3 do
      if paramstr(1)=params[b,1] then appmode:=10*b;
    for b:=1 to 3 do
      if paramstr(1)=params[b,2] then appmode:=10*b;
  end;
  case appmode of
     0: help(true);
    10: help(false);
    20: verinfo;
  end;
  Application.Title:='Electrontubes';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.

