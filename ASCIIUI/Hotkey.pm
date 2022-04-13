{
package ASCIIUI::Hotkey;
use parent ASCIIUI::Enableable;

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

sub getName
{
	my ($self) = @_;
	return $self->{name};
}

sub toString
{
	my ($self) = @_;
	return "$self->{key} : $self->{name}"
}

sub call
{
    my ($self) = @_;
    $sub = $self->{action};
    &$sub($self);
}
	1;
}