package modcharting.effects;

import Constants;

import modcharting.BasicEffect;
import modcharting.ModIDs;

import modchart.Manager;

class AlternatingPlayerRotations extends BasicEffect {
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		setupReverse();
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.queueEase('centerRotateX', this.flip(180.0));
			});
		});
		this.destroy();
	}
	
	private inline function setupReverse():Void
		this.manager.set(ModIDs.REVERSE, this.beatRange[0], 1.0, Constants.OPPONENT_ID);
}
