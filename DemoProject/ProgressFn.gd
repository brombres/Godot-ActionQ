class_name ProgressFn extends Node

## Find the named function and return it as a Callable.
## E.g. calling ProgressFn.find("Bouce In") returns ProgressFn.BOUNCE_IN
static func find( function_name:String )->Callable:
	function_name = function_name.to_snake_case().to_upper()
	return Callable( ProgressFn, function_name )

## Returns a list of callable progress function names in DEFINITION_CASE, e.g.
## ["BOUNCE","BOUNCE_IN","BOUNCE_OUT",...].
static func function_names()->Array[String]:
	var result:Array[String] = []
	for m in ProgressFn.new().get_method_list():
		if m.flags & MethodFlags.METHOD_FLAG_STATIC:
			if m.args.size() == 1 and m.args[0].name == "p":
				result.push_back( m.name )
	return result

## Returns a list of callable progress function names in Title Case, e.g.
## ["Bounce","Bounce In","Bounce Out",...].
static func title_case_function_names()->Array[String]:
	var result:Array[String] = []
	var names = function_names()
	for fn_name in names:
		var parts = fn_name.split( "_" )
		for i in range(parts.size()):
			parts[i] = parts[i].to_pascal_case()
		result.push_back( " ".join(parts) )
	return result

static func BACK(p:float)->float:
	if p < 0.5:
		return p * p * (7 * p - 2.5) * 2
	else:
		p -= 1
		return 1 + p * p * 2 * (7 * p + 2.5)

static func BACK_IN(p:float)->float:
	return p * p * (2.70158 * p - 1.70158)

static func BACK_OUT(p:float)->float:
	return (p-1) * (p-1) * (2.70158*(p-1) + 1.70158) + 1

static func BACK_EASY_OUT(p:float)->float:
	return 1 - ((1.0 - p) ** 2 - (1.0 - p)/1.25 * sin((1.0 - p) * PI))

static func BOUNCE(p:float)->float:
	if p < 0.5:
		return 8 * 2 ** (8 * (p - 1) ) * abs(sin( p * PI * 7 ))
	else:
		return 1 - 8 * 2 ** (-8 * p) * abs(sin( p * PI * 7 ))

static func BOUNCE_IN(p:float)->float:
	return 2 ** (6 * (p - 1)) * abs(sin( p * PI * 3.5 ))

static func BOUNCE_OUT(p:float)->float:
	return 1 - 2 ** (-6 * p) * abs(cos( p * PI * 3.5 ))

static func CIRCULAR(p:float)->float:
	if p < 0.5:
		return (1 - sqrt( 1 - 2 * p )) * 0.5
	else:
		return (1 + sqrt( 2 * p - 1 )) * 0.5

static func CIRCULAR_IN(p:float)->float:
	return 1 - sqrt( 1 - p )

static func CIRCULAR_OUT(p:float)->float:
	return sqrt( p )

static func CUBIC(p:float)->float:
	p *= 2
	if p < 1: return 0.5 * p * p * p
	p -= 2
	return 0.5 * (p * p *p + 2)

static func CUBIC_IN(p:float)->float:
	return p * p * p

static func CUBIC_OUT(p:float)->float:
	p -= 1
	return 1 + p * p * p

static func ELASTIC(p:float)->float:
	if p < 0.45:
		var p2 = p * p
		return 8 * p2 * p2 * sin( p * PI * 9 )
	elif p < 0.55:
		return 0.5 + 0.75 * sin( p * PI * 4 )
	else:
		var p2 = (p - 1) * (p - 1)
		return 1 - 8 * p2 * p2 * sin( p * PI * 9 )

static func ELASTIC_IN(p:float)->float:
	var p2 = p * p
	return p2 * p2 * sin( p * PI * 4.5 )

static func ELASTIC_OUT(p:float)->float:
	var p2 = (p - 1) * (p - 1)
	return 1 - p2 * p2 * cos( p * PI * 4.5 )

static func EXPONENTIAL(p:float)->float:
	if p < 0.5:
		return (2**(16 * p) - 1) / 510
	else:
		return 1 - 0.5 * 2 ** (-16 * (p - 0.5))

static func EXPONENTIAL_IN(p:float)->float:
	return (2**(8*p) - 1) / 255

static func EXPONENTIAL_OUT(p:float)->float:
	return 1 - 2**(-8*p)

static func LINEAR(p:float)->float:
	return p

static func QUADRATIC(p:float)->float:
	return 2*p*p if p<0.5 else 0.5 + (0.5-p) * (2*p-3)

static func QUADRATIC_IN(p:float)->float:
	return p * p

static func QUADRATIC_OUT(p:float)->float:
	return p * (2 - p)

static func QUARTIC(p:float)->float:
	if p < 0.5:
		p *= p
		return 8 * p * p
	else:
		p -= 1
		p *= p
		return 1 - 8 * p * p

static func QUARTIC_IN(p:float)->float:
	p *= p
	return p * p

static func QUARTIC_OUT(p:float)->float:
	p -= 1
	p *= p
	return 1 - p * p

static func QUINTIC(p:float)->float:
	if p < 0.5:
		var p2 = p * p
		return 16 * p * p2 * p2
	else:
		var p2 = (p - 1) * p
		return 1 + 16 * p * p2 * p2

static func QUINTIC_IN(p:float)->float:
	var p2 = p * p
	return p * p2 * p2

static func QUINTIC_OUT(p:float)->float:
	var p2 = (p - p) * p
	return 1 + p * p2 * p2

static func SINE(p:float)->float:
	return 0.5 * (1 + sin( 3.1415926 * (p - 0.5) ))

static func SINE_IN(p:float)->float:
	return sin( 1.5707963 * p )

static func SINE_OUT(p:float)->float:
	return 1 + sin( 1.5707963 * (p-1) )

static func SMOOTHSTEP(p:float)->float:
	return p * p * (3 - 2*p)

static func SMOOTHERSTEP(p:float)->float:
	return p * p * p * (p * (p * 6 - 15) + 10)

static func SNAPBOUNCE(p:float)->float:
	var exponent = -10 * p
	return (sin( -13 * (PI/2) * (p + 1))) * 2 ** exponent + 1

