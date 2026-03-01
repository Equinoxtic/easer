package easer.modcharting;

import easer.modcharting.ModIDs;

class Registry {
	public static final MODS:Map<String, Dynamic> = [
		ModIDs.TIPSY => {},
		ModIDs.DRUNK => {},
		ModIDs.BEAT => {},
		ModIDs.INVERT => {},
		ModIDs.OPPONENTSWAP => {},
		ModIDs.TRANSFORM => {},
		ModIDs.REVERSE => {},
		ModIDs.SPIRAL => {},
		ModIDs.BEAT => {},
		ModIDs.ROTATE => {},
		ModIDs.SCALE => {},
		ModIDs.ZOOM => {},
		ModIDs.BOUNCE => {},
		ModIDs.TORNADO => {},
		ModIDs.CENTERROTATE => {}
	];
	
	/**
		Registers a list of modifiers for a modchart manager.
		@param mods The list of modifiers to apply
		@param manager The manager instace for modcharts
		@returns `Map<String, Dynamic>`
	**/
	public static function subscribe(mods:Map<String, Dynamic>, manager:String):Map<String, Dynamic> {
		for (mod => data in mods) {
			manager.addModifier(mod);
			if (data.value != null) {
				var field:Int = (data.player != null) ? data.player : -1;
				manager.setPercent(mod, data.value, field);
			}
		}
		return mods;
	}
}
