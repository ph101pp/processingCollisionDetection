package pcaCollisionDetection;
import processing.core.PVector;
/**
*	Any object that shall be tested with the collisionDetection Object needs to inherit from this class.
*/
abstract public class CollisionElement {
////////////////////////////////////////////////////////////////////////////////
/**
*	Vector to the location of this element.
*/
	public PVector 								location = new PVector(0,0,0);
/**
*	Elements within this radius will cause a call of the collision() function.
*/
	public float 								actionRadius;
////////////////////////////////////////////////////////////////////////////////
/**
*	Is called if there is a collision with any other collisionElement.
*	This function has to be defined by the element class that is inheriting from the CollisionElement.
*	
@param 	element			CollisionElement that is colliding with this element.
@param	collisionMap	CollisionMap instance that contains the element that is colliding with this one.
@param	testedElement	Is true if this is the element that is tested against the set of elements 
						within the CollisionDetection instance.
*
@param 	actionRadius	New actionRadius.
*/
	abstract public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement);
////////////////////////////////////////////////////////////////////////////////
/**
*	Sets the actionRadius of this CollisionElement. Elements within this radius will cause a call of the collision() function.
*
@param 	actionRadius	New actionRadius.
*/
	public void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	The passed CollisionElement is tested against this CollisionElement for collision.
*
@param 	element		CollisionElement that is tested against this.
@return		Returns true if the elements are colliding, false if not.
*/
	public boolean test(CollisionElement element) {
		return this.equals(element) || PVector.dist(element.location, location) > (actionRadius+element.actionRadius) ?
			false:
			true;
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	The passed CollisionElement is tested against this CollisionElement for collision.
*	The collision() function is called if there is a collision.
*
@param 	element		CollisionElement that is tested against this.
*/
	public void testElement(CollisionElement element) {
		if(!test(element)) return;
		element.collision(this, null, true);
		collision(element, null,false);
	}
}
