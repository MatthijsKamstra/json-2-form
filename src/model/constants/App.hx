package model.constants;

import haxe.macro.Context;

class App {
	public static inline var URL:String = "https://";

	public static var NAME:String = "[json-2-form]";

	public static inline macro function getBuildDate() {
		#if !display
		var date = Date.now().toString();
		return macro $v{date};
		#else
		var date = Date.now().toString();
		return macro $v{date};
		#end
	}
}
