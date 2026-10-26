class_name CityMaterials
extends RefCounted

## Central Material Palette for Hole.io-Style 3D City
## Follows Section 14 specifications precisely

# Base Color Palette (sRGB Colors from Section 14.1)
const COLOR_ASPHALT := Color(67.0 / 255.0, 70.0 / 255.0, 75.0 / 255.0)
const COLOR_SIDEWALK := Color(190.0 / 255.0, 188.0 / 255.0, 180.0 / 255.0)
const COLOR_BUILDING_CREAM := Color(231.0 / 255.0, 218.0 / 255.0, 192.0 / 255.0)
const COLOR_BUILDING_OFFWHITE := Color(225.0 / 255.0, 226.0 / 255.0, 218.0 / 255.0)
const COLOR_BUILDING_PALE_BLUE := Color(143.0 / 255.0, 188.0 / 255.0, 210.0 / 255.0)
const COLOR_BUILDING_PALE_YELLOW := Color(232.0 / 255.0, 205.0 / 255.0, 126.0 / 255.0)
const COLOR_BUILDING_MUTED_GREEN := Color(151.0 / 255.0, 184.0 / 255.0, 139.0 / 255.0)
const COLOR_BUILDING_MUTED_PEACH := Color(222.0 / 255.0, 160.0 / 255.0, 135.0 / 255.0)
const COLOR_ROOF_CHARCOAL := Color(66.0 / 255.0, 69.0 / 255.0, 74.0 / 255.0)
const COLOR_ROOF_TERRACOTTA := Color(166.0 / 255.0, 91.0 / 255.0, 68.0 / 255.0)
const COLOR_GRASS := Color(112.0 / 255.0, 158.0 / 255.0, 91.0 / 255.0)
const COLOR_TREE_FOLIAGE := Color(77.0 / 255.0, 142.0 / 255.0, 76.0 / 255.0)
const COLOR_TREE_TRUNK := Color(112.0 / 255.0, 79.0 / 255.0, 54.0 / 255.0)
const COLOR_WINDOW_GLASS := Color(91.0 / 255.0, 150.0 / 255.0, 180.0 / 255.0)
const COLOR_WINDOW_FRAME := Color(235.0 / 255.0, 231.0 / 255.0, 218.0 / 255.0)

# Secondary & Accent Colors
const COLOR_ROAD_MARKING_WHITE := Color(0.96, 0.96, 0.96)
const COLOR_ROAD_MARKING_YELLOW := Color(0.98, 0.78, 0.15)
const COLOR_KERB := Color(0.60, 0.60, 0.60)
const COLOR_POND_WATER := Color(45.0 / 255.0, 95.0 / 255.0, 105.0 / 255.0)
const COLOR_DARK_METAL := Color(0.25, 0.26, 0.28)
const COLOR_DOOR_WOOD := Color(0.48, 0.32, 0.20)
const COLOR_AWNING_RED := Color(0.85, 0.25, 0.22)
const COLOR_AWNING_ORANGE := Color(0.92, 0.52, 0.18)
const COLOR_AWNING_GREEN := Color(0.28, 0.65, 0.35)

# Vehicle Color Palette (Section 10.1)
const VEHICLE_COLORS: Array[Color] = [
	Color(0.88, 0.22, 0.20), # Red
	Color(0.20, 0.52, 0.88), # Blue
	Color(0.96, 0.82, 0.18), # Yellow
	Color(0.94, 0.94, 0.94), # White
	Color(0.28, 0.30, 0.32), # Dark grey
	Color(0.26, 0.72, 0.38), # Green
	Color(0.94, 0.52, 0.15), # Orange
	Color(0.45, 0.75, 0.92), # Light blue
]

static var _ground_shader: Shader = preload("res://shaders/ground_hole.gdshader")
static var _material_cache: Dictionary = {}

static func get_cutout_material(color: Color, roughness: float = 0.85) -> ShaderMaterial:
	var key := "cutout_%s_%.2f" % [color.to_html(false), roughness]
	if _material_cache.has(key):
		return _material_cache[key]

	var mat := ShaderMaterial.new()
	mat.shader = _ground_shader
	mat.set_shader_parameter("ground_color", color)
	mat.set_shader_parameter("roughness", roughness)
	mat.set_shader_parameter("hole_pos", Vector3.ZERO)
	mat.set_shader_parameter("hole_radius", 1.25)
	_material_cache[key] = mat
	return mat

static func get_standard_material(color: Color, roughness: float = 0.6, metallic: float = 0.0) -> StandardMaterial3D:
	var key := "std_%s_%.2f_%.2f" % [color.to_html(false), roughness, metallic]
	if _material_cache.has(key):
		return _material_cache[key]

	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = roughness
	mat.metallic = metallic
	_material_cache[key] = mat
	return mat
