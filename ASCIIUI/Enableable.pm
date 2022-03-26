{

# "ABSTRACT" CLASS ALL ENABLEABLE ELEMENTS INHERIT FROM, CONTAINS COMMON FUNCITONALITY #

package ASCIIUI::Enableable;

use warnings;
use strict;

# Declare new Enableable.
sub new
{
	my $class = shift;
	my $self = {
		enabled => 1,
	};
	
	bless $self, $class;
	die("Enableable is an abstract class and cannot be instantiated.")
}

sub setEnabled
{
    my ($self, $status) = @_;

    if($status == 1 || $status == 0)
    {
        $self->{enabled} = $status;
    }
    else
    {
        die "Invalid enable status."
    }
}

sub getEnabled
{
    my ($self) = @_;

    return $self->{enabled};
}

sub toggleEnabled
{
    my ($self) = @_;

    if($self->getEnabled())
    {
        $self->setEnabled(0);
    }
    else
    {
        $self->setEnabled(1);
    }
}

    1;
}