class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	void collide(ElementChaos element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(ElementLorenz element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(ElementBlob element, CollisionMap collisionMap, boolean mainCollision){};
/////////////////////////////////////////////////////////
 	void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		String type=element.getClass().getName();
		
		if(type == "pcaRanWEB$ElementChaos") 	collide((ElementChaos) element, collisionMap, mainCollision);
		if(type == "pcaRanWEB$ElementLorenz") 	collide((ElementLorenz) element, collisionMap, mainCollision);
		if(type == "pcaRanWEB$ElementBlob") 	collide((ElementBlob) element, collisionMap, mainCollision);
	}	
}
