{ $I- }

const filename = 'num.txt';

var
	F: text;


begin
	assign(F, filename); reset(F);
	if ioresult=0
		then writeln('got '+filename)
		else writeln(filename+' not found');
end.
{ $I+ }
