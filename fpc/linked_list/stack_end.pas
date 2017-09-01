type
	itemptr = ^item;
	item = record
		data: integer;
		next: itemptr;
	end;

var
	stack: itemptr;
	n: integer;

procedure init(var d: itemptr);
begin
	d := nil
end;

function is_empty(var d: itemptr): boolean;
begin
	is_empty := d = nil;
end;


procedure push(var first: itemptr; k: integer);
var
	p: itemptr;

begin
	if first = nil then begin
		new(p);
		first := p
	end else begin
		p := first;
		while p^.next <> nil do
			p := p^.next;
 
		new(p^.next);
		p := p^.next;
	end;
	p^.data := k;
	p^.next := nil;
end;

function pop(var first: itemptr): itemptr;
var
	p: itemptr;

begin
	if first <> nil then begin
		new(p);
		p := first;
		while p^.next <> nil do
			p := p^.next;
		pop := p
	end else begin
		pop := nil
	end;
end;

begin
	init(stack);
	while not seekeof do begin
		read(n);
		push(stack, n)
	end;

{	while stack <> nil do begin
		writeln(stack^.data);
		stack := stack^.next
	end;}

	while not is_empty(stack) do
		writeln((pop(stack)^.data);

end.
