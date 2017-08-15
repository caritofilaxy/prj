
var
	F: text;

	c: char;
	s: string;

begin
	s:='';
	assign(F,'db.txt'); reset(F);
	repeat
		read(F,c);
		if (((ord(c) >= 65) and (ord(c) <= 90)) or ((ord(c) >= 97) and (ord(c) <= 122))) then 
	s:=s+c;
	until (eoln(F));

	writeln(s);
end.	
