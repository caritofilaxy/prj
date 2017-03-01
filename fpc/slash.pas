program slash;
var
	line, space: integer;

begin
	for line:=1 to 24 do begin
		for space:=1 to line-1 do
			write(' ');
		writeln('*');
	end
end.
