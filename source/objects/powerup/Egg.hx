package objects.powerup;

import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;

class Egg extends FlxSprite
{
    var scoreAmount = 75;
    var gravity = 1000;
    var direction = 1;
    var moveSpeed = 115;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        // Load image
        loadGraphic('assets/images/objects/powerup/egg.png', false);

        // Make sure it's solid
        solid = true;

        // Add gravity
        acceleration.y = gravity;

        // Hitbox
        setSize(44, 32);
        offset.set(10, 0);
    }

    override public function update(elapsed:Float)
    {
        velocity.x = direction * moveSpeed;

        if (justTouched(WALL))
        {
            direction = -direction;
        }

        super.update(elapsed);
    }

    // Called when Tux touches a crystal
    public function collect(tux:Tux)
    {
        // Play sound
        FlxG.sound.play('assets/sounds/tuxyay.ogg');

        // Kill power-up (so it doesn't stay)
        kill();

        // Heal Tux
        FlxG.sound.play('assets/sounds/excellent.wav');
        kill();
        tux.bigTux();
        Global.score += scoreAmount;

        // Add scoreAmount to Global.score
        Global.score += scoreAmount;
    }
}