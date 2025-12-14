### Health.gd

extends ColorRect

# ref to our label node
@onready var label = $Label


# update label text when signal is emitted
@warning_ignore("unused_parameter")
func update_lives(lives,max_lives):
	label.text = str(lives)
