{ prg creates linked list and adds new items to beginnimg }

type 
	rec_ptr = ^rec;
	rec = record
		data: integer;
		next: rec_ptr;
	end;

var
	last, p: rec_ptr;
	n: integer;

begin
	last := nil;
	while not seekeof do begin
		read(n);
		new(p);
		p^.data := n;
		p^.next := last;
		last := p
	end;

	p := last;
	while p <> nil do begin
		writeln(p^.data);
		p := p^.next
	end;
end.
