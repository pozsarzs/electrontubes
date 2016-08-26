{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | frmabout.pp                                                              | }
{ | About form                                                               | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit frmabout;
{$MODE OBJFPC}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, untcommonproc;
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
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label8MouseEnter(Sender: TObject);
    procedure Label8MouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
var
  Form2: TForm2;

implementation
{$R *.lfm}
{ TForm2 }

// OnCreate event
procedure TForm2.FormCreate(Sender: TObject);
begin
  Label1.Caption:=Label1.Caption+untcommonproc.VERSION;
  Label8.Enabled:=not untcommonproc.offline;
  Label8.Caption:=untcommonproc.HOMEPAGE;
  Label5.Enabled:=not untcommonproc.offline;
  Label5.Caption:=untcommonproc.EMAIL;
end;

procedure TForm2.Label4Click(Sender: TObject);
begin

end;

procedure TForm2.Label4MouseEnter(Sender: TObject);
begin

end;

procedure TForm2.Label4MouseLeave(Sender: TObject);
begin

end;

// Visit homepage
procedure TForm2.Label8MouseEnter(Sender: TObject);
begin
  Label8.Font.Color:=clRed;
end;

procedure TForm2.Label8MouseLeave(Sender: TObject);
begin
  Label8.Font.Color:=clBlue;
end;

procedure TForm2.Label8Click(Sender: TObject);
begin
  runbrowser(Label8.Caption);
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

