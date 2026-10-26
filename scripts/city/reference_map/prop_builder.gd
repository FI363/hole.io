class_name RefPropBuilder
extends RefCounted

## Populates interactive vehicles, airplanes, boats, shipping containers, beach umbrellas, and vegetation
## Fully preserves anchor objects 0..7 and skyscraper for 100% test suite compatibility
## Uses imported 3D low-poly models from Kenney City collections

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: ANCHORS & SUITE
# -----------------------------------------------------------------
const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-a.glb")

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: VEHICLES
# -----------------------------------------------------------------
const MODEL_CAR_SEDAN: PackedScene = preload("res://assets/city/models/car-sedan.glb")
const MODEL_CAR_SPORTS: PackedScene = preload("res://assets/city/models/car-sedan-sports.glb")
const MODEL_CAR_SUV: PackedScene = preload("res://assets/city/models/car-suv.glb")
const MODEL_CAR_TAXI: PackedScene = preload("res://assets/city/models/car-taxi.glb")
const MODEL_CAR_VAN: PackedScene = preload("res://assets/city/models/car-van.glb")
const MODEL_CAR_POLICE: PackedScene = preload("res://assets/city/models/car-police.glb")

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: SEAPORT, NATURE & STREET PROPS
# -----------------------------------------------------------------
const MODEL_CONTAINER_A: PackedScene = preload("res://assets/kenney_city/industrial/shipping-container-a.glb")
const MODEL_CONTAINER_B: PackedScene = preload("res://assets/kenney_city/industrial/shipping-container-b.glb")
const MODEL_CONTAINER_C: PackedScene = preload("res://assets/kenney_city/industrial/shipping-container-c.glb")

const MODEL_TREE_PINE: PackedScene = preload("res://assets/city/models/nature-tree_pineDefaultA.glb")
const MODEL_TREE_OAK: PackedScene = preload("res://assets/city/models/nature-tree_oak.glb")
const MODEL_TREE_DEFAULT: PackedScene = preload("res://assets/city/models/nature-tree_default.glb")
const MODEL_BENCH: PackedScene = preload("res://assets/city/models/street-bench.glb")

const COLLECTIBLE_SCENE: PackedScene = preload("res://scenes/collectible.tscn")

static func populate_all_props(collectibles_root: Node3D, player_hole: PlayerHole) -> void:
	seed(3632026)

	# -------------------------------------------------------------
	# 1. MANDATORY ANCHOR OBJECTS (Test runner compatibility: 0..7 & Skyscraper)
	# -------------------------------------------------------------
	# 0: Central Promenade Fountain (Swallowed in Test 2)
	_spawn_model(collectibles_root, MODEL_FOUNTAIN, Vector3(0.0, 0.25, 2.8), 1.0, 0.0, 0.08)
	# 1 & 2: Promenade Trees
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
	_spawn_model(collectibles_root, MODEL_SKYSCRAPER_A, Vector3(42.5, 0.0, 29.0), 5.2, 0.0, 0.60)

	# -------------------------------------------------------------
	# 2. AIRPORT AIRPLANES (Region J)
	# -------------------------------------------------------------
	_populate_airport_planes(collectibles_root)

	# -------------------------------------------------------------
	# 3. MARINA YACHTS & BOATS (Region M)
	# -------------------------------------------------------------
	_populate_marina_boats(collectibles_root)

	# -------------------------------------------------------------
	# 4. BEACH UMBRELLAS & LOUNGERS (Region L)
	# -------------------------------------------------------------
	_populate_beach_props(collectibles_root)

	# -------------------------------------------------------------
	# 5. SEAPORT SHIPPING CONTAINERS (Region C)
	# -------------------------------------------------------------
	_populate_seaport_props(collectibles_root)

	# -------------------------------------------------------------
	# 6. CENTRAL PARK PROPS, GAZEBO & NATURE (Region H)
	# -------------------------------------------------------------
	_populate_central_park(collectibles_root)

	# -------------------------------------------------------------
	# 7. MOUNTAIN EVERGREEN PINE FOREST (Region A)
	# -------------------------------------------------------------
	_populate_mountain_forest(collectibles_root)

	# -------------------------------------------------------------
	# 8. SUBURBAN CARS & VEHICLES (Region G)
	# -------------------------------------------------------------
	_populate_suburban_props(collectibles_root)

	# -------------------------------------------------------------
	# 9. DOWNTOWN PROMENADE & STREET TRAFFIC
	# -------------------------------------------------------------
	_populate_downtown_props(collectibles_root)

# -----------------------------------------------------------------
# 2. AIRPORT AIRPLANES
# -----------------------------------------------------------------
static func _populate_airport_planes(root: Node3D) -> void:
	for x in [-62.0, -53.0, -44.0, -35.0]:
		var plane := _build_airplane()
		_spawn_procedural(root, plane, Vector3(x, 0.65, 65.0), PI * 0.5)

static func _build_airplane() -> Node3D:
	var n := Node3D.new()
	var white_mat := Constants.get_standard_material(Color(0.96, 0.96, 0.98), 0.3)
	var blue_mat := Constants.get_standard_material(Color(0.2, 0.45, 0.85), 0.4)
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.5)

	# Fuselage body
	var fuselage := MeshInstance3D.new()
	var fb := CylinderMesh.new()
	fb.top_radius = 0.55
	fb.bottom_radius = 0.55
	fb.height = 6.5
	fb.material = white_mat
	fuselage.mesh = fb
	fuselage.rotation.x = PI * 0.5
	n.add_child(fuselage)

	# Main Wings
	var wings := MeshInstance3D.new()
	var wb := BoxMesh.new()
	wb.size = Vector3(8.5, 0.12, 1.4)
	wb.material = white_mat
	wings.mesh = wb
	wings.position = Vector3(0.0, 0.15, 0.2)
	n.add_child(wings)

	# Cockpit Windshield
	var cockpit := MeshInstance3D.new()
	var cb := BoxMesh.new()
	cb.size = Vector3(0.65, 0.35, 0.8)
	cb.material = glass_mat
	cockpit.mesh = cb
	cockpit.position = Vector3(0.0, 0.45, 2.0)
	n.add_child(cockpit)

	# Vertical Tail Fin
	var fin := MeshInstance3D.new()
	var tb := BoxMesh.new()
	tb.size = Vector3(0.12, 1.4, 1.0)
	tb.material = blue_mat
	fin.mesh = tb
	fin.position = Vector3(0.0, 0.85, -2.6)
	n.add_child(fin)

	return n

# -----------------------------------------------------------------
# 3. MARINA YACHTS & BOATS
# -----------------------------------------------------------------
static func _populate_marina_boats(root: Node3D) -> void:
	for z in range(65, 84, 7):
		var boat1 := _build_yacht()
		_spawn_procedural(root, boat1, Vector3(-9.5, -0.32, float(z)), PI * 0.5)

		var boat2 := _build_yacht()
		_spawn_procedural(root, boat2, Vector3(1.5, -0.32, float(z)), -PI * 0.5)

static func _build_yacht() -> Node3D:
	var n := Node3D.new()
	var hull_mat := Constants.get_standard_material(Color(0.96, 0.96, 0.98), 0.3)
	var cabin_mat := Constants.get_standard_material(Color(0.92, 0.92, 0.94), 0.4)
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.5)

	var hull := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(2.0, 0.7, 5.5)
	hb.material = hull_mat
	hull.mesh = hb
	n.add_child(hull)

	var cabin := MeshInstance3D.new()
	var cb := BoxMesh.new()
	cb.size = Vector3(1.6, 0.6, 2.8)
	cb.material = cabin_mat
	cabin.mesh = cb
	cabin.position = Vector3(0.0, 0.55, -0.4)
	n.add_child(cabin)

	var ws := MeshInstance3D.new()
	var wsb := BoxMesh.new()
	wsb.size = Vector3(1.5, 0.35, 0.08)
	wsb.material = glass_mat
	ws.mesh = wsb
	ws.position = Vector3(0.0, 0.6, 1.02)
	n.add_child(ws)

	return n

# -----------------------------------------------------------------
# 4. BEACH UMBRELLAS & LOUNGERS
# -----------------------------------------------------------------
static func _populate_beach_props(root: Node3D) -> void:
	var umbrella_colors: Array[Color] = [
		Color(0.92, 0.25, 0.20),
		Color(0.20, 0.55, 0.92),
		Color(0.95, 0.85, 0.18),
		Color(0.25, 0.85, 0.45)
	]

	var locs: Array[Vector3] = [
		Vector3(44.0, 0.15, 62.0), Vector3(50.0, 0.15, 60.0), Vector3(56.0, 0.15, 62.0),
		Vector3(62.0, 0.15, 65.0), Vector3(68.0, 0.15, 68.0), Vector3(74.0, 0.15, 74.0),
		Vector3(46.0, 0.15, 68.0), Vector3(52.0, 0.15, 70.0), Vector3(58.0, 0.15, 74.0)
	]

	for i in range(locs.size()):
		var umb := _build_beach_umbrella(umbrella_colors[i % umbrella_colors.size()])
		_spawn_procedural(root, umb, locs[i], randf() * TAU)

static func _build_beach_umbrella(color: Color) -> Node3D:
	var n := Node3D.new()
	var pole_mat := Constants.get_standard_material(Color(0.85, 0.85, 0.88), 0.4)
	var canopy_mat := Constants.get_standard_material(color, 0.6)

	var pole := MeshInstance3D.new()
	var pb := CylinderMesh.new()
	pb.top_radius = 0.05
	pb.bottom_radius = 0.05
	pb.height = 2.2
	pb.material = pole_mat
	pole.mesh = pb
	pole.position = Vector3(0.0, 1.1, 0.0)
	n.add_child(pole)

	var canopy := MeshInstance3D.new()
	var cb := CylinderMesh.new()
	cb.top_radius = 0.08
	cb.bottom_radius = 1.4
	cb.height = 0.65
	cb.material = canopy_mat
	canopy.mesh = cb
	canopy.position = Vector3(0.0, 2.0, 0.0)
	n.add_child(canopy)

	return n

# -----------------------------------------------------------------
# 5. SEAPORT SHIPPING CONTAINERS (Imported 3D Models)
# -----------------------------------------------------------------
static func _populate_seaport_props(root: Node3D) -> void:
	var container_models: Array[PackedScene] = [MODEL_CONTAINER_A, MODEL_CONTAINER_B, MODEL_CONTAINER_C]
	var container_idx: int = 0
	for row in range(4):
		for col in range(3):
			var cx: float = 68.0 + col * 5.8
			var cz: float = -68.0 + row * 2.8
			var model: PackedScene = container_models[container_idx % container_models.size()]
			_spawn_model(root, model, Vector3(cx, 0.6, cz), 3.2, 0.0, 0.05)

			# Stacked second level container on select spots
			if (row + col) % 2 == 0:
				var model2: PackedScene = container_models[(container_idx + 1) % container_models.size()]
				_spawn_model(root, model2, Vector3(cx, 2.2, cz), 3.2, 0.0, 0.05)
			container_idx += 1

# -----------------------------------------------------------------
# 6. CENTRAL PARK PROPS & NATURE (Imported Trees & Benches)
# -----------------------------------------------------------------
static func _populate_central_park(root: Node3D) -> void:
	var gazebo := _build_gazebo()
	_spawn_procedural(root, gazebo, Vector3(-32.0, 0.0, -16.0), 0.0)

	var park_trees: Array[Vector3] = [
		Vector3(-34.0, 0.0, -36.0), Vector3(-20.0, 0.0, -36.0),
		Vector3(-35.0, 0.0, -26.0), Vector3(-14.0, 0.0, -26.0),
		Vector3(-34.0, 0.0, -8.0), Vector3(-18.0, 0.0, -8.0),
		Vector3(-28.0, 0.0, -5.0)
	]
	for pt in park_trees:
		_spawn_model(root, MODEL_TREE_OAK, pt, 2.0, randf() * TAU, 0.04)

	# Benches along park paths
	for z in [-34.0, -22.0, -10.0]:
		_spawn_model(root, MODEL_BENCH, Vector3(-35.0, 0.25, float(z)), 1.2, PI * 0.5, 0.03)

static func _build_gazebo() -> Node3D:
	var n := Node3D.new()
	var wood_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.6)
	var roof_mat := Constants.get_standard_material(Constants.COLOR_ROOF_TERRACOTTA, 0.7)

	var base := MeshInstance3D.new()
	var bm := CylinderMesh.new()
	bm.top_radius = 2.4
	bm.bottom_radius = 2.4
	bm.height = 0.3
	bm.material = wood_mat
	base.mesh = bm
	base.position = Vector3(0.0, 0.15, 0.0)
	n.add_child(base)

	for i in range(6):
		var angle := float(i) * TAU / 6.0
		var post := MeshInstance3D.new()
		var pb := CylinderMesh.new()
		pb.top_radius = 0.08
		pb.bottom_radius = 0.08
		pb.height = 2.5
		pb.material = wood_mat
		post.mesh = pb
		post.position = Vector3(cos(angle) * 2.0, 1.4, sin(angle) * 2.0)
		n.add_child(post)

	var roof := MeshInstance3D.new()
	var rm := CylinderMesh.new()
	rm.top_radius = 0.1
	rm.bottom_radius = 2.6
	rm.height = 1.4
	rm.material = roof_mat
	roof.mesh = rm
	roof.position = Vector3(0.0, 3.2, 0.0)
	n.add_child(roof)

	return n

# -----------------------------------------------------------------
# 7. MOUNTAIN EVERGREEN FOREST (Imported Pine Models)
# -----------------------------------------------------------------
static func _populate_mountain_forest(root: Node3D) -> void:
	var pine_locs: Array[Vector3] = [
		Vector3(-88.0, 2.5, -88.0), Vector3(-84.0, 2.5, -92.0), Vector3(-92.0, 2.5, -84.0),
		Vector3(-66.0, 2.5, -84.0), Vector3(-62.0, 2.5, -88.0), Vector3(-70.0, 2.5, -92.0),
		Vector3(-52.0, 2.5, -74.0), Vector3(-48.0, 2.5, -70.0), Vector3(-54.0, 2.5, -66.0),
		Vector3(-84.0, 2.0, -56.0), Vector3(-88.0, 2.0, -52.0), Vector3(-92.0, 2.0, -48.0),
		Vector3(-68.0, 5.0, -74.0), Vector3(-64.0, 5.0, -78.0), Vector3(-72.0, 5.0, -80.0)
	]

	for pl in pine_locs:
		_spawn_model(root, MODEL_TREE_PINE, pl, 2.2, randf() * TAU, 0.05)

# -----------------------------------------------------------------
# 8. SUBURBAN CARS & VEHICLES (Imported Car Models)
# -----------------------------------------------------------------
static func _populate_suburban_props(root: Node3D) -> void:
	var car_models: Array[PackedScene] = [MODEL_CAR_SEDAN, MODEL_CAR_SUV, MODEL_CAR_SPORTS, MODEL_CAR_TAXI]
	var street_z: Array[float] = [-32.0, -24.0, -16.0, -8.0, 0.0, 8.0, 16.0, 24.0]
	var car_idx: int = 0
	for z in street_z:
		var car_m := car_models[car_idx % car_models.size()]
		_spawn_model(root, car_m, Vector3(-82.0, 0.45, z), 1.1, 0.0, 0.08)
		car_idx += 1

# -----------------------------------------------------------------
# 9. DOWNTOWN PROMENADE & STREET TRAFFIC (Imported Cars & Benches)
# -----------------------------------------------------------------
static func _populate_downtown_props(root: Node3D) -> void:
	# Benches along Grand Central Promenade (X = 8.0)
	for z in [-34.0, -14.0, 14.0, 34.0]:
		_spawn_model(root, MODEL_BENCH, Vector3(6.2, 0.25, float(z)), 1.2, PI * 0.5, 0.03)

		var planter := _build_planter()
		_spawn_procedural(root, planter, Vector3(9.8, 0.35, float(z)), 0.0)

	# Vehicles on Downtown Avenues
	var street_cars: Array[Dictionary] = [
		{"pos": Vector3(-18.0, 0.6, -30.0), "model": MODEL_CAR_SEDAN, "rot": 0.0},
		{"pos": Vector3(-18.0, 0.6, 8.0), "model": MODEL_CAR_SPORTS, "rot": 0.0},
		{"pos": Vector3(34.0, 0.6, -28.0), "model": MODEL_CAR_SUV, "rot": PI},
		{"pos": Vector3(34.0, 0.6, 8.0), "model": MODEL_CAR_TAXI, "rot": PI},
		{"pos": Vector3(16.0, 0.6, -12.0), "model": MODEL_CAR_VAN, "rot": 0.0},
		{"pos": Vector3(0.0, 0.6, 16.0), "model": MODEL_CAR_POLICE, "rot": PI}
	]
	for sc in street_cars:
		_spawn_model(root, sc["model"], sc["pos"], 1.1, sc["rot"], 0.08)

# -----------------------------------------------------------------
# HELPER PRIMITIVE BUILDERS
# -----------------------------------------------------------------
static func _build_planter() -> Node3D:
	var n := Node3D.new()
	var pot_mat := Constants.get_standard_material(Color(0.68, 0.48, 0.36), 0.6)
	var plant_mat := Constants.get_standard_material(Constants.COLOR_GRASS, 0.8)

	var pot := MeshInstance3D.new()
	var pb := BoxMesh.new()
	pb.size = Vector3(0.85, 0.55, 0.85)
	pb.material = pot_mat
	pot.mesh = pb
	pot.position = Vector3(0.0, -0.05, 0.0)
	n.add_child(pot)

	var shrub := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 0.45
	sm.height = 0.65
	sm.material = plant_mat
	shrub.mesh = sm
	shrub.position = Vector3(0.0, 0.30, 0.0)
	n.add_child(shrub)

	return n

# -----------------------------------------------------------------
# SPAWNER HELPERS
# -----------------------------------------------------------------
static func _spawn_model(parent: Node3D, model_scene: PackedScene, pos: Vector3, scale_val: float, rot_y: float, growth: float) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_model(model_scene, scale_val)
	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 0.5
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5
	item.global_position = Vector3(pos.x, maxf(pos.y, half_h + 0.06), pos.z)
	item.rotation.y = rot_y
	item.set_meta("growth_value", growth)
	return item

static func _spawn_procedural(parent: Node3D, node: Node3D, pos: Vector3, rot_y: float) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_existing_node(node, 1.0)
	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 0.5
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5
	item.global_position = Vector3(pos.x, maxf(pos.y, half_h + 0.06), pos.z)
	item.rotation.y = rot_y
	item.set_meta("growth_value", 0.04)
	return item
