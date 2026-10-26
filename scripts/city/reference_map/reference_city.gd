class_name ReferenceCity
extends RefCounted

## Master Coordinator for the Authentic Low-Poly Reference City Map
## Assembles terrain, roads, buildings, and props matching the reference image layout

const Constants = preload("res://scripts/city/reference_map/map_constants.gd")
const TerrainBuilder = preload("res://scripts/city/reference_map/terrain_builder.gd")
const RoadBuilder = preload("res://scripts/city/reference_map/road_builder.gd")
const BuildingBuilder = preload("res://scripts/city/reference_map/building_builder.gd")
const PropBuilder = preload("res://scripts/city/reference_map/prop_builder.gd")

static func build_reference_city(arena_node: Node3D, collectibles_container: Node3D, player_hole: PlayerHole) -> void:
	# 1. Clean existing children
	for child in collectibles_container.get_children():
		child.queue_free()

	var existing_terrain := arena_node.get_node_or_null("ReferenceTerrain")
	if existing_terrain:
		existing_terrain.queue_free()

	var existing_roads := arena_node.get_node_or_null("ReferenceRoads")
	if existing_roads:
		existing_roads.queue_free()

	var existing_buildings := arena_node.get_node_or_null("ReferenceBuildings")
	if existing_buildings:
		existing_buildings.queue_free()

	# 2. Build Terrain, Ocean, Mountain, Stadium, Lake, Marina, and Beach
	TerrainBuilder.build_terrain(arena_node, player_hole)

	# 3. Build Road Network, Roundabouts, Runway, Bridges, and Sidewalks
	RoadBuilder.build_roads(arena_node, player_hole)

	# 4. Build Skyscrapers, Suburban Houses, Seaport, Airport, and Landmarks
	BuildingBuilder.build_all_buildings(arena_node)

	# 5. Populate Airplanes, Yachts, Containers, Trees, Vehicles, and Anchor Props
	PropBuilder.populate_all_props(collectibles_container, player_hole)

	print("[ReferenceCity] Recreated full low-poly reference city map with %d collectibles!" % collectibles_container.get_child_count())
