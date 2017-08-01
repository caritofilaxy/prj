{ ---=== encryption part ===--- }
procedure encrypt_char(var c:char; offset: integer);
var
        i: integer;
begin
        i:=ord(c)+offset;
        if i>126 then
                i:=i-126+32;

        c:=chr(i);

end;

procedure encrypt_line(var d:string; offset: integer);
var
	i: integer;
begin
	for i:=1 to length(d) do
		encrypt_char(d[i], offset);
end;


{ ---=== encryption part ===--- }

{ ---=== decryption part ===--- }
procedure decrypt_char(var c:char; offset: integer);
var
        i: integer;
begin
        i:=ord(c)-offset;
        if i<32 then
                i:=i+126-32;

        c:=chr(i);
end;

procedure decrypt_line(var d:string; offset: integer);
var
	i: integer;
begin
	for i:=1 to length(d) do
		decrypt_char(d[i], offset);
end;


{ ---=== decryption part ===--- }


{ ---=== main ===--- }

var
	F,T: text;
	S: string;

begin

	assign(F,'dummy.txt'); reset(F);
	assign(T,'dummy.txt.encrypted'); rewrite(T);

	while not eof(F) do begin
		readln(F, S);
		encrypt_line(S, 1);
		writeln(T, S);
	end;
end.
