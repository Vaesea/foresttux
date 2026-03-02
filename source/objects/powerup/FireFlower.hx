package objects.powerup;

import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;

class FireFlower extends FlxSprite
{
    var scoreAmount = 75;
    var gravity = 1000;
    var direction = 1;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        // Load image
        loadGraphic('assets/images/objects/powerup/fireflower.png', false);

        // Make sure it's solid
        solid = true;

        // Add gravity
        acceleration.y = gravity;
    }

    // Called when Tux touches a candle
    public function collect(tux:Tux)
    {
        // Play sound
        FlxG.sound.play('assets/sounds/tuxyay.ogg');

        // Kill power-up (so it doesn't stay)
        kill();

        // Turn Tux into Fire Tux
        tux.fireTux();

        // Add scoreAmount to Global.score
        Global.score += scoreAmount;
    }
}