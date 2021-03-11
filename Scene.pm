{
package ASCIIUI::Scene;
require ASCIIUI::MsgBox;
require ASCIIUI::Text;
require ASCIIUI::Button;
require ASCIIUI::InputField;
use Win32::Console;
use Win32::Console::ANSI qw(SetConsoleFullScreen Cursor);
use Term::ReadKey;
use Term::RawInput;

$|++;
my $selectedElement = ();
my $selectedWindow = ();
$SIG{INT}  = \&quit;
$SIG{TERM} = \&quit;

print "\e[?25l";

# Declares a new Scene object.
sub new
{
	my $class = shift;
	my $self = {
		elements => shift,	
		loaded => 0,	
	};
	
	bless $self, $class;
	return $self;
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
	$newElement->draw();
}

sub unload
{
	my ($self) = @_;
	$self->{loaded} = 0;
	$selectedElement = undef;
	$selectedWindow = undef;
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
	system("cls");
}

sub load
{
	my ($self) = @_;
	Cursor(1, 1);
	system("cls");
	foreach $u ($self->getElements())
	{
		$u->draw();
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
				push(@allButtons, $e);
			}
			elsif(ref($e) =~ /MsgBox/)
			{
				push(@allBoxes, $e);
			}
		}	
	
		foreach $ui (@allElements)
		{
			$ui->redraw();
		}
	
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
			$selectedWindow->redraw();
		}
	
		$key = getKey();
		if($key =~ /(l|r|u|d).+arrow/i)
		{		
			moveCursor($1);
		}
		elsif($key eq 'ENTER')
		{
			if(defined($selectedElement) && ref($selectedElement) !~ /InputField/)
			{
				$selectedElement->click();
			}
		}
		elsif($key eq 'ESC')
		{
			last;
		} 
		elsif($key =~ /(\w|\s)/i)
		{
			if(ref($selectedElement) =~ /InputField/)
			{
				$selectedElement->write($key);
			}
		}
		else
		{
			print $key;
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
			$selectedElement->hover();
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
					@curPos = $selectedElement->getPos();
					@posPos = $b->getPos();
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
		($input,$key)=Term::RawInput::rawInput($prompt,1);
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