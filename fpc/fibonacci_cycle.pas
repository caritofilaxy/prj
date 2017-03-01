program fib_cycle;

var 
	f,z,p,q,n: integer;

begin
	repeat 
		write('how many elements? ');
		readln(f);
	until (f > 0);

	p := 1;
	q := 1;

	if f = 1 then begin
		writeln(p);
		exit;
	end;

	if f = 2 then begin
		writeln(p, ' ', q);
		exit;
	end;

	if f > 2 then begin
		write(p, ' ', q, ' ');
		z := 2;
		while (z < f) do begin
			n := p + q;
			write(n, ' ');
			p := q;
			q := n;
			z := z + 1;
		end;
	end;
	writeln;
end.

		
