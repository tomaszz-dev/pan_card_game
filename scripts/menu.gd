extends VBoxContainer

const LEVEL = preload("res://scenes/level.tscn")


func _on_leave_game_button_pressed():
	get_tree().quit()



func _on_new_game_button_pressed():
	get_tree().change_scene_to_packed(LEVEL)
