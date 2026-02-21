package modcharting.effects;

import modcharting.BasicEffect;

class NoteOffsetPulse extends BasicEffect {
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				
			});
		});
	}
}
