package Publishr::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(TEMPLATE_EXTENSION => '.tt2',
                    INCLUDE_PATH => [
                        Publishr->path_to( 'root', 'src' ),
                        ],
);



=head1 NAME

Publishr::View::TT - TT View for Publishr

=head1 DESCRIPTION

TT View for Publishr. 

=head1 SEE ALSO

L<Publishr>

=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
