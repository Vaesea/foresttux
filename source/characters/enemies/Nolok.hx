package characters.enemies;

// made by vaesea and anatolystev (mostly anatolystev)
// still has a major bug where he doesn't start throwing when hitting the right wall
// also doesn't throw right now

import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

enum NolokStatesOne
{
    Normal;
    Running;
    Throwing;
}

enum NolokStatesTwo
{
    Alive;
    Dead;
}

class Nolok extends FlxSprite
{
    // Health and stuff like that
    var health = 7;
    var invFrames = 2;
    var dyingTime = 2;
    var canTakeDamage = true;

    // Movement
    var speed = 180;
    var jumpHeight = 800;
    var stompHeight = 250;
    var gravity = 1000;
    var fallForce = 128;

    // Score
    var scoreAmount = 5000;
    
    // Direction
    var direction = -1;

    // Current States
    var currentStateOne = Normal;
    var currentStateTwo = Alive;
    var changeToThrowingTimer = 0.5; // unused
    var startTimer = 2;

    var hitThisFrame = false;

    // Spritesheet
    var nolokImage = FlxAtlasFrames.fromSparrow("assets/images/characters/nolok.png", "assets/images/characters/nolok.xml");

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Images / Spritesheet stuff
        frames = nolokImage;
        animation.addByPrefix("stand", "stand", 10, false);
        animation.addByPrefix("walk", "walk", 10, true);
        animation.addByPrefix("throw", "throw", 10, false);
        animation.addByPrefix("fall", "fall", 10, false);
        animation.play("stand");

        // Gravity
        acceleration.y = gravity;

        // Hitbox
        setSize(48, 151);
        offset.set(33, 27);

        new FlxTimer().start(startTimer, function(_)
        {
            currentStateOne = Running;
        }, 1);
    }

    override public function update(elapsed:Float)
    {
        // apparently putting random stuff in update = bad
        if (currentStateTwo == Alive)
        {
            updateState();
        }

        trace(currentStateOne);

        super.update(elapsed);
    }

    function updateState()
    {
        switch (currentStateOne)
        {
            case Normal:
                velocity.x = 0;
                animation.play("stand");
            case Running:
                velocity.x = direction * speed;
                animation.play("walk");
                if (justTouched(WALL))
                {
                    flipDirection();
                    currentStateOne = Throwing;
                }
            case Throwing:
                velocity.x = 0;
                animation.play("throw");
                new FlxTimer().start(4, function(_)
                {
                    currentStateOne = Running;
                }, 1);
        }
    }

    function throwViciousIvy()
    {
        var viciousIvy:ViciousIvy = new ViciousIvy(-32, 64);
        viciousIvy.direction = this.direction;
        Global.PS.enemies.add(viciousIvy);
    }

    function flipDirection()
    {
        flipX = !flipX;
        direction = -direction;
    }

    public function interact(tux:Tux)
    {
        var tuxStomp = (tux.velocity.y > 0 && tux.y + tux.height < y + 10); // This checks for Tux stomping the enemy... or does it?

        if (currentStateTwo != Alive)
        {
            return;
        }

        if (tuxStomp && canTakeDamage && currentStateOne == Running) // Can't just do the simple isTouching UP thing because then if the player hits the corner of the enemy, they take damage. That's not exactly fair.
        {
            tux.y = y - tux.height - 1; // prevent falling into boss otherwise tux would be damaged. i know this looks like an ai ass solution but it's good enough for now.

            if (FlxG.keys.anyPressed([SPACE, UP, W]))
            {
                tux.velocity.y = -tux.maxJumpHeight;
            }
            else
            {
                tux.velocity.y = -tux.minJumpHeight / 2;
            }

            health -= 1;
            canTakeDamage = false;

            if (health <= 0)
            {
                kill();
            }

            FlxTween.flicker(this, invFrames, 0.1, {type: ONESHOT});

            new FlxTimer().start(invFrames, function(_)
            {
                canTakeDamage = true;
            }, 1);

            return; // this has to be here to stop tux from taking damage if he hit nolok without being hit
        }

        // well hopefully this fixes it!
        if (!tuxStomp && currentStateTwo == Alive)
        {
            tux.takeDamage();
        }
    }

    override public function kill()
    {
        Global.score += scoreAmount;
        flipY = true;
        velocity.y = -fallForce;
        solid = false;
    }
}