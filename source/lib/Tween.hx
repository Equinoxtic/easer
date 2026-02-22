package lib;

// import lib.TweenManager;

class Tween {
	public var localized:FlxTween;
	
	public var object:Dynamic;
	public var values:Dynamic;
	public var duration:Float = 4.0;
	public var startDelay:Float = 0.0;
	public var ease:String = 'linear';
	public var tweenType:String = 'Out';
	
	// public var manager:TweenManager;
	
	public function new(object:Dynamic, values:Dynamic, duration:Dynamic, ease:String, tweenType:String, ?startDelay:Null<Float> = 1.0) {
		if (object == null || values == null)
			return;
		
		// this.manager = new TweenManager();
		
		this.object = object;
		this.values = values;
		this.duration = (duration != null) ? duration : this.duration;
		this.ease = (ease != null && ease.length > 0) ? ease : this.ease;
		this.tweenType = (tweenType != null && tweenType.length > 0) ? tweenType : this.tweenType;
		this.startDelay = (startDelay != null) ? startDelay : this.startDelay;
		
		// this.manager.tweens.push(this);
	}
	
	public function play():Tween {
		this.forceCancel();
		this.localized = this.make();
		return this;
	}
	
	public function forceCancel():Void {
		if (this.localized != null)
			this.localized.cancel();
	}
	
	public function setState(state:Bool):Void {
		this.localized.active = state;
	}
	
	private function make():FlxTween {
		return FlxTween.tween(this.object, this.values, (Conductor.stepCrochet / 1000) * this.duration, { ease: CoolUtil.flxeaseFromString(ease, tweenType), startDelay: this.startDelay, onComplete: (_) -> this.localized = null});
	}
}
