{
package ASCIIUI::Hotkey;

sub new
{
	my $class = shift;
	my $self = {
		name => shift,
        key  => shift,
        action => shift,
		enabled => 1,
	};
	
	bless $self, $class;
}

sub call
{
    my ($self) = @_;
    $sub = $self->{action};
    &$sub;
}
	1;
}