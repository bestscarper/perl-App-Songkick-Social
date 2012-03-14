=head1 NAME

Net::Songkick::CalendarEntry - Models a calendar entry in the Songkick API

=cut

package Net::Songkick::CalendarEntry;

use strict;
use warnings;

use Moose;
use Moose::Util::TypeConstraints;
use DateTime::Format::ISO8601;

use aliased 'Net::Songkick::Event';
use aliased 'Net::Songkick::Artist';

subtype 'Reason',
    as 'Str',
    where { $_ =~ /^(im_going|i_might_go)$/, },
    message { "$_ is not a valid reason" };

has event => (
    is => 'ro',
    isa => 'Net::Songkick::Event',
    handles => {
        'event_start' => 'start',
        'venue' => 'venue',
        'location' => 'location',
    },
    required => 1,
);

has created_at => (
    is => 'ro',
    isa => 'DateTime',
    default => sub { DateTime->now() }
);

has reason => (
    is => 'ro',
    isa => 'Reason',
    required => 1,
);

has tracked_artist => (
    is => 'ro',
    isa => 'Net::Songkick::Artist',
    handles => { 
        artist => 'displayName'
    },
    lazy_build => 1
);

sub _build_tracked_artist {
    my $self = shift;

    # ugh -driling the xpath might be preferable, but 'event->lead_artist' is a touch better
    $DB::single = 1;
    $self->event->performances->[0]->artist;
};

=head1 METHODS

=head2 Net::Songkick::CalendarEntry->new_from_xml

Creates a new Net::Songkick::CalendarEntry object from an XML::Element object that
has been created from an <calendarEntry> ... </calendarEntry> element in the XML returned
from a Songkick API request.

event - single event per entry (confirm) => //event[0]
reason => reason//@attendance=im_going|i_might_go
trackedArtist => reason/trackedArtist[0]

=cut

sub new_from_xml {
    my $class = shift;
    my ($xml) = @_;

    my $self = {};

    my $created_at = $xml->findvalue('@createdAt');
    $created_at =~ s/0000$/00:00/; # API3.0 generating non-iso8601 DT

    $self->{created_at} = DateTime::Format::ISO8601->parse_datetime($created_at);

    $self->{event} = Event->new_from_xml(
        ($xml->findnodes('event'))[0]
    );

    $self->{reason} = $xml->findvalue('reason/@attendance');
    my ($tracked_artist) = $xml->findnodes('reason/trackedArtist');
    $self->{tracked_artist} = Artist->new_from_xml( $tracked_artist ) if $tracked_artist;

    return $class->new($self);
}

sub as_string {
    my $self = shift;

    sprintf "%s on %s at %s, %s", 
        $self->artist,
        $self->event_start->ymd,
        $self->venue->displayName,
        $self->location->city,
}

=head1 AUTHOR

Ashley Hindmarsh <hindmarsh@cpan.org>

=head1 SEE ALSO

perl(1), L<http://www.songkick.com/>, L<http://developer.songkick.com/>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010, Ashley Hindmarsh.  All Rights Reserved.

This script is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. 

=cut

1;
