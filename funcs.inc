function func(x:extended):extended;
begin
 func:=x/(hconst+abs(x));
end;

function dfunc(x:extended):extended;
begin
 dfunc:=hconst/sqr(hconst+abs(x));
end;
