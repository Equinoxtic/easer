package lib;

class Tween {
	public var localized:FlxTween;
	
	public var object:Dynamic = null;
	public var values:Dynamic = null;
	public var duration:Float = 4.0;
	public var startDelay:Float = 0.0;
	public var ease:String = 'linear';
	public var tweenType:String = 'Out';
	
	public function new(object:Dynamic, values:Dynamic, duration:Dynamic, ease:String, tweenType:String, ?startDelay:Null<Float> = 1.0) {
		if (object == null || values == null)
			return;
		this.object = object;
		this.values = values;
		this.duration = (duration != null) ? duration : this.duration;
		this.ease = (ease != null && ease.length > 0) ? ease : this.ease;
		this.tweenType = (tweenType != null && tweenType.length > 0) ? tweenType : this.tweenType;
		this.startDelay = (startDelay != null) ? startDelay : this.startDelay;
	}
	
	public function play():Tween {
		this.forceCancel();
		this.localized = this.make();
		return this;
	}
	
	public function forceCancel():Void {
		if (this.localized == null)
			return;
		this.localized.cancel();
	}
	
	public function setState(state:Bool):Void {
		if (this.localized == null)
			return;
		this.localized.active = state;
	}
	
	public function destroy():Void {
		if (this.localized != null)
			this.localized.destroy();
		this = null;
	}
	
	private function make():FlxTween {
		var twn:FlxTween = FlxTween.tween(this.object, this.values, (Conductor.stepCrochet / 1000) * this.duration, { ease: CoolUtil.flxeaseFromString(ease, tweenType), startDelay: this.startDelay, onComplete: (_) -> this.localized = null});
		// this.manager.push(twn);
		return twn;
	}
}
