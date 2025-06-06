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
]



var card_id: int = -1
var is_selected: bool = false

func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_parent().has_method("left_card_was_clicked"):
			get_parent().left_card_was_clicked(self)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_parent().has_method("right_card_was_clicked"):
			get_parent().right_card_was_clicked(self)

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

func get_power() -> int:
	return int(card_id / 4)
