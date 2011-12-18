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

package com.brutaldoodle.components.controllers
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.CanonShotRenderer;
	import com.pblabs.animation.AnimationEvent;
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class CanonController extends TickedComponent {	
		public static var reloadSpeed:Number;
		public static var shootPermission:Boolean = true;
		
		public var canonOffset:PropertyReference;
		public var positionProperty:PropertyReference;
		
		public static const NORMAL_OFFSET:Number = -18;
		public static const ALTERNATE_OFFSET:Number = -62;
		
		private var _shootAnimation:Animator;
		private var _reloadAnimation:Animator;
		
		public function CanonController() {
			super();
			_shootAnimation = new Animator();
			_reloadAnimation = new Animator();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var _offset:Number = PlayerController.state == PlayerController.STATE_NORMAL ? CanonController.NORMAL_OFFSET : CanonController.ALTERNATE_OFFSET;
			
			owner.setProperty(canonOffset, new Point(0, _offset));
			
			if (_shootAnimation.isAnimating)
			{
				_shootAnimation.animate(deltaTime);
				owner.setProperty(canonOffset, new Point(0, _shootAnimation.currentValue + _offset));
			}
			else if (_reloadAnimation.isAnimating)
			{
				_reloadAnimation.animate(deltaTime);
				owner.setProperty(canonOffset, new Point(0, _reloadAnimation.currentValue + _offset));
			}
			else
			{
				if (shootPermission) {
					if (PBE.isKeyDown(InputKey.SPACE)) {
						var p:Projectile = new Projectile(CanonShotRenderer, owner);
						
						// shoot
						_shootAnimation.start(0, 26, 0.05, AnimatorType.PLAY_ANIMATION_ONCE);
						_shootAnimation.addEventListener(AnimationEvent.ANIMATION_FINISHED_EVENT, shootAnimation_done);
					}
					/*
					if (PBE.isKeyDown(InputKey.Z)) {
						// ability 1
					}
					
					if (PBE.isKeyDown(InputKey.X)) {
						// ability 2
					}
					
					if (PBE.isKeyDown(InputKey.C)) {
						// ability 3
					}
					*/
				}
			}
		}
		
		private function shootAnimation_done(event:AnimationEvent):void {
			_shootAnimation.removeEventListener(AnimationEvent.ANIMATION_FINISHED_EVENT, shootAnimation_done);
			_reloadAnimation.start(26, 0, CanonController.reloadSpeed, AnimatorType.PLAY_ANIMATION_ONCE);
		}
	}
}