class_name RoadNetwork
extends Node3D

const CityMaterials = preload("res://scripts/city/city_materials.gd")

## Builds the exact fixed 200x200 Hole.io road and sidewalk network
## Follows Sections 3, 4, 5, and 6 specifications

# Fixed Road Centre Coordinates (Section 4)
const NS_CENTRES: Array[float] = [-90.0, -40.0, 10.0, 60.0]
const EW_CENTRES: Array[float] = [-90.0, -40.0, 10.0, 60.0]
const ROAD_WIDTH: float = 12.0
const HALF_ROAD: float = 6.0
const SIDEWALK_WIDTH: float = 3.0
const ROAD_Y: float = 0.025
const SIDEWALK_Y: float = 0.20
const KERB_HEIGHT: float = 0.15
const KERB_WIDTH: float = 0.25

# 9 Major Block Boundaries (Section 5)
const BLOCK_Z_RANGES: Array[Vector2] = [
	Vector2(-84.0, -46.0), # Northern
	Vector2(-34.0, 4.0),   # Central
	Vector2(16.0, 54.0),   # Southern
]
const BLOCK_X_RANGES: Array[Vector2] = [
	Vector2(-84.0, -46.0), # Western
	Vector2(-34.0, 4.0),   # Central
	Vector2(16.0, 54.0),   # Eastern
]

func build_network(parent_node: Node3D, player_hole: PlayerHole) -> void:
	var roads_root := Node3D.new()
	roads_root.name = "RoadNetwork"
	parent_node.add_child(roads_root)

	var asphalt_mat := CityMaterials.get_cutout_material(CityMaterials.COLOR_ASPHALT, 0.85)
	var sidewalk_mat := CityMaterials.get_cutout_material(CityMaterials.COLOR_SIDEWALK, 0.90)
	var grass_mat := CityMaterials.get_cutout_material(CityMaterials.COLOR_GRASS, 0.88)
	var kerb_mat := CityMaterials.get_cutout_material(CityMaterials.COLOR_KERB, 0.70)
	var marking_white := CityMaterials.get_cutout_material(CityMaterials.COLOR_ROAD_MARKING_WHITE, 0.50)
	var marking_yellow := CityMaterials.get_cutout_material(CityMaterials.COLOR_ROAD_MARKING_YELLOW, 0.50)

	if player_hole:
		player_hole.register_shader_material(asphalt_mat)
		player_hole.register_shader_material(sidewalk_mat)
		player_hole.register_shader_material(grass_mat)
		player_hole.register_shader_material(kerb_mat)
		player_hole.register_shader_material(marking_white)
		player_hole.register_shader_material(marking_yellow)

	# 1. Base Continuous Ground Plane (200x200 at Y = -0.15)
	_build_ground_plane(roads_root, grass_mat)

	# 2. Roads and 16 Intersections
	_build_roads(roads_root, asphalt_mat)

	# 3. Sidewalks and Kerbs around the 9 major blocks and perimeters
	_build_sidewalks_and_kerbs(roads_root, sidewalk_mat, kerb_mat, grass_mat)

	# 4. Road Markings (Lane dashes, double yellow, pedestrian crossings, stop lines)
	_build_markings(roads_root, marking_white, marking_yellow)

func _build_ground_plane(parent: Node3D, mat: Material) -> void:
	var mi := MeshInstance3D.new()
	mi.name = "ContinuousGroundPlane"
	var plane := BoxMesh.new()
	plane.size = Vector3(200.0, 0.10, 200.0)
	plane.material = mat
	mi.mesh = plane
	mi.position = Vector3(0.0, -0.15, 0.0)
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)

func _build_roads(parent: Node3D, mat: Material) -> void:
	var roads_container := Node3D.new()
	roads_container.name = "RoadSurfaces"
	parent.add_child(roads_container)

	# 16 Intersection Squares (12x12 at Y = ROAD_Y)
	for x in NS_CENTRES:
		for z in EW_CENTRES:
			var mi := MeshInstance3D.new()
			mi.name = "Intersection_X%d_Z%d" % [int(x), int(z)]
			var b := BoxMesh.new()
			b.size = Vector3(ROAD_WIDTH, 0.02, ROAD_WIDTH)
			b.material = mat
			mi.mesh = b
			mi.position = Vector3(x, ROAD_Y, z)
			mi.add_to_group("hole_cutout_meshes")
			roads_container.add_child(mi)

	# North-South Road Segments (spanning between intersections and to boundaries)
	# Intervals along Z: [-100 to -96], [-84 to -46], [-34 to 4], [16 to 54], [66 to 100]
	var z_segments: Array[Vector2] = [
		Vector2(-100.0, -96.0),
		Vector2(-84.0, -46.0),
		Vector2(-34.0, 4.0),
		Vector2(16.0, 54.0),
		Vector2(66.0, 100.0)
	]
	for x in NS_CENTRES:
		for seg in z_segments:
			var length := seg.y - seg.x
			var mid_z := (seg.x + seg.y) * 0.5
			var mi := MeshInstance3D.new()
			mi.name = "RoadNS_X%d_Z%d" % [int(x), int(mid_z)]
			var b := BoxMesh.new()
			b.size = Vector3(ROAD_WIDTH, 0.02, length)
			b.material = mat
			mi.mesh = b
			mi.position = Vector3(x, ROAD_Y, mid_z)
			mi.add_to_group("hole_cutout_meshes")
			roads_container.add_child(mi)

	# East-West Road Segments (spanning between intersections and to boundaries)
	var x_segments: Array[Vector2] = [
		Vector2(-100.0, -96.0),
		Vector2(-84.0, -46.0),
		Vector2(-34.0, 4.0),
		Vector2(16.0, 54.0),
		Vector2(66.0, 100.0)
	]
	for z in EW_CENTRES:
		for seg in x_segments:
			var length := seg.y - seg.x
			var mid_x := (seg.x + seg.y) * 0.5
			var mi := MeshInstance3D.new()
			mi.name = "RoadEW_Z%d_X%d" % [int(z), int(mid_x)]
			var b := BoxMesh.new()
			b.size = Vector3(length, 0.02, ROAD_WIDTH)
			b.material = mat
			mi.mesh = b
			mi.position = Vector3(mid_x, ROAD_Y, z)
			mi.add_to_group("hole_cutout_meshes")
			roads_container.add_child(mi)

func _build_sidewalks_and_kerbs(parent: Node3D, sw_mat: Material, kerb_mat: Material, grass_mat: Material) -> void:
	var sw_container := Node3D.new()
	sw_container.name = "SidewalksAndBlocks"
	parent.add_child(sw_container)

	# 1. For each of the 9 primary blocks:
	# Block boundaries:
	for row in range(3):
		for col in range(3):
			var z_range: Vector2 = BLOCK_Z_RANGES[row]
			var x_range: Vector2 = BLOCK_X_RANGES[col]
			var block_w := x_range.y - x_range.x # e.g. 38 units
			var block_d := z_range.y - z_range.x # e.g. 38 units
			var center_x := (x_range.x + x_range.y) * 0.5
			var center_z := (z_range.x + z_range.y) * 0.5

			# Base block slab (light grass/paved interior at Y = 0.05)
			var base_mi := MeshInstance3D.new()
			base_mi.name = "BlockBase_%d_%d" % [row, col]
			var bb := BoxMesh.new()
			bb.size = Vector3(block_w, 0.05, block_d)
			bb.material = grass_mat
			base_mi.mesh = bb
			base_mi.position = Vector3(center_x, 0.025, center_z)
			base_mi.add_to_group("hole_cutout_meshes")
			sw_container.add_child(base_mi)

			# 4 Sidewalk strips surrounding the block (width = 3.0, top Y = 0.20)
			# North sidewalk (along z_range.x)
			_add_sidewalk_strip(sw_container, sw_mat, kerb_mat,
				Vector3(center_x, SIDEWALK_Y, x_range.x + SIDEWALK_WIDTH * 0.5),
				Vector3(block_w, 0.15, SIDEWALK_WIDTH),
				Vector3(center_x, ROAD_Y + KERB_HEIGHT * 0.5, x_range.x + KERB_WIDTH * 0.5),
				Vector3(block_w, KERB_HEIGHT, KERB_WIDTH),
				true)

			# South sidewalk (along z_range.y)
			_add_sidewalk_strip(sw_container, sw_mat, kerb_mat,
				Vector3(center_x, SIDEWALK_Y, z_range.y - SIDEWALK_WIDTH * 0.5),
				Vector3(block_w, 0.15, SIDEWALK_WIDTH),
				Vector3(center_x, ROAD_Y + KERB_HEIGHT * 0.5, z_range.y - KERB_WIDTH * 0.5),
				Vector3(block_w, KERB_HEIGHT, KERB_WIDTH),
				true)

			# West sidewalk (along x_range.x)
			var inner_d := block_d - SIDEWALK_WIDTH * 2.0
			_add_sidewalk_strip(sw_container, sw_mat, kerb_mat,
				Vector3(x_range.x + SIDEWALK_WIDTH * 0.5, SIDEWALK_Y, center_z),
				Vector3(SIDEWALK_WIDTH, 0.15, inner_d),
				Vector3(x_range.x + KERB_WIDTH * 0.5, ROAD_Y + KERB_HEIGHT * 0.5, center_z),
				Vector3(KERB_WIDTH, KERB_HEIGHT, inner_d),
				false)

			# East sidewalk (along x_range.y)
			_add_sidewalk_strip(sw_container, sw_mat, kerb_mat,
				Vector3(x_range.y - SIDEWALK_WIDTH * 0.5, SIDEWALK_Y, center_z),
				Vector3(SIDEWALK_WIDTH, 0.15, inner_d),
				Vector3(x_range.y - KERB_WIDTH * 0.5, ROAD_Y + KERB_HEIGHT * 0.5, center_z),
				Vector3(KERB_WIDTH, KERB_HEIGHT, inner_d),
				false)

func _add_sidewalk_strip(parent: Node3D, sw_mat: Material, kerb_mat: Material,
		sw_pos: Vector3, sw_size: Vector3,
		kerb_pos: Vector3, kerb_size: Vector3, _is_ns: bool) -> void:
	# Sidewalk mesh
	var sw := MeshInstance3D.new()
	var sw_mesh := BoxMesh.new()
	sw_mesh.size = sw_size
	sw_mesh.material = sw_mat
	sw.mesh = sw_mesh
	sw.position = sw_pos
	sw.add_to_group("hole_cutout_meshes")
	parent.add_child(sw)

	# Kerb mesh
	var kerb := MeshInstance3D.new()
	var kerb_mesh := BoxMesh.new()
	kerb_mesh.size = kerb_size
	kerb_mesh.material = kerb_mat
	kerb.mesh = kerb_mesh
	kerb.position = kerb_pos
	kerb.add_to_group("hole_cutout_meshes")
	parent.add_child(kerb)

func _build_markings(parent: Node3D, white_mat: Material, yellow_mat: Material) -> void:
	var markings_container := Node3D.new()
	markings_container.name = "RoadMarkings"
	parent.add_child(markings_container)

	var mark_y := ROAD_Y + 0.005 # slightly above road surface

	# 1. Dashed White Center Lines (dash 2.0, gap 2.0, width 0.12)
	# Add along segments
	var z_segments: Array[Vector2] = [
		Vector2(-84.0, -46.0),
		Vector2(-34.0, 4.0),
		Vector2(16.0, 54.0),
		Vector2(66.0, 96.0)
	]
	var x_segments: Array[Vector2] = [
		Vector2(-84.0, -46.0),
		Vector2(-34.0, 4.0),
		Vector2(16.0, 54.0),
		Vector2(66.0, 96.0)
	]

	# North-South roads dashed lines (or double yellow on central avenues X = -40 and X = +10)
	for x in NS_CENTRES:
		var is_central_avenue := (absf(x - (-40.0)) < 1.0 or absf(x - 10.0) < 1.0)
		for seg in z_segments:
			if is_central_avenue:
				# Double yellow lines (two 0.12 stripes separated by 0.20)
				_add_line(markings_container, yellow_mat, Vector3(x - 0.16, mark_y, (seg.x + seg.y) * 0.5), Vector3(0.12, 0.005, seg.y - seg.x))
				_add_line(markings_container, yellow_mat, Vector3(x + 0.16, mark_y, (seg.x + seg.y) * 0.5), Vector3(0.12, 0.005, seg.y - seg.x))
			else:
				# White dashes
				var cur_z := seg.x + 2.0
				while cur_z < seg.y - 1.0:
					_add_line(markings_container, white_mat, Vector3(x, mark_y, cur_z + 1.0), Vector3(0.12, 0.005, 2.0))
					cur_z += 4.0

	# East-West roads dashed lines (double yellow on Z = -40 and Z = +10)
	for z in EW_CENTRES:
		var is_central_avenue := (absf(z - (-40.0)) < 1.0 or absf(z - 10.0) < 1.0)
		for seg in x_segments:
			if is_central_avenue:
				_add_line(markings_container, yellow_mat, Vector3((seg.x + seg.y) * 0.5, mark_y, z - 0.16), Vector3(seg.y - seg.x, 0.005, 0.12))
				_add_line(markings_container, yellow_mat, Vector3((seg.x + seg.y) * 0.5, mark_y, z + 0.16), Vector3(seg.y - seg.x, 0.005, 0.12))
			else:
				var cur_x := seg.x + 2.0
				while cur_x < seg.y - 1.0:
					_add_line(markings_container, white_mat, Vector3(cur_x + 1.0, mark_y, z), Vector3(2.0, 0.005, 0.12))
					cur_x += 4.0

	# 2. Zebra Crossings and Stop Lines at 16 Intersections (Section 6.2 & 6.3)
	for x in NS_CENTRES:
		for z in EW_CENTRES:
			# North approach (Z = z - 6.5)
			_add_zebra_crossing(markings_container, white_mat, Vector3(x, mark_y, z - 7.5), true)
			_add_line(markings_container, white_mat, Vector3(x, mark_y, z - 9.0), Vector3(ROAD_WIDTH - 1.0, 0.005, 0.4))

			# South approach (Z = z + 6.5)
			_add_zebra_crossing(markings_container, white_mat, Vector3(x, mark_y, z + 7.5), true)
			_add_line(markings_container, white_mat, Vector3(x, mark_y, z + 9.0), Vector3(ROAD_WIDTH - 1.0, 0.005, 0.4))

			# West approach (X = x - 6.5)
			_add_zebra_crossing(markings_container, white_mat, Vector3(x - 7.5, mark_y, z), false)
			_add_line(markings_container, white_mat, Vector3(x - 9.0, mark_y, z), Vector3(0.4, 0.005, ROAD_WIDTH - 1.0))

			# East approach (X = x + 6.5)
			_add_zebra_crossing(markings_container, white_mat, Vector3(x + 7.5, mark_y, z), false)
			_add_line(markings_container, white_mat, Vector3(x + 9.0, mark_y, z), Vector3(0.4, 0.005, ROAD_WIDTH - 1.0))

func _add_line(parent: Node3D, mat: Material, pos: Vector3, size: Vector3) -> void:
	var mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = mat
	mi.mesh = b
	mi.position = pos
	mi.add_to_group("hole_cutout_meshes")
	parent.add_child(mi)

func _add_zebra_crossing(parent: Node3D, mat: Material, center_pos: Vector3, is_horizontal: bool) -> void:
	# 7 white stripes (width 0.8, spacing ~0.5, length across lanes)
	var stripe_count := 7
	var stripe_width := 0.8
	var stripe_spacing := 0.6
	var stripe_length := 2.4

	for i in range(stripe_count):
		var offset_val := (i - 3) * (stripe_width + stripe_spacing)
		var stripe_pos: Vector3
		var stripe_size: Vector3
		if is_horizontal:
			stripe_pos = center_pos + Vector3(offset_val, 0.0, 0.0)
			stripe_size = Vector3(stripe_width, 0.005, stripe_length)
		else:
			stripe_pos = center_pos + Vector3(0.0, 0.0, offset_val)
			stripe_size = Vector3(stripe_length, 0.005, stripe_width)

		_add_line(parent, mat, stripe_pos, stripe_size)
