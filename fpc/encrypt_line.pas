


procedure encrypt_char(var c:char; offset: integer);
begin
	c:=chr(ord(c)+offset);
	
end;
	

procedure encrypt_line(var d:string; offset: integer);
var
	i: integer;

begin
	for i:=1 to length(d) do
		encrypt_char(d[i], offset);
end;


{ main }

var
	s: string;
	offset: integer;

begin
	write('Enter line of text: '); readln(s);
	write('Enter offset: '); readln(offset);
	encrypt_line(s, offset);
	writeln(s);
end.
