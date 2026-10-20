class_name MainGame
extends Node3D

## City Hole.io Game Controller
## Manages a modular 3D city map with vehicles, buildings, trees, and street props.

@export var collectible_scene: PackedScene = preload("res://scenes/collectible.tscn")

# 3D City Model Assets (Kenney CC0)
const MODEL_BUILDING_A: PackedScene = preload("res://assets/city/models/building-small-a.glb")
const MODEL_BUILDING_B: PackedScene = preload("res://assets/city/models/building-small-b.glb")
const MODEL_BUILDING_C: PackedScene = preload("res://assets/city/models/building-small-c.glb")
const MODEL_BUILDING_D: PackedScene = preload("res://assets/city/models/building-small-d.glb")
const MODEL_GARAGE: PackedScene = preload("res://assets/city/models/building-garage.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_TREES_TALL: PackedScene = preload("res://assets/city/models/grass-trees-tall.glb")
const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_TRUCK_GREEN: PackedScene = preload("res://assets/city/models/vehicle-truck-green.glb")
const MODEL_TRUCK_YELLOW: PackedScene = preload("res://assets/city/models/vehicle-truck-yellow.glb")
const MODEL_TRUCK_PURPLE: PackedScene = preload("res://assets/city/models/vehicle-truck-purple.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")

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

## Builds a multi-district city map with layered tiers of swallowable items
func _build_city_map() -> void:
	if not collectible_scene or not collectibles_container:
		return

	for child in collectibles_container.get_children():
		child.queue_free()

	score = 0
	total_objects = 0

	# -------------------------------------------------------------
	# 1. CENTRAL PLAZA & BOULEVARD (Near starting position)
	# -------------------------------------------------------------
	# Starter items around the player hole (small trees, light posts, motorcycles, fountains)
	_spawn_model(MODEL_FOUNTAIN, Vector3(3.2, 0.25, 3.2), 1.0, 0.0)
	_spawn_model(MODEL_TREES, Vector3(3.2, 0.5, -3.2), 1.1, 0.0)
	_spawn_model(MODEL_TREES, Vector3(-3.2, 0.5, 3.2), 1.1, 0.0)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-3.0, 0.35, -2.5), 0.85, 0.4)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(3.0, 0.35, -2.5), 0.85, -0.4)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, 4.0), 1.0, 0.0)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, -4.0), 1.0, PI)

	# -------------------------------------------------------------
	# 2. STREET VEHICLES (Parked along Main Roads)
	# -------------------------------------------------------------
	_spawn_model(MODEL_TRUCK_RED, Vector3(5.5, 0.65, 0.0), 1.1, PI * 0.5)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(-5.5, 0.65, 0.0), 1.1, -PI * 0.5)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(0.0, 0.65, 7.5), 1.1, 0.0)
	_spawn_model(MODEL_TRUCK_PURPLE, Vector3(0.0, 0.65, -7.5), 1.1, PI)

	# Additional vehicles parked on side streets
	_spawn_model(MODEL_TRUCK_RED, Vector3(-10.0, 0.65, 4.5), 1.1, 0.0)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(10.0, 0.65, -4.5), 1.1, PI)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(6.5, 0.35, 6.5), 1.1, 0.8)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-6.5, 0.35, -6.5), 1.1, -0.8)

	# -------------------------------------------------------------
	# 3. RESIDENTIAL DISTRICT (North-West Block)
	# -------------------------------------------------------------
	_spawn_model(MODEL_BUILDING_A, Vector3(-13.5, 0.5, -13.5), 1.4, 0.0)
	_spawn_model(MODEL_BUILDING_D, Vector3(-7.0, 0.5, -13.5), 1.4, 0.0)
	_spawn_model(MODEL_GARAGE, Vector3(-13.5, 0.5, -7.5), 1.2, PI * 0.5)
	_spawn_model(MODEL_TREES, Vector3(-9.5, 0.5, -9.5), 1.2, 0.0)
	_spawn_model(MODEL_TREES_TALL, Vector3(-15.5, 0.7, -10.5), 1.2, 0.0)

	# -------------------------------------------------------------
	# 4. INDUSTRIAL & WAREHOUSE DISTRICT (North-East Block)
	# -------------------------------------------------------------
	_spawn_model(MODEL_GARAGE, Vector3(7.5, 0.5, -13.5), 1.3, 0.0)
	_spawn_model(MODEL_GARAGE, Vector3(13.5, 0.5, -13.5), 1.3, 0.0)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(10.5, 0.65, -10.5), 1.15, PI * 0.5)
	_spawn_model(MODEL_BUILDING_D, Vector3(14.0, 0.5, -7.5), 1.4, -PI * 0.5)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(6.0, 0.5, -10.0), 1.0, 0.0)

	# -------------------------------------------------------------
	# 5. DOWNTOWN COMMERCIAL DISTRICT (South-East Block)
	# -------------------------------------------------------------
	# Office buildings & tall skyscrapers (requires large hole radius!)
	_spawn_model(MODEL_BUILDING_B, Vector3(7.5, 0.8, 7.5), 1.5, 0.0)
	_spawn_model(MODEL_BUILDING_B, Vector3(13.5, 0.8, 7.5), 1.5, 0.0)
	_spawn_model(MODEL_BUILDING_C, Vector3(10.5, 1.2, 13.5), 1.6, 0.0) # Tall skyscraper
	_spawn_model(MODEL_TRUCK_PURPLE, Vector3(7.0, 0.65, 12.5), 1.1, PI * 0.5)
	_spawn_model(MODEL_TREES, Vector3(14.0, 0.5, 12.5), 1.1, 0.0)

	# -------------------------------------------------------------
	# 6. CITY PARK & RECREATION DISTRICT (South-West Block)
	# -------------------------------------------------------------
	_spawn_model(MODEL_FOUNTAIN, Vector3(-10.5, 0.25, 10.5), 1.2, 0.0)
	_spawn_model(MODEL_TREES_TALL, Vector3(-14.0, 0.7, 7.5), 1.3, 0.0)
	_spawn_model(MODEL_TREES_TALL, Vector3(-7.5, 0.7, 14.0), 1.3, 0.0)
	_spawn_model(MODEL_TREES, Vector3(-14.0, 0.5, 14.0), 1.2, 0.0)
	_spawn_model(MODEL_TREES, Vector3(-7.5, 0.5, 7.5), 1.1, 0.0)
	_spawn_model(MODEL_BUILDING_A, Vector3(-14.0, 0.5, 3.5), 1.35, PI * 0.5)

	# -------------------------------------------------------------
	# 7. MIDTOWN AVENUE PROPS & RESIDENCES
	# -------------------------------------------------------------
	_spawn_model(MODEL_BUILDING_A, Vector3(14.0, 0.5, 0.0), 1.4, -PI * 0.5)
	_spawn_model(MODEL_BUILDING_D, Vector3(-14.0, 0.5, 0.0), 1.4, PI * 0.5)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(10.0, 0.5, 0.0), 1.0, PI * 0.5)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(-10.0, 0.5, 0.0), 1.0, -PI * 0.5)

func _spawn_model(model: PackedScene, pos: Vector3, p_scale: float = 1.0, rot_y: float = 0.0) -> Collectible:
	var item := collectible_scene.instantiate() as Collectible
	collectibles_container.add_child(item)
	item.setup_model(model, p_scale)
	item.rotation.y = rot_y

	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 0.5
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5

	item.global_position = Vector3(pos.x, half_h + 0.03, pos.z)
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
		score_label.text = "City Swallowed: %d / %d  |  Hole Radius: %s" % [score, total_objects, radius_str]

	if controls_label:
		controls_label.text = "WASD / Arrow Keys: Move  •  Press 'R' to Reset"

func _show_victory_banner() -> void:
	if banner_label:
		banner_label.text = "★ THE ENTIRE CITY HAS BEEN CONSUMED! ★\nPress 'R' to Restart"
		banner_label.visible = true
