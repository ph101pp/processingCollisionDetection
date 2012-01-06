///////////////////////////////////////////////////////////
pcaRanWEBjs								that;

///////////
//int 								elementCount = 6000;
//int 								depth = 10;
int 								elementCount =300;
int 								depth = 1;
//int 								elementCount = 5500;
//int 								depth = 5;
float								globalFriction=0.8;
boolean								kinect = false;
///////////

ArrayList<CollisionElement> 		elements = new ArrayList();
CollisionDetection					collisionDetection;
CollisionElement					element;
ElementChaos						elementN;
int									globalDisturbance=0;
ElementBlob							mouseElement=null;

			
PVector								mousePos=new PVector(mouseX,mouseY);
float								mouseMoved;

boolean								movement=false;
boolean								lorenzMovement=false;

ElementBlob							ran;

boolean								record=false;
boolean								loop=true;


Data data= new Data();


float		zoom =0.8;
PVector 		shift=new PVector(170,100);
///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(1680,1050);
//	size(1280,720,P3D);
	background(255);
	stroke(0);
	noFill();
	frameRate(9);
	ran=new ElementBlob(this, new PVector(1680/2, 1050/2), 200);
	
	data.load("ranPoints.txt");
//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elementN=new ElementChaos(this);
		elementN.ranPoint=new PVector(data.readFloat()*zoom+shift.x,data.readFloat()*zoom+shift.y);
		
		data.readString();
		elements.add(elementN);
	}
	collisionDetection = new CollisionDetection(this, elements);
	
}
///////////////////////////////////////////////////////////
void draw() {
	println(frameRate);
//	translate(-840+500/2,-525+500/2);
	background(255);
// 	ranShape.draw();
	collisionDetection.remapElements();	
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
			if(elementN.test(ran) && k>550) {
				do {
					ran.moved=1;
					elementN.testElement(ran);
					elementN.moveNormal();
				}
				while(elementN.test(ran));
				frame(elementN);
				continue;
			}
			
		elementN.moveRan();
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
