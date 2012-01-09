class ElementChaos extends CollisionElement {
	example4						that;
	float 							defaultRadius=25;
	float							pushForce=5;
	PVector							velocity = new PVector(0,0,0);
	PVector							newVelocity;
///////////////////////////////////////////////////////////
	ElementChaos(example4 that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height));
	}
	ElementChaos(example4 that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height));
	}
	
///////////////////////////////////////////////////////////
	public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement) {
		float distance=PVector.dist(location, element.location);

		newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(map(distance, 0,(actionRadius+element.actionRadius),pushForce,0));		

		velocity.add(newVelocity);

		if(testedElement)
			line(location.x,location.y,element.location.x,element.location.y);
	}
///////////////////////////////////////////////////////////
	void draw() {	
  		velocity.mult(that.globalFriction);
		location.add(velocity);
	}
}

