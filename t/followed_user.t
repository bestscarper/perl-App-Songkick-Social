use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);

use aliased 'App::Songkick::FollowedUser';

use Test::MockObject;

# assumes test xml data is there somewhere...

test "following events" => sub {
    my $followed = FollowedUser->new( id => 'Boudicca' );

    my $ref_time = DateTime->new( year => 2012, month => 2, day => 1 );

    my $one_day = DateTime::Duration->new( days => 1 );

    my $mock_entry = Test::MockObject->new;
    $mock_entry->set_series( created_at => $ref_time+$one_day, $ref_time-$one_day );
    $mock_entry->set_always( reason => 'im_going' );
    $mock_entry->set_series( as_string => 'Left With Pictures on 2012-02-27 at The Lexington, London', 'Foo' );

    my $mock_agent = Test::MockObject->new;
    $mock_agent->set_always( get_new_calendar_entries => [ $mock_entry, $mock_entry ] );
    my $new_events = $followed->get_new_events($mock_agent, $ref_time);
    is @$new_events, 1;

    # ohhhhh  - let's just do a rough check
    like $new_events->[0], qr/Boudicca is going to see Left With Pictures on 2012-02-27 at The Lexington, London/;
};

run_me;
done_testing();

