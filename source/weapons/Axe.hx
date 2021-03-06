package weapons;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ElRyoGrande
 */
class Axe extends Weapon 
{
	public var yolo:FlxSprite;
	public var _player:Hero;
	
	public function new(player:Hero) 
	{
		_player = player;
		super(player,_weaponType);
		yolo = this.loadGraphic("assets/new_images/axeC64.png", true, 64, 62, false);
		
		//this.scale.set(-2, -2);
		this.scale.set(0.8, 0.8);
	}
	
	override public function update(elapsed:Float):Void
	{
		//this.setPosition(this.x-(yolo.width/2) , this.y+(yolo.height/2));

		super.update(elapsed);
	}
	
	override public function Attack()
	{
		this.setPosition(_player.x-10, _player.y+50);
	}
	
}