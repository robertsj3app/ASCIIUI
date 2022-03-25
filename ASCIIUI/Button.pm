{
package ASCIIUI::Button;
require Win32::Console::ANSI;
require ASCIIUI::Text;

# Declares a new button.
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,
		text => shift,
		color => shift,
		action => shift,
		parent => shift,
		enabled => 1,		
	};
	
	bless $self, $class;
	return $self;
}

# Destroys a button object. Should not be necessary.
sub DESTROY
{
	my ($self) = @_;	
	my $self = shift;
	my $class = shift;	
}

# Getters and setters.
sub setPos
{
	my ($self, $newPosX, $newPosY) = @_;
	$self->{topCorner}[0] = $newPosX;
	$self->{topCorner}[1] = $newPosY;
}

sub getPos
{
	my ($self, $index) = @_;
	
	if(defined($index))
	{
		return $self->{topCorner}[$index];
	}
	return @{$self->{topCorner}};
}

sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
}

sub setColor
{
	my ($self, $changeTo) = @_;
	$self->{color} = $changeTo;
}

sub getColor
{
	my ($self) = @_;
	return $self->{color};
}

sub getLength
{
	my ($self) = @_;
	return length($self->{text}) + 4;
}

sub getAction
{
	my ($self) = @_;
	return $self->{action};
}

sub setAction
{
	my ($self, $changeTo) = @_;
	$self->{action} = $changeTo;
}

sub setParent
{
	my ($self, $newParent) = @_;
	$self->{parent} = $newParent;
}

sub getParent
{
	my ($self) = @_;
	return $self->{parent};
}

sub getType
{
	return "BUTTON";
}

# Draws a button on the screen.
sub draw
{
	my ($self, $framebuffer) = @_;
	
	$x = $self->{topCorner}[0];
	$y = $self->{topCorner}[1];	
	$textLen = length($self->{text});
	$line = undef;
	$line .= "+" for 1..($textLen + 4);
	$showText = "| ".$self->{text}." |";
	
	#print "\e[$self->{color}[0];$self->{color}[1]m";
	
	ASCIIUI::Text::printAt($x,$y,$line,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");
	ASCIIUI::Text::printAt($x,$y+1,$showText,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");
	ASCIIUI::Text::printAt($x,$y+2,$line,$framebuffer,"\e[$self->{color}[0];$self->{color}[1]m");
	#print "\e[49;39m";
}

# Redraws the button. Will be identical to draw once clickspace is phased out.
sub redraw
{
	my ($self) = @_;
	$self->draw();
}

sub hover
{
	my ($self) = @_;
	$self->{color}[0] -= 10;
	$self->{color}[1] += 10;
}

sub unhover
{
	my ($self) = @_;
	$self->{color}[0] += 10;
	$self->{color}[1] -= 10;
}

#Runs the function the button is linked to, passing a reference to itself as the first argument.
sub click
{
	my ($self, @args) = @_;
	$sub = $self->{action};
	$self->unhover();
	&$sub($self, @args);		
}
	1;
}