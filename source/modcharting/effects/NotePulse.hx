package modcharting.effects;

import modcharting.ModIDs;
import modcharting.BasicEffect;
import modcharting.ModchartLib;

import modchart.Manager;

class NotePulse extends BasicEffect {
	private final rotateKey:String = 'rotateY';
	
	private final TARGET_STRUMLANES:Array<Array<Int>> = [ [ 0, 2 ], [ 1, 3 ] ];
	
	private final TIPSYDRUNK_DAMPENING_MULT:Float = 0.8;
	private final TIPSYDRUNK_DURATION_MULT:Float = 0.5;
	private final ROTATION_DURATION_MULT:Float = 1.75;
	
	public var angle:Float = 0;
	
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		this.angle = this.parameters.angle;
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.pulseScale();
				this.pulseDrunkTipsy();
				this.pulseRotate();
			});
		});
		this.destroy();
	}
	
	private function pulseLanes(lanes:Array<Int>, coordinate:String, add:Float, mult:Float):Void {
		for (lane in lanes) {
			final scaleKey = 'scale' + coordinate + Std.string(lane);
			this.pulse(scaleKey, (this.value + add) * mult);
		}
	}
	
	private function pulseDrunkTipsy():Void {
		var val:Float = this.invert((this.value + 1.0) * TIPSYDRUNK_DAMPENING_MULT);
		for (mod in [ModIDs.DRUNK, ModIDs.TIPSY]) {
			this.pulse(mod, val, TIPSYDRUNK_DURATION_MULT);
		}
	}
	
	private function pulseScale():Void {
		var indexA:Int = ((!this.inverse) ? 1 : 0);
		var indexB:Int = ((this.inverse) ? 1 : 0);
		final PULSE_DATA:Array<{lane:Int, coordinate:String, add:Float, mult:Float}> = [
			{ lane: TARGET_STRUMLANES[indexA], coordinate: "X", add: 0.0, mult: 0.0 },
			{ lane: TARGET_STRUMLANES[indexA], coordinate: "Y", add: 0.0, mult: 0.4 },
			{ lane: TARGET_STRUMLANES[indexB], coordinate: "X", add: 0.0, mult: -0.2 },
			{ lane: TARGET_STRUMLANES[indexB], coordinate: "Y", add: 0.0, mult: -0.4 }
		];
		for (data in PULSE_DATA) {
			this.pulseLanes(data.lane, data.coordinate, data.add, data.mult);
		}
	}
	
	private inline function pulseRotate():Void
		this.pulse(rotateKey, this.invert(this.angle), ROTATION_DURATION_MULT);
}
