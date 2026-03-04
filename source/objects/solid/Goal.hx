package objects.solid;

import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer; // wait until cutscene is added
import worldmap.WorldMapState;

class Goal extends FlxSprite
{
    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        solid = true;
        immovable = true;
    }

    public function reach(tux:Tux)
    {
        if (solid) // TODO: Add cutscene
        {
            solid = false;
            
            Global.tuxState = tux.currentState;

            if (!Global.completedLevels.contains(Global.currentLevel))
            {
                Global.completedLevels.push(Global.currentLevel);
            }

            if (FlxG.sound.music != null) // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash. May be useless now but wait until the level end cutscene is added and it wont be useless.
            {
                FlxG.sound.music.stop();
            }

            Global.saveProgress();
            FlxG.switchState(WorldMapState.new);
        }
    }
}