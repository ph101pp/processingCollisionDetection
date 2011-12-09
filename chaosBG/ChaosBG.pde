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

///////////
int 								elementCount = 6000;
int 								depth = 10;
float								globalFriction=0.8;
///////////

ArrayList<CollisionElement> 		elements = new ArrayList();
CollisionDetection					collisionDetection;
CollisionElement					element;
int									globalDisturbance=0;

			
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;


float								blobStart,blobFrames;
float[]								blobs = {0,0};

boolean								blobPressed=false;
float								blobMoved=10;
MouseElement						mouseElement=null;
///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050,P3D);
	background(255);
	stroke(0);
	frameRate(15);
	noFill();

	elementCount=int(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=int(map(width*height, 0,1680*1050 ,0, depth));

 //	tracker = new KinectTracker(this);
	fullScreen = new FullScreen(this); 
//	fullScreen.enter(); 
  	
	

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
//	blobs=tracker.calculateBlobs();
	environment();

	mouseElement();
	
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
void mouseElement() {
	if(mousePressed && mouseElement==null) {
		mouseElement =new MouseElement(that);
		collisionDetection.addElement(mouseElement);
		globalDisturbance=int(random(0,3));
	}
	else if(mousePressed && mouseElement != null) {
		mouseElement.move();
	}
	else if(!mousePressed && mouseElement != null) {
		collisionDetection.elements.remove(mouseElement);
		mouseElement = null;
	}
}
///////////////////////////////////////////////////////////
void environment() {
//	friction
	if(true) if(mouseMoved<=0 && globalFriction > 0.0) globalFriction-=0.005;
	else if(mouseMoved>0 && globalFriction <= 0.9) globalFriction+=0.01;

//	Mouse
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);

// Blob
	blobPressed = (int(blobs[0]) > 0 && int(blobs[1]) > 0);
	if(!blobPressed) blobStart=frameCount;
	if(blobPressed) blobFrames=frameCount-blobStart;
	else blobFrames=0;
	
	globalDisturbance--;	
}
///////////////////////////////////////////////////////////
void stop() {
    that.tracker.kinect.quit();
  }