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
ElementBounce					bouncy = new ElementBounce();

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
	collisionDetection.add(bouncy);
	collisionDetection.add(mouse);
}
////////////////////////////////////////////////////////////////////////////////
void draw(){
	background(255);
	
	for(int i=0; i<gridElements.size(); i++){
		gridElement=(ElementGrid) gridElements.get(i);
		gridElement.draw();
	}
	collisionDetection.testElement(bouncy);
	collisionDetection.testElement(mouse);
	mouse.draw();
	bouncy.draw();
}
