package App::Songkick::Social::UpdateUserByEmail;
use Moose;
use MooseX::Types::Moose qw(Any ArrayRef Str);
use Moose::Autobox;

use aliased 'App::Songkick::User' => 'SKUser';
# use App::Songkick::FollowedUser;
use App::Songkick::Types qw/ FollowedUser ArrayRefOfFollowedUsers /;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use DateTime;
use MooseX::Types::DateTime;

=pod

TODO: Real POD....

Given a user,


=cut

has skuser => (
    is => 'ro',
    isa => 'App::Songkick::User',
    required => 1,
    handles => [qw( email following )]
); 

has ref_time => (
    is => 'ro',
    isa => 'DateTime',
    default => sub { DateTime->now },
);

has sender => (
    is => 'ro',
    required => 1
);

has cal_agent => (
    is => 'ro',
    isa => 'Net::Songkick::CalendarAgent',
    required => 1
);

sub get_new_events {
    my $self = shift;

    $self->following->map( sub { $_->get_new_events($self->cal_agent, $self->ref_time)->flatten } )
}

sub create_body {
    my $self = shift;
    join '\n', @{ $self->get_new_events }
}

sub run {
    my $self = shift;

    my $email = Email::Simple->create(
        header => [
            To      => $self->email,
            From    => $self->sender,
            Subject => "Your Songkick friends are going to more concerts!",
        ],
        body => $self->create_body
    );

    sendmail($email);
}   

1
