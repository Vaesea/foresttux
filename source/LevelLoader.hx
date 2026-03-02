package;

import AnimatedTiles.Flag;
import AnimatedTiles.Water;
import AnimatedTiles.WaterTrans;
import characters.enemies.ViciousIvy;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import objects.solid.Solid;
import states.PlayState;

class LevelLoader extends FlxState
{
    public static var tiledMap:TiledMap;

    public static function loadLevel(state:PlayState, level:String)
    {
        tiledMap = new TiledMap("assets/data/levels/" + level + ".tmx");

        var music = tiledMap.properties.get("Music");
        var levelName = tiledMap.properties.get("Level Name");
        var levelCreator = tiledMap.properties.get("Level Creator");

        Global.levelName = levelName;
        Global.levelCreator = levelCreator;
        Global.currentSong = music;

        // Quickly taken from my other game...
        for (layer in tiledMap.layers)
        {
            if (Std.isOfType(layer, TiledImageLayer))
            {
                var imageLayer:TiledImageLayer = cast layer;
                var path:String = Std.string(imageLayer.imagePath);
                path = StringTools.replace(path, "../", "");
                path = "assets/" + path;

                var image = new FlxBackdrop(path, XY);

                image.offset.x = Std.parseFloat(imageLayer.properties.get("offsetX"));
                image.offset.y = Std.parseFloat(imageLayer.properties.get("offsetY"));
                
                image.scrollFactor.x = imageLayer.parallaxX;
                image.scrollFactor.y = imageLayer.parallaxY;

                state.add(image);

                trace(path); // This is here so you can see if the path is correct if the image isn't showing.
            }
        }

        var mainLayer:TiledTileLayer = cast tiledMap.getLayer("Main");
        
        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 42); // tiled is bad and i have to start at global id 42. fuck tiled.
        state.map.solid = false;

        var backgroundLayer:TiledTileLayer = cast tiledMap.getLayer("Background");
        
        var backgroundMap = new FlxTilemap();
        backgroundMap.loadMapFromArray(backgroundLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 42);
        backgroundMap.solid = false;

        state.add(backgroundMap);
        state.add(state.map);

        var tuxPosition:TiledObject = getLevelObjects(tiledMap, "Player")[0];
        state.tux.setPosition(tuxPosition.x, tuxPosition.y - 64);

        for (solid in getLevelObjects(tiledMap, "Solid"))
        {
            var solidSquare = new Solid(solid.x, solid.y, solid.width, solid.height); // Need this because width and height.
            state.collision.add(solidSquare);
        }

        for (object in getLevelObjects(tiledMap, "AnimatedTiles"))
        {
            switch (object.type)
            {
                default:
                    state.atiles.add(new Water(object.x, object.y - 32));
                case "flag":
                    state.atiles.add(new Flag(object.x, object.y - 32));
                case "trans":
                    state.atiles.add(new WaterTrans(object.x, object.y - 32));
            }
        }

        for (object in getLevelObjects(tiledMap, "AnimatedTilesFront"))
        {
            switch (object.type)
            {
                default:
                    state.atilesFront.add(new Water(object.x, object.y - 32));
                case "flag":
                    state.atilesFront.add(new Flag(object.x, object.y - 32));
                case "trans":
                    state.atilesFront.add(new WaterTrans(object.x, object.y - 32));
            }
        }

        for (object in getLevelObjects(tiledMap, "Enemies"))
        {
            switch (object.type)
            {
                default:
                    state.enemies.add(new ViciousIvy(object.x, object.y - 19));
            }
        }
    }

    // copied from tux platforming (so copied from peppertux (so copied from discover haxeflixel))
    public static function getLevelObjects(map:TiledMap, layer:String):Array<TiledObject>
    {
        if ((map != null) && (map.getLayer(layer) != null))
        {
            var objLayer:TiledObjectLayer = cast map.getLayer(layer);
            return objLayer.objects;
        }
        else
        {
            trace("Object layer " + layer + " not found! Also credits to Discover Haxeflixel.");
            return [];
        }
    }
}