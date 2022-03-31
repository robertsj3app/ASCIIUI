use lib '..';
use ASCIIUI::Scene;

@windowSize = (110,40);
@playerScreenPos = ($windowSize[0]/2, $windowSize[1]/2);
@playerWorldPos = (1,1);
@mapLines = ();
$collisionChars = "#"; ##TODO: Load this from file.
$mapFile = "mapPadded.txt";
$|++;

open MAP, '<', $mapFile;
while(<MAP>)
{
	push @mapLines, $_;
}
close MAP;

@mapGrid = ();
for($i = 0; $i < @mapLines; $i++)
{
	for($j = 0; $j < length($mapLines[$i]); $j++)
	{
		$mapGrid[$i][$j] = substr($mapLines[$i], $j, 1);
	}
}

sub drawViewport
{
	my ($x, $y) = @_;
	$mapText = "";
	$vertView = $y - 0.5 * $windowSize[1];
	$horView = $x - 0.5 * $windowSize[0];

	for($i = $vertView; $i < $vertView + $windowSize[1] - 1; $i++)
	{
		for($j = $horView; $j < $horView + $windowSize[0]; $j++)
		{
			if($i < 0 || $i >= @mapLines)
			{
				$mapText .= ' ' for $windowSize[0];
			}
			else
			{
				if($j < 0 || $j >= scalar($mapGrid[$i])) ##TODO: figure out why graphics bug out when viewing out of bounds on right side. Temp fix: Pad right side of map with spaces.
				{
					$mapText .= ' ';
				}
				else
				{
					$s = $mapGrid[$i][$j];
					$mapText .= $s;
				}
			}
		}
		$mapText .= "\n";
	}
	return $mapText;
}

sub movePlayer
{
	my ($dir, $amt) = @_;
	if($dir eq 'r')
	{
		if($mapGrid[$playerWorldPos[1]][$playerWorldPos[0]+$amt] ne $collisionChars)
		{
			$playerWorldPos[0] += $amt;
		}
	}
	elsif($dir eq 'l')
	{
		if($mapGrid[$playerWorldPos[1]][$playerWorldPos[0]-$amt] ne $collisionChars)
		{
			$playerWorldPos[0] -= $amt;
		}
	}
	elsif($dir eq 'u')
	{
		if($mapGrid[$playerWorldPos[1]-$amt][$playerWorldPos[0]] ne $collisionChars)
		{
			$playerWorldPos[1] -= $amt;
		}
	}
	elsif($dir eq 'd')
	{
		if($mapGrid[$playerWorldPos[1]+$amt][$playerWorldPos[0]] ne $collisionChars)
		{
			$playerWorldPos[1] += $amt;
		}
	}
	$buf = drawViewport($playerWorldPos[0], $playerWorldPos[1]);
	$char = $mapGrid[$playerWorldPos[1]][$playerWorldPos[0]];
	$pos->setText("Pos: $playerWorldPos[0],$playerWorldPos[1]");
	return $buf;
}

sub callMove
{
	my ($sender) = @_;
	my $newMap = movePlayer(lc(substr($sender->{key}, 0, 1)), 1);
	$viewPort->setText($newMap);
}

$demoScene = ASCIIUI::Scene->new([@windowSize],[
	
	$viewPort = ASCIIUI::Text->new([0,0], drawViewport($playerWorldPos[0], $playerWorldPos[1]), [39,49]),
	$playerSprite = ASCIIUI::Text->new([$playerScreenPos[0], $playerScreenPos[1]], "@", [31,49]),
	$pos = ASCIIUI::Text->new([0,0], "Pos:", [39,49]),
	$menu = ASCIIUI::GroupBox->new([2,2], [19,12], "MENU", [47,31], []),
	$invBtn = ASCIIUI::Button->new([5,3], "Inventory", [47,31], 
		sub
		{
			die "You pushed the button";
		}
	),
	$charBtn = ASCIIUI::Button->new([5,6], "Character", [47,31], 
		sub
		{
			die "You pushed the button";
		}
	),
	$saveBtn = ASCIIUI::Button->new([5,9], "Save", [47,31], 
		sub
		{
			die "You pushed the button";
		}
	),
	$quitBtn = ASCIIUI::Button->new([5,12], "Quit", [47,31], 
		sub
		{
			die "You pushed the button";
		}
	),
	
	$mr = ASCIIUI::Hotkey->new("Move Right", "RIGHTARROW", \&callMove),
	$mu = ASCIIUI::Hotkey->new("Move Up", "UPARROW", \&callMove),
	$ml = ASCIIUI::Hotkey->new("Move Left", "LEFTARROW", \&callMove),
	$md = ASCIIUI::Hotkey->new("Move Down", "DOWNARROW", \&callMove),
	$om = ASCIIUI::Hotkey->new("Open Menu", "q",
		sub
		{
			$menu->toggleEnabled();
			$invBtn->toggleEnabled();
			$charBtn->toggleEnabled();
			$saveBtn->toggleEnabled();
			$quitBtn->toggleEnabled();

			foreach my $e ($demoScene->getElements())
			{
				if(ref($e) =~ /Hotkey/ && $e->getName() ne "Open Menu")
				{
					$e->toggleEnabled();
				}	
			}
		}
	),
], 
sub 
{
	my ($self) = @_;
	foreach my $e ($self->getElements())
	{
		if(ref($e) =~ /Hotkey/ && $e->getName() =~ /(Navigation|Activate)/ )
		{
			$e->setEnabled(0);
		}
	}
	$invBtn->setEnabled(0);
	$charBtn->setEnabled(0);
	$saveBtn->setEnabled(0);
	$quitBtn->setEnabled(0);
	$menu->setEnabled(0);
});

$demoScene->load();