# Easer

Easer is a framework/API with the purpose of making the process of creating modcharts easier; built on-top of [FunkinModchart](https://github.com/theoo-h/FunkinModchart/tree/main). This is only exclusive for [Codename Engine](https://github.com/CodenameCrew/CodenameEngine), and is mostly intended for [*softcoded* scripts (hscripts)](https://codename-engine.com/wiki/modding/scripting/).

## Prerequisites

1. Must have knowledge of modding in CNE.
2. Required knowledge of [NotITG](https://www.noti.tg/) modcharts AND FunkinModchart.
3. Basic/Intermediate knowledge of programming in Haxe.

## Code Sample

```hx
// Imports (Easer)
import easer.Constants;

import easer.modcharting.ModIDs;
import easer.modcharting.Registry;
import easer.modcharting.ModData;
import easer.modcharting.ModchartLib;

// Imports (FunkinModchart)
import modchart.Manager;

using Registry;
using ModchartLib;

var manager:Manager;

function postCreate():Void
{
	// Initialize manager (FunkinModchart)
	manager = new Manager();
	add(manager);
	
	/**
		Sample preset of mods that need to be registered. You're able to have a set list for specific songs.
		- P.S.: This system is getting reworked in the future — top priority =)
	**/
	Registry.MODS.subscribe(modcharter);

	// Apply modifiers (at beat 0).
	modcharter.queueForBeat(STARTING_BEAT, [
		{
			modifiers: [ ModIDs.DRUNK, ModIDs.TIPSY ],
			value: 0.4
		}
	]);

	// Apply NoteDisplacement Effect.
	new NoteDisplacement(modcharter, {
		iBeatRanges: [
			{ start: 0, end: 16, interval: 2 }
		],
		length: 5.0,
		value: 1.5,
		ease: FlxEase.expoOut,
		tornadoEnabled: false,
		inverse: false
	});
}
```

## Documentation

Documentation is available in the source code. However, it is advised you head to this repository's wiki for how to set up the API + more advanced implementations such as custom *effects* and *events*.
