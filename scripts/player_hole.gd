class_name PlayerHole
extends Node3D

## Pure physics-driven Hole.io player entity
## Directly drives a physical CSG subtraction aperture in the ground.

signal item_swallowed(collectible: Collectible, total_swallowed: int)
signal hole_grown(new_radius: float)

@export var speed: float = 10.0
@export var acceleration: float = 16.0
@export var friction: float = 14.0
@export var arena_boundary_limit: float = 18.0

@export var hole_radius: float = 1.25
@export var growth_per_item: float = 0.04
@export var max_hole_radius: float = 4.0
@export var growth_speed: float = 2.5

@export var hole_cutout_path: NodePath = NodePath("../Arena/Ground/HoleCutout")

var swallowed_count: int = 0
var current_velocity: Vector3 = Vector3.ZERO
var target_radius: float = 1.25

var _hole_cutout: CSGCylinder3D = null

@onready var visuals: Node3D = $Visuals
@onready var wake_area: Area3D = $WakeArea
@onready var swallow_area: Area3D = $SwallowArea

func _ready() -> void:
	add_to_group("player")
	target_radius = hole_radius

	_find_hole_cutout()
	_sync_hole_geometry()

	if swallow_area:
		swallow_area.body_entered.connect(_on_swallow_area_body_entered)

func _find_hole_cutout() -> void:
	if not hole_cutout_path.is_empty():
		_hole_cutout = get_node_or_null(hole_cutout_path) as CSGCylinder3D
	if not _hole_cutout:
		_hole_cutout = get_tree().root.find_child("HoleCutout", true, false) as CSGCylinder3D

func _physics_process(delta: float) -> void:
	# 1. Process movement
	var move_dir := _get_input_vector()
	if move_dir != Vector3.ZERO:
		current_velocity = current_velocity.lerp(move_dir * speed, acceleration * delta)
	else:
		current_velocity = current_velocity.lerp(Vector3.ZERO, friction * delta)

	global_position += current_velocity * delta
	global_position.y = 0.0

	global_position.x = clampf(global_position.x, -arena_boundary_limit, arena_boundary_limit)
	global_position.z = clampf(global_position.z, -arena_boundary_limit, arena_boundary_limit)

	# 2. Process smooth growth interpolation
	if absf(hole_radius - target_radius) > 0.001:
		hole_radius = move_toward(hole_radius, target_radius, growth_speed * delta)
		_sync_visuals_and_areas()
		hole_grown.emit(hole_radius)

	# 3. Synchronize CSG physical hole aperture in real time
	_sync_hole_geometry()

	# 4. Wake up nearby sleeping bodies so they respond to ground aperture
	_wake_nearby_bodies()

func _sync_hole_geometry() -> void:
	if not _hole_cutout:
		_find_hole_cutout()

	if _hole_cutout:
		_hole_cutout.position.x = global_position.x
		_hole_cutout.position.z = global_position.z
		_hole_cutout.position.y = -2.0
		_hole_cutout.radius = hole_radius

func _wake_nearby_bodies() -> void:
	if not wake_area:
		return

	for body in wake_area.get_overlapping_bodies():
		var rb := body as RigidBody3D
		if rb and rb.sleeping:
			rb.sleeping = false

func _sync_visuals_and_areas() -> void:
	var scale_factor: float = hole_radius / 1.25

	if visuals:
		visuals.scale = Vector3(scale_factor, 1.0, scale_factor)

	if wake_area:
		var col_shape := wake_area.get_node_or_null("CollisionShape3D") as CollisionShape3D
		if col_shape and col_shape.shape is CylinderShape3D:
			col_shape.shape.radius = hole_radius + 1.2

	if swallow_area:
		var col_shape := swallow_area.get_node_or_null("CollisionShape3D") as CollisionShape3D
		if col_shape and col_shape.shape is CylinderShape3D:
			col_shape.shape.radius = hole_radius * 0.95

func grow_hole(amount: float) -> void:
	target_radius = minf(target_radius + amount, max_hole_radius)

func _on_swallow_area_body_entered(body: Node3D) -> void:
	var col := body as Collectible
	if col and not col.is_collected:
		swallowed_count += 1
		col.collect()
		grow_hole(growth_per_item)
		_trigger_gulp_animation()
		item_swallowed.emit(col, swallowed_count)

func _get_input_vector() -> Vector3:
	var dir := Vector3.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or Input.is_action_pressed("ui_left"):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) or Input.is_action_pressed("ui_right"):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or Input.is_action_pressed("ui_up"):
		dir.z -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) or Input.is_action_pressed("ui_down"):
		dir.z += 1.0

	if dir.length_squared() > 1.0:
		dir = dir.normalized()
	return dir

func _trigger_gulp_animation() -> void:
	if not visuals:
		return
	var base_scale := visuals.scale
	var tween := create_tween()
	tween.tween_property(visuals, "scale", base_scale * Vector3(1.15, 0.90, 1.15), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(visuals, "scale", base_scale, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
