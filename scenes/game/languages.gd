extends VBoxContainer



func _on_button_pressed():
	TranslationServer.set_locale("pl")



func _on_button_2_pressed():
	TranslationServer.set_locale("en")
