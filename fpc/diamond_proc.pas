program diamond_proc;

procedure print_chars(ch: char; count: integer);
var 
	i: integer;
begin
	for i:=1 to count do
		write(ch);
end;

procedure print_line(k,n: integer);
begin
	print_chars(' ', n+1-k);
	write('*');
	if (k>1) then begin
		print_chars('+', 2*k-3);
		write('*');
	end;
	writeln
end;

function size: integer;
var
	h: integer;
begin
	repeat
		write('Enter height: ');
		readln(h)
	until (h>0) and (h mod 2 = 1);

	size:=h div 2;
end;

var
	h,n,k: integer;

begin
	{ hieght input }
	n:=size;

	{ upper }
	for k:=1 to n+1 do
		print_line(k,n);
	{ lower }
	for k:=n downto 1 do
		print_line(k,n);
	
end.


