class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	void collide(ElementSquare element, CollisionMap collisionMap, boolean testedElement){};
	void collide(ElementCircle element, CollisionMap collisionMap, boolean testedElement){};
	void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){};
/////////////////////////////////////////////////////////
 	void frameCollision(CollisionMap collisionMap) {};
 	void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement) {
		String type=element.getClass().getName();
		
		if(type == "example2$ElementSquare") 	collide((ElementSquare) element, collisionMap, testedElement);
		if(type == "example2$ElementCircle") 	collide((ElementCircle) element, collisionMap, testedElement);
		if(type == "example2$ElementMouse") 	collide((ElementMouse) element, collisionMap, testedElement);
	}	
}