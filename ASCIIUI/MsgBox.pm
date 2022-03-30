{

# MESSAGEBOX FUNCTIONALITY FOR INTERACTIVE POP-UP MESSAGES AND MENUS #

package ASCIIUI::MsgBox;
use parent ASCIIUI::UIElement;
use ASCIIUI::Text;
use ASCIIUI::Button;
use ASCIIUI::InputField;

use warnings;
use strict;

# Declare new MessageBox
sub new
{
	my $class = shift;
	my $self = {
		topCorner => shift,  # [X,Y] array for top left corner of object
		text => shift,		 # The text this object should display
		color => shift,		 # [FG,BG] array for color, use ANSI color codes documented in Win32::Console::ANSI [https://metacpan.org/pod/Win32::Console::ANSI#Escape-sequences-for-Set-Graphics-Rendition]
		length => shift,	 # The desired length for this MessageBox. May be modified if child buttons cannot fit inside this length
		btnObjects => shift, # Array of all buttons to become children of this MessageBox
		enabled => 1,		 # 1/0 Whether this object can be interacted with (optional)
	};
	
	bless $self, $class;

	foreach $b ($self->getBtns()) # Set self as parent to all child buttons
	{
		$b->setParent($self);
	}	

	return $self;
}

# Custom DESTROY function, will also destroy child buttons when this object falls out of scope.
sub DESTROY {
	my ($self) = @_;	
	foreach $b ($self->getBtns())
		{
			$b->DESTROY();
			$b = undef;
		}	
	
	$self = shift;
}

# Get a list of all child buttons of this MessageBox, either by index or the entire list.
sub getBtns
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

# Write display data to framebuffer
sub draw
{	
	my ($self, $framebuffer) = @_;

	my $txt = $self->{text};
	my $leng = $self->{length};
	my $btnLengths = 0;
	my $inputLengths = 0;
	my $btnKerning = 3;
	my @chars = split(//, $txt);
	my @pos = @{$self->{topCorner}};
	my $x = $pos[0];
	my $y = $pos[1];
	my @lines;
	
	foreach $b (@{$self->{btnObjects}}) # Lines 82 - 100 increase messagebox size if needed to ensure all children fit inside.
	{
		if(ref($b) !~ /InputField/)
		{
			$btnLengths += $b->getLength() + $btnKerning;
		}
		else
		{
			$inputLengths += $b->getLength() + $btnKerning;
		}
	}
	if($leng < $btnLengths)
	{
		$leng = $btnLengths;
	}
	if($leng < $inputLengths)
	{
		$leng = $inputLengths;
	}
		
	my $line2 = '';
	$line2 .= '=' for 1..($leng + 6);
	ASCIIUI::Text::printAt($x,$y,$line2,$framebuffer,$self->getColorString());
	
	my $output = '';
	foreach my $c (@chars)
	{
		if($c eq "\n")
		{
			while(length($output) < $leng)
			{
				$output .= ' ';
			}
		}
		else
		{
			$output .= $c;
		}

		if(length($output) == $leng)
		{
			push(@lines, $output);
			$output = '';
		}
	}
	while(length($output) < $leng)
	{
		$output .= ' ';
	}
	push(@lines, $output);

	my $yoffset = 1;
	my $xoffset = 4;
	foreach my $l (@lines)
	{
		ASCIIUI::Text::printAt($x,($y+$yoffset),"|| $l ||",$framebuffer,$self->getColorString());
		$yoffset++;
	}
	my $btnyoffset = $yoffset;	
	my $clearSpace = '||';
	while(length($clearSpace) < ($leng + 4))
	{
		$clearSpace .= ' ';
	}
	$clearSpace .= '||';
	my $howManyBlanks = 5;
	foreach $b (@{$self->{btnObjects}})
	{
		if(ref($b) =~ /InputField/)
		{
			$howManyBlanks += 3; 
		}
	}
	for(my $p = 0; $p < $howManyBlanks; $p++)
	{
		ASCIIUI::Text::printAt($x,($y+$yoffset),$clearSpace,$framebuffer,$self->getColorString());
		$yoffset++;
	}
	ASCIIUI::Text::printAt($x,($y+$yoffset),$line2,$framebuffer,$self->getColorString());
	
	my $btnxoffset = 0;
	for(my $j = 0; $j < scalar(@{$self->{btnObjects}}); $j++)
	{
		if($j != 0)
		{
			if(ref($self->{btnObjects}[$j-1]) !~ /InputField/) # TODO: Formatting gets messed up if InputField is declared after buttons
			{
				$btnxoffset += $self->{btnObjects}[$j-1]->getLength() + $btnKerning;
			}
		}
		$self->{btnObjects}[$j]->setPos(($x+$xoffset+$btnxoffset), ($y+$btnyoffset+2));
		if(ref($self->{btnObjects}[$j]) =~ /InputField/)
		{
			$btnyoffset += 3; 
		}
	}
}

# DEPRECATED, RETAIN FOR POSSIBLE FUTURE APPLICATIONS
# sub click
# {
# 	($self) = @_;
	
# 	for($i = 0; $i <= length(@AllBoxes); $i++)
# 	{
# 		if($AllBoxes[$i] eq $self)
# 		{
# 			push(@AllBoxes, $self);
# 			splice(@AllBoxes, $i, 1);
# 		}
# 	}
# }

	1;
}