class_name CameraController
extends Camera3D

@export var target: Node3D = null
@export var base_offset: Vector3 = Vector3(0.0, 16.0, 13.0)
@export var smooth_speed: float = 7.0
@export var look_target_offset: Vector3 = Vector3(0.0, 0.0, -0.8)

func _ready() -> void:
	if not target:
		_find_target()

	if is_instance_valid(target):
		global_position = target.global_position + base_offset
		look_at(target.global_position + look_target_offset, Vector3.UP)

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		_find_target()
		if not is_instance_valid(target):
			return

	var current_offset := base_offset
	var hole := target as PlayerHole
	if hole:
		var growth_ratio: float = clampf(hole.hole_radius / 1.25, 1.0, 6.0)
		current_offset = base_offset * (0.75 + 0.3 * growth_ratio)

	var desired_pos := target.global_position + current_offset
	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
	look_at(target.global_position + look_target_offset, Vector3.UP)

func _find_target() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0] as Node3D
