class_name RefMapConstants
extends RefCounted

## Reference Map Constants, Palettes, and Coordinate Transformations
## Accurately reflects the stylized low-poly reference image

# Coordinate Mapping: Normalized [0.0, 1.0] -> Godot World Space [-100.0, 100.0]
const MAP_SIZE: float = 200.0
const HALF_MAP: float = 100.0

static func uv_to_world(u: float, v: float, y: float = 0.0) -> Vector3:
	return Vector3((u - 0.5) * MAP_SIZE, y, (v - 0.5) * MAP_SIZE)

static func world_to_uv(x: float, z: float) -> Vector2:
	return Vector2(x / MAP_SIZE + 0.5, z / MAP_SIZE + 0.5)

# Reference Image Visual Palette
const COLOR_ASPHALT := Color(0.24, 0.25, 0.27)
const COLOR_RUNWAY_ASPHALT := Color(0.19, 0.20, 0.22)
const COLOR_SIDEWALK := Color(0.78, 0.77, 0.74)
const COLOR_KERB := Color(0.60, 0.60, 0.62)
const COLOR_ROAD_MARKING_WHITE := Color(0.96, 0.96, 0.96)
const COLOR_ROAD_MARKING_YELLOW := Color(0.98, 0.78, 0.15)

const COLOR_GRASS := Color(0.38, 0.65, 0.32)
const COLOR_FOREST_GRASS := Color(0.28, 0.52, 0.24)
const COLOR_MOUNTAIN_ROCK := Color(0.48, 0.48, 0.50)
const COLOR_SAND := Color(0.92, 0.82, 0.60)
const COLOR_WATER_SHALLOW := Color(0.18, 0.62, 0.76)
const COLOR_WATER_DEEP := Color(0.10, 0.38, 0.58)

const COLOR_RUNNING_TRACK := Color(0.82, 0.32, 0.25)
const COLOR_SOCCER_PITCH := Color(0.28, 0.68, 0.28)

const COLOR_BRIDGE_RED := Color(0.78, 0.22, 0.18)
const COLOR_PIER_WOOD := Color(0.58, 0.45, 0.32)
const COLOR_ROOF_TERRACOTTA := Color(0.78, 0.38, 0.25)
const COLOR_ROOF_BLUE := Color(0.25, 0.42, 0.62)
const COLOR_ROOF_CHARCOAL := Color(0.28, 0.28, 0.30)
const COLOR_ROOF_BROWN := Color(0.45, 0.32, 0.22)

const COLOR_BUILDING_WHITE := Color(0.92, 0.92, 0.90)
const COLOR_BUILDING_OFFWHITE := Color(0.85, 0.85, 0.82)
const COLOR_BUILDING_CREAM := Color(0.92, 0.86, 0.74)
const COLOR_BUILDING_PALE_BLUE := Color(0.65, 0.78, 0.88)
const COLOR_BUILDING_GREY := Color(0.65, 0.66, 0.68)
const COLOR_GLASS_BLUE := Color(0.35, 0.65, 0.85)

const COLOR_CONTAINER_RED := Color(0.82, 0.20, 0.18)
const COLOR_CONTAINER_BLUE := Color(0.20, 0.45, 0.82)
const COLOR_CONTAINER_GREEN := Color(0.25, 0.65, 0.32)
const COLOR_CONTAINER_YELLOW := Color(0.92, 0.75, 0.18)
const COLOR_CONTAINER_GREY := Color(0.45, 0.46, 0.48)

const VEHICLE_PALETTE: Array[Color] = [
	Color(0.88, 0.22, 0.20), # Red
	Color(0.20, 0.52, 0.88), # Blue
	Color(0.96, 0.82, 0.18), # Yellow / Taxi
	Color(0.94, 0.94, 0.94), # White
	Color(0.28, 0.30, 0.32), # Dark grey
	Color(0.26, 0.72, 0.38), # Green
	Color(0.94, 0.52, 0.15), # Orange
	Color(0.45, 0.75, 0.92)  # Light blue
]

# Material Cache & Cutout Shader
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
