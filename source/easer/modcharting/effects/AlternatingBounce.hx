package easer.modcharting.effects;

import easer.modcharting.ModchartLib;
import easer.modcharting.BasicEffect;

import modchart.Manager;

class AlternatingBounce extends BasicEffect {
	public function new(manager:Manager, params:Dynamic):Void {
		super(manager, params);
		this.manager.setPercent('bounceSpeed', this.parameters.speed);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.queueEase('bounceX');
			});
		});
		this.manager.ease('bounceX', this.beatRange[1], 1.5, 0.0, this.ease, this.player);
		this.destroy();
	}
}
