class_name DynamicFunction extends RefCounted

var arg_names:Array[String]
var statement:String
var object:Variant

func _init( _arg_names:Array[String], _statement:String ):
	arg_names = _arg_names
	statement = _statement

func execute( args:Array=[] ):
	if not object:
		var source = "extends RefCounted\nfunc execute(%s):\n" % [",".join(arg_names)]
		for arg_name in arg_names:
			source += "  %s = %s\n" % [arg_name,arg_name]  # avoid unused parameter warnings

		var gdscript = GDScript.new()
		gdscript.source_code = source
		gdscript.source_code = "%s  %s\n" % [source,statement]
		gdscript.reload()

		object = RefCounted.new()
		object.set_script( gdscript )

	return object.execute.callv( args )
