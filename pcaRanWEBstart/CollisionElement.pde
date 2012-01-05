abstract public class CollisionElement {
////////////////////////////////////////////////////////////////////////////////
	public PVector 								location = new PVector(0,0,0);
	public PVector								velocity = new PVector(0,0,0);
	public float 								actionRadius;
////////////////////////////////////////////////////////////////////////////////
	abstract public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement);
////////////////////////////////////////////////////////////////////////////////
	public void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
////////////////////////////////////////////////////////////////////////////////
	public boolean test(CollisionElement element) {
		return this.equals(element) || PVector.dist(element.location, location) > (actionRadius+element.actionRadius) ?
			false:
			true;
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement(CollisionElement element) {
		if(!test(element)) return;
		element.collision(this, null, true);
		collision(element, null,false);
	}
}
