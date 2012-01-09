class ElementBounce extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	RPolygon	polygon;
	int			xDirection=1;
	int			yDirection=1;
	
	Color		intersectionColor= new Color(0,0,0);
	
////////////////////////////////////////////////////////////////////////////////
	public ElementBounce(){	
		location = new PVector(200, 200);
		actionRadius= 100;
		polygon=RPolygon.createCircle(200,200,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	void draw() {
		float tx= 10 *xDirection;
		float ty= 10 *yDirection;
		
  		polygon.translate(tx,ty);
// 		polygon.draw();
 		location.add(new PVector(tx,ty));
 		
 	 	if(location.x > width-actionRadius || location.x < actionRadius)  xDirection *= -1;
  		if(location.y > height-actionRadius || location.y < actionRadius)   yDirection *= -1;

	}
////////////////////////////////////////////////////////////////////////////////
}