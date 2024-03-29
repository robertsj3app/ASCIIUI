{
package ASCIIUI::Scene;
use ASCIIUI::MsgBox;
use ASCIIUI::Text;
use ASCIIUI::Button;
use ASCIIUI::InputField;
use ASCIIUI::GroupBox;
use ASCIIUI::Hotkey;
use Win32::Console::ANSI;
use Term::RawInput;

my $selectedElement = ();
my $selectedWindow = ();
my @framebuffer = ();
my $cursorHidden = 1;
$SIG{INT}  = \&quit;
$SIG{TERM} = \&quit;

#use utf8;
#binmode STDOUT, ":utf8";
#system("chcp 65001");



# Declares a new Scene object.
sub new
{
	my $class = shift;
	my $self = {
		size => shift,
		elements => shift,
		runOnLoad => shift,	
		loaded => 0,	
	};
	
	bless $self, $class;
	return $self;
}

sub getSelectedElement
{
	return $selectedElement;
}

sub getHotkeys 
{
	my ($self) = @_;
	my @hotkeyRefs;
	foreach $e ($self->getElements())
	{
		if(ref($e) =~ /Hotkey/)
		{
			push @hotkeyRefs, $e;
		}
	}
	return @hotkeyRefs;
}

sub hideCursor
{
	print "\e[?25l";
	$cursorHidden = 1;
}

sub showCursor
{
	print "\e[?25h";
	$cursorHidden = 0;
}

sub hasHotkey
{
	my ($self, $key) = @_;
	@allElements = $self->getElements();
	foreach $e (@allElements)
	{
		if(ref($e) =~ /Hotkey/ && $e->{key} eq $key && $e->getEnabled())
		{
			return $e;
		}
	}
	return 0;
}
sub addElement
{
	my ($self, $newElement) = @_;
	push(@{$self->{elements}}, $newElement);
	if(ref($newElement) =~ /MsgBox/)
	{
		foreach $b ($newElement->getBtns())
		{
			$self->addElement($b);
		}
	}
}

sub unload 
{
	my ($self) = @_; 
	if(defined($selectedElement))
	{
		$selectedElement = undef;
	}
	$selectedWindow = undef;
	$self->{loaded} = 0;
}

sub destroy
{
	my ($self, $elemToDestroy) = @_;

	@allElements = $self->getElements();

	for($i = 0; $i <= @allElements; $i++)
	{
		if($self->{elements}[$i] eq $elemToDestroy)
		{
			splice(@{$self->{elements}}, $i, 1);
			if(ref($elemToDestroy) =~ /MsgBox/)
			{
				foreach $b ($elemToDestroy->getBtns())
				{
					$self->destroy($b);
				}
			}
		}
	}
	$selectedElement = undef;
	$selectedWindow = undef;
}

sub updateFrameBuffer
{
	my ($self) = @_;

	my $i;
	my $j;
	my $frame;

	#Cursor(1,1);
	print "\e[1;1H";
	for($i = 0; $i < $self->{size}[1]; $i++)
	{
		for($j = 0; $j < $self->{size}[0]; $j++)
		{
			$framebuffer[$i][$j][0] = ' ';
			$framebuffer[$i][$j][1] = -1;
		}
	}

	foreach $u ($self->getElements())
	{
		if(ref($u) !~ /Hotkey/ && $u->{enabled} == 1)
		{
			$u->draw(\@framebuffer);
		}
	}

	for($i = 0; $i < $self->{size}[1]; $i++)
	{
		for($j = 0; $j < $self->{size}[0]; $j++)
		{
			if(!exists($framebuffer[$i][$j][0]))
			{
				$framebuffer[$i][$j][0] = ' ';
				$framebuffer[$i][$j][1] = -1;
			}
			if($framebuffer[$i][$j][1] != -1 && $framebuffer[$i][$j][1] ne $framebuffer[$i][$j-1][1])
			{
				$frame .= $framebuffer[$i][$j][1];
			}
			else
			{
				if ($framebuffer[$i][$j][1] ne $framebuffer[$i][$j-1][1])
				{
					$frame .= "\e[49;39m";
				}
			}
			$frame .= $framebuffer[$i][$j][0];
		}
	}

	print  $frame;
}

sub load
{
	my ($self) = @_;
	$self->hideCursor();
	if($self->{size} eq "fullscreen")
	{
		SetConsoleFullScreen(1);
	}
	elsif($self->{size}[0] != 0 && $self->{size}[1] != 0)
	{
		system("mode con lines=$self->{size}[1] cols=$self->{size}[0]");
	}
	system("cls");
	
	$self->addElement(
		ASCIIUI::Hotkey->new("Arrow Up Navigation", "UPARROW", 
		sub
		{
			moveCursor("u");
		}
	));
	$self->addElement(
		ASCIIUI::Hotkey->new("Arrow Down Navigation", "DOWNARROW", 
		sub
		{
			moveCursor("d");
		}
	));
	$self->addElement(
		ASCIIUI::Hotkey->new("Arrow Left Navigation", "LEFTARROW", 
		sub
		{
			moveCursor("l");
		}
	));
	$self->addElement(
		ASCIIUI::Hotkey->new("Arrow Right Navigation", "RIGHTARROW", 
		sub
		{
			moveCursor("r");
		}
	));
	$self->addElement(
		ASCIIUI::Hotkey->new("Activate Current Selection", "ENTER",
		sub
		{
			if(defined($selectedElement) && ref($selectedElement) !~ /InputField/ && $selectedElement->{enabled} == 1)
			{
				$selectedElement->click();
			}
		}
	));

	if(defined($self->{runOnLoad}))
	{
		my $action = $self->{runOnLoad};
		&$action($self);
	}

	$self->{loaded} = 1;
	while($self->{loaded} == 1)
	{
		@allBoxes = ();
		@allButtons = ();
		@activeButtons = ();
		@allElements = $self->getElements();
		foreach $e (@allElements)
		{
			if(ref($e) =~ /(Button|InputField)/)
			{
				if($e->{enabled} == 1)
				{
					push(@allButtons, $e);
				}
				else
				{
					if($selectedElement == $e)
					{
						$e->unhover();
						$selectedElement = ();
					}
				}
			}
			elsif(ref($e) =~ /MsgBox/)
			{
				push(@allBoxes, $e);
			}
		}	
	
		$self->updateFrameBuffer();
	
		if(scalar(@allBoxes) == 0)
		{
			@activeButtons = @allButtons;
		}
		else
		{
			if(!defined($selectedWindow))
			{
				$selectedWindow = $allBoxes[0];
				$selectedElement = undef;
			}
			@activeButtons = $selectedWindow->getBtns();
		}
	
		$key = getKey();
		if(ref($selectedElement) =~ /InputField/ && (length($key) == 1 || $key eq 'BACKSPACE'))
		{
			$selectedElement->write($key);
		}
		else
		{
			$h = $self->hasHotkey($key);
			if($h)
			{
				$h->call();
			}
		}
	}
}	

sub getElements
{
	my($self) = @_;
	return @{$self->{elements}};
}

sub getKeybindings
{
	my($self) = @_;
	return %{$self->{keybindings}};
}

sub moveCursor
{
	my($whichDir) = @_;
	if(!defined($selectedElement))
		{
			$selectedElement = $activeButtons[0];
			if(defined($selectedElement))
			{
				$selectedElement->hover();
			}
		}
		else
		{
			$selectedElement->unhover();
			$contender = undef;
			$prevDist = 999;
			foreach $b (@activeButtons)
			{
				if($b != $selectedElement)
				{
					@curPos = @{$selectedElement->getPos()};
					@posPos = @{$b->getPos()};
					$dist = sqrt(($curPos[0] - $posPos[0])**2 + ($curPos[1] - $posPos[1])**2);
					
					if($whichDir =~ /u/i)
					{
						if($dist < $prevDist && $posPos[1] < $curPos[1])
						{
							$contender = $b;
							$prevDist = $dist;
						}
					}
					elsif($whichDir =~ /d/i)
					{
						if($dist < $prevDist && $posPos[1] > $curPos[1])
						{
							$contender = $b;
							$prevDist = $dist;
						}
					}
					elsif($whichDir =~ /l/i)
					{
						if($dist < $prevDist && $posPos[0] < $curPos[0])
						{
							$contender = $b;
							$prevDist = $dist;
						}
					}
					elsif($whichDir =~ /r/i)
					{
						if($dist < $prevDist && $posPos[0] > $curPos[0])
						{
							$contender = $b;
							$prevDist = $dist;
						}
					}
					else
					{
						die "Not a valid direction, whichDir is $whichDir";
					}
				}
				elsif(scalar(@activeButtons) == 1)
				{
					$contender = $selectedElement;
				}
			}
			if(!defined($contender))
			{
				$contender = $selectedElement;
			}
			$selectedElement = $contender;
			$selectedElement->hover();
		}
}

sub getKey
{
	my ($input,$key)=('','');
		($input,$key)=Term::RawInput::rawInput('',1);
		if($input eq '')
		{
			return $key;
		}
		else
		{
			return $input;
		}
}

sub quit
{
	print("\e[?25h");
	system("cls");
	exit;
}

#END {
#    quit();
#}

	1;
}