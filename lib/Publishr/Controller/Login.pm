package Publishr::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Publishr::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    # If a user doesn't exist, force login
    if ($c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for(
                            $c->controller('Dashboard')->action_for('dashboard')));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }
    
    if ($c->request->method eq "POST") {
        # Get the username and password from form
        my $username = $c->request->params->{username} || "";
        my $password = $c->request->params->{password} || "";
    
        # If the username and password values were found in form
        if (defined($username) && defined($password)) {
            # Attempt to log the user in
            if ($c->authenticate({ username => $username,
                                   password => $password  } )) {
                # If successful, then let them use the application
                $c->response->redirect($c->uri_for(
                    $c->controller('Dashboard')->action_for('dashboard')));
                return;
            } else {
                # Set an error message;
                $c->stash->{error_msg} = "Invlaid username or password.";
            }
        }
    }
    # If either of above don't work out, send to the login page
    $c->stash->{template} = 'login.tt2';

}


=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
