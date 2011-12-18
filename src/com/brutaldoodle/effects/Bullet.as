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

package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Bullet extends EnemyCollidableEmitter
	{
		public static var damage:Number;
		
		public function Bullet() {
			super();
			
			_damageAmount = Bullet.damage;
			
			//Generate one particle
			counter = new Blast(1);
			
			//Make the withe dot in the black dot image for the particle
			//so it's visible on any background
			var bullet:Sprite = new Sprite();
			bullet.addChild( new Dot(3, 0x222222) );
			bullet.addChild( new Dot(2, 0xDDDDDD) );
			
			addInitializer( new SharedImage( bullet ) );
			addInitializer( new Velocity( new PointZone( new Point(0, -250) ) ) );
			
			addAction( new Move() );
		}
	}
}