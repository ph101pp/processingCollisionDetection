class ChaosElement {
	chaosBG that;
	
	PVector location;
	PVector	velocity;
	int		lineCount=0;
///////////////////////////////////////////////////////////
	ChaosElement(chaosBG that_) {
		that=that_;
		location = new PVector (random(width), random(height),random(that.depth));
		velocity = new PVector (0,0,0);
	}
///////////////////////////////////////////////////////////
	void draw() {
		pushMatrix();
			translate(location.x, location.y, location.z);
			fill(0,0,0,100);
			box(1);
			noFill();
		popMatrix();	
	}
}