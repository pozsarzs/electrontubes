{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | commonproc.pp                                                            | }
{ | Common procedures and functions                                          | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

unit untcommonproc; 
{$MODE OBJFPC}{$H-}
interface
uses
  {$IFDEF WIN32}Windows,{$ENDIF} Classes, SysUtils, LResources, Dialogs,
  GraphUtil, Graphics, INIFiles, dos,
  // foreign units:
  httpsend;

var
  b: byte;                                              // general byte variable
  browserapp: string;                            // external browser application
  confdir: string;                              // users configuration directory
  docdir: string;                                    // users document directory
  exepath, p: shortstring;                        // path of the executable file
  lang: string[2];                                                   // language
  mailerapp: string;                              // external mailer application
  offline: boolean;                                             // off-line mode
  r: boolean;                                                    // registration
  s: string;                                          // general string variable
  serialnumber: string;                                   // users serial number
  showhint1, showhint2, showhint3: boolean;                 // show descriptions
  tmpdir: string;                                // directory of temporary files
  userdir: string;                                            // users directory
  username: string[30];                               // users registration name
  savehistory: boolean;                                     // save load history
  appmode: byte;

const
  APPNAME='electrontubes';
  EMAIL='pozsarzs@gmail.com';
  FB_PAGE='http://www.facebook.com/cheapapps';
  HOMEPAGE='http://www.pozsarzs.hu';
  PRJ_HOMEPAGE='http://www.cheapapps-series.info';
  VERSION='0.3.1';
  CFN=APPNAME+'.ini';
  HFN=APPNAME+'.his';
 {$IFDEF WIN32}
  CSIDL_PROFILE=40;
  SHGFP_TYPE_CURRENT=0;
 {$ENDIF}

function getexepath: string;
function getlang: string;
function searchupdate: boolean;
procedure crk;
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
 {$IFDEF LINUX}
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

// Check registration key
procedure crk;
var
  path: string;
begin
  r:=false;
 {$IFDEF LINUX}
  path:=userdir+'Reg_keys/';
 {$ENDIF}
 {$IFDEF WIN32}
  path:=userdir+'Reg_keys\';
 {$ENDIF}
  if FSearch(appname+'.key',path)<>''then
  begin
    username:=checkregkey(path+appname+'.key', serialnumber);
    if (username='!') or (username=' ') then r:=false else r:=true;
  end;
end;

// Load configuration
procedure loadcfg;
var
  ini: TINIFile;
begin
  ini:=TIniFile.Create(confdir+cfn);
  try
    serialnumber:=ini.ReadString('General','SerialNumber','');
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
  his:=TIniFile.Create(confdir+hfn);
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
 {$IFDEF LINUX}
  tmpdir:='/tmp/';
  userdir:=getenvironmentvariable('HOME');
  confdir:=userdir+'/.CheapApps/';
  {$I-}mkdir(confdir);{$I+} ioresult;
  userdir:=userdir+'/CheapApps/';
  {$I-}mkdir(userdir);{$I+} ioresult;
  {$I-}mkdir(userdir+'/Reg_keys');{$I+} ioresult;
 {$ENDIF}
 {$IFDEF WIN32}
  tmpdir:=getwindowstemp;
  userdir:=getuserprofile;
  confdir:=userdir+'\Application data\';
  {$I-}mkdir(confdir);{$I+} ioresult;
  confdir:=confdir+'\CheapApps\';
  {$I-}mkdir(confdir);{$I+} ioresult;
  userdir:=userdir+'\CheapApps\';
  {$I-}mkdir(userdir);{$I+} ioresult;
  {$I-}mkdir(userdir+'\Reg_keys');{$I+} ioresult;
 {$ENDIF}
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
  assignfile(ini,confdir+cfn);
  try
    rewrite(ini);
    writeln(ini,'; '+appname+' v'+version);
    writeln(ini,'');
    writeln(ini,'[General]');
    writeln(ini,'SerialNumber=',serialnumber);
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
  assignfile(his,confdir+hfn);
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

