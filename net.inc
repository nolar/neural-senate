{$I funcs.inc}

procedure constructCorrects;
var st:extended;
    a:word;
begin
 st:=2/(tblSize-1);
 corr[1]:=-1;
 for a:=2 to tblSize do
  corr[a]:=corr[a-1]+st;
end;

function getClass(r:extended):word;
var a,result:word;
    st:extended;
begin
 st:=2/(tblSize-1);
 result:=1;
 for a:=2 to tblSize do
  if(abs(r-corr[a])<abs(r-corr[result]))then
   result:=a;
 getClass:=result;
end;

procedure randomizeWeights;
var a,b:byte;
begin
 for a:=1 to symSize do
  for b:=1 to symSize do
   if(random<0.5)then
    wei1[a,b]:=random else
    wei1[a,b]:=-random;
 for a:=1 to symSize do
  if(random<0.5)then
   wei2[a]:=random else
   wei2[a]:=-random;
end;

function fireSymbol(s:PSymbol):extended;
var a,b:byte;
begin
 for a:=1 to symSize do
  begin
   sum1[a]:=0;
   for b:=1 to symSize do
    sum1[a]:=sum1[a]+s^[a,b]*wei1[a,b];
   res1[a]:=func(sum1[a]);
  end;
 sum2:=0;
 for a:=1 to symSize do
  sum2:=sum2+res1[a]*wei2[a];
 res2:=func(sum2);
 fireSymbol:=res2;
end;

procedure teachSymbol(s:PSymbol;e:extended);
var a,b:byte;
begin
 e:=e*dfunc(sum2);
 for a:=1 to symSize do
  begin
   err1[a]:=(e*wei2[a])*dfunc(sum1[a]);
   wei2[a]:=wei2[a]+e*res1[a];
  end;
 for a:=1 to symSize do
  for b:=1 to symSize do
   wei1[a,b]:=wei1[a,b]+err1[a]*s^[a,b];
end;

procedure teachNet(me:extended);
var e:extended;
    a:word;
    needMore:boolean;
begin
 constructCorrects;

 repeat
  needMore:=false;
  for a:=1 to tblSize do
   begin
    e:=corr[a]-fireSymbol(@(table^[a].view));
    if(abs(e)>abs(me))then
     begin
      needMore:=true;
      write('#',a:2,' E=',e:20:15,#13);
      teachSymbol(@(table^[a].view),e);
     end;
   end;
 until(not(needMore));
end;

procedure fireNet(s:word);
var a:word;
begin
 for a:=1 to askSize do
  begin
   senate[s,a]:=getClass(fireSymbol(@(ask^[a].view)));
   ask^[a].letter:=table^[senate[s,a]].letter;
  end;
end;


procedure writeSenator(s:word);
var a:word;
begin
 writeln('Сенатор #',s);
 for a:=1 to askSize do
  writeln(a,'й символ есть "',ask^[a].letter,'"');
 if(s=senatorCount)then
  wrtln('=',DividerSize) else
  wrtln('-',DividerSize);
end;

procedure writeResults;
var a,b,i:word;
    c,r:array[1..MaxTblSize]of word;
    senRight:array[1..MaxSenatorCount]of boolean;
begin
 writeln('ИТОГО:');

 for a:=1 to askSize do
  begin
   for b:=1 to tblSize do
    c[b]:=0;
   for b:=1 to senatorCount do
    c[senate[b,a]]:=c[senate[b,a]]+1;
   i:=1;
   for b:=2 to tblSize do
    if(c[b]>c[i])then
     i:=b;
   r[a]:=i;
   writeln(a,'й символ есть "',table^[i].letter,'":',(c[i]*100 div senatorCount):3,'%');
  end;
 wrtln('-',DividerSize);
 for a:=1 to senatorCount do
  begin
   senRight[a]:=true;
   for b:=1 to askSize do
    senRight[a]:=senRight[a] and (senate[a,b]=r[b]);
   if(senRight[a])then
    writeln('Сенатор #',a,' был прав');
  end;
end;
