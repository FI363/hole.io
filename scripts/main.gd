class_name MainGame
extends Node3D

## Metropolitan City Hole.io Controller
## Builds a complete 200m x 200m stylized 3D city with 9 urban districts,
## authentic Hole.io physics progression, and over 200 interactive props and vehicles.

@export var collectible_scene: PackedScene = preload("res://scenes/collectible.tscn")

const ReferenceCity = preload("res://scripts/city/reference_map/reference_city.gd")

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

## Builds the authentic low-poly 3D reference city map
func _build_city_map() -> void:
	if not collectibles_container:
		return

	var arena := get_node_or_null("Arena")
	if arena:
		ReferenceCity.build_reference_city(arena, collectibles_container, player_hole)

	score = 0
	total_objects = collectibles_container.get_child_count()

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
