@tool
<<<<<<< HEAD
class_name DMSyntaxHighlighter extends SyntaxHighlighter


var regex: DMCompilerRegEx = DMCompilerRegEx.new()
var compilation: DMCompilation = DMCompilation.new()
var expression_parser = DMExpressionParser.new()
=======
extends SyntaxHighlighter


const DialogueManagerParser = preload("./parser.gd")


enum ExpressionType {DO, SET, IF}


var dialogue_manager_parser: DialogueManagerParser = DialogueManagerParser.new()

var regex_titles: RegEx = RegEx.create_from_string("^\\s*(?<title>~\\s+[^\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\=\\+\\{\\}\\[\\]\\;\\:\\\"\\'\\,\\.\\<\\>\\?\\/\\s]+)")
var regex_comments: RegEx = RegEx.create_from_string("(?:(?>\"(?:\\\\\"|[^\"\\n])*\")[^\"\\n]*?\\s*(?<comment>#[^\\n]*)$|^[^\"#\\n]*?\\s*(?<comment2>#[^\\n]*))")
var regex_mutation: RegEx = RegEx.create_from_string("^\\s*(do|do!|set) (?<mutation>.*)")
var regex_condition: RegEx = RegEx.create_from_string("^\\s*(if|elif|while|else if) (?<condition>.*)")
var regex_wcondition: RegEx = RegEx.create_from_string("\\[if (?<condition>((?:[^\\[\\]]*)|(?:\\[(?1)\\]))*?)\\]")
var regex_wendif: RegEx = RegEx.create_from_string("\\[(\\/if|else)\\]")
var regex_rgroup: RegEx = RegEx.create_from_string("\\[\\[(?<options>.*?)\\]\\]")
var regex_endconditions: RegEx = RegEx.create_from_string("^\\s*(endif|else):?\\s*$")
var regex_tags: RegEx = RegEx.create_from_string("\\[(?<tag>(?!(?:ID:.*)|if)[a-zA-Z_][a-zA-Z0-9_]*!?)(?:[= ](?<val>[^\\[\\]]+))?\\](?:(?<text>(?!\\[\\/\\k<tag>\\]).*?)?(?<end>\\[\\/\\k<tag>\\]))?")
var regex_dialogue: RegEx = RegEx.create_from_string("^\\s*(?:(?<random>\\%[\\d.]* )|(?<response>- ))?(?:(?<character>[^#:]*): )?(?<dialogue>.*)$")
var regex_goto: RegEx = RegEx.create_from_string("=><? (?:(?<file>[^\\/]+)\\/)?(?<title>[^\\/]*)")
var regex_string: RegEx = RegEx.create_from_string("^&?(?<delimiter>[\"'])(?<content>(?:\\\\{2})*|(?:.*?[^\\\\](?:\\\\{2})*))\\1$")
var regex_escape: RegEx = RegEx.create_from_string("\\\\.")
var regex_number: RegEx = RegEx.create_from_string("^-?(?:(?:0x(?:[0-9A-Fa-f]{2})+)|(?:0b[01]+)|(?:\\d+(?:(?:[\\.]\\d*)?(?:e\\d+)?)|(?:_\\d+)+)?)$")
var regex_array: RegEx = RegEx.create_from_string("\\[((?>[^\\[\\]]+|(?R))*)\\]")
var regex_dict: RegEx = RegEx.create_from_string("^\\{((?>[^\\{\\}]+|(?R))*)\\}$")
var regex_kvdict: RegEx = RegEx.create_from_string("^\\s*(?<left>.*?)\\s*(?<colon>:|=)\\s*(?<right>[^\\/]+)$")
var regex_commas: RegEx = RegEx.create_from_string("([^,]+)(?:\\s*,\\s*)?")
var regex_assignment: RegEx = RegEx.create_from_string("^\\s*(?<var>[a-zA-Z_][a-zA-Z_0-9]*)(?:(?<attr>(?:\\.[a-zA-Z_][a-zA-Z_0-9]*)+)|(?:\\[(?<key>[^\\]]+)\\]))?\\s*(?<op>(?:\\/|\\*|-|\\+)?=)\\s*(?<val>.*)$")
var regex_varname: RegEx = RegEx.create_from_string("^\\s*(?!true|false|and|or|&&|\\|\\|not|in|null)(?<var>[a-zA-Z_][a-zA-Z_0-9]*)(?:(?<attr>(?:\\.[a-zA-Z_][a-zA-Z_0-9]*)+)|(?:\\[(?<key>[^\\]]+)\\]))?\\s*$")
var regex_keyword: RegEx = RegEx.create_from_string("^\\s*(true|false|null)\\s*$")
var regex_function: RegEx = RegEx.create_from_string("^\\s*([a-zA-Z_][a-zA-Z_0-9]*\\s*)\\(")
var regex_comparison: RegEx = RegEx.create_from_string("^(?<left>.*?)\\s*(?<op>==|>=|<=|<|>|!=)\\s*(?<right>.*)$")
var regex_blogical: RegEx = RegEx.create_from_string("^(?<left>.*?)\\s+(?<op>and|or|in|&&|\\|\\|)\\s+(?<right>.*)$")
var regex_ulogical: RegEx = RegEx.create_from_string("^\\s*(?<op>not)\\s+(?<right>.*)$")
var regex_paren: RegEx = RegEx.create_from_string("\\((?<paren>((?:[^\\(\\)]*)|(?:\\((?1)\\)))*?)\\)")
>>>>>>> dev_branch

var cache: Dictionary = {}


<<<<<<< HEAD
func _clear_highlighting_cache() -> void:
	cache.clear()


=======
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		dialogue_manager_parser.free()


func _clear_highlighting_cache() -> void:
	cache = {}


## Returns the syntax coloring for a dialogue file line
>>>>>>> dev_branch
func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var colors: Dictionary = {}
	var text_edit: TextEdit = get_text_edit()
	var text: String = text_edit.get_line(line)

	# Prevent an error from popping up while developing
	if not is_instance_valid(text_edit) or text_edit.theme_overrides.is_empty():
		return colors

	# Disable this, as well as the line at the bottom of this function to remove the cache.
	if text in cache:
		return cache[text]

<<<<<<< HEAD
	var theme: Dictionary = text_edit.theme_overrides

	var index: int = 0

	match DMCompiler.get_line_type(text):
		DMConstants.TYPE_COMMENT:
			colors[index] = { color = theme.comments_color }

		DMConstants.TYPE_TITLE:
			colors[index] = { color = theme.titles_color }

		DMConstants.TYPE_CONDITION, DMConstants.TYPE_WHILE, DMConstants.TYPE_MATCH, DMConstants.TYPE_WHEN:
			colors[0] = { color = theme.conditions_color }
			index = text.find(" ")
			if index > -1:
				var expression: Array = expression_parser.tokenise(text.substr(index), DMConstants.TYPE_CONDITION, 0)
				if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
					colors[index] = { color = theme.critical_color }
				else:
					_highlight_expression(expression, colors, index)

		DMConstants.TYPE_MUTATION:
			colors[0] = { color = theme.mutations_color }
			index = text.find(" ")
			var expression: Array = expression_parser.tokenise(text.substr(index), DMConstants.TYPE_MUTATION, 0)
			if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
				colors[index] = { color = theme.critical_color }
			else:
				_highlight_expression(expression, colors, index)

		DMConstants.TYPE_GOTO:
			if text.strip_edges().begins_with("%"):
				colors[index] = { color = theme.symbols_color }
				index = text.find(" ")
			_highlight_goto(text, colors, index)

		DMConstants.TYPE_RANDOM:
			colors[index] = { color = theme.symbols_color }

		DMConstants.TYPE_DIALOGUE, DMConstants.TYPE_RESPONSE:
			if text.strip_edges().begins_with("%"):
				colors[index] = { color = theme.symbols_color }
				index = text.find(" ")
			colors[index] = { color = theme.text_color }

			var dialogue_text: String = text.substr(index, text.find("=>"))

			# Interpolation
			var replacements: Array[RegExMatch] = regex.REPLACEMENTS_REGEX.search_all(dialogue_text)
			for replacement: RegExMatch in replacements:
				var expression_text: String = replacement.get_string().substr(0, replacement.get_string().length() - 2).substr(2)
				var expression: Array = expression_parser.tokenise(expression_text, DMConstants.TYPE_MUTATION, replacement.get_start())
				var expression_index: int = index + replacement.get_start()
				colors[expression_index] = { color = theme.symbols_color }
				if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
					colors[expression_index] = { color = theme.critical_color }
				else:
					_highlight_expression(expression, colors, index + 2)
				colors[expression_index + expression_text.length() + 2] = { color = theme.symbols_color }
				colors[expression_index + expression_text.length() + 4] = { color = theme.text_color }
			# Tags (and inline mutations)
			var resolved_line_data: DMResolvedLineData = DMResolvedLineData.new("")
			var bbcodes: Array[Dictionary] = resolved_line_data.find_bbcode_positions_in_string(dialogue_text, true, true)
			for bbcode: Dictionary in bbcodes:
				var tag: String = bbcode.code
				var code: String = bbcode.raw_args
				if code.begins_with("["):
					colors[bbcode.start] = { color = theme.symbols_color }
					colors[bbcode.start + 2] = { color = theme.text_color }
					var pipe_cursor: int = code.find("|")
					while pipe_cursor > -1:
						colors[bbcode.start + pipe_cursor + 1] = { color = theme.symbols_color }
						colors[bbcode.start + pipe_cursor + 2] = { color = theme.text_color }
						pipe_cursor = code.find("|", pipe_cursor + 1)
					colors[bbcode.end - 1] = { color = theme.symbols_color }
					colors[bbcode.end + 1] = { color = theme.text_color }
				else:
					colors[bbcode.start] = { color = theme.symbols_color }
					if tag.begins_with("do") or tag.begins_with("set") or tag.begins_with("if"):
						if tag.begins_with("if"):
							colors[bbcode.start + 1] = { color = theme.conditions_color }
						else:
							colors[bbcode.start + 1] = { color = theme.mutations_color }
						var expression: Array = expression_parser.tokenise(code, DMConstants.TYPE_MUTATION, bbcode.start + bbcode.code.length())
						if expression.size() == 0 or expression[0].type == DMConstants.TYPE_ERROR:
							colors[bbcode.start + tag.length() + 1] = { color = theme.critical_color }
						else:
							_highlight_expression(expression, colors, index + 2)
					# else and closing if have no expression
					elif tag.begins_with("else") or tag.begins_with("/if"):
						colors[bbcode.start + 1] = { color = theme.conditions_color }
					colors[bbcode.end] = { color = theme.symbols_color }
					colors[bbcode.end + 1] = { color = theme.text_color }
			# Jumps
			if "=> " in text or "=>< " in text:
				_highlight_goto(text, colors, index)

	# Order the dictionary keys to prevent CodeEdit from having issues
	var ordered_colors: Dictionary = {}
	var ordered_keys: Array = colors.keys()
	ordered_keys.sort()
	for key_index: int in ordered_keys:
		ordered_colors[key_index] = colors[key_index]

	cache[text] = ordered_colors
	return ordered_colors


func _highlight_expression(tokens: Array, colors: Dictionary, index: int) -> int:
	var theme: Dictionary = get_text_edit().theme_overrides
	var last_index: int = index
	for token: Dictionary in tokens:
		last_index = token.i
		match token.type:
			DMConstants.TOKEN_CONDITION, DMConstants.TOKEN_AND_OR:
				colors[index + token.i] = { color = theme.conditions_color }

			DMConstants.TOKEN_VARIABLE:
				if token.value in ["true", "false"]:
					colors[index + token.i] = { color = theme.conditions_color }
				else:
					colors[index + token.i] = { color = theme.members_color }

			DMConstants.TOKEN_OPERATOR, DMConstants.TOKEN_COLON, DMConstants.TOKEN_COMMA, DMConstants.TOKEN_NUMBER, DMConstants.TOKEN_ASSIGNMENT:
				colors[index + token.i] = { color = theme.symbols_color }

			DMConstants.TOKEN_STRING:
				colors[index + token.i] = { color = theme.strings_color }

			DMConstants.TOKEN_FUNCTION:
				colors[index + token.i] = { color = theme.mutations_color }
				colors[index + token.i + token.function.length()] = { color = theme.symbols_color }
				for parameter: Array in token.value:
					last_index = _highlight_expression(parameter, colors, index)
			DMConstants.TOKEN_PARENS_CLOSE:
				colors[index + token.i] = { color = theme.symbols_color }

			DMConstants.TOKEN_DICTIONARY_REFERENCE:
				colors[index + token.i] = { color = theme.members_color }
				colors[index + token.i + token.variable.length()] = { color = theme.symbols_color }
				last_index = _highlight_expression(token.value, colors, index)
			DMConstants.TOKEN_ARRAY:
				colors[index + token.i] = { color = theme.symbols_color }
				for item: Array in token.value:
					last_index = _highlight_expression(item, colors, index)
			DMConstants.TOKEN_BRACKET_CLOSE:
				colors[index + token.i] = { color = theme.symbols_color }

			DMConstants.TOKEN_DICTIONARY:
				colors[index + token.i] = { color = theme.symbols_color }
				last_index = _highlight_expression(token.value.keys() + token.value.values(), colors, index)
			DMConstants.TOKEN_BRACE_CLOSE:
				colors[index + token.i] = { color = theme.symbols_color }
				last_index += 1

			DMConstants.TOKEN_GROUP:
				last_index = _highlight_expression(token.value, colors, index)

	return last_index


func _highlight_goto(text: String, colors: Dictionary, index: int) -> int:
	var theme: Dictionary = get_text_edit().theme_overrides
	var goto_data: DMResolvedGotoData = DMResolvedGotoData.new(text, {})
	colors[goto_data.index] = { color = theme.jumps_color }
	if "{{" in text:
		index = text.find("{{", goto_data.index)
		var last_index: int = 0
		if goto_data.error:
			colors[index + 2] = { color = theme.critical_color }
		else:
			last_index = _highlight_expression(goto_data.expression, colors, index)
		index = text.find("}}", index + last_index)
		colors[index] = { color = theme.jumps_color }

	return index
=======
	# Comments have to be removed to make the remaining processing easier.
	# Count both end-of-line and single-line comments
	# Comments are not allowed within dialogue lines or response lines, so we ask the parser what it thinks the current line is
	if not (dialogue_manager_parser.is_dialogue_line(text) or dialogue_manager_parser.is_response_line(text)) or dialogue_manager_parser.is_line_empty(text) or dialogue_manager_parser.is_import_line(text):
		var comment_matches: Array[RegExMatch] = regex_comments.search_all(text)
		for comment_match in comment_matches:
			for i in ["comment", "comment2"]:
				if i in comment_match.names:
					colors[comment_match.get_start(i)] = {"color": text_edit.theme_overrides.comments_color}
					text = text.substr(0, comment_match.get_start(i))

	# Dialogues
	var dialogue_matches: Array[RegExMatch] = regex_dialogue.search_all(text)
	for dialogue_match in dialogue_matches:
		if "random" in dialogue_match.names:
			colors[dialogue_match.get_start("random")] = {"color": text_edit.theme_overrides.symbols_color}
			colors[dialogue_match.get_end("random")] = {"color": text_edit.theme_overrides.text_color}
		if "response" in dialogue_match.names:
			colors[dialogue_match.get_start("response")] = {"color": text_edit.theme_overrides.symbols_color}
			colors[dialogue_match.get_end("response")] = {"color": text_edit.theme_overrides.text_color}
		if "character" in dialogue_match.names:
			colors[dialogue_match.get_start("character")] = {"color": text_edit.theme_overrides.members_color}
			colors[dialogue_match.get_end("character")] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_dialogue_syntax_highlighting(dialogue_match.get_start("dialogue"), dialogue_match.get_string("dialogue")), true)

	# Title lines
	if dialogue_manager_parser.is_title_line(text):
		var title_matches: Array[RegExMatch] = regex_titles.search_all(text)
		for title_match in title_matches:
			colors[title_match.get_start("title")] = {"color": text_edit.theme_overrides.titles_color}

	# Import lines
	var import_matches: Array[RegExMatch] = dialogue_manager_parser.IMPORT_REGEX.search_all(text)
	for import_match in import_matches:
		colors[import_match.get_start(0)] = {"color": text_edit.theme_overrides.conditions_color}
		colors[import_match.get_start("path") - 1] = {"color": text_edit.theme_overrides.strings_color}
		colors[import_match.get_end("path") + 1] = {"color": text_edit.theme_overrides.conditions_color}
		colors[import_match.get_start("prefix")] = {"color": text_edit.theme_overrides.members_color}
		colors[import_match.get_end("prefix")] = {"color": text_edit.theme_overrides.conditions_color}

	# Using clauses
	var using_matches: Array[RegExMatch] = dialogue_manager_parser.USING_REGEX.search_all(text)
	for using_match in using_matches:
		colors[using_match.get_start(0)] = {"color": text_edit.theme_overrides.conditions_color}
		colors[using_match.get_start("state") - 1] = {"color": text_edit.theme_overrides.text_color}

	# Condition keywords and expressions
	var condition_matches: Array[RegExMatch] = regex_condition.search_all(text)
	for condition_match in condition_matches:
		colors[condition_match.get_start(0)] = {"color": text_edit.theme_overrides.conditions_color}
		colors[condition_match.get_end(1)] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_expression_syntax_highlighting(condition_match.get_start("condition"), ExpressionType.IF, condition_match.get_string("condition")), true)
	# endif/else
	var endcondition_matches: Array[RegExMatch] = regex_endconditions.search_all(text)
	for endcondition_match in endcondition_matches:
		colors[endcondition_match.get_start(1)] = {"color": text_edit.theme_overrides.conditions_color}
		colors[endcondition_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}

	# Mutations
	var mutation_matches: Array[RegExMatch] = regex_mutation.search_all(text)
	for mutation_match in mutation_matches:
		colors[mutation_match.get_start(0)] = {"color": text_edit.theme_overrides.mutations_color}
		colors.merge(_get_expression_syntax_highlighting(mutation_match.get_start("mutation"), ExpressionType.DO if mutation_match.strings[1].begins_with("do") else ExpressionType.SET, mutation_match.get_string("mutation")), true)

	# Order the dictionary keys to prevent CodeEdit from having issues
	var new_colors: Dictionary = {}
	var ordered_keys: Array = colors.keys()
	ordered_keys.sort()
	for index in ordered_keys:
		new_colors[index] = colors[index]

	cache[text] = new_colors
	return new_colors


## Return the syntax highlighting for a dialogue line
func _get_dialogue_syntax_highlighting(start_index: int, text: String) -> Dictionary:
	var text_edit: TextEdit = get_text_edit()
	var colors: Dictionary = {}

	# #tag style tags
	var hashtag_matches: Array[RegExMatch] = dialogue_manager_parser.TAGS_REGEX.search_all(text)
	for hashtag_match in hashtag_matches:
		colors[start_index + hashtag_match.get_start(0)] = { "color": text_edit.theme_overrides.comments_color }
		colors[start_index + hashtag_match.get_end(0)] = { "color": text_edit.theme_overrides.text_color }

	# bbcode-like global tags
	var tag_matches: Array[RegExMatch] = regex_tags.search_all(text)
	for tag_match in tag_matches:
		colors[start_index + tag_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		if "val" in tag_match.names:
			colors.merge(_get_literal_syntax_highlighting(start_index + tag_match.get_start("val"), tag_match.get_string("val")), true)
			colors[start_index + tag_match.get_end("val")] = {"color": text_edit.theme_overrides.symbols_color}
		# Show the text color straight in the editor for better ease-of-use
		if tag_match.get_string("tag") == "color":
			colors[start_index + tag_match.get_start("val")] = {"color": Color.from_string(tag_match.get_string("val"), text_edit.theme_overrides.text_color)}
		if "text" in tag_match.names:
			colors[start_index + tag_match.get_start("text")] = {"color": text_edit.theme_overrides.text_color}
			# Text can still contain tags if several effects are applied ([center][b]Something[/b][/center], so recursing
			colors.merge(_get_dialogue_syntax_highlighting(start_index + tag_match.get_start("text"), tag_match.get_string("text")), true)
			colors[start_index + tag_match.get_end("text")] = {"color": text_edit.theme_overrides.symbols_color}
		if "end" in tag_match.names:
			colors[start_index + tag_match.get_start("end")] = {"color": text_edit.theme_overrides.symbols_color}
			colors[start_index + tag_match.get_end("end")] = {"color": text_edit.theme_overrides.text_color}
		colors[start_index + tag_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	# ID tag
	var translation_matches: Array[RegExMatch] = dialogue_manager_parser.TRANSLATION_REGEX.search_all(text)
	for translation_match in translation_matches:
		colors[start_index + translation_match.get_start(0)] = {"color": text_edit.theme_overrides.comments_color}
		colors[start_index + translation_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	# Replacements
	var replacement_matches: Array[RegExMatch] = dialogue_manager_parser.REPLACEMENTS_REGEX.search_all(text)
	for replacement_match in replacement_matches:
		colors[start_index + replacement_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + replacement_match.get_start(1)] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + replacement_match.get_start(1), replacement_match.strings[1]), true)
		colors[start_index + replacement_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + replacement_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	# Jump at the end of a response
	var goto_matches: Array[RegExMatch] = regex_goto.search_all(text)
	for goto_match in goto_matches:
		colors[start_index + goto_match.get_start(0)] = {"color": text_edit.theme_overrides.jumps_color}
		if "file" in goto_match.names:
			colors[start_index + goto_match.get_start("file")] = {"color": text_edit.theme_overrides.jumps_color}
			colors[start_index + goto_match.get_end("file")] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + goto_match.get_start("title")] = {"color": text_edit.theme_overrides.jumps_color}
		colors[start_index + goto_match.get_end("title")] = {"color": text_edit.theme_overrides.jumps_color}
		colors[start_index + goto_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	# Wrapped condition
	var wcondition_matches: Array[RegExMatch] = regex_wcondition.search_all(text)
	for wcondition_match in wcondition_matches:
		colors[start_index + wcondition_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + wcondition_match.get_start(0) + 1] = {"color": text_edit.theme_overrides.conditions_color}
		colors[start_index + wcondition_match.get_start(0) + 3] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + wcondition_match.get_start("condition"), wcondition_match.get_string("condition")), true)
		colors[start_index + wcondition_match.get_end("condition")] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + wcondition_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}
	# [/if] tag for color matching with the opening tag
	var wendif_matches: Array[RegExMatch] = regex_wendif.search_all(text)
	for wendif_match in wendif_matches:
		colors[start_index + wendif_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + wendif_match.get_start(1)] = {"color": text_edit.theme_overrides.conditions_color}
		colors[start_index + wendif_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + wendif_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	# Random groups
	var rgroup_matches: Array[RegExMatch] = regex_rgroup.search_all(text)
	for rgroup_match in rgroup_matches:
		colors[start_index + rgroup_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + rgroup_match.get_start("options")] = {"color": text_edit.theme_overrides.text_color}
		var separator_matches: Array[RegExMatch] = RegEx.create_from_string("\\|").search_all(rgroup_match.get_string("options"))
		for separator_match in separator_matches:
			colors[start_index + rgroup_match.get_start("options") + separator_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
			colors[start_index + rgroup_match.get_start("options") + separator_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}
		colors[start_index + rgroup_match.get_end("options")] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + rgroup_match.get_end(0)] = {"color": text_edit.theme_overrides.text_color}

	return colors


## Returns the syntax highlighting for an expression (mutation set/do, or condition)
func _get_expression_syntax_highlighting(start_index: int, type: ExpressionType, text: String) -> Dictionary:
	var text_edit: TextEdit = get_text_edit()
	var colors: Dictionary = {}

	if type == ExpressionType.SET:
		var assignment_matches: Array[RegExMatch] = regex_assignment.search_all(text)
		for assignment_match in assignment_matches:
			colors[start_index + assignment_match.get_start("var")] = {"color": text_edit.theme_overrides.text_color}
			if "attr" in assignment_match.names:
				colors[start_index + assignment_match.get_start("attr")] = {"color": text_edit.theme_overrides.members_color}
				colors[start_index + assignment_match.get_end("attr")] = {"color": text_edit.theme_overrides.text_color}
			if "key" in assignment_match.names:
				# Braces are outside of the key, so coloring them symbols_color
				colors[start_index + assignment_match.get_start("key") - 1] = {"color": text_edit.theme_overrides.symbols_color}
				colors.merge(_get_literal_syntax_highlighting(start_index + assignment_match.get_start("key"), assignment_match.get_string("key")), true)
				colors[start_index + assignment_match.get_end("key")] = {"color": text_edit.theme_overrides.symbols_color}
				colors[start_index + assignment_match.get_end("key") + 1] = {"color": text_edit.theme_overrides.text_color}

			colors[start_index + assignment_match.get_start("op")] = {"color": text_edit.theme_overrides.symbols_color}
			colors[start_index + assignment_match.get_end("op")] = {"color": text_edit.theme_overrides.text_color}
			colors.merge(_get_literal_syntax_highlighting(start_index + assignment_match.get_start("val"), assignment_match.get_string("val")), true)
	else:
		colors.merge(_get_literal_syntax_highlighting(start_index, text), true)

	return colors


## Return the syntax highlighting for a literal
## For this purpose, "literal" refers to a regular code line that could be used to get a value out of:
## - function calls
## - real literals (bool, string, int, float, etc.)
## - logical operators (>, <, >=, or, and, not, etc.)
func _get_literal_syntax_highlighting(start_index: int, text: String) -> Dictionary:
	var text_edit: TextEdit = get_text_edit()
	var colors: Dictionary = {}

	# Remove spaces at start/end of the literal
	var text_length: int = text.length()
	text = text.lstrip(" ")
	start_index += text_length - text.length()
	text = text.rstrip(" ")

	# Parenthesis expression.
	var paren_matches: Array[RegExMatch] = regex_paren.search_all(text)
	for paren_match in paren_matches:
		colors[start_index + paren_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + paren_match.get_start(0) + 1] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + paren_match.get_start("paren"), paren_match.get_string("paren")), true)
		colors[start_index + paren_match.get_end(0) - 1] = {"color": text_edit.theme_overrides.symbols_color}

	# Strings
	var string_matches: Array[RegExMatch] = regex_string.search_all(text)
	for string_match in string_matches:
		colors[start_index + string_match.get_start(0)] = {"color": text_edit.theme_overrides.strings_color}
		if "content" in string_match.names:
			var escape_matches: Array[RegExMatch] = regex_escape.search_all(string_match.get_string("content"))
			for escape_match in escape_matches:
				colors[start_index + string_match.get_start("content") + escape_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
				colors[start_index + string_match.get_start("content") + escape_match.get_end(0)] = {"color": text_edit.theme_overrides.strings_color}

	# Numbers
	var number_matches: Array[RegExMatch] = regex_number.search_all(text)
	for number_match in number_matches:
		colors[start_index + number_match.get_start(0)] = {"color": text_edit.theme_overrides.numbers_color}

	# Arrays
	var array_matches: Array[RegExMatch] = regex_array.search_all(text)
	for array_match in array_matches:
		colors[start_index + array_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors.merge(_get_list_syntax_highlighting(start_index + array_match.get_start(1), array_match.strings[1]), true)
		colors[start_index + array_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}

	# Dictionaries
	var dict_matches: Array[RegExMatch] = regex_dict.search_all(text)
	for dict_match in dict_matches:
		colors[start_index + dict_match.get_start(0)] = {"color": text_edit.theme_overrides.symbols_color}
		colors.merge(_get_list_syntax_highlighting(start_index + dict_match.get_start(1), dict_match.strings[1]), true)
		colors[start_index + dict_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}

	# Dictionary key: value pairs
	var kvdict_matches: Array[RegExMatch] = regex_kvdict.search_all(text)
	for kvdict_match in kvdict_matches:
		colors.merge(_get_literal_syntax_highlighting(start_index + kvdict_match.get_start("left"), kvdict_match.get_string("left")), true)
		colors[start_index + kvdict_match.get_start("colon")] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + kvdict_match.get_end("colon")] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + kvdict_match.get_start("right"), kvdict_match.get_string("right")), true)

	# Booleans
	var bool_matches: Array[RegExMatch] = regex_keyword.search_all(text)
	for bool_match in bool_matches:
		colors[start_index + bool_match.get_start(0)] = {"color": text_edit.theme_overrides.conditions_color}

	# Functions
	var function_matches: Array[RegExMatch] = regex_function.search_all(text)
	for function_match in function_matches:
		var last_brace_index: int = text.rfind(")")
		colors[start_index + function_match.get_start(1)] = {"color": text_edit.theme_overrides.mutations_color}
		colors[start_index + function_match.get_end(1)] = {"color": text_edit.theme_overrides.symbols_color}
		colors.merge(_get_list_syntax_highlighting(start_index + function_match.get_end(0), text.substr(function_match.get_end(0), last_brace_index - function_match.get_end(0))), true)
		colors[start_index + last_brace_index] = {"color": text_edit.theme_overrides.symbols_color}

	# Variables
	var varname_matches: Array[RegExMatch] = regex_varname.search_all(text)
	for varname_match in varname_matches:
		colors[start_index + varname_match.get_start("var")] = {"color": text_edit.theme_overrides.text_color}
		if "attr" in varname_match.names:
			colors[start_index + varname_match.get_start("attr")] = {"color": text_edit.theme_overrides.members_color}
			colors[start_index + varname_match.get_end("attr")] = {"color": text_edit.theme_overrides.text_color}
		if "key" in varname_match.names:
			# Braces are outside of the key, so coloring them symbols_color
			colors[start_index + varname_match.get_start("key") - 1] = {"color": text_edit.theme_overrides.symbols_color}
			colors.merge(_get_literal_syntax_highlighting(start_index + varname_match.get_start("key"), varname_match.get_string("key")), true)
			colors[start_index + varname_match.get_end("key")] = {"color": text_edit.theme_overrides.symbols_color}

	# Comparison operators
	var comparison_matches: Array[RegExMatch] = regex_comparison.search_all(text)
	for comparison_match in comparison_matches:
		colors.merge(_get_literal_syntax_highlighting(start_index + comparison_match.get_start("left"), comparison_match.get_string("left")), true)
		colors[start_index + comparison_match.get_start("op")] = {"color": text_edit.theme_overrides.symbols_color}
		colors[start_index + comparison_match.get_end("op")] = {"color": text_edit.theme_overrides.text_color}
		var right = comparison_match.get_string("right")
		if right.ends_with(":"):
			right = right.substr(0, right.length() - 1)
		colors.merge(_get_literal_syntax_highlighting(start_index + comparison_match.get_start("right"), right), true)
		colors[start_index + comparison_match.get_start("right") + right.length()] = { "color": text_edit.theme_overrides.symbols_color }

	# Logical binary operators
	var blogical_matches: Array[RegExMatch] = regex_blogical.search_all(text)
	for blogical_match in blogical_matches:
		colors.merge(_get_literal_syntax_highlighting(start_index + blogical_match.get_start("left"), blogical_match.get_string("left")), true)
		colors[start_index + blogical_match.get_start("op")] = {"color": text_edit.theme_overrides.conditions_color}
		colors[start_index + blogical_match.get_end("op")] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + blogical_match.get_start("right"), blogical_match.get_string("right")), true)

	# Logical unary operators
	var ulogical_matches: Array[RegExMatch] = regex_ulogical.search_all(text)
	for ulogical_match in ulogical_matches:
		colors[start_index + ulogical_match.get_start("op")] = {"color": text_edit.theme_overrides.conditions_color}
		colors[start_index + ulogical_match.get_end("op")] = {"color": text_edit.theme_overrides.text_color}
		colors.merge(_get_literal_syntax_highlighting(start_index + ulogical_match.get_start("right"), ulogical_match.get_string("right")), true)

	return colors


## Returns the syntax coloring for a list of literals separated by commas
func _get_list_syntax_highlighting(start_index: int, text: String) -> Dictionary:
	var text_edit: TextEdit = get_text_edit()
	var colors: Dictionary = {}

	# Comma-separated list of literals (for arrays and function arguments)
	var element_matches: Array[RegExMatch] = regex_commas.search_all(text)
	for element_match in element_matches:
		colors.merge(_get_literal_syntax_highlighting(start_index + element_match.get_start(1), element_match.strings[1]), true)

	return colors
>>>>>>> dev_branch
