extends VBoxContainer

const LEVEL = preload("res://scenes/game/level.tscn")
@onready var player = $AudioStreamPlayer

func _ready():
	if player:
		print("Znaleziono AudioStreamPlayer")
	else:
		print("Nie znaleziono AudioStreamPlayer")

func _on_leave_game_button_pressed():

	get_tree().quit()
	
	

func _on_new_game_button_pressed():
	get_tree().change_scene_to_packed(LEVEL)
