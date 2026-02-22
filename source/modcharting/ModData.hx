package modcharting;

class ModData {	
	public var name:String = "";
	public var length:Float = 1.0;
	public var value:Float = 0.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var player:Int = -1;
	/**
		Create a dataset for a modifier. (Does not include `beats` as a parameter since this is meant to be used for the `easeModifiersAtBeat()` method.)
		@param name The name of the modifier
		@param length The length/duration of the modifier's tween
		@param value The value of the modifier
		@param ease The ease of the modifier's tween
		@param player The field/player tobe used for the modifier
	**/
	public function new(name:String, length:Float, value:Float, ease:Float->Float, ?player:Null<Int> = -1) {
		this.name = name;
		this.length = length;
		this.value = value;
		this.ease = ease;
		this.player = player;
	}
}
