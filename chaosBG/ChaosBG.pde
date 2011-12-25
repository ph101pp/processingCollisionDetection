/*import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import processing.video.*;
import java.awt.*;
import damkjer.ocd.*;
*/
import fullscreen.*;
import japplemenubar.*;
import SimpleOpenNI.*;
import geomerative.*;
import processing.dxf.*;

///////////////////////////////////////////////////////////
chaosBG								that;
FullScreen 							fullScreen;

///////////
int 								elementCount = 6000;
int 								depth = 10;
//int 								elementCount = 5800;
//int 								depth = 8;
//int 								elementCount = 5500;
//int 								depth = 5;
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
BlobElement							mouseElement=null;

			
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;

boolean								movement=false;
boolean								lorenzMovement=false;

KinectListener      				kinectListener;
RShape								ranShape;

boolean 							ran=true;
float								ranStop;

boolean								record=false;
///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050,P3D);
//	size(1280,720,P3D);
	background(255);
	stroke(0);
	frameRate(17);
	noFill();

	elementCount=int(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=int(map(width*height, 0,1680*1050 ,0, depth));
	fullScreen = new FullScreen(this); 
	fullScreen.setShortcutsEnabled(true);
	
	if(kinect) kinectListener = new KinectListener(this, new SimpleOpenNI(this));



	RG.init(this);
 	RG.ignoreStyles(false);
 	RG.setPolygonizer(RG.ADAPTATIVE);
 	ranShape = RG.loadShape("data/ran.svg");
  	ranShape.centerIn(g, 100, 1, 1);
 	ranShape.scale(map(width*height, 1280*720,1680*1050 ,0.8, 0.5));
 	ranShape.translate(width/2,height/2);

  	
	

//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elementN=new NewChaosElement(this);
		
		while(!ranShape.contains(elementN.location.x,elementN.location.y))
			elementN.location = new PVector (random(width), random(height),random(depth));
		elementN.ranPoint=new PVector(elementN.location.x,elementN.location.y,0);
		elements.add(elementN);
	}
	collisionDetection = new CollisionDetection(elements);
}
///////////////////////////////////////////////////////////
void draw() {
	if(record) beginRaw(DXF, "output.dxf");
	
	println(frameRate);
	translate(0,0,depth);
	background(255);
// 	ranShape.draw();
	environment();
	movement=false;
	lorenzMovement=false;
	//Kinect
	if(kinect) kinectListener.update();
	else mouseElement();
	
	collisionDetection.mapElements();
	

//	Mouse 'n' Blobs
	Iterator itr0 = lorenzElements.iterator();
	for(int i=lorenzElements.size()-1; i>=0; i--) {
		elementL= (LorenzElement) lorenzElements.get(i);
		if(elementL.moved==false) {
			elementL.allSet=true;
		}
		elementL.moved=false;
		collisionDetection.testElement(elementL);
		elementL.move();
	}
//	Collide the shit out of it.
	Iterator itr = elements.iterator(); 
	int k=0;
	while(itr.hasNext() && (false || !ran || k<=300)) {
		element= (CollisionElement)itr.next();
		collisionDetection.testElement(element);
		k++;
	}


//	Move!
	Iterator itr2 = elements.iterator(); 
	k=0;
	while(itr2.hasNext() && (true || !ran || k<=1000)) {
		elementN= (NewChaosElement)itr2.next();
		elementN.move();
		if(elementN.lorenz==null ) frame(elementN);
		elementN.lorenz=null;
		k++;
	}

  // do all your drawing here
	if(record) {
		endRaw();
	    record = false;
	}	
}
///////////////////////////////////////////////////////////
void mouseElement() {
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);
	if(mouseMoved > 0) movement=true;

	if(mousePressed && mouseElement==null) {
		mouseElement =new BlobElement(that, new PVector(mouseX,mouseY));
		collisionDetection.addElement(mouseElement);
//		globalDisturbance=int(random(0,3));
	}
	else if(mousePressed && mouseElement != null) {
		mouseElement.move(new PVector(mouseX,mouseY));
	}
	else if(!mousePressed && mouseElement != null) {
		mouseElement.finalize();
		collisionDetection.elements.remove(mouseElement);
		mouseElement = null;
	}
}
///////////////////////////////////////////////////////////
void environment() {
//	friction
	if(!ran) {
		if(!movement && (!lorenzMovement || globalFriction > 0.6) && globalFriction > 0.0) globalFriction-=0.005;
		else if((movement || lorenzMovement) && ((globalFriction <= 0.85 && !lorenzMovement) || globalFriction <= 0.75)) globalFriction+=0.08;
	}
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

/////////////////////////////////////////////////////////////////////////////////////////////////////
// session callbacks
void onStartSession(PVector pos) {
	println("onStartSession: " + pos);
}

void onEndSession() {
	println("onEndSession: ");
}

void onFocusSession(String strFocus,PVector pos,float progress) {
	println("onFocusSession: focus=" + strFocus + ",pos=" + pos + ",progress=" + progress);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
void keyPressed() {
	switch(key) {
		case 'e':
			// end sessions
			if(kinect) kinectListener.endSession();
		break;
		case 'r':
			// end sessions
			record = true;
		break;
		case ' ':
			ran=!ran;
			globalFriction=0.7;
		break;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
