class_name RefTerrainBuilder
extends RefCounted

## Builds low-poly faceted terrain, mountains with tunnel, cliffs, ocean, lake, and athletic stadium
## Faithfully matches the reference images with organic, non-square low-poly geometry

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")

static func build_terrain(parent_node: Node3D, player_hole: PlayerHole) -> void:
	var terrain_root := Node3D.new()
	terrain_root.name = "ReferenceTerrain"
	parent_node.add_child(terrain_root)

	var grass_mat := Constants.get_cutout_material(Constants.COLOR_GRASS, 0.88)
	var forest_mat := Constants.get_cutout_material(Constants.COLOR_FOREST_GRASS, 0.90)
	var rock_mat := Constants.get_cutout_material(Constants.COLOR_MOUNTAIN_ROCK, 0.85)
	var sand_mat := Constants.get_cutout_material(Constants.COLOR_SAND, 0.92)
	var water_deep := Constants.get_cutout_material(Constants.COLOR_WATER_DEEP, 0.20)
	var water_shallow := Constants.get_cutout_material(Constants.COLOR_WATER_SHALLOW, 0.20)
	var track_mat := Constants.get_cutout_material(Constants.COLOR_RUNNING_TRACK, 0.80)
	var soccer_mat := Constants.get_cutout_material(Constants.COLOR_SOCCER_PITCH, 0.85)

	if player_hole:
		player_hole.register_shader_material(grass_mat)
		player_hole.register_shader_material(forest_mat)
		player_hole.register_shader_material(rock_mat)
		player_hole.register_shader_material(sand_mat)
		player_hole.register_shader_material(water_deep)
		player_hole.register_shader_material(water_shallow)
		player_hole.register_shader_material(track_mat)
		player_hole.register_shader_material(soccer_mat)

	# 1. Base Mainland Ground Plane (Urban surface at Y = 0.0)
	_build_mainland_base(terrain_root, grass_mat)

	# 2. Ocean Water & Coastal Drop-offs (East & South)
	_build_ocean_and_waterfront(terrain_root, water_deep, water_shallow, rock_mat)

	# 3. Southeastern Sandy Beach (Region L)
	_build_sandy_beach(terrain_root, sand_mat)

	# 4. Northern Faceted Mountain with Cliffs and Tunnel (Region A - matching Image 4)
	_build_faceted_mountain(terrain_root, rock_mat, forest_mat)

	# 5. Sports Stadium & Soccer Field (Region I - matching Image 1)
	_build_sports_stadium(terrain_root, track_mat, soccer_mat)

	# 6. Central Park Organic Lake & Footbridges (Region H - matching Image 3)
	_build_park_lake(terrain_root, water_shallow, grass_mat)

	# 7. Marina Basin & Breakwater Jetty (Region M - matching Image 2)
	_build_marina_basin(terrain_root, water_shallow, rock_mat)

	# 8. Offshore Lighthouse Islet & Footbridge (Region C - matching Image 2)
	_build_lighthouse_islet(terrain_root, rock_mat)

# -----------------------------------------------------------------
# 1. MAINLAND BASE
# -----------------------------------------------------------------
static func _build_mainland_base(parent: Node3D, mat: Material) -> void:
	var mi := MeshInstance3D.new()
	mi.name = "MainlandGround"
	var b := BoxMesh.new()
	b.size = Vector3(200.0, 0.4, 200.0)
	b.material = mat
	mi.mesh = b
	mi.position = Vector3(0.0, -0.2, 0.0)
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)

# -----------------------------------------------------------------
# 2. OCEAN WATER & COASTAL CLIFFS
# -----------------------------------------------------------------
static func _build_ocean_and_waterfront(parent: Node3D, deep_mat: Material, shallow_mat: Material, rock_mat: Material) -> void:
	var water_container := Node3D.new()
	water_container.name = "OceanWater"
	parent.add_child(water_container)

	# Eastern Deep Ocean Water (X: 62 to 100, Z: -42 to 100)
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

	# Faceted coastal rock cliffs dropping into the water along eastern coastline
	var cliffs := StaticBody3D.new()
	cliffs.name = "CoastalRockCliffs"
	parent.add_child(cliffs)

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(rock_mat)

	var cliff_pts: Array[Vector3] = [
		Vector3(62.0, 0.0, -40.0), Vector3(64.0, -0.6, -40.0),
		Vector3(63.0, 0.0, -10.0), Vector3(66.0, -0.6, -10.0),
		Vector3(61.0, 0.0, 20.0), Vector3(65.0, -0.6, 20.0),
		Vector3(60.0, 0.0, 50.0), Vector3(63.0, -0.6, 50.0)
	]
	for i in range(0, cliff_pts.size() - 2, 2):
		_add_flat_quad(st, cliff_pts[i], cliff_pts[i + 1], cliff_pts[i + 3], cliff_pts[i + 2])

	var c_mesh := st.commit()
	var c_mi := MeshInstance3D.new()
	c_mi.mesh = c_mesh
	c_mi.add_to_group("hole_cutout_meshes")
	cliffs.add_child(c_mi)

# -----------------------------------------------------------------
# 3. SANDY BEACH
# -----------------------------------------------------------------
static func _build_sandy_beach(parent: Node3D, sand_mat: Material) -> void:
	var beach_container := Node3D.new()
	beach_container.name = "SandyBeach"
	parent.add_child(beach_container)

	# Smooth crescent-shaped sandy beach curving along Region L (X: 38 to 78, Z: 56 to 82)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(sand_mat)

	var beach_poly: Array[Vector3] = [
		Vector3(42.0, 0.025, 56.0), Vector3(56.0, 0.025, 54.0),
		Vector3(70.0, 0.025, 58.0), Vector3(76.0, 0.025, 70.0),
		Vector3(68.0, 0.025, 82.0), Vector3(52.0, 0.025, 80.0),
		Vector3(40.0, 0.025, 72.0)
	]
	var center := Vector3(58.0, 0.025, 68.0)
	for i in range(beach_poly.size()):
		var p1 := beach_poly[i]
		var p2 := beach_poly[(i + 1) % beach_poly.size()]
		_add_flat_triangle(st, center, p1, p2)

	var b_mesh := st.commit()
	var b_mi := MeshInstance3D.new()
	b_mi.mesh = b_mesh
	b_mi.add_to_group("hole_cutout_meshes")
	beach_container.add_child(b_mi)

# -----------------------------------------------------------------
# 4. NORTHERN FACETED MOUNTAIN & TUNNEL (Matching Image 4)
# -----------------------------------------------------------------
static func _build_faceted_mountain(parent: Node3D, rock_mat: Material, grass_mat: Material) -> void:
	var mtn := StaticBody3D.new()
	mtn.name = "FacetedMountain"
	parent.add_child(mtn)

	# 1. Main Faceted Rock Cliffs using SurfaceTool
	var st_rock := SurfaceTool.new()
	st_rock.begin(Mesh.PRIMITIVE_TRIANGLES)
	st_rock.set_material(rock_mat)

	# Mountain base perimeter (Elevation Y = 0 to 4)
	var base_ring: Array[Vector3] = [
		Vector3(-96.0, 0.0, -96.0), Vector3(-60.0, 0.0, -96.0),
		Vector3(-45.0, 0.0, -82.0), Vector3(-42.0, 0.0, -60.0),
		Vector3(-55.0, 0.0, -42.0), Vector3(-75.0, 0.0, -42.0),
		Vector3(-96.0, 0.0, -55.0)
	]
	# Mid ridge ring (Elevation Y = 5 to 8)
	var mid_ring: Array[Vector3] = [
		Vector3(-90.0, 6.0, -90.0), Vector3(-68.0, 6.0, -90.0),
		Vector3(-52.0, 5.5, -78.0), Vector3(-50.0, 5.0, -62.0),
		Vector3(-62.0, 5.0, -50.0), Vector3(-78.0, 5.5, -48.0),
		Vector3(-90.0, 6.0, -60.0)
	]
	# Upper summit ring (Elevation Y = 11 to 14)
	var upper_ring: Array[Vector3] = [
		Vector3(-85.0, 13.0, -86.0), Vector3(-70.0, 13.0, -86.0),
		Vector3(-64.0, 13.0, -78.0), Vector3(-66.0, 13.0, -68.0),
		Vector3(-76.0, 13.0, -65.0), Vector3(-85.0, 13.0, -75.0)
	]

	# Build faceted cliff faces between base and mid ring
	for i in range(base_ring.size()):
		var b0 := base_ring[i]
		var b1 := base_ring[(i + 1) % base_ring.size()]
		var m0 := mid_ring[i % mid_ring.size()]
		var m1 := mid_ring[(i + 1) % mid_ring.size()]
		_add_flat_quad(st_rock, b0, b1, m1, m0)

	# Build faceted cliff faces between mid and upper ring
	for i in range(mid_ring.size()):
		var m0 := mid_ring[i]
		var m1 := mid_ring[(i + 1) % mid_ring.size()]
		var u0 := upper_ring[i % upper_ring.size()]
		var u1 := upper_ring[(i + 1) % upper_ring.size()]
		_add_flat_quad(st_rock, m0, m1, u1, u0)

	var rock_mesh := st_rock.commit()
	var rock_mi := MeshInstance3D.new()
	rock_mi.mesh = rock_mesh
	rock_mi.add_to_group("hole_cutout_meshes")
	mtn.add_child(rock_mi)

	# 2. Green Summit Plateau (Elevation Y = 13.0)
	var st_grass := SurfaceTool.new()
	st_grass.begin(Mesh.PRIMITIVE_TRIANGLES)
	st_grass.set_material(grass_mat)
	var summit_center := Vector3(-74.0, 13.0, -76.0)
	for i in range(upper_ring.size()):
		var u0 := upper_ring[i]
		var u1 := upper_ring[(i + 1) % upper_ring.size()]
		_add_flat_triangle(st_grass, summit_center, u0, u1)

	var grass_mesh := st_grass.commit()
	var grass_mi := MeshInstance3D.new()
	grass_mi.mesh = grass_mesh
	grass_mi.add_to_group("hole_cutout_meshes")
	mtn.add_child(grass_mi)

	# 3. Tunnel Portal Arch at Base (X = -72.0, Z = -45.0)
	var tunnel_arch := StaticBody3D.new()
	tunnel_arch.name = "MountainTunnelPortal"
	tunnel_arch.position = Vector3(-72.0, 0.0, -44.0)
	parent.add_child(tunnel_arch)

	var portal_mat := Constants.get_standard_material(Color(0.35, 0.36, 0.38), 0.7)
	# Left and right concrete portal pillars
	for px in [-4.5, 4.5]:
		var pillar := MeshInstance3D.new()
		var pb := BoxMesh.new()
		pb.size = Vector3(1.4, 6.0, 3.5)
		pb.material = portal_mat
		pillar.mesh = pb
		pillar.position = Vector3(px, 3.0, 0.0)
		tunnel_arch.add_child(pillar)

	# Top arch lintel
	var lintel := MeshInstance3D.new()
	var lb := BoxMesh.new()
	lb.size = Vector3(10.4, 1.8, 3.5)
	lb.material = portal_mat
	lintel.mesh = lb
	lintel.position = Vector3(0.0, 6.9, 0.0)
	tunnel_arch.add_child(lintel)

	# Dark tunnel interior
	var interior := MeshInstance3D.new()
	var ib := BoxMesh.new()
	ib.size = Vector3(7.6, 5.8, 0.4)
	ib.material = Constants.get_standard_material(Color(0.05, 0.05, 0.06), 0.9)
	interior.mesh = ib
	interior.position = Vector3(0.0, 3.0, -1.6)
	tunnel_arch.add_child(interior)

	# Mountain collision hull
	var col := CollisionShape3D.new()
	var cs := BoxShape3D.new()
	cs.size = Vector3(46.0, 14.0, 46.0)
	col.shape = cs
	col.position = Vector3(-72.0, 7.0, -72.0)
	mtn.add_child(col)

# -----------------------------------------------------------------
# 5. SPORTS STADIUM (Matching Image 1)
# -----------------------------------------------------------------
static func _build_sports_stadium(parent: Node3D, track_mat: Material, soccer_mat: Material) -> void:
	var stadium := Node3D.new()
	stadium.name = "SportsStadium"
	parent.add_child(stadium)

	# 1. Oval Running Track (Red, size 18 x 28 at X = -52.0, Z = 18.0)
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

	# 3. White Pitch Lines
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

	# 4. Bleachers (West side: X = -62.5, Z = 18.0)
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

# -----------------------------------------------------------------
# 6. CENTRAL PARK LAKE & FOUNTAIN PLAZA (Matching Image 3)
# -----------------------------------------------------------------
static func _build_park_lake(parent: Node3D, water_mat: Material, grass_mat: Material) -> void:
	var lake_node := Node3D.new()
	lake_node.name = "CentralParkLake"
	parent.add_child(lake_node)

	# Organic Kidney-shaped lake using SurfaceTool (Center: X = -12.0, Z = -16.0)
	var st_lake := SurfaceTool.new()
	st_lake.begin(Mesh.PRIMITIVE_TRIANGLES)
	st_lake.set_material(water_mat)

	var lake_perimeter: Array[Vector3] = [
		Vector3(-12.0, 0.015, -28.0), Vector3(-6.0, 0.015, -25.0),
		Vector3(-4.0, 0.015, -18.0), Vector3(-7.0, 0.015, -12.0),
		Vector3(-6.0, 0.015, -6.0), Vector3(-10.0, 0.015, -3.0),
		Vector3(-16.0, 0.015, -4.0), Vector3(-18.0, 0.015, -10.0),
		Vector3(-16.0, 0.015, -18.0), Vector3(-18.0, 0.015, -25.0)
	]
	var lake_center := Vector3(-11.0, 0.015, -16.0)
	for i in range(lake_perimeter.size()):
		var p1 := lake_perimeter[i]
		var p2 := lake_perimeter[(i + 1) % lake_perimeter.size()]
		_add_flat_triangle(st_lake, lake_center, p1, p2)

	var l_mesh := st_lake.commit()
	var l_mi := MeshInstance3D.new()
	l_mi.mesh = l_mesh
	l_mi.add_to_group("hole_cutout_meshes")
	lake_node.add_child(l_mi)

	# 3 Wooden Footbridges / Boardwalks extending into lake (matching Image 3)
	var wood_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.7)
	var bridges: Array[Dictionary] = [
		{"pos": Vector3(-15.0, 0.12, -22.0), "size": Vector3(1.8, 0.15, 6.0), "rot": 0.4},
		{"pos": Vector3(-6.0, 0.12, -15.0), "size": Vector3(1.8, 0.15, 5.5), "rot": -0.6},
		{"pos": Vector3(-14.0, 0.12, -8.0), "size": Vector3(1.8, 0.15, 5.0), "rot": 0.8}
	]
	for br in bridges:
		var bm := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = br["size"]
		b.material = wood_mat
		bm.mesh = b
		bm.position = br["pos"]
		bm.rotation.y = br["rot"]
		lake_node.add_child(bm)

	# Circular Plaza Base for the Fountain (Southwest corner of park: X = -18.0, Z = 4.0)
	var plaza := MeshInstance3D.new()
	var p_cyl := CylinderMesh.new()
	p_cyl.top_radius = 5.5
	p_cyl.bottom_radius = 5.5
	p_cyl.height = 0.04
	p_cyl.radial_segments = 32
	p_cyl.material = Constants.get_cutout_material(Constants.COLOR_SIDEWALK, 0.7)
	plaza.mesh = p_cyl
	plaza.position = Vector3(-18.0, 0.02, 4.0)
	plaza.add_to_group("hole_cutout_meshes")
	lake_node.add_child(plaza)

# -----------------------------------------------------------------
# 7. MARINA BASIN (Matching Image 2)
# -----------------------------------------------------------------
static func _build_marina_basin(parent: Node3D, water_mat: Material, rock_mat: Material) -> void:
	var marina := Node3D.new()
	marina.name = "MarinaBasin"
	parent.add_child(marina)

	# Marina water surface (Y = 0.015)
	var water := MeshInstance3D.new()
	var wb := BoxMesh.new()
	wb.size = Vector3(28.0, 0.02, 34.0)
	wb.material = water_mat
	water.mesh = wb
	water.position = Vector3(-3.0, 0.015, 74.0)
	water.add_to_group("hole_cutout_meshes")
	marina.add_child(water)

	# Curved stone breakwater jetty (X: -18.0 to 9.0, Z = 91.0)
	var jetty := MeshInstance3D.new()
	var jb := BoxMesh.new()
	jb.size = Vector3(28.0, 0.8, 3.2)
	jb.material = rock_mat
	jetty.mesh = jb
	jetty.position = Vector3(-3.0, 0.25, 91.0)
	marina.add_child(jetty)

	# Western pier arm
	var arm_west := MeshInstance3D.new()
	var ab := BoxMesh.new()
	ab.size = Vector3(3.2, 0.8, 22.0)
	ab.material = rock_mat
	arm_west.mesh = ab
	arm_west.position = Vector3(-17.0, 0.25, 80.0)
	marina.add_child(arm_west)

	# Floating finger docks
	var dock_mat := Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.7)
	var spine := MeshInstance3D.new()
	var spb := BoxMesh.new()
	spb.size = Vector3(1.8, 0.20, 24.0)
	spb.material = dock_mat
	spine.mesh = spb
	spine.position = Vector3(-4.0, 0.10, 74.0)
	marina.add_child(spine)

	for z in range(64, 86, 4):
		var finger1 := MeshInstance3D.new()
		var fb := BoxMesh.new()
		fb.size = Vector3(6.0, 0.15, 0.8)
		fb.material = dock_mat
		finger1.mesh = fb
		finger1.position = Vector3(-7.5, 0.10, float(z))
		marina.add_child(finger1)

		var finger2 := MeshInstance3D.new()
		finger2.mesh = fb
		finger2.position = Vector3(-0.5, 0.10, float(z))
		marina.add_child(finger2)

# -----------------------------------------------------------------
# 8. OFFSHORE LIGHTHOUSE ISLET (Matching Image 2)
# -----------------------------------------------------------------
static func _build_lighthouse_islet(parent: Node3D, rock_mat: Material) -> void:
	var islet := StaticBody3D.new()
	islet.name = "LighthouseIslet"
	parent.add_child(islet)

	# Rocky island crag in the water
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(rock_mat)

	var ring: Array[Vector3] = [
		Vector3(84.0, 0.0, -22.0), Vector3(94.0, 0.0, -24.0),
		Vector3(98.0, 0.0, -16.0), Vector3(95.0, 0.0, -8.0),
		Vector3(86.0, 0.0, -10.0)
	]
	var top := Vector3(90.0, 3.2, -16.0)
	for i in range(ring.size()):
		var r0 := ring[i]
		var r1 := ring[(i + 1) % ring.size()]
		_add_flat_triangle(st, top, r0, r1)

	var i_mesh := st.commit()
	var i_mi := MeshInstance3D.new()
	i_mi.mesh = i_mesh
	i_mi.add_to_group("hole_cutout_meshes")
	islet.add_child(i_mi)

	# Lighthouse Tower (White tapered column)
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

	# Lantern Cab & Dome
	var cab := MeshInstance3D.new()
	var cb := CylinderMesh.new()
	cb.top_radius = 1.4
	cb.bottom_radius = 1.4
	cb.height = 1.8
	cb.material = Constants.get_standard_material(Color(0.95, 0.95, 0.5), 0.1)
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

	# Footbridge from mainland to islet
	var footbridge := MeshInstance3D.new()
	var fbb := BoxMesh.new()
	fbb.size = Vector3(10.0, 0.3, 2.2)
	fbb.material = Constants.get_standard_material(Constants.COLOR_PIER_WOOD, 0.7)
	footbridge.mesh = fbb
	footbridge.position = Vector3(81.0, 0.8, -16.0)
	islet.add_child(footbridge)

# -----------------------------------------------------------------
# SURFACE TOOL HELPERS
# -----------------------------------------------------------------
static func _add_flat_triangle(st: SurfaceTool, v0: Vector3, v1: Vector3, v2: Vector3) -> void:
	var n: Vector3 = (v1 - v0).cross(v2 - v0).normalized()
	st.set_normal(n)
	st.add_vertex(v0)
	st.add_vertex(v1)
	st.add_vertex(v2)

static func _add_flat_quad(st: SurfaceTool, v0: Vector3, v1: Vector3, v2: Vector3, v3: Vector3) -> void:
	_add_flat_triangle(st, v0, v1, v2)
	_add_flat_triangle(st, v0, v2, v3)
