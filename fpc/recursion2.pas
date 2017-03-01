program print_digits_of_number;

procedure print_digits(n: integer);
begin
	if (n > 0) then begin
		print_digits(n div 10);
		write(n mod 10, ' ');
	end
end;

begin 
	print_digits(2735);
	writeln;
end.
