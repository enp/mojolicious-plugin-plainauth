use Mojo::Base -strict;

use Test::More tests => 27;

use Mojo::Util qw/b64_encode/;

use Mojolicious::Lite;
use Test::Mojo;

plugin 'PlainAuth';

get '/by-file-account-allowed' => sub {
  my $self = shift;
  $self->render(text=>'allowed') if $self->check_file('account','t/account-allowed.txt');
};

get '/by-file-account-rejected' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if !$self->check_file('account','t/account-rejected.txt');
};

get '/by-account-allowed' => sub {
  my $self = shift;
  $self->render(text=>'allowed') if $self->check_account('username password');
};

get '/by-account-rejected' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if !$self->check_account('user pass');
};

get '/by-address-allowed' => sub {
  my $self = shift;
  $self->render(text=>'allowed') if $self->check_address('127.0.0.1');
};

get '/by-address-rejected' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if !$self->check_address('127.0.0.2');
};

get '/by-file-address-allowed' => sub {
  my $self = shift;
  $self->render(text=>'allowed') if $self->check_file('address','t/address-allowed.txt');
};

get '/by-file-address-rejected' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if !$self->check_file('address','t/address-rejected.txt');
};

get '/by-file-fake' => sub {
  my $self = shift;
  $self->render(text=>'rejected', status=>401) if !$self->check_file('fake');
};

my $t = Test::Mojo->new;
my $a = b64_encode('username:password');

$t->get_ok('/by-file-account-allowed', {Authorization => "Basic $a"})->status_is(200)->content_is('allowed');
$t->get_ok('/by-file-account-rejected', {Authorization => "Basic $a"})->status_is(401)->content_is('rejected');
$t->get_ok('/by-account-allowed', {Authorization => "Basic $a"})->status_is(200)->content_is('allowed');
$t->get_ok('/by-account-rejected', {Authorization => "Basic $a"})->status_is(401)->content_is('rejected');
$t->get_ok('/by-address-allowed')->status_is(200)->content_is('allowed');
$t->get_ok('/by-address-rejected')->status_is(401)->content_is('rejected');
$t->get_ok('/by-file-address-allowed')->status_is(200)->content_is('allowed');
$t->get_ok('/by-file-address-rejected')->status_is(401)->content_is('rejected');
$t->get_ok('/by-file-fake')->status_is(401)->content_is('rejected');
