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

$demoScene = ASCIIUI::Scene->new([@windowSize],[
	
	$viewPort = ASCIIUI::Text->new(0, 0, drawViewport($playerWorldPos[0], $playerWorldPos[1])),
	$playerSprite = ASCIIUI::Text->new($playerScreenPos[0], $playerScreenPos[1], "@"),
	$pos = ASCIIUI::Text->new(0,0, "Pos:"),
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
	
	$mr = ASCIIUI::Hotkey->new("Move Right", "d", 
		sub
		{
			$newMap = movePlayer('r', 1);
			$viewPort->setText($newMap);
		}
	),
	$mu = ASCIIUI::Hotkey->new("Move Up", "w", 
		sub
		{
			$newMap = movePlayer('u', 1);
			$viewPort->setText($newMap);
		}
	),
	$ml = ASCIIUI::Hotkey->new("Move Left", "a", 
		sub
		{
			$newMap = movePlayer('l', 1);
			$viewPort->setText($newMap);
		}
	),
	$md = ASCIIUI::Hotkey->new("Move Down", "s", 
		sub
		{
			$newMap = movePlayer('d', 1);
			$viewPort->setText($newMap);
		}
	),
	$om = ASCIIUI::Hotkey->new("Open Menu", "q",
		sub
		{
			
			if($menu->{enabled} == 1) ##TODO: Allow toggling enable status of parent to toggle enable status of children, add toggleEnabled function to objects
			{
				$menu->{enabled} = 0;
				$invBtn->{enabled} = 0;
				$charBtn->{enabled} = 0;
				$saveBtn->{enabled} = 0;
				$quitBtn->{enabled} = 0;
				$mr->{enabled} = 1;
				$mu->{enabled} = 1;
				$ml->{enabled} = 1;
				$md->{enabled} = 1;
			}
			else
			{
				$menu->{enabled} = 1;
				$invBtn->{enabled} = 1;
				$charBtn->{enabled} = 1;
				$saveBtn->{enabled} = 1;
				$quitBtn->{enabled} = 1;
				$mr->{enabled} = 0;
				$mu->{enabled} = 0;
				$ml->{enabled} = 0;
				$md->{enabled} = 0;
			}
		}
	),
]);
$invBtn->{enabled} = 0;
$charBtn->{enabled} = 0;
$saveBtn->{enabled} = 0;
$quitBtn->{enabled} = 0;
$menu->{enabled} = 0;
$demoScene->load();