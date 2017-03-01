{ usage: ./prog < file_with_dates }

program birthday;
var 
	year:integer;
begin
	write('Please type in your birth year: ');
	{ readln(year); }
	readln(year);
	while (year < 1900) or (year > 2013) do begin
		writeln(year, ' is not valid');
		write('Please try again: ');
		readln(year);
	end;
	writeln(year, ' is accepted. Thank you.');
end.

