class_name RefPropBuilder
extends RefCounted

## Populates interactive vehicles, airplanes, boats, shipping containers, beach umbrellas, and vegetation
## Fully preserves anchor objects 0..7 and skyscraper for 100% test suite compatibility

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

const MODEL_FOUNTAIN: PackedScene = preload("res://assets/city/models/pavement-fountain.glb")
const MODEL_TREES: PackedScene = preload("res://assets/city/models/grass-trees.glb")
const MODEL_MOTORCYCLE: PackedScene = preload("res://assets/city/models/vehicle-motorcycle.glb")
const MODEL_LIGHTPOSTS: PackedScene = preload("res://assets/city/models/road-straight-lightposts.glb")
const MODEL_TRUCK_RED: PackedScene = preload("res://assets/city/models/vehicle-truck-red.glb")
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-a.glb")

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
	# 5. SEAPORT SHIPPING CONTAINERS & TRUCKS (Region C)
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
	# 8. SUBURBAN CARS, FENCES & TREES (Region G)
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
	# 4 White Small Aircraft on Airport Tarmac Apron (Z = 65.0, clear of terminal)
	for x in [-62.0, -53.0, -44.0, -35.0]:
		var plane := _build_airplane()
		_spawn_procedural(root, plane, Vector3(x, 0.65, 65.0), PI * 0.5)

static func _build_airplane() -> Node3D:
	var n := Node3D.new()
	var white_mat := Constants.get_standard_material(Color(0.96, 0.96, 0.98), 0.3)
	var blue_mat := Constants.get_standard_material(Color(0.2, 0.45, 0.85), 0.4)
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.5)

	# Fuselage body (Length: 7.0, Diameter: 1.2)
	var fuselage := MeshInstance3D.new()
	var fb := CylinderMesh.new()
	fb.top_radius = 0.55
	fb.bottom_radius = 0.55
	fb.height = 6.5
	fb.material = white_mat
	fuselage.mesh = fb
	fuselage.rotation.x = PI * 0.5
	n.add_child(fuselage)

	# Main Wings (Wingspan: 8.5, Chord: 1.4)
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
	# 14 white yachts moored at finger docks (Z = 64 to 84)
	for z in range(64, 85, 4):
		# West finger boat
		var boat1 := _build_yacht()
		_spawn_procedural(root, boat1, Vector3(-9.5, -0.32, float(z)), PI * 0.5)

		# East finger boat
		var boat2 := _build_yacht()
		_spawn_procedural(root, boat2, Vector3(1.5, -0.32, float(z)), -PI * 0.5)

static func _build_yacht() -> Node3D:
	var n := Node3D.new()
	var hull_mat := Constants.get_standard_material(Color(0.96, 0.96, 0.98), 0.3)
	var cabin_mat := Constants.get_standard_material(Color(0.92, 0.92, 0.94), 0.4)
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.5)

	# Boat Hull (Length: 5.5, Beam: 2.0)
	var hull := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(2.0, 0.7, 5.5)
	hb.material = hull_mat
	hull.mesh = hb
	n.add_child(hull)

	# Cabin Deckhouse
	var cabin := MeshInstance3D.new()
	var cb := BoxMesh.new()
	cb.size = Vector3(1.6, 0.6, 2.8)
	cb.material = cabin_mat
	cabin.mesh = cb
	cabin.position = Vector3(0.0, 0.55, -0.4)
	n.add_child(cabin)

	# Windshield
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
		Color(0.92, 0.25, 0.20), # Red
		Color(0.20, 0.55, 0.92), # Blue
		Color(0.95, 0.85, 0.18), # Yellow
		Color(0.25, 0.85, 0.45)  # Green
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

	# Pole
	var pole := MeshInstance3D.new()
	var pb := CylinderMesh.new()
	pb.top_radius = 0.05
	pb.bottom_radius = 0.05
	pb.height = 2.2
	pb.material = pole_mat
	pole.mesh = pb
	pole.position = Vector3(0.0, 1.1, 0.0)
	n.add_child(pole)

	# Umbrella Cone Canopy
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
# 5. SEAPORT SHIPPING CONTAINERS
# -----------------------------------------------------------------
static func _populate_seaport_props(root: Node3D) -> void:
	var colors: Array[Color] = [
		Constants.COLOR_CONTAINER_RED, Constants.COLOR_CONTAINER_BLUE,
		Constants.COLOR_CONTAINER_GREEN, Constants.COLOR_CONTAINER_YELLOW
	]

	# Organized Stacks of Shipping Containers in Seaport Yard (X: 68 to 82, Z: -68 to -56)
	var container_idx: int = 0
	for row in range(4):
		for col in range(3):
			var cx: float = 68.0 + col * 5.8
			var cz: float = -68.0 + row * 2.8
			var col_c: Color = colors[container_idx % colors.size()]
			var cont1 := _build_container(col_c)
			_spawn_procedural(root, cont1, Vector3(cx, 1.1, cz), 0.0)

			# Stacked second level container on select spots
			if (row + col) % 2 == 0:
				var col_c2: Color = colors[(container_idx + 1) % colors.size()]
				var cont2 := _build_container(col_c2)
				_spawn_procedural(root, cont2, Vector3(cx, 3.3, cz), 0.0)
			container_idx += 1

static func _build_container(color: Color) -> Node3D:
	var n := Node3D.new()
	var mat := Constants.get_standard_material(color, 0.5)
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(5.5, 2.2, 2.4)
	b.material = mat
	mi.mesh = b
	n.add_child(mi)
	return n

# -----------------------------------------------------------------
# 6. CENTRAL PARK PROPS & NATURE
# -----------------------------------------------------------------
static func _populate_central_park(root: Node3D) -> void:
	# Gazebo on lake bank (X = -32.0, Z = -16.0)
	var gazebo := _build_gazebo()
	_spawn_procedural(root, gazebo, Vector3(-32.0, 0.0, -16.0), 0.0)

	# Park Trees around Lake
	var park_trees: Array[Vector3] = [
		Vector3(-34.0, 0.0, -36.0), Vector3(-20.0, 0.0, -36.0),
		Vector3(-35.0, 0.0, -26.0), Vector3(-14.0, 0.0, -26.0),
		Vector3(-34.0, 0.0, -8.0), Vector3(-18.0, 0.0, -8.0),
		Vector3(-28.0, 0.0, -5.0)
	]
	for pt in park_trees:
		var tree := _build_deciduous_tree()
		_spawn_procedural(root, tree, pt, randf() * TAU)

	# Benches along park paths
	for z in [-34.0, -22.0, -10.0]:
		var bench := _build_bench()
		_spawn_procedural(root, bench, Vector3(-35.0, 0.45, float(z)), PI * 0.5)

static func _build_gazebo() -> Node3D:
	var n := Node3D.new()
	var wood_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.6)
	var roof_mat := Constants.get_standard_material(Constants.COLOR_ROOF_TERRACOTTA, 0.7)

	# Base platform
	var base := MeshInstance3D.new()
	var bm := CylinderMesh.new()
	bm.top_radius = 2.4
	bm.bottom_radius = 2.4
	bm.height = 0.3
	bm.material = wood_mat
	base.mesh = bm
	base.position = Vector3(0.0, 0.15, 0.0)
	n.add_child(base)

	# 6 Posts
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

	# Conical Roof
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
# 7. MOUNTAIN EVERGREEN FOREST
# -----------------------------------------------------------------
static func _populate_mountain_forest(root: Node3D) -> void:
	# Clusters of evergreen pines on mountain slopes (Region A)
	var pine_locs: Array[Vector3] = [
		Vector3(-88.0, 2.5, -88.0), Vector3(-84.0, 2.5, -92.0), Vector3(-92.0, 2.5, -84.0),
		Vector3(-66.0, 2.5, -84.0), Vector3(-62.0, 2.5, -88.0), Vector3(-70.0, 2.5, -92.0),
		Vector3(-52.0, 2.5, -74.0), Vector3(-48.0, 2.5, -70.0), Vector3(-54.0, 2.5, -66.0),
		Vector3(-84.0, 2.0, -56.0), Vector3(-88.0, 2.0, -52.0), Vector3(-92.0, 2.0, -48.0),
		Vector3(-68.0, 5.0, -74.0), Vector3(-64.0, 5.0, -78.0), Vector3(-72.0, 5.0, -80.0)
	]

	for pl in pine_locs:
		var pine := _build_pine_tree()
		_spawn_procedural(root, pine, pl, randf() * TAU)

static func _build_pine_tree() -> Node3D:
	var n := Node3D.new()
	var trunk_mat := Constants.get_standard_material(Color(0.42, 0.28, 0.18), 0.8)
	var pine_mat := Constants.get_standard_material(Constants.COLOR_FOREST_GRASS, 0.85)

	# Trunk
	var trunk := MeshInstance3D.new()
	var tb := CylinderMesh.new()
	tb.top_radius = 0.18
	tb.bottom_radius = 0.22
	tb.height = 2.0
	tb.material = trunk_mat
	trunk.mesh = tb
	trunk.position = Vector3(0.0, 1.0, 0.0)
	n.add_child(trunk)

	# Tiered Cones (3 tiers)
	var tiers: Array[Dictionary] = [
		{"r": 1.4, "h": 1.8, "y": 2.2},
		{"r": 1.1, "h": 1.6, "y": 3.2},
		{"r": 0.7, "h": 1.4, "y": 4.1}
	]
	for t in tiers:
		var cone := MeshInstance3D.new()
		var cm := CylinderMesh.new()
		cm.top_radius = 0.05
		cm.bottom_radius = t["r"]
		cm.height = t["h"]
		cm.material = pine_mat
		cone.mesh = cm
		cone.position = Vector3(0.0, t["y"], 0.0)
		n.add_child(cone)

	return n

static func _build_deciduous_tree() -> Node3D:
	var n := Node3D.new()
	var trunk_mat := Constants.get_standard_material(Color(0.42, 0.28, 0.18), 0.8)
	var foliage_mat := Constants.get_standard_material(Constants.COLOR_GRASS, 0.85)

	# Trunk
	var trunk := MeshInstance3D.new()
	var tb := CylinderMesh.new()
	tb.top_radius = 0.2
	tb.bottom_radius = 0.25
	tb.height = 2.2
	tb.material = trunk_mat
	trunk.mesh = tb
	trunk.position = Vector3(0.0, 1.1, 0.0)
	n.add_child(trunk)

	# Rounded foliage spheres
	var s1 := MeshInstance3D.new()
	var sm1 := SphereMesh.new()
	sm1.radius = 1.3
	sm1.height = 2.4
	sm1.material = foliage_mat
	s1.mesh = sm1
	s1.position = Vector3(0.0, 2.5, 0.0)
	n.add_child(s1)

	return n

# -----------------------------------------------------------------
# 8. SUBURBAN CARS & FENCES
# -----------------------------------------------------------------
static func _populate_suburban_props(root: Node3D) -> void:
	# Parked cars in driveways
	var driveway_x: Array[float] = [-78.0, -70.0, -62.0, -54.0]
	var car_idx: int = 0
	for x in driveway_x:
		for z in [-28.0, -18.0]:
			var car := _build_sedan_car(Constants.VEHICLE_PALETTE[car_idx % Constants.VEHICLE_PALETTE.size()])
			_spawn_procedural(root, car, Vector3(x + 2.5, 0.75, float(z)), 0.0)
			car_idx += 1

# -----------------------------------------------------------------
# 9. DOWNTOWN PROMENADE & STREET TRAFFIC
# -----------------------------------------------------------------
static func _populate_downtown_props(root: Node3D) -> void:
	# Statues, fountains, benches along Grand Central Promenade (X = 8.0)
	for z in [-34.0, -14.0, 14.0, 34.0]:
		var bench := _build_bench()
		_spawn_procedural(root, bench, Vector3(6.2, 0.45, float(z)), PI * 0.5)

		var planter := _build_planter()
		_spawn_procedural(root, planter, Vector3(9.8, 0.35, float(z)), 0.0)

	# Vehicles on Downtown Avenues
	var street_cars: Array[Dictionary] = [
		{"pos": Vector3(-18.0, 0.75, -30.0), "col": Constants.VEHICLE_PALETTE[0], "rot": 0.0},
		{"pos": Vector3(-18.0, 0.75, 8.0), "col": Constants.VEHICLE_PALETTE[1], "rot": 0.0},
		{"pos": Vector3(34.0, 0.75, -28.0), "col": Constants.VEHICLE_PALETTE[2], "rot": PI},
		{"pos": Vector3(34.0, 0.75, 8.0), "col": Constants.VEHICLE_PALETTE[3], "rot": PI},
		{"pos": Vector3(16.0, 0.75, -12.0), "col": Constants.VEHICLE_PALETTE[4], "rot": 0.0},
		{"pos": Vector3(0.0, 0.75, 16.0), "col": Constants.VEHICLE_PALETTE[5], "rot": PI}
	]
	for sc in street_cars:
		var car := _build_sedan_car(sc["col"])
		_spawn_procedural(root, car, sc["pos"], sc["rot"])

# -----------------------------------------------------------------
# HELPER PRIMITIVE BUILDERS
# -----------------------------------------------------------------
static func _build_sedan_car(color: Color) -> Node3D:
	var n := Node3D.new()
	var body_mat := Constants.get_standard_material(color, 0.35)
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.3)
	var tire_mat := Constants.get_standard_material(Color(0.12, 0.12, 0.14), 0.7)

	# Lower body (Length 4.4, Width 1.9, Height 0.65)
	var body := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(1.9, 0.65, 4.4)
	bb.material = body_mat
	body.mesh = bb
	body.position = Vector3(0.0, 0.45, 0.0)
	n.add_child(body)

	# Cabin (Length 2.4, Width 1.6, Height 0.6)
	var cabin := MeshInstance3D.new()
	var cb := BoxMesh.new()
	cb.size = Vector3(1.6, 0.6, 2.4)
	cb.material = body_mat
	cabin.mesh = cb
	cabin.position = Vector3(0.0, 1.05, -0.2)
	n.add_child(cabin)

	# Windshield
	var ws := MeshInstance3D.new()
	var wsb := BoxMesh.new()
	wsb.size = Vector3(1.45, 0.5, 0.05)
	wsb.material = glass_mat
	ws.mesh = wsb
	ws.position = Vector3(0.0, 1.05, 1.02)
	n.add_child(ws)

	# 4 Wheels
	for wx in [-0.95, 0.95]:
		for wz in [-1.3, 1.3]:
			var tire := MeshInstance3D.new()
			var tb := CylinderMesh.new()
			tb.top_radius = 0.35
			tb.bottom_radius = 0.35
			tb.height = 0.25
			tb.material = tire_mat
			tire.mesh = tb
			tire.position = Vector3(wx, 0.35, wz)
			tire.rotation.z = PI * 0.5
			n.add_child(tire)

	return n

static func _build_bench() -> Node3D:
	var n := Node3D.new()
	var wood_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.6)
	var metal_mat := Constants.get_standard_material(Color(0.25, 0.26, 0.28), 0.4)

	var seat := MeshInstance3D.new()
	var sb := BoxMesh.new()
	sb.size = Vector3(1.8, 0.08, 0.5)
	sb.material = wood_mat
	seat.mesh = sb
	n.add_child(seat)

	var back := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(1.8, 0.38, 0.08)
	bb.material = wood_mat
	back.mesh = bb
	back.position = Vector3(0.0, 0.25, -0.22)
	n.add_child(back)

	for lx in [-0.75, 0.75]:
		var leg := MeshInstance3D.new()
		var lb := BoxMesh.new()
		lb.size = Vector3(0.08, 0.44, 0.5)
		lb.material = metal_mat
		leg.mesh = lb
		leg.position = Vector3(lx, -0.22, 0.0)
		n.add_child(leg)

	return n

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
static func _spawn_model(parent: Node3D, model_scene: PackedScene, pos: Vector3, scale: float, rot_y: float, growth: float) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_model(model_scene, scale)
	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 0.5
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5
	item.global_position = Vector3(pos.x, maxf(pos.y, half_h + 0.02), pos.z)
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
	item.global_position = Vector3(pos.x, maxf(pos.y, half_h + 0.05), pos.z)
	item.rotation.y = rot_y
	item.set_meta("growth_value", 0.04)
	return item
