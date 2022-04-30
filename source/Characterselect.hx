package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import flixel.addons.display.FlxBackdrop;

#if sys
import sys.FileSystem;
#end

using StringTools;



class CharacterData
{
    public var namealt:Array<String>;
	public var Displayname:Array<String>;
	// public var offset:Array<Float>;
    public function new(namealt:Array<String>, Displayname:Array<String>)
    {
        this.namealt = namealt;
		this.Displayname = Displayname;
        // this.offset = offset;
    }
}


class Characterselect extends MusicBeatState
{
	public var CharactersData:Array<CharacterData> = [
		new CharacterData(['bf', 'zero', 'zero-mic'], ['Boyfriend', 'Boyfriend ZERO', 'Boyfriend ZERO MIC'])];
    public var select:Int = 0; 
    public var characterselected:CharacterData;
	public var characterdisplay:Boyfriend;
    public var characterText:FlxText;
    var done:Bool = false;


	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
    #end




    override public function create():Void
    {
        //create your state objects here

		var bgscroll:FlxBackdrop = new FlxBackdrop(Paths.image('cubicbg2'), 5, 5, true, true);
		bgscroll.scrollFactor.set();
		bgscroll.screenCenter();
		bgscroll.velocity.set(150, 150);
		bgscroll.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgscroll);



		characterselected = CharactersData[select];
		characterdisplay = new Boyfriend(0,0, characterselected.namealt[select]);
		characterdisplay.screenCenter();
		// startCharacterPos(characterdisplay);
        add(characterdisplay);
		characterText = new FlxText(0, FlxG.height - 100, 0, characterselected.Displayname[select], 30, true);
		characterText.screenCenter(X);
        characterText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(characterText);

    }

    override public function update(elapsed:Float):Void
    {
        //call super to update the core state class
        super.update(elapsed);
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
        {
			Change(-1);
        }
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
        {
			Change(1);
        }
        if (FlxG.keys.justPressed.ENTER) {
			ClientPrefs.curCharacter = characterselected.namealt[select];
            ClientPrefs.saveSettings();
			MusicBeatState.switchState(new MainMenuState());
        }
        new FlxTimer().start(0.5, function (tmr:FlxTimer) {
			characterdisplay.dance();
        }, 0);
    }



    function Change(Change)
    {
        select += Change;
		if (select >= characterselected.namealt.length)
			select = 0;
		if (select < 0)
			select = characterselected.namealt.length - 1;

        remove(characterdisplay);

		characterText.text = characterselected.Displayname[select];


		characterdisplay = new Boyfriend(0, 0, characterselected.namealt[select]);
		// boyfriendMap.set(characterselected.namealt[select], characterdisplay);
		// boyfriendGroup.add(newBoyfriend);
		add(characterdisplay);
		characterdisplay.screenCenter();
		// startCharacterPos(characterdisplay);
		// characterdisplay.alpha = 0.00001;
		// startCharacterLua(newBoyfriend.curCharacter);

    }

	function startCharacterPos(char:Character)
	{
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}
}