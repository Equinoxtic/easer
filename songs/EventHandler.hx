package;

import lib.Tween;
import flixel.text.FlxTextAlign;
import ui.GhostTappingStateText;
import ui.system.WindowHandler;

var invertShader:CustomShader;
var lensDistortionShader:CustomShader;

var windowSizeTween:Tween;
var lensDistortionTween:Tween;

var windowHandler:WindowHandler;

final DEFAULT_LENS_DISTORT_INTENSITY:Float = 0.015;
final DEFAULT_LENS_DISTORT_AREA:Float = -0.2;
final DEFAULT_LENS_DISTORT_OFFSET:Float = 0.03;

var savedLensDistortIntensity:Float;
var savedLensDistortArea:Float;
var savedLensDistortOffset:Float;

function create():Void {
	windowHandler = new WindowHandler();
	invertShader = new CustomShader('invertColor');
	invertShader.intensity = 1.0;
	lensDistortionShader = new CustomShader('lensDistortion');
	resetLensDistortion(false);
	camGame.addShader(lensDistortionShader);
	camHUD.addShader(lensDistortionShader);
}

function update(elapsed:Float):Void {
	windowHandler.update();
}

function onEvent(event):Void {
	var curEvent = event.event;
	switch (curEvent.name) {
		case 'Invert Color':
			var parameters:Dynamic = {
				enabled: curEvent.params[0]
			};
			if (parameters.enabled) {
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
			lensDistortionTween = new Tween(lensDistortionShader, {
				intensity: parameters.intensity,
				area: parameters.area,
				offset: parameters.offset
			}, parameters.duration, parameters.ease, parameters.tweenType);
			lensDistortionTween.play();
			savedLensDistortIntensity = parameters.intensity;
			savedLensDistortArea = parameters.area;
			savedLensDistortOffset = parameters.offset;
			tweenLensDistortion(parameters.intensity, parameters.area, parameters.offset, parameters.duration, parameters.ease, parameters.tweenType);
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
	}
}

function setLensDistortion(?intensity:Null<Float> = 0.01, ?area:Null<Float> = -0.1, ?offset:Null<Float> = 0.025, ?multiplier:Null<Float> = 1.0):Void {
	lensDistortionTween.forceCancel();
	lensDistortionShader.intensity = intensity * multiplier;
	lensDistortionShader.area = area * multiplier;
	lensDistortionShader.offset = offset * multiplier;
}

function tweenLensDistortion(?intensity:Null<Float> = 0.01, ?area:Null<Float> = -0.1, ?offset:Null<Float> = 0.025, ?duration:Null<Float> = 1.0, ?ease:Null<String> = 'linear', ?tweenType:Null<String> = 'In'):Void {
	lensDistortionTween = new Tween(lensDistortionShader, {
		intensity: intensity,
		area: area,
		offset: offset
	}, duration, ease, tweenType);
	lensDistortionTween.play();
}

function resetLensDistortion(removeShader:Bool = false):Void {
	lensDistortionShader.intensity = 0;
	lensDistortionShader.offset = 0;
	lensDistortionShader.area = 0;
}
