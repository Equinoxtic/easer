package easer.modcharting.effects;

import easer.modcharting.BasicEffect;
import easer.modcharting.ModIDs;

class RandomizedNoteGrow extends BasicEffect {
	private final POSSIBLE_LANE_COMBINATIONS:Array<Array<Int>> = [
		[1, 0, 3, 2],
		[0, 3, 1, 2],
		[3, 2, 0, 1],
		[2, 1, 3, 0]
	];
	private var position:Int = 0;
	
	public function new(manager:Manager, params:Dynamic) {
		super(manager, params);
		var laneSet:Array<Int> = this.POSSIBLE_LANE_COMBINATIONS[FlxG.random.int(0, this.POSSIBLE_LANE_COMBINATIONS.length - 1)];
		this.manager.set('scale', params.startingScaleBeat, 0.0);
		this.onFloatBeats((beat:Float, interval:Float, section:Any) -> {
			var lane = laneSet[position];
			switch(beat) {
				case section.start:
					this.queueSet(ModIDs.ZOOM, 1.0);
				case section.end:
					this.manager.ease(ModIDs.ZOOM, section.end, 2.0, 0.0, FlxEase.expoInOut);
			}
			this.queueEase('scale' + Std.string(lane), 1.0 * this.value, 1.0);
			if (position >= laneSet.length)
				position = laneSet.length;
			position++;
		});
		this.destroy();
	}
}
