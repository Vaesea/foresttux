package characters.enemies;

// Smartball made by AnatolyStev
// Smartball edited by AnatolyStev (11/4/25) (to make it detect solid squares since this game uses solid squares for collision!!)
// Smartball? Walking Leaf. -vaesea
// Walking Leaf made by AnatolyStev and Vaesea (vaesea made the vicious ivy thinggggggggggggg)

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

class WalkingLeaf extends Enemy
{
    var walkingLeafImage = FlxAtlasFrames.fromSparrow("assets/images/characters/walking_leaf.png", "assets/images/characters/walking_leaf.xml");

    var point:FlxSprite;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = walkingLeafImage;
        animation.addByPrefix('walk', 'walk', 8, true);
        animation.addByPrefix('squished', 'squshed', 8, false);
        animation.play('walk');

        point = new FlxSprite();
        point.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        Global.PS.add(point);

        walkSpeed = 60;

        setSize(26, 19);
        offset.set(4, 20); // This isn't meant to be funny. (this part added on by as -> But it kind of is?)
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
}