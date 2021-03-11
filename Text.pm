{
	
## PERL MODULE FOR PRINTING TEXT ANYWHERE ON THE SCREEN ##	
	
package ASCIIUI::Text;
use parent Win32::Console::ANSI;

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
	};
	bless $self, $class;
	push(@AllText, $self);
	return $self;
}

sub draw
{
	my ($self, $storage) = @_;
	
	$x = $self->{x};
	$y = $self->{y};
	$text = $self->{text};
	$i = 0;
	my @lines = split("\n", $text);
	$self->{storage} = $storage;
	foreach $l (@lines)
	{
		printAt($x, $y+$i, $l, $storage);
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
	$self->draw($self->{storage});
}

sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
	$self->redraw();
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
	my($x, $y, $text, $storage, $sender) = @_;
	
	#print "\e[?25l";
	$strLen = length($text);
	if($storage =~ /ARRAY/)
	{
		$i = $x;
		for($i = $x; $i < ($strLen + $x); $i++)
		{
		push (@$storage, "$i:$y");
		}
	}
	elsif($storage =~ /HASH/)
	{
		$i = $x;
		for($i = $x; $i < ($strLen + $x); $i++)
		{
			$$storage{"$i:$y"} = $sender;
		}
	}
	Win32::Console::ANSI::Cursor($x, $y);
	print $text."\n";
	#print "\e[?25h";
}
	1;
}


