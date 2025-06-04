extends Node3D
var card_textures = [
"res://assets/textures/cards/0.png",
"res://assets/textures/cards/1.png",
"res://assets/textures/cards/2.png",
"res://assets/textures/cards/3.png",
"res://assets/textures/cards/4.png",
"res://assets/textures/cards/5.png",
"res://assets/textures/cards/6.png",
"res://assets/textures/cards/7.png",
"res://assets/textures/cards/8.png",
"res://assets/textures/cards/9.png",
"res://assets/textures/cards/10.png",
"res://assets/textures/cards/11.png",
"res://assets/textures/cards/12.png",
"res://assets/textures/cards/13.png",
"res://assets/textures/cards/14.png",
"res://assets/textures/cards/15.png",
"res://assets/textures/cards/16.png",
"res://assets/textures/cards/17.png",
"res://assets/textures/cards/18.png",
"res://assets/textures/cards/19.png",
"res://assets/textures/cards/20.png",
"res://assets/textures/cards/21.png",
"res://assets/textures/cards/22.png",
"res://assets/textures/cards/23.png",
"res://assets/textures/cards/24.png",
"res://assets/textures/cards/25.png",
"res://assets/textures/cards/26.png",
"res://assets/textures/cards/27.png",
"res://assets/textures/cards/28.png",
"res://assets/textures/cards/29.png",
"res://assets/textures/cards/30.png",
"res://assets/textures/cards/31.png",
"res://assets/textures/cards/32.png",
"res://assets/textures/cards/33.png",
"res://assets/textures/cards/34.png",
"res://assets/textures/cards/35.png",
"res://assets/textures/cards/36.png",
"res://assets/textures/cards/37.png",
"res://assets/textures/cards/38.png",
"res://assets/textures/cards/39.png",
"res://assets/textures/cards/40.png",
"res://assets/textures/cards/41.png",
"res://assets/textures/cards/42.png",
"res://assets/textures/cards/43.png",
"res://assets/textures/cards/44.png",
"res://assets/textures/cards/45.png",
"res://assets/textures/cards/46.png",
"res://assets/textures/cards/47.png",
"res://assets/textures/cards/48.png",
"res://assets/textures/cards/49.png",
"res://assets/textures/cards/50.png",
"res://assets/textures/cards/51.png"
]


enum Suit { CLUBS, DIAMONDS, HEARTS, SPADES }

var card_id: int = -1 
var is_selected: bool = false

func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_parent().has_method("left_card_was_clicked"):
			get_parent().left_card_was_clicked(self)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent().has_method("right_card_was_clicked"):
			get_parent().right_card_was_clicked(self)




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
