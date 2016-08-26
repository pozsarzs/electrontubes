{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                | }
{ | commonproc.pp                                                            | }
{ | Common procedures and functions                                          | }
{ +--------------------------------------------------------------------------+ }

{
  Copyright (C) 2012-2016 Pozsar Zsolt

  This program is free software: you can redistribute it and/or modify
it under the terms of the European Union Public License version 1.1.

  This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit untcommonproc; 
{$MODE OBJFPC}{$H-}
interface
uses
  {$IFDEF WIN32}Windows,{$ENDIF} Classes, SysUtils, LResources, Dialogs,
  GraphUtil, Graphics, INIFiles, dos, httpsend;
var
  b: byte;                                              // general byte variable
  browserapp: string;                            // external browser application
  docdir: string;                                    // users document directory
  exepath, p: shortstring;                        // path of the executable file
  lang: string[2];                                                   // language
  mailerapp: string;                              // external mailer application
  offline: boolean;                                             // off-line mode
  s: string;                                          // general string variable
  showhint1, showhint2, showhint3: boolean;                 // show descriptions
  tmpdir: string;                                // directory of temporary files
  userdir: string;                                            // users directory
  username: string[30];                               // users registration name
  savehistory: boolean;                                     // save load history
  appmode: byte;                                               // operation mode
const
  APPNAME='electrontubes';
  EMAIL='pozsarzs@gmail.com';
  HOMEPAGE='http://www.pozsarzs.hu';
  VERSION='0.4.1';
  CFN=APPNAME+'.ini';
  HFN=APPNAME+'.his';
 {$IFDEF UNIX}
  {$I config.inc}
 {$ENDIF}
 {$IFDEF WIN32}
  CSIDL_PROFILE=40;
  SHGFP_TYPE_CURRENT=0;
 {$ENDIF}
 {$IFDEF UNIX}
  DIR_CONFIG='/.config/cheapapps/';
 {$ENDIF}{$IFDEF WIN32}
  DIR_CONFIG='\AppData\Local\cheapapps\config\';
 {$ENDIF}

function getexepath: string;
function getlang: string;
function searchupdate: boolean;
procedure loadcfg;
procedure loadhis;
procedure makeuserdir;
procedure runbrowser(url: string);
procedure runmailer(adr: string);
procedure savecfg;
procedure savehis;

{$IFDEF WIN32}
function SHGetFolderPath(hwndOwner: HWND; nFolder: Integer; hToken: THandle;
         dwFlags: DWORD; pszPath: LPTSTR): HRESULT; stdcall;
         external 'Shell32.dll' name 'SHGetFolderPathA';
{$ENDIF}

Resourcestring
  MESSAGE01='Cannot read the users''s configuration file!';
  MESSAGE02='Cannot write the user''s configuration file!';
  MESSAGE03='Please check browser application setting!';
  MESSAGE04='Please check mailer application setting!';
  MESSAGE05='Missing files! Please reinstall application!';
  MESSAGE07='Cannot write temporary file!';

implementation
uses frmmain;

// Get executable path
function getexepath: string;
begin
  fsplit(paramstr(0),exepath,p,p);
end;

// Get language
function getlang: string;
{$IFDEF WIN32}
var
  Buffer : PChar;
  Size : integer;
{$ENDIF}
begin
 {$IFDEF UNIX}
  s:=getenv('LANG');
 {$ENDIF}
 {$IFDEF WIN32}
  Size:=GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SABBREVLANGNAME, nil, 0);
  GetMem(Buffer, Size);
  try
    GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SABBREVLANGNAME, Buffer, Size);
    s:=string(Buffer);
  finally
    FreeMem(Buffer);
  end;
 {$ENDIF}
  if length(s)=0 then s:='en';
  lang:=LowerCase(s[1..2]);
end;

// Search update
function searchupdate: boolean;
var
  txt: TStringList;
  newversion: string;
begin
  if offline=false then
  begin
    txt:=TStringList.Create;
    with THTTPSend.Create do
    begin
      if HttpGetText(HOMEPAGE+'/upgrade/'+appname+'/prog_version.txt', txt) then
      try
        newversion:=txt.Strings[0];
        if VERSION<>newversion then searchupdate:=true else searchupdate:=false;
      except
      end;
      Free;
    end;
    txt.Free;
  end;
end;

// Load configuration
procedure loadcfg;
var
  ini: TINIFile;
begin
  ini:=TIniFile.Create(userdir+DIR_CONFIG+CFN);
  try
    offline:=ini.ReadBool('General','OffLineMode',false);
    savehistory:=ini.ReadBool('General','SaveHistory',true);
    browserapp:=ini.ReadString('Applications','Browser','');
    mailerapp:=ini.ReadString('Applications','Mailer','');
    showhint1:=ini.ReadBool('Display','ShowDescription1',false);
    showhint2:=ini.ReadBool('Display','ShowDescription2',false);
    showhint3:=ini.ReadBool('Display','ShowDescription3',false);
    ini.Free;
  except
    ShowMessage(MESSAGE01);
  end;
end;

// Load history
procedure loadhis;
var
  his: TINIFile;
begin
  his:=TIniFile.Create(userdir+DIR_CONFIG+hfn);
  try
    for b:=0 to 4 do
      recentfiles[b]:=his.ReadString('History','RecentFile'+inttostr(b),'');
    his.Free;
  except
  end;
  AddToRecentFiles('#');
end;

// Make users directory
procedure makeuserdir;
{$IFDEF WIN32}
var
  buffer: array[0..MAX_PATH] of char;

  function GetUserProfile: string;
  begin
    fillchar(buffer, sizeof(buffer), 0);
    ShGetFolderPath(0, CSIDL_PROFILE, 0, SHGFP_TYPE_CURRENT, buffer);
    result:=string(pchar(@buffer));
  end;

  function GetWindowsTemp: string;
  begin  
    fillchar(buffer,MAX_PATH+1, 0);
    GetTempPath(MAX_PATH, buffer);
    result:=string(pchar(@buffer));
    if result[length(result)]<>'\' then result:=result+'\';
  end;
{$ENDIF}

begin
 {$IFDEF UNIX}
  tmpdir:='/tmp/';
  userdir:=getenvironmentvariable('HOME');
 {$ENDIF}
 {$IFDEF WIN32}
  tmpdir:=getwindowstemp;
  userdir:=getuserprofile;
 {$ENDIF}
  forcedirectories(userdir+DIR_CONFIG);
end;

// Run browser application
procedure runbrowser(url: string);
begin
  Form1.Process1.CommandLine:=browserapp+' '+url;
  try
    Form1.Process1.Execute;
  except
    ShowMessage(MESSAGE03);
  end;
end;

// Run mailer application
procedure runmailer(adr: string);
begin
  Form1.Process2.CommandLine:=mailerapp+' '+adr;
  try
    Form1.Process2.Execute;
  except
    ShowMessage(MESSAGE04);
  end;
end;

// Save configuration
procedure savecfg;
var
  ini: textfile;
// I use alternative solution for save configuration, because INIFiles unit has
// got some bugs.
begin
  assignfile(ini,userdir+DIR_CONFIG+CFN);
  try
    rewrite(ini);
    writeln(ini,'; '+appname+' v'+version);
    writeln(ini,'');
    writeln(ini,'[General]');
    write(ini,'OffLineMode=');if offline=true then writeln(ini,'1') else writeln(ini,'0');
    write(ini,'SaveHistory=');if savehistory=true then writeln(ini,'1') else writeln(ini,'0');
    writeln(ini,'');
    writeln(ini,'[Applications]');
    writeln(ini,'Browser=',browserapp);
    writeln(ini,'Mailer=',mailerapp);
    writeln(ini,'');
    writeln(ini,'[Display]');
    write(ini,'ShowDescription1=');if showhint1=true then writeln(ini,'1') else writeln(ini,'0');
    write(ini,'ShowDescription2=');if showhint2=true then writeln(ini,'1') else writeln(ini,'0');
    write(ini,'ShowDescription3=');if showhint3=true then writeln(ini,'1') else writeln(ini,'0');
    closefile(ini);
  except
    ShowMessage(MESSAGE02);
  end;
end;

// Save history
procedure savehis;
var
  his: textfile;
// I use alternative solution for save configuration, because INIFiles unit has
// got some bugs.
begin
  assignfile(his,userdir+DIR_CONFIG+HFN);
  try
    rewrite(his);
    writeln(his,'; '+appname+' v'+version);
    writeln(his,'');
    writeln(his,'[History]');
      for b:=0 to 4 do
        writeln(his,'RecentFile'+inttostr(b)+'='+recentfiles[b]);
    closefile(his);
  except
  end;
end;

end.

