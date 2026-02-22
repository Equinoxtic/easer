package modcharting.effects;

import modcharting.ModchartLib;
import modcharting.BasicEffect;

import modchart.Manager;

class AlternatingBounce extends BasicEffect {
	public function new(manager:Manager, params:Dynamic):Void {
		super(manager, params);
		this.manager.setPercent('bounceSpeed', this.parameters.speed);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.manager.ease('bounceX', beat, this.duration, (!this.inverse) ? this.value : -this.value, this.ease, this.player);
			});
		});
		this.manager.ease('bounceX', this.beatRange[1], 1.5, 0.0, this.ease, this.player);
		this.destroy();
	}
}
