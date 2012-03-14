=head1 NAME

Net::Songkick::CalendarAgent - Models a calendar entry in the Songkick API

=cut

package Net::Songkick::CalendarAgent;

use strict;
use warnings;

use Moose;
extends 'Net::Songkick';

use aliased 'Net::Songkick::CalendarEntry';

has api_key => (
    is => 'ro',
    required => 1
);

=head1 METHODS

=head2 Net::Songkick::CalendarAgent->get_user_calendar

Returns an array of CalendarEntry objects for the user

=cut

my $API_URL = 'http://api.songkick.com/api/3.0';
my $CAL_URL = "$API_URL/users/USERNAME/calendar";

sub get_new_calendar_entries {
    my $self = shift;
    my $user = shift;

    my ($params) = @_;

    my ($ret_format, $api_format) = $self->_formats($params->{format});

    my $user_id = $user->id;

    my $url = "$CAL_URL.$api_format?apikey=" . $self->api_key;
    $url =~ s/USERNAME/$user_id/;
    my $resp = $self->_request($url);

    if ($ret_format eq 'perl') {
        my $evnts;

        my $xp = XML::LibXML->new->parse_string($resp);
        foreach ($xp->findnodes('//calendarEntry')) {
            push @$evnts, CalendarEntry->new_from_xml($_);
        }
        return wantarray ? @$evnts : $evnts;
    } else {
        return $resp;
    }

}

=head1 AUTHOR

Ashley Hindmarsh <hindmarsh@cpan.org>

=head1 SEE ALSO

perl(1), L<http://www.songkick.com/>, L<http://developer.songkick.com/>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012, Ashley Hindmarsh.  All Rights Reserved.

This script is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. 

=cut

1;
