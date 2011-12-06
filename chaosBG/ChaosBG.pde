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

int 			elementCount = 6000;
int 			depth = 10;
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

PVector 	wind;
float 		rand=0.1;
PVector		mousePos=new PVector(mouseX,mouseY);
float		mouseMoved;
float		pressedStart,pressedFrames;
float		friction=0.8;

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1080,P3D);
	background(255);
	stroke(0);
	frameRate(15);
	noFill();
	fullScreen = new FullScreen(this); 
	fullScreen.enter(); 
  	
 // 	tracker = new KinectTracker(this);
	

//	Create Elements

	for (int i=0; i<elementCount; i++) {
		element=new ChaosElement(this);
		elements.add(element);
	}
	collision = new Collision(that, elements, 50);
    wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
}


///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
	translate(0,0,depth);
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
	
	if(frameCount% 30 == 0) wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));

	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	
	if(!mousePressed) pressedStart=frameCount;
	if(mousePressed) pressedFrames=frameCount-pressedStart;
	else pressedFrames=0;
	
	
	if(mouseMoved>0 && friction > 0.5) friction-=0.001;
	
	collision.createCollisionMap();
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
		element.move();
		collision.testFrame(element);
	//	element.velocity= new PVector(0,0,0);
	}
	
	
//	noLoop();
//	camera1.feed();
	popMatrix();
	mousePos=new PVector(mouseX,mouseY);
}