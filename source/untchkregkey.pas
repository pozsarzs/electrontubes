{ +--------------------------------------------------------------------------+ }
{ | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ] | }
{ | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                     | }
{ | keycheck.pp                                                              | }
{ | Registration key checker                                                 | }
{ +--------------------------------------------------------------------------+ }
{ ************  This file is not public, contents trade secret! ************** }

unit untchkregkey;
interface
var
  c1: integer;
const
  c2 = 16731;
  c3 = 87342;
  appID = '95';

function checkregkey(filename, serial: string): string;

implementation

// Decrypt registration data
function decrypt (const s: string; key: Word): string;
var
  i: byte;
begin
  decrypt:=s;
  for i:=1 to length(s) do
  begin
    decrypt[i]:=char(byte(s[i]) xor (key shr 8));
    key:=(byte(s[i])+key)*c2+c3;
  end
end;

// Check registration key
function checkregkey(filename, serial: string): string;
var
  key, ss: string;
  t: file of char;
  c: char;
  ii, e: integer;
  b: byte;
begin
  if length(serial)<>20 then
  begin
    checkregkey:='!';
    exit;
  end;
  assign(t,filename);
  {$I-}
  reset(t);
  key:='';
  repeat
    read(t,c);
    key:=key+c;
  until eof(t);
  {$I+}
  if ioresult<>0 then
  begin
    checkregkey:='!';
    exit;
  end;
  close(t);
  ss:=serial[16]+serial[17]+serial[18]+serial[19]+serial[20];
  val(ss,c1,e);
  if e<>0 then
  begin
    checkregkey:='!';
    exit;
  end;
  key:=decrypt(key,c1);
  if key[56]+key[57]=appID then
  begin
    ss:=key[67]+key[68];
    val(ss,ii,e);
    if e<>0 then
    begin
      checkregkey:='!';
      exit;
    end;
    checkregkey:='';
    for b:=4 to 3+ii do
      checkregkey:=checkregkey+key[b];
  end else checkregkey:='!';
end;

end.
