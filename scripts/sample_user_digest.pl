package App::Songkick::UserDigest;
use Moose;

=pod

=head1 NAME

sample_user_digest.pl

=head SYNOPSIS

$ perl sample_user_digest.pl --user 'mr.jones' --email 'mr.jones@hotmail.com' --following anna.jones --following james.jones

=head DESCRIPTION

Generate and send a digest of user activity for the Songkick users being 'followed'.

This is a feature which SK used to provide, but for whatever reason was dropped.

This was very nice when you wanted a heads-up when your mates etc were going to gigs.

This example uses a Google (GMail) account to provide mail transport.

You would need to edit this to put your own credentials in, or actually just supply your own mail transport.

=head AUTHOR

Ashley Hindmarsh

=cut

with 'MooseX::Getopt';

use Email::Sender::Transport::SMTP;

has user => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    documentation => 'The user id of the Songkick user',
);

has email => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    documentation => 'The email address of the Songkick user',
);

has following => (
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
    documentation => 'The SK user ids of users who are being followed',
);

has sent_by => (
    is => 'ro',
    isa => 'Str',
    default => 'sksocial@example.com',
    documentation => 'The email address of the sender/agent',
);

has api_key => (
    is => 'ro',
    isa => 'Str',
    default => 'ky7OqxjeiZQD46LD',
    documentation => 'A valid Songkick API key',
);

has reftime => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    documentation => 'Reference time as Unix seconds-since-epoch',
);

has mail_transport => (
    is => 'ro',
    isa => 'Email::Sender::Transport',
    builder => '_build_mail_transport',
);

sub _build_mail_transport {
    Email::Sender::Transport::SMTP->new({
            host => 'smtp.gmail.com',
            port => 465,
            ssl => 1,
            timeout => 60,
            sasl_username => 'billgates@gmail.com',
            sasl_password => 'rosebud',
        })
}

# TODO: event hooks (e.g. sent email)

use Email::Sender::Simple;
use aliased 'App::Songkick::User' => 'SKUser';
use aliased 'App::Songkick::Social::UpdateUserByEmail';
use aliased 'Net::Songkick::CalendarAgent';
use DateTime;

sub run {
    my $self = shift;

    my $skuser = SKUser->new(
        id          => $self->user,
        email       => $self->email, 
        following   => $self->following
    );

    my $agent = CalendarAgent->new( api_key => $self->api_key );

    UpdateUserByEmail->new(
        skuser      => $skuser, 
        ref_time    => DateTime->from_epoch( epoch => $self->reftime ),
        sender      => 'sksocial@example.com',
        cal_agent   => $agent,
        mail_transport => $self->mail_transport
    )->run;

};

1;
package main;

my $app = App::Songkick::UserDigest->new_with_options();
$app->run;

