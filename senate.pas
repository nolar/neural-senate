{$X+}
{$E-,N+}
{$M 2048,0,655360}
uses crt;
const
  {Параметры интерфейса}
  MaxSymSize    =10        ;{максимально предусмотренный размер символа}
  MaxTblSize    =50        ;{максимально предусмотренный размер таблиц символов}
  MaxSenatorCount=20       ;{максимальное количество сенаторов}
  OnChars       =['1']     ;{символы таблицы, обозначающие включенную точку}
  OffChars      =['-']     ;{символы таблицы, обозначающие выключенную точку}
  DividerSize   =40        ;{размер разделяющей линии}
  {Параметры сети}
  MaxError      =0.8       ;{максимальная погрешность}
  hConst        =0.2       ;{~(0..1)  меньше-умней, но дольше; больше-тупей, но быстрей}
type
  TSymbol       =array[1..MaxSymSize,1..MaxSymSize]of extended;
  TTable        =array[1..MaxTblSize]of record
                                         letter:char;
                                         view:TSymbol;
                                        end;
  PSymbol       =^TSymbol;
  PTable        =^TTable;
const
  symSize:byte  =0;
  tblSize:word  =0;
  askSize:word  =0;
  senatorCount:word=1;
{$I symbols.inc}
var table,ask:PTable;
    wei1               :array[1..MaxSymSize,1..MaxSymSize]of extended;
    wei2,sum1,res1,err1:array[1..MaxSymSize]of extended;
         sum2,res2     :extended;
    corr:array[1..MaxTblSize]of extended;
    senator:word;
    senate:array[1..MaxSenatorCount,1..MaxTblSize]of word;
{$I net.inc}
BEGIN
 if(paramcount<2)then
  begin
   writeln('СимволоРаспознаватель (C) 1997 Васильев Сергей');
   writeln('Запуск: SENATE.EXE <учебник> <вопросник> [<файл отчета> [<кол-во сенаторов>]]');
   halt;
  end;
 if(paramcount=2)then
  clrscr;
 if(paramcount>2)then
  begin
   writeln('СимволоРаспознаватель (C) 1997 Васильев Сергей');
   assign(output,paramstr(3));
   rewrite(output);
   if(paramcount=4)then
    begin
     val(paramstr(4),senatorCount,senator);
     if(senator<>0)then
      senatorCount:=1;
    end;
  end;

 new(table); new(ask);
 tblSize:=readTable(paramstr(1),table);
 askSize:=readTable(paramstr(2),ask);
 randomize;

 for senator:=1 to senatorCount do
  begin
   randomizeWeights;
   teachNet(MaxError);
   fireNet(senator);
   writeSenator(senator);
  end;
 writeResults;
 close(output);
 dispose(table); dispose(ask);
END.
