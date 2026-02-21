package modcharting.effects;

import modcharting.ModIDs;

import modcharting.BasicEffect;

class ContinuousSwapping extends BasicEffect {
	private final SWAP_DATA:Array<Int> = [ 0.5, 1.0, 0.5, 0.0 ];
	private final MAX_POS:Int = 3;
	private var pos:Int = 0;
	
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		this.onBeat((beat:Int) -> {
			this.perModOfBeat(beat, null, (beat:Int) -> {
				this.manager.ease(ModIDs.OPPONENTSWAP, beat, this.duration, SWAP_DATA[pos] * this.value, this.ease, this.player);
				// 0.5 -> 1.0 -> 0.5 -> 0.0 (loops all over again as expected)
				this.pos++;
				if (this.pos > this.MAX_POS) this.pos = 0;
			});
		});
	}
}
