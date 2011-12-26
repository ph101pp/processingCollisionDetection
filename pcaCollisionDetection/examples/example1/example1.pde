import pcaCollisionDetection.*;
import java.awt.Color;
////////////////////////////////////////////////////////////////////////////////
CollisionDetection 					collisionDetection;
ArrayList<CollisionElement> 		circles;
int									circleCount=5;
ElementCircle						circle;
ElementMouse						mouse = new ElementMouse();
////////////////////////////////////////////////////////////////////////////////
void setup() {
	size(800,600);
	noStroke();
	ellipseMode(CENTER);
	
	circles = new ArrayList<CollisionElement>();
	
	for(int i=0; i<circleCount; i++) circles.add(new ElementCircle(this));

	collisionDetection = new CollisionDetection(this, circles);
}
////////////////////////////////////////////////////////////////////////////////
void draw(){
	background(255);

	collisionDetection.testElement(mouse);

	for(int i=0; i<circles.size(); i++) {
		circle= (ElementCircle) circles.get(i);
		circle.draw();
	}
	mouse.draw();
}
////////////////////////////////////////////////////////////////////////////////
void mouseReleased() {
	setup();
}
