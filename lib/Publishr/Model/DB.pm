package Publishr::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Publishr::Schema',
    connect_info => [
        'dbi:mysql:publishr',
        'root',
        '',
        { AutoCommit => 1},
        
    ],
);

=head1 NAME

Publishr::Model::DB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Publishr>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Publishr::Schema>

=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
