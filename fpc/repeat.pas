program repeat_until;
var
	h: integer;

begin
	repeat
		write('?: '); readln(h);
		case h of
			0: writeln('f');
			1: writeln('t');
			else writeln('u');
		end;
	until ((h = 0) or (h = 1));
end.
