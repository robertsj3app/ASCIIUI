{

# "ABSTRACT" CLASS ALL UI ELEMENTS INHERIT FROM, CONTAINS COMMON FUNCITONALITY #

package ASCIIUI::UIElement;
use parent ASCIIUI::Enableable;

use warnings;
use strict;

# Declare new UIElement. This is abstract class, this function should never be called
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,
		parent => shift,
		color => shift,
		enabled => 1,
	};
	
	bless $self, $class;
	die("UIElement is an abstract class and cannot be instantiated.")
}

# Change this object's color
sub setColor
{
	my ($self, $changeTo) = @_;
	$self->{color} = $changeTo;
}

# Return this object's color
sub getColor
{
	my ($self) = @_;
	return $self->{color};
}

# Return this object's color as an ANSI escape code string
sub getColorString
{
	my ($self) = @_;
	return "\e[$self->{color}[0];$self->{color}[1]m";
}

# Set new parent reference
sub setParent
{
	my ($self, $newParent) = @_;
	$self->{parent} = $newParent;
}

# Return reference to parent
sub getParent
{
	my ($self) = @_;
	return $self->{parent};
}

# Set new position
sub setPos
{
	my ($self, $newX, $newY) = @_;
	$self->{topCorner}[0] = $newX;
	$self->{topCorner}[1] = $newY;
}

# Return position, either X or Y, or both.
sub getPos
{
	my ($self, $index) = @_;
	
	if(defined($index) && ($index == 0 || $index == 1))	# Index 0 = X pos, index 1 = Y pos
	{
		return $self->{topCorner}[$index];
	}
	return @{$self->{topCorner}};
}

sub draw
{
	die("The draw method is not implemented for this class.");
}

	1;
}