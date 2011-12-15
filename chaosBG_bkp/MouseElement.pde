class MouseElement extends CollisionElement {
	float 							defaultRadius=180;

	int								startFrame;
	
	float							moved;
	
	LorenzElement					lorenzElement;
		
	boolean							shapeSet;
	
//	PROGRAMM
	PVector newLocation;
///////////////////////////////////////////////////////////
	MouseElement(chaosBG that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (mouseX, mouseY,0);
		startFrame=frameCount;

		lorenzElement= new LorenzElement(that, location);
	}
	MouseElement(chaosBG that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (mouseX, mouseY,0);
		startFrame=frameCount;

		lorenzElement= new LorenzElement(that, location);
	}
///////////////////////////////////////////////////////////
	void frameCollision() {}
	void collide(NewChaosElement element, CollisionMap collisionMap, boolean mainCollision) {}
	void collide(MouseElement element, CollisionMap collisionMap, boolean mainCollision) {}
	void collide(LorenzElement element, CollisionMap collisionMap, boolean mainCollision) {}
	void collide(BlobElement element, CollisionMap collisionMap, boolean mainCollision) {}
///////////////////////////////////////////////////////////
	void move() {
		PVector newLocation =new PVector (mouseX, mouseY,0);
		moved=PVector.dist(newLocation, location);
		
		if(moved>0) that.movement=true;
		
		if(frameCount-startFrame > 100 && random(0,1) >0.9) startFrame=frameCount;

		location = new PVector (mouseX, mouseY,0);
	
		
		if(shapeSet && !lorenzElement.allSet && (moved<=0 || PVector.dist(location, lorenzElement.location) > 80)) {
			startFrame=frameCount;
			shapeSet=false;
			lorenzElement.remove();
		}
		if(frameCount-startFrame> 50 && !shapeSet && moved>0 ) {
			that.lorenzElements.add(lorenzElement);
			that.collisionDetection.addElement(lorenzElement);
			lorenzElement.location=new PVector(location.x,location.y, location.z);
			lorenzElement.startFrame=frameCount;
			lorenzElement.elements = new ArrayList();
			shapeSet=true;
		}
		
	}
///////////////////////////////////////////////////////////
	void finalize() {
		if(lorenzElement.allSet) return;
	
		lorenzElement.remove();
	}
}