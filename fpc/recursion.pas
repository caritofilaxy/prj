program recursion;


procedure print_chars(ch: char; i: integer);

begin
	if i > 0 then begin
		write(ch);
		print_chars(ch, i-1);
	end
end;

begin
	print_chars('*',8);
	writeln;
end.


