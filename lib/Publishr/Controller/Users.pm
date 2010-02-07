package Publishr::Controller::Users;

use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

Publishr::Controller::Articles - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

Fetch all articles from db

=cut

sub list :Local {
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
    

    $c->stash->{users} = [$c->model('DB::User')->all];
    $c->stash->{template} = 'user_list.tt2';
}

=head2 create

Use HTML::FormFu to create a new user

=cut

sub create  :FormConfig :Local {
    my ($self, $c) = @_;

    # Get the form that the :FormConfig attribute saved in the stash
    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        # Create a new article
        my $username = $c->request->params->{username} || "";
        my $password = $c->request->params->{password} || "";
        my $email_address = $c->request->params->{email_address} || "";
        my $first_name = $c->request->params->{first_name} || "";
        my $last_name = $c->request->params->{last_name} || "";
        eval {
            my $user = $c->model('DB::User')->new_result({
                            username  => $username,
                            password => $password,
                            first_name => $first_name,
                            last_name => $last_name,
                            email_address => $email_address,
                            is_active => 1,
                            is_superuser => 1,
                            });
            $form->model->update($user);
            # Set a status message for the user
            $c->flash->{status_msg} = 'User created';
            # Return to the User list
            $c->response->redirect($c->uri_for($self->action_for('list'))); 
            $c->detach;
        };
        if ( $@ =~ m/duplicate entry/i ) {
            $c->stash->{error_msg} = 'Username already exist';
            $form->get_field('username')
                 ->get_constraint({ type => 'Callback' })
                 ->force_errors(1);
            $form->auto_constraint_class( 'constraint_%t' );
            $form->process;
            
            # then redisplay the form as normal
        }
        
        
    }
    # Set the template
    $c->stash->{template} = 'user_create.tt2';
}

=head2 base

Can place common logic to start chained dispatch here

=cut

sub base :Chained('/') :PathPart('users') :CaptureArgs(0) {
    my ($self, $c) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash->{resultset} = $c->model('DB::User');

    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');
}


=head2 object

Fetch an article

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->stash(object => $c->stash->{resultset}->find($id));
    die "User $id not found!" if !$c->stash->{object};
    $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}


=head2 delete
    
Delete a article

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->delete;

    # Set a status message to be displayed at the top of the view
    $c->stash->{status_msg} = "User deleted.";

    # Forward to the list action/method in this controller
    $c->response->redirect($c->uri_for($self->action_for('list')));

}

=head2 edit
    
edit an aritcle

=cut

sub edit :Chained('object') :PathPart('edit') :Args(0) 
            :FormConfig('articles/create.yml') {
    my ($self, $c) = @_;
    
    my $user = $c->stash->{object};

    # Make sure we were able to get an article
    unless ($user) {
        $c->flash->{error_msg} = "Invalid user -- Cannot edit";
        $c->response->redirect($c->uri_for($self->action_for('list')));
        $c->detach;
    }
    
    my $form = $c->stash->{form};


    if ($form->submitted_and_valid) {
        # Create a new article
        $form->model->update($user);

        $c->flash->{status_msg} = 'Article created';
        $c->response->redirect($c->uri_for($self->action_for('list'))); 
        $c->detach;
    } else {
        $form->model->default_values($user);
    }
    # Set the template
    $c->stash->{template} = 'user_create.tt2';
}


=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;