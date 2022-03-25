{
use lib '.';
package ASCIIUI::UIElement;
require Win32::Console::ANSI;

sub new
{
	my $class = shift;
	my $self = {
		parent => shift,
	};
	
	bless $self, $class;
	return $self;
}

sub setParent
{
	my ($newParent) = @_;
	$self->{parent} = $newParent;
}
1;
}