class ElementChaos extends MyCollisionElement {
	float 							defaultRadius=25;

	PVector 						ranPoint;

	float							friction=1;
	
	float							pushForce=5;
	
	int								disturbance=0;
	
	ElementLorenz					lorenz=null;
	
	ElementChaos 					element1, element2;
	///////////////////////////////////////////////////////////
	ElementChaos(pcaRanWEB that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	ElementChaos(pcaRanWEB that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	
///////////////////////////////////////////////////////////
	void collide (ElementChaos element, CollisionMap collisionMap, boolean mainCollision) {
		PVector newVelocity;
		float distance=PVector.dist(location, element.location);
		if(lorenz!=null && !lorenz.allSet) {
			int index = lorenz.elements.indexOf(this);
			PVector pointLocation = new PVector(lorenz.points[index][0],lorenz.points[index][1],lorenz.points[index][2]);
			pointLocation.mult(lorenz.zoom);
			pointLocation.sub(lorenz.average);
			pointLocation.add(lorenz.location);
			if(PVector.dist(location, pointLocation)<=random(5, 15)) return;
		}
		if(distance < (actionRadius+element.actionRadius)*0.9) {
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
		newVelocity.mult(map(distance, 0,(actionRadius+element.actionRadius),pushForce,0));		
			
		velocity.add(newVelocity);
		
//		println(element1.velocity);
	}
///////////////////////////////////////////////////////////
	void collide(ElementBlob element, CollisionMap collisionMap, boolean mainCollision) {
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
	void collide(ElementLorenz element, CollisionMap collisionMap, boolean mainCollision) {
		if(!element.allSet) {
			if(element.elements.contains(this)) lorenz= element;	
			return;
		}
			
		PVector newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(10);
		
		if(element.location.y+20 > location.y) {
			
			if(element.location.x > location.x)
				newVelocity.sub(new PVector(10,0));
			else
				newVelocity.add(new PVector(10,0));
			
			friction=1.5;
		}
		else friction=0.4;

		
		velocity.add(newVelocity);
		disturbance=int(random(0,2));
	}
///////////////////////////////////////////////////////////
	void move() {	
		if(that.ran != null) {
			moveRan();
			return;
		}
		if(lorenz !=null) {
  			int index = lorenz.elements.indexOf(this);
			if(!lorenz.allSet && index<=lorenz.count) {
				moveLorenz(index);
				return;
			}
		}
		moveNormal();
	}
///////////////////////////////////////////////////////////
	void moveLorenz(int index){
		PVector pointLocation = new PVector(lorenz.points[index][0],lorenz.points[index][1],lorenz.points[index][2]);
		pointLocation.mult(lorenz.zoom);
		pointLocation.sub(lorenz.average);
		pointLocation.add(lorenz.location);
		
		velocity= PVector.sub(pointLocation, location);
		
		velocity.mult(0.3);
	//	stroke(255,0,0);
		if(velocity.mag() <=1) {
			if(index-1 >=0 && index+2 < lorenz.elements.size()) {
				element =(ElementChaos) lorenz.elements.get(index-1);
				
				
				element1 =(ElementChaos) lorenz.elements.get(index+1);
				element2 =(ElementChaos) lorenz.elements.get(index+2);
				line(element.location.x, element.location.y, element.location.z, location.x,location.y,location.z);
//				curve( element.location.x, element.location.y, element.location.z,location.x,location.y,location.z, element1.location.x, element1.location.y, element1.location.z, element2.location.x, element2.location.y, element2.location.z);
			}
		}
		stroke(0);

	///	lorenz.moved=true;		
	
		if(PVector.dist(pointLocation, location) <=1) location = pointLocation;
		else {
			location.add(velocity);
			lorenz.moved=true;
		}
	}
///////////////////////////////////////////////////////////
	void moveRan() {
		PVector oldLocation = location;
		
		boolean contained=that.ranShape.contains(location.x,location.y);
		
		if(!contained) {
			velocity= PVector.sub(ranPoint, location);
			velocity.mult(0.3);
		}
		else velocity.mult(0.3);
		
		location.add(velocity);
		
		if(false && !that.ranShape.contains(location.x,location.y)) {
			RPoint[] points=that.ranShape.getIntersections(RShape.createLine(location.x,location.y,oldLocation.x,oldLocation.y));
			location=new PVector(points[0].x, points[0].y,0);
		}
		
	}
///////////////////////////////////////////////////////////
	void moveNormal() {
  		velocity.mult(that.globalFriction);
		velocity.mult(friction);
		
		if(lorenz != null && PVector.dist(location, lorenz.location) > 210) 
			velocity.mult(-1);
		
		if(that.globalDisturbance > 0 || disturbance>0) {
			float mult=-0.06;
			velocity.mult(mult);
			location.add(velocity);
			velocity.mult(1/mult);
			
		}
		else {
			location.add(velocity);
		}
		
		friction=lerp(friction,1,0.3);
		disturbance--;
	}
///////////////////////////////////////////////////////////
}

