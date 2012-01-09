class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	void collide(ElementGrid element, CollisionMap collisionMap, boolean testedElement){};
	void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){};
	void collide(ElementBounce element, CollisionMap collisionMap, boolean testedElement){};
/////////////////////////////////////////////////////////
 	void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement) {
		String type=element.getClass().getName();

		if(type == "example3$ElementGrid") 	collide((ElementGrid) element, collisionMap, testedElement);
		if(type == "example3$ElementMouse") collide((ElementMouse) element, collisionMap, testedElement);
		if(type == "example3$ElementBounce") collide((ElementBounce) element, collisionMap, testedElement);
	}	
}