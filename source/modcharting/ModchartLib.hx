package modcharting;

import modcharting.ModResetParams;
import modcharting.ModData;
import modcharting.ModResetParams;
import modcharting.ModIDs;

import modchart.Manager;

class ModchartLib {
	
	/***
		
	**/
	public static function setModsOnBeat(manager:Manager, beat:Int, mods:Array<ModData>):Array<ModData> {
		for (mod in mods) {
			manager.set(mod.name, beat, mod.value, mod.player);
		}
		return mods;
	}
	
	/**
		Quickly ease a list of modifiers at a specific beat.
		@param manager The instance of the modchart manager
		@param beat When should the modifiers be eased
		@param mods The list of modifiers to be eased
	**/
	public static function easeModsOnBeat(manager:Manager, beat:Int, mods:Array<ModData>):Array<ModData> {
		for (mod in mods) {
			manager.ease(mod.name, beat, mod.length, mod.value, mod.ease, mod.player);
		}
		return mods;
	}
	
	/**
		Sets each modifiers value back to `0.0` at specific beats within a list of the given parameters with easing.
		@param manager The instance of the modchart manager
		@param parametersList The parameters of each modifier to be reset
	**/
	public static function queueEasedModReset(manager:Manager, parametersList:Array<ModResetParams>):Array<ModResetParams> {
		if (parametersList == null || parametersList.length <= 0)
			return;
		for (parameters in parametersList) {
			for (mod in parameters.modifiers) {
				manager.ease(mod, parameters.beat, parameters.length, evalAlpha(mod), parameters.ease, parameters.player);
			}
		}
		return parametersList;
	}
	
	private static function evalAlpha(modName:String):Float {
		return (modName == ModIDs.ALPHA) ? 1.0 : 0.0;
	}
}
