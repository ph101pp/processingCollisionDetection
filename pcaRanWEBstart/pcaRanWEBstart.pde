import geomerative.*;
///////////////////////////////////////////////////////////
pcaRanWEBstart								that;

///////////
//int 								elementCount = 6000;
//int 								depth = 10;
int 								elementCount = 2000;
int 								depth = 1;
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

ElementBlob							ran;

boolean								record=false;
boolean								loop=true;


		Data data= new Data();

///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050,P3D);
//	size(1280,720,P3D);
	background(255);
	stroke(0);
//	frameRate(10);
	noFill();
	ran=new ElementBlob(this, new PVector(width/2, height/2), 300);
	elementCount=int(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=int(map(width*height, 0,1680*1050 ,0, depth));
	

	RG.init(this);
 	RG.ignoreStyles(false);
 	RG.setPolygonizer(RG.ADAPTATIVE);
 	ranShape = RG.loadShape("data/ran.svg");
  	ranShape.centerIn(g, 100, 1, 1);
 	ranShape.scale(0.4);
 	ranShape.translate(width/2,height/2);

		
		data.beginSave();

//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elementN=new ElementChaos(this);
		elementN.ranPoint=new PVector(elementN.location.x,elementN.location.y,0);

		while(!ranShape.contains(elementN.ranPoint.x,elementN.ranPoint.y))
			elementN.ranPoint = new PVector (random(width), random(height),random(depth));
		elements.add(elementN);
		
		
		data.add(elementN.ranPoint.x);
		data.add(elementN.ranPoint.y);
		data.add("-----------------");

	}
	collisionDetection = new CollisionDetection(this, elements);
			
	
}
///////////////////////////////////////////////////////////
void draw() {
		data.endSave(
				sketchPath(java.io.File.separator+"ranPoints.txt")
		);
		noLoop();
	println(frameRate);
	translate(0,0,depth);
	background(255);
// 	ranShape.draw();
	
//	Collide the shit out of it.
	Iterator itr = elements.iterator(); 
	int k=0;
	while(itr.hasNext()) {
		element= (CollisionElement)itr.next();
		
		if(ran!=null)
			if( k > map(min(abs(frameCount-ran.startFrame),6), 0,6, elementCount, 1000))
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
//			if((!elementN.test(ran) || PVector.dist(elementN.location, elementN.ranPoint) <= 5) && k>400) {
			if(elementN.test(ran) && k>600) {
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
