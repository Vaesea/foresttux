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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class MrTree extends Enemy
{
    var enemyImage = FlxAtlasFrames.fromSparrow("assets/images/characters/mrtree.png", "assets/images/characters/mrtree.xml");
    var point:FlxSprite;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = enemyImage;
        animation.addByPrefix('walk', 'walk', 8, true);
        animation.play('walk');

        point = new FlxSprite();
        point.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        Global.PS.add(point);

        setSize(42, 69);
        offset.set(19, 16);
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
        var tuxStomp = (tux.velocity.y > 0 && tux.y + tux.height < y + 10); // This checks for Tux stomping the enemy.

        if (!alive || waitToCollide > 0)
        {
            return;
        }

        if (currentHeldEnemyState == MovingSquished)
        {
            damageOthers = true;
        }

        FlxObject.separateY(tux, this);

        if (tuxStomp) // Can't just do the simple isTouching UP thing because then if the player hits the corner of the enemy, they take damage. That's not exactly fair.
        {
            Global.score += scoreAmount;

            if (FlxG.keys.anyPressed([SPACE, UP, W]))
            {
                tux.velocity.y = -tux.maxJumpHeight;
            }
            else
            {
                tux.velocity.y = -tux.minJumpHeight / 2;
            }

            kill();

            return;
        }

        // Shouldn't get this far unless Tux should actually be damaged.
        tux.takeDamage();
    }

    override public function kill()
    {
        spawnStumpy();
        spawnViciousIvys();
        exists = false;
        alive = false;
    }

    override public function killFall()
    {
        fallSound.setPosition(x + width / 2, y + height);
        fallSound.play();
        Global.score += scoreAmount;
        flipY = true;
        acceleration.x = 0;
        velocity.y = -fallForce;
        solid = false;
    }

    function spawnStumpy()
    {
        var stumpy:Stumpy = new Stumpy(this.x, this.y);
        Global.PS.enemies.add(stumpy);
        stumpy.spawnedFromMrTree = true;
        stumpy.direction = this.direction;
        stumpy.flipX = this.flipX;
        stumpy.walkSpeed = 0;
        stumpy.invincible = true;
        stumpy.animation.play("dizzy");
        new FlxTimer().start(1, function(_)
        {
            stumpy.invincible = false;
            stumpy.animation.play("walk");
            stumpy.walkSpeed = 120;
        }, 1);
    }

    function spawnViciousIvys()
    {
        var vi1:ViciousIvy = new ViciousIvy(this.x - (this.width / 2), this.y);
        Global.PS.enemies.add(vi1);
        vi1.direction = -1;
        vi1.flipX = false;

        var vi2:ViciousIvy = new ViciousIvy(this.x + this.width, this.y);
        Global.PS.enemies.add(vi2);
        vi2.direction = 1;
        vi2.flipX = true;
    }
}