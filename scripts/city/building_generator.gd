class_name BuildingGenerator
extends RefCounted

const CityMaterials = preload("res://scripts/city/city_materials.gd")

## Generates stylized 3D buildings according to Sections 7, 8, 14, and 15 specifications
## Creates StaticBody3D structures with full architectural detailing, windows, doors, roofs, and signage

static func build_all_buildings(parent_node: Node3D) -> void:
	var buildings_root := Node3D.new()
	buildings_root.name = "CityBuildings"
	parent_node.add_child(buildings_root)

	# -----------------------------------------------------------------
	# BLOCK A — NORTHWEST RESIDENTIAL DISTRICT (X: -84 to -46, Z: -84 to -46)
	# -----------------------------------------------------------------
	# A1: Detached house (-74, -72), 10 x 6 x 9, warm cream, terracotta roof
	_build_house(buildings_root, "Building_A1_House", Vector3(-74.0, 0.0, -72.0), Vector3(10.0, 6.0, 9.0),
		CityMaterials.COLOR_BUILDING_CREAM, CityMaterials.COLOR_ROOF_TERRACOTTA, "pitch", "south", 4, "")

	# A2: Blue townhouse (-60, -73), 8 x 8 x 9, muted blue, charcoal roof
	_build_house(buildings_root, "Building_A2_Townhouse", Vector3(-60.0, 0.0, -73.0), Vector3(8.0, 8.0, 9.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, CityMaterials.COLOR_ROOF_CHARCOAL, "pitch", "south", 6, "")

	# A3: Corner house (-74, -58), 9 x 7 x 8, pale yellow, dark brown roof
	_build_house(buildings_root, "Building_A3_CornerHouse", Vector3(-74.0, 0.0, -58.0), Vector3(9.0, 7.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_YELLOW, CityMaterials.COLOR_ROOF_CHARCOAL, "pitch", "east", 4, "")

	# A4: Residential duplex (-60, -58), 8 x 7 x 8, muted peach, dark grey roof
	_build_house(buildings_root, "Building_A4_Duplex", Vector3(-60.0, 0.0, -58.0), Vector3(8.0, 7.0, 8.0),
		CityMaterials.COLOR_BUILDING_MUTED_PEACH, CityMaterials.COLOR_ROOF_CHARCOAL, "pitch", "south", 6, "")

	# A5: Small apartment building (-50, -66), 7 x 11 x 12, pale grey, flat roof, 3 storeys
	_build_apartment(buildings_root, "Building_A5_Apartment", Vector3(-50.0, 0.0, -66.0), Vector3(7.0, 11.0, 12.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, 3, "west")

	# -----------------------------------------------------------------
	# BLOCK B — NORTHERN MIXED RESIDENTIAL DISTRICT (X: -34 to +4, Z: -84 to -46)
	# -----------------------------------------------------------------
	# B1: Apartment block (-24, -73), 11 x 15 x 12, warm light grey + blue accent, 4 storeys
	_build_apartment(buildings_root, "Building_B1_Apartment", Vector3(-24.0, 0.0, -73.0), Vector3(11.0, 15.0, 12.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, 4, "south", CityMaterials.COLOR_BUILDING_PALE_BLUE)

	# B2: Modern townhouse (-8, -73), 9 x 9 x 10, pale beige, dark grey roof
	_build_house(buildings_root, "Building_B2_Townhouse", Vector3(-8.0, 0.0, -73.0), Vector3(9.0, 9.0, 10.0),
		CityMaterials.COLOR_BUILDING_CREAM, CityMaterials.COLOR_ROOF_CHARCOAL, "pitch", "south", 4, "")

	# B3: Detached house (-25, -56), 9 x 6 x 8, light green, terracotta roof
	_build_house(buildings_root, "Building_B3_House", Vector3(-25.0, 0.0, -56.0), Vector3(9.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_MUTED_GREEN, CityMaterials.COLOR_ROOF_TERRACOTTA, "pitch", "south", 4, "")

	# B4: Small residential building (-9, -57), 10 x 8 x 8, off-white, dark grey roof
	_build_house(buildings_root, "Building_B4_Residential", Vector3(-9.0, 0.0, -57.0), Vector3(10.0, 8.0, 8.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, CityMaterials.COLOR_ROOF_CHARCOAL, "pitch", "south", 4, "")

	# -----------------------------------------------------------------
	# BLOCK C — NORTHEAST COMMERCIAL DISTRICT (X: +16 to +54, Z: -84 to -46)
	# -----------------------------------------------------------------
	# C1: Supermarket (+34, -72), 20 x 8 x 17, off-white + grey trim, sign "FRESHMART"
	_build_commercial(buildings_root, "Building_C1_Supermarket", Vector3(34.0, 0.0, -72.0), Vector3(20.0, 8.0, 17.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, "FRESHMART", CityMaterials.COLOR_BUILDING_PALE_BLUE, "south", true)

	# C2: Small café (+22, -54), 10 x 6 x 8, pale cream + green accent, sign "CAFE"
	_build_commercial(buildings_root, "Building_C2_Cafe", Vector3(22.0, 0.0, -54.0), Vector3(10.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_CREAM, "CAFE", CityMaterials.COLOR_AWNING_GREEN, "south", false)

	# C3: Corner retail shop (+43, -54), 10 x 7 x 8, pale blue, sign "MARKET"
	_build_commercial(buildings_root, "Building_C3_Market", Vector3(43.0, 0.0, -54.0), Vector3(10.0, 7.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, "MARKET", CityMaterials.COLOR_AWNING_ORANGE, "south", false)

	# Supermarket Parking Area (south of C1): X: +20 to +48, Z: -62 to -48
	_build_parking_lot(buildings_root, "Parking_BlockC", Vector3(34.0, 0.027, -55.0), Vector2(28.0, 14.0), 6)

	# -----------------------------------------------------------------
	# BLOCK D — WESTERN MIXED-USE DISTRICT (X: -84 to -46, Z: -34 to +4)
	# -----------------------------------------------------------------
	# D1: Small office (-73, -22), 12 x 12 x 10, light grey, 3 floors
	_build_office(buildings_root, "Building_D1_Office", Vector3(-73.0, 0.0, -22.0), Vector3(12.0, 12.0, 10.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, 3, "south")

	# D2: Restaurant (-57, -22), 12 x 7 x 10, warm beige + red accent, sign "PIZZA"
	_build_commercial(buildings_root, "Building_D2_Pizza", Vector3(-57.0, 0.0, -22.0), Vector3(12.0, 7.0, 10.0),
		CityMaterials.COLOR_BUILDING_CREAM, "PIZZA", CityMaterials.COLOR_AWNING_RED, "south", false)

	# D3: Small house (-73, -3), 9 x 6 x 8, pale yellow, terracotta roof
	_build_house(buildings_root, "Building_D3_House", Vector3(-73.0, 0.0, -3.0), Vector3(9.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_YELLOW, CityMaterials.COLOR_ROOF_TERRACOTTA, "pitch", "south", 4, "")

	# D4: Corner shop (-57, -3), 10 x 6 x 8, pale turquoise, sign "SHOP"
	_build_commercial(buildings_root, "Building_D4_Shop", Vector3(-57.0, 0.0, -3.0), Vector3(10.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, "SHOP", CityMaterials.COLOR_AWNING_GREEN, "south", false)

	# -----------------------------------------------------------------
	# BLOCK E — CENTRAL BUSINESS DISTRICT & CENTRAL PLAZA (X: -34 to +4, Z: -34 to +4)
	# -----------------------------------------------------------------
	# E1: Central office tower (-24, -23), 12 x 23 x 12, pale blue-grey, 6 storeys, antenna
	_build_office(buildings_root, "Building_E1_Tower", Vector3(-24.0, 0.0, -23.0), Vector3(12.0, 23.0, 12.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, 6, "south", true)

	# E2: Financial office (-8, -23), 12 x 18 x 12, warm grey, 4-5 storeys, canopy
	_build_office(buildings_root, "Building_E2_Financial", Vector3(-8.0, 0.0, -23.0), Vector3(12.0, 18.0, 12.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, 5, "south")

	# E3: Low commercial building (-25, -7), 10 x 7 x 9, off-white, sign "CITY CAFE"
	_build_commercial(buildings_root, "Building_E3_CityCafe", Vector3(-25.0, 0.0, -7.0), Vector3(10.0, 7.0, 9.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, "CITY CAFE", CityMaterials.COLOR_AWNING_ORANGE, "south", false)

	# E4: Corner retail building (-9, -7), 10 x 8 x 9, pale yellow, sign "CITY SHOP"
	_build_commercial(buildings_root, "Building_E4_CityShop", Vector3(-9.0, 0.0, -7.0), Vector3(10.0, 8.0, 9.0),
		CityMaterials.COLOR_BUILDING_PALE_YELLOW, "CITY SHOP", CityMaterials.COLOR_AWNING_RED, "south", false)

	# Central Public Plaza (approx 10x10 near (0, 0)) - Section 8 Block E
	_build_central_plaza(buildings_root, Vector3(0.0, 0.026, 0.0))

	# -----------------------------------------------------------------
	# BLOCK F — EASTERN RESIDENTIAL AND RETAIL DISTRICT (X: +16 to +54, Z: -34 to +4)
	# -----------------------------------------------------------------
	# F1: Apartment building (+25, -23), 11 x 14 x 12, pale peach, 4 storeys
	_build_apartment(buildings_root, "Building_F1_Apartment", Vector3(25.0, 0.0, -23.0), Vector3(11.0, 14.0, 12.0),
		CityMaterials.COLOR_BUILDING_MUTED_PEACH, 4, "south")

	# F2: Bookshop (+42, -23), 11 x 7 x 10, muted green, sign "BOOKS"
	_build_commercial(buildings_root, "Building_F2_Bookshop", Vector3(42.0, 0.0, -23.0), Vector3(11.0, 7.0, 10.0),
		CityMaterials.COLOR_BUILDING_MUTED_GREEN, "BOOKS", CityMaterials.COLOR_AWNING_ORANGE, "south", false)

	# F3: Small house (+25, -5), 9 x 6 x 8, off-white, terracotta roof
	_build_house(buildings_root, "Building_F3_House", Vector3(25.0, 0.0, -5.0), Vector3(9.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, CityMaterials.COLOR_ROOF_TERRACOTTA, "pitch", "south", 4, "")

	# F4: Pharmacy (+42, -5), 10 x 6 x 8, pale blue, sign "PHARMACY"
	_build_commercial(buildings_root, "Building_F4_Pharmacy", Vector3(42.0, 0.0, -5.0), Vector3(10.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, "PHARMACY", CityMaterials.COLOR_AWNING_GREEN, "south", false)

	# -----------------------------------------------------------------
	# BLOCK G — SOUTHWEST SERVICE AND PARKING DISTRICT (X: -84 to -46, Z: +16 to +54)
	# -----------------------------------------------------------------
	# G1: Small warehouse (-72, +29), 17 x 9 x 15, warm grey, roll-up loading door
	_build_warehouse(buildings_root, "Building_G1_Warehouse", Vector3(-72.0, 0.0, 29.0), Vector3(17.0, 9.0, 15.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE)

	# G2: Service station building (-53, +29), 10 x 6 x 12, off-white + red accent, sign "AUTO"
	_build_commercial(buildings_root, "Building_G2_Auto", Vector3(-53.0, 0.0, 29.0), Vector3(10.0, 6.0, 12.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, "AUTO", CityMaterials.COLOR_AWNING_RED, "south", true)

	# G3: Small storage building (-73, +48), 10 x 5 x 7, pale grey, flat roof
	_build_warehouse(buildings_root, "Building_G3_Storage", Vector3(-73.0, 0.0, 48.0), Vector3(10.0, 5.0, 7.0),
		CityMaterials.COLOR_BUILDING_CREAM)

	# Parking Area in southern part of Block G (X: -65 to -48, Z: 38 to 52)
	_build_parking_lot(buildings_root, "Parking_BlockG", Vector3(-57.0, 0.027, 45.0), Vector2(16.0, 14.0), 8)

	# -----------------------------------------------------------------
	# BLOCK H — SOUTHERN CENTRAL PARK (X: -34 to +4, Z: +16 to +54)
	# -----------------------------------------------------------------
	_build_central_park(buildings_root, Vector3(-15.0, 0.0, 35.0), Vector2(34.0, 34.0))

	# -----------------------------------------------------------------
	# BLOCK I — SOUTHEAST MIXED COMMERCIAL DISTRICT (X: +16 to +54, Z: +16 to +54)
	# -----------------------------------------------------------------
	# I1: Small hotel (+25, +29), 12 x 16 x 12, pale beige + blue accent, sign "HOTEL"
	_build_office(buildings_root, "Building_I1_Hotel", Vector3(25.0, 0.0, 29.0), Vector3(12.0, 16.0, 12.0),
		CityMaterials.COLOR_BUILDING_CREAM, 4, "south", false, "HOTEL")

	# I2: Restaurant (+43, +29), 10 x 7 x 10, pale yellow + orange accent, sign "DINER"
	_build_commercial(buildings_root, "Building_I2_Diner", Vector3(43.0, 0.0, 29.0), Vector3(10.0, 7.0, 10.0),
		CityMaterials.COLOR_BUILDING_PALE_YELLOW, "DINER", CityMaterials.COLOR_AWNING_ORANGE, "south", false)

	# I3: Small apartment building (+25, +48), 10 x 10 x 8, pale grey, 3 storeys
	_build_apartment(buildings_root, "Building_I3_Apartment", Vector3(25.0, 0.0, 48.0), Vector3(10.0, 10.0, 8.0),
		CityMaterials.COLOR_BUILDING_OFFWHITE, 3, "south")

	# I4: Corner shop (+43, +48), 9 x 6 x 8, muted turquoise, sign "MINI MART"
	_build_commercial(buildings_root, "Building_I4_MiniMart", Vector3(43.0, 0.0, 48.0), Vector3(9.0, 6.0, 8.0),
		CityMaterials.COLOR_BUILDING_PALE_BLUE, "MINI MART", CityMaterials.COLOR_AWNING_GREEN, "south", false)

	# Parking Area in Block I
	_build_parking_lot(buildings_root, "Parking_BlockI", Vector3(34.0, 0.027, 40.0), Vector2(16.0, 12.0), 6)

# -----------------------------------------------------------------
# BUILDING CONSTRUCTION SUB-ROUTINES
# -----------------------------------------------------------------

static func _build_house(parent: Node3D, node_name: String, pos: Vector3, size: Vector3,
		wall_color: Color, roof_color: Color, roof_type: String, _door_side: String, window_count: int, _sign_text: String) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = Vector3(pos.x, size.y * 0.5, pos.z)
	parent.add_child(body)

	# Static collision
	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	col.shape = box
	body.add_child(col)

	# Main wall volume
	var wall_mi := MeshInstance3D.new()
	var wall_b := BoxMesh.new()
	wall_b.size = Vector3(size.x, size.y, size.z)
	wall_b.material = CityMaterials.get_standard_material(wall_color, 0.7)
	wall_mi.mesh = wall_b
	body.add_child(wall_mi)

	# Roof
	if roof_type == "pitch":
		var roof_mi := MeshInstance3D.new()
		var prism := PrismMesh.new()
		prism.size = Vector3(size.x + 0.6, 2.2, size.z + 0.6)
		prism.material = CityMaterials.get_standard_material(roof_color, 0.8)
		roof_mi.mesh = prism
		roof_mi.position = Vector3(0.0, size.y * 0.5 + 1.1, 0.0)
		body.add_child(roof_mi)
	else:
		_add_flat_roof_parapet(body, size, roof_color)

	# Door (South side by default, Z = +size.z * 0.5)
	_add_door(body, Vector3(0.0, -size.y * 0.5 + 1.1, size.z * 0.5 + 0.02), Vector2(1.2, 2.2))

	# Windows (distributed symmetrically)
	_add_windows_grid(body, size, window_count)

static func _build_apartment(parent: Node3D, node_name: String, pos: Vector3, size: Vector3,
		wall_color: Color, floors: int, _entrance_side: String, accent_color: Color = Color.TRANSPARENT) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = Vector3(pos.x, size.y * 0.5, pos.z)
	parent.add_child(body)

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	col.shape = box
	body.add_child(col)

	var wall_mi := MeshInstance3D.new()
	var wall_b := BoxMesh.new()
	wall_b.size = size
	wall_b.material = CityMaterials.get_standard_material(wall_color, 0.7)
	wall_mi.mesh = wall_b
	body.add_child(wall_mi)

	# Accent strip if specified
	if accent_color != Color.TRANSPARENT:
		var acc_mi := MeshInstance3D.new()
		var acc_b := BoxMesh.new()
		acc_b.size = Vector3(size.x + 0.05, 0.8, size.z + 0.05)
		acc_b.material = CityMaterials.get_standard_material(accent_color, 0.6)
		acc_mi.mesh = acc_b
		acc_mi.position = Vector3(0.0, size.y * 0.5 - 2.0, 0.0)
		body.add_child(acc_mi)

	_add_flat_roof_parapet(body, size, CityMaterials.COLOR_ROOF_CHARCOAL)
	_add_door(body, Vector3(0.0, -size.y * 0.5 + 1.2, size.z * 0.5 + 0.02), Vector2(1.6, 2.4))
	_add_apartment_windows(body, size, floors)

static func _build_commercial(parent: Node3D, node_name: String, pos: Vector3, size: Vector3,
		wall_color: Color, sign_text: String, awning_color: Color, _side: String, is_supermarket: bool) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = Vector3(pos.x, size.y * 0.5, pos.z)
	parent.add_child(body)

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	col.shape = box
	body.add_child(col)

	var wall_mi := MeshInstance3D.new()
	var wall_b := BoxMesh.new()
	wall_b.size = size
	wall_b.material = CityMaterials.get_standard_material(wall_color, 0.75)
	wall_mi.mesh = wall_b
	body.add_child(wall_mi)

	_add_flat_roof_parapet(body, size, CityMaterials.COLOR_ROOF_CHARCOAL)

	# Storefront Display Window & Double Glass Door
	var front_z := size.z * 0.5 + 0.02
	if is_supermarket:
		# Broad supermarket entrance
		_add_door(body, Vector3(0.0, -size.y * 0.5 + 1.4, front_z), Vector2(3.2, 2.8))
		# Storefront glass panels
		_add_window(body, Vector3(-5.5, -size.y * 0.5 + 1.4, front_z), Vector2(4.5, 2.4))
		_add_window(body, Vector3(5.5, -size.y * 0.5 + 1.4, front_z), Vector2(4.5, 2.4))
		# Loading door on East side
		_add_garage_door(body, Vector3(size.x * 0.5 + 0.02, -size.y * 0.5 + 2.0, 0.0), Vector2(3.5, 3.5), true)
	else:
		_add_door(body, Vector3(0.0, -size.y * 0.5 + 1.2, front_z), Vector2(1.6, 2.4))
		_add_window(body, Vector3(-size.x * 0.25, -size.y * 0.5 + 1.2, front_z), Vector2(size.x * 0.35, 2.0))
		_add_window(body, Vector3(size.x * 0.25, -size.y * 0.5 + 1.2, front_z), Vector2(size.x * 0.35, 2.0))

	# Colorful Fabric Awning
	_add_awning(body, Vector3(0.0, -size.y * 0.5 + 2.7, front_z + 0.6), Vector3(size.x * 0.75, 0.5, 1.2), awning_color)

	# Signboard with 3D Text
	_add_signboard(body, Vector3(0.0, -size.y * 0.5 + 3.5, front_z + 0.08), sign_text)

static func _build_office(parent: Node3D, node_name: String, pos: Vector3, size: Vector3,
		wall_color: Color, storeys: int, _side: String, has_antenna: bool = false, custom_sign: String = "") -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = Vector3(pos.x, size.y * 0.5, pos.z)
	parent.add_child(body)

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	col.shape = box
	body.add_child(col)

	var wall_mi := MeshInstance3D.new()
	var wall_b := BoxMesh.new()
	wall_b.size = size
	wall_b.material = CityMaterials.get_standard_material(wall_color, 0.7)
	wall_mi.mesh = wall_b
	body.add_child(wall_mi)

	_add_flat_roof_parapet(body, size, CityMaterials.COLOR_ROOF_CHARCOAL)
	_add_door(body, Vector3(0.0, -size.y * 0.5 + 1.4, size.z * 0.5 + 0.02), Vector2(2.5, 2.8))
	_add_office_window_bands(body, size, storeys)

	# Rooftop Antenna for towers
	if has_antenna:
		var ant := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 0.05
		cyl.bottom_radius = 0.25
		cyl.height = 4.5
		cyl.material = CityMaterials.get_standard_material(CityMaterials.COLOR_DARK_METAL, 0.4, 0.5)
		ant.mesh = cyl
		ant.position = Vector3(0.0, size.y * 0.5 + 2.25, 0.0)
		body.add_child(ant)

	if not custom_sign.is_empty():
		_add_signboard(body, Vector3(0.0, -size.y * 0.5 + 3.6, size.z * 0.5 + 0.08), custom_sign)

static func _build_warehouse(parent: Node3D, node_name: String, pos: Vector3, size: Vector3, wall_color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = Vector3(pos.x, size.y * 0.5, pos.z)
	parent.add_child(body)

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	col.shape = box
	body.add_child(col)

	var wall_mi := MeshInstance3D.new()
	var wall_b := BoxMesh.new()
	wall_b.size = size
	wall_b.material = CityMaterials.get_standard_material(wall_color, 0.8)
	wall_mi.mesh = wall_b
	body.add_child(wall_mi)

	_add_flat_roof_parapet(body, size, CityMaterials.COLOR_ROOF_CHARCOAL)
	# Large industrial roll-up door
	_add_garage_door(body, Vector3(0.0, -size.y * 0.5 + 2.5, size.z * 0.5 + 0.02), Vector2(6.0, 4.5), false)
	# Side personnel door
	_add_door(body, Vector3(-size.x * 0.5 - 0.02, -size.y * 0.5 + 1.1, 0.0), Vector2(1.2, 2.2), true)

# -----------------------------------------------------------------
# PARKING LOT BUILDER
# -----------------------------------------------------------------

static func _build_parking_lot(parent: Node3D, node_name: String, pos: Vector3, size: Vector2, bays: int) -> void:
	var lot := Node3D.new()
	lot.name = node_name
	lot.position = pos
	parent.add_child(lot)

	# Dark asphalt parking surface
	var surface := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(size.x, 0.015, size.y)
	b.material = CityMaterials.get_standard_material(Color(0.32, 0.34, 0.36), 0.85)
	surface.mesh = b
	surface.add_to_group("hole_cutout_meshes")
	lot.add_child(surface)

	# Painted parking bay stripes
	var white_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_ROAD_MARKING_WHITE, 0.5)
	var bay_w := size.x / float(bays)
	for i in range(bays + 1):
		var x_pos := -size.x * 0.5 + i * bay_w
		var line := MeshInstance3D.new()
		var lb := BoxMesh.new()
		lb.size = Vector3(0.12, 0.005, size.y * 0.7)
		lb.material = white_mat
		line.mesh = lb
		line.position = Vector3(x_pos, 0.01, 0.0)
		line.add_to_group("hole_cutout_meshes")
		lot.add_child(line)

# -----------------------------------------------------------------
# CENTRAL PLAZA & SOUTHERN CENTRAL PARK (Section 8 Block E & H)
# -----------------------------------------------------------------

static func _build_central_plaza(parent: Node3D, pos: Vector3) -> void:
	var plaza := Node3D.new()
	plaza.name = "CentralPlaza_10x10"
	plaza.position = pos
	parent.add_child(plaza)

	# Light-grey paved ground slab
	var slab := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(10.0, 0.02, 10.0)
	b.material = CityMaterials.get_cutout_material(CityMaterials.COLOR_SIDEWALK, 0.85)
	slab.mesh = b
	slab.add_to_group("hole_cutout_meshes")
	plaza.add_child(slab)

	# Central decorative planter
	var planter := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 1.4
	cyl.bottom_radius = 1.5
	cyl.height = 0.5
	cyl.material = CityMaterials.get_standard_material(CityMaterials.COLOR_KERB, 0.6)
	planter.mesh = cyl
	planter.position = Vector3(0.0, 0.25, 0.0)
	planter.add_to_group("hole_cutout_meshes")
	plaza.add_child(planter)

	# Abstract colorful geometric sculpture on top of planter
	var sculp := MeshInstance3D.new()
	var sculp_mesh := TorusMesh.new()
	sculp_mesh.inner_radius = 0.4
	sculp_mesh.outer_radius = 0.9
	sculp_mesh.material = CityMaterials.get_standard_material(Color(0.95, 0.65, 0.15), 0.3, 0.3)
	sculp.mesh = sculp_mesh
	sculp.position = Vector3(0.0, 1.2, 0.0)
	sculp.rotation.x = PI * 0.25
	plaza.add_child(sculp)

static func _build_central_park(parent: Node3D, pos: Vector3, size: Vector2) -> void:
	var park := Node3D.new()
	park.name = "SouthernCentralPark"
	park.position = Vector3(pos.x, 0.025, pos.z)
	parent.add_child(park)

	# Lush Park Grass Base
	var grass := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(size.x, 0.03, size.y)
	b.material = CityMaterials.get_cutout_material(CityMaterials.COLOR_GRASS, 0.9)
	grass.mesh = b
	grass.add_to_group("hole_cutout_meshes")
	park.add_child(grass)

	# Perimeter walking paths (width 2.2m)
	var path_mat := CityMaterials.get_cutout_material(CityMaterials.COLOR_SIDEWALK, 0.85)
	var pw := 2.2
	_add_park_path(park, path_mat, Vector3(0.0, 0.015, -size.y * 0.5 + pw * 0.5), Vector3(size.x, 0.01, pw))
	_add_park_path(park, path_mat, Vector3(0.0, 0.015, size.y * 0.5 - pw * 0.5), Vector3(size.x, 0.01, pw))
	_add_park_path(park, path_mat, Vector3(-size.x * 0.5 + pw * 0.5, 0.015, 0.0), Vector3(pw, 0.01, size.y - pw * 2.0))
	_add_park_path(park, path_mat, Vector3(size.x * 0.5 - pw * 0.5, 0.015, 0.0), Vector3(pw, 0.01, size.y - pw * 2.0))

	# Central gathering plaza circle
	var circle := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = 4.0
	cm.bottom_radius = 4.0
	cm.height = 0.02
	cm.material = path_mat
	circle.mesh = cm
	circle.position = Vector3(0.0, 0.015, 0.0)
	circle.add_to_group("hole_cutout_meshes")
	park.add_child(circle)

	# Decorative Pond (4x3 units) with defined stone edge (Section 8 Block H)
	var pond := Node3D.new()
	pond.name = "Pond"
	pond.position = Vector3(5.0, 0.01, -4.0)
	park.add_child(pond)

	var pond_water := MeshInstance3D.new()
	var wm := BoxMesh.new()
	wm.size = Vector3(4.0, 0.02, 3.0)
	wm.material = CityMaterials.get_standard_material(CityMaterials.COLOR_POND_WATER, 0.15, 0.3)
	pond_water.mesh = wm
	pond_water.position = Vector3(0.0, 0.03, 0.0)
	pond_water.add_to_group("hole_cutout_meshes")
	pond.add_child(pond_water)

	# Pond Stone Rim (4 perimeter curb segments)
	var rim_mat := CityMaterials.get_standard_material(CityMaterials.COLOR_KERB, 0.8)
	var curbs: Array[Dictionary] = [
		{"s": Vector3(4.5, 0.08, 0.25), "p": Vector3(0.0, 0.04, -1.625)},
		{"s": Vector3(4.5, 0.08, 0.25), "p": Vector3(0.0, 0.04, 1.625)},
		{"s": Vector3(0.25, 0.08, 3.0), "p": Vector3(-2.125, 0.04, 0.0)},
		{"s": Vector3(0.25, 0.08, 3.0), "p": Vector3(2.125, 0.04, 0.0)}
	]
	for c in curbs:
		var curbm := MeshInstance3D.new()
		var curb_box := BoxMesh.new()
		curb_box.size = c["s"]
		curb_box.material = rim_mat
		curbm.mesh = curb_box
		curbm.position = c["p"]
		pond.add_child(curbm)

static func _add_park_path(parent: Node3D, mat: Material, pos: Vector3, size: Vector3) -> void:
	var p := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = size
	b.material = mat
	p.mesh = b
	p.position = pos
	p.add_to_group("hole_cutout_meshes")
	parent.add_child(p)

# -----------------------------------------------------------------
# ARCHITECTURAL ACCENTS HELPERS
# -----------------------------------------------------------------

static func _add_flat_roof_parapet(parent: Node3D, size: Vector3, color: Color) -> void:
	var parapet := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(size.x + 0.3, 0.45, size.z + 0.3)
	b.material = CityMaterials.get_standard_material(color, 0.75)
	parapet.mesh = b
	parapet.position = Vector3(0.0, size.y * 0.5 + 0.22, 0.0)
	parent.add_child(parapet)

	# Rooftop AC unit
	var ac := MeshInstance3D.new()
	var ac_b := BoxMesh.new()
	ac_b.size = Vector3(1.5, 0.9, 1.2)
	ac_b.material = CityMaterials.get_standard_material(CityMaterials.COLOR_KERB, 0.5, 0.3)
	ac.mesh = ac_b
	ac.position = Vector3(size.x * 0.2, size.y * 0.5 + 0.65, -size.z * 0.2)
	parent.add_child(ac)

static func _add_door(parent: Node3D, pos: Vector3, size: Vector2, is_side: bool = false) -> void:
	var door_mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	if is_side:
		b.size = Vector3(0.06, size.y, size.x)
	else:
		b.size = Vector3(size.x, size.y, 0.06)
	b.material = CityMaterials.get_standard_material(CityMaterials.COLOR_DOOR_WOOD, 0.6)
	door_mi.mesh = b
	door_mi.position = pos
	parent.add_child(door_mi)

static func _add_garage_door(parent: Node3D, pos: Vector3, size: Vector2, is_side: bool) -> void:
	var g_mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	if is_side:
		b.size = Vector3(0.08, size.y, size.x)
	else:
		b.size = Vector3(size.x, size.y, 0.08)
	b.material = CityMaterials.get_standard_material(Color(0.72, 0.74, 0.76), 0.4, 0.5)
	g_mi.mesh = b
	g_mi.position = pos
	parent.add_child(g_mi)

static func _add_window(parent: Node3D, pos: Vector3, size: Vector2) -> void:
	var w_mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(size.x, size.y, 0.05)
	b.material = CityMaterials.get_standard_material(CityMaterials.COLOR_WINDOW_GLASS, 0.2, 0.2)
	w_mi.mesh = b
	w_mi.position = pos
	parent.add_child(w_mi)

static func _add_awning(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> void:
	var aw_mi := MeshInstance3D.new()
	var prism := PrismMesh.new()
	prism.size = size
	prism.material = CityMaterials.get_standard_material(color, 0.6)
	aw_mi.mesh = prism
	aw_mi.position = pos
	aw_mi.rotation.x = PI * 0.5
	parent.add_child(aw_mi)

static func _add_signboard(parent: Node3D, pos: Vector3, text: String) -> void:
	var sign_node := Node3D.new()
	sign_node.position = pos
	parent.add_child(sign_node)

	# Background sign plate
	var plate_mi := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(text.length() * 0.5 + 1.2, 0.9, 0.12)
	b.material = CityMaterials.get_standard_material(Color(0.12, 0.14, 0.16), 0.5)
	plate_mi.mesh = b
	sign_node.add_child(plate_mi)

	# 3D Text Label
	var label := Label3D.new()
	label.text = text
	label.font_size = 44
	label.pixel_size = 0.016
	label.modulate = Color(1.0, 0.95, 0.4)
	label.outline_render_priority = 1
	label.outline_size = 8
	label.outline_modulate = Color(0.05, 0.05, 0.08)
	label.position = Vector3(0.0, 0.0, 0.07)
	sign_node.add_child(label)

static func _add_windows_grid(parent: Node3D, building_size: Vector3, count: int) -> void:
	var front_z := building_size.z * 0.5 + 0.02
	var w_size := Vector2(1.1, 1.2)
	var cols := int(ceil(float(count) * 0.5))
	var spacing_x := (building_size.x - 2.0) / maxf(1.0, float(cols))

	for i in range(count):
		var floor_lvl := i % 2
		var col_idx := i / 2
		var wx := -building_size.x * 0.5 + 1.2 + col_idx * spacing_x
		var wy := -building_size.y * 0.5 + 1.5 + floor_lvl * 2.2
		_add_window(parent, Vector3(wx, wy, front_z), w_size)

static func _add_apartment_windows(parent: Node3D, building_size: Vector3, floors: int) -> void:
	var front_z := building_size.z * 0.5 + 0.02
	var w_size := Vector2(1.2, 1.3)
	var floor_h := (building_size.y - 3.0) / float(floors)

	for fl in range(1, floors):
		var wy := -building_size.y * 0.5 + 1.5 + fl * floor_h
		_add_window(parent, Vector3(-building_size.x * 0.28, wy, front_z), w_size)
		_add_window(parent, Vector3(building_size.x * 0.28, wy, front_z), w_size)

static func _add_office_window_bands(parent: Node3D, building_size: Vector3, storeys: int) -> void:
	var front_z := building_size.z * 0.5 + 0.02
	var back_z := -building_size.z * 0.5 - 0.02
	var storey_h := building_size.y / float(storeys + 1)

	for s in range(1, storeys + 1):
		var wy := -building_size.y * 0.5 + s * storey_h
		# Continuous ribbon window band
		var band_front := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = Vector3(building_size.x * 0.85, 1.2, 0.05)
		b.material = CityMaterials.get_standard_material(CityMaterials.COLOR_WINDOW_GLASS, 0.15, 0.4)
		band_front.mesh = b
		band_front.position = Vector3(0.0, wy, front_z)
		parent.add_child(band_front)

		var band_back := MeshInstance3D.new()
		band_back.mesh = b
		band_back.position = Vector3(0.0, wy, back_z)
		parent.add_child(band_back)
