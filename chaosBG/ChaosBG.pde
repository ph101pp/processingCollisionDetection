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
boolean								kinect = false;
///////////

ArrayList<CollisionElement> 		elements = new ArrayList();
ArrayList<LorenzElement> 			lorenzElements = new ArrayList();
CollisionDetection					collisionDetection;
CollisionElement					element;
NewChaosElement						elementN;
LorenzElement						elementL;
int									globalDisturbance=0;

			
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;
boolean								movement=false;
boolean								lorenzMovement=false;

float								blobStart,blobFrames;
float[]								blobs = {0,0};

boolean								blobPressed=false;
float								blobMoved=10;
MouseElement						mouseElement=null;


///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1280,1024,P3D);
	background(255);
	stroke(0);
	frameRate(25);
	noFill();

	elementCount=int(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=int(map(width*height, 0,1680*1050 ,0, depth));

	if(kinect) tracker = new KinectTracker(this);
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
	if(kinect) blobs=tracker.calculateBlobs();
	environment();
	movement=false;
	lorenzMovement=false;
	mouseElement();
	
	collisionDetection.mapElements();
	

//	Mouse 'n' Blobs
	Iterator itr0 = lorenzElements.iterator();
	for(int i=lorenzElements.size()-1; i>=0; i--) {
		elementL= (LorenzElement) lorenzElements.get(i);
		if(elementL.moved==false) elementL.allSet=true;
		elementL.moved=false;
		collisionDetection.testElement(elementL);
		elementL.move();
	}
//	Collide the shit out of it.
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		collisionDetection.testElement(element);
	}

//	Move!
	Iterator itr2 = elements.iterator(); 
	while(itr2.hasNext()) {
		elementN= (NewChaosElement)itr2.next();
		elementN.move();
		if(elementN.lorenz==null ) frame(elementN);
		elementN.lorenz=null;
	}
	

}
///////////////////////////////////////////////////////////
void mouseElement() {
	if(mousePressed && mouseElement==null) {
		mouseElement =new MouseElement(that);
		collisionDetection.addElement(mouseElement);
//		globalDisturbance=int(random(0,3));
	}
	else if(mousePressed && mouseElement != null) {
		mouseElement.move();
	}
	else if(!mousePressed && mouseElement != null) {
		mouseElement.finalize();
		collisionDetection.elements.remove(mouseElement);
		mouseElement = null;
	}
}
///////////////////////////////////////////////////////////
void environment() {
//	Mouse
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);
	if(mouseMoved > 0) movement=true;

//	friction
	if(!movement && (!lorenzMovement || globalFriction > 0.6) && globalFriction > 0.0) globalFriction-=0.005;
	else if((movement || lorenzMovement) && ((globalFriction <= 0.85 && !lorenzMovement) || globalFriction <= 0.75)) globalFriction+=0.08;

// Blob
	blobPressed = (int(blobs[0]) > 0 && int(blobs[1]) > 0);
	if(!blobPressed) blobStart=frameCount;
	if(blobPressed) blobFrames=frameCount-blobStart;
	else blobFrames=0;
	
	globalDisturbance--;	
}
///////////////////////////////////////////////////////////
void frame(NewChaosElement element) {
	NewChaosElement thisElement = (NewChaosElement) element;
	
	float border =  30;
	if(element.location.x < 0-border) {
		element.location.x*=-1;
//			element.velocity.x*=-1;
//			element.velocity.add(new PVector(0,force/2,0));
	}
	else if(element.location.x > width+border) {
		element.location.x= width+border-(element.location.x-width+border);
//			element.velocity.x= width+border-(element.velocity.x-width+border);
//			element.velocity.add(new PVector(-force/2,0,0));
	}
	if(element.location.y < 0-border) {
		element.location.y*=-1;
//			element.velocity.y*=-1;
//			element.velocity.add(new PVector(0,force/2,0));
	}
	else if(element.location.y > height+border) {
		element.location.y= height+border-(element.location.y-height+border);
//			element.velocity.y= height+border-(element.velocity.y-height+border);
//			element.velocity.add(new PVector(0,-force/2,0));
	}
	if(element.location.z < 0-border) {
		element.location.z*=-1;
//			element.velocity.z*=-1;
//			element.velocity.add(new PVector(0,0,force/2));
	}
	else if(element.location.z > depth) {
		element.location.z= depth-(element.location.z-depth);
//			element.velocity.z= maxZ-(element.velocity.z-maxZ);
//			element.velocity.add(new PVector(0,0,-force/2));
	}
}	
void stop() {
    that.tracker.kinect.quit();
  }