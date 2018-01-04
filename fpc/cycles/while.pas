program whilee;

var
    i, L, U : integer;

begin
    L := 1; U := 10;
    i:=L;
    while i <= U do begin
        writeln(i);
        i := i + 1;
        if i = 5 then
            U := 20
    end;
end.
