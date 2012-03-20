package Mojolicious::Plugin::PlainAuth;

use Mojo::Base 'Mojolicious::Plugin';

use NetAddr::IP;

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;

  $app->helper(
    check_address => sub {
      my ($self,$address) = @_;
      return 1 if
        NetAddr::IP->new($self->tx->{remote_address})->within(NetAddr::IP->new($address));
    }
  );

  $app->helper(
    check_account => sub {
      my ($self,$userinfo) = @_;
      my ($login,$password) = split(/\s+/, $userinfo);
      return 1 if
        $self->req->url->base->userinfo eq "$login:$password";
    }
  );

  $app->helper(
    check_file => sub {
      my ($self,$type,$filename) = @_;
      return 0 if !($type eq 'account' || $type eq 'address');
      $type = "check_$type";
      open(FILE, "<$filename") or return 0;
      my @lines = <FILE>;
      close(FILE);
      foreach (@lines) {
        chomp;              # no newline
        s/#.*//;            # no comments
        s/^\s+//;           # no leading white
        s/\s+$//;           # no trailing white
        next unless length; # anything left?
        return 1 if $self->$type($_);
      }
      return 0;
    }
  );
}

1;

__END__

=head1 NAME

Mojolicious::Plugin::PlainAuth - auth helper from plain text files

=head1 DESCRIPTION

L<Mojolicious::Plugin::PlainAuth> is authentication helper from plain text files with hosts/networks or logins/passwords.

=head1 USAGE

use Mojolicious::Lite;

plugin 'plain_auth';

get '/' => sub {
  my $self = shift;
  if ($self->check_address('10.10.10.0/24')) {
    if ($self->check_account('username password')) {
      $self->render(text=>'allowed');
    } else {
      $self->res->headers->www_authenticate("Basic realm=Authentication");
      $self->render(text=>'rejected due to wrong account', status=>401);
    }
  } else {
    $self->render(text=>'rejected due to wrong network', status=>401);
  }

};

get '/file' => sub {
  my $self = shift;
  if ($self->check_file('address','address.txt')) {
    if ($self->check_file('account','account.txt')) {
      $self->render(text=>'allowed');
    } else {
      $self->res->headers->www_authenticate("Basic realm=Authentication");
      $self->render(text=>'rejected due to wrong account', status=>401);
    }
  } else {
    $self->render(text=>'rejected due to wrong network', status=>401);
  }

};

app->start;

=head1 METHODS

=head2 C<check_address($address)>;

Returns 1 if remote client address is equal to $address or within it defined as network.

=head2 C<check_account($account)>;

Returns 1 if remote client login and password delimited by space is equal to $account.

=head2 C<check_file($type,$file)>;

Do the same as above but read allowed hosts/networks or login/passwords from $file.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=head1 DEVELOPMENT

L<http://github.com/enp/mojolicious-plugin-plainauth>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Eugene Prokopiev

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
