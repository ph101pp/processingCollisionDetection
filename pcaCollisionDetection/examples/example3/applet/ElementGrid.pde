class ElementGrid extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	example3	that;
	Color		elementColor;
	RPolygon	polygon,intersection;
////////////////////////////////////////////////////////////////////////////////
	public ElementGrid(example3 that_, float x , float y){	
		that=that_;
		elementColor = new Color(int(random(10,245)), int(random(10,245)), int(random(10,245)));
		location = new PVector (x, y);
		actionRadius= random(10, 15);
		
		polygon=RPolygon.createCircle(x,y,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){
	
		intersection= polygon.intersection(element.polygon);
		fill(0);
		intersection.draw();
	
	};
////////////////////////////////////////////////////////////////////////////////
	void draw() {
		fill(elementColor.getRed(),elementColor.getGreen(),elementColor.getBlue());
//		polygon.draw();
	}
////////////////////////////////////////////////////////////////////////////////
}
