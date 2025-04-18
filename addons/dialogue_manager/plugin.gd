@tool
extends EditorPlugin


<<<<<<< HEAD
const MainView = preload("./views/main_view.tscn")


var import_plugin: DMImportPlugin
var inspector_plugin: DMInspectorPlugin
var translation_parser_plugin: DMTranslationParserPlugin
var main_view
var dialogue_cache: DMCache
=======
const DialogueConstants = preload("./constants.gd")
const DialogueImportPlugin = preload("./import_plugin.gd")
const DialogueInspectorPlugin = preload("./inspector_plugin.gd")
const DialogueTranslationParserPlugin = preload("./editor_translation_parser_plugin.gd")
const DialogueSettings = preload("./settings.gd")
const DialogueCache = preload("./components/dialogue_cache.gd")
const MainView = preload("./views/main_view.tscn")
const DialogueResource = preload("./dialogue_resource.gd")


var import_plugin: DialogueImportPlugin
var inspector_plugin: DialogueInspectorPlugin
var translation_parser_plugin: DialogueTranslationParserPlugin
var main_view
var dialogue_cache: DialogueCache
>>>>>>> dev_branch


func _enter_tree() -> void:
	add_autoload_singleton("DialogueManager", get_plugin_path() + "/dialogue_manager.gd")

	if Engine.is_editor_hint():
		Engine.set_meta("DialogueManagerPlugin", self)

<<<<<<< HEAD
		DMSettings.prepare()

		dialogue_cache = DMCache.new()
		Engine.set_meta("DMCache", dialogue_cache)

		import_plugin = DMImportPlugin.new()
		add_import_plugin(import_plugin)

		inspector_plugin = DMInspectorPlugin.new()
		add_inspector_plugin(inspector_plugin)

		translation_parser_plugin = DMTranslationParserPlugin.new()
		add_translation_parser_plugin(translation_parser_plugin)

		main_view = MainView.instantiate()
		EditorInterface.get_editor_main_screen().add_child(main_view)
=======
		DialogueSettings.prepare()

		dialogue_cache = DialogueCache.new()
		Engine.set_meta("DialogueCache", dialogue_cache)

		import_plugin = DialogueImportPlugin.new()
		add_import_plugin(import_plugin)

		inspector_plugin = DialogueInspectorPlugin.new()
		add_inspector_plugin(inspector_plugin)

		translation_parser_plugin = DialogueTranslationParserPlugin.new()
		add_translation_parser_plugin(translation_parser_plugin)

		main_view = MainView.instantiate()
		get_editor_interface().get_editor_main_screen().add_child(main_view)
>>>>>>> dev_branch
		_make_visible(false)
		main_view.add_child(dialogue_cache)

		_update_localization()

<<<<<<< HEAD
		EditorInterface.get_file_system_dock().files_moved.connect(_on_files_moved)
		EditorInterface.get_file_system_dock().file_removed.connect(_on_file_removed)

		add_tool_menu_item("Create copy of dialogue example balloon...", _copy_dialogue_balloon)

		# Automatically make any changes to the known custom balloon if there is one.
		var balloon_path: String = DMSettings.get_setting(DMSettings.BALLOON_PATH, "")
=======
		get_editor_interface().get_file_system_dock().files_moved.connect(_on_files_moved)
		get_editor_interface().get_file_system_dock().file_removed.connect(_on_file_removed)

		add_tool_menu_item("Create copy of dialogue example balloon...", _copy_dialogue_balloon)

		# Make sure the current balloon has a UID unique from the example balloon's
		var balloon_path: String = DialogueSettings.get_setting("balloon_path", "")
>>>>>>> dev_branch
		if balloon_path != "" and FileAccess.file_exists(balloon_path):
			var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
			var example_balloon_file_name: String = "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn"
			var example_balloon_path: String = get_plugin_path() + "/example_balloon/" + example_balloon_file_name
<<<<<<< HEAD

			var contents: String = FileAccess.get_file_as_string(balloon_path)
			var has_changed: bool = false

			# Make sure the current balloon has a UID unique from the example balloon's
=======
>>>>>>> dev_branch
			var example_balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path))
			var balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(balloon_path))
			if example_balloon_uid == balloon_uid:
				var new_balloon_uid: String = ResourceUID.id_to_text(ResourceUID.create_id())
<<<<<<< HEAD
				contents = contents.replace(example_balloon_uid, new_balloon_uid)
				has_changed = true

			# Make sure the example balloon copy has the correct renaming of the responses menu
			if "reponses" in contents:
				contents = contents.replace("reponses", "responses")
				has_changed = true

			# Save any changes
			if has_changed:
=======
				var contents: String = FileAccess.get_file_as_string(balloon_path)
				contents = contents.replace(example_balloon_uid, new_balloon_uid)
>>>>>>> dev_branch
				var balloon_file: FileAccess = FileAccess.open(balloon_path, FileAccess.WRITE)
				balloon_file.store_string(contents)
				balloon_file.close()

<<<<<<< HEAD
=======
		# Prevent the project from showing as unsaved even though it was only just opened
		if DialogueSettings.get_setting("try_suppressing_startup_unsaved_indicator", false) \
			and Engine.get_physics_frames() == 0 \
			and get_editor_interface().has_method("save_all_scenes"):
			var timer: Timer = Timer.new()
			var suppress_unsaved_marker: Callable
			suppress_unsaved_marker = func():
				if Engine.get_frames_per_second() >= 10:
					timer.stop()
					get_editor_interface().call("save_all_scenes")
					timer.queue_free()
			timer.timeout.connect(suppress_unsaved_marker)
			add_child(timer)
			timer.start(0.1)

>>>>>>> dev_branch

func _exit_tree() -> void:
	remove_autoload_singleton("DialogueManager")

	remove_import_plugin(import_plugin)
	import_plugin = null

	remove_inspector_plugin(inspector_plugin)
	inspector_plugin = null

	remove_translation_parser_plugin(translation_parser_plugin)
	translation_parser_plugin = null

	if is_instance_valid(main_view):
		main_view.queue_free()

	Engine.remove_meta("DialogueManagerPlugin")
<<<<<<< HEAD
	Engine.remove_meta("DMCache")

	EditorInterface.get_file_system_dock().files_moved.disconnect(_on_files_moved)
	EditorInterface.get_file_system_dock().file_removed.disconnect(_on_file_removed)
=======
	Engine.remove_meta("DialogueCache")

	get_editor_interface().get_file_system_dock().files_moved.disconnect(_on_files_moved)
	get_editor_interface().get_file_system_dock().file_removed.disconnect(_on_file_removed)
>>>>>>> dev_branch

	remove_tool_menu_item("Create copy of dialogue example balloon...")


func _has_main_screen() -> bool:
	return true


func _make_visible(next_visible: bool) -> void:
	if is_instance_valid(main_view):
		main_view.visible = next_visible


func _get_plugin_name() -> String:
	return "Dialogue"


func _get_plugin_icon() -> Texture2D:
	return load(get_plugin_path() + "/assets/icon.svg")


func _handles(object) -> bool:
<<<<<<< HEAD
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	var external_editor: String = editor_settings.get_setting("text_editor/external/exec_path")
	var use_external_editor: bool = editor_settings.get_setting("text_editor/external/use_external_editor") and external_editor != ""
	if object is DialogueResource and use_external_editor and DMSettings.get_user_value("open_in_external_editor", false):
=======
	var editor_settings: EditorSettings = get_editor_interface().get_editor_settings()
	var external_editor: String = editor_settings.get_setting("text_editor/external/exec_path")
	var use_external_editor: bool = editor_settings.get_setting("text_editor/external/use_external_editor") and external_editor != ""
	if object is DialogueResource and use_external_editor and DialogueSettings.get_user_value("open_in_external_editor", false):
>>>>>>> dev_branch
		var project_path: String = ProjectSettings.globalize_path("res://")
		var file_path: String = ProjectSettings.globalize_path(object.resource_path)
		OS.create_process(external_editor, [project_path, file_path])
		return false

	return object is DialogueResource


func _edit(object) -> void:
	if is_instance_valid(main_view) and is_instance_valid(object):
		main_view.open_resource(object)


func _apply_changes() -> void:
	if is_instance_valid(main_view):
		main_view.apply_changes()
		_update_localization()


func _build() -> bool:
	# If this is the dotnet Godot then we need to check if the solution file exists
<<<<<<< HEAD
	DMSettings.check_for_dotnet_solution()

	# Ignore errors in other files if we are just running the test scene
	if DMSettings.get_user_value("is_running_test_scene", true): return true
=======
	DialogueSettings.check_for_dotnet_solution()

	# Ignore errors in other files if we are just running the test scene
	if DialogueSettings.get_user_value("is_running_test_scene", true): return true
>>>>>>> dev_branch

	if dialogue_cache != null:
		dialogue_cache.reimport_files()

		var files_with_errors = dialogue_cache.get_files_with_errors()
		if files_with_errors.size() > 0:
			for dialogue_file in files_with_errors:
				push_error("You have %d error(s) in %s" % [dialogue_file.errors.size(), dialogue_file.path])
<<<<<<< HEAD
			EditorInterface.edit_resource(load(files_with_errors[0].path))
=======
			get_editor_interface().edit_resource(load(files_with_errors[0].path))
>>>>>>> dev_branch
			main_view.show_build_error_dialog()
			return false

	return true


## Get the shortcuts used by the plugin
func get_editor_shortcuts() -> Dictionary:
	var shortcuts: Dictionary = {
		toggle_comment = [
			_create_event("Ctrl+K"),
			_create_event("Ctrl+Slash")
		],
		delete_line = [
			_create_event("Ctrl+Shift+K")
		],
		move_up = [
			_create_event("Alt+Up")
		],
		move_down = [
			_create_event("Alt+Down")
		],
		save = [
			_create_event("Ctrl+Alt+S")
		],
		close_file = [
			_create_event("Ctrl+W")
		],
		find_in_files = [
			_create_event("Ctrl+Shift+F")
		],

		run_test_scene = [
			_create_event("Ctrl+F5")
		],
		text_size_increase = [
			_create_event("Ctrl+Equal")
		],
		text_size_decrease = [
			_create_event("Ctrl+Minus")
		],
		text_size_reset = [
			_create_event("Ctrl+0")
		]
	}

<<<<<<< HEAD
	var paths = EditorInterface.get_editor_paths()
=======
	var paths = get_editor_interface().get_editor_paths()
>>>>>>> dev_branch
	var settings
	if FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.3.tres"):
		settings = load(paths.get_config_dir() + "/editor_settings-4.3.tres")
	elif FileAccess.file_exists(paths.get_config_dir() + "/editor_settings-4.tres"):
		settings = load(paths.get_config_dir() + "/editor_settings-4.tres")
	else:
		return shortcuts

	for s in settings.get("shortcuts"):
		for key in shortcuts:
			if s.name == "script_text_editor/%s" % key or s.name == "script_editor/%s" % key:
				shortcuts[key] = []
				for event in s.shortcuts:
					if event is InputEventKey:
						shortcuts[key].append(event)

	return shortcuts


func _create_event(string: String) -> InputEventKey:
	var event: InputEventKey = InputEventKey.new()
	var bits = string.split("+")
	event.keycode = OS.find_keycode_from_string(bits[bits.size() - 1])
	event.shift_pressed = bits.has("Shift")
	event.alt_pressed = bits.has("Alt")
	if bits.has("Ctrl") or bits.has("Command"):
		event.command_or_control_autoremap = true
	return event


## Get the editor shortcut that matches an event
func get_editor_shortcut(event: InputEventKey) -> String:
	var shortcuts: Dictionary = get_editor_shortcuts()
	for key in shortcuts:
		for shortcut in shortcuts.get(key, []):
			if event.as_text().split(" ")[0] == shortcut.as_text().split(" ")[0]:
				return key
	return ""


## Get the current version
func get_version() -> String:
	var config: ConfigFile = ConfigFile.new()
	config.load(get_plugin_path() + "/plugin.cfg")
	return config.get_value("plugin", "version")


## Get the current path of the plugin
func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()


## Update references to a moved file
func update_import_paths(from_path: String, to_path: String) -> void:
	dialogue_cache.move_file_path(from_path, to_path)

	# Reopen the file if it's already open
	if main_view.current_file_path == from_path:
		if to_path == "":
			main_view.close_file(from_path)
		else:
			main_view.current_file_path = ""
			main_view.open_file(to_path)

	# Update any other files that import the moved file
	var dependents = dialogue_cache.get_files_with_dependency(from_path)
	for dependent in dependents:
		dependent.dependencies.remove_at(dependent.dependencies.find(from_path))
		dependent.dependencies.append(to_path)

		# Update the live buffer
		if main_view.current_file_path == dependent.path:
			main_view.code_edit.text = main_view.code_edit.text.replace(from_path, to_path)
<<<<<<< HEAD
			main_view.open_buffers[main_view.current_file_path].pristine_text = main_view.code_edit.text
=======
			main_view.pristine_text = main_view.code_edit.text
>>>>>>> dev_branch

		# Open the file and update the path
		var file: FileAccess = FileAccess.open(dependent.path, FileAccess.READ)
		var text = file.get_as_text().replace(from_path, to_path)
		file.close()

		file = FileAccess.open(dependent.path, FileAccess.WRITE)
		file.store_string(text)
		file.close()


func _update_localization() -> void:
	var dialogue_files = dialogue_cache.get_files()

	# Add any new files to POT generation
	var files_for_pot: PackedStringArray = ProjectSettings.get_setting("internationalization/locale/translations_pot_files", [])
	var files_for_pot_changed: bool = false
	for path in dialogue_files:
		if not files_for_pot.has(path):
			files_for_pot.append(path)
			files_for_pot_changed = true

	# Remove any POT references that don't exist any more
	for i in range(files_for_pot.size() - 1, -1, -1):
		var file_for_pot: String = files_for_pot[i]
		if file_for_pot.get_extension() == "dialogue" and not dialogue_files.has(file_for_pot):
			files_for_pot.remove_at(i)
			files_for_pot_changed = true

	# Update project settings if POT changed
	if files_for_pot_changed:
		ProjectSettings.set_setting("internationalization/locale/translations_pot_files", files_for_pot)
		ProjectSettings.save()


### Callbacks


func _copy_dialogue_balloon() -> void:
<<<<<<< HEAD
	var scale: float = EditorInterface.get_editor_scale()
=======
	var scale: float = get_editor_interface().get_editor_scale()
>>>>>>> dev_branch
	var directory_dialog: FileDialog = FileDialog.new()
	var label: Label = Label.new()
	label.text = "Dialogue balloon files will be copied into chosen directory."
	directory_dialog.get_vbox().add_child(label)
	directory_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	directory_dialog.min_size = Vector2(600, 500) * scale
	directory_dialog.dir_selected.connect(func(path):
		var plugin_path: String = get_plugin_path()

<<<<<<< HEAD
		var is_dotnet: bool = DMSettings.check_for_dotnet_solution()
=======
		var is_dotnet: bool = DialogueSettings.check_for_dotnet_solution()
>>>>>>> dev_branch
		var balloon_path: String = path + ("/Balloon.tscn" if is_dotnet else "/balloon.tscn")
		var balloon_script_path: String = path + ("/DialogueBalloon.cs" if is_dotnet else "/balloon.gd")

		# Copy the balloon scene file and change the script reference
		var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
		var example_balloon_file_name: String = "small_example_balloon.tscn" if is_small_window else "example_balloon.tscn"
		var example_balloon_path: String = plugin_path + "/example_balloon/" + example_balloon_file_name
		var example_balloon_script_file_name: String = "ExampleBalloon.cs" if is_dotnet else "example_balloon.gd"
<<<<<<< HEAD
		var example_balloon_script_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(plugin_path + "/example_balloon/example_balloon.gd"))
		var example_balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path))

		# Copy the script file
		var file: FileAccess = FileAccess.open(plugin_path + "/example_balloon/" + example_balloon_script_file_name, FileAccess.READ)
		var file_contents: String = file.get_as_text()
=======
		var file_contents: String = FileAccess.get_file_as_string(example_balloon_path).replace(plugin_path + "/example_balloon/example_balloon.gd", balloon_script_path)
		# Give the balloon a unique UID
		var example_balloon_uid: String = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(example_balloon_path))
		var new_balloon_uid: String = ResourceUID.id_to_text(ResourceUID.create_id())
		file_contents = file_contents.replace(example_balloon_uid, new_balloon_uid)
		# Save the new balloon
		var file: FileAccess = FileAccess.open(balloon_path, FileAccess.WRITE)
		file.store_string(file_contents)
		file.close()

		# Copy the script file
		file = FileAccess.open(plugin_path + "/example_balloon/" + example_balloon_script_file_name, FileAccess.READ)
		file_contents = file.get_as_text()
>>>>>>> dev_branch
		if is_dotnet:
			file_contents = file_contents.replace("class ExampleBalloon", "class DialogueBalloon")
		else:
			file_contents = file_contents.replace("class_name DialogueManagerExampleBalloon ", "")
		file = FileAccess.open(balloon_script_path, FileAccess.WRITE)
		file.store_string(file_contents)
		file.close()
<<<<<<< HEAD
		var new_balloon_script_uid_raw: int = ResourceUID.create_id()
		ResourceUID.add_id(new_balloon_script_uid_raw, balloon_script_path)
		var new_balloon_script_uid: String = ResourceUID.id_to_text(new_balloon_script_uid_raw)

		# Save the new balloon
		file_contents = FileAccess.get_file_as_string(example_balloon_path).replace(plugin_path + "/example_balloon/example_balloon.gd", balloon_script_path)
		var new_balloon_uid: String = ResourceUID.id_to_text(ResourceUID.create_id())
		file_contents = file_contents.replace(example_balloon_uid, new_balloon_uid).replace(example_balloon_script_uid, new_balloon_script_uid)
		file = FileAccess.open(balloon_path, FileAccess.WRITE)
		file.store_string(file_contents)
		file.close()

		EditorInterface.get_resource_filesystem().scan()
		EditorInterface.get_file_system_dock().call_deferred("navigate_to_path", balloon_path)

		DMSettings.set_setting(DMSettings.BALLOON_PATH, balloon_path)

		directory_dialog.queue_free()
	)
	EditorInterface.get_base_control().add_child(directory_dialog)
=======

		get_editor_interface().get_resource_filesystem().scan()
		get_editor_interface().get_file_system_dock().call_deferred("navigate_to_path", balloon_path)

		DialogueSettings.set_setting("balloon_path", balloon_path)

		directory_dialog.queue_free()
	)
	get_editor_interface().get_base_control().add_child(directory_dialog)
>>>>>>> dev_branch
	directory_dialog.popup_centered()


### Signals


func _on_files_moved(old_file: String, new_file: String) -> void:
	update_import_paths(old_file, new_file)
<<<<<<< HEAD
	DMSettings.move_recent_file(old_file, new_file)
=======
	DialogueSettings.move_recent_file(old_file, new_file)
>>>>>>> dev_branch


func _on_file_removed(file: String) -> void:
	update_import_paths(file, "")
	if is_instance_valid(main_view):
		main_view.close_file(file)
	_update_localization()
