package lib;

import lib.Tween;

class TweenManager {
	public static var tweens:Array<Tween>;
	public static function setStateForTweens(state:Bool):Void {
		for (tween in tweens)
			tween.setState(state);
	}
}
