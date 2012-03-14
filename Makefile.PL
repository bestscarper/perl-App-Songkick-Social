use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::Songkick::Social',
    AUTHOR              => q{Ashley Hindmarsh <perl.app.songkick@best-scarper.co.uk>},
    VERSION_FROM        => 'lib/App/Songkick/Social.pm',
    ABSTRACT_FROM       => 'lib/App/Songkick/Social.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::MockObject' => 0,
        'Test::Mock::LWP' => 0,
        'Net::Songkick' => 0,
        'DateTime' => 0,
        'DateTime::Format::ISO8601' => 0,
        'Email::Sender' => 0,
        'Moose' => 0,
        'Moose::Autobox' => 0,
        'MooseX::Types' => 0,
        'MooseX::Types::DateTime' => 0,
        'MooseX::Types::Email' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-Songkick-Social-*' },
);
