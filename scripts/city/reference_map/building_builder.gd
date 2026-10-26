class_name RefBuildingBuilder
extends RefCounted

## Builds all 3D architectural structures, skyscrapers, houses, warehouses, airport, and landmarks
## Accurately reflects the reference image skyline and district distributions

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

static func build_all_buildings(parent_node: Node3D) -> void:
	var buildings_root := Node3D.new()
	buildings_root.name = "ReferenceBuildings"
	parent_node.add_child(buildings_root)

	# 1. Downtown Skyscrapers, Modern Towers & Mid-Rises (Region D)
	_build_downtown_skyscrapers(buildings_root)

	# 2. Suburban Residential Neighborhood Houses (Region G)
	_build_suburban_houses(buildings_root)

	# 3. Northern Industrial Seaport, Cargo Ships & Warehouses (Region C)
	_build_industrial_seaport(buildings_root)

	# 4. Airport Terminal, Control Tower & Hangars (Region J)
	_build_airport_complex(buildings_root)

	# 5. Mountain Peak Observatory (Region A)
	_build_mountain_observatory(buildings_root)

	# 6. School / Civic Center (Region I)
	_build_civic_complex(buildings_root)

	# 7. Marina Yacht Club & Waterfront Hotel (Region M)
	_build_marina_structures(buildings_root)

	# 8. Pleasure Pier Amusement Carousel & Carnival Stalls (Region L)
	_build_pier_amusements(buildings_root)

# -----------------------------------------------------------------
# 1. DOWNTOWN SKYSCRAPERS & TOWERS (Region D)
# -----------------------------------------------------------------
static func _build_downtown_skyscrapers(root: Node3D) -> void:
	var dt := Node3D.new()
	dt.name = "DowntownSkyscrapers"
	root.add_child(dt)

	# Six Major Icon Towers in the Central Core:
	# 1. Central Communications Tower with Spire (West Column North: X = -9.0, Z = -32.0, Height = 24.0)
	_build_tower(dt, "Tower_Central_Spire", Vector3(-9.0, 0.0, -32.0), Vector3(7.5, 24.0, 10.0),
		Constants.COLOR_BUILDING_WHITE, 7, true)

	# 2. Stepped Corporate Mid-Rise (East Column North: X = 25.0, Z = -32.0, Height = 20.0)
	_build_tower(dt, "Tower_North_Stepped", Vector3(25.0, 0.0, -32.0), Vector3(7.5, 20.0, 10.0),
		Constants.COLOR_BUILDING_OFFWHITE, 6, false)

	# 3. Modern Diamond/Angled Glass Tower (Far East Column North: X = 42.5, Z = -32.0, Height = 26.0)
	_build_tower(dt, "Tower_East_Glass", Vector3(42.5, 0.0, -32.0), Vector3(7.0, 26.0, 10.0),
		Constants.COLOR_BUILDING_PALE_BLUE, 8, false)

	# 4. Twin High-Rise Tower West (West Column South: X = -9.0, Z = 29.0, Height = 18.0)
	_build_tower(dt, "Tower_Twin_West", Vector3(-9.0, 0.0, 29.0), Vector3(7.5, 18.0, 10.0),
		Constants.COLOR_BUILDING_WHITE, 5, false)

	# 5. Twin High-Rise Tower East (East Column South: X = 25.0, Z = 29.0, Height = 17.0)
	_build_tower(dt, "Tower_Twin_East", Vector3(25.0, 0.0, 29.0), Vector3(7.5, 17.0, 10.0),
		Constants.COLOR_BUILDING_PALE_BLUE, 5, false)

	# Downtown Surrounding Mid-Rises:
	var midrises: Array[Dictionary] = [
		{"pos": Vector3(-9.0, 0.0, -8.0), "size": Vector3(7.5, 13.0, 8.0), "col": Constants.COLOR_BUILDING_OFFWHITE, "fl": 4},
		{"pos": Vector3(25.0, 0.0, -8.0), "size": Vector3(7.5, 14.0, 8.0), "col": Constants.COLOR_BUILDING_PALE_BLUE, "fl": 4},
		{"pos": Vector3(42.5, 0.0, -8.0), "size": Vector3(7.0, 12.0, 8.0), "col": Constants.COLOR_BUILDING_WHITE, "fl": 4},
		{"pos": Vector3(-9.0, 0.0, 3.5), "size": Vector3(7.5, 12.0, 8.0), "col": Constants.COLOR_BUILDING_GREY, "fl": 4},
		{"pos": Vector3(25.0, 0.0, 3.5), "size": Vector3(7.5, 13.0, 8.0), "col": Constants.COLOR_BUILDING_OFFWHITE, "fl": 4},
		{"pos": Vector3(42.5, 0.0, 3.5), "size": Vector3(7.0, 12.0, 8.0), "col": Constants.COLOR_BUILDING_PALE_BLUE, "fl": 4},
		# North-Central Big Box Supermarket & Shopping Complex (X = 8.0, Z = -57.0)
		{"pos": Vector3(8.0, 0.0, -57.0), "size": Vector3(24.0, 7.5, 10.0), "col": Constants.COLOR_BUILDING_WHITE, "fl": 2},
		# Northern Gas Station / Retail (X = -12.0, Z = -57.0)
		{"pos": Vector3(-12.0, 0.0, -57.0), "size": Vector3(8.0, 5.5, 8.0), "col": Constants.COLOR_BUILDING_CREAM, "fl": 1}
	]

	for mr in midrises:
		_build_tower(dt, "MidRise_" + str(mr["pos"].x), mr["pos"], mr["size"], mr["col"], mr["fl"], false)

# -----------------------------------------------------------------
# 2. SUBURBAN RESIDENTIAL HOUSES (Region G)
# -----------------------------------------------------------------
static func _build_suburban_houses(root: Node3D) -> void:
	var sub := Node3D.new()
	sub.name = "SuburbanHouses"
	root.add_child(sub)

	# 24 suburban houses arranged in residential rows
	var house_configs: Array[Dictionary] = []
	# North suburban rows (Z = -32.0, -24.0, -14.0, -4.0)
	for x in [-78.0, -70.0, -62.0, -54.0]:
		house_configs.append({"pos": Vector3(x, 0.0, -32.0), "roof": Constants.COLOR_ROOF_TERRACOTTA, "wall": Constants.COLOR_BUILDING_CREAM})
		house_configs.append({"pos": Vector3(x, 0.0, -24.0), "roof": Constants.COLOR_ROOF_BLUE, "wall": Constants.COLOR_BUILDING_WHITE})
		house_configs.append({"pos": Vector3(x, 0.0, -14.0), "roof": Constants.COLOR_ROOF_CHARCOAL, "wall": Constants.COLOR_BUILDING_OFFWHITE})
		house_configs.append({"pos": Vector3(x, 0.0, -4.0), "roof": Constants.COLOR_ROOF_BROWN, "wall": Constants.COLOR_BUILDING_CREAM})

	# South suburban rows (near stadium: Z = 24.0, 36.0)
	for x in [-78.0, -70.0]:
		house_configs.append({"pos": Vector3(x, 0.0, 24.0), "roof": Constants.COLOR_ROOF_TERRACOTTA, "wall": Constants.COLOR_BUILDING_WHITE})
		house_configs.append({"pos": Vector3(x, 0.0, 36.0), "roof": Constants.COLOR_ROOF_BLUE, "wall": Constants.COLOR_BUILDING_CREAM})

	for i in range(house_configs.size()):
		var hc := house_configs[i]
		_build_house(sub, "SuburbanHouse_" + str(i), hc["pos"], Vector3(6.5, 4.5, 6.0), hc["wall"], hc["roof"])

# -----------------------------------------------------------------
# 3. NORTHERN INDUSTRIAL SEAPORT & SHIPS (Region C)
# -----------------------------------------------------------------
static func _build_industrial_seaport(root: Node3D) -> void:
	var port := Node3D.new()
	port.name = "IndustrialSeaport"
	root.add_child(port)

	# Cargo Ship 1 (East quay, facing North: X = 94.0, Z = -52.0)
	_build_cargo_ship(port, "CargoShip_East", Vector3(94.0, -0.2, -52.0), Vector3(9.0, 7.5, 32.0), true)

	# Cargo Ship 2 (North quay, facing East: X = 82.0, Z = -86.0)
	_build_cargo_ship(port, "CargoShip_North", Vector3(82.0, -0.2, -86.0), Vector3(28.0, 7.0, 8.5), false)

	# Industrial Warehouses & Factory Sheds
	_build_warehouse(port, "Warehouse_1", Vector3(64.0, 0.0, -82.0), Vector3(16.0, 7.5, 14.0), Constants.COLOR_BUILDING_GREY)
	_build_warehouse(port, "Warehouse_2", Vector3(48.0, 0.0, -54.0), Vector3(14.0, 6.5, 12.0), Constants.COLOR_BUILDING_OFFWHITE)
	_build_warehouse(port, "Warehouse_3", Vector3(82.0, 0.0, -48.0), Vector3(12.0, 6.5, 10.0), Constants.COLOR_BUILDING_WHITE)

	# Fuel Storage Tank Farm (4 white industrial cylinders)
	var tank_mat := Constants.get_standard_material(Color(0.92, 0.92, 0.94), 0.4)
	var tank_locs: Array[Vector3] = [
		Vector3(38.0, 2.5, -80.0), Vector3(46.0, 2.5, -80.0),
		Vector3(38.0, 2.5, -72.0), Vector3(46.0, 2.5, -72.0)
	]
	for tl in tank_locs:
		var tank := StaticBody3D.new()
		tank.position = tl
		port.add_child(tank)

		var cyl := MeshInstance3D.new()
		var cm := CylinderMesh.new()
		cm.top_radius = 3.2
		cm.bottom_radius = 3.2
		cm.height = 5.0
		cm.material = tank_mat
		cyl.mesh = cm
		tank.add_child(cyl)

		var col := CollisionShape3D.new()
		var cs := CylinderShape3D.new()
		cs.radius = 3.2
		cs.height = 5.0
		col.shape = cs
		tank.add_child(col)

		# Dome lid
		var dome := MeshInstance3D.new()
		var dm := SphereMesh.new()
		dm.radius = 3.2
		dm.height = 1.8
		dm.material = tank_mat
		dome.mesh = dm
		dome.position = Vector3(0.0, 2.5, 0.0)
		tank.add_child(dome)

	# Cargo Gantry Cranes along East Quay
	_build_cargo_crane(port, Vector3(88.0, 0.0, -62.0))
	_build_cargo_crane(port, Vector3(88.0, 0.0, -40.0))

# -----------------------------------------------------------------
# 4. AIRPORT TERMINAL & HANGARS (Region J)
# -----------------------------------------------------------------
static func _build_airport_complex(root: Node3D) -> void:
	var apt := Node3D.new()
	apt.name = "AirportComplex"
	root.add_child(apt)

	# Modern Passenger Terminal (X = -56.0, Z = 52.0, size: 24 x 6.5 x 12)
	var term := StaticBody3D.new()
	term.name = "AirportTerminal"
	term.position = Vector3(-56.0, 3.25, 52.0)
	apt.add_child(term)

	var t_mesh := MeshInstance3D.new()
	var tb := BoxMesh.new()
	tb.size = Vector3(24.0, 6.5, 12.0)
	tb.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.3)
	t_mesh.mesh = tb
	term.add_child(t_mesh)

	var t_col := CollisionShape3D.new()
	var t_cs := BoxShape3D.new()
	t_cs.size = Vector3(24.0, 6.5, 12.0)
	t_col.shape = t_cs
	term.add_child(t_col)

	# Terminal Glass Concourse
	var glass := MeshInstance3D.new()
	var gb := BoxMesh.new()
	gb.size = Vector3(22.0, 3.5, 0.2)
	gb.material = Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.4)
	glass.mesh = gb
	glass.position = Vector3(0.0, 0.0, 6.05)
	term.add_child(glass)

	# Air Traffic Control Tower (ATCT) (X = -42.0, Z = 48.0, Height = 18.0)
	var tower := StaticBody3D.new()
	tower.name = "AirTrafficControlTower"
	tower.position = Vector3(-42.0, 0.0, 48.0)
	apt.add_child(tower)

	# Tower Column
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

	# Observation Glass Cab
	var cab := MeshInstance3D.new()
	var cbm := CylinderMesh.new()
	cbm.top_radius = 2.8
	cbm.bottom_radius = 2.4
	cbm.height = 2.8
	cbm.material = Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.1, 0.5)
	cab.mesh = cbm
	cab.position = Vector3(0.0, 16.8, 0.0)
	tower.add_child(cab)

	# Radome roof dome
	var radome := MeshInstance3D.new()
	var rm := SphereMesh.new()
	rm.radius = 1.2
	rm.height = 1.6
	rm.material = Constants.get_standard_material(Color(0.96, 0.96, 0.96), 0.2)
	radome.mesh = rm
	radome.position = Vector3(0.0, 18.8, 0.0)
	tower.add_child(radome)

	# Two Large Arched Aircraft Hangars (X = -84.0 and -70.0, Z = 52.0)
	for hx in [-84.0, -70.0]:
		_build_hangar(apt, Vector3(hx, 0.0, 52.0), Vector3(12.0, 7.5, 14.0))

# -----------------------------------------------------------------
# 5. MOUNTAIN OBSERVATORY (Region A)
# -----------------------------------------------------------------
static func _build_mountain_observatory(root: Node3D) -> void:
	var obs := StaticBody3D.new()
	obs.name = "MountainObservatory"
	obs.position = Vector3(-76.0, 12.0, -84.0)
	root.add_child(obs)

	# Main Base Building (White concrete)
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(12.0, 5.0, 10.0)
	b.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.3)
	mi.mesh = b
	mi.position = Vector3(0.0, 2.5, 0.0)
	obs.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = Vector3(12.0, 5.0, 10.0)
	col.shape = cs
	col.position = Vector3(0.0, 2.5, 0.0)
	obs.add_child(col)

	# Telescope Dome (Hemisphere radius 3.2)
	var dome := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 3.2
	sm.height = 4.5
	sm.material = Constants.get_standard_material(Color(0.88, 0.90, 0.94), 0.2, 0.4)
	dome.mesh = sm
	dome.position = Vector3(0.0, 5.8, 0.0)
	obs.add_child(dome)

# -----------------------------------------------------------------
# 6. CIVIC COMPLEX & SCHOOL (Region I)
# -----------------------------------------------------------------
static func _build_civic_complex(root: Node3D) -> void:
	var civic := StaticBody3D.new()
	civic.name = "CivicSchoolComplex"
	civic.position = Vector3(-38.0, 0.0, 18.0)
	root.add_child(civic)

	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(14.0, 7.0, 12.0)
	b.material = Constants.get_standard_material(Constants.COLOR_BUILDING_CREAM, 0.5)
	mi.mesh = b
	mi.position = Vector3(0.0, 3.5, 0.0)
	civic.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = Vector3(14.0, 7.0, 12.0)
	col.shape = cs
	col.position = Vector3(0.0, 3.5, 0.0)
	civic.add_child(col)

	# Pitched roof
	var roof := MeshInstance3D.new()
	var pm := PrismMesh.new()
	pm.size = Vector3(12.5, 2.2, 14.5)
	pm.material = Constants.get_standard_material(Constants.COLOR_ROOF_TERRACOTTA, 0.7)
	roof.mesh = pm
	roof.position = Vector3(0.0, 8.1, 0.0)
	roof.rotation.y = PI * 0.5
	civic.add_child(roof)

# -----------------------------------------------------------------
# 7. MARINA STRUCTURES & YACHT CLUB (Region M)
# -----------------------------------------------------------------
static func _build_marina_structures(root: Node3D) -> void:
	var marina_b := Node3D.new()
	marina_b.name = "MarinaStructures"
	root.add_child(marina_b)

	# Octagonal Yacht Club / Restaurant (X = 14.0, Z = 58.0)
	var club := StaticBody3D.new()
	club.position = Vector3(14.0, 0.0, 58.0)
	marina_b.add_child(club)

	var mi := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = 5.2
	cm.bottom_radius = 5.2
	cm.height = 5.5
	cm.radial_segments = 8 # Octagonal
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

	# Waterfront Hotel / Apartments (X = -2.0, Z = 54.0)
	_build_tower(marina_b, "WaterfrontHotel", Vector3(-2.0, 0.0, 54.0), Vector3(16.0, 8.5, 10.0),
		Constants.COLOR_BUILDING_CREAM, 3, false)

# -----------------------------------------------------------------
# 8. PLEASURE PIER AMUSEMENTS & CAROUSEL (Region L)
# -----------------------------------------------------------------
static func _build_pier_amusements(root: Node3D) -> void:
	var pier_a := Node3D.new()
	pier_a.name = "PierAmusements"
	root.add_child(pier_a)

	# Amusement Carousel / Ride Structure at Pierhead (X = 60.0, Z = 86.0)
	var carousel := Node3D.new()
	carousel.position = Vector3(60.0, 0.3, 86.0)
	pier_a.add_child(carousel)

	# Circular base platform
	var base := MeshInstance3D.new()
	var bm := CylinderMesh.new()
	bm.top_radius = 4.5
	bm.bottom_radius = 4.8
	bm.height = 0.5
	bm.material = Constants.get_standard_material(Constants.COLOR_BUILDING_WHITE, 0.5)
	base.mesh = bm
	base.position = Vector3(0.0, 0.25, 0.0)
	carousel.add_child(base)

	# Central spindle
	var spindle := MeshInstance3D.new()
	var sm := CylinderMesh.new()
	sm.top_radius = 0.6
	sm.bottom_radius = 0.6
	sm.height = 4.2
	sm.material = Constants.get_standard_material(Color(0.85, 0.75, 0.2), 0.3)
	spindle.mesh = sm
	spindle.position = Vector3(0.0, 2.1, 0.0)
	carousel.add_child(spindle)

	# Colorful Carnival Canopy Cone (Striped Red & White)
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
# HELPER ARCHITECTURAL BUILDERS
# -----------------------------------------------------------------
static func _build_tower(parent: Node3D, name: String, pos: Vector3, size: Vector3, wall_color: Color, storeys: int, has_antenna: bool) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.position = pos
	parent.add_child(body)

	# Main Tower Box
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = Constants.get_standard_material(wall_color, 0.45)
	mi.mesh = b
	mi.position = Vector3(0.0, size.y * 0.5, 0.0)
	body.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = size
	col.shape = cs
	col.position = Vector3(0.0, size.y * 0.5, 0.0)
	body.add_child(col)

	# Ribbon Glass Window Bands
	var glass_mat := Constants.get_standard_material(Constants.COLOR_GLASS_BLUE, 0.2, 0.4)
	var floor_h: float = size.y / float(storeys + 1)
	for s in range(1, storeys + 1):
		var wy := s * floor_h
		var band_f := MeshInstance3D.new()
		var bb := BoxMesh.new()
		bb.size = Vector3(size.x * 0.88, 1.1, 0.08)
		bb.material = glass_mat
		band_f.mesh = bb
		band_f.position = Vector3(0.0, wy, size.z * 0.5 + 0.02)
		body.add_child(band_f)

		var band_b := MeshInstance3D.new()
		band_b.mesh = bb
		band_b.position = Vector3(0.0, wy, -size.z * 0.5 - 0.02)
		body.add_child(band_b)

	# Rooftop Parapet & HVAC
	var hvac := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(size.x * 0.4, 1.2, size.z * 0.4)
	hb.material = Constants.get_standard_material(Color(0.4, 0.42, 0.45), 0.6)
	hvac.mesh = hb
	hvac.position = Vector3(0.0, size.y + 0.6, 0.0)
	body.add_child(hvac)

	if has_antenna:
		var ant := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 0.06
		cyl.bottom_radius = 0.16
		cyl.height = 6.0
		cyl.material = Constants.get_standard_material(Color(0.85, 0.2, 0.2), 0.3)
		ant.mesh = cyl
		ant.position = Vector3(0.0, size.y + 4.0, 0.0)
		body.add_child(ant)

	return body

static func _build_house(parent: Node3D, name: String, pos: Vector3, size: Vector3, wall_color: Color, roof_color: Color) -> StaticBody3D:
	var house := StaticBody3D.new()
	house.name = name
	house.position = pos
	parent.add_child(house)

	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = Constants.get_standard_material(wall_color, 0.6)
	mi.mesh = b
	mi.position = Vector3(0.0, size.y * 0.5, 0.0)
	house.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = size
	col.shape = cs
	col.position = Vector3(0.0, size.y * 0.5, 0.0)
	house.add_child(col)

	# Pitched Roof
	var roof := MeshInstance3D.new()
	var pm := PrismMesh.new()
	pm.size = Vector3(size.x + 0.6, 2.2, size.z + 0.6)
	pm.material = Constants.get_standard_material(roof_color, 0.7)
	roof.mesh = pm
	roof.position = Vector3(0.0, size.y + 1.1, 0.0)
	roof.rotation.y = PI * 0.5
	house.add_child(roof)

	# Front Door & Windows
	var door := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(1.2, 2.2, 0.08)
	db.material = Constants.get_standard_material(Color(0.35, 0.22, 0.15), 0.6)
	door.mesh = db
	door.position = Vector3(0.0, 1.1, size.z * 0.5 + 0.02)
	house.add_child(door)

	return house

static func _build_warehouse(parent: Node3D, name: String, pos: Vector3, size: Vector3, color: Color) -> StaticBody3D:
	var wh := StaticBody3D.new()
	wh.name = name
	wh.position = pos
	parent.add_child(wh)

	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = Constants.get_standard_material(color, 0.65)
	mi.mesh = b
	mi.position = Vector3(0.0, size.y * 0.5, 0.0)
	wh.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = size
	col.shape = cs
	col.position = Vector3(0.0, size.y * 0.5, 0.0)
	wh.add_child(col)

	# Large Roll-up Loading Door
	var door := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(size.x * 0.5, size.y * 0.7, 0.08)
	db.material = Constants.get_standard_material(Color(0.4, 0.42, 0.46), 0.5, 0.4)
	door.mesh = db
	door.position = Vector3(0.0, size.y * 0.35, size.z * 0.5 + 0.02)
	wh.add_child(door)

	return wh

static func _build_hangar(parent: Node3D, pos: Vector3, size: Vector3) -> StaticBody3D:
	var h := StaticBody3D.new()
	h.position = pos
	parent.add_child(h)

	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = Constants.get_standard_material(Color(0.82, 0.84, 0.88), 0.4, 0.3)
	mi.mesh = b
	mi.position = Vector3(0.0, size.y * 0.5, 0.0)
	h.add_child(mi)

	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = size
	col.shape = cs
	col.position = Vector3(0.0, size.y * 0.5, 0.0)
	h.add_child(col)

	# Arched roof simulation
	var roof := MeshInstance3D.new()
	var rm := CylinderMesh.new()
	rm.top_radius = size.x * 0.5
	rm.bottom_radius = size.x * 0.5
	rm.height = size.z
	rm.material = Constants.get_standard_material(Color(0.72, 0.75, 0.80), 0.5, 0.4)
	roof.mesh = rm
	roof.position = Vector3(0.0, size.y, 0.0)
	roof.rotation.x = PI * 0.5
	h.add_child(roof)

	return h

static func _build_cargo_ship(parent: Node3D, name: String, pos: Vector3, size: Vector3, is_north_south: bool) -> StaticBody3D:
	var ship := StaticBody3D.new()
	ship.name = name
	ship.position = pos
	parent.add_child(ship)

	# Lower Hull (Navy blue)
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

	# Bridge Superstructure (White multi-level cabin)
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

	# Containers on Deck
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

	var crane_mat := Constants.get_standard_material(Color(0.92, 0.72, 0.15), 0.4) # Bright yellow

	# 2 Vertical Crane Legs
	for side in [-2.5, 2.5]:
		var leg := MeshInstance3D.new()
		var lb := BoxMesh.new()
		lb.size = Vector3(0.5, 12.0, 0.5)
		lb.material = crane_mat
		leg.mesh = lb
		leg.position = Vector3(side, 6.0, 0.0)
		crane.add_child(leg)

	# Horizontal Crane Boom Arm
	var boom := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(14.0, 0.8, 1.2)
	bb.material = crane_mat
	boom.mesh = bb
	boom.position = Vector3(2.5, 12.0, 0.0)
	crane.add_child(boom)
