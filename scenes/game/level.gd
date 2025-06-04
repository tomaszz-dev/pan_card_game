extends Node3D

# Ładujemy prefab (PackedScene) karty
var CardScene := preload("res://scenes/objects/card.tscn")
var sound = preload("res://assets/sounds/card_rozdanie.wav")
var player = AudioStreamPlayer.new()
var lista = []
var gracz1 = []
var gracz2 = []
var przesuniecie_x
var przesuniecie_y
var przesuniecie_z
var card_id: int = -1
var stos = []
var stos_y = 82.4
var up = []

	
func _ready():
	losowanie()
	przesuniecie_x = -30
	przesuniecie_z = -60
	przesuniecie_y = 82.3
	for i in gracz1:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,0)
		przesuniecie_z = przesuniecie_z+5
		przesuniecie_y = przesuniecie_y+0.01
		await get_tree().create_timer(0.01).timeout
	#gracz2
	przesuniecie_x = 40
	przesuniecie_z = -60
	przesuniecie_y = 83
	for i in gracz2:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,180)
		przesuniecie_z = przesuniecie_z+5
		przesuniecie_y = przesuniecie_y+0.01
		await get_tree().create_timer(0.01).timeout
	game_loop()
	
func ustaw_karty():
	for child in get_children():
		if child is Node3D and child.has_method("set_card"):  # zakładamy że tylko karty mają set_card()
			remove_child(child)
			child.queue_free()

	przesuniecie_x = -30
	przesuniecie_z = -60
	przesuniecie_y = 82.3
	for i in gracz1:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,0)
		przesuniecie_z = przesuniecie_z+5
		przesuniecie_y = przesuniecie_y+0.01
	#gracz2
	przesuniecie_x = 40
	przesuniecie_z = -60
	przesuniecie_y = 83
	for i in gracz2:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,180)
		przesuniecie_z = przesuniecie_z+5
		przesuniecie_y = przesuniecie_y+0.01
	#stos
	przesuniecie_x = 2.0
	przesuniecie_z = 3.0
	przesuniecie_y = 82.4
	for i in stos:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,0)
		przesuniecie_y = przesuniecie_y+0.1
	

func losowanie():
	for i in range(0,52):
		lista.append(i)
		print(i)
	lista.shuffle()
	for i in lista:
		if i % 2 == 0:
			gracz1.append(i)
		else:
			gracz2.append(i)
	print(gracz1,gracz2)



func karta(x,y,z,card_id,rotacja):
		# Tworzymy instancję karty
	var card = CardScene.instantiate()
	# Ustawiamy jej pozycję w świecie (opcjonalnie)
	card.transform.origin = Vector3(x, y, z)
	card.rotation = Vector3(0, deg_to_rad(90), deg_to_rad(rotacja))
	# Dodajemy do sceny
	add_child(card)
	# Ustawiamy jej wartość (np. 9 kier)
	card.set_card(card_id)
	card.card_id = card_id  

#stos

func dzwiek():
	add_child(player)
	player.stream = sound
	player.play()

func left_card_was_clicked(card_node: Node3D):
	var pos = card_node.global_transform.origin
	print(gracz1)

	if card_node.card_id in gracz1:
		if not card_node.is_selected:
			pos.y += 2  # podnieś
			card_node.is_selected = true
			up.append(card_node.card_id)
		else:
			pos.y -= 2  # opuść
			card_node.is_selected = false
			up.erase(card_node.card_id)
	elif card_node.card_id in stos and card_node.card_id == stos[len(stos)-1]:
		if up.is_empty():
			stos.erase(card_node.card_id)
			gracz1.append(card_node.card_id)
			ustaw_karty()
		else:
			var kopia_up = up.duplicate()
			for i in kopia_up:
				gracz1.erase(i)
				stos.append(i)
			up.clear()
			ustaw_karty()

	print(card_node.card_id)
	card_node.global_transform.origin = pos
	print(up)



func game_loop():
	place_this_on_stack(4)
	show_message("Karta została zagrana!")

func place_this_on_stack(x):
	gracz1.erase(x)
	stos.append(x)
	ustaw_karty()

func show_message(text: String, duration: float = 2.0):
	var label = $CanvasLayer/Label
	label.text = text
	label.visible = true
	await get_tree().create_timer(duration).timeout
	label.visible = false

		
func usun_karty_gracza1():
	for child in get_children():
		if child.has_variable("card_id") and child.card_id in gracz1:
			remove_child(child)
			child.queue_free()
