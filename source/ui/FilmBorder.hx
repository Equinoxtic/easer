package ui;

import lib.Tween;

class FilmBorder extends FlxSprite {
	private var savedHeight:Float = 0.0;
	private var twn:Tween;
	
	private final MAXIMUM_SIZE:Float = 1.0;
	
	public function new() {
		super(0, 0, Paths.image("FilmBorder"));
		this.antialiasing = false;
		this.scale.set(FlxG.width * 8, 2.0);
		this.scrollFactor.set(0, 0);
		this.updateHitbox();
		this.screenCenter();
	}
	
	public function pulsate(height:Float, duration:Float, ease:String, tweenType:String):Void {
		this.savedHeight = this.scale.y;
		this.resize(this.scale.y + height);
		this.tween(savedHeight, duration, ease, tweenType);
	}
	
	public inline function resize(height:Float):Void
		this.scale.set(this.scale.x, height);
	
	public inline function tween(height:Float, duration:Float, ease:String, tweenType:String):Void
		this.twn = new Tween(this.scale, {y: height}, duration, ease, tweenType).play();
}
