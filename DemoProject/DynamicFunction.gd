class_name DynamicFunction extends RefCounted

var arg_names:Array[String]
var statement:String
var object:Variant
var returns_value:bool

func _init( _arg_names:Array[String], _statement:String, _returns_value:bool=false ):
	arg_names = _arg_names
	statement = _statement
	returns_value = _returns_value

func execute( args:Array=[] ):
	if not object:
		var source = "extends RefCounted\nfunc execute(%s):\n" % [",".join(arg_names)]
		for arg_name in arg_names:
			source += "  %s = %s\n" % [arg_name,arg_name]  # avoid unused parameter warnings

		var gdscript = GDScript.new()
		gdscript.source_code = source
		if returns_value:
			gdscript.source_code = "%s  return %s\n" % [source,statement]
		else:
			gdscript.source_code = "%s  %s\n" % [source,statement]
		gdscript.reload()

		object = RefCounted.new()
		object.set_script( gdscript )

	return object.execute.callv( args )
