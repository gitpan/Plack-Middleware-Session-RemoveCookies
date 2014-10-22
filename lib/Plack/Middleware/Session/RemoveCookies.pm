package Plack::Middleware::Session::RemoveCookies;
{
  $Plack::Middleware::Session::RemoveCookies::VERSION = '0.01';
}
# ABSTRACT: remove cookies from the requests

use strict;
use warnings;
use Plack::Request;
use HTTP::Headers::Util qw(join_header_words);

use parent 'Plack::Middleware';

__PACKAGE__->mk_accessors('key');

sub call {
  my ( $self, $env ) = @_;

  if ( $env->{'HTTP_COOKIE'} ) {
    my $cookie = Plack::Request->new($env)->cookies;
    foreach my $c_key ( keys %$cookie ) {
      delete $cookie->{$c_key} if $c_key =~ $self->key;
    }
    $env->{'plack.cookie.string'} = $env->{'HTTP_COOKIE'}
      = join_header_words(%$cookie);
  }

  return $self->app->($env);
}

1;



=pod

=head1 NAME

Plack::Middleware::Session::RemoveCookies - remove cookies from the requests

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    enable 'Session::RemoveCookies', key => qr{plack_session}i;

    or

    enable_if {
        $_[0]->{'HTTP_X_DO-NOT-TRACK'} || $_[0]->{'HTTP_DNT'}
    } 'Session::RemoveCookies', key => qr{plack_session}i;

=head1 ACKNOWLEDGMENT

Initial development sponsored by 123people Internetservices GmbH - L<http://www.123people.com/>

=head1 SEE ALSO

L<Plack::Middleware>,  L<Plack::Builder>

=head1 AUTHOR

Wallace Reis <wreis@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Wallace Reis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

