program for_cycle;

var 
    i, L, U : integer;

begin
    L := 1; U := 10;
    for i := L to U do
        begin 
            writeln(i);
            if i = 5 then
                U := 20
        end;
end.
