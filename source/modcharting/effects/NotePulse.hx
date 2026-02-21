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
	}
	
	private function pulseDrunkTipsy():Void {
		var val:Float = (this.value + 1.0) * TIPSYDRUNK_DAMPENING_MULT;
		for (mod in ['Drunk', 'Tipsy']) {
			this.manager.set(mod, this.beat, (!this.inverse) ? val : -val, this.player);
			this.manager.ease(mod, this.beat, this.duration * TIPSYDRUNK_DURATION_MULT, 0.0, this.ease, this.player);
		}
	}
	
	private function pulseRotate():Void {
		this.manager.set(rotateKey, this.beat, (this.inverse) ? -this.angle : this.angle, this.player);
		this.manager.ease(rotateKey, this.beat, this.duration * ROTATION_DURATION_MULT, 0.0, this.ease, this.player);
	}
	
	private function pulseScale():Void {
		var indexA:Int = ((!this.inverse) ? 1 : 0);
		var indexB:Int = ((this.inverse) ? 1 : 0);
		this.pulseLanes(TARGET_STRUMLANES[indexA], 'X');
		this.pulseLanes(TARGET_STRUMLANES[indexA], 'Y', 0.0, 0.4);
		this.pulseLanes(TARGET_STRUMLANES[indexB], 'X', 0.0, -0.2);
		this.pulseLanes(TARGET_STRUMLANES[indexB], 'Y', 0.0, -0.4);
	}
	
	private function pulseLanes(lanes:Array<Int>, coordinate:String, ?add:Null<Float> = 0.0, ?mult:Null<Float> = 1.0):Void {
		for (lane in lanes) {
			final scaleKey = 'scale' + coordinate + Std.string(lane);
			this.manager.set(scaleKey, this.beat, (this.value + add) * mult, this.player);
			this.manager.ease(scaleKey, this.beat, this.duration, 0.0, this.ease, this.player);
		}
	}
}
