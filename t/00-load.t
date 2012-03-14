#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Songkick::Social' ) || print "Bail out!\n";
}

diag( "Testing App::Songkick::Social $App::Songkick::Social::VERSION, Perl $], $^X" );
