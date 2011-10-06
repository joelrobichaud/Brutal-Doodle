package com.brutaldoodle.effects
{
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Bullet extends Emitter2D
	{
		public function Bullet()
		{
			counter = new Blast(1);
						
			addInitializer( new SharedImage( new Dot(3, 0x444444) ) );
			addInitializer( new Velocity( new PointZone( new Point(0, -150) ) ) );
			
			addAction( new Move() );
		}
	}
}