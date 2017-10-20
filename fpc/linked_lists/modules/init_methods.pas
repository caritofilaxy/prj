type
	p_node = ^node;
	node = record
		data: integer;
		next: p_node;
	end;

{#############################################}
procedure init(var p: p_node);
begin
	p := nil;
end;
{#############################################}
function is_empty(var p: p_node): boolean;
begin
	is_empty := p = nil;
end;
{#############################################}
