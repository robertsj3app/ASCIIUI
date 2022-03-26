{
package ASCIIUI::InputField;
require Win32::Console::ANSI;
require ASCIIUI::Text;

# Declares a new button.
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,
		text => shift,
        length => shift,
		color => shift,
        variable => shift,
		parent => shift,
		enabled => 1,
	};
	
	bless $self, $class;
	return $self;
}

sub write
{
    my ($self, $char) = @_;

    if($char eq 'BACKSPACE' || $char eq 'DELETE')
    {
        chop(${$self->{variable}});
    }
    else
    {
		if(length(${$self->{variable}}) < $self->{length} - 2)
		{
        	${$self->{variable}} .= $char;
		}
	}
    $self->setText(${$self->{variable}});
}

sub draw()
{
    my ($self, $framebuffer) = @_;

    $x = $self->{topCorner}[0];
	$y = $self->{topCorner}[1];
    if(${$self->{variable}} ne "")
    {
        $self->setText(${$self->{variable}});
    }
    $text = $self->{text};
    $textLen = length($text) + 2;
    $numUnderscores = $self->{length} - $textLen;
    $line = "[" . $text;
    for(1 .. $numUnderscores)
    {
        $line .= "_";
    }
    $line .= "]";
    #print "\e[$self->{color}[0];$self->{color}[1]m";
    ASCIIUI::Text::printAt($x, $y, $line, $framebuffer, "\e[$self->{color}[0];$self->{color}[1]m");
    #print "\e[49;39m";
}

sub redraw()
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

sub getLength
{
    my ($self) = @_;
    return $self->{length};
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

    1;
}