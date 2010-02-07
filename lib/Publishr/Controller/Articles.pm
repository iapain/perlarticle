package Publishr::Controller::Articles;

use strict;
use warnings;
use DateTime;
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
    

    $c->stash->{articles} = [$c->model('DB::Article')->all];
    $c->stash->{template} = 'article_list.tt2';
}

=head2 create

Use HTML::FormFu to create a new book

=cut

sub create  :FormConfig :Local {
    my ($self, $c) = @_;

    # Get the form that the :FormConfig attribute saved in the stash
    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        # Create a new article
        my $title = $c->request->params->{title} || "";
        my $body = $c->request->params->{body} || "";
        my $tags = $c->request->params->{tags} || "";
        my $dt = DateTime->now();
        my @tag = split(/,/, $tags);

        
        my $article = $c->model('DB::Article')->new_result({
                        title  => $title,
                        body => $body,
                        insert_date => $dt,
                        update_date => $dt,
                        user_id => $c->user->id,
                        });
        $form->model->update($article);
        foreach (@tag){
            $c->log->warn($_);
            eval {
                $_ =~ s/^\s+//;
                $c->log->debug($_);
                my $tins = $c->model('DB::Tag')->create({
                            name  => lc($_),
                    });
                $c->model('DB::ArticleTag')->create({
                            article_id  => $article->id,
                            tag_id => $tins->id
                    });
                $c->log->debug("DONEEEEEEEEE");
            };
            if ( $@ =~ m/duplicate entry/i ) {
                my $tins = $c->model('DB::Tag')->find({name => lc($_)});
                $c->log->warn($tins->name);
                $c->model('DB::ArticleTag')->create({
                            article_id  => $article->id,
                            tag_id => $tins->id
                    });
            }
        }
        
        # Set a status message for the user
        $c->flash->{status_msg} = 'Article created';
        # Return to the books list
        $c->response->redirect($c->uri_for($self->action_for('list'))); 
        $c->detach;
    }
    # Set the template
    $c->stash->{template} = 'article_create.tt2';
}

=head2 base

Can place common logic to start chained dispatch here

=cut

sub base :Chained('/') :PathPart('articles') :CaptureArgs(0) {
    my ($self, $c) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash->{resultset} = $c->model('DB::Article');

    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');
}


=head2 object

Fetch an article

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->stash(object => $c->stash->{resultset}->find($id));
    die "Article $id not found!" if !$c->stash->{object};
    $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}


=head2 delete
    
Delete a article

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->delete;

    # Set a status message to be displayed at the top of the view
    $c->stash->{status_msg} = "Article deleted.";

    # Forward to the list action/method in this controller
    $c->response->redirect($c->uri_for($self->action_for('list')));

}

=head2 edit
    
edit an aritcle

=cut

sub edit :Chained('object') :PathPart('edit') :Args(0) 
            :FormConfig('articles/create.yml') {
    my ($self, $c) = @_;
    
    my $article = $c->stash->{object};

    # Make sure we were able to get an article
    unless ($article) {
        $c->flash->{error_msg} = "Invalid article -- Cannot edit";
        $c->response->redirect($c->uri_for($self->action_for('list')));
        $c->detach;
    }
    
    my $form = $c->stash->{form};
    my @tags;
    foreach ($article->tags()) {
        push(@tags, $_->name);
    }
    my $tagstr = join(', ', @tags);

    if ($form->submitted_and_valid) {
        # Create a new article
        my $title = $c->request->params->{title} || "";
        my $body = $c->request->params->{body} || "";
        my $tags = $c->request->params->{tags} || "";
        my $dt = DateTime->now();
        my @tag = split(/,/, $tags);
        
        $form->model->update($article);
        $c->model('DB::Article')->update({
                        update_date => $dt,
                        user_id => $c->user->id,});
        $c->model('DB::ArticleTag')->search({
                            article_id  => $article->id})->delete;
        foreach (@tag){
            eval {
                $_ =~ s/^\s+//;
                $c->log->debug($_);
                my $tins = $c->model('DB::Tag')->create({
                            name  => lc($_),
                    });
                $c->model('DB::ArticleTag')->create({
                            article_id  => $article->id,
                            tag_id => $tins->id
                    });
                $c->log->debug("DONEEEEEEEEE");
            };
            if ( $@ ) {
                my $tins = $c->model('DB::Tag')->find({name => lc($_)});
                $c->log->warn($tins->name);
                eval {
                    $c->model('DB::ArticleTag')->create({
                            article_id  => $article->id,
                            tag_id => $tins->id
                    });
                };
            }
        }
        
        

        $c->flash->{status_msg} = 'Article created';
        $c->response->redirect($c->uri_for($self->action_for('list'))); 
        $c->detach;
    } else {
        $form->model->default_values($article);
        $form->get_field(name => 'tags')->default( $tagstr );

    }
    # Set the template
    $c->stash->{template} = 'article_create.tt2';
}


=head1 AUTHOR

iapain,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
