use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);

use Dir::Self;

use aliased 'Net::Songkick::Event';

use File::Slurp;
use XML::LibXML;

has xml => (
    is => 'ro',
    lazy_build => 1,
);

sub _build_xml {
    my $self = shift;
    read_file (sprintf "%s/users.%s.calendar.xml", __DIR__, 'Boudicca');
}

# assumes test xml data is there somewhere...
before run_test => sub {
    my $test = shift;

};

test "test event xml" => sub {
    my $test = shift;

    my $xp = XML::LibXML->new->parse_string($test->xml);

    foreach ($xp->findnodes('//event')) {
        lives_ok { Event->new_from_xml($_) } "event expanded";
    }
};

run_me;
done_testing();

