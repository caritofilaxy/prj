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
var
	r: boolean;
begin
	if d = nil then
		r := true
	else
		r := false;
	
	is_empty := r;
end;


function shift(var d: itemptr): itemptr;
var 
	tmp: itemptr;

begin
	new(tmp);
	tmp^.data := d^.data;
	d := d^.next;
	tmp^.next := nil;

	shift := tmp;
end;
	

procedure unshift(var d: itemptr; k: integer);
var
	p: itemptr;

begin
	new(p);
	p^.data := k;
	p^.next := d;
	d := p
end;


procedure push(var first: itemptr; k: integer);
var
	p: itemptr;

begin

	if first = nil then begin
		new(p);
		first := p
	end else begin
		p2 := @d;
		while p2^.next <> nil do
			p2^.next := p2^.next^.next;

		p1 := p2^.next;

	end;
	p1^.data := k;
	p1^.next := nil;
end;

begin
	init(stack);
	while not seekeof do begin
		read(n);
		unshift(stack, n)
	end;


	while not is_empty(stack) do
		writeln(shift(stack)^.data);

end.
