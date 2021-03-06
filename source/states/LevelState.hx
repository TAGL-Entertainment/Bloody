package states;

import enums.ItemType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import haxe.macro.Type;
import hud.InventoryUI;
import hud.PlayerHud;
import hud.PopupInventory;
import structs.Item;

/**
 * ...
 * @author ElRyoGrande
 */
class LevelState extends FlxState 
{
	//WORLD SETTINGS
	public static var TILE_WIDTH:Int = 16;
	public static var TILE_HEIGHT:Int = 16;
	//public static var LEVEL_WIDTH:Int = 50;
	//public static var LEVEL_HEIGHT:Int = 50;
	
	
	
	public var maps:FlxTilemap;
	public var player:Hero;
	public var enemy:Enemy;
	public var floor:FlxObject;
	
	//ITEMS ET WEAPONS SPAWN
	public var items:Item;
	public var itemGroup:FlxTypedGroup<Item>;
	
	
	public var grip :FlxSprite;
	
	
	//UI
	public var info:FlxText;
	
	//HUD
	//DOIT PEUT ETRE DISPARAITRE (ON A DEJA LES INFOS DANS LE PLAYER)
	//public var _playerHud:PlayerHud;
	
	
	
	
	
	//SYSTEM ATTACK
	public var attacks:FlxTypedGroup<FlxSprite>;
	
	
	override public function create():Void 
	{
		super.create();
		
		//UTILE POUR LE DEBUG
		FlxG.mouse.visible = true;
		bgColor = 0xffaaaaaa;
		
		//GENERATION
		maps = GenerateLevel();
		
		FlxG.worldBounds.width = TILE_WIDTH * maps.widthInTiles;
		FlxG.worldBounds.height = TILE_HEIGHT * maps.heightInTiles;
		
		add(maps);
		add(player);
		//add(player.weaponSprite);
		
		//ENEMY 
		//enemy = new Enemy(player.getPosition().x + 40, player.getPosition().y);
		//add(enemy);
		
		//CAMERA SECTION
		camera.follow(player);
		
		
		//HUD
		//_playerHud = new PlayerHud(player);
		add(player.playerHud);
		
		//Inventory
		add(player.inventory);
		
		//TEST WEAPON
		//add(player.testWeap);
		
		
		//Attack system basic
		//attacks = new FlxTypedGroup<FlxSprite>();
		
		
		
		
		//TEST UI //FONCTIONNEL A REFORMATER
		
		info = new FlxText(items.x,items.y + 40 , 80);
		//info.scrollFactor.set(0, 0); 
		info.borderColor = 0xff000000;
		info.borderStyle = SHADOW;
		info.text = "RAMASSER";
		info.visible = false;
		add(info);
		
	
	}
	
	override public function update(elapsed:Float):Void 
	{
		player.acceleration.x = 0;
		
		FlxG.collide(player, maps);
		
		//INTERACTION WITH OBJECT // MAYBE CREER UNE VARIABLE OVERLAPS A CHECKER POUR LES DIFFERENTS AFFICHAGE
		if (!FlxG.overlap(itemGroup, player, getItem))
		{
			info.visible = false;	
		}

		//FlxG.collide(enemy, maps);
		//FlxG.collide(enemy, player);

		//ATTACK SYSTEM DEBUT
		//if (attacks.members.length > 0)
		//{
			//FlxG.overlap(player, attacks, onOverlaping);
			//trace("CHECK ATTACK");
		//}
	
		//if (FlxG.keys.anyJustPressed([FlxKey.A]))
		//{
			//attacks.add(player);
		//}
		//if (FlxG.keys.anyJustPressed([FlxKey.E]))
		//{
			//attacks.remove(player,true);
		//}
		
		
		
		//UI TEST (INVENTORY)
		if (FlxG.keys.anyJustPressed([FlxKey.I]))
		{
			//FlxG.switchState(new InventoryUI());
			openSubState(new PopupInventory());
			
		}
		
		
		if (FlxG.keys.anyJustPressed([FlxKey.R]))
		{
			FlxG.resetState();
		}
		
		
		super.update(elapsed);
		
	}
	
	public function onOverlaping(obj1:FlxObject, obj2:FlxObject)
	{
		trace("ON A HIT : " + obj2.toString());
	}
	
	
	public function getItem(item:Item, player:Hero):Void
	{	
		info.text = "RAMASSER";
		info.setPosition(item.x, item.y);
		info.visible = true;
		
		if (FlxG.keys.anyJustPressed([FlxKey.G]))
		{
			item.kill();
			player.inventory.addItemToInventory(item);
		}
	}
	
	
	//ALGO GENERATION MAP
	
	public function GenerateLevel():FlxTilemap
	{
		var mapTable = [FlxColor.WHITE, FlxColor.BLACK, FlxColor.BLUE, FlxColor.RED, FlxColor.GREEN];
		var mps = new FlxTilemap();
		itemGroup = new FlxTypedGroup<Item>();
	

		//var mapCSV = FlxStringUtil.imageToCSV("assets/data/mapo.png",false,1,mapTable);
		//trace(mps.toString());
		var mapTilePath:String = "assets/data/tilezz.png";
		//mps.loadMapFromCSV(mapCSV, mapTilePath, 16, 16);
		mps.loadMapFromGraphic("assets/data/mapo2.png", false, 1, [FlxColor.WHITE, FlxColor.BLACK,FlxColor.BLUE, FlxColor.RED,FlxColor.GREEN], mapTilePath, 16, 16, OFF, 0, 1, 1);
		trace("LVL WIDTH : " + mps.widthInTiles);
		trace("LVL HEIGHT : " + mps.heightInTiles);
		
		
		//Chargement de la position de départ du joueur
		var playerPos:Array<FlxPoint> = mps.getTileCoords(2, false);
		player = new Hero(playerPos[0].x, playerPos[0].y);
		
		
		//Chargement de la position des objets et instanciation des objets
		var itemPos:Array<FlxPoint> = mps.getTileCoords(3, false);
		for (i in itemPos)
		{
			//UNE ERREUR DANS LES ITEMPOS
			
			
			if (i == itemPos[2])
			{
				items = new Item(i.x, i.y, ItemType.consumable, "potion");
			}
			else
			{
				items = new Item(i.x, i.y, ItemType.weapon, "axeC64");
		
			}
			
				itemGroup.add(items);
			
		}
		add(itemGroup);
		
		//POUR LES AGGRIP
		//if (mps.getTileCoords(4, false) != null)
		//{
			mps.setTileProperties(4, FlxObject.NONE);
			var gripPos:Array<FlxPoint> = mps.getTileCoords(4, false);
			for (i in gripPos)
			{
			
			grip = new Grip(gripPos[0].x+9, gripPos[0].y+5);

			grip.makeGraphic(16, 16, FlxColor.TRANSPARENT,true);

			grip.setSize(6, 4);


			add(grip);
			}
		
		//}
		
		
		
		
		
		//Remove de la case propre au joueur
		var playerTiles:Array<Int> = mps.getTileInstances(2);
		var playerTile:Int = playerTiles[0];
		mps.setTileByIndex(playerTile, -1, true);
		
		//FAIRE UN FOR QUI DETRUIIIIIT TOUUUUUT
		var itemTiles:Array<Int> = mps.getTileInstances(3);
		for (i in itemTiles)
		{
				mps.setTileByIndex(i, -1, true);
		}
		
		//var itemTile:Int = itemTiles[0];
		//mps.setTileByIndex(itemTile, -1, true);
		
	
		//mps.setTileByIndex(itemTiles[1], -1, true);
		//mps.setTileByIndex(itemTiles[2], -1, true);
		
		/*var gripTiles:Array<Int> = mps.getTileInstances(4);
		var gripTile:Int = gripTiles[0];
		mps.setTileByIndex(gripTile, -1, true);*/
		
		//mps.setTileProperties(1, FlxObject.ANY);
		//trace(mps.totalTiles);
		return mps;
	}
	
	
}