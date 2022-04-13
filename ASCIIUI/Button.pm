{

# BUTTON OBJECTS, SUPPORT FUNCTIONALITY FOR HOVER HIGHLIGHTING AND RUNNING FUNCTIONS ON CLICK # 

package ASCIIUI::Button;
use parent ASCIIUI::Interactable;
use ASCIIUI::Text;

use warnings;
use strict;

sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift, # [X,Y] array for top left corner of object
		text => shift,		# The text this object should display
		color => shift,     # [FG,BG] array for color, use ANSI color codes documented in Win32::Console::ANSI [https://metacpan.org/pod/Win32::Console::ANSI#Escape-sequences-for-Set-Graphics-Rendition]
		action => shift,	# Reference to the subroutine this button should run when clicked
		parent => shift,	# A reference to a parent object, if any (optional)
		enabled => 1,		# 1/0 Whether this object can be interacted with (optional)
	};
	
	bless $self, $class;
	return $self;
}

# Change text displayed by this object
sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
}

# Return this object's text
sub getText
{
	my ($self) = @_;
	return $self->{text};
}

# Return this object's length
sub getLength
{
	my ($self) = @_;
	return length($self->{text}) + 4;
}

# Write display data to framebuffer
sub draw
{
	my ($self, $framebuffer) = @_;
	
	my $x = $self->{topCorner}[0];
	my $y = $self->{topCorner}[1];	
	my $textLen = length($self->{text});
	my $line;
	my $showText = "| ".$self->{text}." |";

	$line .= "+" for 1..($textLen + 4);
	
	ASCIIUI::Text::printAt($x,$y,$line,$framebuffer,$self->getColorString());
	ASCIIUI::Text::printAt($x,$y+1,$showText,$framebuffer,$self->getColorString());
	ASCIIUI::Text::printAt($x,$y+2,$line,$framebuffer,$self->getColorString());

}

	1;
}