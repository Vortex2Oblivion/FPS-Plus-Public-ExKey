package;

import config.*;

import flixel.FlxSprite;
//import polymod.format.ParseRules.TargetSignatureElement;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var type:String = "";

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public var playedEditorClick:Bool = false;
	public var editorBFNote:Bool = false;
	public var absoluteNumber:Int;
	public var mania:Int = 0;

	public var editor = false;

	public var xOffset:Float = 0;
	public var yOffset:Float = 0;

	public static var swagWidth:Float = 160 * 0.7;
	public static var noteScale:Float;

	public var dType:Int = 0;

	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var tooMuch:Float = 30;

	public function new(_strumTime:Float, _noteData:Int, _type:String, ?_editor = false, ?_prevNote:Note, ?_sustainNote:Bool = false)
	{
		super();

		if (_type != null)
			type = _type;

		if (_prevNote == null)
			_prevNote = this;

		prevNote = _prevNote;
		isSustainNote = _sustainNote;

		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		editor = _editor;
		if (PlayState.SONG.mania == 2)
			{
				x -= tooMuch;
			}
		
		if(!editor){
			strumTime = _strumTime + Config.offset;
			if(strumTime < 0) {
				strumTime = 0;
			}
		}
		else {
			strumTime = _strumTime;
		}

		noteData = _noteData;

		var daStage:String = PlayState.curStage;

	

		noteScale = 0.7;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 90 * 0.7;
			noteScale = 0.46;
			mania = 2;
		}

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('week6/weeb/pixelUI/arrows-pixels'), true, 19, 19);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				animation.add('green glow', [22]);
				animation.add('red glow', [23]);
				animation.add('blue glow', [21]);
				animation.add('purple glow', [20]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('week6/weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				frames = Paths.getSparrowAtlas('ui/NOTE_assets_multikey');

				animation.addByPrefix('greenScroll', 'C0');
				animation.addByPrefix('redScroll', 'D0');
				animation.addByPrefix('blueScroll', 'B0');
				animation.addByPrefix('purpleScroll', 'A0');
				animation.addByPrefix('whiteScroll', 'E0');
				animation.addByPrefix('yellowScroll', 'F0');
				animation.addByPrefix('violetScroll', 'G0');
				animation.addByPrefix('blackScroll', 'H0');
				animation.addByPrefix('darkScroll', 'I0');

				animation.addByPrefix('purpleholdend', 'A tail');
				animation.addByPrefix('greenholdend', 'C tail');
				animation.addByPrefix('redholdend', 'D tail');
				animation.addByPrefix('blueholdend', 'B tail');
				animation.addByPrefix('whiteholdend', 'E tail');
				animation.addByPrefix('yellowholdend', 'F tail');
				animation.addByPrefix('violetholdend', 'G tail');
				animation.addByPrefix('blackholdend', 'H tail');
				animation.addByPrefix('darkholdend', 'I tail');

				animation.addByPrefix('purplehold', 'A hold');
				animation.addByPrefix('greenhold', 'C hold');
				animation.addByPrefix('redhold', 'D hold');
				animation.addByPrefix('bluehold', 'B hold');
				animation.addByPrefix('whitehold', 'E hold');
				animation.addByPrefix('yellowhold', 'F hold');
				animation.addByPrefix('violethold', 'G hold');
				animation.addByPrefix('blackhold', 'H hold');
				animation.addByPrefix('darkhold', 'I hold');

				animation.addByPrefix('purpleglow', 'A-glow');
				animation.addByPrefix('greenglow', 'C-glow');
				animation.addByPrefix('redglow', 'D-glow');
				animation.addByPrefix('blueglow', 'B-glow');
				animation.addByPrefix('whiteglow', 'E-glow');
				animation.addByPrefix('yellowglow', 'F-glow');
				animation.addByPrefix('violetglow', 'G-glow');
				animation.addByPrefix('blackglow', 'H-glow');
				animation.addByPrefix('darkglow', 'I-glow');

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		this.noteData = noteData % Main.keyAmmo[mania];
		x += swagWidth * (noteData % Main.keyAmmo[mania]);
		animation.play(frameN[noteData % Main.keyAmmo[mania]] + 'Scroll');


		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			xOffset += width / 2;
			
			flipY = Config.downscroll;

			animation.play(frameN[noteData % Main.keyAmmo[mania]] + 'holdend');
			switch (noteData)
			{
				case 0:
				//nada
			}
			

			updateHitbox();

			xOffset -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				xOffset += 36;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
					//nada
				}
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * (0.7 / noteScale);
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
				
				var speed = PlayState.SONG.speed;

				if(Config.scrollSpeedOverride > 0){
					speed = Config.scrollSpeedOverride;
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.485 * speed;
				if(PlayState.curStage.startsWith('school')) {
					prevNote.scale.y *= 0.833 * (1.5 / 1.485); // Kinda weird, just roll with it.
				}
				prevNote.updateHitbox();
			}
		}

		if(type == "transparent"){
			alpha = 0.35;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if(isSustainNote){
				canBeHit = (strumTime < Conductor.songPosition + Conductor.safeZoneOffset * 1 && (prevNote == null ? true : prevNote.wasGoodHit));
			}
			else{
				canBeHit = (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
							&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset);
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
			
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				canBeHit = true;
			}
		}

		//Glow note stuff.

		if (canBeHit && Config.noteGlow && !isSustainNote && !editor && animation.curAnim.name.contains("Scroll")){
			var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
			if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
			else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
			animation.play(frameN[noteData % Main.keyAmmo[mania]] + 'glow');
		}


	}
}
