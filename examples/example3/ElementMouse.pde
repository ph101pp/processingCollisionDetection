class ElementMouse extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	RPolygon	polygon;	

	Color		intersectionColor= new Color(200,200,200);
	
	boolean 	enlarged=false;
////////////////////////////////////////////////////////////////////////////////
	public ElementMouse(){	
		location = new PVector (mouseX, mouseY);
		actionRadius= 100;
		polygon=RPolygon.createCircle(mouseX,mouseY,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	void collide(ElementBounce element, CollisionMap collisionMap, boolean testedElement){
		enlarged=true;
		actionRadius=120;
		polygon=RPolygon.createCircle(mouseX,mouseY,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	void draw() {
		polygon.translate(mouseX-location.x,mouseY-location.y);
		location = new PVector (mouseX, mouseY);
		intersectionColor= new Color(200,200,200);
//		polygon.draw();
		
		if(enlarged) {
			actionRadius=100;
			polygon=RPolygon.createCircle(mouseX,mouseY,actionRadius);
			enlarged=false;
		}
	}
////////////////////////////////////////////////////////////////////////////////
}