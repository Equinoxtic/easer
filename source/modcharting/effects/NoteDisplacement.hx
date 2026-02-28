package modcharting.effects;

import modcharting.ModIDs;
import modcharting.ModIDs;

import modcharting.BasicEffect;

class NoteDisplacement extends BasicEffect {
	private final STRUM_DATA:Map<Int, Dynamic> = [
		0 => {	x: -1.0,	y: 1.0	},
		1 => {	x: -0.5,	y: -1.0	},
		2 => {	x: 0.5,		y: 1.0	},
		3 => {	x: 1.0,		y: -1.0	}
	];
	private final X_OFFSET_KEY:String = 'x';
	private final Y_OFFSET_KEY:String = 'y';
	private final OFFSET:Float = 30;
	private final TORNADO_VALUE:Float = 0.7;
	private var offsetValue:Float = 0;
	private var tornadoEnabled:Bool = false;
	private var alternate:Bool = false;
	private var trueInverse:Bool = false;
	
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		this.tornadoEnabled = params.tornadoEnabled;
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.spaceOut();
				this.tornadoPulse();
				this.alternate = !this.alternate;
			});
			this.perModOfBeat(beat, (this.modulus * 2), (beat:Int) -> this.trueInverse = !this.trueInverse);
		});
		this.destroy();
	}
	
	public function spaceOut():Void {
		for (note => values in this.STRUM_DATA) {
			if (!this.alternate)
				this.easeOffset(this.X_OFFSET_KEY, note, values.x);
			else
				this.easeOffset(this.Y_OFFSET_KEY, note, values.y);
		}
	}
	
	public inline function tornadoPulse():Void
		if (this.tornadoEnabled) this.pulse(ModIDs.TORNADO, this.invert(this.TORNADO_VALUE * this.value));
	
	private inline function easeOffset(targetOffset:String, note:Int, v:Float):Void
		this.pulse(targetOffset + Std.string(note), this.calculateValue((!this.trueInverse) ? v : -v));
	
	private inline function calculateValue(v:Float):Float
		return v * this.OFFSET * this.value;
}
