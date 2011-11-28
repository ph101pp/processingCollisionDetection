import 			java.util.*;

chaosBG			that;
int 			elementCount = 100000;
ArrayList 		elements = new ArrayList<ChaosElement>();

ChaosElement	element;

int 			count=0;
int 			countInt=0;

float 			mouseRadius;
///////////////////////////////////////////////////////////
void setup() {
	that = this;
	size(500,500,P3D);
	background(255);
	stroke(0);
	noFill();
	

//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elements.add(new ChaosElement(this));
	}

	
}
///////////////////////////////////////////////////////////
void draw() {
	background(255);
	count=0;

//	Create Lines	
	Collections.sort(elements, new Mover(that));
	Collections.sort(elements, new CreateLines(that));
	
	
}
