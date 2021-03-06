package DDGC::Web::Controller::Userpage;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub user :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $username ) = @_;
    $c->stash->{user} = $c->d->find_user($username);
    unless ($c->stash->{user} && $c->stash->{user}->public) {
    	return $c->go('/default');
    }
    $c->add_bc('User page of '.$username, '');
    $c->stash->{title} = $username." User Page";
}

sub home :Chained('user') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{last_comments} = $c->stash->{user}->last_comments(1,3);
}

__PACKAGE__->meta->make_immutable;

1;
