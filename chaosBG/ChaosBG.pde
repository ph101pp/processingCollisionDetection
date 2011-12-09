import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import processing.video.*;
import java.awt.*;
import fullscreen.*;
import japplemenubar.*;
import 			java.util.*;
import damkjer.ocd.*;
///////////////////////////////////////////////////////////
chaosBG								that;
FullScreen 							fullScreen;
KinectTracker 						tracker;

int 								elementCount = 6000;
int 								depth = 10;
ArrayList<CollisionElement> 		elements = new ArrayList();


CollisionDetection					collisionDetection;
CollisionElement					element;

int 								count=0;
float 								mouseRadius;

float 								dropX=0,
									dropY=0;
			
float[]								blobPosition= new float[2];

PVector 							wind;
float 								rand=0.1;
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;
float								pressedStart,pressedFrames;
float								blobStart,blobFrames;
float								friction=0.8;
float[]								blobs;

boolean								blobPressed=false;
float								blobMoved=10;

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
  	
 	tracker = new KinectTracker(this);
	

//	Create Elements

	for (int i=0; i<elementCount; i++) {
		element=new NewChaosElement(this);
		elements.add(element);
	}
	collisionDetection = new CollisionDetection(that, elements);
}


///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
	translate(0,0,depth);
	background(255);
	count=0;
	blobs=tracker.calculateBlobs();
	environmentInfo();

//	Wind
//	if(frameCount% 30 == 0) wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
	
//	friction
	if(false) if(mouseMoved<=0 && friction > 0.0) friction-=0.005;
	else if(mouseMoved>0 && friction <= 0.9) friction+=0.01;

	collisionDetection.mapElements();
//	Collision
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		collisionDetection.testElement(element);
	}

//	Move!
	Iterator itr2 = elements.iterator(); 
	while(itr2.hasNext()) {
		element= (CollisionElement)itr2.next();
		element.move();
		element.frameCollision();
	}
}
///////////////////////////////////////////////////////////
void environmentInfo() {
//	Mouse
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);
	
	if(!mousePressed) pressedStart=frameCount;
	if(mousePressed) pressedFrames=frameCount-pressedStart;
	else pressedFrames=0;

// Blob
	blobPressed = (int(blobs[0]) > 0 && int(blobs[1]) > 0);

	if(!blobPressed) blobStart=frameCount;
	if(blobPressed) blobFrames=frameCount-blobStart;
	else blobFrames=0;
	
	
}
void stop() {
    that.tracker.kinect.quit();
  }