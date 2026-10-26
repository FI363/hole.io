class_name CityValidation
extends RefCounted

## Automated verification and integrity checklist for Hole.io-style 3D City
## Validates Sections 3, 4, 5, 8, 10, 11, 16, and 23 checklist items

static func validate_city(main_node: Node) -> Dictionary:
	var report: Dictionary = {
		"valid": true,
		"errors": [],
		"warnings": [],
		"stats": {}
	}

	# 1. Collectibles verification
	var collectibles_container := main_node.get_node_or_null("Collectibles")
	if not collectibles_container:
		report["errors"].append("Missing Collectibles container node")
		report["valid"] = false
		return report

	var count := collectibles_container.get_child_count()
	report["stats"]["collectibles_count"] = count
	if count < 100:
		report["warnings"].append("Expected >= 100 props/vehicles, found %d" % count)

	# 2. Buildings verification
	var buildings_container := main_node.get_node_or_null("Arena/CityBuildings")
	if not buildings_container:
		report["errors"].append("Missing CityBuildings node in Arena")
		report["valid"] = false
	else:
		var b_count := buildings_container.get_child_count()
		report["stats"]["buildings_count"] = b_count
		if b_count < 25:
			report["warnings"].append("Expected >= 25 buildings/structures across 9 blocks, found %d" % b_count)

	# 3. Roads & Ground Plane verification
	var roads_container := main_node.get_node_or_null("Arena/GroundDecorations/RoadNetwork")
	if not roads_container:
		report["errors"].append("Missing RoadNetwork in Arena/GroundDecorations")
		report["valid"] = false

	# 4. Player Hole verification
	var player := main_node.get_node_or_null("PlayerHole") as PlayerHole
	if not player:
		report["errors"].append("Missing PlayerHole")
		report["valid"] = false
	else:
		if player.arena_boundary_x < 90.0 or player.arena_boundary_z < 90.0:
			report["warnings"].append("Player arena boundary limits (%.1f, %.1f) may restrict 200x200 navigation" % [
				player.arena_boundary_x, player.arena_boundary_z
			])

	print("[CityValidation] Validation finished. Valid: %s. Stats: %s" % [report["valid"], report["stats"]])
	return report
