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
ArrayList<CollisionElement> 		collisionElements = new ArrayList();


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
float[]								blobs = {0,0};

boolean								blobPressed=false;
float								blobMoved=10;
MouseElement						mouseElement=null;

boolean								disturbance=false;

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050,P3D);
	
	elementCount=int(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=int(map(width*height, 0,1680*1050 ,0, depth));
	
	background(255);
	stroke(0);
	frameRate(15);
	noFill();
	fullScreen = new FullScreen(this); 
//	fullScreen.enter(); 
  	
 //	tracker = new KinectTracker(this);
	

//	Create Elements

	for (int i=0; i<elementCount; i++) {
		element=new NewChaosElement(this);
		collisionElements.add(element);
	}
	collisionDetection = new CollisionDetection(that, collisionElements);
}


///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
	translate(0,0,depth);
	background(255);
	count=0;
//	blobs=tracker.calculateBlobs();
	environmentInfo();

//	Wind
//	if(frameCount% 30 == 0) wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
	
//	friction
	if(true) if(mouseMoved<=0 && friction > 0.0) friction-=0.005;
	else if(mouseMoved>0 && friction <= 0.9) friction+=0.01;

	if(mousePressed && mouseElement==null) {
		mouseElement =new MouseElement(that);
		collisionDetection.addElement(mouseElement);
	}
	else if(mousePressed && mouseElement != null) {
		mouseElement.move();
	}
	else if(!mousePressed && mouseElement != null) {
		collisionDetection.elements.remove(mouseElement);
		mouseElement = null;
	}
	
	collisionDetection.mapElements();
	
//	Collision
	Iterator itr = collisionElements.iterator(); 
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		collisionDetection.testElement(element);
	}

//	Move!
	Iterator itr2 = collisionElements.iterator(); 
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

// Blob
	blobPressed = (int(blobs[0]) > 0 && int(blobs[1]) > 0);
	if(!blobPressed) blobStart=frameCount;
	if(blobPressed) blobFrames=frameCount-blobStart;
	else blobFrames=0;
	
	
}
void stop() {
    that.tracker.kinect.quit();
  }