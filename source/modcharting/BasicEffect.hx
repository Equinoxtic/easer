package modcharting;

import modchart.Manager;

/**
	The basic class for all the effects used for modcharting.
**/
class BasicEffect {
	public var manager:Manager;
	
	public var parameters:Dynamic;
	
	public var beatRange:Array<Int> = [0, 0];
	public var modulus:Int = 4;
	public var duration:Float = 1.0;
	public var value:Float = 0.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var inverse:Bool = false;
	public var player:Int = -1;
	
	public var beat:Int = 0;
	
	/**
		Create a new custom modchart effect.
		@param manager The manager instance for modcharts
		@param params The parameters used to control the effect
	**/
	public function new(manager:Manager, params:Dynamic) {
		if (manager == null) return;
		this.manager = manager;
		this.parameters = params;
		this.beatRange = params.beatRange;
		this.modulus = params.modulus;
		this.duration = params.length;
		this.value = params.value;
		this.ease = params.ease;
		this.inverse = params.inverse;
		this.player = params.player;
	}
	
	/**
		Fires multiple callbacks within the beat range.
	**/
	public function onBeat(?func:Null<(beat:Int)->Void>):Void {
		if (func == null) return;
		for (beat in this.iterateBeatRange()) {
			func(beat);
		}
	}
	
	/**
		Fires a callback upon `beat mod n`. The `modulus` parameter of the effect will be used if the `mod` argument is either `null` or `0`. This also calls `!effect.inverse` which will allow — if `inverse` is referenced within a custom effect — to auto-inverse the values of it.
		@param beat The beat for when the callback should fire
		@param mod The *modulus* of the beat [Default: 4]
		@param func The callback to be fired
	**/
	public function perModOfBeat(beat:Int, ?mod:Null<Int> = 4, ?func:Null<(beat:Int)->Void>):Void {
		if (this.getModulo(beat, (mod != null && mod > 0) ? mod : this.modulus)) {
			this.beat = beat;
			func(this.beat);
			this.inverse = !this.inverse;
		}
	}
	
	/**
		Iterates through the range of beats of the effect.
		@returns IntIterator
	**/
	private function iterateBeatRange():IntIterator {
		return (this.beatRange[0]...(this.beatRange[1] + 1));
	}
	
	private function getModulo(beat:Int, ?mod:Null<Int> = 4):Int {
		return ((beat % mod) == 0);
	}
}
