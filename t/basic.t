use Mojo::Base -strict;

use Test::More tests => 9;

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

get '/by-address-rejected' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if (!$self->auth_by_address('127.0.0.2'));
};

get '/by-address-allowed' => sub {
  my $self = shift;
  $self->render(text=>'allowed') if ($self->auth_by_address('127.0.0.1'));
};

my $t = Test::Mojo->new;
my $a = b64_encode('username:password');

$t->get_ok('/', {Authorization => "Basic $a"})->status_is(200)->content_is('Hello Mojo!');

$t->get_ok('/by-address-rejected')->status_is(401)->content_is('rejected');
$t->get_ok('/by-address-allowed')->status_is(200)->content_is('allowed');
