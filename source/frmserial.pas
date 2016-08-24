{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | frmserial.pp                                                             | }
{ | Set serial number form                                                   | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

unit frmserial;
{$MODE OBJFPC}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,
  // own units:
  untcommonproc;

type
  { TForm3 }
  TForm3 = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3; 

Resourcestring
  MESSAGE01='Wrong serial number!';
  MESSAGE02='Demo';
  MESSAGE03='Full';

implementation
uses frmmain;

{$R *.lfm}
{ TForm3 }

// Cancel
procedure TForm3.Button3Click(Sender: TObject);
begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Close;
end;

// Check and close
procedure TForm3.Button1Click(Sender: TObject);
begin
  serialnumber:=Edit1.Text+'-'+Edit2.Text+'-'+Edit3.Text;
  crk;
  if (username='!') or (username='') then
  begin
    untcommonproc.r:=false;
    showmessage(MESSAGE01);
    serialnumber:='';
    Edit1.Clear;
    Edit2.Clear;
    Edit3.Clear;
    Form1.StatusBar1.Panels.Items[0].Text:=' '+MESSAGE02;
  end else
  begin
    Form1.StatusBar1.Panels.Items[0].Text:=' '+MESSAGE03;
    Form1.Button1.Enabled:=true;
    Form1.Button3.Enabled:=true;
    Form1.MenuItem17.Enabled:=true;
    Form1.MenuItem18.Enabled:=true;
    untcommonproc.r:=true;
  end;
  savecfg;
  Close;
end;

// Edit1 OnChange event
procedure TForm3.Edit1Change(Sender: TObject);
begin
  if length(Edit1.Text)+length(Edit2.Text)+length(Edit3.Text)=18
  then Button1.Enabled:=true
  else Button1.Enabled:=false;
end;

end.
