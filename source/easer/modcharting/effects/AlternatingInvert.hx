package easer.modcharting.effects;

import easer.modcharting.ModchartLib;
import easer.modcharting.BasicEffect;
import modchart.ModIDs;

import modchart.Manager;

class AlternatingInvert extends BasicEffect {
	public function new(manager:Manager, params:Dynamic):Void {
		super(manager, params);
		this.onIntBeats((beat:Int, section:Any) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.queueEase(ModIDs.INVERT, this.flip(this.value));
			});
		});
		this.destroy();
	}
}
