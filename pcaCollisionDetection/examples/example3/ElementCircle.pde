class ElementCircle extends CollisionElement{
////////////////////////////////////////////////////////////////////////////////
	example2	that;
	Color		elementColor;
	boolean		mouseColor;
////////////////////////////////////////////////////////////////////////////////
	public ElementCircle(example2 that_){	
		that=that_;
		elementColor = new Color(int(random(10,245)), int(random(10,245)), int(random(10,245)));
		location = new PVector (random(width), random(height));
		actionRadius= random(10, 100);
	}
////////////////////////////////////////////////////////////////////////////////
	public void frameCollision(CollisionMap collisionMap) {};
////////////////////////////////////////////////////////////////////////////////
	public void collision(ElementMouse element, CollisionMap collisionMap, boolean mainCollision) {
		if(that.removeElement) remove();
		else {
			mouseColor = true;
			that.collision = true;
		}
	};
////////////////////////////////////////////////////////////////////////////////
	void draw() {
		if(mouseColor) 
			fill(that.mouse.elementColor.getRed(),that.mouse.elementColor.getGreen(),that.mouse.elementColor.getBlue());		
		else  
			fill(elementColor.getRed(),elementColor.getGreen(),elementColor.getBlue());

		ellipse(location.x,location.y, actionRadius*2,actionRadius*2);
		mouseColor=false;
	}
////////////////////////////////////////////////////////////////////////////////
	public void remove() {
		that.collisionDetection.remove(this);
		that.circles.remove(this);
	}
////////////////////////////////////////////////////////////////////////////////
}