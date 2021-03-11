{
package ASCIIUI::MsgBox;
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
		text => shift,
		color => shift,
		length => shift,
		btnObjects => shift,	
	};
	
	bless $self, $class;
	push(@AllBoxes, $self);

	foreach $b ($self->getBtns())
	{
		$b->setParent($self);
	}	
	return $self;
}

sub DESTROY {
	my ($self) = @_;	
	for($i = 0; $i <= @AllBoxes; $i++)
	{
		if($AllBoxes[$i] eq $self)
		{
			splice(@AllBoxes, $i, 1);
		}
	}
	foreach $b ($self->getBtns())
		{
			$b->DESTROY();
			$b = undef;
		}
	
	
	my $self = shift;
	my $class = shift;

}

sub setPos
{
	my ($self, @newPos) = @_;
	$self->{topCorner} = @newPos;
	$self->redraw();
}
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
sub getType
{
	return "MSGBOX";
}
sub setText
{
	my ($self, $changeTo) = @_;
	$self->{text} = $changeTo;
}

sub draw
{	
	my ($self) = @_;
		
	if(length(@{$self->{btnTexts}}) != length(@{$self->{btnActions}}))
	{
		die "Different numbers of button texts and actions!";
	}
	my $txt = $self->{text};
	my $leng = $self->{length};
	my $btnLengths = 0;
	my $inputLengths = 0;
	my $btnKerning = 3;
	my $cs = $self->{clickSpace};
	my @chars = split(//, $txt);
	my @pos = @{$self->{topCorner}};
	my $x = $pos[0];
	my $y = $pos[1];
	my @lines;
	print "\e[$self->{color}[0];$self->{color}[1]m";
	
	foreach $b (@{$self->{btnObjects}})
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
	ASCIIUI::Text::printAt($x,$y,$line2,$cs,$self);
	
	$output = '';
	foreach $c (@chars)
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

	$yoffset = 1;
	$xoffset = 4;
	foreach $l (@lines)
	{
		ASCIIUI::Text::printAt($x,($y+$yoffset),"|| $l ||",$cs,$self);
		$yoffset++;
	}
	$btnyoffset = $yoffset;	
	$clearSpace = '||';
	while(length($clearSpace) < ($leng + 4))
	{
		$clearSpace .= ' ';
	}
	$clearSpace .= '||';
	$howManyBlanks = 5;
	foreach $b (@{$self->{btnObjects}})
	{
		if(ref($b) =~ /InputField/)
		{
			$howManyBlanks += 3; 
		}
	}
	for($p = 0; $p < $howManyBlanks; $p++)
	{
		ASCIIUI::Text::printAt($x,($y+$yoffset),$clearSpace,$cs,$self);
		$yoffset++;
	}
	ASCIIUI::Text::printAt($x,($y+$yoffset),$line2,$cs,$self);
	
	my $btnxoffset = 0;
	for($j = 0; $j < scalar(@{$self->{btnObjects}}); $j++)
	{
		if($j != 0)
		{
			if(ref($self->{btnObjects}[$j-1]) !~ /InputField/)
			{
				$btnxoffset += $self->{btnObjects}[$j-1]->getLength() + $btnKerning;
			}
		}
		$self->{btnObjects}[$j]->setPos(($x+$xoffset+$btnxoffset), ($y+$btnyoffset+2)); #= ASCIIUI::Button->new([($x+$xoffset+$btnxoffset), ($y+$btnyoffset+2)], $self->{btnTexts}[$j], [$self->{color}[0], $self->{color}[1]], $self->{btnActions}[$j]);
		if(ref($self->{btnObjects}[$j]) =~ /InputField/)
		{
			$btnyoffset += 3; 
		}
	}
	foreach $b (@{$self->{btnObjects}})
	{
		$b->redraw();
	}

	print "\e[39;49m";
}
sub click
{
	($self) = @_;
	
	for($i = 0; $i <= length(@AllBoxes); $i++)
	{
		if($AllBoxes[$i] eq $self)
		{
			push(@AllBoxes, $self);
			splice(@AllBoxes, $i, 1);
			$self->redraw();
		}
	}
}
sub redraw
{
	my ($self) = @_;
	$self->draw();
	# my ($self) = @_;
		
	# my $txt = $self->{text};
	# my $leng = $self->{length};
	# my $btnLengths = 0;
	# my $btnKerning = 3;
	# my $cs = $self->{clickSpace};
	# my @chars = split(//, $txt);
	# my @pos = @{$self->{topCorner}};
	# my $x = $pos[0];
	# my $y = $pos[1];
	# my @lines;
	# print "\e[$self->{color}[0];$self->{color}[1]m";
	
	# foreach $b (@{$self->{btnObjects}})
	# {
	# 	$btnLengths += $b->getLength() + 4 + $btnKerning;
	# }
	# if($leng < $btnLengths)
	# {
	# 	$leng = $btnLengths;
	# }
		
	# my $line2 = '';
	# $line2 .= '=' for 1..($leng + 6);
	# ASCIIUI::Text::printAt($x,$y,$line2,$cs,$self);
	
	# $output = '';
	# foreach $c (@chars)
	# {
	# 	if($c eq "\n")
	# 	{
	# 		while(length($output) < $leng)
	# 		{
	# 			$output .= ' ';
	# 		}
	# 	}
	# 	else
	# 	{
	# 		$output .= $c;
	# 	}

	# 	if(length($output) == $leng)
	# 	{
	# 		push(@lines, $output);
	# 		$output = '';
	# 	}
	# }
	# while(length($output) < $leng)
	# {
	# 	$output .= ' ';
	# }
	# push(@lines, $output);
	
	# $yoffset = 1;
	# $xoffset = 4;
	# foreach $l (@lines)
	# {
	# 	ASCIIUI::Text::printAt($x,($y+$yoffset),"|| $l ||",$cs,$self);
	# 	$yoffset++;
	# }
	# $btnyoffset = $yoffset;	
	# $clearSpace = '||';
	# while(length($clearSpace) < ($leng + 4))
	# {
	# 	$clearSpace .= ' ';
	# }
	# $clearSpace .= '||';
	# for($p = 0; $p < 5; $p++)
	# {
	# 	ASCIIUI::Text::printAt($x,($y+$yoffset),$clearSpace,$cs,$self);
	# 	$yoffset++;
	# }
	# ASCIIUI::Text::printAt($x,($y+$yoffset),$line2,$cs,$self);
	
	# my $btnxoffset = 0;
	
	# foreach $b (@{$self->{btnObjects}})
	# {
	# 	$b->redraw();
	# }

	# print "\e[39;49m";
}
	1;
}