package modcharting;

import modcharting.ModData;
import modcharting.ModResetParams;

import modchart.Manager;

class ModchartLib {
	/**
		Quickly ease a list of modifiers at a specific beat.
		@param manager The instance of the modchart manager
		@param beat When should the modifiers be eased
		@param modifierList The list of modifiers to be eased
	**/
	public static function easeModifiersAtBeat(manager:Manager, beat:Int, modifierList:Array<ModData>):Manager {
		for (mod in modifierList) {
			manager.ease(mod.name, beat, mod.length, mod.value, mod.ease, mod.player);
		}
		return manager;
	}
	
	/**
		Sets each modifiers value back to `0.0` at specific beats within a list of the given parameters.
		@param manager The instance of the modchart manager
		@param paramsArray The parameters of each modifier to be reset
	**/
	public static function resetModifiers(manager:Manager, paramsArray:Array<ModResetParams>):Manager {
		if (paramsArray == null || paramsArray.length <= 0)
			return;
		for (params in paramsArray) {
			for (mod in params.modifiers) {
				var val:Float = 0.0;
				if (mod.toLowerCase() == 'alpha')
					val = 1.0;
				manager.ease(mod, params.beat, params.length, val, params.ease);
			}
		}
		return manager;
	}
}
