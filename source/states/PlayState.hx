package states;

import characters.enemies.Enemy;
import characters.player.Fireball;
import characters.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import objects.BonusBlock;
import objects.BrickBlock.CoinNormalBrickBlock;
import objects.BrickBlock.CoinSnowBrickBlock;
import objects.BrickBlock.EmptyNormalBrickBlock;
import objects.BrickBlock.EmptySnowBrickBlock;
import objects.Coin;
import objects.powerup.Egg;
import objects.powerup.FireFlower;
import objects.powerup.PowerUp;
import objects.powerup.TuxDoll;
import states.substates.LevelIntro;

class PlayState extends FlxState
{
	public var map:FlxTilemap;

	// Add things part 1
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var tux(default, null):Tux;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var blocks(default, null):FlxTypedGroup<FlxSprite>;
	public var bricks(default, null):FlxTypedGroup<FlxSprite>;
	public var atiles(default, null):FlxTypedGroup<FlxSprite>;
	public var atilesFront(default, null):FlxTypedGroup<FlxSprite>;
	var hud:HUD;
	var entities:FlxGroup;
	public var solidThings:FlxGroup;

	override public function create()
	{
		// Just so Global.PS actually works...
		Global.PS = this;

		// Add things part 2
		entities = new FlxGroup();
		solidThings = new FlxGroup();
		enemies = new FlxTypedGroup<Enemy>();
		tux = new Tux();
		items = new FlxTypedGroup<FlxSprite>();
		blocks = new FlxTypedGroup<FlxSprite>();
		bricks = new FlxTypedGroup<FlxSprite>();
		hud = new HUD();
		atiles = new FlxTypedGroup<FlxSprite>();
		atilesFront = new FlxTypedGroup<FlxSprite>();

		LevelLoader.loadLevel(this, Global.currentLevel);

		// Add things part 3
		entities.add(items);
		entities.add(enemies);
		add(solidThings);
		add(atiles);
		add(entities);
		add(tux);
		add(atilesFront);
		add(hud);

		// Camera
		FlxG.camera.follow(tux, PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		// Foreground Layer, just realized I added this in the worst way possible. Oh well, too bad!
		var foregroundLayer:TiledTileLayer = cast LevelLoader.tiledMap.getLayer("Foreground");
        
        var foregroundMap = new FlxTilemap();
        foregroundMap.loadMapFromArray(foregroundLayer.tileArray, LevelLoader.tiledMap.width, LevelLoader.tiledMap.height, "assets/images/tiles.png", 32, 32, 42);
        foregroundMap.solid = false;

		add(foregroundMap);

		// Start the Level Intro
		openSubState(new LevelIntro(FlxColor.BLACK));
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Tux collision
		FlxG.collide(solidThings, tux, collideEntities);
		FlxG.overlap(entities, tux, collideEntities);

		// Enemy + Entity collision
		FlxG.collide(solidThings, entities);
		FlxG.overlap(entities, enemies, function (entity:FlxSprite, enemy:Enemy)
		{
			if (Std.isOfType(entity, Enemy))
			{
				enemy.collideOtherEnemy(cast entity);
			}
			if (Std.isOfType(entity, Fireball))
			{
				enemy.collideFireball(cast entity);
			}
		} );

		// Item collision
		FlxG.collide(solidThings, items);
	}

	function collideEntities(entity:FlxSprite, tux:Tux)
	{
		if (Std.isOfType(entity, Enemy))
		{
			(cast entity).interact(tux);
		}

		if (Std.isOfType(entity, Coin))
		{
			(cast entity).collect();
		}

		if (Std.isOfType(entity, PowerUp) || Std.isOfType(entity, FireFlower) || Std.isOfType(entity, Egg) || Std.isOfType(entity, TuxDoll))
		{
			(cast entity).collect(tux);
		}

		if (Std.isOfType(entity, EmptyNormalBrickBlock) || Std.isOfType(entity, EmptySnowBrickBlock) || Std.isOfType(entity, CoinSnowBrickBlock) || Std.isOfType(entity, CoinNormalBrickBlock) || Std.isOfType(entity, BonusBlock))
		{
			(cast entity).hit(tux);
		}
	}
}
