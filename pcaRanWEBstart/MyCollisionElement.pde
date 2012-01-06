class MyCollisionElement extends CollisionElement{
	pcaRanWEBstart 	that;
/////////////////////////////////////////////////////////
	void collide(ElementChaos element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(ElementLorenz element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(ElementBlob element, CollisionMap collisionMap, boolean mainCollision){};
/////////////////////////////////////////////////////////
 	void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		collide((ElementChaos) element, collisionMap, mainCollision);	
	}	
////////////////////////////////////////////////////////////////////////////////
	public boolean test(CollisionElement element) {
		return this.equals(element) || PVector.dist(element.location, location) > (actionRadius+element.actionRadius) ?
			false:
			true;
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement(MyCollisionElement element) {
		if(!test(element)) return;
		element.collide((ElementChaos) this, new CollisionMap(element.that, element.actionRadius), true);
		collide((ElementBlob) element, new CollisionMap(element.that, element.actionRadius),false);
	}
}