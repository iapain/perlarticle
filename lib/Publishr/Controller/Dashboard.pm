package Publishr::Controller::Dashboard;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Publishr::Controller::Dashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 dashboard

=cut

sub dashboard :Path :Args(0) {
    my ( $self, $c ) = @_;

    if ($c->controller eq $c->controller('Login')) {
         return 1;
    }
    
    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }
    
    $c->stash->{template} = 'dashboard.tt2';
}


=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
