program get_out;
var 
	x: integer;
begin
	readln(x);
	if x > 0 then begin
		writeln('x > 0');
		exit;
	end;
	writeln('x<0');
end.
