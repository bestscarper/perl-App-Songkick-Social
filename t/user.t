use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);

use App::Songkick::Types qw/ FollowedUser ArrayRefOfFollowedUsers /;

# use Test::MockObject;

# for 'Boudicca' test that a single entry becomes an email response

test "test user coercion" => sub {
    my $users = [ qw/ user1 user2 / ];

    my $followers = to_ArrayRefOfFollowedUsers( $users );

    is @$followers, 2, "array maintained";
    is $followers->[0]->id, 'user1';
};

run_me;
done_testing();

