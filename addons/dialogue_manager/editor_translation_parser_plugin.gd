<<<<<<< HEAD
class_name DMTranslationParserPlugin extends EditorTranslationParserPlugin


## Cached result of parsing a dialogue file.
var data: DMCompilerResult
## List of characters that were added.
var translated_character_names: PackedStringArray = []
var translated_lines: Array[Dictionary] = []
=======
extends EditorTranslationParserPlugin


const DialogueConstants = preload("./constants.gd")
const DialogueSettings = preload("./settings.gd")
const DialogueManagerParser = preload("./components/parser.gd")
const DialogueManagerParseResult = preload("./components/parse_result.gd")
>>>>>>> dev_branch


func _parse_file(path: String, msgids: Array, msgids_context_plural: Array) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()

<<<<<<< HEAD
	data = DMCompiler.compile_string(text, path)

	var known_keys: PackedStringArray = PackedStringArray([])

	# Add all character names if settings ask for it
	if DMSettings.get_setting(DMSettings.INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST, true):
		translated_character_names = [] as Array[DialogueLine]
		for character_name: String in data.character_names:
=======
	var data: DialogueManagerParseResult = DialogueManagerParser.parse_string(text, path)
	var known_keys: PackedStringArray = PackedStringArray([])

	# Add all character names if settings ask for it
	if DialogueSettings.get_setting("export_characters_in_translation", true):
		var character_names: PackedStringArray = data.character_names
		for character_name in character_names:
>>>>>>> dev_branch
			if character_name in known_keys: continue

			known_keys.append(character_name)

<<<<<<< HEAD
			translated_character_names.append(character_name)
=======
>>>>>>> dev_branch
			msgids_context_plural.append([character_name.replace('"', '\"'), "dialogue", ""])

	# Add all dialogue lines and responses
	var dialogue: Dictionary = data.lines
<<<<<<< HEAD
	for key: String in dialogue.keys():
		var line: Dictionary = dialogue.get(key)

		if not line.type in [DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE]: continue

		var translation_key: String = line.get(&"translation_key", line.text)

		if translation_key in known_keys: continue

		known_keys.append(translation_key)
		translated_lines.append(line)
		if translation_key == line.text:
=======
	for key in dialogue.keys():
		var line: Dictionary = dialogue.get(key)

		if not line.type in [DialogueConstants.TYPE_DIALOGUE, DialogueConstants.TYPE_RESPONSE]: continue
		if line.translation_key in known_keys: continue

		known_keys.append(line.translation_key)

		if line.translation_key == "" or line.translation_key == line.text:
>>>>>>> dev_branch
			msgids_context_plural.append([line.text.replace('"', '\"'), "", ""])
		else:
			msgids_context_plural.append([line.text.replace('"', '\"'), line.translation_key.replace('"', '\"'), ""])


<<<<<<< HEAD
func _get_comments(msgids_comment: Array[String], msgids_context_plural_comment: Array[String]) -> void:
	# Add all character names if settings ask for it
	if DMSettings.get_setting(DMSettings.INCLUDE_CHARACTERS_IN_TRANSLATABLE_STRINGS_LIST, true):
		for character_name in translated_character_names:
			msgids_context_plural_comment.append(DMConstants.translate("translation_plugin.character_name"))

	# Add all dialogue lines and responses
	for line: Dictionary in translated_lines:
		msgids_context_plural_comment.append(line.get("notes", ""))


=======
>>>>>>> dev_branch
func _get_recognized_extensions() -> PackedStringArray:
	return ["dialogue"]
