extends SceneTree

## City Map Physics Verification Suite for Godot 4 Hole.io

func _init() -> void:
	print("=====================================================================")
	print("       CITY MAP 3D PHYSICS VERIFICATION TEST SUITE (GODOT 4)         ")
	print("=====================================================================")
	call_deferred("_run_full_suite")

func _run_full_suite() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main_node: Node = main_scene.instantiate()
	root.add_child(main_node)

	var player: PlayerHole = main_node.get_node("PlayerHole")
	var collectibles_container: Node3D = main_node.get_node("Collectibles")

	# Wait for initial scene settle
	for f in range(25):
		await physics_frame

	var count := collectibles_container.get_child_count()
	print("[Suite] City Map initialized with %d 3D objects. Player at %s (radius: %.2f)" % [
		count,
		player.global_position,
		player.hole_radius
	])

	if count < 20:
		printerr("FAIL: Expected rich city map with >= 20 objects, got %d" % count)
		quit(1)
		return

	# -------------------------------------------------------------
	# TEST 1 — Solid Ground Rest: City objects rest stably on streets/blocks
	# -------------------------------------------------------------
	print("\n--- TEST 1: City Objects Stable Ground Support ---")
	var objects := collectibles_container.get_children()
	for obj in objects:
		var rb := obj as RigidBody3D
		if rb:
			if rb.global_position.y < -0.2:
				printerr("FAIL: Test 1 - City object fell through ground during initial settle: %s" % rb.global_position)
				quit(1)
				return

	print(">>> PASS: Test 1 verified - All %d city objects rest stably on the city map." % objects.size())

	# -------------------------------------------------------------
	# TEST 2 — Swallowing Starter City Prop (Plaza Fountain)
	# -------------------------------------------------------------
	print("\n--- TEST 2: Swallowing Plaza Prop (Fountain) ---")
	var starter_prop := objects[0] as Collectible
	var initial_prop_pos := starter_prop.global_position
	print("Driving hole toward plaza fountain at %s..." % initial_prop_pos)

	var initial_score := player.swallowed_count
	var fell_in := false

	for f in range(80):
		player.global_position = player.global_position.move_toward(initial_prop_pos, 0.10)
		player.global_position.y = 0.0
		player._sync_hole_geometry()
		player._wake_nearby_bodies()
		await physics_frame
		if starter_prop == null or not is_instance_valid(starter_prop) or starter_prop.global_position.y < 0.15:
			fell_in = true
			break

	if not fell_in:
		printerr("FAIL: Test 2 - Plaza prop did not fall into hole when hole moved under it")
		quit(1)
		return

	print(">>> PASS: Test 2 verified - Plaza prop naturally tilts and falls into hole.")

	# Wait for swallowing
	for f in range(35):
		await physics_frame

	print("Score after swallowing fountain: %d" % player.swallowed_count)
	if player.swallowed_count != initial_score + 1:
		printerr("FAIL: Test 2 - Swallowed count did not increment")
		quit(1)
		return

	print(">>> PASS: Test 2 collection confirmed.")

	# -------------------------------------------------------------
	# TEST 3 — Swallowing Street Vehicle (Motorcycle)
	# -------------------------------------------------------------
	print("\n--- TEST 3: Swallowing Street Vehicle (Motorcycle) ---")
	var moto := objects[3] as Collectible
	var initial_moto_pos := moto.global_position
	player.global_position = Vector3(initial_moto_pos.x + 1.5, 0.0, initial_moto_pos.z)
	player._sync_hole_geometry()
	player._wake_nearby_bodies()
	print("Driving hole toward parked motorcycle at %s..." % initial_moto_pos)

	var moto_fell := false
	for f in range(60):
		player.global_position = player.global_position.move_toward(initial_moto_pos, 0.10)
		player.global_position.y = 0.0
		player._sync_hole_geometry()
		player._wake_nearby_bodies()
		await physics_frame
		if moto == null or not is_instance_valid(moto) or moto.global_position.y < 0.25:
			moto_fell = true
			break

	if not moto_fell:
		printerr("FAIL: Test 3 - Motorcycle did not fall into hole")
		quit(1)
		return

	print(">>> PASS: Test 3 verified - Street motorcycle cleanly swallowed into hole.")

	# -------------------------------------------------------------
	# TEST 4 — Medium Truck Bridging & Growth Release
	# -------------------------------------------------------------
	print("\n--- TEST 4: Medium Truck Bridging & Growth Release ---")
	# Truck is at (5.5, 0.65, 0.0) with length 3.08 > starting hole diameter 2.50
	var truck := objects[7] as Collectible
	var truck_pos := truck.global_position
	player.global_position = Vector3(truck_pos.x, 0.0, truck_pos.z)
	player.hole_radius = 1.25
	player.target_radius = 1.25
	player._sync_hole_geometry()
	player._wake_nearby_bodies()

	for f in range(35):
		await physics_frame

	print("Truck pos directly over hole: %s (hole radius: %.2f)" % [
		truck.global_position, player.hole_radius
	])

	# Must bridge the hole at y >= 0.4
	if truck.global_position.y < 0.4:
		printerr("FAIL: Test 4 - Truck fell in before hole was large enough: %s" % truck.global_position)
		quit(1)
		return

	print(">>> PASS: Truck physically bridged the hole opening without falling in.")

	# Expand hole so diameter becomes 3.60 > 3.08 (truck length)
	print("Growing hole radius to 1.80 (diameter 3.60)...")
	player.hole_radius = 1.80
	player.target_radius = 1.80
	player._sync_hole_geometry()
	truck.sleeping = false

	var truck_fell := false
	for f in range(50):
		await physics_frame
		if truck == null or not is_instance_valid(truck) or truck.global_position.y < 0.2:
			truck_fell = true
			break

	if not truck_fell:
		printerr("FAIL: Test 4 - Truck did not fall in after hole expanded")
		quit(1)
		return

	print(">>> PASS: Test 4 verified - Street truck swallowed after hole growth.")

	print("\n=====================================================================")
	print("       ALL CITY MAP PHYSICS TESTS PASSED WITH 100% SUCCESS!          ")
	print("=====================================================================")
	quit(0)
