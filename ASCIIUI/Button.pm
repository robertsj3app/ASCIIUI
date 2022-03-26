{

# BUTTON OBJECTS, SUPPORT FUNCTIONALITY FOR HOVER HIGHLIGHTING AND RUNNING FUNCTIONS ON CLICK # 

package ASCIIUI::Button;
use parent ASCIIUI::UIElement;
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
	
	ASCIIUI::Text::printAt($x,$y,$line,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");
	ASCIIUI::Text::printAt($x,$y+1,$showText,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");
	ASCIIUI::Text::printAt($x,$y+2,$line,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");

}

# Swap foreground and background color when button is highlighted
sub hover
{
	my ($self) = @_;
	my $temp = $self->{color}[0];
	$self->{color}[0] -= 10;
	$self->{color}[1] += 10;
}

# Revert foreground and background colors when button is unhighlighted
sub unhover
{
	my ($self) = @_;
	$self->{color}[0] += 10;
	$self->{color}[1] -= 10;
}

# Run subroutine $self->{action} when this button is clicked
sub click
{
	my ($self, @args) = @_;
	my $sub = $self->{action};
	$self->unhover();
	&$sub($self, @args);		
}

	1;
}