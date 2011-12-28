import pcaCollisionDetection.*;
import java.awt.Color;
////////////////////////////////////////////////////////////////////////////////
CollisionDetection 					collisionDetection;
ArrayList<CollisionElement> 		elements = new ArrayList<CollisionElement>();
int									elementCount=2000;
CollisionElement					element;
ElementChaos						elementC;

ElementMouse						mouse = new ElementMouse();
float								globalFriction=0.85;
////////////////////////////////////////////////////////////////////////////////
void setup() {
	size(1024,768, P3D);
	stroke(0);
	frameRate(25);
	ellipseMode(CENTER);
	
	elements = new ArrayList<CollisionElement>();
	for(int i=0; i<elementCount; i++) elements.add(new ElementChaos(this));
	collisionDetection = new CollisionDetection(this, elements);
}
////////////////////////////////////////////////////////////////////////////////
void draw(){
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
void frame(ElementChaos element) {
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
