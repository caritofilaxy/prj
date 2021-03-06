const offset = 2;

{ char2ord + offset, back2char }
function encrypt_char(c: char): char;
var
        i: integer;
begin
	encrypt_char:=c;
	if ((ord(c)>31) and (ord(c)<127)) then begin
	        i:=ord(c)+offset;
        	if i>126 then i:=i-126+31;
	        encrypt_char:=char(i);
	end;
end;

{ same as above foreach char in string }
procedure encrypt_line(var d:string);
var
	i: integer;
begin
	for i:=1 to length(d) do d[i]:=encrypt_char(d[i]);
end;


{ ---=== encryption part ===--- }

{ ---=== decryption part ===--- }
function decrypt_char(c: char): char;
var
        i: integer;
begin
	decrypt_char:=c;
	if ((ord(c)>31) and (ord(c)<127)) then begin
	        i:=ord(c)-offset;
	        if i<32 then  i:=i+126-31;
	        decrypt_char:=char(i);
	end;
end;

procedure decrypt_line(var d:string);
var
	i: integer;
begin
	for i:=1 to length(d) do d[i]:=decrypt_char(d[i]);
end;


{ ---=== decryption part ===--- }


{ ---=== main ===--- }

var
	s: string;

begin
	while not eof(Input) do begin
		readln(Input, s);
		decrypt_line(s);
		writeln(s);
	end;
end.
end.
