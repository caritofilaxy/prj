procedure encrypt_char(var c:char; offset: integer);
var
	i: integer;
begin
	i:=ord(c)+offset;
	if i>126 then
		i:=i-126+32;

	c:=chr(i);
	
end;


procedure decrypt_char(var c:char; offset: integer);
var
	i: integer;
begin
	i:=ord(c)-offset;
	if i<32 then
		i:=i+126-32;

	c:=chr(i);
end;
	
var 
	ch: char;
	i: integer;

begin
	write('char: '); readln(ch); 
	write('offset: '); read(i);

	encrypt_char(ch, i);
	writeln(ch);
	decrypt_char(ch, i);
	writeln(ch);
end.
	
