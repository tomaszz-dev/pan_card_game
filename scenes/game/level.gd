extends Node3D

# Ładujemy prefab (PackedScene) karty
var CardScene := preload("res://scenes/objects/card.tscn")

func _ready():
	# Tworzymy instancję karty
	var card = CardScene.instantiate()
	
	# Ustawiamy jej pozycję w świecie (opcjonalnie)
	card.transform.origin = Vector3(-34.76, 83, 14)
	card.rotation = Vector3(0, deg_to_rad(90), 0)
	# Dodajemy do sceny
	add_child(card)
	
	# Ustawiamy jej wartość (np. 9 kier)
	card.set_card_by_value(card.Suit.HEARTS, 2)
