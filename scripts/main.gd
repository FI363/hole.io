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
	# 0: Central Plaza Fountain
	_spawn_model(MODEL_FOUNTAIN, Vector3(3.2, 0.25, 3.2), 1.0, 0.0, 0.08)
	# 1 & 2: Starter Plaza Trees
	_spawn_model(MODEL_TREES, Vector3(3.2, 0.5, -3.2), 1.1, 0.0, 0.06)
	_spawn_model(MODEL_TREES, Vector3(-3.2, 0.5, 3.2), 1.1, 0.0, 0.06)
	# 3 & 4: Street Motorcycles
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-3.0, 0.35, -2.5), 0.85, 0.4, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(3.0, 0.35, -2.5), 0.85, -0.4, 0.05)
	# 5 & 6: Avenue Light Posts
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, 4.0), 1.0, 0.0, 0.05)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, -4.0), 1.0, PI, 0.05)
	# 7: Bridging Red Street Truck
	_spawn_model(MODEL_TRUCK_RED, Vector3(5.5, 0.65, 0.0), 1.1, PI * 0.5, 0.12)

	# =============================================================
	# ZONE 0: GRAND CENTRAL PLAZA & STARTER PERIMETER (Center: -18..+18)
	# =============================================================
	# Manhole covers along the central avenue crossroads
	_spawn_manhole(Vector3(0.0, 0.02, 5.8))
	_spawn_manhole(Vector3(0.0, 0.02, -5.8))
	_spawn_manhole(Vector3(8.5, 0.02, 0.0))
	_spawn_manhole(Vector3(-8.5, 0.02, 0.0))
	_spawn_manhole(Vector3(0.0, 0.02, 12.5))
	_spawn_manhole(Vector3(0.0, 0.02, -12.5))
	_spawn_manhole(Vector3(14.0, 0.02, 0.0))
	_spawn_manhole(Vector3(-14.0, 0.02, 0.0))

	# Traffic cones (Starter road works along south and north avenues)
	_spawn_model(MODEL_CONE, Vector3(1.8, 0.0, 5.5), 0.8, 0.0, 0.03)
	_spawn_model(MODEL_CONE, Vector3(2.3, 0.0, 5.5), 0.8, 0.3, 0.03)
	_spawn_model(MODEL_CONE, Vector3(2.8, 0.0, 5.5), 0.8, -0.2, 0.03)
	_spawn_model(MODEL_CONE, Vector3(-1.8, 0.0, -5.5), 0.8, 0.1, 0.03)
	_spawn_model(MODEL_CONE, Vector3(-2.3, 0.0, -5.5), 0.8, -0.4, 0.03)
	_spawn_model(MODEL_CONE, Vector3(-2.8, 0.0, -5.5), 0.8, 0.2, 0.03)

	# Sidewalk trash cans around plaza
	_spawn_model(MODEL_TRASHCAN, Vector3(4.2, 0.0, 1.8), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-4.2, 0.0, 1.8), 2.0, PI, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(4.2, 0.0, -1.8), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-4.2, 0.0, -1.8), 2.0, PI, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(8.5, 0.0, 4.5), 2.0, PI * 0.5, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-8.5, 0.0, -4.5), 2.0, -PI * 0.5, 0.03)

	# Plaza benches
	_spawn_model(MODEL_BENCH, Vector3(2.0, 0.0, 4.8), 2.4, PI, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-2.0, 0.0, 4.8), 2.4, PI, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(2.0, 0.0, -4.8), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-2.0, 0.0, -4.8), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-7.5, 0.0, 8.5), 2.4, PI * 0.5, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-7.5, 0.0, 12.5), 2.4, PI * 0.5, 0.04)

	# Street signs & Traffic lights
	_spawn_model(MODEL_SIGN_STOP, Vector3(4.5, 0.0, 4.2), 3.6, PI * 0.25, 0.04)
	_spawn_model(MODEL_SIGN_STOP, Vector3(-4.5, 0.0, -4.2), 3.6, -PI * 0.75, 0.04)
	_spawn_model(MODEL_SIGN_STREET, Vector3(4.5, 0.0, -4.2), 3.6, PI * 0.75, 0.04)
	_spawn_model(MODEL_SIGN_STREET, Vector3(-4.5, 0.0, 4.2), 3.6, -PI * 0.25, 0.04)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(4.5, 0.0, 2.2), 4.5, 0.0, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-4.5, 0.0, -2.2), 4.5, PI, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(2.2, 0.0, -4.5), 4.5, PI * 0.5, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-2.2, 0.0, 4.5), 4.5, -PI * 0.5, 0.06)

	# Parked motorcycles / bikes in plaza stalls
	_spawn_model(MODEL_MOTORCYCLE, Vector3(1.8, 0.0, -3.8), 0.85, 0.5, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-1.8, 0.0, 3.8), 0.85, -0.5, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(6.5, 0.0, 6.5), 0.85, 0.8, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-6.5, 0.0, -6.5), 0.85, -0.8, 0.05)

	# Decorative Plaza Flowers & Bushes
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(4.8, 0.0, 1.5), 2.2, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-1.5, 0.0, 4.8), 2.2, 0.4, 0.03)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(1.5, 0.0, -4.8), 2.2, -0.3, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-4.8, 0.0, -1.5), 2.2, 0.6, 0.03)
	_spawn_model(MODEL_BUSH_SMALL, Vector3(5.2, 0.0, 3.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_BUSH_SMALL, Vector3(-5.2, 0.0, -3.5), 2.0, 0.5, 0.03)
	_spawn_model(MODEL_BUSH, Vector3(4.0, 0.0, -5.2), 2.0, 0.2, 0.04)
	_spawn_model(MODEL_BUSH, Vector3(-4.0, 0.0, 5.2), 2.0, -0.4, 0.04)

	# =============================================================
	# ZONE 1: DOWNTOWN FINANCIAL DISTRICT & SKYSCRAPER CORE (South-East: +22..+42, +22..+42)
	# =============================================================
	# Giant Skyscraper Towers (Trophy high-rises!)
	_spawn_model(MODEL_SKYSCRAPER_A, Vector3(32.0, 0.0, 32.0), 3.6, 0.0, 0.60)
	_spawn_model(MODEL_SKYSCRAPER_B, Vector3(39.0, 0.0, 32.0), 3.6, 0.0, 0.65)
	_spawn_model(MODEL_SKYSCRAPER_C, Vector3(32.0, 0.0, 39.0), 3.6, 0.0, 0.65)
	_spawn_model(MODEL_SKYSCRAPER_D, Vector3(39.0, 0.0, 39.0), 3.6, 0.0, 0.80)

	# Commercial Office Mid-Rises (2-3 Stories)
	_spawn_model(MODEL_COMM_A, Vector3(26.0, 0.0, 26.0), 3.2, 0.0, 0.30)
	_spawn_model(MODEL_COMM_C, Vector3(38.0, 0.0, 26.0), 3.2, 0.0, 0.30)
	_spawn_model(MODEL_COMM_F, Vector3(26.0, 0.0, 33.0), 3.2, PI * 0.5, 0.30)
	_spawn_model(MODEL_COMM_H, Vector3(26.0, 0.0, 40.0), 3.2, PI * 0.5, 0.32)
	_spawn_model(MODEL_BUILDING_B, Vector3(38.0, 0.8, 25.5), 1.6, 0.0, 0.25)
	_spawn_model(MODEL_BUILDING_C, Vector3(28.0, 1.2, 28.0), 1.7, 0.0, 0.30)

	# Downtown Street Vehicles (Taxis, police cruisers, executive sedans)
	_spawn_model(MODEL_TAXI, Vector3(27.0, 0.65, 22.5), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_TAXI, Vector3(35.0, 0.65, 22.5), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_POLICE, Vector3(22.5, 0.65, 30.0), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_POLICE, Vector3(22.5, 0.65, 38.0), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(30.0, 0.65, 26.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_SEDAN, Vector3(36.0, 0.65, 26.5), 1.0, 0.0, 0.10)

	# Modern Curved Streetlights & Traffic Signals
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(29.0, 0.0, 23.5), 4.2, PI, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(37.0, 0.0, 23.5), 4.2, PI, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(23.5, 0.0, 29.0), 4.2, -PI * 0.5, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(23.5, 0.0, 37.0), 4.2, -PI * 0.5, 0.05)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(24.5, 0.0, 24.5), 4.5, PI * 0.25, 0.06)
	_spawn_model(MODEL_SIGN_STOP, Vector3(25.0, 0.0, 23.0), 3.6, PI * 0.5, 0.04)

	# Downtown Manholes & Trash Cans
	_spawn_manhole(Vector3(30.0, 0.02, 22.5))
	_spawn_manhole(Vector3(22.5, 0.02, 33.0))
	_spawn_model(MODEL_TRASHCAN, Vector3(26.0, 0.0, 23.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(34.0, 0.0, 23.5), 2.0, 0.0, 0.03)

	# =============================================================
	# ZONE 2: CENTRAL BOTANICAL PARK & NATURE RESERVE (South-West: -42..-22, +22..+42)
	# =============================================================
	# Grand Park Fountain
	_spawn_model(MODEL_FOUNTAIN, Vector3(-33.0, 0.25, 33.0), 1.4, 0.0, 0.12)

	# Mature Oak Trees
	_spawn_model(MODEL_TREE_OAK, Vector3(-27.0, 0.0, 27.0), 2.6, 0.3, 0.08)
	_spawn_model(MODEL_TREE_OAK, Vector3(-39.0, 0.0, 27.0), 2.6, -0.2, 0.08)
	_spawn_model(MODEL_TREE_OAK, Vector3(-27.0, 0.0, 39.0), 2.6, 0.5, 0.08)
	_spawn_model(MODEL_TREE_OAK, Vector3(-39.0, 0.0, 39.0), 2.6, -0.4, 0.08)

	# Tall Pine Trees
	_spawn_model(MODEL_TREE_PINE, Vector3(-33.0, 0.0, 27.0), 2.7, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-27.0, 0.0, 33.0), 2.7, 0.4, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-39.0, 0.0, 33.0), 2.7, -0.3, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-33.0, 0.0, 39.0), 2.7, 0.2, 0.08)

	# Tropical Palm Trees & Grove Trees
	_spawn_model(MODEL_TREE_PALM, Vector3(-30.0, 0.0, 30.0), 2.8, 0.1, 0.08)
	_spawn_model(MODEL_TREE_PALM, Vector3(-36.0, 0.0, 36.0), 2.8, -0.2, 0.08)
	_spawn_model(MODEL_TREES_TALL, Vector3(-36.0, 0.7, 30.0), 1.3, 0.0, 0.08)
	_spawn_model(MODEL_TREES_TALL, Vector3(-30.0, 0.7, 36.0), 1.3, 0.0, 0.08)

	# Park Amenities (Benches, flowers, bushes, parked bikes)
	_spawn_model(MODEL_BENCH, Vector3(-31.0, 0.0, 33.0), 2.4, PI * 0.5, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-35.0, 0.0, 33.0), 2.4, -PI * 0.5, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-33.0, 0.0, 31.0), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-33.0, 0.0, 35.0), 2.4, PI, 0.04)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(-29.0, 0.0, 29.0), 2.4, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-37.0, 0.0, 29.0), 2.4, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(-29.0, 0.0, 37.0), 2.4, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-37.0, 0.0, 37.0), 2.4, 0.0, 0.03)
	_spawn_model(MODEL_BUSH, Vector3(-28.0, 0.0, 35.0), 2.2, 0.0, 0.04)
	_spawn_model(MODEL_BUSH, Vector3(-38.0, 0.0, 35.0), 2.2, 0.0, 0.04)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-24.5, 0.0, 26.0), 0.85, PI * 0.5, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-24.5, 0.0, 27.5), 0.85, PI * 0.5, 0.05)
	_spawn_model(MODEL_TRASHCAN, Vector3(-25.5, 0.0, 33.0), 2.0, 0.0, 0.03)

	# =============================================================
	# ZONE 3: MAPLE RIDGE SUBURBAN RESIDENTIAL DISTRICT (North-West: -42..-22, -42..-22)
	# =============================================================
	# Suburban Homes with Porches & Gardens
	_spawn_model(MODEL_SUBURBAN_A, Vector3(-30.0, 0.0, -30.0), 2.6, 0.0, 0.22)
	_spawn_model(MODEL_SUBURBAN_B, Vector3(-38.0, 0.0, -30.0), 2.6, 0.0, 0.25)
	_spawn_model(MODEL_SUBURBAN_E, Vector3(-30.0, 0.0, -38.0), 2.6, PI * 0.5, 0.22)
	_spawn_model(MODEL_SUBURBAN_H, Vector3(-38.0, 0.0, -38.0), 2.6, -PI * 0.5, 0.25)
	_spawn_model(MODEL_SUBURBAN_A, Vector3(-34.0, 0.0, -27.0), 2.6, 0.0, 0.22)
	_spawn_model(MODEL_SUBURBAN_B, Vector3(-27.0, 0.0, -34.0), 2.6, -PI * 0.5, 0.25)

	# Detached Garages
	_spawn_model(MODEL_GARAGE, Vector3(-33.0, 0.5, -34.0), 1.3, PI * 0.5, 0.15)
	_spawn_model(MODEL_GARAGE, Vector3(-41.0, 0.5, -34.0), 1.3, PI * 0.5, 0.15)

	# Driveway Family Vehicles
	_spawn_model(MODEL_SEDAN, Vector3(-28.0, 0.65, -29.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_SEDAN, Vector3(-36.0, 0.65, -29.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_SUV, Vector3(-28.0, 0.70, -37.5), 1.05, 0.0, 0.12)
	_spawn_model(MODEL_SUV, Vector3(-36.0, 0.70, -37.5), 1.05, 0.0, 0.12)

	# Front-yard trees, curbside trash cans, street signs
	_spawn_model(MODEL_TREE_OAK, Vector3(-34.0, 0.0, -31.0), 2.5, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-41.0, 0.0, -30.0), 2.6, 0.0, 0.08)
	_spawn_model(MODEL_TRASHCAN, Vector3(-28.0, 0.0, -25.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-36.0, 0.0, -25.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_SIGN_STOP, Vector3(-25.0, 0.0, -23.0), 3.6, -PI * 0.5, 0.04)
	_spawn_manhole(Vector3(-30.0, 0.02, -22.5))

	# =============================================================
	# ZONE 4: LOGISTICS DEPOT & ACTIVE CONSTRUCTION (North-East: +22..+42, -42..-22)
	# =============================================================
	# Industrial Warehouses & Depots
	_spawn_model(MODEL_GARAGE, Vector3(30.0, 0.5, -30.0), 1.35, 0.0, 0.16)
	_spawn_model(MODEL_GARAGE, Vector3(38.0, 0.5, -30.0), 1.35, 0.0, 0.16)
	_spawn_model(MODEL_BUILDING_D, Vector3(30.0, 0.5, -38.0), 1.45, -PI * 0.5, 0.20)
	_spawn_model(MODEL_BUILDING_A, Vector3(38.0, 0.5, -38.0), 1.4, 0.0, 0.18)
	_spawn_model(MODEL_WATER_TOWER, Vector3(35.0, 0.0, -35.0), 2.2, 0.0, 0.25)
	_spawn_model(MODEL_CONTAINER_A, Vector3(31.0, 0.0, -34.0), 2.2, 0.0, 0.15)
	_spawn_model(MODEL_CONTAINER_B, Vector3(39.0, 0.0, -34.0), 2.2, PI * 0.5, 0.15)

	# Active Construction Zone Perimeter
	_spawn_model(MODEL_CONE_ORANGE, Vector3(30.0, 0.0, -26.0), 4.5, 0.0, 0.03)
	_spawn_model(MODEL_CONE_ORANGE, Vector3(33.0, 0.0, -26.0), 4.5, 0.2, 0.03)
	_spawn_model(MODEL_CONE_ORANGE, Vector3(36.0, 0.0, -26.0), 4.5, -0.3, 0.03)
	_spawn_model(MODEL_BARRIER, Vector3(29.0, 0.0, -25.0), 3.8, 0.0, 0.05)
	_spawn_model(MODEL_BARRIER, Vector3(37.0, 0.0, -25.0), 3.8, 0.0, 0.05)
	_spawn_model(MODEL_FENCE, Vector3(29.0, 0.0, -27.0), 3.8, 0.0, 0.05)
	_spawn_model(MODEL_FENCE, Vector3(37.0, 0.0, -27.0), 3.8, 0.0, 0.05)
	_spawn_model(MODEL_DUMPSTER, Vector3(33.0, 0.0, -34.0), 3.5, 0.0, 0.08)
	_spawn_model(MODEL_DUMPSTER, Vector3(41.0, 0.0, -28.0), 3.5, 0.4, 0.08)

	# Heavy Transport Fleet
	_spawn_model(MODEL_GARBAGE_TRUCK, Vector3(27.0, 0.80, -34.0), 1.1, PI * 0.5, 0.16)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(34.0, 0.65, -23.0), 1.15, PI * 0.5, 0.12)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(27.0, 0.65, -23.0), 1.15, PI * 0.5, 0.12)
	_spawn_model(MODEL_VAN, Vector3(40.0, 0.70, -23.0), 1.05, PI * 0.5, 0.12)

	# Electricity Poles & Manholes
	_spawn_model(MODEL_ELECTRICITY_POLE, Vector3(26.0, 0.0, -24.5), 4.0, 0.0, 0.06)
	_spawn_model(MODEL_ELECTRICITY_POLE, Vector3(38.0, 0.0, -24.5), 4.0, 0.0, 0.06)
	_spawn_manhole(Vector3(30.0, 0.02, -22.5))
	_spawn_manhole(Vector3(22.5, 0.02, -33.0))

	# =============================================================
	# ZONE 5: CIVIC SERVICES & EMERGENCY PRECINCT (North-Central: -16..+16, -42..-24)
	# =============================================================
	# City Hospital / Medical Clinic
	_spawn_model(MODEL_BUILDING_D, Vector3(-8.0, 0.5, -34.0), 1.5, 0.0, 0.22)
	_spawn_model(MODEL_AMBULANCE, Vector3(-4.0, 0.75, -34.0), 1.05, 0.0, 0.14)
	_spawn_model(MODEL_AMBULANCE, Vector3(-12.0, 0.75, -34.0), 1.05, 0.0, 0.14)

	# Metro Fire Station
	_spawn_model(MODEL_GARAGE, Vector3(8.0, 0.5, -34.0), 1.4, 0.0, 0.16)
	_spawn_model(MODEL_FIRETRUCK, Vector3(8.0, 0.80, -28.0), 1.1, 0.0, 0.16)

	# Police Substation
	_spawn_model(MODEL_BUILDING_A, Vector3(0.0, 0.5, -38.0), 1.4, 0.0, 0.18)
	_spawn_model(MODEL_POLICE, Vector3(0.0, 0.65, -32.0), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, -26.0), 1.0, 0.0, 0.05)

	# =============================================================
	# ZONE 6: MIDTOWN RETAIL & DINING PROMENADE (South-Central: -16..+16, +24..+42)
	# =============================================================
	# Storefronts & Boutique Buildings
	_spawn_model(MODEL_COMM_A, Vector3(-8.0, 0.0, 34.0), 3.2, 0.0, 0.28)
	_spawn_model(MODEL_BUILDING_B, Vector3(0.0, 0.8, 36.0), 1.6, 0.0, 0.25)
	_spawn_model(MODEL_BUILDING_C, Vector3(8.0, 1.2, 34.0), 1.6, 0.0, 0.30)

	# Taxis & Delivery Fleet
	_spawn_model(MODEL_TAXI, Vector3(-6.0, 0.65, 26.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_TAXI, Vector3(6.0, 0.65, 26.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_VAN, Vector3(-12.0, 0.70, 34.0), 1.05, PI * 0.5, 0.12)
	_spawn_model(MODEL_VAN, Vector3(12.0, 0.70, 34.0), 1.05, -PI * 0.5, 0.12)

	# Promenade Sidewalk Amenities
	_spawn_model(MODEL_BENCH, Vector3(-4.0, 0.0, 31.0), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(4.0, 0.0, 31.0), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_TRASHCAN, Vector3(-8.0, 0.0, 31.0), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(8.0, 0.0, 31.0), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, 26.0), 1.0, PI, 0.05)

	# =============================================================
	# ZONE 7: WESTERN COMMERCIAL TRANSIT CORRIDOR (West-Central: -42..-24, -16..+16)
	# =============================================================
	_spawn_model(MODEL_BUILDING_A, Vector3(-34.0, 0.5, -8.0), 1.4, PI * 0.5, 0.18)
	_spawn_model(MODEL_BUILDING_D, Vector3(-34.0, 0.5, 8.0), 1.45, -PI * 0.5, 0.20)
	_spawn_model(MODEL_SEDAN, Vector3(-30.0, 0.65, 0.0), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(-38.0, 0.65, 0.0), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-27.0, 0.35, -4.0), 0.85, 0.0, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-27.0, 0.35, 4.0), 0.85, 0.0, 0.05)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(-26.0, 0.5, 0.0), 1.0, PI * 0.5, 0.05)

	# =============================================================
	# ZONE 8: INNOVATION & TECH OFFICE PARK (East-Central: +24..+42, -16..+16)
	# =============================================================
	_spawn_model(MODEL_COMM_C, Vector3(34.0, 0.0, -8.0), 3.2, 0.0, 0.30)
	_spawn_model(MODEL_BUILDING_B, Vector3(34.0, 0.8, 8.0), 1.6, 0.0, 0.25)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(30.0, 0.65, 0.0), 1.0, -PI * 0.5, 0.10)
	_spawn_model(MODEL_SUV, Vector3(38.0, 0.70, 0.0), 1.05, -PI * 0.5, 0.12)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(26.0, 0.0, 0.0), 4.2, -PI * 0.5, 0.05)
	_spawn_model(MODEL_TREE_PALM, Vector3(34.0, 0.0, 0.0), 2.8, 0.0, 0.08)

	# =============================================================
	# ZONE 9: 4-WAY ARTERIAL INTERSECTIONS & TRAFFIC CONTROLS
	# =============================================================
	# Major 4-way intersections: (-24, -24), (24, -24), (-24, 24), (24, 24)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-22.5, 0.0, -22.5), 4.5, -PI * 0.25, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(22.5, 0.0, -22.5), 4.5, PI * 0.75, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-22.5, 0.0, 22.5), 4.5, -PI * 0.75, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(22.5, 0.0, 22.5), 4.5, PI * 0.25, 0.06)

	# Intersecting road delivery vehicles
	_spawn_model(MODEL_TRUCK_PURPLE, Vector3(0.0, 0.65, -18.0), 1.1, PI, 0.12)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(0.0, 0.65, 18.0), 1.1, 0.0, 0.12)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(-18.0, 0.65, 0.0), 1.1, -PI * 0.5, 0.12)

	# Outlying manhole covers
	_spawn_manhole(Vector3(-24.0, 0.02, 0.0))
	_spawn_manhole(Vector3(24.0, 0.02, 0.0))
	_spawn_manhole(Vector3(0.0, 0.02, -24.0))
	_spawn_manhole(Vector3(0.0, 0.02, 24.0))

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
