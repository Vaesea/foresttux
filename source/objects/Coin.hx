package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Coin extends FlxSprite
{
    // Spritesheet
    var coinImage = FlxAtlasFrames.fromSparrow("assets/images/objects/bonus/coin.png", "assets/images/objects/bonus/coin.xml");

    var scoreAmount = 25;
    var speedFromBlock = -128;
    var gravity = 420; // wtf

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet
        frames = coinImage;

        // Animations
        animation.addByPrefix("normal", "idle", 10, true);
        animation.play("normal");
    }

    public function collect()
    {
        alive = false;
        solid = false;
        
        Global.score += scoreAmount;
        Global.coins += 1;

        FlxG.sound.play("assets/sounds/distro.wav");

        FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
    }

    function finishKill(_)
    {
        kill();
    }

    public function collectNoSound()
    {
        alive = false;
        solid = false;
        
        Global.score += scoreAmount;
        Global.coins += 1;

        FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
    }

    // is this like the worst way to do this???
    public function setFromBlock()
    {
        FlxG.sound.play('assets/sounds/distro.wav');
        solid = false;
        acceleration.y = gravity;
        velocity.y = speedFromBlock;
        new FlxTimer().start(0.3, function(_) {collectNoSound();}, 1);
    }
}