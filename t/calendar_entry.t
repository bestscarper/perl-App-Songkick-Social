use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);
use Test::MockObject;

use aliased 'Net::Songkick::CalendarEntry';
use aliased 'Net::Songkick::Venue';
use aliased 'Net::Songkick::Location';
use DateTime::Format::ISO8601;

# assumes test xml data is there somewhere...

test "calendar entry rendering" => sub {

    my $artist = Test::MockObject->new;
    $artist->set_isa('Net::Songkick::Artist');
    $artist->mock( 'displayName', sub { 'Left With Pictures' } );

    my $event = Test::MockObject->new;
    $event->set_isa('Net::Songkick::Event');
    $event->mock( 'displayName', sub { 'Eliza Carthy with Emily Barker, at The Lexington' } );
    $event->set_always( 'location' => Location->new( city => 'London' ) );
    $event->set_always( 'venue' => Venue->new( displayName => 'The Lexington' ) );
    $event->set_always( 'start' => DateTime::Format::ISO8601->parse_datetime('2012-02-27') );

    my $followed = CalendarEntry->new( 
        tracked_artist => $artist, 
        event => $event,
        reason => 'im_going'
    );

    is $followed->as_string, q/Left With Pictures on 2012-02-27 at The Lexington, London/;
};

test "No tracked artist" => sub {

    my $event = Test::MockObject->new;
    $event->set_isa('Net::Songkick::Event');
    $event->mock( 'displayName', sub { 'Eliza Carthy with Emily Barker, at The Lexington' } );
    $event->set_always( 'location' => 'London' );
    $event->set_always( 'venue' => 'The Lexington' );
    $event->set_always( 'start' => '2012-02-27' );

    lives_ok {
        CalendarEntry->new( 
            event => $event,
            reason => 'im_going'
        )
    };

};

test "parsing an xml feed" => sub {
    ok 1;
};

run_me;
done_testing();

