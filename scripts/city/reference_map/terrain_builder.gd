class_name RefTerrainBuilder
extends RefCounted

## Builds the continuous low-poly terrain, water bodies, mountains, coastline, and sports field
## Faithfully matches the reference image geography

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

static func build_terrain(parent_node: Node3D, player_hole: PlayerHole) -> void:
	var terrain_root := Node3D.new()
	terrain_root.name = "ReferenceTerrain"
	parent_node.add_child(terrain_root)

	var grass_mat := Constants.get_cutout_material(Constants.COLOR_GRASS, 0.88)
	var rock_mat := Constants.get_cutout_material(Constants.COLOR_MOUNTAIN_ROCK, 0.90)
	var sand_mat := Constants.get_cutout_material(Constants.COLOR_SAND, 0.92)
	var water_deep := Constants.get_cutout_material(Constants.COLOR_WATER_DEEP, 0.20)
	var water_shallow := Constants.get_cutout_material(Constants.COLOR_WATER_SHALLOW, 0.20)
	var track_mat := Constants.get_cutout_material(Constants.COLOR_RUNNING_TRACK, 0.80)
	var soccer_mat := Constants.get_cutout_material(Constants.COLOR_SOCCER_PITCH, 0.85)

	if player_hole:
		player_hole.register_shader_material(grass_mat)
		player_hole.register_shader_material(rock_mat)
		player_hole.register_shader_material(sand_mat)
		player_hole.register_shader_material(water_deep)
		player_hole.register_shader_material(water_shallow)
		player_hole.register_shader_material(track_mat)
		player_hole.register_shader_material(soccer_mat)

	# 1. Base Mainland Ground Plane (Y = 0.0, covering full urban landmass)
	_build_mainland_base(terrain_root, grass_mat)

	# 2. Ocean Water & Coastline (East & South)
	_build_ocean_and_waterfront(terrain_root, water_deep, water_shallow)

	# 3. Southeastern Sandy Beach (Region L)
	_build_sandy_beach(terrain_root, sand_mat)

	# 4. Northern Mountain & Forested Hills with Tunnel (Region A)
	_build_mountain_hills(terrain_root, rock_mat, grass_mat)

	# 5. Sports Stadium & Soccer Field (Region I)
	_build_sports_stadium(terrain_root, track_mat, soccer_mat)

	# 6. Central Park Lake & Bridges (Region H)
	_build_park_lake(terrain_root, water_shallow, grass_mat)

	# 7. Marina Basin & Breakwater Jetty (Region M)
	_build_marina_basin(terrain_root, water_shallow, rock_mat)

	# 8. Offshore Lighthouse Islet & Footbridge (Region C)
	_build_lighthouse_islet(terrain_root, rock_mat)

static func _build_mainland_base(parent: Node3D, mat: Material) -> void:
	# Main Urban Ground Surface at Y = 0.0 (slightly elevated above water at Y = -0.6)
	var mi := MeshInstance3D.new()
	mi.name = "MainlandGround"
	var b := BoxMesh.new()
	b.size = Vector3(200.0, 0.4, 200.0)
	b.material = mat
	mi.mesh = b
	mi.position = Vector3(0.0, -0.2, 0.0)
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)

static func _build_ocean_and_waterfront(parent: Node3D, deep_mat: Material, shallow_mat: Material) -> void:
	var water_container := Node3D.new()
	water_container.name = "OceanWater"
	parent.add_child(water_container)

	# Eastern Ocean Water (X: 62 to 100, Z: -42 to 100)
	var ocean_east := MeshInstance3D.new()
	var eb := BoxMesh.new()
	eb.size = Vector3(40.0, 0.02, 144.0)
	eb.material = deep_mat
	ocean_east.mesh = eb
	ocean_east.position = Vector3(80.0, 0.01, 30.0)
	ocean_east.add_to_group("hole_cutout_meshes")
	water_container.add_child(ocean_east)

	# Northeast Harbor Basin Water (around cargo quays: X: 68 to 100, Z: -100 to -42)
	var harbor_water := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(36.0, 0.02, 58.0)
	hb.material = deep_mat
	harbor_water.mesh = hb
	harbor_water.position = Vector3(82.0, 0.01, -71.0)
	harbor_water.add_to_group("hole_cutout_meshes")
	water_container.add_child(harbor_water)

	# Southern Coastal Ocean (X: -24 to 65, Z: 68 to 100)
	var south_water := MeshInstance3D.new()
	var sb := BoxMesh.new()
	sb.size = Vector3(90.0, 0.02, 34.0)
	sb.material = deep_mat
	south_water.mesh = sb
	south_water.position = Vector3(20.0, 0.01, 84.0)
	south_water.add_to_group("hole_cutout_meshes")
	water_container.add_child(south_water)

	# Shallow Turquoise Coastal Water (Near Beach and Marina)
	var shallow_mesh := MeshInstance3D.new()
	var sm := BoxMesh.new()
	sm.size = Vector3(48.0, 0.025, 30.0)
	sm.material = shallow_mat
	shallow_mesh.mesh = sm
	shallow_mesh.position = Vector3(56.0, 0.015, 68.0)
	shallow_mesh.add_to_group("hole_cutout_meshes")
	water_container.add_child(shallow_mesh)

static func _build_sandy_beach(parent: Node3D, sand_mat: Material) -> void:
	# Crescent-shaped sandy beach curving along Region L (X: 36 to 82, Z: 54 to 86)
	var beach_container := Node3D.new()
	beach_container.name = "SandyBeach"
	parent.add_child(beach_container)

	var beach_segments: Array[Dictionary] = [
		{"pos": Vector3(48.0, 0.025, 62.0), "size": Vector3(18.0, 0.03, 14.0)},
		{"pos": Vector3(62.0, 0.025, 66.0), "size": Vector3(22.0, 0.03, 18.0)},
		{"pos": Vector3(72.0, 0.025, 74.0), "size": Vector3(18.0, 0.03, 16.0)},
		{"pos": Vector3(56.0, 0.025, 76.0), "size": Vector3(16.0, 0.03, 12.0)}
	]

	for s in beach_segments:
		var mi := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = s["size"]
		b.material = sand_mat
		mi.mesh = b
		mi.position = s["pos"]
		mi.add_to_group("hole_cutout_meshes")
		beach_container.add_child(mi)

static func _build_mountain_hills(parent: Node3D, rock_mat: Material, grass_mat: Material) -> void:
	# Northern Forested Hills / Mountain Ridge (Region A: X in [-98, -40], Z in [-98, -40])
	var mtn := StaticBody3D.new()
	mtn.name = "MountainHills"
	parent.add_child(mtn)

	# Stepped low-poly rocky cliff tiers
	var tiers: Array[Dictionary] = [
		# Base Plateau (Y = 2.5)
		{"pos": Vector3(-72.0, 1.25, -72.0), "size": Vector3(48.0, 2.5, 48.0)},
		# Mid Rocky Ridge (Y = 5.5)
		{"pos": Vector3(-76.0, 3.25, -76.0), "size": Vector3(38.0, 4.0, 38.0)},
		# Upper Crags (Y = 8.5)
		{"pos": Vector3(-80.0, 5.5, -80.0), "size": Vector3(28.0, 5.0, 28.0)},
		# Mountain Peak (Y = 12.0)
		{"pos": Vector3(-82.0, 8.0, -82.0), "size": Vector3(18.0, 6.0, 18.0)},
		# Eastern Ridge Spur
		{"pos": Vector3(-52.0, 1.8, -80.0), "size": Vector3(22.0, 3.6, 26.0)},
		# Southern Foothills near Tunnel
		{"pos": Vector3(-84.0, 1.8, -50.0), "size": Vector3(24.0, 3.6, 20.0)}
	]

	for t in tiers:
		var mi := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = t["size"]
		b.material = rock_mat
		mi.mesh = b
		mi.position = t["pos"]
		mi.add_to_group("hole_cutout_meshes")
		mtn.add_child(mi)

		# Add Collision for mountain slopes
		var col := CollisionShape3D.new()
		var cs := BoxShape3D.new()
		cs.size = t["size"]
		col.shape = cs
		col.position = t["pos"]
		mtn.add_child(col)

		# Green grassy cap on top of plateau
		var cap := MeshInstance3D.new()
		var cb := BoxMesh.new()
		cb.size = Vector3(t["size"].x * 0.92, 0.15, t["size"].z * 0.92)
		cb.material = grass_mat
		cap.mesh = cb
		cap.position = Vector3(t["pos"].x, t["pos"].y + t["size"].y * 0.5 + 0.08, t["pos"].z)
		cap.add_to_group("hole_cutout_meshes")
		mtn.add_child(cap)

	# Tunnel Entrance Portal at base of mountain (X = -76.0, Z = -42.0)
	var portal_frame := MeshInstance3D.new()
	var pfb := BoxMesh.new()
	pfb.size = Vector3(10.0, 4.5, 3.0)
	pfb.material = rock_mat
	portal_frame.mesh = pfb
	portal_frame.position = Vector3(-76.0, 2.25, -42.0)
	mtn.add_child(portal_frame)

	var tunnel_blackout := MeshInstance3D.new()
	var tbb := BoxMesh.new()
	tbb.size = Vector3(6.5, 3.5, 0.2)
	tbb.material = Constants.get_standard_material(Color(0.04, 0.04, 0.05), 0.9)
	tunnel_blackout.mesh = tbb
	tunnel_blackout.position = Vector3(-76.0, 1.75, -40.4)
	mtn.add_child(tunnel_blackout)

static func _build_sports_stadium(parent: Node3D, track_mat: Material, soccer_mat: Material) -> void:
	# Athletic running track & soccer pitch in Region I (Center: X = -52.0, Z = 18.0)
	var stadium := Node3D.new()
	stadium.name = "SportsStadium"
	parent.add_child(stadium)

	# 1. Oval Running Track (Red asphalt, size 18 x 28)
	var track := MeshInstance3D.new()
	var tb := BoxMesh.new()
	tb.size = Vector3(18.0, 0.04, 28.0)
	tb.material = track_mat
	track.mesh = tb
	track.position = Vector3(-52.0, 0.02, 18.0)
	track.add_to_group("hole_cutout_meshes")
	stadium.add_child(track)

	# 2. Inner Soccer Pitch (Green grass, size 11 x 21)
	var pitch := MeshInstance3D.new()
	var pb := BoxMesh.new()
	pb.size = Vector3(11.0, 0.05, 21.0)
	pb.material = soccer_mat
	pitch.mesh = pb
	pitch.position = Vector3(-52.0, 0.03, 18.0)
	pitch.add_to_group("hole_cutout_meshes")
	stadium.add_child(pitch)

	# 3. White Pitch Markings (Perimeter + Center Line + Center Circle)
	var white_mat := Constants.get_standard_material(Color(0.96, 0.96, 0.96), 0.4)
	var center_line := MeshInstance3D.new()
	var clb := BoxMesh.new()
	clb.size = Vector3(10.8, 0.06, 0.2)
	clb.material = white_mat
	center_line.mesh = clb
	center_line.position = Vector3(-52.0, 0.04, 18.0)
	stadium.add_child(center_line)

	var center_circle := MeshInstance3D.new()
	var ccb := CylinderMesh.new()
	ccb.top_radius = 2.2
	ccb.bottom_radius = 2.2
	ccb.height = 0.06
	ccb.material = white_mat
	center_circle.mesh = ccb
	center_circle.position = Vector3(-52.0, 0.04, 18.0)
	stadium.add_child(center_circle)

	# 4. Stadium Bleachers (West side: X = -62.5, Z = 18.0)
	var bleachers := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(2.5, 2.2, 22.0)
	bb.material = Constants.get_standard_material(Color(0.70, 0.72, 0.75), 0.5)
	bleachers.mesh = bb
	bleachers.position = Vector3(-62.5, 1.1, 18.0)
	stadium.add_child(bleachers)

	# Canopy roof over bleachers
	var canopy := MeshInstance3D.new()
	var cb := BoxMesh.new()
	cb.size = Vector3(3.5, 0.2, 22.5)
	cb.material = Constants.get_standard_material(Color(0.25, 0.45, 0.75), 0.5)
	canopy.mesh = cb
	canopy.position = Vector3(-62.0, 2.8, 18.0)
	stadium.add_child(canopy)

static func _build_park_lake(parent: Node3D, water_mat: Material, grass_mat: Material) -> void:
	# Central Park organic lake in Region H (Center: X = -25.0, Z = -22.0)
	var lake_node := Node3D.new()
	lake_node.name = "CentralParkLake"
	parent.add_child(lake_node)

	# Water surface (slightly elevated at Y = 0.015)
	var lake_water := MeshInstance3D.new()
	var wb := BoxMesh.new()
	wb.size = Vector3(15.0, 0.02, 19.0)
	wb.material = water_mat
	lake_water.mesh = wb
	lake_water.position = Vector3(-25.0, 0.015, -22.0)
	lake_water.add_to_group("hole_cutout_meshes")
	lake_node.add_child(lake_water)

	# White arched footbridge crossing the lake center
	var bridge := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(3.2, 0.35, 17.0)
	bb.material = Constants.get_standard_material(Color(0.94, 0.94, 0.94), 0.3)
	bridge.mesh = bb
	bridge.position = Vector3(-25.0, 0.25, -22.0)
	lake_node.add_child(bridge)

	# Bridge railings
	for side in [-1.5, 1.5]:
		var rail := MeshInstance3D.new()
		var rb := BoxMesh.new()
		rb.size = Vector3(0.12, 0.65, 17.0)
		rb.material = Constants.get_standard_material(Color(0.85, 0.85, 0.88), 0.3)
		rail.mesh = rb
		rail.position = Vector3(-25.0 + side, 0.65, -22.0)
		lake_node.add_child(rail)

static func _build_marina_basin(parent: Node3D, water_mat: Material, rock_mat: Material) -> void:
	# Marina basin in Region M (X = -2.0, Z = 74.0)
	var marina := Node3D.new()
	marina.name = "MarinaBasin"
	parent.add_child(marina)

	# Marina sheltered water surface (Y = 0.015)
	var water := MeshInstance3D.new()
	var wb := BoxMesh.new()
	wb.size = Vector3(28.0, 0.02, 34.0)
	wb.material = water_mat
	water.mesh = wb
	water.position = Vector3(-3.0, 0.015, 74.0)
	water.add_to_group("hole_cutout_meshes")
	marina.add_child(water)

	# Curved stone breakwater jetty protecting harbor (X: -18.0 to 9.0, Z = 91.0)
	var jetty := MeshInstance3D.new()
	var jb := BoxMesh.new()
	jb.size = Vector3(28.0, 0.8, 3.2)
	jb.material = rock_mat
	jetty.mesh = jb
	jetty.position = Vector3(-3.0, -0.15, 91.0)
	marina.add_child(jetty)

	# Western pier arm
	var arm_west := MeshInstance3D.new()
	var ab := BoxMesh.new()
	ab.size = Vector3(3.2, 0.8, 22.0)
	ab.material = rock_mat
	arm_west.mesh = ab
	arm_west.position = Vector3(-17.0, -0.15, 80.0)
	marina.add_child(arm_west)

	# Floating finger docks (Wood planks for boats)
	var dock_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.7)
	# Main central dock spine
	var spine := MeshInstance3D.new()
	var spb := BoxMesh.new()
	spb.size = Vector3(1.8, 0.25, 24.0)
	spb.material = dock_mat
	spine.mesh = spb
	spine.position = Vector3(-4.0, -0.42, 74.0)
	marina.add_child(spine)

	# Finger berths
	for z in range(64, 86, 4):
		var finger1 := MeshInstance3D.new()
		var fb := BoxMesh.new()
		fb.size = Vector3(6.0, 0.20, 0.8)
		fb.material = dock_mat
		finger1.mesh = fb
		finger1.position = Vector3(-7.5, -0.42, float(z))
		marina.add_child(finger1)

		var finger2 := MeshInstance3D.new()
		finger2.mesh = fb
		finger2.position = Vector3(-0.5, -0.42, float(z))
		marina.add_child(finger2)

static func _build_lighthouse_islet(parent: Node3D, rock_mat: Material) -> void:
	# Offshore rocky islet in Region C (X = 90.0, Z = -16.0)
	var islet := StaticBody3D.new()
	islet.name = "LighthouseIslet"
	parent.add_child(islet)

	# Rocky island crag rising out of water
	var rock := MeshInstance3D.new()
	var rb := CylinderMesh.new()
	rb.top_radius = 5.5
	rb.bottom_radius = 7.5
	rb.height = 3.5
	rb.material = rock_mat
	rock.mesh = rb
	rock.position = Vector3(90.0, 0.6, -16.0)
	islet.add_child(rock)

	var col := CollisionShape3D.new()
	var cs := CylinderShape3D.new()
	cs.radius = 6.0
	cs.height = 3.5
	col.shape = cs
	col.position = Vector3(90.0, 0.6, -16.0)
	islet.add_child(col)

	# Lighthouse Tower (White & Red striped cylinder, height 12.0)
	var lh_base := MeshInstance3D.new()
	var lb := CylinderMesh.new()
	lb.top_radius = 1.3
	lb.bottom_radius = 1.8
	lb.height = 10.0
	lb.material = Constants.get_standard_material(Color(0.96, 0.96, 0.96), 0.3)
	lh_base.mesh = lb
	lh_base.position = Vector3(90.0, 7.3, -16.0)
	islet.add_child(lh_base)

	# Red stripes
	for y in [4.5, 7.5]:
		var stripe := MeshInstance3D.new()
		var sb := CylinderMesh.new()
		sb.top_radius = 1.6
		sb.bottom_radius = 1.65
		sb.height = 1.8
		sb.material = Constants.get_standard_material(Color(0.88, 0.18, 0.15), 0.4)
		stripe.mesh = sb
		stripe.position = Vector3(90.0, float(y), -16.0)
		islet.add_child(stripe)

	# Lantern Cab & Roof Cupola
	var cab := MeshInstance3D.new()
	var cb := CylinderMesh.new()
	cb.top_radius = 1.4
	cb.bottom_radius = 1.4
	cb.height = 1.8
	cb.material = Constants.get_standard_material(Color(0.95, 0.95, 0.5), 0.1) # Bright yellow light
	cab.mesh = cb
	cab.position = Vector3(90.0, 13.0, -16.0)
	islet.add_child(cab)

	var dome := MeshInstance3D.new()
	var db := CylinderMesh.new()
	db.top_radius = 0.1
	db.bottom_radius = 1.5
	db.height = 1.2
	db.material = Constants.get_standard_material(Color(0.88, 0.18, 0.15), 0.4)
	dome.mesh = db
	dome.position = Vector3(90.0, 14.5, -16.0)
	islet.add_child(dome)

	# Wooden footbridge connecting from mainland cliff (X = 77.0, Z = -16.0) to island (X = 85.0, Z = -16.0)
	var footbridge := MeshInstance3D.new()
	var fbb := BoxMesh.new()
	fbb.size = Vector3(10.0, 0.3, 2.2)
	fbb.material = Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.7)
	footbridge.mesh = fbb
	footbridge.position = Vector3(81.0, 0.8, -16.0)
	islet.add_child(footbridge)
