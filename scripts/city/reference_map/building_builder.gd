class_name RefBuildingBuilder
extends RefCounted

## Builds all 3D architectural structures, skyscrapers, houses, warehouses, airport, and landmarks
## Fully powered by imported low-poly 3D assets from Kenney City collections
## All buildings and houses are unattached physics Collectibles that can fall into the hole!

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")
const COLLECTIBLE_SCENE: PackedScene = preload("res://scenes/collectible.tscn")

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: COMMERCIAL & SKYSCRAPERS
# -----------------------------------------------------------------
const MODEL_SKYSCRAPER_A: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-a.glb")
const MODEL_SKYSCRAPER_B: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-b.glb")
const MODEL_SKYSCRAPER_C: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-c.glb")
const MODEL_SKYSCRAPER_D: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-d.glb")
const MODEL_SKYSCRAPER_E: PackedScene = preload("res://assets/kenney_city/commercial/building-skyscraper-e.glb")

const MODEL_COMM_D: PackedScene = preload("res://assets/kenney_city/commercial/building-d.glb")
const MODEL_COMM_F: PackedScene = preload("res://assets/kenney_city/commercial/building-f.glb")
const MODEL_COMM_H: PackedScene = preload("res://assets/kenney_city/commercial/building-h.glb")
const MODEL_COMM_J: PackedScene = preload("res://assets/kenney_city/commercial/building-j.glb")
const MODEL_COMM_K: PackedScene = preload("res://assets/kenney_city/commercial/building-k.glb")
const MODEL_COMM_M: PackedScene = preload("res://assets/kenney_city/commercial/building-m.glb")
const MODEL_COMM_WIDE_A: PackedScene = preload("res://assets/kenney_city/commercial/low-detail-building-wide-a.glb")
const MODEL_COMM_WIDE_B: PackedScene = preload("res://assets/kenney_city/commercial/low-detail-building-wide-b.glb")
const MODEL_GAS_STATION: PackedScene = preload("res://assets/city/models/building-small-c.glb")

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: SUBURBAN RESIDENTIAL HOUSES (21 UNIQUE VARIETIES)
# -----------------------------------------------------------------
const SUBURBAN_MODELS: Array[PackedScene] = [
	preload("res://assets/kenney_city/suburban/building-type-a.glb"),
	preload("res://assets/kenney_city/suburban/building-type-b.glb"),
	preload("res://assets/kenney_city/suburban/building-type-c.glb"),
	preload("res://assets/kenney_city/suburban/building-type-d.glb"),
	preload("res://assets/kenney_city/suburban/building-type-e.glb"),
	preload("res://assets/kenney_city/suburban/building-type-f.glb"),
	preload("res://assets/kenney_city/suburban/building-type-g.glb"),
	preload("res://assets/kenney_city/suburban/building-type-h.glb"),
	preload("res://assets/kenney_city/suburban/building-type-i.glb"),
	preload("res://assets/kenney_city/suburban/building-type-j.glb"),
	preload("res://assets/kenney_city/suburban/building-type-k.glb"),
	preload("res://assets/kenney_city/suburban/building-type-l.glb"),
	preload("res://assets/kenney_city/suburban/building-type-m.glb"),
	preload("res://assets/kenney_city/suburban/building-type-n.glb"),
	preload("res://assets/kenney_city/suburban/building-type-o.glb"),
	preload("res://assets/kenney_city/suburban/building-type-p.glb"),
	preload("res://assets/kenney_city/suburban/building-type-q.glb"),
	preload("res://assets/kenney_city/suburban/building-type-r.glb"),
	preload("res://assets/kenney_city/suburban/building-type-s.glb"),
	preload("res://assets/kenney_city/suburban/building-type-t.glb"),
	preload("res://assets/kenney_city/suburban/building-type-u.glb")
]

# -----------------------------------------------------------------
# PRELOADED 3D ASSETS: INDUSTRIAL SEAPORT & AIRPORT
# -----------------------------------------------------------------
const MODEL_IND_A: PackedScene = preload("res://assets/kenney_city/industrial/building-a.glb")
const MODEL_IND_B: PackedScene = preload("res://assets/kenney_city/industrial/building-b.glb")
const MODEL_IND_C: PackedScene = preload("res://assets/kenney_city/industrial/building-c.glb")
const MODEL_IND_D: PackedScene = preload("res://assets/kenney_city/industrial/building-d.glb")
const MODEL_IND_TANK_LARGE: PackedScene = preload("res://assets/kenney_city/industrial/detail-tank-large.glb")

static func build_all_buildings(collectibles_root: Node3D, arena_node: Node3D) -> void:
	# 1. Downtown Skyscrapers, Modern Towers & Mid-Rises (Region D)
	_build_downtown_skyscrapers(collectibles_root)

	# 2. Suburban Residential Neighborhood Houses (Region G)
	_build_suburban_houses(collectibles_root)

	# 3. Northern Industrial Seaport, Cargo Ships & Warehouses (Region C)
	_build_industrial_seaport(collectibles_root, arena_node)

	# 4. Airport Terminal, Control Tower & Hangars (Region J)
	_build_airport_complex(collectibles_root, arena_node)

	# 5. Mountain Peak Observatory (Region A)
	_build_mountain_observatory(arena_node)

	# 6. School / Civic Center (Region I)
	_build_civic_complex(collectibles_root)

	# 7. Marina Yacht Club & Waterfront Hotel (Region M)
	_build_marina_structures(collectibles_root, arena_node)

	# 8. Pleasure Pier Amusement Carousel & Carnival Stalls (Region L)
	_build_pier_amusements(arena_node)

# -----------------------------------------------------------------
# 1. DOWNTOWN SKYSCRAPERS & TOWERS (Region D - Unattached Collectibles)
# -----------------------------------------------------------------
static func _build_downtown_skyscrapers(root: Node3D) -> void:
	# Major Icon Towers using imported Kenney Skyscraper models:
	# 1. Central Spire Skyscraper (West Column North: X = -13.5, Z = -32.0, Height ~20.0)
	_spawn_building_collectible(root, MODEL_SKYSCRAPER_C, Vector3(-13.5, 0.0, -32.0), 4.2, 0.0, 0.60)

	# 2. Stepped Corporate Mid-Rise (East Column North: X = 25.0, Z = -32.0, Height ~18.0)
	_spawn_building_collectible(root, MODEL_SKYSCRAPER_B, Vector3(25.0, 0.0, -32.0), 4.2, 0.0, 0.55)

	# 3. Modern Diamond/Angled Glass Tower (Far East Column North: X = 42.5, Z = -32.0, Height ~22.0)
	_spawn_building_collectible(root, MODEL_SKYSCRAPER_E, Vector3(42.5, 0.0, -32.0), 4.0, 0.0, 0.60)

	# 4. Twin High-Rise Tower West (West Column South: X = -13.5, Z = 29.0, Height ~16.0)
	_spawn_building_collectible(root, MODEL_SKYSCRAPER_D, Vector3(-13.5, 0.0, 29.0), 4.0, 0.0, 0.50)

	# 5. Twin High-Rise Tower East (East Column South: X = 25.0, Z = 29.0, Height ~15.5)
	_spawn_building_collectible(root, MODEL_SKYSCRAPER_A, Vector3(25.0, 0.0, 29.0), 4.0, 0.0, 0.50)

	# Downtown Surrounding Mid-Rises using imported Commercial Models:
	var midrises: Array[Dictionary] = [
		{"pos": Vector3(-13.5, 0.0, -8.0), "scene": MODEL_COMM_D, "scale": 3.6, "rot": 0.0},
		{"pos": Vector3(25.0, 0.0, -8.0), "scene": MODEL_COMM_F, "scale": 3.6, "rot": PI},
		{"pos": Vector3(42.5, 0.0, -8.0), "scene": MODEL_COMM_H, "scale": 3.6, "rot": 0.0},
		{"pos": Vector3(-13.5, 0.0, 4.0), "scene": MODEL_COMM_J, "scale": 3.6, "rot": 0.0},
		{"pos": Vector3(25.0, 0.0, 4.0), "scene": MODEL_COMM_K, "scale": 3.6, "rot": PI},
		{"pos": Vector3(42.5, 0.0, 4.0), "scene": MODEL_COMM_M, "scale": 3.6, "rot": 0.0}
	]

	for mr in midrises:
		_spawn_building_collectible(root, mr["scene"], mr["pos"], mr["scale"], mr["rot"], 0.35)

	# North-Central Big Box Supermarket (X = 8.0, Z = -57.0)
	_spawn_building_collectible(root, MODEL_COMM_WIDE_A, Vector3(8.0, 0.0, -57.0), 9.0, 0.0, 0.45)

	# Northern Gas Station / Retail (X = -12.0, Z = -57.0)
	_spawn_building_collectible(root, MODEL_GAS_STATION, Vector3(-12.0, 0.0, -57.0), 5.5, 0.0, 0.20)

# -----------------------------------------------------------------
# 2. SUBURBAN RESIDENTIAL HOUSES (Region G - Unattached Collectibles)
# -----------------------------------------------------------------
static func _build_suburban_houses(root: Node3D) -> void:
	# 24 suburban houses arranged in residential rows
	var house_locs: Array[Vector3] = []
	# North suburban rows (Z = -36.0, -28.0, -20.0, -12.0, -4.0)
	for z in [-36.0, -28.0, -20.0, -12.0, -4.0]:
		for x in [-78.0, -70.0, -62.0, -54.0]:
			house_locs.append(Vector3(x, 0.0, z))

	# South suburban rows (west of stadium: X = -78.0, -70.0, Z = 24.0, 36.0)
	for z in [24.0, 36.0]:
		for x in [-78.0, -70.0]:
			house_locs.append(Vector3(x, 0.0, z))

	for i in range(house_locs.size()):
		var model_scene := SUBURBAN_MODELS[i % SUBURBAN_MODELS.size()]
		var pos := house_locs[i]
		var rot: float = 0.0 if (i % 2 == 0) else PI
		_spawn_building_collectible(root, model_scene, pos, 4.5, rot, 0.15)

# -----------------------------------------------------------------
# 3. NORTHERN INDUSTRIAL SEAPORT & SHIPS (Region C)
# -----------------------------------------------------------------
static func _build_industrial_seaport(collectibles_root: Node3D, arena_node: Node3D) -> void:
	var port := Node3D.new()
	port.name = "IndustrialSeaport"
	arena_node.add_child(port)

	# Cargo Ship 1 (East quay, facing North: X = 94.0, Z = -52.0)
	_build_cargo_ship(port, "CargoShip_East", Vector3(94.0, -0.2, -52.0), Vector3(9.0, 7.5, 32.0), true)

	# Cargo Ship 2 (North quay, facing East: X = 82.0, Z = -86.0)
	_build_cargo_ship(port, "CargoShip_North", Vector3(82.0, -0.2, -86.0), Vector3(28.0, 7.0, 8.5), false)

	# Industrial Warehouses as unattached collectibles
	_spawn_building_collectible(collectibles_root, MODEL_IND_A, Vector3(64.0, 0.0, -82.0), 5.5, 0.0, 0.35)
	_spawn_building_collectible(collectibles_root, MODEL_IND_B, Vector3(48.0, 0.0, -54.0), 5.0, 0.0, 0.30)
	_spawn_building_collectible(collectibles_root, MODEL_IND_C, Vector3(82.0, 0.0, -48.0), 4.8, 0.0, 0.30)

	# Fuel Storage Tank Farm
	var tank_locs: Array[Vector3] = [
		Vector3(38.0, 0.0, -80.0), Vector3(46.0, 0.0, -80.0),
		Vector3(38.0, 0.0, -72.0), Vector3(46.0, 0.0, -72.0)
	]
	for tl in tank_locs:
		_spawn_building_collectible(collectibles_root, MODEL_IND_TANK_LARGE, tl, 3.8, 0.0, 0.20)

	# Cargo Gantry Cranes along East Quay
	_build_cargo_crane(port, Vector3(88.0, 0.0, -62.0))
	_build_cargo_crane(port, Vector3(88.0, 0.0, -40.0))

# -----------------------------------------------------------------
# 4. AIRPORT TERMINAL & HANGARS (Region J)
# -----------------------------------------------------------------
static func _build_airport_complex(collectibles_root: Node3D, arena_node: Node3D) -> void:
	# Passenger Terminal as unattached collectible
	_spawn_building_collectible(collectibles_root, MODEL_COMM_WIDE_B, Vector3(-56.0, 0.0, 52.0), 8.5, 0.0, 0.40)

	# Air Traffic Control Tower (ATCT) (X = -42.0, Z = 48.0, Height = 18.0)
	var tower := StaticBody3D.new()
	tower.name = "AirTrafficControlTower"
	tower.position = Vector3(-42.0, 0.0, 48.0)
	arena_node.add_child(tower)

	var col_mi := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = 1.6
	cm.bottom_radius = 2.0
	cm.height = 16.0
	cm.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.3)
	col_mi.mesh = cm
	col_mi.position = Vector3(0.0, 8.0, 0.0)
	tower.add_child(col_mi)

	var tow_col := CollisionShape3D.new()
	var tow_cs := CylinderShape3D.new()
	tow_cs.radius = 1.8
	tow_cs.height = 16.0
	tow_col.shape = tow_cs
	tow_col.position = Vector3(0.0, 8.0, 0.0)
	tower.add_child(tow_col)

	var cab := MeshInstance3D.new()
	var cbm := CylinderMesh.new()
	cbm.top_radius = 2.8
	cbm.bottom_radius = 2.4
	cbm.height = 2.8
	cbm.material = Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.1, 0.5)
	cab.mesh = cbm
	cab.position = Vector3(0.0, 16.8, 0.0)
	tower.add_child(cab)

	var radome := MeshInstance3D.new()
	var rm := SphereMesh.new()
	rm.radius = 1.2
	rm.height = 1.6
	rm.material = Constants.get_standard_material(Color(0.96, 0.96, 0.96), 0.2)
	radome.mesh = rm
	radome.position = Vector3(0.0, 18.8, 0.0)
	tower.add_child(radome)

	# Two Large Aircraft Hangars as unattached collectibles
	for hx in [-84.0, -70.0]:
		_spawn_building_collectible(collectibles_root, MODEL_IND_D, Vector3(hx, 0.0, 52.0), 5.5, 0.0, 0.35)

# -----------------------------------------------------------------
# 5. MOUNTAIN OBSERVATORY (Region A)
# -----------------------------------------------------------------
static func _build_mountain_observatory(root: Node3D) -> void:
	var obs := StaticBody3D.new()
	obs.name = "MountainObservatory"
	obs.position = Vector3(-76.0, 13.0, -84.0)
	root.add_child(obs)

	# Main Base Building (White concrete)
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(12.0, 4.0, 10.0)
	b.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.3)
	mi.mesh = b
	mi.position = Vector3(0.0, 2.0, 0.0)
	obs.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = Vector3(12.0, 4.0, 10.0)
	col.shape = cs
	col.position = Vector3(0.0, 2.0, 0.0)
	obs.add_child(col)

	# Telescope Dome
	var dome := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 3.2
	sm.height = 4.5
	sm.material = Constants.get_standard_material(Color(0.88, 0.90, 0.94), 0.2, 0.4)
	dome.mesh = sm
	dome.position = Vector3(0.0, 4.8, 0.0)
	obs.add_child(dome)

# -----------------------------------------------------------------
# 6. CIVIC COMPLEX & SCHOOL (Region I)
# -----------------------------------------------------------------
static func _build_civic_complex(collectibles_root: Node3D) -> void:
	_spawn_building_collectible(collectibles_root, MODEL_COMM_WIDE_A, Vector3(-38.0, 0.0, 18.0), 6.5, 0.0, 0.35)

# -----------------------------------------------------------------
# 7. MARINA STRUCTURES (Region M)
# -----------------------------------------------------------------
static func _build_marina_structures(collectibles_root: Node3D, arena_node: Node3D) -> void:
	# Octagonal Yacht Club
	var club := StaticBody3D.new()
	club.position = Vector3(14.0, 0.0, 58.0)
	arena_node.add_child(club)

	var mi := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = 5.2
	cm.bottom_radius = 5.2
	cm.height = 5.5
	cm.radial_segments = 8
	cm.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.3)
	mi.mesh = cm
	mi.position = Vector3(0.0, 2.75, 0.0)
	club.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := CylinderShape3D.new()
	cs.radius = 5.2
	cs.height = 5.5
	col.shape = cs
	col.position = Vector3(0.0, 2.75, 0.0)
	club.add_child(col)

	# Waterfront Hotel / Apartments as unattached collectible
	_spawn_building_collectible(collectibles_root, MODEL_COMM_WIDE_A, Vector3(-2.0, 0.0, 54.0), 6.5, 0.0, 0.35)

# -----------------------------------------------------------------
# 8. PLEASURE PIER AMUSEMENTS & CAROUSEL (Region L)
# -----------------------------------------------------------------
static func _build_pier_amusements(root: Node3D) -> void:
	var carousel := Node3D.new()
	carousel.name = "PierCarousel"
	carousel.position = Vector3(60.0, 0.3, 86.0)
	root.add_child(carousel)

	var base := MeshInstance3D.new()
	var bm := CylinderMesh.new()
	bm.top_radius = 4.5
	bm.bottom_radius = 4.8
	bm.height = 0.5
	bm.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.5)
	base.mesh = bm
	base.position = Vector3(0.0, 0.25, 0.0)
	carousel.add_child(base)

	var spindle := MeshInstance3D.new()
	var sm := CylinderMesh.new()
	sm.top_radius = 0.6
	sm.bottom_radius = 0.6
	sm.height = 4.2
	sm.material = Constants.get_standard_material(Color(0.85, 0.75, 0.2), 0.3)
	spindle.mesh = sm
	spindle.position = Vector3(0.0, 2.1, 0.0)
	carousel.add_child(spindle)

	var canopy := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = 0.1
	cm.bottom_radius = 5.0
	cm.height = 2.5
	cm.material = Constants.get_standard_material(Color(0.88, 0.18, 0.15), 0.4)
	canopy.mesh = cm
	canopy.position = Vector3(0.0, 4.8, 0.0)
	carousel.add_child(canopy)

# -----------------------------------------------------------------
# SPAWNER & HELPER FUNCTIONS
# -----------------------------------------------------------------
static func _spawn_building_collectible(parent: Node3D, model_scene: PackedScene, pos: Vector3, scale_val: float, rot_y: float = 0.0, growth: float = 0.25) -> Collectible:
	var item := COLLECTIBLE_SCENE.instantiate() as Collectible
	parent.add_child(item)
	item.setup_model(model_scene, scale_val)
	var col_shape := item.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_h: float = 2.0
	if col_shape and col_shape.shape is BoxShape3D:
		half_h = (col_shape.shape as BoxShape3D).size.y * 0.5
	item.global_position = Vector3(pos.x, maxf(pos.y, half_h + 0.06), pos.z)
	item.rotation.y = rot_y
	item.set_meta("growth_value", growth)
	return item

static func _build_cargo_ship(parent: Node3D, name: String, pos: Vector3, size: Vector3, is_north_south: bool) -> StaticBody3D:
	var ship := StaticBody3D.new()
	ship.name = name
	ship.position = pos
	parent.add_child(ship)

	var hull := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(size.x, size.y * 0.6, size.z)
	hb.material = Constants.get_standard_material(Color(0.12, 0.18, 0.28), 0.5)
	hull.mesh = hb
	hull.position = Vector3(0.0, size.y * 0.3, 0.0)
	ship.add_child(hull)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = size
	col.shape = cs
	col.position = Vector3(0.0, size.y * 0.5, 0.0)
	ship.add_child(col)

	var bridge := MeshInstance3D.new()
	var bb := BoxMesh.new()
	var bridge_l := size.z * 0.22 if is_north_south else size.x * 0.22
	var bridge_w := size.x * 0.85 if is_north_south else size.z * 0.85
	bb.size = Vector3(bridge_w, size.y * 0.8, bridge_l) if is_north_south else Vector3(bridge_l, size.y * 0.8, bridge_w)
	bb.material = Constants.get_standard_material(Color(0.94, 0.94, 0.96), 0.3)
	bridge.mesh = bb
	var b_offset := size.z * 0.35 if is_north_south else size.x * 0.35
	bridge.position = Vector3(0.0, size.y * 0.8, b_offset) if is_north_south else Vector3(b_offset, size.y * 0.8, 0.0)
	ship.add_child(bridge)

	var colors: Array[Color] = [Constants.COLOR_CONTAINER_RED, Constants.COLOR_CONTAINER_BLUE, Constants.COLOR_CONTAINER_GREEN, Constants.COLOR_CONTAINER_YELLOW]
	for i in range(6):
		var c_mesh := MeshInstance3D.new()
		var cb := BoxMesh.new()
		cb.size = Vector3(2.4, 2.2, 5.5) if is_north_south else Vector3(5.5, 2.2, 2.4)
		cb.material = Constants.get_standard_material(colors[i % colors.size()], 0.5)
		c_mesh.mesh = cb
		var cz: float = (-size.z * 0.28 + i * 2.8) if is_north_south else 0.0
		var cx: float = 0.0 if is_north_south else (-size.x * 0.28 + i * 2.8)
		c_mesh.position = Vector3(cx, size.y * 0.6 + 1.1, cz)
		ship.add_child(c_mesh)

	return ship

static func _build_cargo_crane(parent: Node3D, pos: Vector3) -> void:
	var crane := StaticBody3D.new()
	crane.position = pos
	parent.add_child(crane)

	var crane_mat := Constants.get_standard_material(Color(0.92, 0.72, 0.15), 0.4)

	for side in [-2.5, 2.5]:
		var leg := MeshInstance3D.new()
		var lb := BoxMesh.new()
		lb.size = Vector3(0.5, 12.0, 0.5)
		lb.material = crane_mat
		leg.mesh = lb
		leg.position = Vector3(side, 6.0, 0.0)
		crane.add_child(leg)

	var boom := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(14.0, 0.8, 1.2)
	bb.material = crane_mat
	boom.mesh = bb
	boom.position = Vector3(2.5, 12.0, 0.0)
	crane.add_child(boom)
