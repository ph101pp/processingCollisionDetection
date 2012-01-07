class ElementChaos extends MyCollisionElement {
	float 							defaultRadius=20;

	PVector 						ranPoint;

	float							friction=1;
	
	float							pushForce=5;
	
	int								disturbance=0;
	
	
	ElementChaos 					element1, element2;
	///////////////////////////////////////////////////////////
	ElementChaos(pcaRanWEBjs that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	ElementChaos(pcaRanWEBjs that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	
///////////////////////////////////////////////////////////
	void collideChaos (ElementChaos element, CollisionMap collisionMap, boolean mainCollision) {
		PVector newVelocity;
		float distance=PVector.dist(location, element.location);
		if(distance < (actionRadius+element.actionRadius)*0.9) {
			newVelocity= PVector.sub(location,element.location);
		
			if(mainCollision) {
				float lineZ= abs((location.z-element.location.z)/2);
				stroke(map(lineZ,0,30,0,100 ));
				line(location.x,location.y,element.location.x,element.location.y);
			}			
		}
		else {
			newVelocity= PVector.sub(element.location,location);
		}
		newVelocity.normalize();
		newVelocity.mult(map(distance, 0,(actionRadius+element.actionRadius),pushForce,0));		
			
		velocity.add(newVelocity);
		
//		println(element1.velocity);
	}
///////////////////////////////////////////////////////////
	void collideBlob(ElementBlob element, CollisionMap collisionMap, boolean mainCollision) {
		if(element.moved <=0 || that.globalFriction < 0.8) return;
		
		int pressedFrames = frameCount-element.startFrame;

		PVector newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(0.5*pressedFrames);
		newVelocity.limit(pushForce+4);
		
		velocity.add(newVelocity);
		
		friction=0.7;
		disturbance=int(random(0,2));
	}
///////////////////////////////////////////////////////////
	void move() {	
		if(that.ran != null) {
			moveRan();
			return;
		}
		moveNormal();
	}
///////////////////////////////////////////////////////////
	void moveRan() {
		PVector oldLocation = location;
		
		boolean contained=PVector.dist(ranPoint, location)<=1;
		
		if(!contained) {
			velocity= PVector.sub(ranPoint, location);
			velocity.mult(random(0.2,0.7));
		}
		else velocity.mult(random(0.2,0.7));
		
		location.add(velocity);
		
	}
///////////////////////////////////////////////////////////
	void moveNormal() {
 		velocity.mult(0.8);
		velocity.mult(friction);
		
		location.add(velocity);
		
		friction=lerp(friction,1,0.3);
		disturbance--;
		
		
	}
///////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
 	void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		collideChaos((ElementChaos) element, collisionMap, mainCollision);	
	}	
////////////////////////////////////////////////////////////////////////////////
	public boolean test(CollisionElement element) {
		return this.equals(element) || PVector.dist(element.location, location) > (actionRadius+element.actionRadius) ?
			false:
			true;
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement(MyCollisionElement element) {
		if(!test(element)) return;
		collideBlob((ElementBlob) element, new CollisionMap(element.that, element.actionRadius),false);
	}
}

