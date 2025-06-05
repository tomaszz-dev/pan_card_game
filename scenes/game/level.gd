extends Node3D

# Ładujemy prefab (PackedScene) karty
var CardScene := preload("res://scenes/objects/card.tscn")
var rozdanie = preload("res://assets/sounds/card_rozdanie.wav")
var error = preload("res://assets/sounds/error.wav")
var card_up = preload("res://assets/sounds/card_up.wav")
var card_stack = preload("res://assets/sounds/card_stack.wav")
var stack_up = preload("res://assets/sounds/stack_up.wav")
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
var gra_skonczona
	
func _ready():
	losowanie()
	dzwiek(rozdanie)
	przesuniecie_x = -30
	przesuniecie_z = -50
	przesuniecie_y = 82.3
	for i in gracz1:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,0)
		przesuniecie_z = przesuniecie_z+10
		przesuniecie_y = przesuniecie_y+0.01
		await get_tree().create_timer(0.01).timeout
	#gracz2
	przesuniecie_x = 40
	przesuniecie_z = -50
	przesuniecie_y = 83
	for i in gracz2:
		karta(przesuniecie_x,przesuniecie_y,przesuniecie_z,i,180)
		przesuniecie_z = przesuniecie_z+10
		przesuniecie_y = przesuniecie_y+0.01
		await get_tree().create_timer(0.01).timeout
	game_loop()
	
func ustaw_karty():
	for child in get_children():
		if child is Node3D and child.has_method("set_card"):
			remove_child(child)
			child.queue_free()

	var max_z_range = 100.0  # czyli od -50 do 50
	var max_step = 10.0
	var min_z = -50.0

	# Gracz 1
	var ilosc_kart = gracz1.size()
	var step_z = max_z_range / max(ilosc_kart - 1, 1)
	step_z = min(step_z, max_step)
	var total_range = step_z * (ilosc_kart - 1)
	var start_z = -total_range / 2.0

	var przesuniecie_x = -30
	var przesuniecie_y = 82.3
	for i in gracz1:
		var index = gracz1.find(i)
		var przesuniecie_z = start_z + index * step_z
		karta(przesuniecie_x, przesuniecie_y, przesuniecie_z, i, 0)
		przesuniecie_y += 0.01

	# Gracz 2
	ilosc_kart = gracz2.size()
	step_z = max_z_range / max(ilosc_kart - 1, 1)
	step_z = min(step_z, max_step)
	total_range = step_z * (ilosc_kart - 1)
	start_z = -total_range / 2.0

	przesuniecie_x = 40
	przesuniecie_y = 83.0
	for i in gracz2:
		var index = gracz2.find(i)
		var przesuniecie_z = start_z + index * step_z
		karta(przesuniecie_x, przesuniecie_y, przesuniecie_z, i, 180)
		przesuniecie_y += 0.01

	# Stos
	przesuniecie_x = 2.0
	przesuniecie_y = 82.4
	przesuniecie_z = 3.0
	for i in stos:
		karta(przesuniecie_x, przesuniecie_y, przesuniecie_z, i, 0)
		przesuniecie_y += 0.1


func losowanie():
	lista.clear()
	gracz1.clear()
	gracz2.clear()

	for i in range(24):
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
	
func dzwiek(x):
	add_child(player)
	player.stream = x
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
				dzwiek(card_up)
			elif up:
				dzwiek(error)
				
				# Zaznacz kartę
				
		else:
			# Odznacz kartę
			pos.y -= 2
			card_node.is_selected = false
			up.erase(card_node.card_id)
			dzwiek(card_up)
		card_node.global_transform.origin = pos
	
	# Kliknięto kartę ze stosu (tylko górną)
	elif card_node.card_id in stos and stos.back() == card_node.card_id:
		if up.is_empty() and len(stos) > 1:
			# Podnieś górną kartę ze stosu do ręki
			for i in range(3):
				if len(stos) == 1:
					pass
				else:
					gracz1.append(stos.back())
					stos.pop_back()
			ustaw_karty()
			dzwiek(card_stack)
			TWOJA_KOLEJ = 0
			kolej()
		else:
			# Zagraj wybrane karty na stos
			if len(up) == 1 or len(up) == 4 or zawiera_trzy_dziewiatki(up):#tylko 1 albo 4 karty albo 3 dziewiatki 
				if ID_na_moc(stos[len(stos)-1]) <= ID_na_moc(up[0]):
					for card_id in up:
						gracz1.erase(card_id)
						stos.append(card_id)
					up.clear()
					ustaw_karty()
					TWOJA_KOLEJ = 0
					kolej()
					dzwiek(stack_up)
				else:
					dzwiek(error)
			else:
				dzwiek(error)
	else:
		dzwiek(error)
	print("Kliknięto kartę:", card_node.card_id)
	print("Wybrane karty:", up)

func zawiera_trzy_dziewiatki(lista_kart):
	if lista_kart.size() != 3:
		return false
	for id in lista_kart:
		if ID_na_moc(id) != 1:
			return false
	return true

func game_loop():
	show_message("Zaczyna gracz posiadający kartę 9 serce!")
	if 2 in gracz1:
		show_message("Kolej przeciwnika")
		TWOJA_KOLEJ = 0
	elif 2 in gracz2:
		show_message("Twoja kolej!",)
		TWOJA_KOLEJ = 1
		kolej()
	place_this_on_stack(2)
	await get_tree().create_timer(1).timeout
	kolej()
	

func kolej():
	if gra_skonczona:
		return
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
				dzwiek(stack_up)
				break
		if not zagrano:
			# Przeciwnik musi dobrać kartę, ale tylko jeśli stos ma więcej niż jedną kartę
			if stos.size() > 1:
				for i in range(3):
					if len(stos) == 1:
						pass
					else:
						gracz2.append(stos.back())
						stos.pop_back()
				TWOJA_KOLEJ = 1
				dzwiek(card_stack)
			else:
				show_message("WYGRAŁEŚ!")  # Przeciwnik nie ma ruchu i nie może dobrać — przegrywa
				return
		
		ustaw_karty()
		kolej()

	if gracz1.is_empty():
		show_message("WYGRAŁEŚ!")
		gra_skonczona = true
		return
	if gracz2.is_empty():
		show_message("PRZEGRAŁEŚ!")
		gra_skonczona = true
		return
		


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
