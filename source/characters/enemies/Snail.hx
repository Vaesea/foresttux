package characters.enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

class Snail extends Enemy
{
    var snailImage = FlxAtlasFrames.fromSparrow("assets/images/characters/snail.png", "assets/images/characters/snail.xml");
    var point:FlxSprite;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = snailImage;
        animation.addByPrefix('walk', 'walk', 10, true);
        animation.addByPrefix('flat', 'flat', 20, true);
        animation.play('walk');

        setSize(31, 29);
        offset.set(0, 4);

        point = new FlxSprite();
        point.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        Global.PS.add(point);

        canBeHeld = true;
        jumpsWhenHittingWall = true;
    }

    override private function move()
    {
        if (currentHeldEnemyState == MovingSquished)
        {
            velocity.x = direction * walkSpeed * 6;
        }
        else if (currentHeldEnemyState == Squished || currentHeldEnemyState == Held)
        {
            velocity.x = 0;

            if (currentHeldEnemyState == Held)
            {
                velocity.y = 0;
            }
        }
        else
        {
            // Ground detection stuff copied from WalkingLeaf.hx. Is this a good way to do this? No. Will I do it like this anyways? Yes.
            var groundX = x + (direction == 1 ? width + 1 : -1); // spooky scary to some people probably, i should explain what this does but i'm tired?? -as
            var groundY = y + height + 2;

            point.setPosition(groundX, groundY);

            var hasGround = FlxG.overlap(point, Global.PS.solidThings);

            if (!hasGround && isTouching(FLOOR))
            {
                flipDirection();
            }

            velocity.x = direction * walkSpeed;
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (currentHeldEnemyState == Held && held != null)
        {
            if (held.flipX == true)
            {
                x = held.x - 8;
            }
            else if (held.flipX == false)
            {
                x = held.x + 11;
            }

            y = held.y;
            flipX = !held.flipX;
        }
    }
}