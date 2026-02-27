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
	
	public function tornadoPulse():Void {
		if (!this.tornadoEnabled) return;
		this.manager.set(ModIDs.TORNADO, this.beat, ((!this.inverse) ? this.TORNADO_VALUE : -this.TORNADO_VALUE) * this.value, this.player);
		this.manager.ease(ModIDs.TORNADO, this.beat, this.duration, 0.0, this.ease, this.player);
	}
	
	public function spaceOut():Void {
		for (note => values in this.STRUM_DATA) {
			if (!this.alternate)
				this.easeOffset(this.X_OFFSET_KEY, note, values.x);
			else
				this.easeOffset(this.Y_OFFSET_KEY, note, values.y);
		}
	}
	
	private function easeOffset(?targetOffset:Null<String> = 'x', ?note:Null<Int> = 0, ?v:Null<Float> = 1.0):Void {
		var targetNote:String = targetOffset + Std.string(note);
		this.manager.set(targetNote, this.beat, this.calculateValue((!this.trueInverse) ? v : -v), this.player);
		this.manager.ease(targetNote, this.beat, this.duration, 0.0, this.ease, this.player);
	}
	
	private function calculateValue(?v:Null<Float> = 1.0):Float {
		return v * this.OFFSET * this.value;
	}
}
