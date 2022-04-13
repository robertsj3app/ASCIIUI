{

# TEXT BOX OBJECT FUNCTIONALITY AND PRINTAT FUNCTION USED FOR WRITING TO FRAMEBUFFER #

package ASCIIUI::Text;
use parent ASCIIUI::UIElement;

use warnings;
use strict;

# Declare a new Text object
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,	# [X,Y] array for top left corner of object
		text => shift,		# The text this object should display
		color => shift,		# [FG,BG] array for color, use ANSI color codes documented in Win32::Console::ANSI [https://metacpan.org/pod/Win32::Console::ANSI#Escape-sequences-for-Set-Graphics-Rendition]
		parent => shift,    # A reference to a parent object, if any (optional)
		enabled => 1,		# 1/0 Whether this object can be interacted with (optional)
	};

	bless $self, $class;
	return $self;
}

# Write display data to framebuffer
sub draw
{
	my ($self, $framebuffer) = @_;
	
	my $x = $self->{topCorner}[0];
	my $y = $self->{topCorner}[1];
	my $text = $self->{text};
	my $i = 0;
	my @lines = split("\n", $text); # Multiline support

	foreach my $l (@lines)
	{
		printAt($x, $y+$i, $l, $framebuffer, $self->getColorString()); # Write each line's display data to framebuffer
		$i++;
	}
}

# Set text to new value
sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
}

# Function used for writing display data to framebuffer
sub printAt
{
	my($x, $y, $text, $framebuffer, $color) = @_;

	if(!defined($color)) # Use default color if no color is specified
	{
		$color = -1;
	}
	my @chars = split(//, $text);
	foreach my $c (@chars)
	{
		$$framebuffer[$y][$x][1] = $color; # Write color data to framebuffer
		$$framebuffer[$y][$x][0] = $c;	   # Write character data to framebuffer
		$x++;
	}
}

	1;
}


