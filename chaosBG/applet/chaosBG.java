import processing.core.*; 
import processing.xml.*; 

import java.util.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class chaosBG extends PApplet {



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
public void setup() {
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
public void draw() {
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
class ChaosElement {
	chaosBG that;
	
	PVector location;
	PVector	velocity;
	int		lineCount=0;
///////////////////////////////////////////////////////////
	ChaosElement(chaosBG that_) {
		that=that_;
		location = new PVector (random(width), random(height),random(50));
		velocity = new PVector (0,0,0);
	}
///////////////////////////////////////////////////////////
	public void draw() {
		pushMatrix();
			translate(location.x, location.y, location.z);
			fill(0,0,0,100);
			box(1);
			noFill();
		popMatrix();	
	}
}
class Collision {
	chaosBG			that;
	float 			gridSize; 
	Iterator		itr;
	ChaosElement	testElement;
	float			distance;

	ArrayList<ChaosElement>[][] elements;
///////////////////////////////////////////////////////////
    Collision (chaosBG that_, float gridSize_) {
    	that=that_;
    	gridSize=gridSize_;
    	elements= (ArrayList<ChaosElement>[][]) new ArrayList[PApplet.parseInt(ceil(width/gridSize))][PApplet.parseInt(ceil(height/gridSize))]; 
    }
///////////////////////////////////////////////////////////
	public void add (ChaosElement element) {
	 	testFrame(element);
		int x = PApplet.parseInt(floor(element.location.x/gridSize));
		int y = PApplet.parseInt(floor(element.location.y/gridSize));
		
		if(elements[x][y] == null) elements[x][y] = new ArrayList();
		elements[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	public void test(ChaosElement element) {
		testFrame(element);
		int x = PApplet.parseInt(floor(element.location.x/gridSize));
		int y = PApplet.parseInt(floor(element.location.y/gridSize));
		
		if(elements[x][y] != null)
			elements[x][y].remove(element);
		
		for(int i=-1; i<=1; i++) 
			if(x+i >=0 && x+i < elements.length)
				for(int k=-1; k<=1; k++) 
					if(y+k >=0 && y+k < elements[x+i].length && elements[x+i][y+k] != null) {
						itr=elements[x+i][y+k].iterator();
						while(itr.hasNext())
							collide(element, (ChaosElement) itr.next());
					}
		that.newCollision.add(element);
	}
///////////////////////////////////////////////////////////
	public void testFrame (ChaosElement element) {
		if(element.location.x < 0) element.location.x*=-1;
		else if(element.location.x > width) element.location.x= width-(element.location.x-width);
		if(element.location.y < 0) element.location.y*=-1;
		else if(element.location.y > height) element.location.y= height-(element.location.y-height);
	}

///////////////////////////////////////////////////////////
	public void collide(ChaosElement element1, ChaosElement element2) {		
		distance=PVector.dist(element1.location, element2.location);
		that.count++;
		if(distance > gridSize) return;
		
		line(element1.location.x,element1.location.y,element1.location.z,element2.location.x,element2.location.y,element2.location.z);
	
		float force=1.2f* abs(gridSize-distance-gridSize)/gridSize;
		
		PVector velocity1= PVector.sub(element1.location,element2.location);
		
		velocity1.normalize();
		//velocity1.mult(force);		
	//	element1.velocity.add(velocity1);
	//	element1.velocity.mult(0.9);
		
		element1.location.add(element1.velocity);
	}
}
class CreateLines implements Comparator<ChaosElement> {
	chaosBG			that;
	int				maxLines = 5,
					connectionDistance = 20;
///////////////////////////////////////////////////////////
    CreateLines (chaosBG that_) {
    	that=that_;
    }
///////////////////////////////////////////////////////////
	public int compare(ChaosElement o1, ChaosElement o2) {
		if(o1.lineCount >= maxLines || o2.lineCount >= maxLines) return 1;
		float distance =PVector.dist(o1.location,o2.location);
		if(distance < connectionDistance) {
			
//			stroke((distance*255/connectionDistance));
			line(o1.location.x,o1.location.y,o1.location.z,o2.location.x,o2.location.y,o2.location.z);
			o1.lineCount++;
			o2.lineCount++;
		}
        return 1;
    }
}
class Mover implements Comparator<ChaosElement> {
	chaosBG			that;
	int				maxLines = 5,
					connectionDistance = 20;
	float			friction = 0.98f;
///////////////////////////////////////////////////////////
    Mover (chaosBG that_) {
    	that=that_;
    }
///////////////////////////////////////////////////////////
	public int compare(ChaosElement o1, ChaosElement o2) {
		float distance =PVector.dist(o2.location,o1.location);
		
		that.count++;
		o1.lineCount=0;
		o2.lineCount=0;
		if(distance < connectionDistance) {
			
			float force=connectionDistance-(distance-connectionDistance)*1.5f;
			
			PVector velocity1= PVector.sub(o2.location,o1.location);
			PVector velocity2= PVector.sub(o2.location,o1.location);
			
			velocity1.normalize();
			velocity2.normalize();
			
			velocity1.mult(force);
			velocity2.mult(force);
			
			o1.location.add(velocity1);
			o2.location.add(velocity2);


		}
        return 1;
    }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "chaosBG" });
  }
}
