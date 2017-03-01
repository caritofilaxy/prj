program repeat_until;
var
	h: integer;

begin
	repeat
		write('Enter positive odd value: ');
		readln(h)
	until (h>0) and (h mod 2 = 1);
	{until (h>0) or (h mod 2 = 1);}
end.


