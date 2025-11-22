### Pickup.gd

#When you add at the top of a script the tool keyword, it will be executed not only during the game, but also in the editor.
@tool

extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)

# pickup enum
enum Pickups {HEALTH, SCORE, ATTACK}
@export var pickup : Pickups

# texture assets for our pickup
var health_texture = preload("res://Assets/heart/heart/sprite_0.png")
var score_texture = preload("res://Assets/star/star/sprite_04.png")
var attack_boost_texture = preload("res://Assets/lightning bolt/lightning bolt/sprite_0.png")

# reference to our sprite 2d texture
@onready var pickup_texture = get_node("Sprite2D")

# allow us to change the sprite texture in editor
func _processs (_delta):
	if Engine.is_editor_hint():
		if pickup == Pickups.HEALTH:
			pickup_texture.set_texture(health_texture)
		elif pickup == Pickups.SCORE:
			pickup_texture.set_texture(score_texture)
		elif pickup == Pickups.ATTACK:
			pickup_texture.set_texture(attack_boost_texture)
