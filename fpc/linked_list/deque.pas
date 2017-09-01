type
	p = ^item;
	item = record
		data: integer;
		next: p;
	end;



var
	last: p;
	i: integer;

procedure print_deque(var d: p);
begin
	while d <> nil do begin
		write(d^.data);
		d := d^.next
	end;
end;

procedure init(var d: p);
begin
	d := nil
end;

function is_empty(var d: p): boolean
var
	v: boolean
begin
	if d = nil then
		v := true
	else
		v := false

	is_empty := v
end;


procedure push(var d: p; n: integer)
var
	tmp: p
begin
	new(tmp);
	tmp^.data := n;
	if d = nil then
		tmp^.data := nil
	else
		tmp^.data := d
	
	d := tmp
end;


begin
	init(last);
	ds
