package modcharting;

class ModResetParams {
	public var modifiers:Array<String> = [];
	public var beat:Int = 0;
	public var length:Float = 1.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var player:Int = -1;
	public function new(modifiers:Array<String>, beat:Int, length:Float, ease:Float->Float, ?player:Null<Int> = -1) {
		this.modifiers = modifiers;
		this.beat = beat;
		this.length = length;
		this.ease = ease;
		this.player = player;
	}
}

