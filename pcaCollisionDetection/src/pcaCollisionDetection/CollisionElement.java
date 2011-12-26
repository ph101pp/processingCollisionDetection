package pcaCollisionDetection;
import processing.core.PVector;

abstract public class CollisionElement {
	public PVector 							location = new PVector(0,0,0);
	public PVector								velocity = new PVector(0,0,0);
	public float 								actionRadius;

///////////////////////////////////////////////////////////
	public void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
///////////////////////////////////////////////////////////
	abstract public void frameCollision(CollisionMap collisionMap);
	abstract public void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision);
}
