var
	F: text;
	S: string;
	filename: string;


begin

	readln(filename);
	
	assign(F,filename); reset(F);

	while not eof(F) do begin
		readln(F, S);
		writeln(S);
	end;
	close(F);
end.
