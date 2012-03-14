package App::Songkick::User;
use Moose;
use MooseX::Types::Moose qw(Str ArrayRef);
use MooseX::Types::Email qw/EmailAddress/;
use App::Songkick::Types qw/ FollowedUser ArrayRefOfFollowedUsers /;

has id => (
    is => 'ro',
    required => 1
);

has email => (
    is => 'ro',
    isa => EmailAddress,
    required => 1,
);

has following => (
    is => 'ro',
    isa  => ArrayRefOfFollowedUsers,
    coerce => 1,
    required => 1
);

1
