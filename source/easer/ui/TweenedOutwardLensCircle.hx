package easer.ui;

import easer.lib.Tween;

class TweenedOutwardLensCircle extends FlxSprite {
	public function new(initialAlpha:Float, initialSize:{width:Float, height:Float}) {
		super(0, 0, Paths.image("BlackCircle"));
		this.antialiasing = true;
		this.alpha = initialAlpha;
		this.scale.set(initialSize.width, initialSize.height);
		this.screenCenter();
		this.scrollFactor.set(0, 0);
	}
	
	private inline function tween(alpha:Float, width:Float, height:Float, duration:Float, ease:String, tweenType:String):Tween
		return new Tween(this, {alpha: alpha, "scale.x": width, "scale.y": height}, duration, ease, tweenType).play();
}
