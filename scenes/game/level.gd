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


	
func _ready():
	losowanie()
	dzwiek()
	#gracz1
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

func dzwiek():
	add_child(player)
	player.stream = sound
	player.play()
