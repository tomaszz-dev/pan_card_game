extends Node3D

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
"res://assets/textures/cards/card_empty.png",
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

	
func _ready():
	var texture = load(card_textures[2])  # poprawna ścieżka do PNG

	# Stwórz materiał
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.roughness = 1.0  # żeby nie odbijało światła jak lustro
	material.metallic = 0.0
	
	# Ustaw materiał na powierzchnię 0
	var mesh_instance = $przod
	mesh_instance.set_surface_override_material(0, material)
	
	material.uv1_scale = Vector3(0.6, 0.9, 1.0)
	material.uv1_offset = Vector3(0.2, 0.05, 0.0)
