use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);
use Dir::Self;

# call me paranoid, but apart from a Net::Songkick::VERSION, I'd like to know this is working as it stands...
use Net::Songkick;
use Net::Songkick::Event;
use XML::LibXML;

has user_calendar_file => (
    is => 'ro',
    default => __DIR__ . '/users.Boudicca.calendar.xml'
);

test "songkick events inflate from xml" => sub {
    my $test = shift;

    my $xp = XML::LibXML->load_xml(location => $test->user_calendar_file);
    my ($firstnode) =$xp->findnodes('//event');
    my $event = Net::Songkick::Event->new_from_xml($firstnode);
    isa_ok($event, 'Net::Songkick::Event');

    my $location = $event->location;
    isa_ok($location, 'Net::Songkick::Location');
};

run_me;
done_testing();
