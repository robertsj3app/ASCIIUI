{
	
## PERL MODULE FOR PRINTING TEXT ANYWHERE ON THE SCREEN ##	
	
package ASCIIUI::Text;

our @AllText;

sub getAll
{
	return @AllText;
}

sub new
{
	my $class = shift;
	my $self = {
		x => shift,
		y => shift,
		text => shift,
		enabled => 1,
	};
	bless $self, $class;
	push(@AllText, $self);
	return $self;
}

sub draw
{
	my ($self, $framebuffer) = @_;
	
	$x = $self->{x};
	$y = $self->{y};
	$text = $self->{text};
	$i = 0;
	my @lines = split("\n", $text);
	foreach $l (@lines)
	{
		printAt($x, $y+$i, $l, $framebuffer);
		$i++;
	}
}

sub DESTROY
{
	my ($self) = @_;	
	for($i = 0; $i <= @AllText; $i++)
	{
		if($AllButtons[$i] eq $self)
		{
			splice(@AllText, $i, 1);
		}
	}
	my $self = shift;
	my $class = shift;
}
sub redraw
{
	my ($self) = @_;
	$self->draw();
}

sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
}

sub moveTo
{
	my ($self, $newX, $newY) = @_;
	$self->{x} = $newX;
	$self->{y} = $newY;
}

sub printAt
{
	my ($self) = @_;
	my($x, $y, $text, $framebuffer, $color) = @_;
	
	#print "\e[?25l";
	#Win32::Console::ANSI::Cursor($x, $y);
	if(!defined($color))
	{
		$color = -1;
	}
	my @chars = split(//, $text);
	foreach $c (@chars)
	{
		$$framebuffer[$y][$x][1] = $color;
		$$framebuffer[$y][$x][0] = $c;
		$x++;
	}
	#print $text."\n";
	#print "\e[?25h";
}
	1;
}


