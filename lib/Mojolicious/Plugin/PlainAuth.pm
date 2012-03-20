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
    check_file => sub {
      my ($self,$type,$filename) = @_;
      $self->app->log->debug("auth by $type via $filename");
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

Mojolicious::Plugin::PlainAuth - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('PlainAuth');

  # Mojolicious::Lite
  plugin 'PlainAuth';

=head1 DESCRIPTION

L<Mojolicious::Plugin::PlainAuth> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::PlainAuth> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register;

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
