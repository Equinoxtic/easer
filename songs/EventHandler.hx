package;

import easer.lib.Tween;
import flixel.text.FlxTextAlign;
import easer.ui.FilmBorder;
import easer.ui.GhostTappingStateText;
import easer.ui.TweenedOutwardLensCircle;
import easer.ui.system.WindowHandler;

var filmBorder:FilmBorder;

var invertShader:CustomShader;
var lensDistortionShader:CustomShader;
var bokehShader:CustomShader;

var windowSizeTween:Tween;
var lensDistortionTween:Tween;
var lensCircleBlackTween:Tween;
var filmBorderTween:Tween;
var bokehTween:Tween;

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

var lensCircle:TweenedOutwardLensCircle;
var lensCircleBlack:FlxSprite;

var filmBorderGrp:FlxSpriteGroup;

var spriteCache:Array<FlxSprite> = [];
var tweenCache:Array<Tween> = [];

var savedFilmBorderHeight:Float = 0.0;

final DEFAULT_FILM_BORDER_HEIGHT:Float = 0.0;

var camOther:FlxCamera;

function create():Void {
	windowHandler = new WindowHandler();
	windowHandler.reset();
	
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
	
	lensCircleBlack = new FlxSprite(0, 0);
	lensCircleBlack.cameras = [camHUD];
	lensCircleBlack.color = 0xFF000000;
	lensCircleBlack.alpha = 0.0;
	lensCircleBlack.scale.set(FlxG.width * 2.0, FlxG.height * 2.0);
	lensCircleBlack.visible = false;
	add(lensCircleBlack);
	
	lensCircle = new TweenedOutwardLensCircle(1.0, {width: 0.0, height: 0.0});
	lensCircle.cameras = [camHUD];
	lensCircle.visible = false;
	add(lensCircle);
	
	spriteCache.push(lensCircle);
	spriteCache.push(lensCircleBlack);
}

function onPreGenerateStrums(event:AmountEvent):Void {
	filmBorder = new FilmBorder();
	filmBorder.cameras = [camHUD];
	add(filmBorder);
	spriteCache.push(filmBorder);
}

function update(elapsed:Float):Void {
	windowHandler.update();
}

function postUpdate(elapsed:Float):Void {
	// if (endingSong) clearMem();
}

function onNoteHit(e:NoteHitEvent):Void {
	shakeCamFor(e.character);
}

/*function onStateSwitch(e:StateEvent):Void {
	clearMem();
}*/

function onGameOver():Void {
	clearMem();
}

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
		case 'Tween Bokeh':
			var parameters:Dynamic = {
				intensity:				curEvent.params[0],
				radius:					curEvent.params[1],
				duration:				curEvent.params[2],
				ease:					curEvent.params[3],
				tweenType:				curEvent.params[4]
			};
			bokehTween = new Tween(bokehShader, {radius: parameters.radius, amount: parameters.intensity}, parameters.duration, parameters.ease, parameters.tweenType).play();
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
			windowHandler.active = true;
			windowHandler.setSineWaveProperties(parameters.amplitude, parameters.frequency, parameters.xDampening, parameters.yDampening);
			windowHandler.setSineWaveState(true);
		case 'Toggle Borderless':
			windowHandler.setBorderless(curEvent.params[0]);
		case 'Tween Outward Lens Circle':
			var parameters:Dynamic = {
				width:					curEvent.params[0],
				height:					curEvent.params[1],
				alpha:					curEvent.params[2],
				duration:				curEvent.params[3],
				ease:					curEvent.params[4],
				tweenType:				curEvent.params[5]
			};
			lensCircle.visible = true;
			lensCircleBlack.visible = true;
			lensCircle.tween(parameters.alpha, parameters.width, parameters.height, parameters.duration, parameters.ease, parameters.tweenType);
			lensCircleBlackTween = new Tween(lensCircleBlack, {alpha: parameters.alpha}, parameters.duration * 0.5, parameters.ease, parameters.tweenType).play();
			tweenCache.push(lensCircleBlackTween);
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
		case 'Film Border':
			var parameters = {
				isTweened:				curEvent.params[0],
				height:					curEvent.params[1],
				duration:				curEvent.params[2],
				ease:					curEvent.params[3],
				tweenType:				curEvent.params[4],
				pulsates:				curEvent.params[5]
			};
			if (parameters.isTweened) {
				if (parameters.pulsates) {
					filmBorder.pulsate(parameters.height, parameters.duration, parameters.ease, parameters.tweenType);
				} else {
					filmBorder.tween(parameters.height, parameters.duration, parameters.ease, parameters.tweenType);
				}
			} else {
				filmBorder.resize(parameters.height);
			}
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

function setLensDistortion(intensity:Float = 0.01, area:Float = -0.1, offset:Float = 0.025, multiplier:Float = 1.0):Void {
	if (!shadersEnabled) return;
	if (lensDistortionTween != null)
		lensDistortionTween.forceCancel();
	lensDistortionShader.intensity = intensity * multiplier;
	lensDistortionShader.area = area * multiplier;
	lensDistortionShader.offset = offset * multiplier;
}

function tweenLensDistortion(intensity:Float = 0.01, area:Float = -0.1, offset:Float = 0.025, duration:Float = 1.0, ease:String = 'linear', tweenType:String = 'In'):Void {
	if (!shadersEnabled) return;
	lensDistortionTween = new Tween(lensDistortionShader, {
		intensity: intensity,
		area: area,
		offset: offset
	}, duration, ease, tweenType).play();
	tweenCache.push(lensDistortionTween);
}

function resetLensDistortion(removeShader:Bool = false):Void {
	if (!shadersEnabled) return;
	lensDistortionShader.intensity = 0;
	lensDistortionShader.offset = 0;
	lensDistortionShader.area = 0;
}

function drawFilmBorder(y:Float, height:Float, angle:Float, yOrigin:Float):FlxSprite {
	var borderSpr:FlxSprite = new FlxSprite(0, y);
	borderSpr.color = 0xFF000000;
	borderSpr.scale.set(FlxG.width * 5, height);
	borderSpr.angle = angle;
	borderSpr.origin.set(0.5, yOrigin);
	borderSpr.updateHitbox();
	spriteCache.push(borderSpr);
	return borderSpr;
}

function clearMem():Void {
	shakeMap.clear();
	shakeMap = [];
	for (sprite in spriteCache) {
		if (sprite == null)
			continue;
		sprite.destroy();
	}
	for (tween in tweenCache) {
		if (tween == null)
			continue;
		tween.destroy();
	}
}
