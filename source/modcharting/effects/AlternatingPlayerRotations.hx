package modcharting.effects;

import Constants;

import modcharting.BasicEffect;
import modcharting.ModIDs;

import modchart.Manager;

class AlternatingPlayerRotations extends BasicEffect {
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		setupReverse(this.beatRange[0]);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				var value:Float = (!this.inverse) ? 180.0 : 0;
				this.manager.ease('centerRotateX', beat, this.duration, value, this.ease);
			});
		});
		this.destroy();
	}
	
	private function setupReverse(beat:Int):Void {
		this.manager.ease(ModIDs.REVERSE, beat, this.duration, 1.0, this.ease, (!this.inverse) ? Constants.OPPONENT_ID : Constants.PLAYER_ID);
	}
}
