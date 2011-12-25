class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	void collide(NewChaosElement element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(LorenzElement element, CollisionMap collisionMap, boolean mainCollision){};
	void collide(BlobElement element, CollisionMap collisionMap, boolean mainCollision){};
/////////////////////////////////////////////////////////
	void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		String type=element.getClass().getName();
		
		if(type == "chaosBG$NewChaosElement") 	collide((NewChaosElement) element, collisionMap, mainCollision);
		if(type == "chaosBG$LorenzElement") 	collide((LorenzElement) element, collisionMap, mainCollision);
		if(type == "chaosBG$BlobElement") 		collide((BlobElement) element, collisionMap, mainCollision);
	}	
}