use strict;
use Plack;
use Plack::Request;
use Plack::Builder;
use Handler;

my $check = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $res = $req->new_response(200);
    my $params = $req->parameters();
    my $body = "<html><body></head><body>target is "
    my $res = Handler::check("192.168.12.201","22");
    if ($res == 0) {
        $body .= "alive"
    } else {
        $body .= "<b>dead</b>"
    };
    $body .= "</body></html>";

    $res->body($body);
    return $res->finalize();
};

my $main_app = builder {
        mount "/" => builder { $check };
   }
