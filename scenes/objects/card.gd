extends Node3D


enum Suit { CLUBS, DIAMONDS, HEARTS, SPADES }

var card_id: int = -1 
var is_selected: bool = false

var card_textures = [
"res://assets/textures/cards/card_clubs_02.png",
"res://assets/textures/cards/card_clubs_03.png",
"res://assets/textures/cards/card_clubs_04.png",
"res://assets/textures/cards/card_clubs_05.png",
"res://assets/textures/cards/card_clubs_06.png",
"res://assets/textures/cards/card_clubs_07.png",
"res://assets/textures/cards/card_clubs_08.png",
"res://assets/textures/cards/card_clubs_09.png",
"res://assets/textures/cards/card_clubs_10.png",
"res://assets/textures/cards/card_clubs_A.png",
"res://assets/textures/cards/card_clubs_J.png",
"res://assets/textures/cards/card_clubs_K.png",
"res://assets/textures/cards/card_clubs_Q.png",
"res://assets/textures/cards/card_diamonds_02.png",
"res://assets/textures/cards/card_diamonds_03.png",
"res://assets/textures/cards/card_diamonds_04.png",
"res://assets/textures/cards/card_diamonds_05.png",
"res://assets/textures/cards/card_diamonds_06.png",
"res://assets/textures/cards/card_diamonds_07.png",
"res://assets/textures/cards/card_diamonds_08.png",
"res://assets/textures/cards/card_diamonds_09.png",
"res://assets/textures/cards/card_diamonds_10.png",
"res://assets/textures/cards/card_diamonds_A.png",
"res://assets/textures/cards/card_diamonds_J.png",
"res://assets/textures/cards/card_diamonds_K.png",
"res://assets/textures/cards/card_diamonds_Q.png",
"res://assets/textures/cards/card_hearts_02.png",
"res://assets/textures/cards/card_hearts_03.png",
"res://assets/textures/cards/card_hearts_04.png",
"res://assets/textures/cards/card_hearts_05.png",
"res://assets/textures/cards/card_hearts_06.png",
"res://assets/textures/cards/card_hearts_07.png",
"res://assets/textures/cards/card_hearts_08.png",
"res://assets/textures/cards/card_hearts_09.png",
"res://assets/textures/cards/card_hearts_10.png",
"res://assets/textures/cards/card_hearts_A.png",
"res://assets/textures/cards/card_hearts_J.png",
"res://assets/textures/cards/card_hearts_K.png",
"res://assets/textures/cards/card_hearts_Q.png",
"res://assets/textures/cards/card_spades_02.png",
"res://assets/textures/cards/card_spades_03.png",
"res://assets/textures/cards/card_spades_04.png",
"res://assets/textures/cards/card_spades_05.png",
"res://assets/textures/cards/card_spades_06.png",
"res://assets/textures/cards/card_spades_07.png",
"res://assets/textures/cards/card_spades_08.png",
"res://assets/textures/cards/card_spades_09.png",
"res://assets/textures/cards/card_spades_10.png",
"res://assets/textures/cards/card_spades_A.png",
"res://assets/textures/cards/card_spades_J.png",
"res://assets/textures/cards/card_spades_K.png",
"res://assets/textures/cards/card_spades_Q.png",
]

func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_parent().has_method("card_was_clicked"):
			get_parent().card_was_clicked(self)





var suit_offsets = {
	Suit.CLUBS: 0,
	Suit.DIAMONDS: 13,
	Suit.HEARTS: 27,
	Suit.SPADES: 40,
}

func set_card(index: int) -> void:
	if index < 0 or index >= card_textures.size():
		push_error("Niepoprawny indeks karty: %s" % index)
		return

	var texture = load(card_textures[index])
	var mesh_instance = $przod

	var material = mesh_instance.get_active_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, material)

	material.albedo_texture = texture
	material.roughness = 1.0
	material.metallic = 0.0
	material.uv1_scale = Vector3(0.6, 0.9, 1.0)
	material.uv1_offset = Vector3(0.2, 0.05, 0.0)

func set_card_by_value(suit: Suit, value: int) -> void:
	# 2–10, 11=J, 12=Q, 13=K, 14=A
	if value < 2 or value > 14:
		push_error("Niepoprawna wartość karty: %s" % value)
		return

	var offset = suit_offsets[suit]
	var index = offset + (value - 2)
	set_card(index)
