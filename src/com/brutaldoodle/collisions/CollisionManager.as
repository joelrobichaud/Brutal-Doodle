/*
* Brutal Doodle
* Copyright (C) 2011  Joel Robichaud, Maxime Basque, Maxime St-Louis-Fortier, Raphaelle Cantin & Simon Garnier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.brutaldoodle.collisions
{
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.events.CollisionEvent;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flintparticles.twoD.zones.Zone2D;

	public class CollisionManager extends EventDispatcher
	{
		// Singleton instance
		private static var _instance:CollisionManager = new CollisionManager();
		
		// Containers for all collidable types
		private var _players:Vector.<Zone2D>;
		private var _enemies:Vector.<Zone2D>;
		private var _allies:Vector.<Zone2D>;
		private var _neutrals:Vector.<Zone2D>;
		
		// Dictionary used for quick reference access to the vectors
		private var _zones:Dictionary;
		
		public static function get instance ():CollisionManager { return _instance; }
		
		public function CollisionManager() {
			// "Private" constructor
			if (instance) throw new Error("CollisionManager can only be accessed through CollisionManager.instance");
		}
		
		public function initialize ():void {
			_players = new Vector.<Zone2D>();
			_enemies = new Vector.<Zone2D>();
			_allies = new Vector.<Zone2D>();
			_neutrals = new Vector.<Zone2D>();
			
			// quick access by reference...
			_zones = new Dictionary(true);
			_zones[CollisionType.NEUTRAL] = _neutrals;
			_zones[CollisionType.PLAYER] = _players;
			_zones[CollisionType.ENEMY]	= _enemies;
			_zones[CollisionType.ALLY] = _allies;
		}
		
		public function reset ():void {
			initialize(); // hard reset, everything is deleted
		}
		
		// collisions are only calculated for objects that are registered here
		public function registerForCollisions (zone:Zone2D, type:String):void {
			_zones[type].push(zone);
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_REGISTERED, zone));
		}
		
		// when you no longer need an object to collide...
		public function stopCollisionsWith (zone:Zone2D, type:String):void {
			var zones:Vector.<Zone2D> = _zones[type];
			var index:int = zones.indexOf(zone);
			
			if (index != -1) {
				// Because we all like minus infinity...
				// (the collision zone is moved away from the canvas until it's garbage collected by flash)
				(zone as BoundingBoxComponent).zone = new Rectangle(-Infinity, -Infinity, -Infinity, -Infinity);
				zones.splice(index, 1);
			}
			
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_UNREGISTERED, zone));
		}
		
		public function getCollidableObjectsByType (type:String):Vector.<Zone2D> {
			return _zones[type];
		}
	}
}