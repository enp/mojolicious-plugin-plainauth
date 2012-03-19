use Mojo::Base -strict;

use Test::More tests => 3;

use Mojo::Util qw/b64_encode/;

use Mojolicious::Lite;
use Test::Mojo;

plugin 'PlainAuth';

get '/' => sub {
  my $self = shift;
  diag('');
  diag('Userinfo : '.$self->req->url->base->userinfo);
  diag('Address  : '.$self->tx->{remote_address});
  $self->render_text('Hello Mojo!');
};

my $t = Test::Mojo->new;
my $a = b64_encode('username:password');
$t->get_ok('/', {Authorization => "Basic $a"})->status_is(200)->content_is('Hello Mojo!');
