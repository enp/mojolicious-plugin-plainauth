package Mojolicious::Plugin::PlainAuth;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;
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
