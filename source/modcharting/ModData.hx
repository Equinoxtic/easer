package modcharting;

class ModData {	
	public var name:String = "";
	public var length:Float = 1.0;
	public var value:Float = 0.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var player:Int = -1;
	public function new(name:String, length:Float, value:Float, ease:Float->Float, ?player:Null<Int> = -1) {
		this.name = name;
		this.length = length;
		this.value = value;
		this.ease = ease;
		this.player = player;
	}
}
