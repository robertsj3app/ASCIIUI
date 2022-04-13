{

# GROUPBOX FUNCTIONALITY (STILL IN DEVELOPMENT)
package ASCIIUI::GroupBox;
use parent ASCIIUI::UIElement;
require ASCIIUI::Text;
require ASCIIUI::Button;
require ASCIIUI::InputField;

our @AllBoxes;

sub getAll
{
	return @AllBoxes;
}

sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,
		dimensions => shift,
		title => shift,
		color => shift,
		children => shift,
		enabled => 1,	
	};
	
	bless $self, $class;
	push(@AllBoxes, $self);

	foreach $b ($self->getChildren())
	{
		$b->setParent($self);
	}	
	return $self;
}

sub setPos
{
	my ($self, @newPos) = @_;
	$self->{topCorner} = @newPos;
	$self->redraw();
}
sub getChildren
{
	my ($self, $index) = @_;
	if(defined($index))
	{
		return $self->{btnObjects}[$index];
	}
	else
	{
		return @{$self->{btnObjects}};
	}
}
sub getType
{
	return "MSGBOX";
}

sub draw
{	
	my ($self, $framebuffer) = @_;
		
	my @pos = @{$self->{topCorner}};
	my $x = $pos[0];
	my $y = $pos[1];
	my $titlen = length($self->{title});
	my $length = $self->{dimensions}[0];
	my $width = $self->{dimensions}[1];

	my @lines;
	#print "\e[$self->{color}[0];$self->{color}[1]m";
		
	my $titLine = "==  $self->{title} ";
	$titLine .= '=' for 1.. $length - 5 - $titlen;	
	my $line = '';
	$line .= '=' for 1..$length;
	my $line2 = '';
	$line2 .= ' ' for 1..$length-4;
	ASCIIUI::Text::printAt($x,$y,$titLine,$framebuffer,$self->getColorString());
	$i = 0;
	for(1..$width)
	{
		ASCIIUI::Text::printAt($x,$y + $i + 1,"||" . $line2 . "||",$framebuffer,$self->getColorString());
		$i++;
	}
	ASCIIUI::Text::printAt($x,$y + $i + 1,$line,$framebuffer,$self->getColorString());
}
sub redraw
{
	my ($self) = @_;
	$self->draw();
}
	1;
}