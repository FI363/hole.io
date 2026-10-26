class_name PropFactory
extends RefCounted

const CityMaterials = preload("res://scripts/city/city_materials.gd")

## Factory for creating Hole.io-style vehicles, street furniture, vegetation, and urban props
## Follows Sections 10, 11, 12, 13, and 21 specifications

# Preload anchor assets for 100% test suite compatibility
const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-a.glb")

const COLLECTIBLE_SCENE: PackedScene = preload("res://scenes/collectible.tscn")

static func populate_city(collectibles_root: Node3D, player_hole: PlayerHole) -> void:
	# Set deterministic seed per Section 21
	seed(3632026)

	# -------------------------------------------------------------
	# 1. MANDATORY ANCHOR OBJECTS (Indices 0..7 and Skyscraper for test runner)
	# -------------------------------------------------------------
	# 0: Central Plaza Fountain (Swallowed in Test 2)
	_spawn_model(collectibles_root, MODEL_FOUNTAIN, Vector3(0.0, 0.25, 2.8), 1.0, 0.0, 0.08)
	# 1 & 2: Starter Plaza Trees
	_spawn_model(collectibles_root, MODEL_TREES, Vector3(-4.0, 0.5, -4.0), 1.1, 0.0, 0.06)
	_spawn_model(collectibles_root, MODEL_TREES, Vector3(-4.0, 0.5, 4.0), 1.1, 0.0, 0.06)
	# 3 & 4: Street Motorcycles (Index 3 swallowed in Test 3)
	_spawn_model(collectibles_root, MODEL_MOTORCYCLE, Vector3(0.0, 0.35, -2.5), 0.85, 0.0, 0.05)
	_spawn_model(collectibles_root, MODEL_MOTORCYCLE, Vector3(0.0, 0.35, -5.0), 0.85, 0.0, 0.05)
	# 5 & 6: Avenue Light Posts
	_spawn_model(collectibles_root, MODEL_LIGHTPOSTS, Vector3(-2.5, 0.5, 0.0), 1.0, 0.0, 0.05)
	_spawn_model(collectibles_root, MODEL_LIGHTPOSTS, Vector3(2.5, 0.5, 0.0), 1.0, PI, 0.05)
	# 7: Bridging Red Street Truck (Bridges at r=1.25, swallowed at r=1.80 in Test 4)
	_spawn_model(collectibles_root, MODEL_TRUCK_RED, Vector3(0.0, 0.65, -8.0), 1.1, PI * 0.5, 0.12)
	# 8: Skyscraper for physics verification (Test 5: BoxShape3D.size.y > 6.0)
	_spawn_model(collectibles_root, MODEL_SKYSCRAPER_A, Vector3(33.0, 0.0, 20.0), 5.2, 0.0, 0.60)

	# -------------------------------------------------------------
	# 2. VEHICLE FLEET (Section 10)
	# -------------------------------------------------------------
	_populate_vehicles(collectibles_root)

	# -------------------------------------------------------------
	# 3. URBAN PROPS, STREET FURNITURE & VEGETATION BY DISTRICT (Sections 8, 11, 12, 13)
	# -------------------------------------------------------------
	_populate_block_a(collectibles_root)
	_populate_block_b(collectibles_root)
	_populate_block_c(collectibles_root)
	_populate_block_d(collectibles_root)
	_populate_block_e(collectibles_root)
	_populate_block_f(collectibles_root)
	_populate_block_g(collectibles_root)
	_populate_block_h_park(collectibles_root)
	_populate_block_i(collectibles_root)

	# -------------------------------------------------------------
	# 4. AVENUE STREETLIGHTS & PERIMETER URBAN DETAILS
	# -------------------------------------------------------------
	_populate_avenue_infrastructure(collectibles_root)

# -----------------------------------------------------------------
# VEHICLE GENERATION & PARKING (Section 10)
# -----------------------------------------------------------------
static func _populate_vehicles(root: Node3D) -> void:
	# Block C Supermarket Parking Lot (X: 34, Z: -55): 4 parked cars
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[0]), Vector3(25.0, 0.75, -55.0), 0.0)
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[1]), Vector3(29.0, 0.75, -55.0), 0.0)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[3]), Vector3(33.0, 0.90, -55.0), 0.0)
	_spawn_procedural(root, build_hatchback(CityMaterials.VEHICLE_COLORS[6]), Vector3(37.0, 0.75, -55.0), 0.0)

	# Block G Service Station & Parking (X: -57, Z: 45): 6 cars + 1 delivery van
	_spawn_procedural(root, build_delivery_van(Color(0.92, 0.92, 0.92)), Vector3(-62.0, 1.20, 42.0), 0.0)
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[4]), Vector3(-58.0, 0.75, 42.0), 0.0)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[2]), Vector3(-54.0, 0.75, 42.0), 0.0)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[5]), Vector3(-50.0, 0.90, 42.0), 0.0)
	_spawn_procedural(root, build_hatchback(CityMaterials.VEHICLE_COLORS[7]), Vector3(-62.0, 0.75, 48.0), PI)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[0]), Vector3(-58.0, 0.75, 48.0), PI)
	_spawn_procedural(root, build_taxi(), Vector3(-54.0, 0.75, 48.0), PI)

	# Block I Southeast Commercial Parking (X: 34, Z: 40): 4 parked cars
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[2]), Vector3(28.0, 0.75, 40.0), 0.0)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[1]), Vector3(32.0, 0.75, 40.0), 0.0)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[4]), Vector3(36.0, 0.90, 40.0), 0.0)
	_spawn_procedural(root, build_hatchback(CityMaterials.VEHICLE_COLORS[0]), Vector3(40.0, 0.75, 40.0), 0.0)

	# On-Street Parallel Parking along Major Avenues (Curb parking, clear of travel lanes)
	# Western Avenue (X = -40, parked at X = -35.2 or -44.8)
	_spawn_procedural(root, build_taxi(), Vector3(-35.2, 0.75, -70.0), 0.0)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[5]), Vector3(-35.2, 0.75, -62.0), 0.0)
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[0]), Vector3(-44.8, 0.75, -28.0), PI)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[7]), Vector3(-44.8, 0.90, -18.0), PI)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[6]), Vector3(-35.2, 0.75, 22.0), 0.0)
	_spawn_procedural(root, build_delivery_van(Color(0.2, 0.35, 0.6)), Vector3(-44.8, 1.20, 32.0), PI)

	# Eastern Avenue (X = 10, parked at X = 4.8 or 15.2)
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[3]), Vector3(4.8, 0.75, -70.0), PI)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[2]), Vector3(15.2, 0.75, -60.0), 0.0)
	_spawn_procedural(root, build_taxi(), Vector3(4.8, 0.75, -28.0), PI)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[1]), Vector3(15.2, 0.90, -18.0), 0.0)
	_spawn_procedural(root, build_hatchback(CityMaterials.VEHICLE_COLORS[4]), Vector3(4.8, 0.75, 22.0), PI)
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[0]), Vector3(15.2, 0.75, 30.0), 0.0)

	# Northern Avenue (Z = -40) & Southern Avenue (Z = 10) curb parking
	_spawn_procedural(root, build_compact_car(CityMaterials.VEHICLE_COLORS[5]), Vector3(-68.0, 0.75, -35.2), PI * 0.5)
	_spawn_procedural(root, build_sedan(CityMaterials.VEHICLE_COLORS[7]), Vector3(30.0, 0.75, -35.2), PI * 0.5)
	_spawn_procedural(root, build_suv(CityMaterials.VEHICLE_COLORS[3]), Vector3(-68.0, 0.90, 4.8), -PI * 0.5)
	_spawn_procedural(root, build_hatchback(CityMaterials.VEHICLE_COLORS[1]), Vector3(30.0, 0.75, 4.8), -PI * 0.5)

# -----------------------------------------------------------------
# DISTRICT PROPS POPULATION (Section 8 & 11)
# -----------------------------------------------------------------
static func _populate_block_a(root: Node3D) -> void:
	# Northwest Residential: 3 trees, 2 benches, 2 bins, 4 shrubs, 3 streetlights, mailbox
	_spawn_procedural(root, build_tree_rounded(0), Vector3(-80.0, 1.8, -80.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(1), Vector3(-50.0, 1.8, -80.0), 0.5)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(-80.0, 2.2, -50.0), 0.0)

	_spawn_procedural(root, build_bench(), Vector3(-67.0, 0.45, -82.5), 0.0)
	_spawn_procedural(root, build_bench(), Vector3(-82.5, 0.45, -67.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(-65.0, 0.45, -82.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-82.5, 0.45, -65.0), PI * 0.5)

	_spawn_procedural(root, build_mailbox(), Vector3(-73.0, 0.55, -66.5), 0.0) # A1 front
	_spawn_procedural(root, build_shrub(), Vector3(-76.0, 0.45, -66.5), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-71.0, 0.45, -66.5), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-62.0, 0.45, -67.5), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-58.0, 0.45, -67.5), 0.0)

	_spawn_procedural(root, build_streetlight(), Vector3(-82.5, 2.4, -75.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(-60.0, 2.4, -82.5), 0.0)
	_spawn_procedural(root, build_streetlight(), Vector3(-47.5, 2.4, -60.0), -PI * 0.5)

static func _populate_block_b(root: Node3D) -> void:
	# Northern Mixed Residential: 3 trees, 4 shrubs, 2 benches, 2 bins
	_spawn_procedural(root, build_tree_rounded(2), Vector3(-30.0, 1.8, -80.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(0), Vector3(0.0, 1.8, -80.0), 0.8)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(-17.0, 2.2, -65.0), 0.0)

	_spawn_procedural(root, build_bench(), Vector3(-18.0, 0.45, -82.5), 0.0)
	_spawn_procedural(root, build_bench(), Vector3(-32.5, 0.45, -65.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(-16.0, 0.45, -82.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-32.5, 0.45, -63.0), PI * 0.5)

	_spawn_procedural(root, build_shrub(), Vector3(-20.0, 0.45, -65.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-14.0, 0.45, -65.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-27.0, 0.45, -51.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-7.0, 0.45, -51.0), 0.0)

	_spawn_procedural(root, build_streetlight(), Vector3(-32.5, 2.4, -75.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(2.5, 2.4, -75.0), -PI * 0.5)

static func _populate_block_c(root: Node3D) -> void:
	# Northeast Commercial: Supermarket + Cafe + Market
	# Shopping carts, bollards, trees, bins, streetlights, cafe tables & chairs
	_spawn_procedural(root, build_shopping_cart(), Vector3(31.0, 0.50, -62.5), 0.0)
	_spawn_procedural(root, build_shopping_cart(), Vector3(32.5, 0.50, -62.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(28.0, 0.40, -62.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(34.0, 0.40, -62.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(40.0, 0.40, -62.5), 0.0)

	# Cafe outdoor tables and chairs at C2 Cafe (X: 22, Z: -54)
	_spawn_procedural(root, build_cafe_table(), Vector3(20.0, 0.38, -49.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(19.2, 0.40, -49.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(20.8, 0.40, -49.0), -PI * 0.5)
	_spawn_procedural(root, build_cafe_table(), Vector3(24.0, 0.38, -49.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(23.2, 0.40, -49.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(24.8, 0.40, -49.0), -PI * 0.5)

	# Perimeter trees & furniture
	_spawn_procedural(root, build_tree_rounded(1), Vector3(18.0, 1.8, -80.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(0), Vector3(50.0, 1.8, -80.0), 0.3)
	_spawn_procedural(root, build_tree_rounded(2), Vector3(50.0, 1.8, -50.0), 0.6)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(18.0, 2.2, -50.0), 0.0)

	_spawn_procedural(root, build_bin(), Vector3(21.0, 0.45, -47.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(44.0, 0.45, -47.5), 0.0)
	_spawn_procedural(root, build_streetlight(), Vector3(17.5, 2.4, -65.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(52.5, 2.4, -65.0), -PI * 0.5)

static func _populate_block_d(root: Node3D) -> void:
	# Western Mixed-Use: Office, Pizza Restaurant, House, Shop
	# Outdoor tables & chairs at Pizza D2 (-57, -22)
	_spawn_procedural(root, build_cafe_table(), Vector3(-59.0, 0.38, -16.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-59.8, 0.40, -16.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-58.2, 0.40, -16.0), -PI * 0.5)
	_spawn_procedural(root, build_cafe_table(), Vector3(-55.0, 0.38, -16.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-55.8, 0.40, -16.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-54.2, 0.40, -16.0), -PI * 0.5)
	_spawn_procedural(root, build_cafe_table(), Vector3(-57.0, 0.38, -14.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-57.8, 0.40, -14.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-56.2, 0.40, -14.0), -PI * 0.5)
	_spawn_procedural(root, build_utility_box(), Vector3(-53.0, 0.50, -16.5), 0.0)

	_spawn_procedural(root, build_tree_rounded(0), Vector3(-80.0, 1.8, -30.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(1), Vector3(-80.0, 1.8, 0.0), 0.4)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(-65.0, 2.2, -12.0), 0.0)

	_spawn_procedural(root, build_shrub(), Vector3(-74.0, 0.45, 2.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-71.0, 0.45, 2.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-77.0, 0.45, -16.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(-69.0, 0.45, -16.0), 0.0)

	_spawn_procedural(root, build_bench(), Vector3(-82.5, 0.45, -15.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(-65.0, 0.45, 2.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-82.5, 0.45, -13.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(-63.0, 0.45, 2.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-53.0, 0.45, 2.5), 0.0)

	_spawn_procedural(root, build_streetlight(), Vector3(-82.5, 2.4, -15.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(-47.5, 2.4, -15.0), -PI * 0.5)

static func _populate_block_e(root: Node3D) -> void:
	# Central Plaza around (0, 0): keep (0, 0) open for player hole spawn
	_spawn_procedural(root, build_planter(), Vector3(2.0, 0.35, 2.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(0), Vector3(-3.5, 1.8, -3.5), 0.0)
	_spawn_procedural(root, build_tree_rounded(1), Vector3(3.5, 1.8, -3.5), 0.5)
	_spawn_procedural(root, build_tree_rounded(2), Vector3(-3.5, 1.8, 3.5), 1.0)
	_spawn_procedural(root, build_tree_rounded(0), Vector3(3.5, 1.8, 3.5), 1.5)

	_spawn_procedural(root, build_bench(), Vector3(0.0, 0.45, -4.5), 0.0)
	_spawn_procedural(root, build_bench(), Vector3(0.0, 0.45, 4.5), PI)
	_spawn_procedural(root, build_bench(), Vector3(-4.5, 0.45, 0.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(4.5, 0.45, 0.0), -PI * 0.5)

	_spawn_procedural(root, build_bin(), Vector3(-4.5, 0.45, -3.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(4.5, 0.45, 3.0), -PI * 0.5)

	_spawn_procedural(root, build_bollard(), Vector3(-4.0, 0.40, -4.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(4.0, 0.40, -4.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(-4.0, 0.40, 4.5), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(4.0, 0.40, 4.5), 0.0)

	# 4 Low Planters
	_spawn_procedural(root, build_planter(), Vector3(-5.0, 0.35, -5.0), 0.0)
	_spawn_procedural(root, build_planter(), Vector3(5.0, 0.35, -5.0), 0.0)
	_spawn_procedural(root, build_planter(), Vector3(-5.0, 0.35, 5.0), 0.0)
	_spawn_procedural(root, build_planter(), Vector3(5.0, 0.35, 5.0), 0.0)

	# Cafe outdoor seating at E3 City Cafe (-25, -7)
	_spawn_procedural(root, build_cafe_table(), Vector3(-25.0, 0.38, -1.8), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-25.8, 0.40, -1.8), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(-24.2, 0.40, -1.8), -PI * 0.5)

static func _populate_block_f(root: Node3D) -> void:
	# Eastern Residential & Retail:
	# Bike rack with bicycles, 2 trees, 4 shrubs, 2 benches, 3 bins, 3 streetlights
	_spawn_procedural(root, build_bike_rack(), Vector3(42.0, 0.50, -17.5), 0.0)

	_spawn_procedural(root, build_tree_rounded(1), Vector3(20.0, 1.8, -30.0), 0.0)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(50.0, 2.2, 0.0), 0.0)

	_spawn_procedural(root, build_shrub(), Vector3(23.0, 0.45, 0.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(27.0, 0.45, 0.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(40.0, 0.45, 0.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(44.0, 0.45, 0.0), 0.0)

	_spawn_procedural(root, build_bench(), Vector3(17.5, 0.45, -15.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(52.5, 0.45, -15.0), -PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(17.5, 0.45, -13.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(45.0, 0.45, 2.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(52.5, 0.45, -13.0), -PI * 0.5)

	_spawn_procedural(root, build_streetlight(), Vector3(17.5, 2.4, -15.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(35.0, 2.4, 2.5), 0.0)
	_spawn_procedural(root, build_streetlight(), Vector3(52.5, 2.4, -15.0), -PI * 0.5)

static func _populate_block_g(root: Node3D) -> void:
	# Southwest Service & Parking:
	# 4 traffic cones near garage opening, 4 bollards, 2 bins, 3 streetlights
	_spawn_procedural(root, build_traffic_cone(), Vector3(-55.0, 0.30, 22.0), 0.0)
	_spawn_procedural(root, build_traffic_cone(), Vector3(-53.0, 0.30, 22.0), 0.0)
	_spawn_procedural(root, build_traffic_cone(), Vector3(-51.0, 0.30, 22.0), 0.0)
	_spawn_procedural(root, build_traffic_cone(), Vector3(-49.0, 0.30, 22.0), 0.0)

	_spawn_procedural(root, build_bollard(), Vector3(-65.0, 0.40, 38.0), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(-61.0, 0.40, 38.0), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(-57.0, 0.40, 38.0), 0.0)
	_spawn_procedural(root, build_bollard(), Vector3(-53.0, 0.40, 38.0), 0.0)

	_spawn_procedural(root, build_bin(), Vector3(-66.0, 0.45, 52.5), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-50.0, 0.45, 52.5), 0.0)

	_spawn_procedural(root, build_streetlight(), Vector3(-82.5, 2.4, 35.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(-47.5, 2.4, 35.0), -PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(-65.0, 2.4, 52.5), 0.0)

static func _populate_block_h_park(root: Node3D) -> void:
	# Southern Central Park (34x34 centered around (-15, 35)):
	# 12 trees, 8 shrubs, 4 flower beds, 6 benches, 4 bins, 2 picnic tables, 8 rocks, 4 streetlights
	var tree_coords: Array[Vector2] = [
		Vector2(-28.0, 22.0), Vector2(-22.0, 20.0), Vector2(-8.0, 22.0), Vector2(-2.0, 20.0),
		Vector2(-29.0, 32.0), Vector2(-2.0, 34.0), Vector2(-28.0, 42.0), Vector2(-2.0, 44.0),
		Vector2(-27.0, 48.0), Vector2(-20.0, 49.0), Vector2(-9.0, 48.0), Vector2(-3.0, 49.0)
	]
	for i in range(tree_coords.size()):
		var tc := tree_coords[i]
		if i % 3 == 0:
			_spawn_procedural(root, build_tree_park(), Vector3(tc.x, 2.5, tc.y), float(i) * 0.4)
		elif i % 3 == 1:
			_spawn_procedural(root, build_tree_rounded(i % 3), Vector3(tc.x, 1.8, tc.y), float(i) * 0.5)
		else:
			_spawn_procedural(root, build_tree_tall_narrow(), Vector3(tc.x, 2.2, tc.y), float(i) * 0.3)

	# 8 Shrubs
	var shrub_coords: Array[Vector2] = [
		Vector2(-25.0, 26.0), Vector2(-5.0, 26.0), Vector2(-25.0, 40.0), Vector2(-5.0, 40.0),
		Vector2(-19.0, 27.0), Vector2(-11.0, 27.0), Vector2(-19.0, 43.0), Vector2(-11.0, 43.0)
	]
	for sc in shrub_coords:
		_spawn_procedural(root, build_shrub(), Vector3(sc.x, 0.45, sc.y), 0.0)

	# 4 Flower beds
	_spawn_procedural(root, build_flower_bed(), Vector3(-20.0, 0.20, 31.0), 0.0)
	_spawn_procedural(root, build_flower_bed(), Vector3(-10.0, 0.20, 23.0), 0.0)
	_spawn_procedural(root, build_flower_bed(), Vector3(-20.0, 0.20, 39.0), 0.0)
	_spawn_procedural(root, build_flower_bed(), Vector3(-10.0, 0.20, 39.0), 0.0)

	# 6 Benches along park paths
	_spawn_procedural(root, build_bench(), Vector3(-15.0, 0.45, 20.0), 0.0)
	_spawn_procedural(root, build_bench(), Vector3(-15.0, 0.45, 50.0), PI)
	_spawn_procedural(root, build_bench(), Vector3(-29.0, 0.45, 35.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(-1.0, 0.45, 35.0), -PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(-22.0, 0.45, 35.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(-8.0, 0.45, 35.0), -PI * 0.5)

	# 4 Bins
	_spawn_procedural(root, build_bin(), Vector3(-13.0, 0.45, 20.0), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(-17.0, 0.45, 50.0), PI)
	_spawn_procedural(root, build_bin(), Vector3(-29.0, 0.45, 33.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(-1.0, 0.45, 37.0), -PI * 0.5)

	# 2 Picnic tables
	_spawn_procedural(root, build_picnic_table(), Vector3(-24.0, 0.40, 24.0), 0.0)
	_spawn_procedural(root, build_picnic_table(), Vector3(-6.0, 0.40, 46.0), 0.0)

	# 8 Decorative rocks around pond perimeter and grass clearings
	var rock_coords: Array[Vector2] = [
		Vector2(-13.0, 31.0), Vector2(-7.0, 31.0), Vector2(-10.0, 28.5), Vector2(-10.0, 33.5),
		Vector2(-26.0, 28.0), Vector2(-4.0, 28.0), Vector2(-26.0, 44.0), Vector2(-4.0, 44.0)
	]
	for rc in rock_coords:
		_spawn_procedural(root, build_decorative_rock(), Vector3(rc.x, 0.30, rc.y), randf() * TAU)

	# 4 Park Streetlights
	_spawn_procedural(root, build_streetlight(), Vector3(-32.0, 2.4, 25.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(2.0, 2.4, 25.0), -PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(-32.0, 2.4, 45.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(2.0, 2.4, 45.0), -PI * 0.5)

static func _populate_block_i(root: Node3D) -> void:
	# Southeast Mixed Commercial: Hotel, Diner, Apartments, MiniMart
	# Diner outdoor tables & chairs at I2 Diner (43, 29)
	_spawn_procedural(root, build_cafe_table(), Vector3(41.0, 0.38, 35.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(40.2, 0.40, 35.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(41.8, 0.40, 35.0), -PI * 0.5)
	_spawn_procedural(root, build_cafe_table(), Vector3(45.0, 0.38, 35.0), 0.0)
	_spawn_procedural(root, build_cafe_chair(), Vector3(44.2, 0.40, 35.0), PI * 0.5)
	_spawn_procedural(root, build_cafe_chair(), Vector3(45.8, 0.40, 35.0), -PI * 0.5)

	# Trees & Landscaping
	_spawn_procedural(root, build_tree_rounded(0), Vector3(18.0, 1.8, 50.0), 0.0)
	_spawn_procedural(root, build_tree_rounded(1), Vector3(50.0, 1.8, 50.0), 0.3)
	_spawn_procedural(root, build_tree_tall_narrow(), Vector3(50.0, 2.2, 22.0), 0.0)

	_spawn_procedural(root, build_shrub(), Vector3(20.0, 0.45, 36.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(25.0, 0.45, 36.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(40.0, 0.45, 52.0), 0.0)
	_spawn_procedural(root, build_shrub(), Vector3(46.0, 0.45, 52.0), 0.0)

	_spawn_procedural(root, build_bench(), Vector3(17.5, 0.45, 35.0), PI * 0.5)
	_spawn_procedural(root, build_bench(), Vector3(52.5, 0.45, 35.0), -PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(17.5, 0.45, 37.0), PI * 0.5)
	_spawn_procedural(root, build_bin(), Vector3(43.0, 0.45, 37.0), 0.0)
	_spawn_procedural(root, build_bin(), Vector3(52.5, 0.45, 37.0), -PI * 0.5)

	_spawn_procedural(root, build_streetlight(), Vector3(17.5, 2.4, 45.0), PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(52.5, 2.4, 45.0), -PI * 0.5)
	_spawn_procedural(root, build_streetlight(), Vector3(35.0, 2.4, 52.5), 0.0)

# -----------------------------------------------------------------
# AVENUE INFRASTRUCTURE & ROAD SIGNS (Section 13)
# -----------------------------------------------------------------
static func _populate_avenue_infrastructure(root: Node3D) -> void:
	# Traffic signs at major intersection approaches
	_spawn_procedural(root, build_traffic_sign("stop"), Vector3(-35.0, 1.1, -47.0), 0.0)
	_spawn_procedural(root, build_traffic_sign("stop"), Vector3(15.0, 1.1, -47.0), 0.0)
	_spawn_procedural(root, build_traffic_sign("pedestrian"), Vector3(-35.0, 1.1, 5.0), 0.0)
	_spawn_procedural(root, build_traffic_sign("pedestrian"), Vector3(15.0, 1.1, 5.0), 0.0)
	_spawn_procedural(root, build_traffic_sign("speed"), Vector3(-45.0, 1.1, -33.0), PI * 0.5)
	_spawn_procedural(root, build_traffic_sign("parking"), Vector3(5.0, 1.1, -33.0), PI * 0.5)

	# Fire hydrants near avenue corners
	_spawn_procedural(root, build_fire_hydrant(), Vector3(-35.0, 0.35, -45.0), 0.0)
	_spawn_procedural(root, build_fire_hydrant(), Vector3(5.0, 0.35, -45.0), 0.0)
	_spawn_procedural(root, build_fire_hydrant(), Vector3(-35.0, 0.35, 15.0), 0.0)
	_spawn_procedural(root, build_fire_hydrant(), Vector3(5.0, 0.35, 15.0), 0.0)

# -----------------------------------------------------------------
# PROCEDURAL MESH BUILDERS - VEHICLES (Section 10)
# -----------------------------------------------------------------
static func build_compact_car(color: Color) -> Node3D:
	# 4.0 length, 1.8 width, 1.5 height
	return _build_car_base(Vector3(1.8, 1.5, 4.0), color, 0.55, 0.55, false)

static func build_sedan(color: Color) -> Node3D:
	# 4.5 length, 1.9 width, 1.5 height
	return _build_car_base(Vector3(1.9, 1.5, 4.5), color, 0.65, 0.50, false)

static func build_hatchback(color: Color) -> Node3D:
	# 3.8 length, 1.8 width, 1.5 height
	return _build_car_base(Vector3(1.8, 1.5, 3.8), color, 0.50, 0.70, false)

static func build_suv(color: Color) -> Node3D:
	# 4.6 length, 2.0 width, 1.8 height
	var n := _build_car_base(Vector3(2.0, 1.8, 4.6), color, 0.60, 0.65, true)
	# Roof rack
	var rack_mat := CityMaterials.get_standard_material(Color(0.2, 0.2, 0.2), 0.4)
	var rail1 := _add_box(n, Vector3(0.08, 0.06, 2.2), rack_mat, Vector3(-0.65, 0.93, -0.1))
	var rail2 := _add_box(n, Vector3(0.08, 0.06, 2.2), rack_mat, Vector3(0.65, 0.93, -0.1))
	return n

static func build_delivery_van(color: Color) -> Node3D:
	# 5.2 length, 2.0 width, 2.4 height
	var n := Node3D.new()
	var body_mat := CityMaterials.get_standard_material(color, 0.4)
	var glass_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_WINDOW_GLASS, 0.2, 0.2)
	var trim_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.6)

	# Main tall cargo box
	_add_box(n, Vector3(1.95, 1.6, 3.4), body_mat, Vector3(0.0, 0.2, -0.6))
	# Front cab
	_add_box(n, Vector3(1.90, 1.1, 1.6), body_mat, Vector3(0.0, -0.05, 1.7))
	# Front windshield
	_add_box(n, Vector3(1.65, 0.65, 0.05), glass_mat, Vector3(0.0, 0.25, 2.48))
	# Side cab windows
	_add_box(n, Vector3(0.05, 0.45, 0.7), glass_mat, Vector3(-0.96, 0.25, 1.6))
	_add_box(n, Vector3(0.05, 0.45, 0.7), glass_mat, Vector3(0.96, 0.25, 1.6))
	# Wheels (4)
	_add_car_wheels(n, 2.0, 5.2, 0.42)
	# Bumpers & Lights
	_add_box(n, Vector3(1.85, 0.22, 0.15), trim_mat, Vector3(0.0, -0.45, 2.52))
	_add_box(n, Vector3(1.85, 0.22, 0.15), trim_mat, Vector3(0.0, -0.45, -2.32))
	_add_headlights(n, 1.9, 5.2)
	return n

static func build_taxi() -> Node3D:
	var n := build_sedan(Color(0.96, 0.78, 0.12)) # Iconic taxi yellow
	# Roof taxi sign
	var sign_mat := CityMaterials.get_standard_material(Color(0.98, 0.98, 0.98), 0.3)
	var sign_box := _add_box(n, Vector3(0.65, 0.20, 0.25), sign_mat, Vector3(0.0, 0.82, -0.1))
	# Black roof sign base
	var base_mat := CityMaterials.get_standard_material(Color(0.15, 0.15, 0.15), 0.5)
	_add_box(n, Vector3(0.70, 0.05, 0.30), base_mat, Vector3(0.0, 0.72, -0.1))
	return n

static func _build_car_base(size: Vector3, color: Color, hood_ratio: float, cabin_ratio: float, is_tall: bool) -> Node3D:
	var n := Node3D.new()
	var body_mat := CityMaterials.get_standard_material(color, 0.35)
	var glass_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_WINDOW_GLASS, 0.2, 0.2)
	var trim_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.5)

	var chassis_h := size.y * 0.42
	var cabin_h := size.y * 0.48
	var wheel_r := chassis_h * 0.55

	# Lower chassis body
	_add_box(n, Vector3(size.x, chassis_h, size.z), body_mat, Vector3(0.0, -size.y * 0.5 + chassis_h * 0.5 + wheel_r * 0.3, 0.0))

	# Upper cabin
	var cabin_l := size.z * cabin_ratio
	var cabin_z := -size.z * 0.06
	var cabin_y := -size.y * 0.5 + chassis_h + cabin_h * 0.5 + wheel_r * 0.3
	_add_box(n, Vector3(size.x * 0.86, cabin_h, cabin_l), body_mat, Vector3(0.0, cabin_y, cabin_z))

	# Front windshield
	_add_box(n, Vector3(size.x * 0.78, cabin_h * 0.75, 0.06), glass_mat, Vector3(0.0, cabin_y, cabin_z + cabin_l * 0.5 + 0.01))
	# Rear windshield
	_add_box(n, Vector3(size.x * 0.78, cabin_h * 0.68, 0.06), glass_mat, Vector3(0.0, cabin_y, cabin_z - cabin_l * 0.5 - 0.01))
	# Side windows
	_add_box(n, Vector3(0.06, cabin_h * 0.65, cabin_l * 0.75), glass_mat, Vector3(-size.x * 0.43 - 0.01, cabin_y, cabin_z))
	_add_box(n, Vector3(0.06, cabin_h * 0.65, cabin_l * 0.75), glass_mat, Vector3(size.x * 0.43 + 0.01, cabin_y, cabin_z))

	# Wheels
	_add_car_wheels(n, size.x, size.z, wheel_r)
	# Bumpers
	_add_box(n, Vector3(size.x * 0.95, chassis_h * 0.45, 0.12), trim_mat, Vector3(0.0, -size.y * 0.5 + wheel_r * 0.8, size.z * 0.5 + 0.05))
	_add_box(n, Vector3(size.x * 0.95, chassis_h * 0.45, 0.12), trim_mat, Vector3(0.0, -size.y * 0.5 + wheel_r * 0.8, -size.z * 0.5 - 0.05))
	# Headlights & Taillights
	_add_headlights(n, size.x, size.z)
	return n

static func _add_car_wheels(parent: Node3D, width: float, length: float, radius: float) -> void:
	var tire_mat := CityMaterials.get_standard_material(Color(0.12, 0.12, 0.14), 0.7)
	var rim_mat := CityMaterials.get_standard_material(Color(0.75, 0.75, 0.78), 0.3, 0.6)

	var wx := width * 0.5
	var wz := length * 0.32
	var wy := -radius * 0.35

	var wheel_positions: Array[Vector3] = [
		Vector3(-wx, wy, wz),
		Vector3(wx, wy, wz),
		Vector3(-wx, wy, -wz),
		Vector3(wx, wy, -wz)
	]

	for wp in wheel_positions:
		var tire := _add_cylinder(parent, radius, 0.28, tire_mat, wp)
		tire.rotation.z = PI * 0.5
		var rim := _add_cylinder(parent, radius * 0.55, 0.30, rim_mat, wp)
		rim.rotation.z = PI * 0.5

static func _add_headlights(parent: Node3D, width: float, length: float) -> void:
	var light_mat := CityMaterials.get_standard_material(Color(1.0, 0.98, 0.85), 0.2)
	light_mat.emission_enabled = true
	light_mat.emission = Color(1.0, 0.95, 0.75)
	light_mat.emission_energy_multiplier = 0.8

	var tail_mat := CityMaterials.get_standard_material(Color(0.9, 0.15, 0.12), 0.3)
	tail_mat.emission_enabled = true
	tail_mat.emission = Color(0.85, 0.1, 0.08)
	tail_mat.emission_energy_multiplier = 0.6

	var hx := width * 0.35
	var fz := length * 0.5 + 0.02
	var bz := -length * 0.5 - 0.02
	var y := 0.05

	# Front headlights
	_add_box(parent, Vector3(0.28, 0.18, 0.05), light_mat, Vector3(-hx, y, fz))
	_add_box(parent, Vector3(0.28, 0.18, 0.05), light_mat, Vector3(hx, y, fz))
	# Rear taillights
	_add_box(parent, Vector3(0.28, 0.16, 0.05), tail_mat, Vector3(-hx, y, bz))
	_add_box(parent, Vector3(0.28, 0.16, 0.05), tail_mat, Vector3(hx, y, bz))

# -----------------------------------------------------------------
# PROCEDURAL MESH BUILDERS - STREET PROPS (Section 11)
# -----------------------------------------------------------------
static func build_bench() -> Node3D:
	# 1.8 x 0.6 x 0.9 bench
	var n := Node3D.new()
	var wood_mat := CityMaterials.get_standard_material(Color(0.62, 0.42, 0.24), 0.6)
	var metal_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4)

	# Slats (Seat)
	_add_box(n, Vector3(1.8, 0.08, 0.5), wood_mat, Vector3(0.0, 0.0, 0.0))
	# Backrest
	_add_box(n, Vector3(1.8, 0.38, 0.08), wood_mat, Vector3(0.0, 0.25, -0.22))
	# Legs
	_add_box(n, Vector3(0.08, 0.44, 0.5), metal_mat, Vector3(-0.75, -0.22, 0.0))
	_add_box(n, Vector3(0.08, 0.44, 0.5), metal_mat, Vector3(0.75, -0.22, 0.0))
	return n

static func build_bin() -> Node3D:
	# 0.5 x 0.5 x 0.9 bin
	var n := Node3D.new()
	var bin_mat := CityMaterials.get_standard_material(Color(0.25, 0.45, 0.35), 0.5)
	var lid_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4)

	_add_box(n, Vector3(0.48, 0.70, 0.48), bin_mat, Vector3(0.0, -0.05, 0.0))
	_add_box(n, Vector3(0.52, 0.12, 0.52), lid_mat, Vector3(0.0, 0.35, 0.0))
	return n

static func build_bollard() -> Node3D:
	# 0.2 x 0.2 x 0.8 bollard
	var n := Node3D.new()
	var b_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4)
	var stripe_mat := CityMaterials.get_standard_material(Color(0.95, 0.85, 0.2), 0.4)

	_add_cylinder(n, 0.12, 0.75, b_mat, Vector3(0.0, 0.0, 0.0))
	_add_cylinder(n, 0.125, 0.12, stripe_mat, Vector3(0.0, 0.20, 0.0))
	return n

static func build_traffic_cone() -> Node3D:
	# 0.35 x 0.35 x 0.6 traffic cone
	var n := Node3D.new()
	var orange_mat := CityMaterials.get_standard_material(Color(0.98, 0.42, 0.08), 0.4)
	var white_mat := CityMaterials.get_standard_material(Color(0.96, 0.96, 0.96), 0.3)

	# Base plate
	_add_box(n, Vector3(0.38, 0.04, 0.38), orange_mat, Vector3(0.0, -0.28, 0.0))
	# Conical body
	var cone := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.04
	cyl.bottom_radius = 0.16
	cyl.height = 0.56
	cyl.material = orange_mat
	cone.mesh = cyl
	cone.position = Vector3(0.0, 0.02, 0.0)
	n.add_child(cone)
	# Reflective band
	var band := _add_cylinder(n, 0.11, 0.14, white_mat, Vector3(0.0, 0.05, 0.0))
	return n

static func build_fire_hydrant() -> Node3D:
	# 0.35 x 0.35 x 0.7 fire hydrant
	var n := Node3D.new()
	var red_mat := CityMaterials.get_standard_material(Color(0.88, 0.18, 0.14), 0.4)
	var cap_mat := CityMaterials.get_standard_material(Color(0.75, 0.75, 0.78), 0.3)

	_add_cylinder(n, 0.16, 0.65, red_mat, Vector3(0.0, 0.0, 0.0))
	_add_cylinder(n, 0.19, 0.10, red_mat, Vector3(0.0, 0.30, 0.0))
	# Side nozzle caps
	var cap1 := _add_cylinder(n, 0.07, 0.42, cap_mat, Vector3(0.0, 0.10, 0.0))
	cap1.rotation.z = PI * 0.5
	return n

static func build_mailbox() -> Node3D:
	# 0.4 x 0.4 x 1.1 mailbox
	var n := Node3D.new()
	var post_mat := CityMaterials.get_standard_material(Color(0.2, 0.35, 0.65), 0.4)
	var slit_mat := CityMaterials.get_standard_material(Color(0.1, 0.1, 0.1), 0.5)

	_add_box(n, Vector3(0.42, 0.70, 0.42), post_mat, Vector3(0.0, 0.15, 0.0))
	_add_box(n, Vector3(0.12, 0.45, 0.12), post_mat, Vector3(0.0, -0.32, 0.0))
	_add_box(n, Vector3(0.28, 0.04, 0.05), slit_mat, Vector3(0.0, 0.32, 0.22))
	return n

static func build_planter() -> Node3D:
	# 0.8 x 0.8 x 0.6 planter
	var n := Node3D.new()
	var pot_mat := CityMaterials.get_standard_material(Color(0.68, 0.48, 0.36), 0.6)
	var plant_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_TREE_FOLIAGE, 0.8)

	_add_box(n, Vector3(0.85, 0.55, 0.85), pot_mat, Vector3(0.0, -0.05, 0.0))
	var sphere := MeshInstance3D.new()
	var sp := SphereMesh.new()
	sp.radius = 0.45
	sp.height = 0.65
	sp.material = plant_mat
	sphere.mesh = sp
	sphere.position = Vector3(0.0, 0.30, 0.0)
	n.add_child(sphere)
	return n

static func build_cafe_table() -> Node3D:
	# 0.8 x 0.8 x 0.75 cafe table
	var n := Node3D.new()
	var top_mat := CityMaterials.get_standard_material(Color(0.85, 0.75, 0.62), 0.5)
	var leg_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4)

	_add_cylinder(n, 0.42, 0.05, top_mat, Vector3(0.0, 0.35, 0.0))
	_add_cylinder(n, 0.04, 0.70, leg_mat, Vector3(0.0, 0.0, 0.0))
	_add_cylinder(n, 0.25, 0.03, leg_mat, Vector3(0.0, -0.34, 0.0))
	return n

static func build_cafe_chair() -> Node3D:
	# 0.45 x 0.45 x 0.8 chair
	var n := Node3D.new()
	var chair_mat := CityMaterials.get_standard_material(Color(0.25, 0.30, 0.35), 0.5)

	# Seat
	_add_box(n, Vector3(0.42, 0.04, 0.42), chair_mat, Vector3(0.0, 0.0, 0.0))
	# Backrest
	_add_box(n, Vector3(0.42, 0.38, 0.04), chair_mat, Vector3(0.0, 0.20, -0.19))
	# Legs
	_add_box(n, Vector3(0.04, 0.42, 0.04), chair_mat, Vector3(-0.18, -0.21, -0.18))
	_add_box(n, Vector3(0.04, 0.42, 0.04), chair_mat, Vector3(0.18, -0.21, -0.18))
	_add_box(n, Vector3(0.04, 0.42, 0.04), chair_mat, Vector3(-0.18, -0.21, 0.18))
	_add_box(n, Vector3(0.04, 0.42, 0.04), chair_mat, Vector3(0.18, -0.21, 0.18))
	return n

static func build_picnic_table() -> Node3D:
	# 1.8 x 1.4 x 0.8 picnic table
	var n := Node3D.new()
	var wood_mat := CityMaterials.get_standard_material(Color(0.68, 0.45, 0.26), 0.7)

	# Table top
	_add_box(n, Vector3(1.8, 0.08, 0.75), wood_mat, Vector3(0.0, 0.36, 0.0))
	# Benches
	_add_box(n, Vector3(1.8, 0.06, 0.28), wood_mat, Vector3(0.0, 0.16, -0.55))
	_add_box(n, Vector3(1.8, 0.06, 0.28), wood_mat, Vector3(0.0, 0.16, 0.55))
	# Legs / frame
	_add_box(n, Vector3(0.08, 0.72, 1.3), wood_mat, Vector3(-0.65, 0.0, 0.0))
	_add_box(n, Vector3(0.08, 0.72, 1.3), wood_mat, Vector3(0.65, 0.0, 0.0))
	return n

static func build_shopping_cart() -> Node3D:
	# 1.0 x 0.6 x 1.0 shopping cart
	var n := Node3D.new()
	var wire_mat := CityMaterials.get_standard_material(Color(0.78, 0.80, 0.84), 0.3, 0.7)
	var handle_mat := CityMaterials.get_standard_material(Color(0.85, 0.15, 0.15), 0.4)

	# Wire basket
	_add_box(n, Vector3(0.60, 0.55, 0.85), wire_mat, Vector3(0.0, 0.15, -0.05))
	# Handle
	_add_box(n, Vector3(0.62, 0.06, 0.06), handle_mat, Vector3(0.0, 0.45, -0.48))
	# Under-chassis & wheels
	_add_box(n, Vector3(0.55, 0.25, 0.80), wire_mat, Vector3(0.0, -0.32, -0.05))
	return n

static func build_utility_box() -> Node3D:
	# 0.8 x 0.5 x 1.0 utility box
	var n := Node3D.new()
	var box_mat := CityMaterials.get_standard_material(Color(0.35, 0.45, 0.38), 0.6)
	_add_box(n, Vector3(0.80, 1.0, 0.50), box_mat, Vector3(0.0, 0.0, 0.0))
	return n

static func build_bike_rack() -> Node3D:
	# 1.6 x 1.0 x 0.8 bicycle rack
	var n := Node3D.new()
	var metal_mat := CityMaterials.get_standard_material(Color(0.65, 0.68, 0.72), 0.3, 0.5)
	var bike_mat1 := CityMaterials.get_standard_material(Color(0.85, 0.2, 0.15), 0.4)
	var bike_mat2 := CityMaterials.get_standard_material(Color(0.2, 0.55, 0.85), 0.4)

	# Rack hoops
	for x in [-0.5, 0.0, 0.5]:
		_add_box(n, Vector3(0.06, 0.75, 0.65), metal_mat, Vector3(x, 0.0, 0.0))

	# 2 Parked stylized bikes
	_add_box(n, Vector3(0.08, 0.70, 1.2), bike_mat1, Vector3(-0.25, 0.0, 0.0))
	_add_box(n, Vector3(0.08, 0.70, 1.2), bike_mat2, Vector3(0.25, 0.0, 0.0))
	return n

static func build_streetlight() -> Node3D:
	# Tall dark-metal streetlight (height ~5.0)
	var n := Node3D.new()
	var pole_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4)
	var lamp_mat := CityMaterials.get_standard_material(Color(1.0, 0.98, 0.9), 0.2)
	lamp_mat.emission_enabled = true
	lamp_mat.emission = Color(1.0, 0.95, 0.8)
	lamp_mat.emission_energy_multiplier = 0.9

	# Vertical pole
	_add_cylinder(n, 0.08, 4.8, pole_mat, Vector3(0.0, 0.0, 0.0))
	# Base plate
	_add_cylinder(n, 0.25, 0.12, pole_mat, Vector3(0.0, -2.35, 0.0))
	# Horizontal arm
	_add_box(n, Vector3(0.08, 0.08, 0.9), pole_mat, Vector3(0.0, 2.35, 0.4))
	# Lamp head
	_add_box(n, Vector3(0.24, 0.12, 0.35), pole_mat, Vector3(0.0, 2.30, 0.8))
	_add_box(n, Vector3(0.20, 0.04, 0.30), lamp_mat, Vector3(0.0, 2.22, 0.8))
	return n

static func build_traffic_sign(type: String) -> Node3D:
	var n := Node3D.new()
	var pole_mat := CityMaterials.get_standard_material(Color(0.7, 0.72, 0.75), 0.4)

	# Pole (height 2.2)
	_add_cylinder(n, 0.04, 2.2, pole_mat, Vector3(0.0, 0.0, 0.0))

	# Signboard
	var sign_col := Color(0.85, 0.18, 0.15) # Stop red
	if type == "pedestrian":
		sign_col = Color(0.18, 0.45, 0.85) # Blue
	elif type == "parking":
		sign_col = Color(0.2, 0.65, 0.35) # Green
	elif type == "speed":
		sign_col = Color(0.95, 0.95, 0.95) # White

	var sign_mat := CityMaterials.get_standard_material(sign_col, 0.4)
	_add_box(n, Vector3(0.55, 0.55, 0.04), sign_mat, Vector3(0.0, 0.85, 0.05))
	return n

# -----------------------------------------------------------------
# PROCEDURAL MESH BUILDERS - VEGETATION (Section 12)
# -----------------------------------------------------------------
static func build_tree_rounded(variant: int) -> Node3D:
	var n := Node3D.new()
	var trunk_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_TREE_TRUNK, 0.8)
	var foliage_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_TREE_FOLIAGE, 0.85)

	# Trunk
	_add_cylinder(n, 0.22, 2.0, trunk_mat, Vector3(0.0, -0.6, 0.0))

	# Overlapping foliage spheres
	var s1 := _add_sphere(n, 1.25, foliage_mat, Vector3(0.0, 0.6, 0.0))
	if variant == 1:
		_add_sphere(n, 0.95, foliage_mat, Vector3(0.3, 1.2, 0.2))
	elif variant == 2:
		_add_sphere(n, 0.90, foliage_mat, Vector3(-0.3, 1.3, -0.2))
	return n

static func build_tree_tall_narrow() -> Node3D:
	var n := Node3D.new()
	var trunk_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_TREE_TRUNK, 0.8)
	var foliage_mat := CityMaterials.get_standard_material(Color(0.22, 0.48, 0.25), 0.85)

	_add_cylinder(n, 0.20, 2.5, trunk_mat, Vector3(0.0, -0.9, 0.0))
	_add_cone(n, 0.9, 2.0, foliage_mat, Vector3(0.0, 0.2, 0.0))
	_add_cone(n, 0.7, 1.8, foliage_mat, Vector3(0.0, 1.1, 0.0))
	return n

static func build_tree_park() -> Node3D:
	var n := Node3D.new()
	var trunk_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_TREE_TRUNK, 0.8)
	var foliage_mat := CityMaterials.get_standard_material(Color(0.32, 0.62, 0.30), 0.85)

	_add_cylinder(n, 0.32, 2.2, trunk_mat, Vector3(0.0, -0.8, 0.0))
	_add_sphere(n, 1.6, foliage_mat, Vector3(0.0, 0.6, 0.0))
	_add_sphere(n, 1.2, foliage_mat, Vector3(0.6, 1.1, 0.4))
	_add_sphere(n, 1.1, foliage_mat, Vector3(-0.5, 1.0, -0.5))
	return n

static func build_shrub() -> Node3D:
	var n := Node3D.new()
	var foliage_mat := CityMaterials.get_standard_material(Color(0.35, 0.58, 0.28), 0.85)
	_add_sphere(n, 0.55, foliage_mat, Vector3(0.0, 0.0, 0.0))
	_add_sphere(n, 0.42, foliage_mat, Vector3(0.25, 0.05, 0.15))
	return n

static func build_flower_bed() -> Node3D:
	var n := Node3D.new()
	var wood_mat := CityMaterials.get_standard_material(Color(0.55, 0.38, 0.25), 0.8)
	var soil_mat := CityMaterials.get_standard_material(Color(0.28, 0.22, 0.18), 0.9)
	var flower_mat1 := CityMaterials.get_standard_material(Color(0.85, 0.25, 0.65), 0.5)
	var flower_mat2 := CityMaterials.get_standard_material(Color(0.95, 0.85, 0.20), 0.5)

	# Raised planter frame
	_add_box(n, Vector3(2.1, 0.25, 1.1), wood_mat, Vector3(0.0, 0.0, 0.0))
	_add_box(n, Vector3(1.9, 0.28, 0.9), soil_mat, Vector3(0.0, 0.02, 0.0))

	# Colorful flower clusters
	for x in [-0.6, -0.2, 0.2, 0.6]:
		var f_mat := flower_mat1 if (int(x * 10) % 2 == 0) else flower_mat2
		_add_sphere(n, 0.14, f_mat, Vector3(x, 0.20, randf_range(-0.25, 0.25)))
	return n

static func build_decorative_rock() -> Node3D:
	var n := Node3D.new()
	var rock_mat := CityMaterials.get_standard_material(Color(0.55, 0.55, 0.58), 0.85)
	var b := _add_box(n, Vector3(0.75, 0.45, 0.65), rock_mat, Vector3(0.0, 0.0, 0.0))
	b.rotation = Vector3(0.2, 0.4, 0.1)
	return n

# -----------------------------------------------------------------
# HELPER SPAWNERS & PRIMITIVE FACTORIES
# -----------------------------------------------------------------
static func _spawn_model(parent: Node3D, model_scene: PackedScene, pos: Vector3, scale: float, rot_y: float, growth: float) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_model(model_scene, scale)
	item.global_position = pos
	item.rotation.y = rot_y
	item.set_meta("growth_value", growth)
	return item

static func _spawn_procedural(parent: Node3D, node: Node3D, pos: Vector3, rot_y: float) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_existing_node(node, 1.0)
	item.global_position = pos
	item.rotation.y = rot_y
	item.set_meta("growth_value", 0.04)
	return item

static func _add_box(parent: Node3D, size: Vector3, mat: Material, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = mat
	mi.mesh = b
	mi.position = pos
	parent.add_child(mi)
	return mi

static func _add_cylinder(parent: Node3D, radius: float, height: float, mat: Material, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.height = height
	cyl.material = mat
	mi.mesh = cyl
	mi.position = pos
	parent.add_child(mi)
	return mi

static func _add_sphere(parent: Node3D, radius: float, mat: Material, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var sp := SphereMesh.new()
	sp.radius = radius
	sp.height = radius * 2.0
	sp.material = mat
	mi.mesh = sp
	mi.position = pos
	parent.add_child(mi)
	return mi

static func _add_cone(parent: Node3D, radius: float, height: float, mat: Material, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.05
	cyl.bottom_radius = radius
	cyl.height = height
	cyl.material = mat
	mi.mesh = cyl
	mi.position = pos
	parent.add_child(mi)
	return mi
