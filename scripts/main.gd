class_name MainGame
extends Node3D

## Metropolitan City Hole.io Controller
## Builds a complete 200m x 200m stylized 3D city with 9 urban districts,
## authentic Hole.io physics progression, and over 200 interactive props and vehicles.

@export var collectible_scene: PackedScene = preload("res://scenes/collectible.tscn")

const RoadNetwork = preload("res://scripts/city/road_network.gd")
const BuildingGenerator = preload("res://scripts/city/building_generator.gd")
const PropFactory = preload("res://scripts/city/prop_factory.gd")
const CityValidation = preload("res://scripts/city/city_validation.gd")

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

## Builds the authentic 200m x 200m stylized Hole.io 3D city
func _build_city_map() -> void:
	if not collectibles_container:
		return

	# 1. Clean existing children
	for child in collectibles_container.get_children():
		child.queue_free()

	var ground_decorations := get_node_or_null("Arena/GroundDecorations")
	if ground_decorations:
		for child in ground_decorations.get_children():
			child.queue_free()

	var arena := get_node_or_null("Arena")
	if arena:
		var existing_buildings := arena.get_node_or_null("CityBuildings")
		if existing_buildings:
			existing_buildings.queue_free()

	score = 0
	total_objects = 0

	# 2. Build 200x200 Road and Sidewalk Network
	if ground_decorations:
		var road_net := RoadNetwork.new()
		road_net.build_network(ground_decorations, player_hole)

	# 3. Build All 9 City Blocks with 3D Buildings
	if arena:
		BuildingGenerator.build_all_buildings(arena)

	# 4. Populate Vehicle Fleets, Street Furniture, Trees, Urban Props & Anchors
	PropFactory.populate_city(collectibles_container, player_hole)
	total_objects = collectibles_container.get_child_count()

	# 5. Run Integrity Validation
	CityValidation.validate_city(self)

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
