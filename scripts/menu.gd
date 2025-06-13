extends VBoxContainer

const LEVEL = preload("res://scenes/game/level.tscn")
@onready var player = $AudioStreamPlayer

var tr_pl = load("res://translations.pl.translation")
var tr_en = load("res://translations.en.translation")


func _ready():
	if tr_pl: TranslationServer.add_translation(tr_pl)
	if tr_en: TranslationServer.add_translation(tr_en)
	TranslationServer.set_locale("en")
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
