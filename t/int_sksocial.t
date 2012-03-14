use Test::Routine;
use Test::Routine::Util;
use Test::Most qw(!blessed);
use Dir::Self;
use Moose::Autobox;

use Test::Mock::LWP;
$Mock_ua->set_isa('LWP::UserAgent');
use File::Slurp;
use aliased 'DateTime::Format::ISO8601';

# we assume Email::Simple is the emailer; to be zen we'd mock and implement this via the email abstraction
use Email::Sender::Simple;
use aliased 'App::Songkick::User' => 'SKUser';
use aliased 'App::Songkick::Social::UpdateUserByEmail';
use aliased 'Net::Songkick::CalendarAgent';

BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }
# use Test::MockObject;

# for 'Boudicca' test that a single entry becomes an email response
sub mock_response {
    my $user_id = shift;

    # http://api.songkick.com/api/3.0/users/Boudicca/calendar.xml?apikey=foo
    
    my $xml = read_file (sprintf "%s/users.%s.calendar.xml", __DIR__, $user_id);
    return $xml;
}

before run_test => sub {
    my $test = shift;
    $Mock_resp->set_series( content => 
        mock_response('Boudicca'),
        mock_response('FintanStack')
    );
    $Mock_resp->set_always( code => 200 );
    $Mock_resp->set_always( is_success => 1 );
    $Mock_ua->mock( get => sub { $Mock_resp } );

    # $Mock_response->mock( content => sub { $test->mock_response } );
};

test "test simple case for email" => sub {
    my $skuser = SKUser->new(
        id => 'Test SK User', 
        email => 'skuser@example.com', 
        following => [ qw/ Boudicca FintanStack / ]
    );

    my $agent = CalendarAgent->new( api_key => 'foo' );

    UpdateUserByEmail->new(
        skuser => $skuser, 
        ref_time => ISO8601->parse_datetime('2012-01-11T15:40:49+00:00'),
        sender => 'sksocial@example.com',
        cal_agent => $agent,
    )->run;

    my ($send, @extra_emails) = Email::Sender::Simple->default_transport->deliveries;

    is @extra_emails, 0;

    # diag explain $send;
    $send = $send->{email};

    is $send->get_header('To'), 'skuser@example.com';
    is $send->get_header('From'), 'sksocial@example.com';

    my $body = $send->get_body;
    like $body, qr/Boudicca is going to see Left With Pictures on 2012-02-27 at The Lexington, London/;
    like $body, qr/Boudicca is going to see Fanfarlo on 2012-02-28 at Rough Trade East, London/;
    like $body, qr/FintanStack is going to see Ute Lemper on 2012-05-02 at Union Chapel, London/;
    like $body, qr/FintanStack might be going to see Emily Smith on 2012-05-13 at The Cornerstone, Oxford/;

    # Miserable Rich event is before this date
    unlike $body, qr/Boudicca is going to see The Miserable Rich/;

    # might get extra requirements with HTML, multipart etc...
};

run_me;
done_testing();

