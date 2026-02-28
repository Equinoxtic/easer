package;

import lib.Tween;
import flixel.text.FlxTextAlign;
import ui.GhostTappingStateText;
import ui.system.WindowHandler;

var invertShader:CustomShader;
var lensDistortionShader:CustomShader;
var bokehShader:CustomShader;

var windowSizeTween:Tween;
var lensDistortionTween:Tween;

var windowHandler:WindowHandler;

final DEFAULT_LENS_DISTORT_INTENSITY:Float = 0.015;
final DEFAULT_LENS_DISTORT_AREA:Float = -0.2;
final DEFAULT_LENS_DISTORT_OFFSET:Float = 0.03;

var savedLensDistortIntensity:Float;
var savedLensDistortArea:Float;
var savedLensDistortOffset:Float;

var shadersEnabled:Bool = Options.gameplayShaders;

var playerCameraShake:Bool = false;
var opponentCameraShake:Bool = false;

var shakeMap:Map<String, { camera:String, intensity:Float, duration:Float, active:Bool }> = [];

final TARGET_CAMERAS:Map<String, FlxCamera> = [
	'camGame'	=> camGame,
	'camHUD'	=> camHUD
];

function create():Void {
	windowHandler = new WindowHandler();
	if (shadersEnabled) {
		invertShader = new CustomShader('invertColor');
		invertShader.intensity = 1.0;
		lensDistortionShader = new CustomShader('lensDistortion');
		bokehShader = new CustomShader('bokeh');
		bokehShader.radius = 0.0;
		bokehShader.amount = 0.0;
		resetLensDistortion(false);
		addShadersToCameras([camGame, camHUD], [lensDistortionShader]);
		addShadersToCameras([camGame], [bokehShader]);
	}
}

function update(elapsed:Float):Void {
	windowHandler.update();
}

function onNoteHit(e:NoteHitEvent):Void { shakeCamFor(e.character); }

function onEvent(event):Void {
	var curEvent = event.event;
	switch (curEvent.name) {
		case 'Invert Color':
			var parameters:Dynamic = {
				enabled: curEvent.params[0]
			};
			if (parameters.enabled && shadersEnabled) {
				camGame.addShader(invertShader);
			} else {
				camGame.removeShader(invertShader);
			}
		case 'Tween Lens Distortion':
			var parameters:Dynamic = {
				intensity:				curEvent.params[0],
				area:					curEvent.params[1],
				offset:					curEvent.params[2],
				duration:				curEvent.params[3],
				ease:					curEvent.params[4],
				tweenType:				curEvent.params[5]
			};
			savedLensDistortIntensity = parameters.intensity;
			savedLensDistortArea = parameters.area;
			savedLensDistortOffset = parameters.offset;
			tweenLensDistortion(parameters.intensity, parameters.area, parameters.offset, parameters.duration, parameters.ease, parameters.tweenType);
		case 'Set Lens Distortion':
			var parameters:Dynamic = {
				intensity:				curEvent.params[0],
				area:					curEvent.params[1],
				offset:					curEvent.params[2]
			};
			savedLensDistortIntensity = parameters.intensity;
			savedLensDistortArea = parameters.area;
			savedLensDistortOffset = parameters.offset;
			setLensDistortion(parameters.intensity, parameters.area, parameters.offset, 1.0);
		case 'Pulse Lens Distortion':
			var parameters:Dynamic = {
				initialMultiplier:		curEvent.params[0],
				endMultiplier:			curEvent.params[1],
				duration:				curEvent.params[2]
			};
			var intensity:Float = savedLensDistortIntensity * parameters.endMultiplier;
			var area:Float = savedLensDistortArea * parameters.endMultiplier;
			var offset:Float = savedLensDistortOffset * parameters.endMultiplier;
			setLensDistortion(savedLensDistortIntensity, savedLensDistortArea, savedLensDistortOffset, parameters.initialMultiplier);
			tweenLensDistortion(intensity, area, offset, parameters.duration, "expo", "Out");
		case 'Tween Window Size':
			var parameters:Dynamic = {
				width:					curEvent.params[0],
				height:					curEvent.params[1],
				duration:				curEvent.params[2],
				ease:					curEvent.params[3],
				tweenType:				curEvent.params[4]
			};
			windowHandler.tweenedResize(parameters.width, parameters.height, parameters.duration, parameters.ease, parameters.tweenType);
		case 'Tween Window Position':
			var parameters:Dynamic = {
				x:						curEvent.params[0],
				y:						curEvent.params[1],
				duration:				curEvent.params[2],
				ease:					curEvent.params[3],
				tweenType:				curEvent.params[4]
			};
			windowHandler.active = false;
			windowHandler.tweenedPosition(parameters.x, parameters.y, parameters.duration, parameters.ease, parameters.tweenType);
		case 'Sine Wave Window':
			var parameters:Dynamic = {
				amplitude:				curEvent.params[0],
				frequency:				curEvent.params[1],
				xDampening:				curEvent.params[2],
				yDampening:				curEvent.params[3]
			};
			windowHandler.setSineWaveProperties(parameters.amplitude, parameters.frequency, parameters.xDampening, parameters.yDampening);
			windowHandler.setSineWaveState(true);
			windowHandler.active = true;
		case 'Toggle Ghost Tapping':
			ghostTapping = !curEvent.params[0];
			var text:FunkinText = new GhostTappingStateText();
			text.cameras = [camHUD];
			add(text);
		case 'Singing Shake Toggle':
			var parameters = {
				enabled:				curEvent.params[0],
				windowAffected:			curEvent.params[1],
				strumLine:				curEvent.params[2],
				targetCamera:			curEvent.params[3],
				intensity:				curEvent.params[4],
				duration:				curEvent.params[5]
			};
			shakeMap.set(strumLines.members[parameters.strumLine].characters[0].curCharacter, { 
				camera: parameters.targetCamera,
				intensity: parameters.intensity,
				duration: parameters.duration,
				active: parameters.enabled
			});
	}
}

function addShadersToCameras(cameraList:Array<FlxCamera>, shaderList:Array<CustomShader>):Void {
	for (camera in cameraList) {
		for (shader in shaderList) {
			camera.addShader(shader);
		}
	}
}

function shakeCamFor(character:Character):Void {
	if (shakeMap.get(character.curCharacter) == null)
		return;
	var data = shakeMap.get(character.curCharacter);
	if (!data.active)
		return;
	TARGET_CAMERAS.get(data.camera).shake(data.intensity, data.duration);
}

function setLensDistortion(?intensity:Null<Float> = 0.01, ?area:Null<Float> = -0.1, ?offset:Null<Float> = 0.025, ?multiplier:Null<Float> = 1.0):Void {
	if (!shadersEnabled) return;
	if (lensDistortionTween != null)
		lensDistortionTween.forceCancel();
	lensDistortionShader.intensity = intensity * multiplier;
	lensDistortionShader.area = area * multiplier;
	lensDistortionShader.offset = offset * multiplier;
}

function tweenLensDistortion(?intensity:Null<Float> = 0.01, ?area:Null<Float> = -0.1, ?offset:Null<Float> = 0.025, ?duration:Null<Float> = 1.0, ?ease:Null<String> = 'linear', ?tweenType:Null<String> = 'In'):Void {
	if (!shadersEnabled) return;
	lensDistortionTween = new Tween(lensDistortionShader, {
		intensity: intensity,
		area: area,
		offset: offset
	}, duration, ease, tweenType).play();
}

function resetLensDistortion(removeShader:Bool = false):Void {
	if (!shadersEnabled) return;
	lensDistortionShader.intensity = 0;
	lensDistortionShader.offset = 0;
	lensDistortionShader.area = 0;
}
