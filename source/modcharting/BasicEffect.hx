package modcharting;

import modchart.Manager;

/**
	The basic class for all the effects used for modcharting.
**/
class BasicEffect {
	public var manager:Manager;
	
	public var parameters:Dynamic;
	
	public var beatRange:Array<Int> = [ 0, 0 ];
	public var iBeatRange:{min:Float, max:Float, interval:Float} = {min: 0.0, max: 0.0, interval: 0.0};
	public var modulus:Int = 4;
	public var duration:Float = 1.0;
	public var value:Float = 0.0;
	public var ease:Float->Float = FlxEase.expoOut;
	public var inverse:Bool = false;
	public var player:Int = -1;
	
	public var beat:Float = 0;
	
	private var callbacks:Array<Dynamic> = [];
	
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
		this.iBeatRange = params.iBeatRange;
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
	public function onBeat(func:(beat:Int)->Void):Void {
		if (func == null) return;
		for (beat in this.iterateBeatRange()) {
			func(beat);
		}
	}
	
	/**
		Fires multiple callbacks within a beat range of floats with intervals.
		- This does not and SHOULD NOT make use of a modulo, as modulos in programming cannot discern if the output is a decimal or not.
		- This is used for much more controlled scenarios for faster beats.
	**/
	public function onIBeats(func:(beat:Float, interval:Float)->Void):Void {
		if (func == null) return;
		var beat:Float = this.iBeatRange.min;
		while (beat <= this.iBeatRange.max) {
			this.beat = beat;
			func(this.beat, this.iBeatRange.interval);
			beat += this.iBeatRange.interval;
		}
	}
	
	/**
		Fires a callback upon `beat mod n`. The `modulus` parameter of the effect will be used if the `mod` argument is either `null` or `0`. This also calls `!effect.inverse` which will allow — if `inverse` is referenced within a custom effect — to auto-inverse the values of it.
		@param beat The beat for when the callback should fire
		@param mod The *modulus* of the beat [Default: 4]
		@param func The callback to be fired
	**/
	public function perModOfBeat(beat:Int, mod:Int = 4, func:(beat:Int)->Void):Void {
		if (this.getModulo(beat, (mod != null && mod > 0) ? mod : this.modulus)) {
			this.beat = beat;
			func(Math.floor(this.beat));
			this.inverse = !this.inverse;
		}
	}
	
	public inline function queueSet(name:String, value:Float = 1.0):Void
		this.manager.set(name, this.beat, (value != null) ? value : this.invert(this.value), this.player);
	
	public inline function queueEase(name:String, value:Float = 1.0, lifetime:Float = 1.0):Void
		this.manager.ease(name, this.beat, this.calculateDuration(this.duration, lifetime), (value != null) ? value : this.invert(this.value), this.ease, this.player);
	
	public function pulse(name:String, value:Float = 1.0, lifetime:Float = 1.0):Void {
		this.queueSet(name, value);
		this.queueEase(name, 0.0, lifetime);
	}
	
	public inline function invert(value:Float):Float
		return (this.inverse) ? -value : value;
	
	public inline function flip(value:Float):Float
		return (this.inverse) ? 0.0 : value;
	
	public inline function calculateDuration(duration:Float, multiplier:Float):Float
		return (duration * ((multiplier != null) ? multiplier : 1));
	
	public function destroy():Void {
		this.manager = null;
		if (this.parameters != null)
			this.parameters = null;
		// for (f in callbacks)
		// 	f = null;
		this = null;
	}
	
	/**
		Iterates through the range of beats of the effect.
		@returns IntIterator
	**/
	private inline function iterateBeatRange():IntIterator
		return (this.beatRange[0]...(this.beatRange[1] + 1));
	
	/**
		Gets `n mod beat`.
	**/
	private inline function getModulo(beat:Int, mod:Int = 4):Int
		return ((beat % mod) == 0);
}
