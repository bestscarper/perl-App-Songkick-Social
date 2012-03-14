package App::Songkick::FollowedUser;
use Moose;
use MooseX::Types::Moose qw(Str ArrayRef);
use Moose::Autobox;

use aliased 'Net::Songkick::CalendarEntry';
use aliased 'Net::Songkick::Artist';
use aliased 'Net::Songkick::Event';
use aliased 'Net::Songkick::CalendarAgent';

has id => (
    is => 'ro',
    required => 1
);

sub get_new_event_objects {
    my $self = shift;
    my $sk_agent = shift;

    return $sk_agent->get_new_calendar_entries( $self );
}

sub get_new_events {
    my $self = shift;
    my $sk_agent = shift;
    my $ref_time = shift;
    $self->get_new_event_objects($sk_agent)
        ->grep(
            sub {
                $_->created_at >= $ref_time 
            }
            )
        ->map(
            sub { sprintf "%s %s going to see %s",
                $self->id,  
                ($_->reason eq 'im_going' ? 'is' : 'might be'),
                $_->as_string
                }
            )
}

1
