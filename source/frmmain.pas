{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | frmmain.pas                                                              | }
{ | Main form                                                                | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit frmmain; 
{$MODE OBJFPC}{$H+}
interface
uses
  {$IFDEF WIN32} Windows, {$ENDIF}  Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, Menus, StdCtrls, PairSplitter, ExtCtrls, ComCtrls,
  XMLPropStorage, PrintersDlgs, Process, DOM, XMLRead, XMLWrite, Printers,
  {$IFDEF LINUX} Types, {$ENDIF} dos, frmabout, frmactivehelp, frmpref,
  untmodules, untcommonproc;
type
  { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PrintDialog1: TPrintDialog;
    Process1: TProcess;
    Process2: TProcess;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StList: TStrings;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);
  private
    procedure DrawGraphic(X,Y,AWidth,AHeight:Integer; Graphic: TGraphic);
    function CM(Avalue: Double; VertRes:boolean=true): Integer;
    function MM(AValue: Double; VertRes:boolean=true): Integer;
    function Inch(AValue: Double; VertRes:boolean=true): Integer;
    function Per(AValue: Double; VertRes:boolean=true): Integer;
    procedure CenterText(const X,Y: Integer; const AText: string);
  public
    { public declarations }
  end;
var
  Form1: TForm1;
  recentfiles: array[0..4] of string;
  changeddata: boolean;
  bbb: byte;
  modnum: byte;
  changeddata_sample: string;

procedure AddToRecentFiles(filename: string);

Resourcestring
  MESSAGE01='Demo';
  MESSAGE02='Full';
  MESSAGE03='Off-line';
  MESSAGE04='On-line';
  MESSAGE05='New version is available. Please visit CheapApps''s homepage!';
  MESSAGE06='Save report to file';
  MESSAGE07='text files (*.txt)|*.txt| all files (*.*)|*.*|';
  MESSAGE08='Write error';
  MESSAGE09='File exists, overwrite?';
  MESSAGE10='This is a shareware application.';
  MESSAGE11='If you want to use it without limitation, you need to register!';
  MESSAGE12='Don''t forget: this is just 1€!';
  MESSAGE13=' No picture!';
  MESSAGE14='Do you want to save your work?';
  MESSAGE15='Bad value, fix it';
  MESSAGE16='There is not newer version.';
  MESSAGE17='Sizing report';
  MESSAGE18='Warning! Calculating error, the result can be wrong.';
  MESSAGE19='Save initial values';
  MESSAGE20='values files (*.cav)|*.cav| all files (*.*)|*.*|';
  MESSAGE21='Load initial values';
  MESSAGE22='This file is not owned by this application!';
  MESSAGE23='Saved data is not compatible this module!';
  MESSAGE24='Different version application has saved this file!';
  MESSAGE25='Read error!';
  MESSAGE26='Print report';
  MESSAGE27='Print error!';
  MESSAGE28='Schematic draw';
  MESSAGE29='result.txt';

implementation

{$R *.lfm}
{ TForm1 }

procedure AddToRecentFiles(filename: string);
var
  subItem, Item: TMenuItem;
  c, cc: byte;
  exist: boolean;
  rep: string;
  label onlyload;
begin
  if filename='#' then goto onlyload;
  exist:=false;
  for c:=0 to 4 do
    if recentfiles[c]=filename then begin exist:=true; break; end;
  if exist=false
  then
    begin
      for cc:=4 downto 1 do recentfiles[cc]:=recentfiles[cc-1];
      recentfiles[0]:=filename;
    end
  else
  begin
    for cc:=c downto 1 do
      recentfiles[cc]:=recentfiles[cc-1];
    recentfiles[0]:=filename;
  end;
  onlyload:
  with Form1 do
  begin
    MenuItem31.Enabled:=true;
    MainMenu1.Items[0].Items[4].Clear;
    for c:=0 to 4 do
      if recentfiles[c]<>'' then
      begin
        SubItem:= TMenuItem.Create(MainMenu1);
        SubItem.Caption:=recentfiles[c];
        SubItem.OnClick:=MenuItem4.OnClick;
        MainMenu1.Items[0].Items[4].Add(SubItem);
      end;
  end;
end;

function splitter1(chained: string; mode: byte): string;
{
  Mode #1: Uin
  Mode #2: V
  Mode #3: input voltage
  Mode #4: Uin [V]
}
var
  bb: byte;
  c1, c2, c3: string;
begin
  c1:='';
  c2:='';
  c3:='';
  for bb:=1 to length(chained) do
    if chained[bb]<>'|' then c1:=c1+chained[bb] else break;
  for bb:=bb+1 to length(chained) do
    if chained[bb]<>'|' then c2:=c2+chained[bb] else break;
  for bb:=bb+1 to length(chained) do
    if chained[bb]<>'|' then c3:=c3+chained[bb] else break;
  case mode of
    1: result:=c1;
    2: result:=c2;
    3: result:=c3;
    4: if c2<>'-' then result:=c1+' ['+c2+']' else result:=c1;
  end;
end;

function splitter2(chained: string; mode: byte): string;
{
  Mode #1: V1
  Mode #2: Ua
  Mode #3: V
  Mode #4: anode voltage
  Mode #5: Ua [V]
}
var
  bb: byte;
  c1, c2, c3, c4: string;
begin
  c1:='';
  c2:='';
  c3:='';
  c4:='';
  for bb:=1 to length(chained) do
    if chained[bb]<>'|' then c1:=c1+chained[bb] else break;
  for bb:=bb+1 to length(chained) do
    if chained[bb]<>'|' then c2:=c2+chained[bb] else break;
  for bb:=bb+1 to length(chained) do
    if chained[bb]<>'|' then c3:=c3+chained[bb] else break;
  for bb:=bb+1 to length(chained) do
    if chained[bb]<>'|' then c4:=c4+chained[bb] else break;
  case mode of
    1: result:=c1;
    2: result:=c2;
    3: result:=c3;
    4: result:=c4;
    5: if c3<>'-' then result:=c2+' ['+c3+']' else result:=c2;
  end;
end;

procedure changeddata_getsample;
begin
  changeddata_sample:='';
  for b:=1 to Form1.StringGrid1.RowCount-1 do changeddata_sample:=changeddata_sample+Form1.StringGrid1.Cells[1,b];
  for b:=1 to Form1.StringGrid3.RowCount-1 do changeddata_sample:=changeddata_sample+Form1.StringGrid3.Cells[2,b];
end;

procedure set_changeddata;
var g: string;
begin
  g:='';
  for b:=1 to Form1.StringGrid1.RowCount-1 do g:=g+Form1.StringGrid1.Cells[1,b];
  for b:=1 to Form1.StringGrid3.RowCount-1 do g:=g+Form1.StringGrid3.Cells[2,b];
  if changeddata_sample=g then changeddata:=false else changeddata:=true;
  if changeddata
  then Form1.StatusBar1.Panels.Items[2].Text:=' *'
  else Form1.StatusBar1.Panels.Items[2].Text:='';
end;

procedure TForm1.DrawGraphic(X, Y, AWidth, Aheight: Integer; Graphic: TGraphic);
var
  Ratio: Double;
begin
  if (AWidth<=0) or (AHeight<=0) then
  begin
    if Graphic.Width=0 then ratio := 1 else ratio := Graphic.Height/Graphic.Width;
    if AWidth<=0 then AWidth := round(AHeight/ratio) else
      if AHeight<=0 then AHeight := round(AWidth * ratio);
  end;
  if (AWidth>0) and (AHeight>0)
  then Printer.Canvas.StretchDraw(Bounds(X,Y,AWidth,AHeight), Graphic);
end;

function TForm1.CM(Avalue: Double; VertRes: boolean=true): Integer;
begin
  result := MM(AValue*10, vertRes);
end;

function TForm1.MM(AValue: Double; VertRes:boolean=true): Integer;
begin
  if VertRes then
    result := Round(AValue*Printer.YDPI/25.4)
  else
    result := Round(AValue*Printer.XDPI/25.4);
end;

function TForm1.Inch(AValue: Double; VertRes:boolean=true): Integer;
begin
  if VertRes then
    result := Round(AValue*Printer.YDPI)
  else
    result := Round(AValue*Printer.XDPI);
end;

function TForm1.Per(AValue: Double; VertRes:boolean=true): Integer;
begin
  if VertRes then
    result := Round(AValue*Printer.PageHeight/100)
  else
    result := Round(AValue*Printer.PageWidth/100);
end;

procedure TForm1.CenterText(const X, Y: Integer; const AText: string);
var
  Sz: TSize;
begin
  Sz := Printer.Canvas.TextExtent(AText);
  Printer.Canvas.TextOut(X - Sz.cx div 2, Y - Sz.cy div 2, AText);
end;

//-- File menu -----------------------------------------------------------------
// Save report to file
procedure TForm1.MenuItem14Click(Sender: TObject);
var
  tfdir, tfname, tfext: shortstring;
  unt: string;
begin
  SaveDialog1.InitialDir:=untcommonproc.userdir;
  SaveDialog1.Title:=MESSAGE06;
  SaveDialog1.Filter:=MESSAGE07;
  SaveDialog1.FilterIndex:=1;
  SaveDialog1.Filename:=MESSAGE29;
  if SaveDialog1.Execute=false then exit;
  s:=SaveDialog1.FileName;
  if length(s)=0 then exit;
  fsplit(s,tfdir,tfname,tfext);
  if FSearch(tfname+tfext,tfdir)<>'' then
    if MessageDlg(MESSAGE09,mtConfirmation, [mbYes, mbNo],0)=mrNo then exit;
  try
    with Memo1.Lines do
    begin
      Clear;
      Add(MESSAGE17+' - '+untmodules.NameModule[modnum]);
      Add('--------------------------------------------------------------------------------');
      Add(TabSheet2.Caption+':');
      for b:=1 to 15 do
      begin
        s:='';
        for bbb:=1 to 12-length(Splitter2(NameActiveElements[modnum,b-1],2)) do s:=s+' ';
        unt:=Splitter2(NameActiveElements[modnum,b-1],3);
        if unt='-' then unt:='';
        if b<StringGrid3.RowCount then Add(' '+Splitter2(NameActiveElements[modnum,b-1],1)+' '+Splitter2(NameActiveElements[modnum,b-1],2)+':'+s+StringGrid3.Cells[2,b]+' '+unt);
      end;
      Add('');
      Add(Label3.Caption+':');
      for b:=1 to 15 do
      begin
        s:='';
        for bbb:=1 to 15-length(Splitter1(NameDataIn[modnum,b-1],1)) do s:=s+' ';
        unt:=Splitter1(NameDataIn[modnum,b-1],2);
        if unt='-' then unt:='';
        if b<StringGrid1.RowCount then Add(' '+Splitter1(NameDataIn[modnum,b-1],1)+':'+s+StringGrid1.Cells[1,b]+' '+unt);
      end;
      Add('');
      Add(Label2.Caption+':');
      for b:=1 to 15 do
      begin
        s:='';
        for bbb:=1 to 15-length(Splitter1(NameDataOut[modnum,b-1],1)) do s:=s+' ';
        unt:=Splitter1(NameDataOut[modnum,b-1],2);
        if unt='-' then unt:='';
        if b<StringGrid2.RowCount then Add(' '+Splitter1(NameDataOut[modnum,b-1],1)+':'+s+StringGrid2.Cells[1,b]+' '+unt);
      end;
      Add('--------------------------------------------------------------------------------');
      Add(Form2.Label1.Caption+' (C)2012 Pozsár Zsolt <http://www.cheapapps-series.info>');
      SaveToFile(SaveDialog1.FileName);
    end;
    changeddata_getsample;
    set_changeddata;
  except
    MessageDlg(MESSAGE08,mtError,[mbOk],0);
  end;
end;

// Load initial data to file
procedure TForm1.MenuItem27Click(Sender: TObject);
var
  Child: TDOMNode;
  xdoc: TXMLDocument;
  j: byte;
begin
  OpenDialog1.InitialDir:=untcommonproc.userdir;
  OpenDialog1.Title:=MESSAGE21;
  OpenDialog1.Filter:=MESSAGE20;
  OpenDialog1.FilterIndex:=1;
  if OpenDialog1.Execute=false then exit;
  try
    ReadXMLFile(xdoc,OpenDialog1.FileName);
    Child:=xdoc.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
      // read 'info' section
      if Child.NodeName='info' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
            begin
              if Item[j].NodeName='app_name' then
                if Item[j].FirstChild.NodeValue<>appname then
                begin
                  showmessage(MESSAGE22);
                  break;
                end;
              if Item[j].NodeName='app_version' then
                if Item[j].FirstChild.NodeValue<>version then showmessage(MESSAGE24);
              if Item[j].NodeName='module_id' then
                if Item[j].FirstChild.NodeValue<>moduleID[modnum] then
                begin
                  showmessage(MESSAGE23+Item[j].FirstChild.NodeValue+moduleID[modnum]);
                  break;
                end;
            end;
          finally
            Free;
          end;
      // read 'active_elements' section
      if Child.NodeName='active_elements' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
              if StringGrid3.RowCount>j+1 then
                StringGrid3.Cells[2,j+1]:=Item[j].FirstChild.NodeValue;
          finally
            set_changeddata;
            Free;
          end;
      // read 'input_values' section
      if Child.NodeName='input_values' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
              if StringGrid1.RowCount>j+1 then
                StringGrid1.Cells[1,j+1]:=Item[j].FirstChild.NodeValue;
          finally
            set_changeddata;
            Free;
          end;
      Child := Child.NextSibling;
    end;
    xdoc.Free;
  except
    MessageDlg(MESSAGE25,mtError,[mbOk],0);
  end;
  AddToRecentFiles(Opendialog1.FileName);
end;

// Save initial data to file
procedure TForm1.MenuItem7Click(Sender: TObject);
var
  tfdir, tfname, tfext: shortstring;
  xdoc: TXMLDocument;
  RootNode, ParentNode, nofilho: TDOMNode;

  // file format:
  // <?xml version="1.0"?>
  // <xml>
  //   <info>
  //     <app_name>power_supplies</app_name>
  //     <app_version>0.2.1</app_version>
  //     <module_id>ps01</module_id>
  //   </info>
  //   <input_values>
  //     <value id="1">10</value>
  //     <value id="2">1001</value>
  //   </input_values>
  //   <active_elements>
  //     <value id="1">2</value>
  //     <value id="2">211</value>
  //   </active_elements>
  // </xml>

begin
  SaveDialog1.InitialDir:=untcommonproc.userdir;
  SaveDialog1.Title:=MESSAGE19;
  SaveDialog1.Filter:=MESSAGE20;
  SaveDialog1.FilterIndex:=1;
  SaveDialog1.Filename:='initial_data.cav';
  if SaveDialog1.Execute=false then exit;
  s:=SaveDialog1.FileName;
  if length(s)=0 then exit;
  fsplit(s,tfdir,tfname,tfext);
  if FSearch(tfname+tfext,tfdir)<>'' then
    if MessageDlg(MESSAGE09,mtConfirmation, [mbYes, mbNo],0)=mrNo then exit;
  try
    xdoc:=TXMLDocument.Create;
    RootNode:=xdoc.CreateElement('cav');
    xdoc.AppendChild(RootNode);
    RootNode:=xdoc.DocumentElement;
    ParentNode:=xdoc.CreateElement('info');
    RootNode.AppendChild(ParentNode);
    ParentNode:=xdoc.CreateElement('app_name');
    nofilho:=xdoc.CreateTextNode(appname);
    ParentNode.AppendChild(nofilho);
    RootNode.ChildNodes.Item[0].AppendChild(parentNode);
    ParentNode:=xdoc.CreateElement('app_version');
    nofilho:=xdoc.CreateTextNode(version);
    ParentNode.AppendChild(nofilho);
    RootNode.ChildNodes.Item[0].AppendChild(parentNode);
    ParentNode:=xdoc.CreateElement('module_id');
    nofilho:=xdoc.CreateTextNode(untmodules.ModuleID[modnum]);
    ParentNode.AppendChild(nofilho);
    RootNode.ChildNodes.Item[0].AppendChild(parentNode);
    RootNode:=xdoc.DocumentElement;
    ParentNode:=xdoc.CreateElement('active_elements');
    RootNode.AppendChild(ParentNode);
    for b:=1 to 15 do
      if b<StringGrid3.RowCount then
      begin
        ParentNode:=xdoc.CreateElement('value_'+inttostr(b-1));
        nofilho:=xdoc.CreateTextNode(StringGrid3.Cells[2,b]);
        ParentNode.AppendChild(nofilho);
        RootNode.ChildNodes.Item[1].AppendChild(parentNode);
      end;
    RootNode:=xdoc.DocumentElement;
    ParentNode:=xdoc.CreateElement('input_values');
    RootNode.AppendChild(ParentNode);
    for b:=1 to 15 do
      if b<StringGrid1.RowCount then
      begin
        ParentNode:=xdoc.CreateElement('value_'+inttostr(b-1));
        nofilho:=xdoc.CreateTextNode(StringGrid1.Cells[1,b]);
        ParentNode.AppendChild(nofilho);
        RootNode.ChildNodes.Item[2].AppendChild(parentNode);
      end;
    WriteXMLFile(xdoc,SaveDialog1.FileName);
    xdoc.free;
  except
    MessageDlg(MESSAGE08,mtError,[mbOk],0);
  end;
end;

// Load recent file
procedure TForm1.MenuItem4Click(Sender: TObject);
var
  RecentFilesMenuItem: TMenuItem;
  Child: TDOMNode;
  xdoc: TXMLDocument;
  j: byte;
begin
  RecentFilesMenuItem:=TMenuItem(Sender);
  try
    ReadXMLFile(xdoc,RecentFilesMenuItem.Caption);
    Child:=xdoc.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
      // read 'info' section
      if Child.NodeName='info' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
            begin
              if Item[j].NodeName='app_name' then
                if Item[j].FirstChild.NodeValue<>appname then
                begin
                  showmessage(MESSAGE22);
                  break;
                end;
              if Item[j].NodeName='app_version' then
                if Item[j].FirstChild.NodeValue<>version then showmessage(MESSAGE24);
              if Item[j].NodeName='module_id' then
                if Item[j].FirstChild.NodeValue<>moduleID[modnum] then
                begin
                  showmessage(MESSAGE23+Item[j].FirstChild.NodeValue+moduleID[modnum]);
                  break;
                end;
            end;
          finally
            Free;
          end;
      // read 'active_elements' section
      if Child.NodeName='active_elements' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
              if StringGrid3.RowCount>j+1 then
                StringGrid3.Cells[2,j+1]:=Item[j].FirstChild.NodeValue;
          finally
            set_changeddata;
            Free;
          end;
      // read 'input_values' section
      if Child.NodeName='input_values' then
        with Child.ChildNodes do
          try
            for j:=0 to (Count-1) do
              if StringGrid1.RowCount>j+1 then
                StringGrid1.Cells[1,j+1]:=Item[j].FirstChild.NodeValue;
          finally
            set_changeddata;
            Free;
          end;
      Child := Child.NextSibling;
    end;
    xdoc.Free;
  except
    MessageDlg(MESSAGE25,mtError,[mbOk],0);
  end;
  AddToRecentFiles(RecentFilesMenuItem.Caption);
end;

// Print report
procedure TForm1.MenuItem29Click(Sender: TObject);
var
  Pic: TPicture;
  x1, x2, y1, y2: integer;
  unt: string;
begin
  x1:=cm(1);
  x2:=Printer.PageWidth-mm(5);
  y1:=cm(2);
  y2:=Printer.PageHeight-cm(1);
  PrintDialog1.Title:=MESSAGE26;
  if PrintDialog1.Execute then
    try
      Printer.Title:=MESSAGE17;
      Printer.BeginDoc;
      Printer.Canvas.Font.Color:=clBlack;
      Printer.Canvas.Font.Size:=12;
      Printer.Canvas.Font.Bold:=true;
      CenterText(Printer.PageWidth div 2, y1,MESSAGE17);
      CenterText(Printer.PageWidth div 2, y1+mm(6),untmodules.NameModule[modnum]);
      Printer.Canvas.Font.Size:=10;
      Printer.Canvas.TextOut(x1,y1+cm(2),MESSAGE28+':');
      Pic:=TPicture.Create;
      Pic.Bitmap:=Image1.Picture.Bitmap;
      DrawGraphic(x1+cm(5), y1+cm(2), cm(8), 0, Pic.Graphic);
      Pic.Free;
      Printer.Canvas.Font.Size:=10;
      Printer.Canvas.TextOut(x1,y1+cm(11),TabSheet2.Caption+':');
      Printer.Canvas.Font.Bold:=false;
      for b:=1 to 15 do
      begin
        if b<StringGrid3.RowCount then
        begin
          Printer.Canvas.TextOut(x1+mm(5),y1+cm(11)+(b*mm(6)),Splitter2(NameActiveElements[modnum,b-1],1)+' '+Splitter2(NameActiveElements[modnum,b-1],2)+':');
          unt:=Splitter2(NameActiveElements[modnum,b-1],3);
          if unt='-' then unt:='';
          Printer.Canvas.TextOut(x1+mm(30),y1+cm(11)+(b*mm(6)),StringGrid3.Cells[2,b]+' '+unt);
        end;
      end;
      Printer.Canvas.Font.Bold:=true;
      Printer.Canvas.TextOut(x1+cm(7),y1+cm(11),Label3.Caption+':');
      Printer.Canvas.Font.Bold:=false;
      for b:=1 to 15 do
      begin
        if b<StringGrid1.RowCount then
        begin
          Printer.Canvas.TextOut(x1+mm(75),y1+cm(11)+(b*mm(6)),Splitter1(NameDataIn[modnum,b-1],1)+':');
          unt:=Splitter1(NameDataIn[modnum,b-1],2);
          if unt='-' then unt:='';
          Printer.Canvas.TextOut(x1+mm(100),y1+cm(11)+(b*mm(6)),StringGrid1.Cells[1,b]+' '+unt);
        end;
      end;
      Printer.Canvas.Font.Bold:=true;
      Printer.Canvas.TextOut(x1+mm(140),y1+cm(11),Label2.Caption+':');
      Printer.Canvas.Font.Bold:=false;
      for b:=1 to 15 do
      begin
        if b<StringGrid2.RowCount then
        begin
        Printer.Canvas.TextOut(x1+mm(145),y1+cm(11)+(b*mm(6)),Splitter1(NameDataOut[modnum,b-1],1)+':');
        unt:=Splitter1(NameDataOut[modnum,b-1],2);
        if unt='-' then unt:='';
        Printer.Canvas.TextOut(x1+mm(170),y1+cm(11)+(b*mm(6)),StringGrid2.Cells[1,b]+' '+unt);
        end;
      end;
      Printer.Canvas.Pen.Color:=clBlack;
      Printer.canvas.Pen.Width:=2;
      Printer.Canvas.Line(x1, y2-38,x2,y2-38);
      Printer.Canvas.Font.Size:=10;
      Printer.Canvas.TextOut(x1,y2-25,Form2.Label1.Caption+' (C)2012 Pozsár Zsolt <http://www.cheapapps-series.info>');
      Printer.EndDoc;
    except
      Printer.Abort;
      MessageDlg(MESSAGE27,mtError,[mbOk],0);
    end;
end;

// Quit
procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  Form1.Close;
  Application.Terminate;
end;

// -- Operation menu -----------------------------------------------------------
// Reset input data
procedure TForm1.MenuItem40Click(Sender: TObject);
begin
  if changeddata then
  begin
    if MessageDlg(MESSAGE14,mtConfirmation, [mbYes, mbNo],0)=mrYes
    then MenuItem14Click(Sender);
  end;
  for b:=0 to 7 do SetInputData(modnum,b,0);
  for b:=0 to 7 do SetActiveElementParameters(modnum,b,0);
  for b:=1 to StringGrid1.RowCount-1 do StringGrid1.Cells[1,b]:='0';
  for b:=1 to StringGrid2.RowCount-1 do StringGrid2.Cells[1,b]:='0';
  for b:=1 to StringGrid3.RowCount-1 do StringGrid3.Cells[2,b]:='0';
  changeddata_getsample;
  set_changeddata;
end;

// Calculate!
procedure TForm1.MenuItem41Click(Sender: TObject);
var
  e: integer;
  rnum: real;
  snum: string;
begin
  // Set input data
  for b:=1 to StringGrid1.RowCount-1 do
  begin
    s:='';
    snum:=StringGrid1.Cells[1,b];
    if snum='' then snum:='0';
    for e:=1 to length(snum) do
      if snum[e]<>',' then s:=s+snum[e] else s:=s+'.';
    val(s,rnum,e);
    if rnum=0 then StringGrid1.Cells[1,b]:='0' else StringGrid1.Cells[1,b]:=FormatFloat('######.###',rnum);
    if e>0 then
    begin
      showmessage(MESSAGE15+': '+Splitter1(NameDataIn[modnum,b-1],1));
      StringGrid1.Cells[1,b]:='0';
      exit;
    end;
    SetInputData(modnum,b-1,rnum);
  end;
  // Set parameters of active elements
  for b:=1 to StringGrid3.RowCount-1 do
  begin
    s:='';
    snum:=StringGrid3.Cells[2,b];
    if snum='' then snum:='0';
    for e:=1 to length(snum) do
      if snum[e]<>',' then s:=s+snum[e] else s:=s+'.';
    val(s,rnum,e);
    if rnum=0 then StringGrid3.Cells[2,b]:='0' else StringGrid3.Cells[2,b]:=FormatFloat('######.###',rnum);
    if e>0 then
    begin
      showmessage(MESSAGE15+': '+Splitter2(NameDataIn[modnum,b-1],1));
      StringGrid3.Cells[2,b]:='0';
      exit;
    end;
    SetActiveElementParameters(modnum,b-1,rnum);
  end;
  if Calculate(modnum)=false then ShowMessage(EMessage);
  for b:=1 to 15 do
    if b<StringGrid2.RowCount then
    begin
      s:=FormatFloat('######.###',GetOutputData(modnum,b-1));
      if s='' then StringGrid2.Cells[1,b]:='0' else StringGrid2.Cells[1,b]:=s;
    end;
  if untcommonproc.r=false then
  begin
    Button1.Enabled:=false;
    Button3.Enabled:=false;
    MenuItem17.Enabled:=false;
    MenuItem18.Enabled:=false;
    ShowMessage(MESSAGE10+#10+#13+#10+#13+MESSAGE11+#10+#13+#10+#13+MESSAGE12);
  end;
end;

// -- Configuration menu -------------------------------------------------------
// On-line registration
procedure TForm1.MenuItem32Click(Sender: TObject);
begin
  if untcommonproc.lang='hu'
  then runbrowser(untcommonproc.HOMEPAGE+'/cheapapps/registration_hu.php')
  else runbrowser(untcommonproc.HOMEPAGE+'/cheapapps/registration_en.php');
end;

// Settings
procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  Form4.Show;
end;

// Save settings
procedure TForm1.MenuItem19Click(Sender: TObject);
begin
  untcommonproc.savecfg;
end;

// -- Help menu ----------------------------------------------------------------
// Help
procedure TForm1.MenuItem2Click(Sender: TObject);
begin
{$IFDEF LINUX}
  if FSearch('help/'+lang+'.html',exepath)<>''
  then runbrowser(exepath+'help/'+lang+'.html')
  else runbrowser(exepath+'help/en.html');
{$ENDIF}
{$IFDEF WIN32}
  if FSearch('help\'+lang+'.html',exepath)<>''
  then runbrowser(exepath+'help\'+lang+'.html')
  else runbrowser(exepath+'help\en.html');
{$ENDIF}
end;

// Search new version
procedure TForm1.MenuItem15Click(Sender: TObject);
begin
  if offline=false then
    if searchupdate
    then ShowMessage(MESSAGE05)
    else ShowMessage(MESSAGE16)
end;

// On-line bugreport
procedure TForm1.MenuItem33Click(Sender: TObject);
begin
  if untcommonproc.lang='hu'
  then runbrowser(untcommonproc.HOMEPAGE+'/cheapapps/bugreport_hu.php')
  else runbrowser(untcommonproc.HOMEPAGE+'/cheapapps/bugreport_en.php');
end;

// Internet/Project's homepage
procedure TForm1.MenuItem36Click(Sender: TObject);
begin
  if untcommonproc.lang='hu'
  then runbrowser(untcommonproc.HOMEPAGE)
  else runbrowser(untcommonproc.HOMEPAGE+'/english');
end;

// Internet/Pozsi's homepage
procedure TForm1.MenuItem21Click(Sender: TObject);
begin
  if untcommonproc.lang='hu'
  then runbrowser(untcommonproc.HOMEPAGE)
  else runbrowser(untcommonproc.HOMEPAGE+'/en');
end;

// About
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

// -- Events ------------------------------------------------------------------
// Combobox1 OnChange exent
procedure TForm1.ComboBox1Change(Sender: TObject);
var
  oldmessage: string;
begin
  if changeddata then
  begin
    if MessageDlg(MESSAGE14,mtConfirmation, [mbYes, mbNo],0)=mrYes
    then MenuItem14Click(Sender);
    changeddata:=false;
    StatusBar1.Panels.Items[2].Text:='';
  end;
  for modnum:=0 to 63 do
    if ComboBox1.Items.Strings[ComboBox1.ItemIndex]=untmodules.NameModule[modnum]
    then break;
  s:=inttostr(modnum+1);
  if length(s)=1 then s:='0'+s;
  try
    {$IFDEF LINUX}
    Image1.Picture.LoadFromFile(exepath+'figures/module_'+s+'.png');
    {$ENDIF}
    {$IFDEF WIN32}
    Image1.Picture.LoadFromFile(exepath+'figures\module_'+s+'.png');
    {$ENDIF}
    if StatusBar1.Panels.Items[3].Text=MESSAGE13
    then StatusBar1.Panels.Items[3].Text:=oldmessage;
  except
    if StatusBar1.Panels.Items[3].Text<>MESSAGE13
    then oldmessage:=StatusBar1.Panels.Items[3].Text;
    StatusBar1.Panels.Items[3].Text:=MESSAGE13;
    Image1.Picture.Clear;
  end;
  Label1.Enabled:=HTSLActive[modnum];
  with StringGrid1 do
  begin
    RowCount:=1;
    for b:=0 to 15 do
      if length(NameDataIn[modnum,b])>0 then
      begin
        RowCount:=RowCount+1;
        Cells[0,b+1]:=Splitter1(NameDataIn[modnum,b],4);
        Cells[1,b+1]:='0';
        Cells[2,b+1]:=Splitter1(NameDataIn[modnum,b],3);
      end;
    AutoSizeColumns;
    Columns.Items[2].Width:=0;
    Columns.Items[1].Width:=Width-Columns.Items[0].Width;
    CheckBox2Change(Sender);
  end;
  with StringGrid2 do
  begin
    RowCount:=1;
    for b:=0 to 15 do
      if length(NameDataOut[modnum,b])>0 then
      begin
        RowCount:=RowCount+1;
        Cells[0,b+1]:=Splitter1(NameDataOut[modnum,b],4);
        Cells[1,b+1]:='0';
        Cells[2,b+1]:=Splitter1(NameDataOut[modnum,b],3);
      end;
    AutoSizeColumns;
    Columns.Items[2].Width:=0;
    Columns.Items[1].Width:=Width-Columns.Items[0].Width;
    CheckBox1Change(Sender);
    CheckBox3Change(Sender);
  end;
  with StringGrid3 do
  begin
    RowCount:=1;
    for b:=0 to 15 do
      if length(NameActiveElements[modnum,b])>0 then
      begin
        RowCount:=RowCount+1;
        Cells[0,b+1]:=Splitter2(NameActiveElements[modnum,b],1);
        Cells[1,b+1]:=Splitter2(NameActiveElements[modnum,b],5);
        Cells[2,b+1]:='0';
        Cells[3,b+1]:=Splitter2(NameActiveElements[modnum,b],4);
      end;
    AutoSizeColumns;
      Columns.Items[3].Width:=0;
      Columns.Items[2].Width:=Width-Columns.Items[0].Width-Columns.Items[1].Width;
    CheckBox1Change(Sender);
    CheckBox3Change(Sender);
  end;
end;

// Show input data''s hint
procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  untcommonproc.showhint1:=CheckBox2.Checked;
  with StringGrid1 do
    begin
    if CheckBox2.Checked then
    begin
      Columns.Items[1].Width:=100;
      Columns.Items[2].Width:=Width-Columns.Items[0].Width-Columns.Items[1].Width;
    end else
    begin
      Columns.Items[2].Width:=0;
      Columns.Items[1].Width:=Width-Columns.Items[0].Width;
    end;
  end;
end;

// Show result''s hint
procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  untcommonproc.showhint2:=CheckBox1.Checked;
  with StringGrid2 do
    begin
    if CheckBox1.Checked then
    begin
      Columns.Items[1].Width:=100;
      Columns.Items[2].Width:=Width-Columns.Items[0].Width-Columns.Items[1].Width;
    end else
    begin
      Columns.Items[2].Width:=0;
      Columns.Items[1].Width:=Width-Columns.Items[0].Width;
    end;
  end;
end;

// Show active elements'' hint
procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  untcommonproc.showhint3:=CheckBox3.Checked;
  with StringGrid3 do
    begin
    if CheckBox3.Checked then
    begin
      Columns.Items[2].Width:=64;
      Columns.Items[3].Width:=Width-Columns.Items[0].Width-Columns.Items[1].Width-Columns.Items[2].Width;
    end else
    begin
      Columns.Items[3].Width:=0;
      Columns.Items[2].Width:=Width-Columns.Items[0].Width-Columns.Items[1].Width;
    end;
  end;
end;

// How to set it? - help
procedure TForm1.Label1Click(Sender: TObject);
begin
  Form5.Show;
end;

// StringGrid1 EditingDone
procedure TForm1.StringGrid1EditingDone(Sender: TObject);
begin
  set_changeddata;
end;

// OnShow event
procedure TForm1.FormShow(Sender: TObject);
var
  b: byte;
begin
  makeuserdir;
  getlang;
  getexepath;
  loadcfg;
  Application.Title:=Form2.Label1.Caption;
  if appmode=30 then untcommonproc.offline:=true;
  if untcommonproc.offline=true
  then StatusBar1.Panels.Items[1].Text:=' '+MESSAGE03
  else StatusBar1.Panels.Items[1].Text:=' '+MESSAGE04;
  MenuItem15.Enabled:=not offline;
  MenuItem33.Enabled:=not offline;
  MenuItem35.Enabled:=not offline;
  CheckBox2.Checked:=untcommonproc.showhint1;
  CheckBox1.Checked:=untcommonproc.showhint2;
  CheckBox3.Checked:=untcommonproc.showhint3;
  if offline=false then
    if searchupdate then StatusBar1.Panels.Items[3].Text:=' '+MESSAGE05;
  CollectNames;
  for b:=0 to 63 do
    if length(untmodules.NameModule[b])<>0
    then ComboBox1.Items.Add(untmodules.NameModule[b]);
  ComboBox1.Sorted:=true;
  ComboBox1.ItemIndex:=0;
  ComboBox1Change(Sender);
  if savehistory=true then loadhis;
  changeddata_getsample;
  set_changeddata;
end;

// Form1 OnClose event
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if changeddata then
    if MessageDlg(MESSAGE14,mtConfirmation, [mbYes, mbNo],0)=mrYes
    then MenuItem14Click(Sender);
  if savehistory=true then savehis;
  CanClose:=true;
end;

end.

