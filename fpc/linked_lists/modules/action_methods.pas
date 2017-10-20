procedure push(var p: p_node; n: integer);

var
	pp: p_node;

begin
	new(pp);
	pp^.data := n;
	pp^.next := p;
	p := pp;
end;
{#############################################}
function pop(var p: p_node): p_node;

var
	pp: p_node;
	n: integer;
begin
	if not is_empty(p) then begin
		n := p^.data;
		new(pp);
		pp := p;
		p := p^.next;
		dispose(pp);
		pop := n;
	end else begin
		writeln('empty');
		pop := 0
	end;
end;
{#############################################}
procedure push_end(var p: p_node; n: integer);
var
	pp: p_node;

begin
	new(pp);
	if is_empty(p) then begin
		p := pp;
	end else begin
		pp := p;
		while pp^.next <> nil do
			pp := pp^.next;
		
		new(pp^.next);
		pp := pp^.next;
	end;
pp^.data := n;
pp^.next := nil;
end;
{#############################################}
function pop_end(var p: p_node): integer ;
var
	pp: p_node;
	res: integer;

begin
		new(pp);
		pp := p;
		while pp^.next <> nil do
			pp := pp^.next;
		
		pop_end := pp^.next^.data;
		pp^.next := nil;
end;
