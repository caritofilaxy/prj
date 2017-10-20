type
	itemptr = ^item;
	item = record
		data: integer;
		next: itemptr;
	end;

var
	first,p: itemptr;
	n: integer;
	

begin;
	first := nil;
	while not seekeof do begin
		read(n);
		new(p);
		p^.data := n;
		p^.next := first;
		first := p
	end;
	p := first;
	while p <> nil do begin
		write(p^.data, ' ');
		p := p^.next
	end;
	writeln;
end.
