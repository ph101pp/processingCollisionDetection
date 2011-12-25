package pcaCollision;
import processing.core.PVector;

abstract class CollisionElement {
	PVector 							location = new PVector(0,0,0);
	PVector								velocity = new PVector(0,0,0);
	float 								actionRadius;

///////////////////////////////////////////////////////////
	public void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
///////////////////////////////////////////////////////////
	abstract void frameCollision(CollisionMap collisionMap);
	abstract void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision);
}
