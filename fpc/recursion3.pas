program rec3;

procedure fib(k: integer);
var
	n,m,p,q: integer;

begin
	if n < k then begin
		m := p + q;
		write(m, ' ');
		p := q;
		q := m;
		n := n + 1;
		fib(k);
	end;
end;


var
	f: integer;

begin
	f := 8;
	if f < 3 then begin
		writeln('1 1');
		exit;
	end else begin
		write('1 1 ');
		fib(f);
	end;
	writeln;
end.
