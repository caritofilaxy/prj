
type
	ptr = ^item;
	item = record
		data: integer;
		next: ptr;
	end;

var 
	first, last: ptr;
	n: integer;

begin;
	first := nil;
	last := nil;
	while not seekeof do begin
		read(n);
		if first = nil then begin
			new(first);
			last := first
		end else begin
			new(last^.next);
			last := last^.next
		end;
		last^.data := n;
		last^.next := nil;
	end;	

	while first <> nil do begin
		writeln(first^.data);
		first := first^.next;
	end;
end.
