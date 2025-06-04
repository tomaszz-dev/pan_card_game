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
var TWOJA_KOLEJ = 1

	
func _ready():
	losowanie()
	dzwiek()
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
	lista.clear()
	gracz1.clear()
	gracz2.clear()

	for i in range(52):
		lista.append(i)
	lista.shuffle()
	
	for i in range(lista.size()):
		if i % 2 == 0:
			gracz1.append(lista[i])
		else:
			gracz2.append(lista[i])




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
func ID_na_moc(x: int) -> int:
	return int(x / 4) + 1
	
func dzwiek():
	add_child(player)
	player.stream = sound
	player.play()

func left_card_was_clicked(card_node: Node3D):
	if TWOJA_KOLEJ != 1:
		return
	# Kliknięta karta należy do gracza
	if card_node.card_id in gracz1:
		var pos = card_node.global_transform.origin
		if not card_node.is_selected:
			if up.is_empty() or ID_na_moc(up[0]) == ID_na_moc(card_node.card_id):  #sprawdza czy ma to sama moc
				pos.y += 2
				card_node.is_selected = true
				up.append(card_node.card_id)
			elif up:
				pass
				# Zaznacz kartę
				
		else:
			# Odznacz kartę
			pos.y -= 2
			card_node.is_selected = false
			up.erase(card_node.card_id)

		card_node.global_transform.origin = pos
	
	# Kliknięto kartę ze stosu (tylko górną)
	elif card_node.card_id in stos and stos.back() == card_node.card_id:
		if up.is_empty() and len(stos) > 1:
			# Podnieś górną kartę ze stosu do ręki
			stos.erase(card_node.card_id)
			gracz1.append(card_node.card_id)
			ustaw_karty()
			TWOJA_KOLEJ = 0
			kolej()
		else:
			# Zagraj wybrane karty na stos
			if len(up) == 1 or len(up) == 4: #tylko 1 albo 4 karty
				if ID_na_moc(stos[len(stos)-1]) <= ID_na_moc(up[0]):
					for card_id in up:
						gracz1.erase(card_id)
						stos.append(card_id)
					up.clear()
					ustaw_karty()
					TWOJA_KOLEJ = 0
					kolej()

	print("Kliknięto kartę:", card_node.card_id)
	print("Wybrane karty:", up)



func game_loop():
	show_message("Zaczyna gracz posiadający kartę 9 serce!")
	if 33 in gracz1:
		show_message("Kolej przeciwnika")
		TWOJA_KOLEJ = 0
	elif 33 in gracz2:
		show_message("Twoja kolej!",)
		TWOJA_KOLEJ = 1
		kolej()
	place_this_on_stack(30)
	await get_tree().create_timer(1).timeout
	kolej()
	

func kolej():
	if TWOJA_KOLEJ == 1:
		show_message("Twoja kolej!")
	else:
		show_message("Kolej przeciwnika.")
		await get_tree().create_timer(1).timeout
		var ostatni = stos.back()
		var zagrano = false
		for x in gracz2:
			if ID_na_moc(x) >= ID_na_moc(ostatni):
				place_this_on_stack(x)
				TWOJA_KOLEJ = 1
				zagrano = true
				break

		if not zagrano:
			# Przeciwnik musi dobrać kartę ze stosu
			stos.pop_back()
			gracz2.append(ostatni)
			TWOJA_KOLEJ = 1
		ustaw_karty()
		kolej()
	if gracz1.is_empty():
		show_message("WYGRAŁEŚ!")
	if gracz2.is_empty():
		show_message("PRZEGRAŁEŚ!")

func place_this_on_stack(x):
	if x in gracz1:
		gracz1.erase(x)
	else:
		gracz2.erase(x)
	stos.append(x)
	ustaw_karty()




func show_message(text: String):
	var label = $CanvasLayer/Label
	label.visible = false
	label.text = text
	label.visible = true
	

		
func usun_karty_gracza1():
	for child in get_children():
		if child.has_variable("card_id") and child.card_id in gracz1:
			remove_child(child)
			child.queue_free()
