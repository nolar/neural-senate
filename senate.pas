{$X+}
{$E-,N+}
{$M 2048,0,655360}
uses crt;
const
  {��ࠬ���� ����䥩�}
  MaxSymSize    =10        ;{���ᨬ��쭮 �।�ᬮ�७�� ࠧ��� ᨬ����}
  MaxTblSize    =50        ;{���ᨬ��쭮 �।�ᬮ�७�� ࠧ��� ⠡��� ᨬ�����}
  MaxSenatorCount=20       ;{���ᨬ��쭮� ������⢮ ᥭ��஢}
  OnChars       =['1']     ;{ᨬ���� ⠡����, ��������騥 ����祭��� ���}
  OffChars      =['-']     ;{ᨬ���� ⠡����, ��������騥 �몫�祭��� ���}
  DividerSize   =40        ;{ࠧ��� ࠧ�����饩 �����}
  {��ࠬ���� ��}
  MaxError      =0.8       ;{���ᨬ��쭠� ����譮���}
  hConst        =0.2       ;{~(0..1)  �����-㬭��, �� �����; �����-�㯥�, �� ����३}
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
   writeln('���������ᯮ�����⥫� (C) 1997 ��ᨫ쥢 ��ࣥ�');
   writeln('�����: SENATE.EXE <�祡���> <����᭨�> [<䠩� ����> [<���-�� ᥭ��஢>]]');
   halt;
  end;
 if(paramcount=2)then
  clrscr;
 if(paramcount>2)then
  begin
   writeln('���������ᯮ�����⥫� (C) 1997 ��ᨫ쥢 ��ࣥ�');
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
