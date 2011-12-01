import 			java.util.*;
import damkjer.ocd.*;
Camera 			camera1;
chaosBG			that;

int 			elementCount = 10000;
ArrayList 		elements = new ArrayList<ChaosElement>();

Collision		collision;
Collision		newCollision;

ChaosElement	element;

int 			count=0;
int 			countInt=0;
float 			rotation=0;
float 			mouseRadius;

float	xmag, ymag, newXmag, newYmag, diff,
		rotationX,rotationY,rotationZ;

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1000,1000,P3D);
	collision = new Collision(that, 30);
	background(255);
	stroke(0);
	noFill();
	
	camera1 = new Camera(this, width/2, height/2, 0, width, height/2, 0);

//	Create Elements

	pushMatrix();
	for (int i=0; i<elementCount; i++) {
		element=new ChaosElement(this);
		elements.add(element);
		collision.add(element);
	}
	popMatrix();
}
///////////////////////////////////////////////////////////
void draw() {
//	translate(width/2,height/2,0);
//	rotateX(mouseY*360/height);

	pushMatrix();
//	translate(-width/2,-height/2,(mouseX-width/2)*3);
	rotation+=0.3;
//	rotateY(rotation);
//	rotateY(rotation);
//	rotation ();
	background(255);
	count=0;
	newCollision = new Collision(that,30);
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
	}
	
	collision = newCollision;
//	noLoop();
//	camera1.feed();
	popMatrix();
}
void rotation () {
//	rotationY=obj.rotation[1]+0.5;
	newXmag = mouseX/float(width) * TWO_PI;
	newYmag = mouseY/float(height) * TWO_PI;

	if(mousePressed) {
		
		diff = xmag-newXmag;
		if (abs(diff) >  0.01) rotationY -= degrees(diff/1.0);
	
		diff = ymag-newYmag;
		if (abs(diff) >  0.01) rotationX += degrees(diff/1.0);
		
	}
	
	xmag=newXmag;
	ymag=newYmag;
	rotateX(rotationX);
	rotateY(rotationY);
	rotateZ(rotationZ);

}
