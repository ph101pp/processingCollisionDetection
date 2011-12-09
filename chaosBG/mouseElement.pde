class MouseElement extends CollisionElement {
	float 							defaultRadius=200;

	float							friction=1;
	
	int								startFrame;
	
	float							moved;
///////////////////////////////////////////////////////////
	MouseElement(chaosBG that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (mouseX, mouseY,0);
		startFrame=frameCount;
	}
	MouseElement(chaosBG that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (mouseX, mouseY,0);
		startFrame=frameCount;
	}
///////////////////////////////////////////////////////////
	void frameCollision() {}
///////////////////////////////////////////////////////////
	void collide(NewChaosElement element, boolean mainCollision) {}
	void collide(CollisionElement element, boolean mainCollision) {}
	void collide(MouseElement element, boolean mainCollision) {}
///////////////////////////////////////////////////////////
	void move() {
		PVector newLocation=new PVector (mouseX, mouseY,0);
		moved=PVector.dist(newLocation, location);
		
		if(frameCount-startFrame > 100 && random(0,1) >0.9) startFrame=frameCount;

		location = new PVector (mouseX, mouseY,0);
	
	}





}