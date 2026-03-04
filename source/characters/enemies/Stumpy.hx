package characters.enemies;

// Smartball made by AnatolyStev
// Smartball edited by AnatolyStev (11/4/25) (to make it detect solid squares since this game uses solid squares for collision!!)
// Smartball? Walking Leaf. -vaesea
// Walking Leaf made by AnatolyStev and Vaesea (vaesea made the vicious ivy thinggggggggggggg)

import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Stumpy extends Enemy
{
    var enemyImage = FlxAtlasFrames.fromSparrow("assets/images/characters/smallmrtree.png", "assets/images/characters/smallmrtree.xml");
    var point:FlxSprite;

    public var invincible = false;

    public var spawnedFromMrTree = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = enemyImage;
        animation.addByPrefix('walk', 'walk', 8, true);
        animation.addByPrefix("dizzy", "dizzy", 8, false);
        animation.addByPrefix('squished', 'squished', 8, false);
        
        if (!spawnedFromMrTree)
        {
            animation.play('walk');
        }
        else
        {
            FlxTween.flicker(this, 1, 0.1, {type: ONESHOT});
        }

        point = new FlxSprite();
        point.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        Global.PS.add(point);

        walkSpeed = 120;

        setSize(42, 50);
        offset.set(19, 35); // This isn't meant to be funny. (this part added on by as -> But it kind of is?)
    }

    override private function move()
    {
        var groundX = x + (direction == 1 ? width + 1 : -1); // spooky scary to some people probably, i should explain what this does but i'm tired?? -as
        var groundY = y + height + 2;

        point.setPosition(groundX, groundY);

        var hasGround = FlxG.overlap(point, Global.PS.solidThings);

        if (!hasGround && isTouching(FLOOR))
        {
            flipDirection();
        }

        // Walk
        velocity.x = direction * walkSpeed;
    }

    override public function interact(tux:Tux)
    {
        if (!invincible)
        {
            super.interact(tux);
        }
        if (invincible)
        {
            var tuxStomp = (tux.velocity.y > 0 && tux.y + tux.height < y + 10); // This checks for Tux stomping the enemy.

            FlxObject.separateY(tux, this);

            if (tuxStomp) // Can't just do the simple isTouching UP thing because then if the player hits the corner of the enemy, they take damage. That's not exactly fair.
            {
                if (FlxG.keys.anyPressed([SPACE, UP, W]))
                {
                    tux.velocity.y = --tux.maxJumpHeight;
                }
                else
                {
                    tux.velocity.y = -tux.minJumpHeight / 2;
                }
            }
            else
            {
                tux.takeDamage();
            }
        }
    }
}