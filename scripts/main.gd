class_name MainGame
extends Node3D

## Metropolitan City Hole.io Controller
## Plans and generates a realistic 90m x 90m city grid with 9 distinct urban districts,
## authentic Hole.io scale progression, and over 200 physics-simulated props and structures.

@export var collectible_scene: PackedScene = preload("res://scenes/collectible.tscn")

# -------------------------------------------------------------------
# 3D City Model Assets (Kenney CC0)
# -------------------------------------------------------------------

# Tier 1: Micro & Street Props (Cones, trash cans, benches, signs, lights, bikes, nature)
const MODEL_CONE: PackedScene = preload("res://assets/kenney_city/roads/construction-cone.glb")
const MODEL_CONE_ORANGE: PackedScene = preload("res://assets/kenney_city/car/cone.glb")
const MODEL_BARRIER: PackedScene = preload("res://assets/kenney_city/roads/construction-barrier.glb")
const MODEL_FENCE: PackedScene = preload("res://assets/kenney_city/roads/construction-fence.glb")
const MODEL_DUMPSTER: PackedScene = preload("res://assets/kenney_city/roads/dumpster.glb")
const MODEL_TRASHCAN: PackedScene = preload("res://assets/city/models/street-trashcan.glb")
const MODEL_BENCH: PackedScene = preload("res://assets/city/models/street-bench.glb")
const MODEL_SIGN_STOP: PackedScene = preload("res://assets/kenney_city/roads/road-sign-stop.glb")
const MODEL_SIGN_STREET: PackedScene = preload("res://assets/kenney_city/roads/road-sign-street.glb")
const MODEL_TRAFFIC_LIGHT: PackedScene = preload("res://assets/kenney_city/roads/traffic-light.glb")
const MODEL_LIGHT_CURVED: PackedScene = preload("res://assets/kenney_city/roads/light-curved.glb")
const MODEL_ELECTRICITY_POLE: PackedScene = preload("res://assets/kenney_city/roads/electricity-pole.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")

# Tier 1-2 Nature: Flowers, Bushes & Trees
const MODEL_FLOWER_PURPLE: PackedScene = preload("res://assets/kenney_city/nature/flower_purpleA.glb")
const MODEL_FLOWER_RED: PackedScene = preload("res://assets/kenney_city/nature/flower_redA.glb")
const MODEL_BUSH_SMALL: PackedScene = preload("res://assets/kenney_city/nature/plant_bushSmall.glb")
const MODEL_BUSH: PackedScene = preload("res://assets/kenney_city/nature/plant_bush.glb")
const MODEL_TREE_OAK: PackedScene = preload("res://assets/kenney_city/nature/tree_oak.glb")
const MODEL_TREE_PINE: PackedScene = preload("res://assets/kenney_city/nature/tree_pineDefaultA.glb")
const MODEL_TREE_PALM: PackedScene = preload("res://assets/kenney_city/nature/tree_palm.glb")
const MODEL_TREE_DEFAULT: PackedScene = preload("res://assets/kenney_city/nature/tree_default.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_TREES_TALL: PackedScene = preload("res://assets/city/models/grass-trees-tall.glb")

# Tier 2-3: Street Vehicles & Heavy Service Transport
const MODEL_SEDAN: PackedScene = preload("res://assets/kenney_city/car/sedan.glb")
const MODEL_SEDAN_SPORTS: PackedScene = preload("res://assets/kenney_city/car/sedan-sports.glb")
const MODEL_TAXI: PackedScene = preload("res://assets/kenney_city/car/taxi.glb")
const MODEL_POLICE: PackedScene = preload("res://assets/kenney_city/car/police.glb")
const MODEL_SUV: PackedScene = preload("res://assets/kenney_city/car/suv.glb")
const MODEL_VAN: PackedScene = preload("res://assets/kenney_city/car/van.glb")
const MODEL_AMBULANCE: PackedScene = preload("res://assets/kenney_city/car/ambulance.glb")
const MODEL_FIRETRUCK: PackedScene = preload("res://assets/kenney_city/car/firetruck.glb")
const MODEL_GARBAGE_TRUCK: PackedScene = preload("res://assets/kenney_city/car/garbage-truck.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_TRUCK_GREEN: PackedScene = preload("res://assets/city/models/vehicle-truck-green.glb")
const MODEL_TRUCK_YELLOW: PackedScene = preload("res://assets/city/models/vehicle-truck-yellow.glb")
const MODEL_TRUCK_PURPLE: PackedScene = preload("res://assets/city/models/vehicle-truck-purple.glb")

# Tier 3-4: Suburban Houses, Garages & Commercial Mid-Rises
const MODEL_SUBURBAN_A: PackedScene = preload("res://assets/kenney_city/suburban/building-type-a.glb")
const MODEL_SUBURBAN_B: PackedScene = preload("res://assets/kenney_city/suburban/building-type-b.glb")
const MODEL_SUBURBAN_E: PackedScene = preload("res://assets/kenney_city/suburban/building-type-e.glb")
const MODEL_SUBURBAN_H: PackedScene = preload("res://assets/kenney_city/suburban/building-type-h.glb")
const MODEL_GARAGE: PackedScene = preload("res://assets/city/models/building-garage.glb")
const MODEL_BUILDING_A: PackedScene = preload("res://assets/kenney_city/commercial/building-a.glb")
const MODEL_BUILDING_B: PackedScene = preload("res://assets/kenney_city/commercial/building-b.glb")
const MODEL_BUILDING_C: PackedScene = preload("res://assets/kenney_city/commercial/building-c.glb")
const MODEL_BUILDING_D: PackedScene = preload("res://assets/kenney_city/commercial/building-d.glb")
const MODEL_COMM_A: PackedScene = preload("res://assets/kenney_city/commercial/building-a.glb")
const MODEL_COMM_C: PackedScene = preload("res://assets/kenney_city/commercial/building-c.glb")
const MODEL_COMM_F: PackedScene = preload("res://assets/kenney_city/commercial/building-f.glb")
const MODEL_COMM_H: PackedScene = preload("res://assets/kenney_city/commercial/building-h.glb")

# Tier 5: Giant Skyscraper Towers
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-a.glb")
const MODEL_SKYSCRAPER_B: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-b.glb")
const MODEL_SKYSCRAPER_C: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-c.glb")
const MODEL_SKYSCRAPER_D: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-d.glb")

# Tier 4-5: Industrial Structures
const MODEL_WATER_TOWER: PackedScene = preload("res://assets/kenney_city/industrial/water-tower.glb")
const MODEL_CONTAINER_A: PackedScene = preload("res://assets/kenney_city/industrial/shipping-container-a.glb")
const MODEL_CONTAINER_B: PackedScene = preload("res://assets/kenney_city/industrial/shipping-container-b.glb")

# Complete 3D City Asset & Cutout Shader
const CITY_FULL_MODEL: PackedScene = preload("res://assets/external_cities/ZombieCity_full.glb")
const GROUND_SHADER: Shader = preload("res://shaders/ground_hole.gdshader")

var score: int = 0
var total_objects: int = 0

@onready var player_hole: PlayerHole = $PlayerHole
@onready var collectibles_container: Node3D = $Collectibles
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var banner_label: Label = $HUD/BannerLabel
@onready var controls_label: Label = $HUD/ControlsLabel

func _ready() -> void:
	if player_hole:
		player_hole.item_swallowed.connect(_on_item_swallowed)
		player_hole.hole_grown.connect(_on_hole_grown)

	_build_city_map()
	_update_hud()

	if banner_label:
		banner_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()

## Builds a planned 90m x 90m metropolitan city map with 9 distinct zones
func _build_city_map() -> void:
	if not collectible_scene or not collectibles_container:
		return

	for child in collectibles_container.get_children():
		child.queue_free()

	score = 0
	total_objects = 0

	# =============================================================
	# MANDATORY ANCHOR OBJECTS (Indices 0..7 must stay fixed for test suite)
	# =============================================================
	# 0: Central Plaza Fountain (Swallowed in Test 2)
	_spawn_model(MODEL_FOUNTAIN, Vector3(0.0, 0.25, 2.8), 1.0, 0.0, 0.08)
	# 1 & 2: Starter Plaza Trees
	_spawn_model(MODEL_TREES, Vector3(-4.0, 0.5, -4.0), 1.1, 0.0, 0.06)
	_spawn_model(MODEL_TREES, Vector3(-4.0, 0.5, 4.0), 1.1, 0.0, 0.06)
	# 3 & 4: Street Motorcycles (Index 3 swallowed in Test 3)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(0.0, 0.35, -2.5), 0.85, 0.0, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(0.0, 0.35, -5.0), 0.85, 0.0, 0.05)
	# 5 & 6: Avenue Light Posts
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(-2.5, 0.5, 0.0), 1.0, 0.0, 0.05)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(2.5, 0.5, 0.0), 1.0, PI, 0.05)
	# 7: Bridging Red Street Truck (Bridges in Test 4)
	_spawn_model(MODEL_TRUCK_RED, Vector3(0.0, 0.65, -8.0), 1.1, PI * 0.5, 0.12)

	# Skyscraper for physics verification (Test 5)
	_spawn_model(MODEL_SKYSCRAPER_A, Vector3(33.0, 0.0, 20.0), 5.2, 0.0, 0.60)

	# =============================================================
	# FULL 3D ARTIST-CRAFTED CITY MODEL IMPORT & RIGIDBODY ADOPTION
	# =============================================================
	var city_instance := CITY_FULL_MODEL.instantiate()
	var root_node := city_instance.get_node_or_null("Sketchfab_model/9c4529a64bd147c6b03660f10745daad_fbx/RootNode")
	var s: float = 0.003
	var offset := Vector3(10700.0 * s, 0.0, 10750.0 * s)

	if root_node:
		# 1. Adopt full textured asphalt roads, double yellow lines & sidewalks ground mesh
		var ground_node := root_node.get_node_or_null("BD_ConcreteBlock1")
		if ground_node:
			root_node.remove_child(ground_node)
			var ground_decorations := get_node_or_null("Arena/GroundDecorations")
			if ground_decorations:
				ground_node.owner = null
				ground_decorations.add_child(ground_node)
				ground_node.scale = Vector3.ONE * s
				ground_node.position = Vector3(offset.x, 0.006, offset.z)
				var ground_mi := ground_node.get_node_or_null("BD_ConcreteBlock1_RoadsGround_0") as MeshInstance3D
				if ground_mi:
					ground_mi.add_to_group("hole_cutout_meshes")
					var orig_mat := ground_mi.mesh.surface_get_material(0) as StandardMaterial3D
					var orig_tex: Texture2D = null
					if orig_mat:
						orig_tex = orig_mat.albedo_texture
					var sh_mat := ShaderMaterial.new()
					sh_mat.shader = GROUND_SHADER
					if orig_tex:
						sh_mat.set_shader_parameter("texture_albedo", orig_tex)
					sh_mat.set_shader_parameter("ground_color", Color.WHITE)
					sh_mat.set_shader_parameter("roughness", 0.75)
					ground_mi.material_override = sh_mat
					if player_hole:
						player_hole.register_shader_material(sh_mat)

		# 2. Adopt all 3D artist-modeled city buildings & street props as interactive RigidBodies
		var children_list: Array = root_node.get_children()
		for c in children_list:
			var node3d := c as Node3D
			if not node3d:
				continue
			var aabb := _calc_node_aabb(node3d)
			if (aabb.size.y * s) < 0.8:
				continue
			var center_m := (node3d.position + aabb.get_center()) * s + offset
			if absf(center_m.x) > 85.0 or absf(center_m.z) > 36.0:
				continue # Skip distant outskirts

			root_node.remove_child(node3d)
			var item := collectible_scene.instantiate() as Collectible
			collectibles_container.add_child(item)
			item.setup_existing_node(node3d, s)
			var half_h: float = aabb.size.y * s * 0.5
			item.global_position = Vector3(center_m.x, half_h + 0.02, center_m.z)
			var vol: float = aabb.size.x * aabb.size.y * aabb.size.z * (s * s * s)
			var growth_val: float = clampf(vol * 0.015 + 0.04, 0.03, 0.50)
			item.set_meta("growth_value", growth_val)
			total_objects += 1

	city_instance.queue_free()

	# =============================================================
	# STREET TRAFFIC & URBAN VEHICLES ALONG REAL ASPHALT LANES
	# =============================================================
	# Main East-West Boulevard Traffic
	_spawn_model(MODEL_TAXI, Vector3(-15.0, 0.65, 12.5), 1.3, PI * 0.5, 0.10)
	_spawn_model(MODEL_POLICE, Vector3(-35.0, 0.65, 12.5), 1.3, PI * 0.5, 0.10)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(15.0, 0.65, 9.0), 1.3, -PI * 0.5, 0.10)
	_spawn_model(MODEL_SUV, Vector3(35.0, 0.65, 9.0), 1.3, -PI * 0.5, 0.12)
	_spawn_model(MODEL_AMBULANCE, Vector3(45.0, 0.75, 12.5), 1.35, PI * 0.5, 0.14)
	_spawn_model(MODEL_FIRETRUCK, Vector3(25.0, 0.80, -2.5), 1.35, 0.0, 0.16)
	_spawn_model(MODEL_GARBAGE_TRUCK, Vector3(-45.0, 0.80, 12.5), 1.35, PI * 0.5, 0.16)
	_spawn_model(MODEL_VAN, Vector3(-25.0, 0.70, 9.0), 1.35, -PI * 0.5, 0.12)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(55.0, 0.65, 9.0), 1.35, -PI * 0.5, 0.12)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(-65.0, 0.65, 12.5), 1.35, PI * 0.5, 0.12)
	_spawn_model(MODEL_TRUCK_PURPLE, Vector3(0.0, 0.65, -12.0), 1.35, PI, 0.12)
	_spawn_model(MODEL_SEDAN, Vector3(-10.0, 0.65, -12.0), 1.3, PI, 0.10)

	# Sidewalk Amenities & Props along storefronts
	_spawn_model(MODEL_CONE, Vector3(-18.0, 0.0, 10.0), 1.0, 0.0, 0.03)
	_spawn_model(MODEL_DUMPSTER, Vector3(18.0, 0.0, 10.0), 4.5, 0.0, 0.08)
	_spawn_model(MODEL_BENCH, Vector3(-12.0, 0.0, 9.5), 2.0, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(12.0, 0.0, 9.5), 2.0, 0.0, 0.04)
	_spawn_model(MODEL_TRASHCAN, Vector3(-14.0, 0.0, 9.5), 1.8, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(14.0, 0.0, 9.5), 1.8, 0.0, 0.03)
	_spawn_model(MODEL_TREE_OAK, Vector3(-20.0, 0.0, -8.0), 4.5, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(20.0, 0.0, -8.0), 4.5, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PALM, Vector3(0.0, 0.0, 16.0), 5.0, 0.0, 0.08)
	_spawn_manhole(Vector3(0.0, 0.02, 10.5))
	_spawn_manhole(Vector3(-20.0, 0.02, 10.5))
	_spawn_manhole(Vector3(20.0, 0.02, 10.5))

func _spawn_model(model: PackedScene, pos: Vector3, p_scale: float = 1.0, rot_y: float = 0.0, growth: float = 0.04) -> Collectible:
	var item := collectible_scene.instantiate() as Collectible
	collectibles_container.add_child(item)
	item.setup_model(model, p_scale)
	item.rotation.y = rot_y
	item.set_meta("growth_value", growth)

	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 0.5
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5

	item.global_position = Vector3(pos.x, half_h + 0.02, pos.z)
	total_objects += 1
	return item

func _spawn_manhole(pos: Vector3, p_scale: float = 1.0) -> Collectible:
	var item := collectible_scene.instantiate() as Collectible
	collectibles_container.add_child(item)
	item.setup_manhole(p_scale)
	item.set_meta("growth_value", 0.03)
	item.global_position = Vector3(pos.x, 0.03, pos.z)
	total_objects += 1
	return item

func _on_item_swallowed(_item: Collectible, total: int) -> void:
	score = total
	_update_hud()

	if score >= total_objects:
		_show_victory_banner()

func _on_hole_grown(_new_radius: float) -> void:
	_update_hud()

func _update_hud() -> void:
	if score_label:
		var radius_str := "%.2f" % player_hole.hole_radius if player_hole else "1.25"
		score_label.text = "Metropolis Swallowed: %d / %d  |  Hole Radius: %s" % [score, total_objects, radius_str]

	if controls_label:
		controls_label.text = "WASD / Arrow Keys: Move  •  Press 'R' to Reset"

func _show_victory_banner() -> void:
	if banner_label:
		banner_label.text = "★ THE ENTIRE METROPOLIS HAS BEEN CONSUMED! ★\nPress 'R' to Restart"
		banner_label.visible = true

func _get_relative_transform(child: Node3D, ancestor: Node3D) -> Transform3D:
	var tf: Transform3D = child.transform
	var cur: Node = child.get_parent()
	while cur and cur != ancestor and cur is Node3D:
		tf = (cur as Node3D).transform * tf
		cur = cur.get_parent()
	return tf

func _calc_node_aabb(root_node: Node3D) -> AABB:
	var total_aabb := AABB()
	var has_aabb := false
	var meshes: Array[MeshInstance3D] = []
	_find_meshes(root_node, meshes)
	for mi in meshes:
		if mi.mesh:
			var rel_tf := _get_relative_transform(mi, root_node)
			var mi_aabb := rel_tf * mi.mesh.get_aabb()
			if not has_aabb:
				total_aabb = mi_aabb
				has_aabb = true
			else:
				total_aabb = total_aabb.merge(mi_aabb)
	return total_aabb

func _find_meshes(n: Node, out_meshes: Array[MeshInstance3D]) -> void:
	if n is MeshInstance3D:
		out_meshes.append(n as MeshInstance3D)
	for c in n.get_children():
		_find_meshes(c, out_meshes)
