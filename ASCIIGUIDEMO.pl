use ASCIIUI::Scene;

$nameVar = "";
$pokemon = "";

$selectionScene = ASCIIUI::Scene->new([
	ASCIIUI::Text->new(18, 5, "Choose your starter Pokemon!"),

	ASCIIUI::Button->new([5,10], "Bulbasaur", [47,32], 
	sub 
	{ 
		my ($sender) = @_;
		$selectionScene->addElement(
			ASCIIUI::MsgBox->new([5,10], "Name your Bulbasaur!", [47,32], 0,
			[
                ASCIIUI::InputField->new([5,10], "Enter name here!", 40, [47,32], \$nameVar),

				ASCIIUI::Button->new([5,10], "Ready!", [47,32], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
                    $pokemon = "Bulbasaur";
                    $output->setText("Congratulations! You now own a $pokemon named $nameVar!");
					$selectionScene->unload();
					$statScene->load();
				}
				),

                ASCIIUI::Button->new([5,10], "Never Mind", [47,32], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
					$nameVar = "";
				}
				),
			])
		);
	}
	),

	ASCIIUI::Button->new([25,10], "Charmander", [47,31], 
	sub 
	{ 
		my ($sender) = @_;
		$selectionScene->addElement(
			ASCIIUI::MsgBox->new([25,10], "Name your Charmander!", [47,31], 0,
			[
                ASCIIUI::InputField->new([25,10], "Enter name here!", 40, [47,31], \$nameVar),

				ASCIIUI::Button->new([25,10], "Ready!", [47,31], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
                    $pokemon = "Charmander";
                    $output->setText("Congratulations! You now own a $pokemon named $nameVar!");
					$selectionScene->unload();
					$statScene->load();
				}
				),

                ASCIIUI::Button->new([25,10], "Never Mind", [47,31], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
					$nameVar = "";
				}
				),
			])
		);
	}
	),

    ASCIIUI::Button->new([45,10], "Squirtle", [47,34], 
	sub 
	{ 
		my ($sender) = @_;
		$selectionScene->addElement(
			ASCIIUI::MsgBox->new([45,10], "Name your Squirtle!", [47,34], 0,
			[
                ASCIIUI::InputField->new([45,10], "Enter name here!", 40, [47,34], \$nameVar),

				ASCIIUI::Button->new([45,10], "Ready!", [47,34], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
                    $pokemon = "Squirtle";
                    $output->setText("Congratulations! You now own a $pokemon named $nameVar!");
					$selectionScene->unload();
					$statScene->load();
				}
				),

                ASCIIUI::Button->new([45,10], "Never Mind", [47,34], 
				sub 
				{ 
					my ($sender) = @_;
					$selectionScene->destroy($sender->getParent());
					$nameVar = "";
				}
				),
			])
		);
	}
	),

	ASCIIUI::Button->new([1,1], "X", [41,37],
	sub
	{
		my ($sender) = @_;
		ASCIIUI::Scene::quit();
	}
	),
]);

$statScene = ASCIIUI::Scene->new([
	ASCIIUI::Button->new([1,1], "<-", [41,37],
	sub
	{
		my ($sender) = @_;
		$statScene->unload();
        $selectionScene->load();
	}
	),

    $output = ASCIIUI::Text->new(18, 5, ""),

]);

$selectionScene->load();