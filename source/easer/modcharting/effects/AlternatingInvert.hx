package easer.modcharting.effects;

import easer.modcharting.ModchartLib;
import easer.modcharting.BasicEffect;
import modchart.ModIDs;

import modchart.Manager;

class AlternatingInvert extends BasicEffect {
	public function new(manager:Manager, params:Dynamic):Void {
		super(manager, params);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.queueEase(ModIDs.INVERT, this.flip(1.0));
			});
		});
		this.destroy();
	}
}
