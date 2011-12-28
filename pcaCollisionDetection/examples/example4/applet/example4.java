import processing.core.*; 
import processing.xml.*; 

import pcaCollisionDetection.*; 
import java.awt.Color; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class example4 extends PApplet {



////////////////////////////////////////////////////////////////////////////////
CollisionDetection 					collisionDetection;
ArrayList<CollisionElement> 		elements = new ArrayList<CollisionElement>();
int									elementCount=2000;
CollisionElement					element;
ElementChaos						elementC;

ElementMouse						mouse = new ElementMouse();
float								globalFriction=0.85f;
////////////////////////////////////////////////////////////////////////////////
public void setup() {
	size(1024,768, P3D);
	stroke(0);
	frameRate(25);
	ellipseMode(CENTER);
	
	elements = new ArrayList<CollisionElement>();
	for(int i=0; i<elementCount; i++) elements.add(new ElementChaos(this));
	collisionDetection = new CollisionDetection(this, elements);
}
////////////////////////////////////////////////////////////////////////////////
public void draw(){
	println(frameRate);
	background(255);
	translate(0,0,200);
	
	if(mousePressed) mouse.setActionRadius(300);
	else mouse.setActionRadius(100);
	
	collisionDetection.testElement(mouse);

//	Collide
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		collisionDetection.testElement(element);
	}

//	Move!
	Iterator itr2 = elements.iterator(); 
	while(itr2.hasNext()) {
		elementC= (ElementChaos)itr2.next();
		elementC.draw();
		frame(elementC);
	}
	mouse.draw();
}
////////////////////////////////////////////////////////////////////////////////
public void frame(ElementChaos element) {
	float border =  10;
	if(element.location.x < 0-border) {
		element.location.x*=-1;
	}
	else if(element.location.x > width+border) {
		element.location.x= width+border-(element.location.x-width+border);
	}
	if(element.location.y < 0-border) {
		element.location.y*=-1;
	}
	else if(element.location.y > height+border) {
		element.location.y= height+border-(element.location.y-height+border);
	}
}	
////////////////////////////////////////////////////////////////////////////////
class ElementChaos extends CollisionElement {

	example4						that;
	float 							defaultRadius=25;
	float							pushForce=5;
	PVector							newVelocity;
///////////////////////////////////////////////////////////
	ElementChaos(example4 that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height));
	}
	ElementChaos(example4 that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height));
	}
	
///////////////////////////////////////////////////////////
	public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement) {
		float distance=PVector.dist(location, element.location);

		newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(map(distance, 0,(actionRadius+element.actionRadius),pushForce,0));		

		velocity.add(newVelocity);

		if(testedElement) {
			fill(random(10,250),random(10,250),random(10,250));
			line(location.x,location.y,element.location.x,element.location.y);
		}
	}
///////////////////////////////////////////////////////////
	public void draw() {	
  		velocity.mult(that.globalFriction);
		location.add(velocity);
	}
}

class ElementMouse extends CollisionElement{
////////////////////////////////////////////////////////////////////////////////
	public ElementMouse(){	
		location = new PVector (mouseX, mouseY);
		actionRadius= 100;
	}
////////////////////////////////////////////////////////////////////////////////
	public void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {}
////////////////////////////////////////////////////////////////////////////////
	public void draw() {
		location = new PVector (mouseX, mouseY);
	}
////////////////////////////////////////////////////////////////////////////////
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "example4" });
  }
}
