import geomerative.*;
import pcaCollisionDetection.*;

///////////////////////////////////////////////////////////
pcaRanWEB								that;

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
ArrayList<ElementLorenz> 			lorenzElements = new ArrayList();
CollisionDetection					collisionDetection;
CollisionElement					element;
ElementChaos						elementN;
ElementLorenz						elementL;
int									globalDisturbance=0;
ElementBlob							mouseElement=null;

			
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;

boolean								movement=false;
boolean								lorenzMovement=false;

RShape								ranShape;

ElementBlob							ran=null;

boolean								record=false;
boolean								loop=true;
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
	

	RG.init(this);
 	RG.ignoreStyles(false);
 	RG.setPolygonizer(RG.ADAPTATIVE);
 	ranShape = RG.loadShape("data/ran.svg");
  	ranShape.centerIn(g, 100, 1, 1);
 	ranShape.scale(map(width*height, 1280*720,1680*1050 ,0.8, 0.5));
 	ranShape.translate(width/2+20,height/2);

//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elementN=new ElementChaos(this);
		elementN.ranPoint=new PVector(elementN.location.x,elementN.location.y,0);

		while(!ranShape.contains(elementN.ranPoint.x,elementN.ranPoint.y))
			elementN.ranPoint = new PVector (random(width), random(height),random(depth));
		elements.add(elementN);
	}
	collisionDetection = new CollisionDetection(this, elements);
}
///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
	translate(0,0,depth);
	background(255);
// 	ranShape.draw();
	environment();
	movement=false;
	lorenzMovement=false;

	mouseElement();
	
//	Mouse 'n' Blobs
	Iterator itr0 = lorenzElements.iterator();
	for(int i=lorenzElements.size()-1; i>=0; i--) {
		elementL= (ElementLorenz) lorenzElements.get(i);
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
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		
		if(ran!=null)
			if( k > map(min(abs(frameCount-ran.startFrame),6), 0,6, elementCount, 400))
				if(element.test(ran)) continue;

		collisionDetection.testElement(element);
		k++;
	}

//	Move!
	Iterator itr2 = elements.iterator(); 
	k=0;
	while(itr2.hasNext()) {
		elementN= (ElementChaos)itr2.next();

		if(ran!=null)
			if((!elementN.test(ran) || PVector.dist(elementN.location, elementN.ranPoint) <= 5) && k>400) {
		//	if(elementN.test(ran) && k>400) {
				do {
					ran.moved=1;
					elementN.testElement(ran);
					elementN.moveNormal();
				}
				while(elementN.test(ran));
				frame(elementN);
				continue;
			}
			
		elementN.move();
		if(elementN.lorenz==null) frame(elementN);
		elementN.lorenz=null;
		k++;
	}
}
///////////////////////////////////////////////////////////
void mouseElement() {
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);
	if(mouseMoved > 0) movement=true;

	if(mousePressed && mouseElement==null && ran==null) {
		mouseElement =new ElementBlob(that, new PVector(mouseX,mouseY));
		collisionDetection.addElement(mouseElement);
//		globalDisturbance=int(random(0,3));
	}
	else if(mousePressed && mouseElement != null) {
		mouseElement.move(new PVector(mouseX,mouseY));
	}
	else if(!mousePressed && mouseElement != null) {
		mouseElement.finalize();
		collisionDetection.remove(mouseElement);
		mouseElement = null;
	}
}
///////////////////////////////////////////////////////////
void environment() {
//	friction
	if(ran==null) {
		if(!movement && (!lorenzMovement || globalFriction > 0.6) && globalFriction > 0.0) globalFriction-=0.005;
		else if((movement || lorenzMovement) && ((globalFriction <= 0.85 && !lorenzMovement) || globalFriction <= 0.75)) globalFriction+=0.08;
	}
	globalDisturbance--;	
}
///////////////////////////////////////////////////////////
void frame(ElementChaos element) {
	float border =  30;

	if(element.location.x < 0-border) {
		element.location.x*=-1;
	}
	else if(element.location.x > width+border) {
		element.location.x= width+border-(element.location.x-width+border);
	}
	if(element.location.y < 0-border) {
		element.location.y*=-1;
	}
	else if(element.location.y > height+border) {
		element.location.y= height+border-(element.location.y-height+border);
	}
	if(element.location.z < 0-border) {
		element.location.z*=-1;
	}
	else if(element.location.z > depth) {
		element.location.z= depth-(element.location.z-depth);
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
	switch(keyCode) {
		case 10: //Enter
			ran=ran!=null?
				null:
				new ElementBlob(this, new PVector(width/2, height/2), 400);
				globalFriction=0.81;
		break;		
		case 32: //Space
			if(loop) {
				noLoop();
				loop=false;
			}
			else {
				loop();
				loop=true;
			}
		break;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
