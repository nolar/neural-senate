function readSymbol(var f:text;sym:PSymbol):char;
var s:string;
    result:char;
    a,b:byte;
begin
 readln(f,s);
 if(symSize=0)then
  symSize:=length(s)-1;
 result:=s[length(s)];
 s[0]:=char(byte(s[0])-1);
 for a:=1 to symSize do
  if(s[a] in OnChars)then
   sym^[1,a]:=1 else
   if(s[a] in OffChars)then
    sym^[1,a]:=-1 else
    sym^[1,a]:=0;
 for b:=2 to symSize do
  begin
   readln(f,s);
   for a:=1 to symSize do
   if(s[a] in OnChars)then
    sym^[b,a]:=1 else
    if(s[a] in OffChars)then
     sym^[b,a]:=-1 else
     sym^[b,a]:=0;
  end;
 readSymbol:=result;
end;

function readTable(fs:string;t:PTable):word;
var f:text;
    result:word;
begin
 assign(f,fs);
 reset(f);
 result:=0;
 while(not(eof(f)))do
  begin
   result:=result+1;
   t^[result].letter:=readSymbol(f,@(t^[result].view));
  end;
 close(f);
 readTable:=result;
end;


procedure wrtln(ch:char;c:word);
var a:word;
begin
 for a:=1 to c do
  write(ch);
 writeln;
end;
