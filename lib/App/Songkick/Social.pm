package App::Songkick::Social;
our $VERSION = '0.001';

=head1 NAME

App::Songkick::Social - Retired social features reproduced without permission

=head1 SYNOPSIS

    package MyClass;
    use App::Songkick::Social::UpdateUserEMail;
    App::Songkick::Songkick::UpdateUserEMail->new( conf => 'myconf.yaml' );

=head1 DESCRIPTION

Songkick dropped support for a daily digest of updated.

This app reproduces the basics of the service, in a form which might scale reasonably.

It requires a valid Songkick API.

=head1 SEE ALSO

=over

=item L<Net::Songkick>

=item L<Moose>

=back

=head1 AUTHOR

Ashley Hindmarsh C<< <ash.app.songkick@bestHYPHENscarper.co.uk> >>

=head1 COPYRIGHT

Copyright 2012 the above L<AUTHOR>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

