class_name MainGame
extends Node3D

## City Hole.io Game Controller
## Manages a modular, highly layered 3D city map with realistic Hole.io scale progression.

@export var collectible_scene: PackedScene = preload("res://scenes/collectible.tscn")

# -------------------------------------------------------------------
# 3D City Model Assets (Kenney CC0)
# -------------------------------------------------------------------

# Tier 1: Micro & Street Props (Traffic cones, trash cans, benches, signs, lights, bikes, nature)
const MODEL_CONE: PackedScene = preload("res://assets/city/models/car-cone.glb")
const MODEL_CONE_ORANGE: PackedScene = preload("res://assets/city/models/prop-construction-cone.glb")
const MODEL_BARRIER: PackedScene = preload("res://assets/city/models/prop-construction-barrier.glb")
const MODEL_FENCE: PackedScene = preload("res://assets/city/models/prop-construction-fence.glb")
const MODEL_DUMPSTER: PackedScene = preload("res://assets/city/models/prop-dumpster.glb")
const MODEL_TRASHCAN: PackedScene = preload("res://assets/city/models/street-trashcan.glb")
const MODEL_BENCH: PackedScene = preload("res://assets/city/models/street-bench.glb")
const MODEL_SIGN_STOP: PackedScene = preload("res://assets/city/models/prop-road-sign-stop.glb")
const MODEL_SIGN_STREET: PackedScene = preload("res://assets/city/models/prop-road-sign-street.glb")
const MODEL_TRAFFIC_LIGHT: PackedScene = preload("res://assets/city/models/prop-traffic-light.glb")
const MODEL_LIGHT_CURVED: PackedScene = preload("res://assets/city/models/prop-light-curved.glb")
const MODEL_ELECTRICITY_POLE: PackedScene = preload("res://assets/city/models/prop-electricity-pole.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")

# Tier 1-2 Nature: Flowers, Bushes & Trees
const MODEL_FLOWER_PURPLE: PackedScene = preload("res://assets/city/models/nature-flower_purpleA.glb")
const MODEL_FLOWER_RED: PackedScene = preload("res://assets/city/models/nature-flower_redA.glb")
const MODEL_BUSH_SMALL: PackedScene = preload("res://assets/city/models/nature-plant_bushSmall.glb")
const MODEL_BUSH: PackedScene = preload("res://assets/city/models/nature-plant_bush.glb")
const MODEL_TREE_OAK: PackedScene = preload("res://assets/city/models/nature-tree_oak.glb")
const MODEL_TREE_PINE: PackedScene = preload("res://assets/city/models/nature-tree_pineDefaultA.glb")
const MODEL_TREE_PALM: PackedScene = preload("res://assets/city/models/nature-tree_palm.glb")
const MODEL_TREE_DEFAULT: PackedScene = preload("res://assets/city/models/nature-tree_default.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_TREES_TALL: PackedScene = preload("res://assets/city/models/grass-trees-tall.glb")

# Tier 2-3: Street Vehicles & Heavy Service Transport
const MODEL_SEDAN: PackedScene = preload("res://assets/city/models/car-sedan.glb")
const MODEL_SEDAN_SPORTS: PackedScene = preload("res://assets/city/models/car-sedan-sports.glb")
const MODEL_TAXI: PackedScene = preload("res://assets/city/models/car-taxi.glb")
const MODEL_POLICE: PackedScene = preload("res://assets/city/models/car-police.glb")
const MODEL_SUV: PackedScene = preload("res://assets/city/models/car-suv.glb")
const MODEL_VAN: PackedScene = preload("res://assets/city/models/car-van.glb")
const MODEL_AMBULANCE: PackedScene = preload("res://assets/city/models/car-ambulance.glb")
const MODEL_FIRETRUCK: PackedScene = preload("res://assets/city/models/car-firetruck.glb")
const MODEL_GARBAGE_TRUCK: PackedScene = preload("res://assets/city/models/car-garbage-truck.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_TRUCK_GREEN: PackedScene = preload("res://assets/city/models/vehicle-truck-green.glb")
const MODEL_TRUCK_YELLOW: PackedScene = preload("res://assets/city/models/vehicle-truck-yellow.glb")
const MODEL_TRUCK_PURPLE: PackedScene = preload("res://assets/city/models/vehicle-truck-purple.glb")

# Tier 3-4: Suburban Houses, Garages & Commercial Mid-Rises
const MODEL_SUBURBAN_A: PackedScene = preload("res://assets/city/models/suburban-building-type-a.glb")
const MODEL_SUBURBAN_B: PackedScene = preload("res://assets/city/models/suburban-building-type-b.glb")
const MODEL_SUBURBAN_E: PackedScene = preload("res://assets/city/models/suburban-building-type-e.glb")
const MODEL_SUBURBAN_H: PackedScene = preload("res://assets/city/models/suburban-building-type-h.glb")
const MODEL_GARAGE: PackedScene = preload("res://assets/city/models/building-garage.glb")
const MODEL_BUILDING_A: PackedScene = preload("res://assets/city/models/building-small-a.glb")
const MODEL_BUILDING_B: PackedScene = preload("res://assets/city/models/building-small-b.glb")
const MODEL_BUILDING_C: PackedScene = preload("res://assets/city/models/building-small-c.glb")
const MODEL_BUILDING_D: PackedScene = preload("res://assets/city/models/building-small-d.glb")
const MODEL_COMM_A: PackedScene = preload("res://assets/city/models/comm-building-a.glb")
const MODEL_COMM_C: PackedScene = preload("res://assets/city/models/comm-building-c.glb")
const MODEL_COMM_F: PackedScene = preload("res://assets/city/models/comm-building-f.glb")
const MODEL_COMM_H: PackedScene = preload("res://assets/city/models/comm-building-h.glb")

# Tier 5: Giant Skyscraper Towers
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/city/models/comm-building-skyscraper-a.glb")
const MODEL_SKYSCRAPER_B: PackedScene = preload("res://assets/city/models/comm-building-skyscraper-b.glb")
const MODEL_SKYSCRAPER_C: PackedScene = preload("res://assets/city/models/comm-building-skyscraper-c.glb")
const MODEL_SKYSCRAPER_D: PackedScene = preload("res://assets/city/models/comm-building-skyscraper-d.glb")

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

	# =============================================================
	# MANDATORY ANCHOR OBJECTS (Indices 0..7 must stay fixed for test suite)
	# =============================================================
	# 0: Plaza fountain
	_spawn_model(MODEL_FOUNTAIN, Vector3(3.2, 0.25, 3.2), 1.0, 0.0, 0.08)
	# 1 & 2: Starter trees
	_spawn_model(MODEL_TREES, Vector3(3.2, 0.5, -3.2), 1.1, 0.0, 0.06)
	_spawn_model(MODEL_TREES, Vector3(-3.2, 0.5, 3.2), 1.1, 0.0, 0.06)
	# 3 & 4: Motorcycles
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-3.0, 0.35, -2.5), 0.85, 0.4, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(3.0, 0.35, -2.5), 0.85, -0.4, 0.05)
	# 5 & 6: Avenue light posts
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, 4.0), 1.0, 0.0, 0.05)
	_spawn_model(MODEL_LIGHTPOSTS, Vector3(0.0, 0.5, -4.0), 1.0, PI, 0.05)
	# 7: Bridging street truck
	_spawn_model(MODEL_TRUCK_RED, Vector3(5.5, 0.65, 0.0), 1.1, PI * 0.5, 0.12)

	# =============================================================
	# TIER 1: MICRO STREET PROPS (Traffic Cones, Manholes, Trash Cans, Benches)
	# =============================================================
	# Manhole covers placed along the road network
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

	# Orange construction cones & barriers (Industrial District edge)
	_spawn_model(MODEL_CONE_ORANGE, Vector3(8.5, 0.0, -8.5), 4.5, 0.0, 0.03)
	_spawn_model(MODEL_CONE_ORANGE, Vector3(9.5, 0.0, -8.5), 4.5, 0.2, 0.03)
	_spawn_model(MODEL_BARRIER, Vector3(11.0, 0.0, -8.5), 3.5, 0.0, 0.05)
	_spawn_model(MODEL_FENCE, Vector3(13.0, 0.0, -8.5), 3.5, 0.0, 0.05)

	# Sidewalk trash cans
	_spawn_model(MODEL_TRASHCAN, Vector3(4.2, 0.0, 1.8), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-4.2, 0.0, 1.8), 2.0, PI, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(4.2, 0.0, -1.8), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-4.2, 0.0, -1.8), 2.0, PI, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(8.5, 0.0, 4.5), 2.0, PI * 0.5, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-8.5, 0.0, -4.5), 2.0, -PI * 0.5, 0.03)

	# Park & street benches
	_spawn_model(MODEL_BENCH, Vector3(2.0, 0.0, 4.8), 2.4, PI, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-2.0, 0.0, 4.8), 2.4, PI, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(2.0, 0.0, -4.8), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-2.0, 0.0, -4.8), 2.4, 0.0, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-7.5, 0.0, 8.5), 2.4, PI * 0.5, 0.04)
	_spawn_model(MODEL_BENCH, Vector3(-7.5, 0.0, 12.5), 2.4, PI * 0.5, 0.04)

	# Street signs & traffic lights
	_spawn_model(MODEL_SIGN_STOP, Vector3(4.5, 0.0, 4.2), 3.6, PI * 0.25, 0.04)
	_spawn_model(MODEL_SIGN_STOP, Vector3(-4.5, 0.0, -4.2), 3.6, -PI * 0.75, 0.04)
	_spawn_model(MODEL_SIGN_STREET, Vector3(4.5, 0.0, -4.2), 3.6, PI * 0.75, 0.04)
	_spawn_model(MODEL_SIGN_STREET, Vector3(-4.5, 0.0, 4.2), 3.6, -PI * 0.25, 0.04)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(4.5, 0.0, 2.2), 4.5, 0.0, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-4.5, 0.0, -2.2), 4.5, PI, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(2.2, 0.0, -4.5), 4.5, PI * 0.5, 0.06)
	_spawn_model(MODEL_TRAFFIC_LIGHT, Vector3(-2.2, 0.0, 4.5), 4.5, -PI * 0.5, 0.06)

	# Additional parked motorcycles / bikes
	_spawn_model(MODEL_MOTORCYCLE, Vector3(1.8, 0.0, -3.8), 0.85, 0.5, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-1.8, 0.0, 3.8), 0.85, -0.5, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(6.5, 0.0, 6.5), 0.85, 0.8, 0.05)
	_spawn_model(MODEL_MOTORCYCLE, Vector3(-6.5, 0.0, -6.5), 0.85, -0.8, 0.05)

	# Flowers & Bushes (positioned around plaza corners without blocking central paths)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(4.8, 0.0, 1.5), 2.2, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-1.5, 0.0, 4.8), 2.2, 0.4, 0.03)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(1.5, 0.0, -4.8), 2.2, -0.3, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-4.8, 0.0, -1.5), 2.2, 0.6, 0.03)
	_spawn_model(MODEL_BUSH_SMALL, Vector3(5.2, 0.0, 3.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_BUSH_SMALL, Vector3(-5.2, 0.0, -3.5), 2.0, 0.5, 0.03)
	_spawn_model(MODEL_BUSH, Vector3(4.0, 0.0, -5.2), 2.0, 0.2, 0.04)
	_spawn_model(MODEL_BUSH, Vector3(-4.0, 0.0, 5.2), 2.0, -0.4, 0.04)

	# =============================================================
	# TIER 2: STREET VEHICLES & SERVICE FLEET
	# =============================================================
	# Compact Cars, Sedans, Taxis, Police Cars
	_spawn_model(MODEL_TAXI, Vector3(0.0, 0.65, 8.5), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_TAXI, Vector3(8.5, 0.65, 0.0), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_POLICE, Vector3(-5.5, 0.65, 0.0), 1.0, -PI * 0.5, 0.10)
	_spawn_model(MODEL_POLICE, Vector3(0.0, 0.65, -8.5), 1.0, PI, 0.10)
	_spawn_model(MODEL_SEDAN, Vector3(7.2, 0.65, 7.2), 1.0, 0.0, 0.10)
	_spawn_model(MODEL_SEDAN, Vector3(-7.2, 0.65, -7.2), 1.0, PI, 0.10)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(11.0, 0.65, -4.5), 1.0, PI * 0.5, 0.10)
	_spawn_model(MODEL_SEDAN_SPORTS, Vector3(-11.0, 0.65, 4.5), 1.0, -PI * 0.5, 0.10)

	# SUVs, Vans, Service Transport
	_spawn_model(MODEL_SUV, Vector3(-13.0, 0.70, -4.5), 1.05, 0.0, 0.12)
	_spawn_model(MODEL_SUV, Vector3(13.0, 0.70, 4.5), 1.05, PI, 0.12)
	_spawn_model(MODEL_VAN, Vector3(4.5, 0.70, -12.0), 1.05, PI * 0.5, 0.12)
	_spawn_model(MODEL_VAN, Vector3(-4.5, 0.70, 12.0), 1.05, -PI * 0.5, 0.12)
	_spawn_model(MODEL_AMBULANCE, Vector3(-15.5, 0.75, 0.0), 1.05, -PI * 0.5, 0.14)
	_spawn_model(MODEL_FIRETRUCK, Vector3(0.0, 0.80, 16.5), 1.1, 0.0, 0.16)
	_spawn_model(MODEL_GARBAGE_TRUCK, Vector3(16.5, 0.80, -12.0), 1.1, PI * 0.5, 0.16)
	_spawn_model(MODEL_TRUCK_YELLOW, Vector3(-10.0, 0.65, -4.5), 1.1, PI, 0.12)
	_spawn_model(MODEL_TRUCK_GREEN, Vector3(10.0, 0.65, -10.5), 1.15, PI * 0.5, 0.12)
	_spawn_model(MODEL_TRUCK_PURPLE, Vector3(7.0, 0.65, 12.5), 1.1, PI * 0.5, 0.12)

	# =============================================================
	# DISTRICT 1: CENTRAL PARK & BOTANICAL GARDENS (South-West)
	# =============================================================
	_spawn_model(MODEL_FOUNTAIN, Vector3(-10.5, 0.25, 10.5), 1.25, 0.0, 0.10)
	_spawn_model(MODEL_TREE_OAK, Vector3(-15.0, 0.0, 8.5), 2.5, 0.3, 0.08)
	_spawn_model(MODEL_TREE_OAK, Vector3(-8.5, 0.0, 15.0), 2.5, -0.4, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-18.0, 0.0, 12.0), 2.6, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-12.0, 0.0, 18.0), 2.6, 0.5, 0.08)
	_spawn_model(MODEL_TREE_PALM, Vector3(-16.0, 0.0, 16.0), 2.7, 0.2, 0.08)
	_spawn_model(MODEL_TREE_DEFAULT, Vector3(-20.0, 0.0, 8.5), 2.5, 0.0, 0.08)
	_spawn_model(MODEL_TREE_DEFAULT, Vector3(-8.5, 0.0, 20.0), 2.5, -0.2, 0.08)
	_spawn_model(MODEL_TREES_TALL, Vector3(-21.0, 0.7, 15.0), 1.3, 0.0, 0.08)
	_spawn_model(MODEL_TREES_TALL, Vector3(-15.0, 0.7, 21.0), 1.3, 0.0, 0.08)
	_spawn_model(MODEL_FLOWER_PURPLE, Vector3(-12.5, 0.0, 10.5), 2.5, 0.0, 0.03)
	_spawn_model(MODEL_FLOWER_RED, Vector3(-10.5, 0.0, 12.5), 2.5, 0.0, 0.03)
	_spawn_model(MODEL_BUSH, Vector3(-14.0, 0.0, 14.0), 2.2, 0.0, 0.04)

	# =============================================================
	# DISTRICT 2: SUBURBAN RESIDENTIAL NEIGHBORHOOD (North-West)
	# =============================================================
	# Cozy houses with gardens, driveways, garages
	_spawn_model(MODEL_SUBURBAN_A, Vector3(-19.0, 0.0, -18.5), 2.6, 0.0, 0.22)
	_spawn_model(MODEL_SUBURBAN_B, Vector3(-10.5, 0.0, -18.5), 2.6, 0.0, 0.25)
	_spawn_model(MODEL_SUBURBAN_E, Vector3(-19.0, 0.0, -10.5), 2.6, PI * 0.5, 0.22)
	_spawn_model(MODEL_SUBURBAN_H, Vector3(-10.5, 0.0, -10.5), 2.6, -PI * 0.5, 0.25)
	_spawn_model(MODEL_GARAGE, Vector3(-22.0, 0.5, -14.0), 1.3, PI * 0.5, 0.15)
	_spawn_model(MODEL_BUILDING_A, Vector3(-14.0, 0.5, -14.0), 1.4, 0.0, 0.18)
	_spawn_model(MODEL_TREE_OAK, Vector3(-15.0, 0.0, -19.0), 2.5, 0.0, 0.08)
	_spawn_model(MODEL_TREE_PINE, Vector3(-22.0, 0.0, -10.5), 2.6, 0.0, 0.08)
	_spawn_model(MODEL_TRASHCAN, Vector3(-17.0, 0.0, -14.5), 2.0, 0.0, 0.03)
	_spawn_model(MODEL_TRASHCAN, Vector3(-12.5, 0.0, -14.5), 2.0, 0.0, 0.03)

	# =============================================================
	# DISTRICT 3: INDUSTRIAL DEPOT & CONSTRUCTION WORKS (North-East)
	# =============================================================
	_spawn_model(MODEL_DUMPSTER, Vector3(14.0, 0.0, -12.5), 3.4, 0.0, 0.08)
	_spawn_model(MODEL_DUMPSTER, Vector3(18.0, 0.0, -12.5), 3.4, 0.3, 0.08)
	_spawn_model(MODEL_GARAGE, Vector3(12.0, 0.5, -19.0), 1.35, 0.0, 0.16)
	_spawn_model(MODEL_GARAGE, Vector3(18.0, 0.5, -19.0), 1.35, 0.0, 0.16)
	_spawn_model(MODEL_BUILDING_D, Vector3(20.0, 0.5, -14.0), 1.45, -PI * 0.5, 0.20)
	_spawn_model(MODEL_BARRIER, Vector3(15.0, 0.0, -16.0), 3.8, PI * 0.5, 0.05)
	_spawn_model(MODEL_FENCE, Vector3(15.0, 0.0, -18.0), 3.8, PI * 0.5, 0.05)
	_spawn_model(MODEL_ELECTRICITY_POLE, Vector3(8.5, 0.0, -19.0), 4.0, 0.0, 0.06)
	_spawn_model(MODEL_ELECTRICITY_POLE, Vector3(21.0, 0.0, -8.5), 4.0, 0.0, 0.06)

	# =============================================================
	# DISTRICT 4: DOWNTOWN COMMERCIAL & SKYSCRAPER FINANCIAL DISTRICT (South-East)
	# =============================================================
	# 2-3 Story Commercial Shops & Mid-Rises
	_spawn_model(MODEL_COMM_A, Vector3(10.5, 0.0, 9.5), 3.2, 0.0, 0.28)
	_spawn_model(MODEL_COMM_C, Vector3(16.0, 0.0, 9.5), 3.2, 0.0, 0.30)
	_spawn_model(MODEL_COMM_F, Vector3(9.5, 0.0, 16.0), 3.2, PI * 0.5, 0.28)
	_spawn_model(MODEL_COMM_H, Vector3(9.5, 0.0, 21.0), 3.2, PI * 0.5, 0.32)
	_spawn_model(MODEL_BUILDING_B, Vector3(15.5, 0.8, 15.5), 1.6, 0.0, 0.25)
	_spawn_model(MODEL_BUILDING_C, Vector3(21.0, 1.2, 15.5), 1.7, 0.0, 0.32)

	# Curved modern streetlights along commercial strip
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(12.5, 0.0, 6.5), 4.2, PI, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(18.5, 0.0, 6.5), 4.2, PI, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(6.5, 0.0, 12.5), 4.2, -PI * 0.5, 0.05)
	_spawn_model(MODEL_LIGHT_CURVED, Vector3(6.5, 0.0, 18.5), 4.2, -PI * 0.5, 0.05)

	# GIANT SKYSCRAPER TOWERS (The ultimate Hole.io trophies!)
	# Skyscraper A (Glass Commercial Tower - Footprint ~4.8m, Height ~10.4m)
	_spawn_model(MODEL_SKYSCRAPER_A, Vector3(17.5, 0.0, 21.5), 3.6, 0.0, 0.55)
	# Skyscraper B (Metropolitan High-Rise - Footprint ~5.0m, Height ~12.0m)
	_spawn_model(MODEL_SKYSCRAPER_B, Vector3(22.5, 0.0, 21.5), 3.6, 0.0, 0.60)
	# Skyscraper C (Corporate Stepped Tower - Footprint ~4.8m, Height ~11.5m)
	_spawn_model(MODEL_SKYSCRAPER_C, Vector3(17.5, 0.0, 26.5), 3.6, 0.0, 0.60)
	# Skyscraper D (Towering Spire Skyscraper - Footprint ~4.8m, Height ~19.5m!)
	_spawn_model(MODEL_SKYSCRAPER_D, Vector3(22.5, 0.0, 26.5), 3.6, 0.0, 0.75)

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
		score_label.text = "City Swallowed: %d / %d  |  Hole Radius: %s" % [score, total_objects, radius_str]

	if controls_label:
		controls_label.text = "WASD / Arrow Keys: Move  •  Press 'R' to Reset"

func _show_victory_banner() -> void:
	if banner_label:
		banner_label.text = "★ THE ENTIRE CITY HAS BEEN CONSUMED! ★\nPress 'R' to Restart"
		banner_label.visible = true
