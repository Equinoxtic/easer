package ui;

import flixel.text.FlxTextAlign;
import lib.Tween;

class GhostTappingStateText extends FunkinText {
	public var alphaTween:Tween;
	public var sizeTween:Tween;
	
	public function new() {
		final stateKey:String = (PlayState.instance.ghostTapping) ? "enabled" : "disabled";
		super(0, 0, FlxG.width, "", 32, true);
		this.text = "GHOST TAPPING " + stateKey.toUpperCase();
		this.alignment = FlxTextAlign.CENTER;
		this.screenCenter();
		this.updateHitbox();
		this.borderSize = 3.0;
		this.tween();
	}
	
	private function tween():Void {
		alphaTween = new Tween(this, {alpha: 0}, 24, 'smootherStep', 'InOut', 0.5);
		sizeTween = new Tween(this.scale, {x: 2.0, y: 0.0}, 38, 'smootherStep', 'InOut', 0.1);
		alphaTween.play();
		sizeTween.play();
	}
}
