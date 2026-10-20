class_name CameraController
extends Camera3D

@export var target: Node3D = null
@export var offset: Vector3 = Vector3(0.0, 16.0, 12.0)
@export var smooth_speed: float = 7.0
@export var look_target_offset: Vector3 = Vector3(0.0, 0.0, -0.8)

func _ready() -> void:
	if not target:
		_find_target()

	if is_instance_valid(target):
		global_position = target.global_position + offset
		look_at(target.global_position + look_target_offset, Vector3.UP)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		_find_target()
		if not is_instance_valid(target):
			return

	var desired_pos := target.global_position + offset
	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
	look_at(target.global_position + look_target_offset, Vector3.UP)

func _find_target() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0] as Node3D
