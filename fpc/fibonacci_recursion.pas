program fib_cycle;

function fib(n: integer): integer;

begin
	if n = 0 then
		fib := 0
	else if n = 1 then
		fib := 1
	else 
		fib := fib(n-1) + fib(n-2);
end;

var 
	n,i,c: integer;
begin
	n := 9; 
	i := 1;
	for c := 1 to n do begin
		write(fib(i), ' ');
		i := i + 1;
	end;
	writeln;
end.
