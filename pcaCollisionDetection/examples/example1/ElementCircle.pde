class ElementCircle extends CollisionElement{
////////////////////////////////////////////////////////////////////////////////
	example1	that;
	Color		elementColor;
	boolean		mouseColor;
////////////////////////////////////////////////////////////////////////////////
	public ElementCircle(example1 that_){	
		that=that_;
		elementColor = new Color(int(random(10,245)), int(random(10,245)), int(random(10,245)));
		location = new PVector (random(width), random(height));
		actionRadius= random(10, 100);
	}
////////////////////////////////////////////////////////////////////////////////
	public void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		mouseColor = true;
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
}