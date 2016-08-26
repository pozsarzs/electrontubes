{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator                      | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | frmactivehlp.pp                                                          | }
{ | Set serial number form                                                   | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit frmactivehelp;
{$MODE OBJFPC}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, XMLPropStorage, DOM, XMLRead, XMLWrite;
type
  { TForm5 }
  TForm5 = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form5: TForm5;
  page, pages: byte;
  title: array [1..10] of string;
  description: array [1..10] of ansistring;
  figure: array [1..10] of string;

Resourcestring
  MESSAGE01='Help file error!';
  MESSAGE02='There is not help file!';
  MESSAGE03='(There is not picture!)';

implementation
uses frmmain, untcommonproc;
{$R *.lfm}
{ TForm5 }

// actual module number in string
function smn: string;
var
  s: string;
begin
  s:=inttostr(frmmain.modnum+1);
  if length(s)=1 then s:='0'+s;
  smn:=s;
end;

// page shower
procedure showpage;
var
  i, ii: integer;
  ss, sss: string;
begin
  with Form5 do
  begin
  if page=pages then Button3.Enabled:=false else Button3.Enabled:=true;
  if page=1 then Button2.Enabled:=false else Button2.Enabled:=true;
  Label2.Caption:=inttostr(page)+'/'+inttostr(pages);
  Label1.Caption:=UTF8Encode(title[page]);
  Memo1.Lines.Clear;
  ss:=UTF8Encode(description[page]);
  i:=1;
  sss:='';
  repeat
    if ss[i]<>#10 then sss:=sss+ss[i] else
    begin
      Memo1.Lines.Add(sss);
      sss:='';
    end;
    i:=i+1;
  until i=length(ss)+1;
  Memo1.Lines.Add(sss);
  try
   {$IFDEF UNIX}{$IFDEF UseFHS}
    Image1.Picture.LoadFromFile(untcommonproc.INSTPATH+'/share/'+APPNAME+
      '/help/module_'+smn+'/'+figure[page]);
   {$ELSE}
    Image1.Picture.LoadFromFile(untcommonproc.EXEPATH+'help/module_'+smn+
      '/'+figure[page]);
   {$ENDIF}{$ENDIF}
   {$IFDEF WIN32}
    Image1.Picture.LoadFromFile(untcommonproc.EXEPATH+'help\module_'+smn+
      '\'+figure[page]);
   {$ENDIF}
  except
    Memo1.Lines.Add(MESSAGE03);
  end;
end;
end;

// OnShow event
procedure TForm5.FormShow(Sender: TObject);
var
  Child: TDOMNode;
  xdoc: TXMLDocument;
  j: byte;
  s: string;
begin
  Form1.ComboBox1.Enabled:=false;
  for page:=1 to 10 do
  begin
    title[page]:='';
    description[page]:='';
    figure[page]:='';
  end;
  pages:=0;
  page:=0;
  try
   {$IFDEF UNIX}{$IFDEF UseFHS}
    ReadXMLFile(xdoc,untcommonproc.INSTPATH+'/share/'+APPNAME+'/help/module_'+
      smn+'/'+untcommonproc.lang+'_help.xml');
   {$ELSE}
    ReadXMLFile(xdoc,untcommonproc.EXEPATH+'help/module_'+smn+'/'+
      untcommonproc.lang+'_help.xml');
   {$ENDIF}{$ENDIF}
   {$IFDEF WIN32}
    ReadXMLFile(xdoc,untcommonproc.EXEPATH+'help\module_'+smn+'\'+
      untcommonproc.lang+'_help.xml');
   {$ENDIF}
    Child:=xdoc.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
      if Child.NodeName='page' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
            begin
              if Item[j].NodeName='title' then title[pages+1]:=Item[j].FirstChild.NodeValue;
              if Item[j].NodeName='description' then description[pages+1]:=Item[j].FirstChild.NodeValue;
              if Item[j].NodeName='figure' then figure[pages+1]:=Item[j].FirstChild.NodeValue;
            end;
            pages:=pages+1;
          finally
            Free;
          end;
      Child := Child.NextSibling;
    end;
    xdoc.Free;
  except
    Memo1.Clear;
    Memo1.Append(MESSAGE01);
    Button2.Enabled:=false;
    Button3.Enabled:=false;
    exit;
  end;
  if pages=0 then
  begin
    Memo1.Clear;
    Memo1.Append(MESSAGE02);
    Button2.Enabled:=false;
    Button3.Enabled:=false;
    exit;
  end;
  page:=1;
  showpage;
end;

// close page
procedure TForm5.Button1Click(Sender: TObject);
begin
  Form1.ComboBox1.Enabled:=true;
  Form5.Close;
end;

// previous page
procedure TForm5.Button2Click(Sender: TObject);
begin
  if page>1 then page:=page-1;
  showpage;
end;

// next page
procedure TForm5.Button3Click(Sender: TObject);
begin
  if page<pages then page:=page+1;
  showpage;
end;

procedure TForm5.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Form1.ComboBox1.Enabled:=true;
end;

end.

