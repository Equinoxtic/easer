package ui.system;

import Constants;

import lime.app.Application;

import lib.Tween;
import lib.Wave;

class WindowHandler {
	public var windowInstance;
	public var active:Bool;
	
	private var sineWaveEnabled:Bool;
	private var waveAmplitude:Float;
	private var waveFrequency:Float;
	private var waveDampeningX:Float;
	private var waveDampeningY:Float;
	
	public function new() {
		this.windowInstance = Application.current.window;
		this.setSineWaveProperties(Constants.DEFAULT_WINDOW_WAVE_AMPLITUDE, Constants.DEFAULT_WINDOW_WAVE_FREQUENCY, 1.0, 1.0);
	}
	
	public function update():Void {
		if (!active) return;
		sineWave(this.waveAmplitude, this.waveFrequency);
	}
	
	public function reset():Void {
		this.active = false;
		this.sineWaveEnabled = false;
		this.setBorderless(false);
		this.setFullscreen(false);
		this.position(Constants.DEFAULT_WINDOW_X, Constants.DEFAULT_WINDOW_Y);
		this.resize(Constants.DEFAULT_WINDOW_WIDTH, Constants.DEFAULT_WINDOW_HEIGHT);
	}
	
	public function position(x:Int, y:Int):Void {
		this.windowInstance.move(x, y);
	}
	
	public function resize(width:Int, height:Int):Void {
		this.windowInstance.resize(width, height);
	}
	
	public function tweenedPosition(x:Int, y:Int, duration:Float, ease:String, tweenType:String):Void {
		var posTween:Tween = new Tween(this.windowInstance, {x: x, y: y}, duration, ease, tweenType).play();
	}
	
	public function tweenedResize(width:Int, height:Int, duration:Float, ease:String, tweenType:String):Void {
		var sizeTween:Tween = new Tween(this.windowInstance, {width: width, height: height}, duration, ease, tweenType).play();
	}
	
	public function sineWave(amplitude:Float, frequency:Float):Void {
		if (this.sineWaveEnabled) {
			var newX:Int = Std.int(FlxMath.lerp(this.windowInstance.x, Constants.DEFAULT_WINDOW_X + ((amplitude / this.waveDampeningX) * Math.cos(Wave.create(frequency))), 0.1));
			var newY:Int = Std.int(FlxMath.lerp(this.windowInstance.y, Constants.DEFAULT_WINDOW_Y + ((amplitude / this.waveDampeningY) * Math.sin(Wave.create(frequency))), 0.1));
			this.position(newX, newY);
		}
	}
	
	public function setSineWaveState(state:Bool):Void {
		this.sineWaveEnabled = state;
	}
	
	public function setSineWaveProperties(newAmplitude:Float, newFrequency:Float, dampeningX:Float, dampeningY:Float):Void {
		this.waveAmplitude = newAmplitude;
		this.waveFrequency = newFrequency;
		this.waveDampeningX = dampeningX;
		this.waveDampeningY = dampeningY;
	}
	
	public function focus():Void {
		this.windowInstance.focus();
	}
	
	public function setFullscreen(isFullscreen:Bool):Void {
		if (!this.windowInstance.borderless) {
			this.windowInstance.fullscreen = isFullscreen;
		} else {
			if (isFullscreen) this.resize(1920, 1080);
		}
	}
	
	public function setBorderless(isBorderless:Bool):Void {
		this.windowInstance.borderless = isBorderless;
	}
}
