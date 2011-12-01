import 			java.util.*;

chaosBG			that;
int 			elementCount = 5000;
ArrayList 		elements = new ArrayList<ChaosElement>();

Collision		collision;
Collision		newCollision;

ChaosElement	element;

int 			count=0;
int 			countInt=0;

float 			mouseRadius;
///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(500,500,P3D);
	collision = new Collision(that, 30);
	background(255);
	stroke(0);
	noFill();
	

//	Create Elements
	for (int i=0; i<elementCount; i++) {
		element=new ChaosElement(this);
		elements.add(element);
		collision.add(element);
	}

	
}
///////////////////////////////////////////////////////////
void draw() {
	background(255);
	count=0;
	newCollision = new Collision(that,30);
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
	}
	
	collision = newCollision;
//	noLoop();
	
}
