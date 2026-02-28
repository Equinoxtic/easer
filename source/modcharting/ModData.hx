package modcharting;

import flixel.tweens.FlxEase;

class ModData {	
	public var name:String = "";
	public var length:Float = 1.0;
	public var value:Float = 0.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var player:Int = -1;
	/**
		Create a dataset for a modifier. (Does not include `beats` as a parameter since this is meant to be used for the `easeModsOnBeat()` method.)
		@param name The name of the modifier
		@param data The data for the given modifier; its tween duration, value, tween easing, and the target field/player
	**/
	public function new(name:String, data:{length:Float, value:Float, ease:Float->Float, player:Int}) {
		this.initialize(name, data.length, data.value, data.ease, data.player);
	}
	
	public function initialize(name:String, length:Float = 1.0, value:Float = 0.0, ease:Float->Float = FlxEase.expoOut, player:Int = -1):Void {
		this.name = name;
		this.length = (length != null) ? length : this.length;
		this.value = (value != null) ? value : this.value;
		this.ease = (ease != null) ? ease : this.ease;
		this.player = (player != null) ? player : this.player;
	}
}
