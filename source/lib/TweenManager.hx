package lib;

import lib.Tween;

class TweenManager {
	public var tweens:Array<Tween>;
	public function new() {}
	public function setStateForTweens(state:Bool):Void {
		for (tween in tweens)
			tween.setState(state);
	}
}
