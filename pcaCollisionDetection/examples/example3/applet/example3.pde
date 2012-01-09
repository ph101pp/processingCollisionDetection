import pcaCollisionDetection.*;
import geomerative.*;
import java.awt.Color;
////////////////////////////////////////////////////////////////////////////////
int								gridSize=30;
ArrayList<CollisionElement>	gridElements;
float							x,y;

CollisionDetection				collisionDetection;
ElementGrid						gridElement;
ElementMouse					mouse = new ElementMouse();

////////////////////////////////////////////////////////////////////////////////
void setup() {
	size(900,600);
	noStroke();
	ellipseMode(CENTER);
	rectMode(CENTER);
	RG.init(this);


	gridElements=new ArrayList<CollisionElement>();
	for(int i=0; i*gridSize <= width-gridSize; i++) 
		for(int k=0; k*gridSize <= height-gridSize; k++) {
			x=gridSize/2+i*gridSize;
			y=gridSize/2+k*gridSize;
			gridElements.add(new ElementGrid(this, x, y));
		}
	collisionDetection = new CollisionDetection(this, gridElements);
}
////////////////////////////////////////////////////////////////////////////////
void draw(){
	background(255);
	
	collisionDetection.testElement(mouse);
	for(int i=0; i<gridElements.size(); i++){
		gridElement=(ElementGrid) gridElements.get(i);
		gridElement.draw();
	}
	mouse.draw();
}
