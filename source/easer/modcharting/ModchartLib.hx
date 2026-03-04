package easer.modcharting;

import easer.modcharting.ModResetParams;
import easer.modcharting.ModData;
import easer.modcharting.ModResetParams;
import easer.modcharting.ModIDs;

import modchart.Manager;

class ModchartLib {
	/**
		Quickly queue a list of modifiers at a specific beat with given parameters.
		@param manager The instance of the modchart manager
		@param beat When should the modifiers be set/eased
		@param list The list of modifiers to be set/eased
		@return `Manager`
	**/
	public static function queueForBeat(manager:Manager, beat:Float, list:Array<{modifiers:Array<String>, value:Float, length:Float, ease:Float->Float, player:Int}>):Manager {
		for (params in list) {
			for (mod in params.modifiers) {
				if (params.length != null && params.ease != null)
					manager.ease(mod, beat, params.length, params.value, params.ease, params.player);
				else
					manager.set(mod, beat, params.value, params.player);
			}
		}
		return manager;
	}
	
	/**
		## DEPRECATED / LEGACY FUNCTION! Use `queueModsForBeat` instead.
		Quickly set a list of modifiers at a specific beat.
		@param manager The instance of the modchart manager
		@param beat When should the modifiers be set
		@param mods The list of modifiers to be set
	**/
	public static function setModsOnBeat(manager:Manager, beat:Int, mods:Array<ModData>):Array<ModData> {
		for (mod in mods) {
			manager.set(mod.name, beat, mod.value, mod.player);
		}
		return mods;
	}
	
	/**
		## DEPRECATED / LEGACY FUNCTION! Use `queueModsForBeat` instead.
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
		Quickly queue a reset of a list of modifiers with their consecutive beats and given parameters.
		@param manager The instance of the modchart manager
		@param list The list of modifiers to be reset
		@return `Any`
	**/
	public static function queueReset(manager:Manager, list:Array<{modifiers:Array<String>, beat:Float, length:Float, ease:Float->Float, player:Int}>):Manager {
		for (params in list) {
			for (mod in params.modifiers) {
				if (params.ease != null && params.length != null)
					manager.ease(mod, params.beat, params.length, evalAlpha(mod), params.ease, params.player);
				else
					manager.set(mod, params.beat, evalAlpha(mod), params.player);
			}
		}
		return manager;
	}
	
	/**
		## DEPRECATED / LEGACY FUNCTION! Use `queueReset` instead.
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
	
	private static inline function evalAlpha(modName:String):Float
		return (modName == ModIDs.ALPHA) ? 1.0 : 0.0;
}
