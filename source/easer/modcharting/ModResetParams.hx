package easer.modcharting;

class ModResetParams {
	public var modifiers:Array<String> = [];
	public var beat:Int = 0;
	public var length:Float = 1.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var player:Int = -1;
	/**
		Creates parameters to set each modifier back to its `0.0` value with given duration and ease at a certain beat.
		@param modifiers The list of modifiers to be reset
		@param beat The beat of when the modifiers should be reset
		@param length The length of the modifier's tween
		@param ease The ease of the modifier's tween
		@param player The field/player that is affected by the reset
	**/
	public function new(modifiers:Array<String>, beat:Int, length:Float, ease:Float->Float, player:Int = -1) {
		this.modifiers = modifiers;
		this.beat = beat;
		this.length = length;
		this.ease = ease;
		this.player = (player != null) ? player : -1;
	}
}

