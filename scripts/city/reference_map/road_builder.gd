class_name RefRoadBuilder
extends RefCounted

## Builds the complete road network, serpentine mountain switchbacks, roundabouts, bridges, runways, and park paths
## Faithfully reproduces the reference image layout with smooth curves and authentic markings

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
	var guardrail_mat := Constants.get_standard_material(Color(0.85, 0.86, 0.88), 0.4, 0.3)

	if player_hole:
		player_hole.register_shader_material(asphalt_mat)
		player_hole.register_shader_material(runway_mat)
		player_hole.register_shader_material(sidewalk_mat)
		player_hole.register_shader_material(kerb_mat)
		player_hole.register_shader_material(white_mat)
		player_hole.register_shader_material(yellow_mat)

	# 1. Four Major City Roundabouts
	_build_roundabouts(roads_root, asphalt_mat, kerb_mat)

	# 2. Mountain Serpentine Switchback Road (Matching Image 4)
	_build_mountain_switchback(roads_root, asphalt_mat, guardrail_mat)

	# 3. Downtown Avenue Grid & Grand Promenade (Matching Images 3 & 5)
	_build_downtown_grid(roads_root, asphalt_mat, sidewalk_mat)

	# 4. Suburban Residential Street Network (Matching Image 1)
	_build_suburban_streets(roads_root, asphalt_mat, sidewalk_mat)

	# 5. Central Park Winding Walking Paths (Matching Image 3)
	_build_park_paths(roads_root, sidewalk_mat)

	# 6. Airport Runway, Taxiways, and Apron (Region J)
	_build_airport_runway_system(roads_root, runway_mat, white_mat, yellow_mat)

	# 7. Eastern Coastal Highway & Elevated Bridge (Region O)
	_build_coastal_highway(roads_root, asphalt_mat, yellow_mat)

	# 8. Red Steel Truss Bridge (Crossing eastern water channel)
	_build_red_truss_bridge(roads_root, asphalt_mat, bridge_red)

	# 9. Wooden Pleasure Pier & Boardwalk (Region L)
	_build_pleasure_pier(roads_root, wood_mat)

	# 10. Pedestrian Crossings and Markings
	_build_lane_markings(roads_root, white_mat)

# -----------------------------------------------------------------
# 1. ROUNDABOUTS
# -----------------------------------------------------------------
static func _build_roundabouts(parent: Node3D, asphalt: Material, kerb: Material) -> void:
	var roundabouts_node := Node3D.new()
	roundabouts_node.name = "Roundabouts"
	parent.add_child(roundabouts_node)

	var list: Array[Dictionary] = [
		{"name": "Roundabout_NW", "pos": Vector3(-42.0, 0.02, -38.0), "r_out": 6.5, "r_in": 3.2},
		{"name": "Roundabout_West", "pos": Vector3(-75.0, 0.02, 35.0), "r_out": 6.5, "r_in": 3.2},
		{"name": "Roundabout_SW_Airport", "pos": Vector3(-26.0, 0.02, 42.0), "r_out": 6.5, "r_in": 3.2},
		{"name": "Roundabout_SE_Coast", "pos": Vector3(52.0, 0.02, 42.0), "r_out": 6.5, "r_in": 3.2}
	]

	for rb in list:
		var p: Vector3 = rb["pos"]
		var ro: float = rb["r_out"]
		var ri: float = rb["r_in"]

		# Asphalt ring
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

		# Kerbed center island
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

		# Green center lawn
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
# 2. MOUNTAIN SERPENTINE SWITCHBACK (Matching Image 4)
# -----------------------------------------------------------------
static func _build_mountain_switchback(parent: Node3D, asphalt: Material, guardrail: Material) -> void:
	var mtn_roads := Node3D.new()
	mtn_roads.name = "MountainSwitchbackRoads"
	parent.add_child(mtn_roads)

	# Mountain switchback path points curving across the mountain face matching Image 4
	var waypoints: Array[Vector3] = [
		Vector3(-66.0, 0.25, -42.0), # Branch off arterial near tunnel
		Vector3(-58.0, 1.8, -46.0),
		Vector3(-48.0, 3.8, -52.0),  # Hairpin 1 turn (East)
		Vector3(-52.0, 5.6, -60.0),
		Vector3(-64.0, 7.8, -64.0),  # Hairpin 2 turn (West)
		Vector3(-56.0, 10.0, -72.0), # Hairpin 3 turn (East)
		Vector3(-66.0, 12.0, -78.0), # Approach summit
		Vector3(-74.0, 13.15, -80.0) # Summit parking / turnaround
	]

	# Build smooth ribbon road along waypoints
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(asphalt)

	var road_w: float = 4.8
	for i in range(waypoints.size() - 1):
		var p0 := waypoints[i] + Vector3(0.0, 0.20, 0.0)
		var p1 := waypoints[i + 1] + Vector3(0.0, 0.20, 0.0)
		var dir := (p1 - p0).normalized()
		var norm := Vector3(-dir.z, 0.0, dir.x).normalized()

		var l0 := p0 - norm * (road_w * 0.5)
		var r0 := p0 + norm * (road_w * 0.5)
		var l1 := p1 - norm * (road_w * 0.5)
		var r1 := p1 + norm * (road_w * 0.5)

		_add_flat_quad(st, l0, r0, r1, l1)

		# Add outer guardrail on elevated switchbacks (Y > 1.5)
		if p0.y > 1.5:
			var rail := MeshInstance3D.new()
			var rb := BoxMesh.new()
			rb.size = Vector3(0.12, 0.65, (p1 - p0).length())
			rb.material = guardrail
			rail.mesh = rb
			var rail_pos := (r0 + r1) * 0.5 + Vector3(0.0, 0.35, 0.0)
			var target_pos := r1 + Vector3(0.0, 0.35, 0.0)
			rail.look_at_from_position(rail_pos, target_pos, Vector3.UP)
			mtn_roads.add_child(rail)

	var road_mesh := st.commit()
	var road_mi := MeshInstance3D.new()
	road_mi.mesh = road_mesh
	road_mi.add_to_group("hole_cutout_meshes")
	mtn_roads.add_child(road_mi)

	# Summit Vehicle Turnaround Loop (X = -74.0, Z = -80.0 at Y = 13.15)
	var loop := MeshInstance3D.new()
	var lc := CylinderMesh.new()
	lc.top_radius = 7.5
	lc.bottom_radius = 7.5
	lc.height = 0.02
	lc.radial_segments = 32
	lc.material = asphalt
	loop.mesh = lc
	loop.position = Vector3(-74.0, 13.25, -80.0)
	loop.add_to_group("hole_cutout_meshes")
	mtn_roads.add_child(loop)

# -----------------------------------------------------------------
# 3. DOWNTOWN GRID & GRAND PROMENADE (Matching Images 3 & 5)
# -----------------------------------------------------------------
static func _build_downtown_grid(parent: Node3D, asphalt: Material, sidewalk: Material) -> void:
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
	# North Cross (Z = -38.0 - continuous arterial across entire city)
	_add_road_strip(grid, asphalt, Vector3(8.0, 0.02, -38.0), Vector3(72.0, 0.02, 7.0))
	# Mid-North Cross (Z = -20.0)
	_add_road_strip(grid, asphalt, Vector3(5.0, 0.02, -20.0), Vector3(96.0, 0.02, 7.0))
	# Center Boulevard (Z = 16.0)
	_add_road_strip(grid, asphalt, Vector3(5.0, 0.02, 16.0), Vector3(96.0, 0.02, 8.0))
	# South Cross (Z = 42.0)
	_add_road_strip(grid, asphalt, Vector3(13.0, 0.02, 42.0), Vector3(80.0, 0.02, 8.0))

	# Northern Industrial Port Access Road (X: 30 to 85, Z: -72)
	_add_road_strip(grid, asphalt, Vector3(58.0, 0.02, -72.0), Vector3(56.0, 0.02, 8.0))
	_add_road_strip(grid, asphalt, Vector3(74.0, 0.02, -58.0), Vector3(8.0, 0.02, 36.0))

	# Northern Commercial District Access & Supermarket Loop (Matching Image 5)
	# Commercial West Lane (X = -4.0, Z: -38 to -68)
	_add_road_strip(grid, asphalt, Vector3(-4.0, 0.02, -53.0), Vector3(6.0, 0.02, 30.0))
	# Commercial North Lane (Z = -68.0, X: -4 to 34)
	_add_road_strip(grid, asphalt, Vector3(15.0, 0.02, -68.0), Vector3(44.0, 0.02, 6.0))
	# Commercial East Lane (X = 34.0, Z: -38 to -68)
	_add_road_strip(grid, asphalt, Vector3(34.0, 0.02, -53.0), Vector3(6.0, 0.02, 30.0))

	# Supermarket Front Parking Lot (X: 2 to 26, Z: -54 to -44)
	_add_road_strip(grid, asphalt, Vector3(14.0, 0.02, -49.0), Vector3(24.0, 0.02, 10.0))
	_add_sidewalk_strip(grid, sidewalk, Vector3(14.0, 0.08, -43.5), Vector3(25.0, 0.06, 1.2))

# -----------------------------------------------------------------
# 4. SUBURBAN STREET NETWORK (Matching Image 1)
# -----------------------------------------------------------------
static func _build_suburban_streets(parent: Node3D, asphalt: Material, sidewalk: Material) -> void:
	var sub := Node3D.new()
	sub.name = "SuburbanStreets"
	parent.add_child(sub)

	# 1. Outer Northern Arterial (connecting Tunnel, NW Roundabout, and Avenue West: Z = -38.0, X: -84 to -18)
	_add_road_strip(sub, asphalt, Vector3(-51.0, 0.02, -38.0), Vector3(66.0, 0.02, 6.0))

	# 2. Western Perimeter Avenue (X = -84.0, Z: -38 to 35)
	_add_road_strip(sub, asphalt, Vector3(-84.0, 0.02, -1.5), Vector3(6.0, 0.02, 73.0))

	# 3. Dividing Avenue between Suburbs and Stadium (Z = 12.0, X: -84 to -18)
	_add_road_strip(sub, asphalt, Vector3(-51.0, 0.02, 12.0), Vector3(66.0, 0.02, 6.0))

	# 4. Internal Residential Street North (Z = -22.0, X: -81 to -20, Width 4.5m)
	_add_road_strip(sub, asphalt, Vector3(-50.5, 0.02, -22.0), Vector3(61.0, 0.02, 4.5))

	# 5. Internal Residential Street South (Z = -4.0, X: -81 to -20, Width 4.5m)
	_add_road_strip(sub, asphalt, Vector3(-50.5, 0.02, -4.0), Vector3(61.0, 0.02, 4.5))

	# 6. Connecting North-South Residential Cross Street West (X = -58.0, Z: -22 to -4, Width 4.5m)
	_add_road_strip(sub, asphalt, Vector3(-58.0, 0.02, -13.0), Vector3(4.5, 0.02, 18.0))

	# 7. Connecting North-South Residential Cross Street East (X = -32.0, Z: -22 to -4, Width 4.5m)
	_add_road_strip(sub, asphalt, Vector3(-32.0, 0.02, -13.0), Vector3(4.5, 0.02, 18.0))

	# 8. Residential Cul-de-Sac West of Stadium (X = -74.0, Z: 12 to 35, Width 4.5m)
	_add_road_strip(sub, asphalt, Vector3(-74.0, 0.02, 23.5), Vector3(4.5, 0.02, 23.0))

	# 9. Stadium South Access Avenue (connecting Roundabout West to Avenue West: Z = 35.0)
	_add_road_strip(sub, asphalt, Vector3(-46.5, 0.02, 35.0), Vector3(57.0, 0.02, 6.0))

# -----------------------------------------------------------------
# 5. CENTRAL PARK WINDING PATHS (Matching Image 3)
# -----------------------------------------------------------------
static func _build_park_paths(parent: Node3D, path_mat: Material) -> void:
	var paths := Node3D.new()
	paths.name = "ParkWalkingPaths"
	parent.add_child(paths)

	# Organic beige footpaths winding throughout the park
	var path_loops: Array[Array] = [
		# Outer loop around the park perimeter
		[Vector3(-24.0, 0.025, -38.0), Vector3(-6.0, 0.025, -36.0), Vector3(-3.0, 0.025, -20.0),
		 Vector3(-4.0, 0.025, 6.0), Vector3(-18.0, 0.025, 4.0), Vector3(-24.0, 0.025, -15.0), Vector3(-24.0, 0.025, -38.0)],
		# Inner loop around the lake
		[Vector3(-14.0, 0.025, -30.0), Vector3(-5.0, 0.025, -24.0), Vector3(-5.0, 0.025, -6.0),
		 Vector3(-12.0, 0.025, -2.0), Vector3(-18.0, 0.025, -12.0), Vector3(-14.0, 0.025, -30.0)]
	]

	for loop in path_loops:
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_material(path_mat)
		var pw: float = 1.6
		for i in range(loop.size() - 1):
			var p0: Vector3 = loop[i]
			var p1: Vector3 = loop[i + 1]
			var dir := (p1 - p0).normalized()
			var norm := Vector3(-dir.z, 0.0, dir.x).normalized()
			var l0 := p0 - norm * (pw * 0.5)
			var r0 := p0 + norm * (pw * 0.5)
			var l1 := p1 - norm * (pw * 0.5)
			var r1 := p1 + norm * (pw * 0.5)
			_add_flat_quad(st, l0, r0, r1, l1)
		var p_mesh := st.commit()
		var p_mi := MeshInstance3D.new()
		p_mi.mesh = p_mesh
		p_mi.add_to_group("hole_cutout_meshes")
		paths.add_child(p_mi)

# -----------------------------------------------------------------
# 6. AIRPORT RUNWAY & TAXIWAYS
# -----------------------------------------------------------------
static func _build_airport_runway_system(parent: Node3D, runway_mat: Material, white_mat: Material, yellow_mat: Material) -> void:
	var apt_roads := Node3D.new()
	apt_roads.name = "AirportRunwaySystem"
	parent.add_child(apt_roads)

	# Main Runway 09/27 (Length: 82.0, Width: 14.0 at X = -55.0, Z = 82.0)
	_add_road_strip(apt_roads, runway_mat, Vector3(-55.0, 0.02, 82.0), Vector3(82.0, 0.02, 14.0))

	# Parallel Taxiway (Length: 72.0, Width: 7.0 at Z = 72.0)
	_add_road_strip(apt_roads, runway_mat, Vector3(-55.0, 0.02, 72.0), Vector3(72.0, 0.02, 7.0))

	# Connecting High-Speed Taxiway Exits
	for tx in [-80.0, -55.0, -30.0]:
		_add_road_strip(apt_roads, runway_mat, Vector3(tx, 0.02, 77.0), Vector3(6.5, 0.02, 10.0))

	# Apron Tarmac (Z: 60 to 70, X: -68 to -30)
	_add_road_strip(apt_roads, runway_mat, Vector3(-49.0, 0.02, 65.0), Vector3(42.0, 0.02, 12.0))

	# Runway Threshold "Piano Keys"
	for end_x in [-92.0, -18.0]:
		for bar in range(-4, 5):
			var mi := MeshInstance3D.new()
			var b := BoxMesh.new()
			b.size = Vector3(5.5, 0.02, 0.9)
			b.material = white_mat
			mi.mesh = b
			mi.position = Vector3(end_x, 0.03, 82.0 + bar * 1.3)
			mi.add_to_group("hole_cutout_meshes")
			apt_roads.add_child(mi)

	# Runway Centerline Dashes
	for cx in range(-82, -22, 8):
		var mi := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = Vector3(4.8, 0.02, 0.7)
		b.material = white_mat
		mi.mesh = b
		mi.position = Vector3(float(cx), 0.03, 82.0)
		mi.add_to_group("hole_cutout_meshes")
		apt_roads.add_child(mi)

# -----------------------------------------------------------------
# 7. COASTAL HIGHWAY & ELEVATED BRIDGE
# -----------------------------------------------------------------
static func _build_coastal_highway(parent: Node3D, asphalt: Material, yellow_mat: Material) -> void:
	var hwy := Node3D.new()
	hwy.name = "CoastalHighway"
	parent.add_child(hwy)

	# Elevated highway ramp crossing the water on the East side (X = 66.0, Z = 14.0)
	var ramp := MeshInstance3D.new()
	var rb := BoxMesh.new()
	rb.size = Vector3(7.5, 0.4, 48.0)
	rb.material = asphalt
	ramp.mesh = rb
	ramp.position = Vector3(66.0, 0.25, 14.0)
	ramp.add_to_group("hole_cutout_meshes")
	hwy.add_child(ramp)

	# Concrete bridge support piers
	var pier_mat := Constants.get_standard_material(Color(0.72, 0.74, 0.76), 0.5)
	for pz in [-6.0, 14.0, 34.0]:
		var p_col := MeshInstance3D.new()
		var pb := BoxMesh.new()
		pb.size = Vector3(7.0, 0.8, 1.8)
		pb.material = pier_mat
		p_col.mesh = pb
		p_col.position = Vector3(66.0, -0.2, pz)
		hwy.add_child(p_col)

# -----------------------------------------------------------------
# 8. RED STEEL TRUSS BRIDGE (Crossing eastern water channel)
# -----------------------------------------------------------------
static func _build_red_truss_bridge(parent: Node3D, asphalt: Material, bridge_red: Material) -> void:
	var bridge_node := Node3D.new()
	bridge_node.name = "RedSteelTrussBridge"
	parent.add_child(bridge_node)

	# Bridge Deck (Spans X: 64 to 98 at Z = 42.0)
	var deck := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(34.0, 0.4, 7.5)
	db.material = asphalt
	deck.mesh = db
	deck.position = Vector3(81.0, 0.25, 42.0)
	deck.add_to_group("hole_cutout_meshes")
	bridge_node.add_child(deck)

	# Red Steel Trusses (North and South sides)
	for side in [-3.8, 3.8]:
		var lower_chord := MeshInstance3D.new()
		var lcb := BoxMesh.new()
		lcb.size = Vector3(34.0, 0.35, 0.3)
		lcb.material = bridge_red
		lower_chord.mesh = lcb
		lower_chord.position = Vector3(81.0, 0.5, 42.0 + side)
		bridge_node.add_child(lower_chord)

		var upper_chord := MeshInstance3D.new()
		var ucb := BoxMesh.new()
		ucb.size = Vector3(34.0, 0.35, 0.3)
		ucb.material = bridge_red
		upper_chord.mesh = ucb
		upper_chord.position = Vector3(81.0, 2.8, 42.0 + side)
		bridge_node.add_child(upper_chord)

		for bx in range(66, 98, 4):
			var vert := MeshInstance3D.new()
			var vb := BoxMesh.new()
			vb.size = Vector3(0.25, 2.3, 0.25)
			vb.material = bridge_red
			vert.mesh = vb
			vert.position = Vector3(float(bx), 1.65, 42.0 + side)
			bridge_node.add_child(vert)

# -----------------------------------------------------------------
# 9. WOODEN PLEASURE PIER & BOARDWALK
# -----------------------------------------------------------------
static func _build_pleasure_pier(parent: Node3D, wood_mat: Material) -> void:
	var pier_node := Node3D.new()
	pier_node.name = "PleasurePier"
	parent.add_child(pier_node)

	# Main boardwalk extending south into water (X = 60.0, Z: 64 to 86)
	var deck := MeshInstance3D.new()
	var db := BoxMesh.new()
	db.size = Vector3(6.5, 0.3, 24.0)
	db.material = wood_mat
	deck.mesh = db
	deck.position = Vector3(60.0, 0.08, 75.0)
	pier_node.add_child(deck)

	# Pierhead octagonal platform (X = 60.0, Z = 86.0)
	var platform := MeshInstance3D.new()
	var pb := BoxMesh.new()
	pb.size = Vector3(14.0, 0.3, 14.0)
	pb.material = wood_mat
	platform.mesh = pb
	platform.position = Vector3(60.0, 0.08, 86.0)
	pier_node.add_child(platform)

# -----------------------------------------------------------------
# 10. LANE MARKINGS & ZEBRA CROSSINGS
# -----------------------------------------------------------------
static func _build_lane_markings(parent: Node3D, white_mat: Material) -> void:
	var markings := Node3D.new()
	markings.name = "RoadMarkings"
	parent.add_child(markings)

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

	# Supermarket Parking Lot Stall Markings (Matching Image 5)
	for px in range(5, 24, 3):
		for pz in [-52.0, -46.0]:
			var stall_line := MeshInstance3D.new()
			var slb := BoxMesh.new()
			slb.size = Vector3(0.12, 0.02, 4.2)
			slb.material = white_mat
			stall_line.mesh = slb
			stall_line.position = Vector3(float(px), 0.03, float(pz))
			stall_line.add_to_group("hole_cutout_meshes")
			markings.add_child(stall_line)

# -----------------------------------------------------------------
# HELPER STRIP SPAWNERS & SURFACE TOOL
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

static func _add_flat_triangle(st: SurfaceTool, v0: Vector3, v1: Vector3, v2: Vector3) -> void:
	var n: Vector3 = (v1 - v0).cross(v2 - v0).normalized()
	st.set_normal(n)
	st.add_vertex(v0)
	st.add_vertex(v1)
	st.add_vertex(v2)

static func _add_flat_quad(st: SurfaceTool, v0: Vector3, v1: Vector3, v2: Vector3, v3: Vector3) -> void:
	_add_flat_triangle(st, v0, v1, v2)
	_add_flat_triangle(st, v0, v2, v3)
