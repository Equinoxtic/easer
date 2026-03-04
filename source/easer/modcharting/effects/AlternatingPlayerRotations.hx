package easer.modcharting.effects;

import easer.Constants;

import easer.modcharting.BasicEffect;
import easer.modcharting.ModIDs;

import modchart.Manager;

class AlternatingPlayerRotations extends BasicEffect {
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		this.onIntBeats((beat:Int, section:Any) -> {
			this.manager.set(ModIDs.REVERSE, section.start, 1.0, Constants.OPPONENT_ID);
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.queueEase('centerRotateX', this.flip(180.0));
			});
		});
		this.destroy();
	}
}
