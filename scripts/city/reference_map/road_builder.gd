class_name RefRoadBuilder
extends RefCounted

## Builds the complete road network, roundabouts, bridges, runways, and pedestrian sidewalks
## Matches the reference image layout precisely

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

static func build_roads(parent_node: Node3D, player_hole: PlayerHole) -> void:
	var roads_root := Node3D.new()
	roads_root.name = "ReferenceRoads"
	parent_node.add_child(roads_root)

	var asphalt_mat := Constants.get_cutout_material(Constants.COLOR_ASPHALT, 0.85)
	var runway_mat := Constants.get_cutout_material(Constants.COLOR_RUNWAY_ASPHALT, 0.88)
	var sidewalk_mat := Constants.get_cutout_material(Constants.COLOR_SIDEWALK, 0.90)
	var kerb_mat := Constants.get_cutout_material(Constants.COLOR_KERB, 0.70)
	var white_mat := Constants.get_cutout_material(Constants.COLOR_ROAD_MARKING_WHITE, 0.50)
	var yellow_mat := Constants.get_cutout_material(Constants.COLOR_ROAD_MARKING_YELLOW, 0.50)
	var wood_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.70)
	var bridge_red := Constants.get_standard_material(Constants.COLOR_BRIDGE_RED, 0.40)

	if player_hole:
		player_hole.register_shader_material(asphalt_mat)
		player_hole.register_shader_material(runway_mat)
		player_hole.register_shader_material(sidewalk_mat)
		player_hole.register_shader_material(kerb_mat)
		player_hole.register_shader_material(white_mat)
		player_hole.register_shader_material(yellow_mat)

	# 1. Four Major City Roundabouts
	_build_roundabouts(roads_root, asphalt_mat, sidewalk_mat, kerb_mat)

	# 2. Downtown Avenue Grid & Grand Promenade Corridors
	_build_downtown_grid(roads_root, asphalt_mat, sidewalk_mat, kerb_mat)

	# 3. Suburban Neighborhood Residential Streets (Region G)
	_build_suburban_streets(roads_root, asphalt_mat, sidewalk_mat)

	# 4. Northern Approach & Mountain Switchback Roads (Region A & B)
	_build_mountain_roads(roads_root, asphalt_mat)

	# 5. Airport Runway, Taxiways, and Apron (Region J)
	_build_airport_runway_system(roads_root, runway_mat, white_mat, yellow_mat)

	# 6. Eastern Coastal Highway & Elevated Bridge (Region O)
	_build_coastal_highway(roads_root, asphalt_mat, yellow_mat)

	# 7. Red Steel Truss Bridge (Region O, crossing water to East)
	_build_red_truss_bridge(roads_root, asphalt_mat, bridge_red)

	# 8. Wooden Pleasure Pier & Boardwalk (Region L)
	_build_pleasure_pier(roads_root, wood_mat)

	# 9. Pedestrian Crossings and Lane Markings
	_build_lane_markings(roads_root, white_mat, yellow_mat)

# -----------------------------------------------------------------
# 1. ROUNDABOUTS
# -----------------------------------------------------------------
static func _build_roundabouts(parent: Node3D, asphalt: Material, sidewalk: Material, kerb: Material) -> void:
	var roundabouts_node := Node3D.new()
	roundabouts_node.name = "Roundabouts"
	parent.add_child(roundabouts_node)

	var list: Array[Dictionary] = [
		{"name": "Roundabout_NW", "pos": Vector3(-42.0, 0.02, -44.0), "r_out": 6.5, "r_in": 3.2},
		{"name": "Roundabout_West", "pos": Vector3(-84.0, 0.02, 0.0), "r_out": 6.0, "r_in": 2.8},
		{"name": "Roundabout_SW_Airport", "pos": Vector3(-26.0, 0.02, 42.0), "r_out": 6.5, "r_in": 3.2},
		{"name": "Roundabout_SE_Coast", "pos": Vector3(52.0, 0.02, 42.0), "r_out": 6.5, "r_in": 3.2}
	]

	for rb in list:
		var p: Vector3 = rb["pos"]
		var ro: float = rb["r_out"]
		var ri: float = rb["r_in"]

		# Outer asphalt ring
		var ring := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = ro
		cyl.bottom_radius = ro
		cyl.height = 0.02
		cyl.radial_segments = 36
		cyl.material = asphalt
		ring.mesh = cyl
		ring.position = p
		ring.add_to_group("hole_cutout_meshes")
		roundabouts_node.add_child(ring)

		# Central landscaped island
		var island := MeshInstance3D.new()
		var ic := CylinderMesh.new()
		ic.top_radius = ri
		ic.bottom_radius = ri
		ic.height = 0.16
		ic.radial_segments = 32
		ic.material = kerb
		island.mesh = ic
		island.position = Vector3(p.x, p.y + 0.08, p.z)
		roundabouts_node.add_child(island)

		# Green lawn inside center island
		var grass_center := MeshInstance3D.new()
		var gc := CylinderMesh.new()
		gc.top_radius = ri - 0.3
		gc.bottom_radius = ri - 0.3
		gc.height = 0.04
		gc.radial_segments = 28
		gc.material = Constants.get_cutout_material(Constants.COLOR_GRASS, 0.85)
		grass_center.mesh = gc
		grass_center.position = Vector3(p.x, p.y + 0.18, p.z)
		grass_center.add_to_group("hole_cutout_meshes")
		roundabouts_node.add_child(grass_center)

# -----------------------------------------------------------------
# 2. DOWNTOWN GRID & GRAND PROMENADE
# -----------------------------------------------------------------
static func _build_downtown_grid(parent: Node3D, asphalt: Material, sidewalk: Material, kerb: Material) -> void:
	var grid := Node3D.new()
	grid.name = "DowntownAvenues"
	parent.add_child(grid)

	# North-South Corridors:
	# Avenue West (X = -18.0)
	_add_road_strip(grid, asphalt, Vector3(-18.0, 0.02, -1.0), Vector3(7.0, 0.02, 88.0))
	_add_sidewalk_strip(grid, sidewalk, Vector3(-22.0, 0.12, -1.0), Vector3(1.4, 0.10, 88.0))

	# Central Promenade West Lane (X = 0.0)
	_add_road_strip(grid, asphalt, Vector3(0.0, 0.02, -1.0), Vector3(6.5, 0.02, 88.0))

	# Grand Central Pedestrian Promenade (X = 8.0, Z: -44 to 42)
	_add_sidewalk_strip(grid, sidewalk, Vector3(8.0, 0.12, -1.0), Vector3(9.5, 0.10, 88.0))

	# Central Promenade East Lane (X = 16.0)
	_add_road_strip(grid, asphalt, Vector3(16.0, 0.02, -1.0), Vector3(6.5, 0.02, 88.0))

	# Avenue East (X = 34.0)
	_add_road_strip(grid, asphalt, Vector3(34.0, 0.02, -1.0), Vector3(7.0, 0.02, 88.0))
	_add_sidewalk_strip(grid, sidewalk, Vector3(38.0, 0.12, -1.0), Vector3(1.4, 0.10, 88.0))

	# Highway Avenue East (X = 52.0)
	_add_road_strip(grid, asphalt, Vector3(52.0, 0.02, 6.0), Vector3(8.0, 0.02, 74.0))

	# East-West Cross Streets:
	# North Cross (Z = -44.0)
	_add_road_strip(grid, asphalt, Vector3(5.0, 0.02, -44.0), Vector3(96.0, 0.02, 8.0))
	# Mid-North Cross (Z = -20.0)
	_add_road_strip(grid, asphalt, Vector3(5.0, 0.02, -20.0), Vector3(96.0, 0.02, 7.5))
	# Center Boulevard (Z = 16.0)
	_add_road_strip(grid, asphalt, Vector3(5.0, 0.02, 16.0), Vector3(96.0, 0.02, 8.0))
	# South Cross (Z = 42.0)
	_add_road_strip(grid, asphalt, Vector3(13.0, 0.02, 42.0), Vector3(80.0, 0.02, 8.5))

	# Northern Industrial Port Access Road (X: 30 to 85, Z: -72)
	_add_road_strip(grid, asphalt, Vector3(58.0, 0.02, -72.0), Vector3(56.0, 0.02, 8.0))
	_add_road_strip(grid, asphalt, Vector3(74.0, 0.02, -58.0), Vector3(8.0, 0.02, 36.0))

# -----------------------------------------------------------------
# 3. SUBURBAN RESIDENTIAL STREETS (Region G)
# -----------------------------------------------------------------
static func _build_suburban_streets(parent: Node3D, asphalt: Material, sidewalk: Material) -> void:
	var sub := Node3D.new()
	sub.name = "SuburbanStreets"
	parent.add_child(sub)

	# Western Connecting Avenue (Z = 0.0, X: -84 to -12)
	_add_road_strip(sub, asphalt, Vector3(-48.0, 0.02, 0.0), Vector3(72.0, 0.02, 6.5))

	# Suburban North Loop (Z = -20.0, X: -84 to -42)
	_add_road_strip(sub, asphalt, Vector3(-63.0, 0.02, -20.0), Vector3(44.0, 0.02, 5.5))

	# Residential Cross Streets
	_add_road_strip(sub, asphalt, Vector3(-70.0, 0.02, -10.0), Vector3(5.5, 0.02, 22.0))
	_add_road_strip(sub, asphalt, Vector3(-54.0, 0.02, -10.0), Vector3(5.5, 0.02, 22.0))

	# Stadium Access Road (Z = 32.0, X: -72 to -26)
	_add_road_strip(sub, asphalt, Vector3(-49.0, 0.02, 32.0), Vector3(48.0, 0.02, 6.0))

# -----------------------------------------------------------------
# 4. MOUNTAIN ROADS & SWITCHBACK (Region A & B)
# -----------------------------------------------------------------
static func _build_mountain_roads(parent: Node3D, asphalt: Material) -> void:
	var mtn_roads := Node3D.new()
	mtn_roads.name = "MountainRoads"
	parent.add_child(mtn_roads)

	# Approach road from NW Roundabout to mountain base
	_add_road_strip(mtn_roads, asphalt, Vector3(-58.0, 0.02, -44.0), Vector3(32.0, 0.02, 6.5))

	# Mountain Switchback Ledges:
	# Leg 1: Climbing west toward tunnel entrance
	_add_road_strip(mtn_roads, asphalt, Vector3(-76.0, 0.02, -48.0), Vector3(6.0, 0.02, 16.0))
	# Hairpin ledge 1 (Y = 2.0)
	_add_road_strip(mtn_roads, asphalt, Vector3(-68.0, 2.0, -60.0), Vector3(16.0, 0.04, 5.5))
	# Leg 2: Climbing north toward ridge (Y = 4.5)
	_add_road_strip(mtn_roads, asphalt, Vector3(-80.0, 4.5, -68.0), Vector3(5.5, 0.04, 18.0))
	# Hairpin ledge 2 (Y = 7.0)
	_add_road_strip(mtn_roads, asphalt, Vector3(-74.0, 7.0, -78.0), Vector3(18.0, 0.04, 5.5))
	# Leg 3: Summit Road to Peak Observatory (Y = 10.0)
	_add_road_strip(mtn_roads, asphalt, Vector3(-80.0, 10.0, -82.0), Vector3(5.5, 0.04, 12.0))

# -----------------------------------------------------------------
# 5. AIRPORT RUNWAY & TAXIWAY (Region J)
# -----------------------------------------------------------------
static func _build_airport_runway_system(parent: Node3D, runway_mat: Material, white_mat: Material, yellow_mat: Material) -> void:
	var airport := Node3D.new()
	airport.name = "AirportRunwaySystem"
	parent.add_child(airport)

	# Main Runway 09/27 (Length: 64.0, Width: 8.5 at Z = 76.0, X: -88 to -24)
	_add_road_strip(airport, runway_mat, Vector3(-56.0, 0.02, 76.0), Vector3(64.0, 0.02, 8.5))

	# Runway Threshold Piano Keys (West end at X = -85.0, East end at X = -27.0)
	for side_x in [-85.0, -27.0]:
		for stripe_z in range(-3, 4):
			var key := MeshInstance3D.new()
			var kb := BoxMesh.new()
			kb.size = Vector3(2.8, 0.04, 0.5)
			kb.material = white_mat
			key.mesh = kb
			key.position = Vector3(side_x, 0.03, 76.0 + stripe_z * 0.9)
			key.add_to_group("hole_cutout_meshes")
			airport.add_child(key)

	# Runway Centerline Dashes
	for cx in range(-78, -32, 6):
		var dash := MeshInstance3D.new()
		var db := BoxMesh.new()
		db.size = Vector3(3.2, 0.04, 0.4)
		db.material = white_mat
		dash.mesh = db
		dash.position = Vector3(float(cx), 0.03, 76.0)
		dash.add_to_group("hole_cutout_meshes")
		airport.add_child(dash)

	# Parallel Taxiway (Z = 66.0, X: -82 to -30, width 5.0)
	_add_road_strip(airport, runway_mat, Vector3(-56.0, 0.02, 66.0), Vector3(52.0, 0.02, 5.0))

	# Connecting Taxiway Turnoffs
	_add_road_strip(airport, runway_mat, Vector3(-78.0, 0.02, 71.0), Vector3(4.5, 0.02, 10.0))
	_add_road_strip(airport, runway_mat, Vector3(-56.0, 0.02, 71.0), Vector3(4.5, 0.02, 10.0))
	_add_road_strip(airport, runway_mat, Vector3(-34.0, 0.02, 71.0), Vector3(4.5, 0.02, 10.0))

	# Aircraft Apron & Parking Stands (Z = 58.0, X: -64 to -34, size 30 x 12)
	_add_road_strip(airport, runway_mat, Vector3(-49.0, 0.02, 58.0), Vector3(30.0, 0.02, 12.0))

	# Airport Terminal Access Road from SW Roundabout
	_add_road_strip(airport, runway_mat, Vector3(-26.0, 0.02, 54.0), Vector3(6.5, 0.02, 24.0))

# -----------------------------------------------------------------
# 6. COASTAL HIGHWAY & ELEVATED BRIDGE (Region O)
# -----------------------------------------------------------------
static func _build_coastal_highway(parent: Node3D, asphalt: Material, yellow_mat: Material) -> void:
	var hwy := Node3D.new()
	hwy.name = "CoastalHighway"
	parent.add_child(hwy)

	# Elevated Highway Bridge sweeping across eastern ocean bay (X = 72.0, Z = 12.0)
	var deck := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(8.5, 0.4, 38.0)
	db.material = asphalt
	deck.mesh = db
	deck.position = Vector3(72.0, 1.2, 12.0)
	hwy.add_child(deck)

	# Concrete Bridge Support Pillars
	var pillar_mat := Constants.get_standard_material(Constants.COLOR_KERB, 0.7)
	for z in [-2.0, 12.0, 26.0]:
		var pillar := MeshInstance3D.new()
		var pb := CylinderMesh.new()
		pb.top_radius = 1.2
		pb.bottom_radius = 1.4
		pb.height = 2.4
		pb.material = pillar_mat
		pillar.mesh = pb
		pillar.position = Vector3(72.0, 0.0, float(z))
		hwy.add_child(pillar)

	# Guardrails
	var rail_mat := Constants.get_standard_material(Color(0.85, 0.85, 0.88), 0.4)
	for side in [-4.0, 4.0]:
		var rail := MeshInstance3D.new()
		var rb := BoxMesh.new()
		rb.size = Vector3(0.18, 0.75, 38.0)
		rb.material = rail_mat
		rail.mesh = rb
		rail.position = Vector3(72.0 + side, 1.7, 12.0)
		hwy.add_child(rail)

# -----------------------------------------------------------------
# 7. RED STEEL TRUSS BRIDGE (Region O)
# -----------------------------------------------------------------
static func _build_red_truss_bridge(parent: Node3D, asphalt: Material, bridge_red: Material) -> void:
	var bridge_node := Node3D.new()
	bridge_node.name = "RedSteelBridge"
	parent.add_child(bridge_node)

	# Bridge Deck across water from SE Roundabout to East (X = 80.0, Z = 42.0)
	var deck := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(28.0, 0.4, 7.5)
	db.material = asphalt
	deck.mesh = db
	deck.position = Vector3(80.0, 0.4, 42.0)
	bridge_node.add_child(deck)

	# Red Steel Truss Framework on North and South sides
	for side in [-3.9, 3.9]:
		var truss_top := MeshInstance3D.new()
		var tb := BoxMesh.new()
		tb.size = Vector3(28.0, 0.35, 0.35)
		tb.material = bridge_red
		truss_top.mesh = tb
		truss_top.position = Vector3(80.0, 3.4, 42.0 + side)
		bridge_node.add_child(truss_top)

		# Vertical posts
		for x in range(68, 94, 5):
			var post := MeshInstance3D.new()
			var pb := BoxMesh.new()
			pb.size = Vector3(0.35, 3.0, 0.35)
			pb.material = bridge_red
			post.mesh = pb
			post.position = Vector3(float(x), 1.9, 42.0 + side)
			bridge_node.add_child(post)

# -----------------------------------------------------------------
# 8. PLEASURE PIER & BOARDWALK (Region L)
# -----------------------------------------------------------------
static func _build_pleasure_pier(parent: Node3D, wood_mat: Material) -> void:
	var pier_node := Node3D.new()
	pier_node.name = "PleasurePier"
	parent.add_child(pier_node)

	# Main Long Pier Deck extending South into water (X = 60.0, Z: 54 to 84)
	var deck := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(5.5, 0.35, 30.0)
	db.material = wood_mat
	deck.mesh = db
	deck.position = Vector3(60.0, 0.08, 69.0)
	pier_node.add_child(deck)

	# Pierhead Amusement Platform at south end (Size: 14 x 14 at Z = 86.0)
	var platform := MeshInstance3D.new()
	var pb := BoxMesh.new()
	pb.size = Vector3(14.0, 0.4, 14.0)
	pb.material = wood_mat
	platform.mesh = pb
	platform.position = Vector3(60.0, 0.08, 86.0)
	pier_node.add_child(platform)

	# Wooden Pilings supporting the pier above water
	var pile_mat := Constants.get_standard_material(Color(0.35, 0.28, 0.20), 0.8)
	for z in range(60, 94, 6):
		for x in [-2.5, 2.5]:
			var pile := MeshInstance3D.new()
			var cb := CylinderMesh.new()
			cb.top_radius = 0.22
			cb.bottom_radius = 0.22
			cb.height = 1.2
			cb.material = pile_mat
			pile.mesh = cb
			pile.position = Vector3(60.0 + x, -0.4, float(z))
			pier_node.add_child(pile)

# -----------------------------------------------------------------
# 9. ROAD MARKINGS & ZEBRA CROSSINGS
# -----------------------------------------------------------------
static func _build_lane_markings(parent: Node3D, white_mat: Material, yellow_mat: Material) -> void:
	var markings := Node3D.new()
	markings.name = "RoadMarkings"
	parent.add_child(markings)

	# Zebra Crossings at downtown intersections
	var zebra_locs: Array[Vector3] = [
		Vector3(-18.0, 0.03, -40.0), Vector3(34.0, 0.03, -40.0),
		Vector3(-18.0, 0.03, -24.0), Vector3(34.0, 0.03, -24.0),
		Vector3(-18.0, 0.03, 12.0), Vector3(34.0, 0.03, 12.0),
		Vector3(-18.0, 0.03, 38.0), Vector3(34.0, 0.03, 38.0)
	]

	for zl in zebra_locs:
		for stripe in range(-3, 4):
			var z_bar := MeshInstance3D.new()
			var zb := BoxMesh.new()
			zb.size = Vector3(0.7, 0.02, 2.4)
			zb.material = white_mat
			z_bar.mesh = zb
			z_bar.position = Vector3(zl.x + stripe * 1.0, zl.y, zl.z)
			z_bar.add_to_group("hole_cutout_meshes")
			markings.add_child(z_bar)

# -----------------------------------------------------------------
# HELPER STRIP SPAWNERS
# -----------------------------------------------------------------
static func _add_road_strip(parent: Node3D, mat: Material, pos: Vector3, size: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = mat
	mi.mesh = b
	mi.position = pos
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)
	return mi

static func _add_sidewalk_strip(parent: Node3D, mat: Material, pos: Vector3, size: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = mat
	mi.mesh = b
	mi.position = pos
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)
	return mi
