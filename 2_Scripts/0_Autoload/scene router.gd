extends Node


var transitionScenePath : String = "res://1_Scenes/0_Screens/scene transition.tscn"
var loadingScenePath : String = "res://1_Scenes/0_Screens/loading screen.tscn"

# Optional single-slot save.
var savedScene : Node = null

var isTransitionPlaying : bool = false

var targetScenePath : String = ""
var targetPackedScene : PackedScene = null

enum TargetType {
	NONE,
	PATH,
	PACKED,
	RESTORE_SAVED
}

var targetType : TargetType = TargetType.NONE


func changeToFile(scenePath : String) -> void:
	if isTransitionPlaying:
		return

	targetScenePath = scenePath
	targetPackedScene = null
	targetType = TargetType.PATH

	_playCloseThenSwap()


func changeToPacked(scenePacked : PackedScene) -> void:
	if isTransitionPlaying:
		return

	if scenePacked == null:
		return

	targetPackedScene = scenePacked
	targetScenePath = ""
	targetType = TargetType.PACKED

	_playCloseThenSwap()


func saveCurrentThenChangeToFile(scenePath : String) -> void:
	if isTransitionPlaying:
		return

	_saveCurrentScene()
	changeToFile(scenePath)


func restoreSavedScene() -> void:
	if isTransitionPlaying:
		return

	if savedScene == null:
		return

	targetScenePath = ""
	targetPackedScene = null
	targetType = TargetType.RESTORE_SAVED

	_playCloseThenSwap()


# -------------------------------------------------------------------
# Transition + Swap
# -------------------------------------------------------------------

func _playCloseThenSwap() -> void:
	isTransitionPlaying = true

	var closeTransition : Node = _spawnTransition(0)

	if closeTransition != null:
		await closeTransition.isFinished

	await _swapScenes()

	_cleanupTransition(closeTransition)

	var openTransition : Node = _spawnTransition(1)

	if openTransition != null:
		await openTransition.isFinished
		_cleanupTransition(openTransition)

	targetType = TargetType.NONE
	targetScenePath = ""
	targetPackedScene = null

	isTransitionPlaying = false


func _swapScenes() -> void:
	if loadingScenePath != "":
		var loadingError : Error = get_tree().change_scene_to_file(
			loadingScenePath
		)

		if loadingError != OK:
			push_error(
				"Could not open loading scene: %s"
				% error_string(loadingError)
			)

	# Allows the loading screen to become the current scene and render.
	await get_tree().process_frame

	match targetType:
		TargetType.PATH:
			await _loadAndChangeToFile(targetScenePath)

		TargetType.PACKED:
			var changeError : Error = get_tree().change_scene_to_packed(
				targetPackedScene
			)

			if changeError != OK:
				push_error(
					"Could not change to PackedScene: %s"
					% error_string(changeError)
				)

			await get_tree().process_frame

		TargetType.RESTORE_SAVED:
			_restoreSavedSceneInternal()
			await get_tree().process_frame

		_:
			pass


func _loadAndChangeToFile(scenePath : String) -> void:
	if scenePath.is_empty():
		push_error("Cannot load an empty scene path.")
		return

	var requestError : Error = ResourceLoader.load_threaded_request(
		scenePath
	)

	if requestError != OK:
		push_error(
			"Could not start loading scene '%s': %s"
			% [scenePath, error_string(requestError)]
		)
		return

	while true:
		var status : ResourceLoader.ThreadLoadStatus = (
			ResourceLoader.load_threaded_get_status(scenePath)
		)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break

			ResourceLoader.THREAD_LOAD_FAILED:
				push_error(
					"Threaded loading failed for scene: %s"
					% scenePath
				)
				return

			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error(
					"Invalid threaded resource: %s"
					% scenePath
				)
				return

			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame

	var loadedResource : Resource = ResourceLoader.load_threaded_get(
		scenePath
	)

	var loadedScene : PackedScene = loadedResource as PackedScene

	if loadedScene == null:
		push_error(
			"Loaded resource is not a PackedScene: %s"
			% scenePath
		)
		return

	var changeError : Error = get_tree().change_scene_to_packed(
		loadedScene
	)

	if changeError != OK:
		push_error(
			"Could not change to scene '%s': %s"
			% [scenePath, error_string(changeError)]
		)
		return

	await get_tree().process_frame


# -------------------------------------------------------------------
# Save / Restore
# -------------------------------------------------------------------

func _saveCurrentScene() -> void:
	var tree : SceneTree = get_tree()
	var currentScene : Node = tree.current_scene

	if currentScene == null:
		return

	# Discard the previous saved scene before replacing it.
	if savedScene != null:
		if savedScene.is_inside_tree():
			savedScene.get_parent().remove_child(savedScene)

		savedScene.queue_free()
		savedScene = null

	# Prevent change_scene_to_file() from freeing the saved scene.
	tree.current_scene = null

	currentScene.get_parent().remove_child(currentScene)
	savedScene = currentScene


func _restoreSavedSceneInternal() -> void:
	if savedScene == null:
		return

	var tree : SceneTree = get_tree()
	var oldScene : Node = tree.current_scene

	if oldScene != null:
		tree.current_scene = null

		if oldScene.get_parent() != null:
			oldScene.get_parent().remove_child(oldScene)

		oldScene.queue_free()

	tree.root.add_child(savedScene)
	tree.current_scene = savedScene


# -------------------------------------------------------------------
# Transition helpers
# -------------------------------------------------------------------

func _spawnTransition(state : int) -> Node:
	if transitionScenePath.is_empty():
		return null

	var packed : PackedScene = load(transitionScenePath) as PackedScene

	if packed == null:
		push_error(
			"Could not load transition scene: %s"
			% transitionScenePath
		)
		return null

	var transition : Node = packed.instantiate()
	get_tree().root.add_child(transition)

	if state == 0:
		transition._enter()
	elif state == 1:
		transition._exit()

	return transition


func _cleanupTransition(transition : Node) -> void:
	if is_instance_valid(transition):
		transition.queue_free()
