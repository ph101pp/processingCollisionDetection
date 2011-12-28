class ElementGrid extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	example3	that;
	Color		elementColor;
	RPolygon	polygon,intersection;
	boolean 	collided=false;
////////////////////////////////////////////////////////////////////////////////
	public ElementGrid(example3 that_, float x , float y){	
		that=that_;
		elementColor = new Color(int(random(10,245)), int(random(10,245)), int(random(10,245)));
		location = new PVector (x, y);
		actionRadius= random(10, 15);
		
		polygon=RPolygon.createCircle(x,y,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	void collide(ElementBounce element, CollisionMap collisionMap, boolean testedElement){
		try {
			intersection= polygon.intersection(element.polygon);
			fill(element.intersectionColor.getRed(),element.intersectionColor.getGreen(),element.intersectionColor.getBlue());
			intersection.draw();
		}
		catch(NullPointerException npe)	{}
		collided=true;
	};
////////////////////////////////////////////////////////////////////////////////
	void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){
		try {
			intersection= polygon.intersection(element.polygon);
			fill(element.intersectionColor.getRed(),element.intersectionColor.getGreen(),element.intersectionColor.getBlue());
			intersection.draw();

			if(collided) {
				intersection=intersection.intersection(that.bouncy.polygon);
				fill(200,0,0);
				intersection.draw();
			}
		}
		catch(NullPointerException npe)	{}
		collided=true;
	};
////////////////////////////////////////////////////////////////////////////////
	void draw() {
		fill(elementColor.getRed(),elementColor.getGreen(),elementColor.getBlue());
		polygon.draw();
		collided=false;
	}
////////////////////////////////////////////////////////////////////////////////
}