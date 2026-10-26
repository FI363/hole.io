extends SceneTree

## Captures high-resolution in-game screenshots of the 3D stylized city

const ARTIFACTS_DIR: String = "C:/Users/hydro/.gemini/antigravity-ide/brain/409d58a5-8c8e-442d-8b5d-a45fcbb66e38"

func _init() -> void:
	call_deferred("_run_captures")

func _run_captures() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main_node: Node = main_scene.instantiate()
	root.add_child(main_node)

	# Settle physics and graphics frames
	for f in range(30):
		await process_frame

	var camera: Camera3D = main_node.get_node("Camera3D")
	camera.script = null # Detach tracking script for static inspection shots

	var shots: Array[Dictionary] = [
		{
			"name": "reference_city_overview.png",
			"pos": Vector3(0.0, 155.0, 135.0),
			"look": Vector3(0.0, 0.0, -8.0),
			"fov": 65.0
		},
		{
			"name": "reference_city_airport_stadium.png",
			"pos": Vector3(-55.0, 55.0, 85.0),
			"look": Vector3(-55.0, 0.0, 38.0),
			"fov": 55.0
		},
		{
			"name": "reference_city_harbor_beach.png",
			"pos": Vector3(50.0, 60.0, 95.0),
			"look": Vector3(35.0, 0.0, 35.0),
			"fov": 55.0
		},
		{
			"name": "reference_city_mountain_park.png",
			"pos": Vector3(-25.0, 55.0, 15.0),
			"look": Vector3(-45.0, 5.0, -45.0),
			"fov": 55.0
		},
		{
			"name": "reference_city_downtown_promenade.png",
			"pos": Vector3(8.0, 35.0, 48.0),
			"look": Vector3(8.0, 5.0, -10.0),
			"fov": 50.0
		}
	]

	for shot in shots:
		camera.global_position = shot["pos"]
		camera.fov = shot["fov"]
		camera.look_at(shot["look"], Vector3.UP)

		for f in range(6):
			await process_frame

		var img := root.get_viewport().get_texture().get_image()
		var out_path: String = ARTIFACTS_DIR + "/" + shot["name"]
		var err := img.save_png(out_path)
		print("Saved screenshot: %s (result: %d)" % [out_path, err])

	print("ALL CITY PREVIEWS CAPTURED SUCCESSFULLY!")
	quit(0)
