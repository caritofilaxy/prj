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
    
    my $body = "<html><body>";
    $body .= Handler::check("websrv","192.168.12.141","80");
    $body .= Handler::check("bb","192.168.12.201","25");
    $body .= Handler::check("mx","192.168.12.129","3128");
    $body .= Handler::check("mx","192.168.12.130","25");
    $body .= "</html></body>";
    
    $res->body($body);
    return $res->finalize();
};

my $main_app = builder {
        mount "/" => builder { $check };
   }
