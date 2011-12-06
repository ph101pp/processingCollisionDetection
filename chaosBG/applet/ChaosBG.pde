import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import processing.video.*;
import java.awt.*;
import fullscreen.*;
import japplemenubar.*;
import 			java.util.*;
import damkjer.ocd.*;
chaosBG			that;

int 			elementCount = 4000;
int 			depth = 80;
ArrayList 		elements = new ArrayList<ChaosElement>();

Collision		collision;
FullScreen fullScreen;
KinectTracker tracker;

ChaosElement	element;

int 			count=0;
int 			countInt=0;
float 			rotation=0;
float 			mouseRadius;

float	xmag, ymag, newXmag, newYmag, diff,
		rotationX,rotationY,rotationZ;
float 		dropX=0,
			dropY=0;
			
float[]		blobPosition= new float[2];

PVector		mousePos=new PVector(mouseX,mouseY);
boolean		mouseMoved;

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1000,800,P3D);
	background(255);
	stroke(0);
	frameRate(15);
	noFill();
	fullScreen = new FullScreen(this); 
//	fullScreen.enter(); 
  	
 // 	tracker = new KinectTracker(this);
	

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
//	blobPosition=tracker.calculateBlobs();
	pushMatrix();
//	translate(-width/2,-height/2,(mouseX-width/2)*3);
	rotation+=0.3;
//	rotateY(rotation);
//	rotateY(rotation);
//	rotation ();
	background(255);
	count=0;
	
	if(PVector.dist(mousePos,new PVector(mouseX, mouseY)) >0 ) mouseMoved=true;
	else mouseMoved=false;

	collision.createCollisionMap();
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
		element.location.add(element.velocity);
	//	element.velocity= new PVector(0,0,0);
	}
	
	
//	noLoop();
//	camera1.feed();
	popMatrix();
	mousePos=new PVector(mouseX,mouseY);
}
