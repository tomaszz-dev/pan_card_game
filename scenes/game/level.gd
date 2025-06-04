extends Node3D

# Ładujemy prefab (PackedScene) karty
var CardScene := preload("res://scenes/objects/card.tscn")
var gracz
var lista = []
var gracz1 = []
var gracz2 = []

func _ready():
	losowanie()
	var przesuniecie_x = -60
	var przesuniecie_y = 83
	for i in gracz1:
		karta(przesuniecie_x,i,przesuniecie_y)
		przesuniecie_x = przesuniecie_x+5
		przesuniecie_y = przesuniecie_y+0.1
		await get_tree().create_timer(0.1).timeout

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

func karta(z,card_id,y):
		# Tworzymy instancję karty
	var card = CardScene.instantiate()
	
	# Ustawiamy jej pozycję w świecie (opcjonalnie)
	card.transform.origin = Vector3(-34.76, y, z)
	card.rotation = Vector3(0, deg_to_rad(90), 0)
	# Dodajemy do sceny
	add_child(card)
	# Ustawiamy jej wartość (np. 9 kier)
	card.set_card(card_id)
