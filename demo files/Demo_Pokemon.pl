use lib '..';
use ASCIIUI::Scene;

$nameVar = "";

$selectionScene = ASCIIUI::Scene->new([120,40],[
	ASCIIUI::Text->new([18,5], "Choose your starter Pokemon!", [39,49]),

	ASCIIUI::Hotkey->new("Skip Selection Screen", "s", 
		sub
		{
            $output->setText("You skipping bastard!");
			$selectionScene->unload();
			$statScene->load();
		}),

	ASCIIUI::Button->new([5,10], "Bulbasaur", [47,32], \&createBox),

	ASCIIUI::Button->new([25,10], "Charmander", [47,31], \&createBox), 

    ASCIIUI::Button->new([45,10], "Squirtle", [47,34], \&createBox),

	ASCIIUI::Button->new([0,0], "X", [41,37],
	sub
	{
		my ($sender) = @_;
		ASCIIUI::Scene::quit();
	}
	),
]);

$statScene = ASCIIUI::Scene->new([120,40],[
	ASCIIUI::Button->new([0,0], "<-", [41,37],
	sub
	{
		my ($sender) = @_;
		$statScene->unload();
        $selectionScene->load();
	}
	),

    $output = ASCIIUI::Text->new([18,5], "", [39,49]),

]);

sub createBox
{
	my ($sender) = @_;
		my $pokemon = $sender->getText();
		$selectionScene->addElement(
			ASCIIUI::MsgBox->new($sender->getPos(), "Name your $pokemon", $sender->getColor(), 0,
			[
                ASCIIUI::InputField->new([], "Enter name here!", 40, $sender->getColor(), \$nameVar),

				ASCIIUI::Button->new([], "Ready!", $sender->getColor(), 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
                    $output->setText("Congratulations! You now own a $pokemon named $nameVar!");
					$nameVar = "";
					$selectionScene->unload();
					$statScene->load();
				}),

                ASCIIUI::Button->new([], "Never Mind", $sender->getColor(), 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
					$nameVar = "";
				}),				
			])
		);

}

$selectionScene->load();