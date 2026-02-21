package modcharting;

import modcharting.ModIDs;

class Registry {
	public static final HJOIM_MODS:Map<String, Dynamic> = [
		ModIDs.TIPSY => {},
		ModIDs.DRUNK => {},
		ModIDs.BEAT => {},
		ModIDs.INVERT => {},
		ModIDs.OPPONENTSWAP => {},
		ModIDs.REVERSE => {},
		ModIDs.SPIRAL => {},
		ModIDs.BEAT => {},
		ModIDs.ROTATE => {},
		ModIDs.SCALE => {},
		ModIDs.ZOOM => {},
		ModIDs.BOUNCE => {},
		ModIDs.CENTERROTATE => {}
	];
	
	public static function subscribe(modMap:Map<String, Dynamic>, manager:String):Map<String, Dynamic> {
		for (mod => data in modMap) {
			manager.addModifier(mod);
		}
		return modMap;
	}
}
