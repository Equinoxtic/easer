package easer.ui.system;

import easer.Constants;

import lime.app.Application;

import easer.lib.Tween;
import easer.lib.Wave;

class WindowHandler {
	public var windowInstance;
	public var active:Bool;
	
	private var sineWaveEnabled:Bool = false;
	private var waveAmplitude:Float = 100;
	private var waveFrequency:Float = 1.0;
	private var waveDampeningX:Float = 1.0;
	private var waveDampeningY:Float = 1.0;
	
	private var posTween:Tween;
	private var sizeTween:Tween;
	
	public function new() {
		this.windowInstance = Application.current.window;
		this.setSineWaveProperties(Constants.DEFAULT_WINDOW_WAVE_AMPLITUDE, Constants.DEFAULT_WINDOW_WAVE_FREQUENCY, 1.0, 1.0);
	}
	
	public function update():Void {
		if (PlayState.instance.endingSong) {
			this.destroy();
		} else {
			if (!this.active)
				return;
			sineWave(this.waveAmplitude, this.waveFrequency);
		}
	}
	
	public function reset():Void {
		this.active = false;
		this.sineWaveEnabled = false;
		this.setBorderless(false);
		this.setFullscreen(false);
		this.position(Constants.DEFAULT_WINDOW_X, Constants.DEFAULT_WINDOW_Y);
		this.resize(Constants.DEFAULT_WINDOW_WIDTH, Constants.DEFAULT_WINDOW_HEIGHT);
	}
	
	public inline function position(x:Int, y:Int):Void
		this.windowInstance.move(x, y);
	
	public inline function resize(width:Int, height:Int):Void
		this.windowInstance.resize(width, height);
	
	public inline function tweenedPosition(x:Int, y:Int, duration:Float, ease:String, tweenType:String):Void
		this.posTween = new Tween(this.windowInstance, {x: x, y: y}, duration, ease, tweenType).play();
	
	public inline function tweenedResize(width:Int, height:Int, duration:Float, ease:String, tweenType:String):Void
		this.sizeTween = new Tween(this.windowInstance, {width: width, height: height}, duration, ease, tweenType).play();
	
	public function sineWave(amplitude:Float, frequency:Float):Void {
		if (!this.sineWaveEnabled) return;
		this.position(
			Std.int(FlxMath.lerp(this.windowInstance.x, Constants.DEFAULT_WINDOW_X + ((amplitude / this.waveDampeningX) * Math.cos(Wave.create(frequency))), 0.1)),
			Std.int(FlxMath.lerp(this.windowInstance.y, Constants.DEFAULT_WINDOW_Y + ((amplitude / this.waveDampeningY) * Math.sin(Wave.create(frequency))), 0.1))
		);
	}
	
	public inline function setSineWaveState(state:Bool):Void
		this.sineWaveEnabled = state;
	
	public function setSineWaveProperties(newAmplitude:Float, newFrequency:Float, dampeningX:Float, dampeningY:Float):Void {
		this.waveAmplitude = newAmplitude;
		this.waveFrequency = newFrequency;
		this.waveDampeningX = dampeningX;
		this.waveDampeningY = dampeningY;
	}
	
	public inline function focus():Void
		this.windowInstance.focus();
	
	public inline function setBorderless(isBorderless:Bool):Void
		this.windowInstance.borderless = isBorderless;
	
	public function setFullscreen(isFullscreen:Bool):Void {
		if (!this.windowInstance.borderless) {
			this.windowInstance.fullscreen = isFullscreen;
		} else {
			if (isFullscreen)
				this.resize(1920, 1080);
		}
	}
	
	public function destroy():Void {
		this.reset();
		if (this.posTween != null)
			this.posTween.destroy();
		if (this.sizeTween != null)
			this.sizeTween.destroy();
		this.windowInstance = null;
		this = null;
	}
}
