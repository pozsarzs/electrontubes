{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | frmabout.pp                                                              | }
{ | About form                                                               | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

unit frmabout;
{$MODE OBJFPC}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,
  // own units:
  untcommonproc;
type
  { TForm2 }
  TForm2 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button1: TButton;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
var
  Form2: TForm2;

Resourcestring
  MESSAGE01='Demo mode,';
  MESSAGE02='registration required!';

implementation

{$R *.lfm}
{ TForm2 }

// OnCreate event
procedure TForm2.FormCreate(Sender: TObject);
begin
  Label1.Caption:=Label1.Caption+untcommonproc.VERSION;
  Label4.Enabled:=not untcommonproc.offline;
  Label4.Caption:=untcommonproc.PRJ_HOMEPAGE;
  Label5.Enabled:=not untcommonproc.offline;
  Label5.Caption:=untcommonproc.EMAIL;
end;

// OnShow event
procedure TForm2.FormShow(Sender: TObject);
begin
  Label8.Font.Color:=clRed;
  Label10.Font.Color:=clRed;
  Label8.Caption:=MESSAGE01;
  Label10.Caption:=MESSAGE02;
  if (untcommonproc.username<>'!') and (untcommonproc.username<>'')
  then
  begin
    Label8.Font.Color:=clWindowText;
    Label10.Font.Color:=clWindowText;
    Label8.Caption:=untcommonproc.username;
    Label10.Caption:=untcommonproc.serialnumber;
  end;
end;

// Visit homepage
procedure TForm2.Label4MouseEnter(Sender: TObject);
begin
  Label4.Font.Color:=clRed;
end;

procedure TForm2.Label4MouseLeave(Sender: TObject);
begin
  Label4.Font.Color:=clBlue;
end;

procedure TForm2.Label4Click(Sender: TObject);
begin
  runbrowser(Label4.Caption);
end;

// Send an e-mail
procedure TForm2.Label5Click(Sender: TObject);
begin
  runmailer(Label5.Caption);
end;

procedure TForm2.Label5MouseEnter(Sender: TObject);
begin
  Label5.Font.Color:=clRed;
end;

procedure TForm2.Label5MouseLeave(Sender: TObject);
begin
  Label5.Font.Color:=clBlue;
end;

// Close about
procedure TForm2.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

