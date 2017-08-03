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
function decrypt_char(c:char);
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

procedure decrypt_line(var d:string; offset: integer);
var
	i: integer;
begin
	for i:=1 to length(d) do d[i] decrypt_char(d[i]);
end;


{ ---=== decryption part ===--- }

{ ---=== file encryption ===--- }
procedure encrypt_file(const aFile: string; aOper: boolean);
var
	FileIn: text;
	FileOut: text;
	S, I, O: string;

begin
	write('File to operate: '); 


{ ---=== main ===--- }

var
	n: integer;

begin
	writeln('choose operaion: ');
	writeln('1 - encrypt');
	writeln('2 - decrypt');
	write('enter number from above: '); readln(n);

	case n of:
		1) 
