package easer.lib;

import Sys;

/**
	A generalized class for the calculations of creating `sin` and `cos` waves.
**/
class Wave {
	public static inline function create(frequency:Float):Float
		return (2 * Math.PI * frequency * ((Conductor.stepCrochet / 1000) * Sys.time()));
}
