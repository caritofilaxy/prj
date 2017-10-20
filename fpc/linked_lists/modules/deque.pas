{$I init_methods.pas}
{$I action_methods.pas}

var
	first: p_node;
	i: integer;

begin
	init(first);
		
	for i := 10 to 20 do begin
		push_end(first, i);
	end;
		 
	while pop_end(first, i) do begin
		writeln(i,' :');
	end;
end.
	
