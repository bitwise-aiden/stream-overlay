extends TextEdit

# Syntax highlighting, colors and keywords is thanks to:
# https://github.com/GDQuest/learn-gdscript/blob/main/ui/components/CodeEditorEnhancer.gd
# - TheYagich

# Private constants

const __BASE_SOURCE_CODE = "func handle(state: Dictionary) -> void:\n\t%s"

const __COLOR_CLASS: Color = Color(0.556,1,0.856)
const __COLOR_MEMBER: Color = Color(0.736, 0.88, 1)
const __COLOR_KEYWORD: Color = Color(1,0.44,0.52)
const __COLOR_QUOTES: Color = Color(1, 0.960784, 0.25098)
const __COLOR_COMMENTS: Color = Color(0.290196, 0.294118, 0.388235)
const __KEYWORDS: Array = [
	"onready",
	"var",
	"export",
	"if",
	"elif",
	"else",
	"for",
	"do",
	"while",
	"match",
	"switch",
	"case",
	"break",
	"continue",
	"pass",
	"return",
	"class",
	"extends",
	"is",
	"self",
	"tool",
	"signal",
	"func",
	"static",
	"const",
	"enum",
	"setget",
	"breakpoint",
	"preload",
	"yield",
	"assert",
	"remote",
	"master",
	"slave",
	"sync",
	"Color8",
	"ColorN",
	"abs",
	"acos",
	"asin",
	"assert",
	"atan",
	"atan2",
	"bytes2var",
	"cartesian2polar",
	"ceil",
	"char",
	"clamp",
	"convert",
	"cos",
	"cosh",
	"db2linear",
	"decials",
	"dectime",
	"def2rad",
	"dict2inst",
	"ease",
	"expo",
	"floor",
	"fmod",
	"fposmod",
	"funcref",
	"hash",
	"inst2dict",
	"instance_from_id",
	"inverse_lerp",
	"is_inf",
	"is_nan",
	"len",
	"lerp",
	"linear2db",
	"load",
	"log",
	"max",
	"min",
	"nearest_po2",
	"parse_json",
	"polar2cartesian",
	"pow",
	"preload",
	"print",
	"print_stack",
	"printerr",
	"printraw",
	"prints",
	"printt",
	"rad2def",
	"rand_range",
	"rand_seed",
	"randf",
	"randi",
	"randomize",
	"range",
	"range_lerp",
	"round",
	"seed",
	"sign",
	"sin",
	"sinh",
	"sqrt",
	"stepify",
	"str",
	"str2var",
	"tan",
	"tanh",
	"to_json",
	"type_exists",
	"typeof",
	"validate_json",
	"var2bytes",
	"var2str",
	"weakref",
	"wrapf",
	"wrapi",
	"yield",
	"int",
	"float",
	"bool",
	"and",
	"void",
]

# Private variables

var __timer_debounce: Timer = null


# Lifecycle methods

func _init() -> void:
	add_color_region('"', '"', __COLOR_QUOTES)
	add_color_region("'", "'", __COLOR_QUOTES)
	add_color_region("#", "\n", __COLOR_COMMENTS, true)

	for classname in ClassDB.get_class_list():
		add_keyword_color(classname, __COLOR_CLASS)
		for member in ClassDB.class_get_property_list(classname):
			for key in member:
				add_keyword_color(key, __COLOR_MEMBER)

	for keyword in __KEYWORDS:
		add_keyword_color(keyword, __COLOR_KEYWORD)


func _ready():
	__timer_debounce = Timer.new()
	__timer_debounce.one_shot = true
	__timer_debounce.connect("timeout", self, "__check_code")
	add_child(__timer_debounce)

	connect("text_changed", self, "__input_code_text_changed")


# Private methods

func __check_code() -> void:
	var raw_code: String = text.replace("\n", "\n\t")
	var code: String = __BASE_SOURCE_CODE % raw_code

	var script: GDScript = GDScript.new()
	script.set_source_code(code)

	var thread: Thread = Thread.new()
	thread.start(self, "__reload_script", script)

	var error: int = thread.wait_to_finish()


func __input_code_text_changed() -> void:
	self.__timer_debounce.start(0.5)


func __reload_script(script: GDScript) -> int:
	return script.reload()
