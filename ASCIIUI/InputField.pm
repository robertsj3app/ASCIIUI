{

# FIELD FOR ACCEPTING USER INPUT AND STORING IT IN A VARIABLE #

package ASCIIUI::InputField;
use parent ASCIIUI::Button;
use ASCIIUI::Text;

use warnings;
use strict;

# Declare a new InputField
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift, # [X,Y] array for top left corner of object
		text => shift,      # The default text contained in the field before user input
        length => shift,    # The max length the user can input
		color => shift,     # [FG,BG] array for color, use ANSI color codes documented in Win32::Console::ANSI [https://metacpan.org/pod/Win32::Console::ANSI#Escape-sequences-for-Set-Graphics-Rendition]
        variable => shift,  # A reference to a variable to store use input into
        action => shift,    # Reference to the subroutine this button should run when clicked, if any (optional)
		parent => shift,    # A reference to a parent object, if any (optional)
		enabled => 1,       # 1/0 Whether this object can be interacted with (optional)
	};
	
	bless $self, $class;
	return $self;
}

# Input one character into the variable referenced by $self->{variable}
sub write
{
    my ($self, $char) = @_;

    if($char eq 'BACKSPACE' || $char eq 'DELETE') # If a backspace is entered, remove last char
    {
        chop(${$self->{variable}});
    }
    else
    {
		if(length(${$self->{variable}}) < $self->{length} - 2) # Otherwise, append char to variable
		{
        	${$self->{variable}} .= $char;
		}
	}
	
    $self->setText(${$self->{variable}}); # Update text to reflect user input
}

# Write display data to framebuffer
sub draw()
{
    my ($self, $framebuffer) = @_;  # All UI objects must draw themselves into a framebuffer for display

	my $x = $self->{topCorner}[0];
	my $y = $self->{topCorner}[1];
	my $text = $self->{text};
    my $textLen = length($text) + 2;
    my $numUnderscores = $self->{length} - $textLen; # How many underscores to draw after variable text to indicate empty space
    my $line = "[" . $text;
    
    for(1 .. $numUnderscores) 
    {
        $line .= "_";
    }
    $line .= "]";

    ASCIIUI::Text::printAt($x, $y, $line, $framebuffer, $self->getColorString()); # Write display data to framebuffer
}

# Returns length, overrides parent function
sub getLength 
{
    my ($self) = @_;
    return $self->{length};
}

# Override parent function since InputField does not have a subroutine to run when clicked. Scene.pm should prevent this from ever being called
sub click
{
	die("You can't click an InputField!");
}

    1;
}