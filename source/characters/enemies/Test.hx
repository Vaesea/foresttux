package characters.enemies;

import flixel.graphics.frames.FlxAtlasFrames;

class Test extends Enemy
{
    var viciousIvyImage = FlxAtlasFrames.fromSparrow("assets/images/characters/nolok.png", "assets/images/characters/nolok.xml");

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = viciousIvyImage;
        animation.addByPrefix('walk', 'walk', 10, true);
        animation.addByPrefix('squished', 'throw', 10, false);
        animation.play('walk');

        setSize(48, 151);
        offset.set(33, 27);
    }

    override private function move()
    {
        velocity.x = direction * walkSpeed;
    }
}