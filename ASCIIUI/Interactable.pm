{

# "ABSTRACT" CLASS ALL INTERACTABLE UI ELEMENTS INHERIT FROM, CONTAINS COMMON FUNCITONALITY #

package ASCIIUI::Interactable;
use parent ASCIIUI::UIElement;

use warnings;
use strict;

# Declare new Interactable. This is abstract class, this function should never be called
sub new
{
	my $class = shift;
	my $self = {
		color => shift,
        action => shift,
	};
	
	bless $self, $class;
	die("Interactable is an abstract class and cannot be instantiated.")
}

# Swap foreground and background color when interactable object is highlighted
sub hover
{
	my ($self) = @_;
	my $temp = $self->{color}[0];
	$self->{color}[0] -= 10;
	$self->{color}[1] += 10;
}

# Revert foreground and background colors when interactable object is unhighlighted
sub unhover
{
	my ($self) = @_;
	$self->{color}[0] += 10;
	$self->{color}[1] -= 10;
}

# Return reference to the subroutine this button calls when clicked
sub getAction
{
	my ($self) = @_;
	return $self->{action};
}

# Set new subroutine to be run on click
sub setAction
{
	my ($self, $changeTo) = @_;
	$self->{action} = $changeTo;
}

# Run subroutine when interactable object is clicked
sub click
{
    my ($self, @args) = @_;
    if(defined($self->{action}))
    {
	    my $sub = $self->{action};
	    $self->unhover();
	    &$sub($self, @args);	
    }
}

    1;
}