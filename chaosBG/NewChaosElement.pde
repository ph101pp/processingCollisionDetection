
class NewChaosElement extends CollisionElement {

	float 							defaultRadius=50;

	float							friction=1;
	
	float							pushForce=5;
	
	int								disturbance=0;
///////////////////////////////////////////////////////////
	NewChaosElement(chaosBG that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	NewChaosElement(chaosBG that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	
///////////////////////////////////////////////////////////
	void collide (NewChaosElement element, boolean mainCollision) {
		PVector newVelocity;
		float distance=PVector.dist(location, element.location);
		if(distance > actionRadius) return;
	
		if(distance < actionRadius*0.9) {
			newVelocity= PVector.sub(location,element.location);
		
			if(mainCollision) {
				float lineZ= abs((location.z-element.location.z)/2);
				stroke(map(lineZ,0,30,0,100 ));
				line(location.x,location.y,location.z,element.location.x,element.location.y,element.location.z);
			}			
		}
		else {
			newVelocity= PVector.sub(element.location,location);
		}
		newVelocity.normalize();
		newVelocity.mult(map(distance, 0,actionRadius,pushForce,0));		
		
	
		velocity.add(newVelocity);

//		println(element1.velocity);
	}
///////////////////////////////////////////////////////////
	void collide(MouseElement element, boolean mainCollision) {
		float distance=PVector.dist(new PVector(location.x,location.y),new PVector(element.location.x, element.location.y));
		
		if(element.moved <=0 || distance>element.actionRadius) return;
		
		int pressedFrames = frameCount-element.startFrame;

		PVector newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(0.5*pressedFrames);
		newVelocity.limit(5);
		
		velocity.add(newVelocity);
		
		friction=0.7;
		disturbance=int(random(0,2));
	}
///////////////////////////////////////////////////////////
	void move() {	
  		velocity.mult(that.globalFriction);
		velocity.mult(friction);

		if(that.globalDisturbance > 0 || disturbance>0) {
			float mult=-0.06;
			velocity.mult(mult);
			location.add(velocity);
			velocity.mult(1/mult);
			
		}
		else {
			location.add(velocity);
		}
		
		friction=1;
		disturbance--;
	}
///////////////////////////////////////////////////////////
	void frameCollision() {
		float border =  30;
		if(location.x < 0-border) {
			location.x*=-1;
	//			element.velocity.x*=-1;
	//			element.velocity.add(new PVector(0,force/2,0));
		}
		else if(location.x > width+border) {
			location.x= width+border-(location.x-width+border);
	//			element.velocity.x= width+border-(element.velocity.x-width+border);
	//			element.velocity.add(new PVector(-force/2,0,0));
		}
		if(location.y < 0-border) {
			location.y*=-1;
	//			element.velocity.y*=-1;
	//			element.velocity.add(new PVector(0,force/2,0));
		}
		else if(location.y > height+border) {
			location.y= height+border-(location.y-height+border);
	//			element.velocity.y= height+border-(element.velocity.y-height+border);
	//			element.velocity.add(new PVector(0,-force/2,0));
		}
		if(location.z < 0-border) {
			location.z*=-1;
	//			element.velocity.z*=-1;
	//			element.velocity.add(new PVector(0,0,force/2));
		}
		else if(location.z > depth) {
			location.z= depth-(location.z-depth);
	//			element.velocity.z= maxZ-(element.velocity.z-maxZ);
	//			element.velocity.add(new PVector(0,0,-force/2));
		}
	}	
}

