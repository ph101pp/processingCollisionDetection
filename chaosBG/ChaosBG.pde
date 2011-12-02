import fullscreen.*;
import japplemenubar.*;
import 			java.util.*;
import damkjer.ocd.*;
chaosBG			that;

int 			elementCount = 4000;
int 			depth = 1;
ArrayList 		elements = new ArrayList<ChaosElement>();

Collision		collision;
FullScreen fullScreen;

ChaosElement	element;

int 			count=0;
int 			countInt=0;
float 			rotation=0;
float 			mouseRadius;

float	xmag, ymag, newXmag, newYmag, diff,
		rotationX,rotationY,rotationZ;
float 		dropX=0,
			dropY=0;

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050,P3D);
	background(255);
	stroke(0);
	frameRate(15);
	noFill();
	fullScreen = new FullScreen(this); 
//	fullScreen.enter(); 
	

//	Create Elements

	for (int i=0; i<elementCount; i++) {
		element=new ChaosElement(this);
		elements.add(element);
	}
	collision = new Collision(that, elements, 50);
}
///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
	translate(0,0,0);
//	rotateX(mouseY*360/height);

	pushMatrix();
//	translate(-width/2,-height/2,(mouseX-width/2)*3);
	rotation+=0.3;
//	rotateY(rotation);
//	rotateY(rotation);
//	rotation ();
	background(255);
	count=0;

	collision.createCollisionMap();
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
	}
	
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
