class_name Collectible
extends RigidBody3D

## Pure physics-driven collectible object
## Interacts directly with genuine Godot 3D rigid-body physics.

signal collected(collectible: Collectible)

@export var shape_type: String = "cube"
@export var base_color: Color = Color.WHITE
@export var item_scale: float = 1.4

var is_collected: bool = false

@onready var mesh_instance: MeshInstance3D = get_node_or_null("MeshInstance3D")
@onready var collision_shape: CollisionShape3D = get_node_or_null("CollisionShape3D")

const PALETTE: Array[Color] = [
	Color(0.95, 0.28, 0.28),  # Coral Red
	Color(0.26, 0.70, 0.95),  # Electric Sky
	Color(0.98, 0.75, 0.18),  # Warm Amber
	Color(0.35, 0.85, 0.45),  # Lime Emerald
	Color(0.68, 0.35, 0.92),  # Vivid Violet
	Color(0.98, 0.45, 0.15),  # Sunset Orange
	Color(0.95, 0.35, 0.75),  # Hot Magenta
	Color(0.18, 0.85, 0.82)   # Bright Cyan
]

func _ready() -> void:
	add_to_group("collectibles")

	# Genuine tabletop rigid-body physics settings with snappy arcade gravity
	linear_damp = 0.1
	angular_damp = 1.0
	gravity_scale = 2.2
	can_sleep = true

	var phys_mat := PhysicsMaterial.new()
	phys_mat.friction = 0.55
	phys_mat.bounce = 0.08
	physics_material_override = phys_mat

	_ensure_nodes()
	if shape_type != "custom":
		_apply_mesh_and_shape(shape_type, base_color, item_scale)

func _ensure_nodes() -> void:
	if not mesh_instance:
		mesh_instance = get_node_or_null("MeshInstance3D")
	if not collision_shape:
		collision_shape = get_node_or_null("CollisionShape3D")

func setup_custom(shape: String, color: Color, p_scale: float = 1.0, p_mass: float = -1.0) -> void:
	shape_type = shape
	base_color = color
	item_scale = p_scale
	_ensure_nodes()
	_apply_mesh_and_shape(shape, color, p_scale)
	if p_mass > 0.0:
		mass = p_mass
	else:
		mass = 1.0 * (p_scale * p_scale * p_scale)

## Configures this collectible from a 3D model scene (GLB / GLTF)
func setup_model(model_scene: PackedScene, p_scale: float = 1.0, p_mass: float = -1.0) -> void:
	shape_type = "model"
	item_scale = p_scale
	_ensure_nodes()

	# Clear primitive mesh if any
	if mesh_instance:
		mesh_instance.mesh = null

	var model_inst := model_scene.instantiate() as Node3D
	model_inst.name = "ModelInstance"
	add_child(model_inst)
	model_inst.scale = Vector3.ONE * p_scale

	var combined_aabb := _get_combined_aabb(model_inst)
	var aabb_center := combined_aabb.get_center()

	# Center the visual model at origin so the RigidBody3D origin is the true Center of Mass
	model_inst.position = -aabb_center

	if not collision_shape:
		collision_shape = CollisionShape3D.new()
		collision_shape.name = "CollisionShape3D"
		add_child(collision_shape)

	var b_shape := BoxShape3D.new()
	b_shape.size = combined_aabb.size
	collision_shape.shape = b_shape
	collision_shape.position = Vector3.ZERO

	if p_mass > 0.0:
		mass = p_mass
	else:
		mass = maxf(1.5, combined_aabb.size.x * combined_aabb.size.y * combined_aabb.size.z * 0.7)

func _get_combined_aabb(node: Node3D) -> AABB:
	var total_aabb: AABB = AABB()
	var has_aabb := false

	var meshes: Array[MeshInstance3D] = []
	_find_meshes(node, meshes)

	for mi in meshes:
		if mi.mesh:
			var mi_aabb := mi.mesh.get_aabb()
			var local_tf := mi.transform
			var transformed_aabb := local_tf * mi_aabb
			if not has_aabb:
				total_aabb = transformed_aabb
				has_aabb = true
			else:
				total_aabb = total_aabb.merge(transformed_aabb)

	if not has_aabb:
		total_aabb = AABB(Vector3(-0.5, 0.0, -0.5), Vector3(1.0, 1.0, 1.0))

	# Scale by node's scale
	total_aabb.position *= node.scale
	total_aabb.size *= node.scale
	return total_aabb

func _find_meshes(n: Node, out_meshes: Array[MeshInstance3D]) -> void:
	if n is MeshInstance3D:
		out_meshes.append(n as MeshInstance3D)
	for child in n.get_children():
		_find_meshes(child, out_meshes)

func _apply_mesh_and_shape(shape: String, color: Color, p_scale: float) -> void:
	var chosen_color := color
	if chosen_color == Color.WHITE:
		chosen_color = PALETTE[randi() % PALETTE.size()]

	var mat := StandardMaterial3D.new()
	mat.albedo_color = chosen_color
	mat.roughness = 0.5
	mat.metallic = 0.1

	var mesh: Mesh
	var shape_3d: Shape3D

	match shape:
		"cube":
			var b_mesh := BoxMesh.new()
			b_mesh.size = Vector3.ONE * p_scale
			b_mesh.material = mat
			mesh = b_mesh

			var b_shape := BoxShape3D.new()
			b_shape.size = Vector3.ONE * p_scale
			shape_3d = b_shape

		"sphere":
			var s_mesh := SphereMesh.new()
			s_mesh.radius = 0.5 * p_scale
			s_mesh.height = 1.0 * p_scale
			s_mesh.material = mat
			mesh = s_mesh

			var s_shape := SphereShape3D.new()
			s_shape.radius = 0.5 * p_scale
			shape_3d = s_shape

		"cylinder":
			var c_mesh := CylinderMesh.new()
			c_mesh.top_radius = 0.45 * p_scale
			c_mesh.bottom_radius = 0.45 * p_scale
			c_mesh.height = 1.2 * p_scale
			c_mesh.material = mat
			mesh = c_mesh

			var c_shape := CylinderShape3D.new()
			c_shape.radius = 0.45 * p_scale
			c_shape.height = 1.2 * p_scale
			shape_3d = c_shape

		"prism":
			var p_mesh := PrismMesh.new()
			p_mesh.size = Vector3(1.0, 1.0, 1.0) * p_scale
			p_mesh.material = mat
			mesh = p_mesh

			var p_shape := BoxShape3D.new()
			p_shape.size = Vector3(1.0, 1.0, 1.0) * p_scale
			shape_3d = p_shape

		_:
			var def_mesh := BoxMesh.new()
			def_mesh.size = Vector3.ONE * p_scale
			def_mesh.material = mat
			mesh = def_mesh

			var def_shape := BoxShape3D.new()
			def_shape.size = Vector3.ONE * p_scale
			shape_3d = def_shape

	if mesh_instance:
		mesh_instance.mesh = mesh
	if collision_shape:
		collision_shape.shape = shape_3d

## Collects this object when swallowed into the hole
func collect() -> void:
	if is_collected:
		return
	is_collected = true
	freeze = true
	if collision_shape:
		collision_shape.disabled = true
	collected.emit(self)

	var tween := create_tween()
	var has_visual := false
	for child in get_children():
		if child is Node3D and child != collision_shape:
			has_visual = true
			tween.tween_property(child, "scale", Vector3.ZERO, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	if has_visual:
		tween.tween_callback(queue_free)
	else:
		queue_free()
