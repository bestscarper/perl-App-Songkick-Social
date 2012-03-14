package App::Songkick::Types;

use MooseX::Types
-declare => [qw(
    FollowedUser
    ArrayRefOfFollowedUsers
)];

use Moose::Autobox;

use MooseX::Types::Moose qw/ArrayRef Str/;

class_type 'App::Songkick::FollowedUser';

subtype FollowedUser,
    as 'App::Songkick::FollowedUser';

subtype ArrayRefOfFollowedUsers,
    as ArrayRef[FollowedUser];

coerce ArrayRefOfFollowedUsers,
    => from ArrayRef[Str]
        => via { 
            require App::Songkick::FollowedUser; 
            $_->map( sub { App::Songkick::FollowedUser->new( id => $_ ) } )
        };

1;
