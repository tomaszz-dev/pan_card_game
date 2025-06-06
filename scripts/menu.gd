extends VBoxContainer

const LEVEL = preload("res://scenes/game/level.tscn")
@onready var player = $AudioStreamPlayer


func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	print(DisplayServer.window_get_mode())
	if player:
		print("Znaleziono AudioStreamPlayer")
	else:
		print("Nie znaleziono AudioStreamPlayer")

func _on_leave_game_button_pressed():

	get_tree().quit()
	
	
func _on_new_game_button_pressed():
	get_tree().change_scene_to_packed(LEVEL)



var ekran = DisplayServer.WINDOW_MODE_FULLSCREEN

func _input(event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if ekran == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			ekran = DisplayServer.WINDOW_MODE_FULLSCREEN
			print('fullscreen')
		else:
			ekran = DisplayServer.WINDOW_MODE_WINDOWED
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print('tryb okienkowy')
