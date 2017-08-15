
var
	F: text;
	S: integer;

begin
	assign(F, 'eolndb.txt'); reset(F);
	while not eof(F) do begin
		read(F, S);
		writeln(S,'--',eoln(F));
	end;
end.
