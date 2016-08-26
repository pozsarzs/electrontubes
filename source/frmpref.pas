{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | frmpref.pp                                                               | }
{ | Preferences form                                                         | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit frmpref;
{$MODE OBJFPC}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, untcommonproc;

type
  { TForm4 }
  TForm4 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
var
  Form4: TForm4;

Resourcestring
  MESSAGE01='Select browser application';
  MESSAGE02='Select mailer application';
  MESSAGE03='executables|*.exe|all files|*.*';
  MESSAGE04='all files|*.*';
  MESSAGE05='Off-line';
  MESSAGE06='On-line';

implementation
uses frmmain;
{$R *.lfm}
{ TForm4 }

//  Form1 OnShow event
procedure TForm4.FormShow(Sender: TObject);
var
  count: byte;
begin
  Edit1.Text:=browserapp;
  Edit2.Text:=mailerapp;
  CheckBox1.Checked:=offline;
  CheckBox2.Checked:=savehistory;
end;

// Cancel button
procedure TForm4.Button2Click(Sender: TObject);
begin
  Close;
end;

// Set default values
procedure TForm4.Button3Click(Sender: TObject);
begin
  {$IFDEF UNIX}
  Edit1.Text:='xdg-open';
  Edit2.Text:='xdg-email';
  {$ENDIF}
  {$IFDEF WIN32}
  Edit1.Text:='rundll32.exe url.dll,FileProtocolHandler';
  Edit2.Text:='rundll32.exe url.dll,FileProtocolHandler mailto:';
  {$ENDIF}
  CheckBox1.Checked:=false;
  CheckBox2.Checked:=true;
end;

// Browse buttons
procedure TForm4.Button4Click(Sender: TObject);
begin
  OpenDialog1.Title:=MESSAGE01;
  {$IFDEF UNIX}
  OpenDialog1.InitialDir:='/';
  Opendialog1.Filter:=MESSAGE03;
  {$ENDIF}
  {$IFDEF WINDOWS}
  OpenDialog1.InitialDir:='\';
  Opendialog1.Filter:=MESSAGE04;
  {$ENDIF}
  if OpenDialog1.Execute=false then exit;
  Edit1.Text:=OpenDialog1.FileName;
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
  OpenDialog1.Title:=MESSAGE02;
  {$IFDEF UNIX}
  OpenDialog1.InitialDir:='/';
  Opendialog1.Filter:=MESSAGE03;
  {$ENDIF}
  {$IFDEF WINDOWS}
  OpenDialog1.InitialDir:='\';
  Opendialog1.Filter:=MESSAGE04;
  {$ENDIF}
  if OpenDialog1.Execute=false then exit;
  Edit2.Text:=OpenDialog1.FileName;
end;

// Set button
procedure TForm4.Button1Click(Sender: TObject);
begin
  untcommonproc.browserapp:=Edit1.Text;
  untcommonproc.mailerapp:=Edit2.Text;
  untcommonproc.savehistory:=CheckBox2.Checked;
  untcommonproc.offline:=CheckBox1.Checked;
  with Form1 do
  begin
    if untcommonproc.offline=true
    then StatusBar1.Panels.Items[0].Text:=' '+MESSAGE05
    else StatusBar1.Panels.Items[0].Text:=' '+MESSAGE06;
    MenuItem15.Enabled:=not offline;
    MenuItem33.Enabled:=not offline;
    MenuItem35.Enabled:=not offline;
  end;
  Close;
end;

end.
