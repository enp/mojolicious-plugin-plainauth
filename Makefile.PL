use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::PlainAuth',
  VERSION_FROM => 'lib/Mojolicious/Plugin/PlainAuth.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '2.50'},
  test         => {TESTS => 't/*.t'}
);
