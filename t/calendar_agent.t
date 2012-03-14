use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);

use Dir::Self;
use Test::MockObject;
use Test::Mock::LWP;
$Mock_ua->set_isa('LWP::UserAgent');

use aliased 'Net::Songkick::CalendarAgent';
use aliased 'App::Songkick::User';

# use Test::MockObject;
use File::Slurp;

has test_user => (
    is => 'ro',
    default => 'Boudicca'
);

has mock_response => (
    is => 'ro',
    lazy_build => 1,
);

sub _build_mock_response {
    my $self = shift;
    read_file (sprintf "%s/users.%s.calendar.xml", __DIR__, $self->test_user);
}

# assumes test xml data is there somewhere...
before run_test => sub {
    my $test = shift;
    $Mock_resp->mock( content => sub { $test->mock_response } );
    $Mock_resp->set_always( code => 200 );
    $Mock_resp->set_always( is_success => 1 );
    $Mock_ua->mock( get => sub { $Mock_resp } );

    # $Mock_response->mock( content => sub { $test->mock_response } );
};

test "following events" => sub {
    my $test = shift;

    my $user = Test::MockObject->new;
    $user->set_isa( 'App::Songkick::FollowedUser' );
    $user->set_always( 'id', $test->test_user );

    my $agent = CalendarAgent->new(
        api_key => '0123456789abcdef',
    );

    my $calendar_entries = $agent->get_new_calendar_entries( $user );
    is @$calendar_entries, 12;
};

run_me;
done_testing();

