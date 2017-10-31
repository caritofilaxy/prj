use strict;
use Plack;
use Plack::Request;
use Plack::Builder;
use Handler;

my %targets = (
 	sl_site => [ 80, 110, 143, 21,  ],
	dkl => [ 443, 80, 25, 110 ],
	fail => [ 443, 80, 25, 110 ],
);



my $check = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $res = $req->new_response(200);
    my $params = $req->parameters();
    
    my $body = '<html><body>';
    $body .= Handler::srv_avail_table(%targets);
    $body .= "</html></body>";
	$body =~ s/dkl/deklarant.pro/g;
	$body =~ s/fail/deklarant.pro failover/g;
	$body =~ s/sl_site/softland.ru/g;
    
    $res->body($body);
    return $res->finalize();
};

my $main_app = builder {
        mount "/" => builder { $check };
   }
