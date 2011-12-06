import processing.core.*; 
import processing.xml.*; 

import org.openkinect.*; 
import org.openkinect.processing.*; 
import hypermedia.video.*; 
import processing.video.*; 
import java.awt.*; 
import fullscreen.*; 
import japplemenubar.*; 
import java.util.*; 
import damkjer.ocd.*; 

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

int 			elementCount = 4000;
int 			depth = 80;
ArrayList 		elements = new ArrayList<ChaosElement>();

Collision		collision;
FullScreen fullScreen;
KinectTracker tracker;

ChaosElement	element;

int 			count=0;
int 			countInt=0;
float 			rotation=0;
float 			mouseRadius;

float	xmag, ymag, newXmag, newYmag, diff,
		rotationX,rotationY,rotationZ;
float 		dropX=0,
			dropY=0;
			
float[]		blobPosition= new float[2];

PVector		mousePos=new PVector(mouseX,mouseY);
boolean		mouseMoved;

///////////////////////////////////////////////////////////
public void setup() {
	that = this;
	size(1000,800,P3D);
	background(255);
	stroke(0);
	frameRate(15);
	noFill();
	fullScreen = new FullScreen(this); 
//	fullScreen.enter(); 
  	
 // 	tracker = new KinectTracker(this);
	

//	Create Elements

	for (int i=0; i<elementCount; i++) {
		element=new ChaosElement(this);
		elements.add(element);
	}
	collision = new Collision(that, elements, 50);
}


///////////////////////////////////////////////////////////
public void draw() {
	println(frameRate);
	translate(0,0,0);
//	rotateX(mouseY*360/height);
//	blobPosition=tracker.calculateBlobs();
	pushMatrix();
//	translate(-width/2,-height/2,(mouseX-width/2)*3);
	rotation+=0.3f;
//	rotateY(rotation);
//	rotateY(rotation);
//	rotation ();
	background(255);
	count=0;
	
	if(PVector.dist(mousePos,new PVector(mouseX, mouseY)) >0 ) mouseMoved=true;
	else mouseMoved=false;

	collision.createCollisionMap();
	
	Iterator itr = elements.iterator(); 
	while(itr.hasNext()) {
		element= (ChaosElement)itr.next();
		collision.test(element);
		element.location.add(element.velocity);
	//	element.velocity= new PVector(0,0,0);
	}
	
	
//	noLoop();
//	camera1.feed();
	popMatrix();
	mousePos=new PVector(mouseX,mouseY);
}
class ChaosElement {
	chaosBG that;
	
	PVector location;
	PVector	velocity;
	int		lineCount=0;
///////////////////////////////////////////////////////////
	ChaosElement(chaosBG that_) {
		that=that_;
		location = new PVector (random(width), random(height),random(that.depth));
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
	chaosBG							that;
	Collision						nextCollision;
	Iterator						itr;
	ChaosElement					testElement;
	ArrayList<ChaosElement>			elements;
	ArrayList<ChaosElement>[][] 	quadrants;
	
	float 							gridSize; 
	float							distance;
	PVector							velocity1,velocity2, velocity3, mouse;
	PVector 						wind;
	int 							maxZ;;
	float							mouseDist;
	float							radius=200;
	float 							rand=0.1f;
	float							friction=0.2f;
	
///////////////////////////////////////////////////////////
    Collision (chaosBG that_, ArrayList elements_, float gridSize_, boolean flag) {
    	that=that_;
    	elements=elements_;
    	gridSize=gridSize_;
    	quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[PApplet.parseInt(ceil(width/gridSize))+2][PApplet.parseInt(ceil(height/gridSize))+2]; 
    }
    Collision (chaosBG that_, ArrayList elements_, float gridSize_) {
    	that=that_;
    	elements=elements_;
    	gridSize=gridSize_;
    	maxZ=that.depth;
    	quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[PApplet.parseInt(ceil(width/gridSize))+2][PApplet.parseInt(ceil(height/gridSize))+2]; 
    	wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
    	nextCollision = new Collision(that, new ArrayList(), gridSize, true);
    }
	    
///////////////////////////////////////////////////////////
	public void add(ChaosElement element) {	 	
		PVector quadrant = getQuadrant(element);		
		int x= PApplet.parseInt(quadrant.x);
		int y= PApplet.parseInt(quadrant.y);
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	public PVector getQuadrant(ChaosElement element) {
		int x = 1+PApplet.parseInt(floor(element.location.x/gridSize));
		int y = 1+PApplet.parseInt(floor(element.location.y/gridSize));
		
		if(x < 1) x=0;
		if(x > PApplet.parseInt(ceil(width/gridSize))) x=PApplet.parseInt(ceil(width/gridSize))+1;
		
		if(y < 1) y=0;
		if(y > PApplet.parseInt(ceil(height/gridSize))) y=PApplet.parseInt(ceil(height/gridSize))+1;
			
		return new PVector(x,y);	
	}
///////////////////////////////////////////////////////////
	public void createCollisionMap() {
		int length=0;
		for(int i=0; i< nextCollision.quadrants.length; i++)
			for(int k=0; k< nextCollision.quadrants[i].length; k++)
				if(nextCollision.quadrants[i][k] != null)
					length+=nextCollision.quadrants[i][k].size();
		
		if(length == elements.size()) quadrants=nextCollision.quadrants.clone();
		else {
    		quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[PApplet.parseInt(ceil(width/gridSize))+2][PApplet.parseInt(ceil(height/gridSize))+2]; 
			itr=elements.iterator();
			while(itr.hasNext()) 
				add((ChaosElement)itr.next());
		}	
		nextCollision= new Collision(that, new ArrayList(), gridSize, true);
	}
///////////////////////////////////////////////////////////
	public void test(ChaosElement element) {
		PVector quadrant = getQuadrant(element);		
		int x= PApplet.parseInt(quadrant.x);
		int y= PApplet.parseInt(quadrant.y);
		
		if(quadrants[x][y] != null)
			quadrants[x][y].remove(element);
		
		for(int i=1; i>=-1; i--) 
			if(x+i >=0 && x+i < quadrants.length)
				for(int k=-1; k<=1; k++) 
					if(y+k >=0 && y+k < quadrants[x+i].length && quadrants[x+i][y+k] != null) {
						itr=quadrants[x+i][y+k].iterator();
						while(itr.hasNext())
							collide(element, (ChaosElement) itr.next());
					}
		nextCollision.add(element);
	}
///////////////////////////////////////////////////////////
	public void testFrame (ChaosElement element) {
		if(element.location.x < 0) element.location.x*=-1;
		else if(element.location.x > width) element.location.x= width-(element.location.x-width);
		if(element.location.y < 0) element.location.y*=-1;
		else if(element.location.y > height) element.location.y= height-(element.location.y-height);
		if(element.location.z > maxZ) element.location.z= maxZ-(element.location.z-maxZ);
		else if(element.location.z < 0) element.location.z*=-1;
	}

///////////////////////////////////////////////////////////
	public void collide(ChaosElement element1, ChaosElement element2) {		
		distance=PVector.dist(element1.location, element2.location);
		that.count++;
		if(distance > gridSize) return;
		
		if(distance < gridSize*0.9f) {
			float lineZ= abs((element1.location.z-element2.location.z)/2);
			
			stroke(map(lineZ,0,maxZ,0,255 ));
			line(element1.location.x,element1.location.y,element1.location.z,element2.location.x,element2.location.y,element2.location.z);
			
			velocity1= PVector.sub(element1.location,element2.location);
			velocity2= PVector.sub(element2.location,element1.location);
		}
		else {
			velocity1= PVector.sub(element2.location,element1.location);
			velocity2= PVector.sub(element1.location,element2.location);
		}
		velocity1.normalize();
		velocity1.mult(map(distance, 0,50,4,0));		
		velocity2.normalize();
		velocity2.mult(map(distance, 0,50,4,0));		
		
		float force=1;//(1-(PVector.dist(element1.location, new PVector(width/2,height/2,element1.location.z))/(height/2)))*0.2;
		if(PApplet.parseInt(blobPosition[0]) > 0 && PApplet.parseInt(blobPosition[1]) > 0) {
			that.dropX=map(blobPosition[0],0,640,0,width);
			that.dropY=map(blobPosition[1],0,480,0,height);
			radius=200;
		}
		else if(mousePressed && that.mouseMoved) {
			that.dropX=mouseX;
			that.dropY=mouseY;
			radius=200;
		}
		else if(frameCount% 10 == 0 && false) {
			that.dropX=random(width);
			that.dropY=random(height);
			radius = random(height/2);
		}
//		else radius=0;
		if(frameCount% 30 == 0) {
   		 	wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
		}
		
		if(PApplet.parseInt(blobPosition[0]) > 0 || mousePressed) {
			mouse=new PVector(that.dropX, that.dropY,0);
			mouseDist= PVector.dist(new PVector(element1.location.x,element1.location.y),new PVector(that.dropX, that.dropY));
			if(mouseDist < radius) {
				velocity3= PVector.sub(element1.location,mouse);
				velocity3.normalize();
				velocity3.mult(10);		
				velocity1.add(velocity3);
			}
		}
		

	//	wind.mult(force);
		velocity1.add(wind);
		
	//	element1.velocity.add(velocity1);
		element1.velocity.mult(friction);
	//	element1.location.add(velocity1);
		element1.velocity.add(velocity1);
		element2.velocity.add(velocity2);
		testFrame(element1);
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

class KinectTracker {
 	OpenCV opencv;
	chaosBG that;
	Kinect kinect;
  // Size of kinect image
  int kw = 640;
  int kh = 480;
  int threshold = 600;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;


  PImage display;

  KinectTracker(chaosBG that_) {
 	that=that_;
	opencv = new OpenCV(that);
	opencv.allocate(kw, kh);
  	kinect = new Kinect(that);
 	kinect.start();
    kinect.enableDepth(true);

    // We could skip processing the grayscale image for efficiency
    // but this example is just demonstrating everything
    kinect.processDepthImage(true);

    display = createImage(kw, kh, PConstants.RGB);
  }

  public void createDisplay() {
    PImage img = kinect.getDepthImage();
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // mirroring image
        int offset = kw-x-1+y*kw;
        // Raw depth
        int rawDepth = depth[offset];

        int pix = x+y*display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(255);
        } 
        else {
          display.pixels[pix] = color(0);
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }



  public float[] calculateBlobs() {
  	float 	sumX=0,
  			sumY=0;
  	int		count=1;
  
    createDisplay();
    opencv.copy(display);
   image( opencv.image(), 640, 0 );
    opencv.threshold( 80 );
    Blob[] blobs = opencv.blobs( 10, width*height/2, 100, true, OpenCV.MAX_VERTICES*4 );
	
    // draw blob results
        for( int i=0; i<blobs.length; i++ ) {
        	println(blobs[i].points.length);
        	
        	

         beginShape();
           for( int j=0; j<blobs[i].points.length; j++ ) {
              vertex( blobs[i].points[j].x, blobs[i].points[j].y );
           
           		sumX+=blobs[i].points[j].x;
           		sumY+=blobs[i].points[j].y;
           		count++;
           
           }
          endShape(CLOSE);
       }
       
    float[] value = {sumX/count, sumY/count};
    return value;
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
