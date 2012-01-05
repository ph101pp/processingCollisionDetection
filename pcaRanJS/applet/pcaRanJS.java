import processing.core.*; 
import processing.xml.*; 

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

public class pcaRanJS extends PApplet {

//import geomerative.*;

///////////////////////////////////////////////////////////
pcaRanJS								that;
///////////
int 								elementCount = 6000;
int 								depth = 10;
//int 								elementCount = 5800;
//int 								depth = 8;
//int 								elementCount = 5500;
//int 								depth = 5;
float								globalFriction=0.8f;
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

//RShape								ranShape;

ElementBlob							ran=null;

boolean								record=false;
boolean								loop=true;
///////////////////////////////////////////////////////////
public void setup() {
	that = this;
	size(1680,1050,P3D);
//	size(1280,720,P3D);
	background(255);
	stroke(0);
	frameRate(17);
	noFill();

	elementCount=PApplet.parseInt(map(width*height, 0,1680*1050 ,0, elementCount));
	depth=PApplet.parseInt(map(width*height, 0,1680*1050 ,0, depth));



/*	RG.init(this);
 	RG.ignoreStyles(false);
 	RG.setPolygonizer(RG.ADAPTATIVE);
 	ranShape = RG.loadShape("data/ran.svg");
  	ranShape.centerIn(g, 100, 1, 1);
 	ranShape.scale(map(width*height, 1280*720,1680*1050 ,0.8, 0.5));
 	ranShape.translate(width/2+20,height/2);
*/
//	Create Elements
	for (int i=0; i<elementCount; i++) {
		elementN=new ElementChaos(this);
		elementN.ranPoint=new PVector(elementN.location.x,elementN.location.y,0);
/*
		while(!ranShape.contains(elementN.ranPoint.x,elementN.ranPoint.y))
			elementN.ranPoint = new PVector (random(width), random(height),random(depth));
*/		elements.add(elementN);
	}
	collisionDetection = new CollisionDetection(this, elements);
}
///////////////////////////////////////////////////////////
public void draw() {
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
			if( k > map(min(abs(frameCount-ran.startFrame),6), 0,6, elementCount, 400) || (!element.test(ran) && PVector.dist(element.location, new PVector(width/2, height/2)) > map(abs(frameCount-ran.startFrame), 0,3, width/2, 50)))
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
			if(!elementN.test(ran) && k>400) {
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
public void mouseElement() {
	mouseMoved=PVector.dist(mousePos,new PVector(mouseX, mouseY));
	mousePos=new PVector(mouseX,mouseY);
	if(mouseMoved > 0) movement=true;

	if(mousePressed && mouseElement==null) {
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
public void environment() {
//	friction
	if(ran==null) {
		if(!movement && (!lorenzMovement || globalFriction > 0.6f) && globalFriction > 0.0f) globalFriction-=0.005f;
		else if((movement || lorenzMovement) && ((globalFriction <= 0.85f && !lorenzMovement) || globalFriction <= 0.75f)) globalFriction+=0.08f;
	}
	globalDisturbance--;	
}
///////////////////////////////////////////////////////////
public void frame(ElementChaos element) {
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
public void onStartSession(PVector pos) {
	println("onStartSession: " + pos);
}

public void onEndSession() {
	println("onEndSession: ");
}

public void onFocusSession(String strFocus,PVector pos,float progress) {
	println("onFocusSession: focus=" + strFocus + ",pos=" + pos + ",progress=" + progress);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
public void keyPressed() {
	switch(keyCode) {
		case 10: //Enter
			ran=ran!=null?
				null:
				new ElementBlob(this, new PVector(width/2, height/2), 400);
				globalFriction=0.81f;
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
public class CollisionDetection {
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionMap>				maps = new ArrayList();
	private ArrayList<CollisionElement>			elements = new ArrayList();
	private CollisionMap						map;
	private CollisionElement 					element;
////////////////////////////////////////////////////////////////////////////////
	public CollisionDetection(PApplet that_) {
		that=that_;
    	that.registerPre(this);
	}
	public CollisionDetection(PApplet that_, ArrayList<CollisionElement> elements_) {
		that=that_;
		elements=(ArrayList<CollisionElement>) elements_.clone(); 
	   	that.registerPre(this);
	}
////////////////////////////////////////////////////////////////////////////////
	public void pre() {
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
	public void add(CollisionElement element) {
		elements.add(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void remove(CollisionElement element) {
		elements.remove(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void addElement (CollisionElement element) {
		add(element);
		addToMap(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void removeElement (CollisionElement element) {
		remove(element);
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
	public ArrayList getElements () {
		return elements;
	}
////////////////////////////////////////////////////////////////////////////////
	public int size() {
		return elements.size();
	}
////////////////////////////////////////////////////////////////////////////////
	public int mapSize() {
		int length=0;
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			length+=map.size();
		}
		return length;
	}
////////////////////////////////////////////////////////////////////////////////
	public void remapElements() {
		maps=new ArrayList();
		Iterator itr= elements.iterator();
		while(itr.hasNext()) {
			element = (CollisionElement) itr.next();
			addToMap(element);
		}
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement (CollisionElement element, boolean removeElement) {
		_testElement(element, removeElement);
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement (CollisionElement element) {
		_testElement(element, true);	
	}
////////////////////////////////////////////////////////////////////////////////
	private void _testElement (CollisionElement element, boolean removeElement) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			map.test(element, removeElement);
		}
	}
////////////////////////////////////////////////////////////////////////////////
	private void addToMap(CollisionElement element) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			if(map.gridSize!=element.actionRadius) continue;
			map.add(element);
			return;			
		}
		map=new CollisionMap(that, element.actionRadius);
		map.add(element);	
		maps.add(map);
	}
////////////////////////////////////////////////////////////////////////////////
}
abstract public class CollisionElement {
////////////////////////////////////////////////////////////////////////////////
	public PVector 								location = new PVector(0,0,0);
	public PVector								velocity = new PVector(0,0,0);
	public float 								actionRadius;
////////////////////////////////////////////////////////////////////////////////
	abstract public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement);
////////////////////////////////////////////////////////////////////////////////
	public void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
////////////////////////////////////////////////////////////////////////////////
	public boolean test(CollisionElement element) {
		return this.equals(element) || PVector.dist(element.location, location) > (actionRadius+element.actionRadius) ?
			false:
			true;
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement(CollisionElement element) {
		if(!test(element)) return;
		element.collision(this, null, true);
		collision(element, null,false);
	}
}
public class CollisionMap{
////////////////////////////////////////////////////////////////////////////////
	public float 								gridSize; 
	public int									columns, rows;
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionElement>[][] 	quadrants;
	private CollisionElement					testElement;
	private int									x,y,i,k,length;
	private PVector								q, q1, q2, radius;
	private Iterator							itr;
////////////////////////////////////////////////////////////////////////////////
	public CollisionMap(PApplet that_, float gridSize_) {
		that=that_;
		gridSize=gridSize_;
		columns=(int) Math.ceil(that.width/gridSize)+2;
		rows=(int) Math.ceil(that.height/gridSize)+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[columns][rows]; 
	}
////////////////////////////////////////////////////////////////////////////////
	public void add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element.location);
		x= (int) quadrant.x;
		y= (int) quadrant.y;
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public PVector getQuadrant(PVector location) {
		x = (int) Math.floor(location.x/gridSize)+1;
		y = (int) Math.floor(location.y/gridSize)+1;
		
		if(x < 1) x=0;
		if(x > (int) Math.ceil(that.width/gridSize)) x=(int) Math.ceil(that.width/gridSize)+1;
		if(y < 1) y=0;
		if(y > (int) Math.ceil(that.height/gridSize)) y=(int) Math.ceil(that.height/gridSize)+1;
			
		return new PVector(x,y);	
	}
////////////////////////////////////////////////////////////////////////////////
	public ArrayList getQuadrantElements(int x, int y) {
		if(quadrants[x][y] != null) return quadrants[x][y];
		else return new ArrayList();
	}
////////////////////////////////////////////////////////////////////////////////
	public int size() {
		length=0;
		for(i=0; i< quadrants.length; i++)
			for(k=0; k< quadrants[i].length; k++)
				if(quadrants[i][k] != null)
					length+=quadrants[i][k].size();
		return length;	
	}
////////////////////////////////////////////////////////////////////////////////
	public void test(CollisionElement element, boolean removeElement) {
		q = getQuadrant(element.location);		
		x= (int) q.x;
		y= (int) q.y;
		
		if(element.actionRadius <= gridSize) {
			q1 = PVector.sub(q, new PVector(2,2));
			q2 = PVector.add(q, new PVector(2,2));
		}
		else {
			radius = new PVector(element.actionRadius, element.actionRadius);
			q1 = getQuadrant(PVector.sub(element.location, radius));		
			q2 = getQuadrant(PVector.add(element.location, radius));		
			q1.sub(new PVector(1,1));
			q2.add(new PVector(1,1));
		}
		if(removeElement && quadrants[x][y] != null && quadrants[x][y].contains(element))
			quadrants[x][y].remove(element);
				
		for(i=(int) q1.x; i<=q2.x; i++) 
			if(i >=0 && i < quadrants.length)
				for(k=(int) q1.y; k<=q2.y; k++) 
					if(k >=0 && k < quadrants[i].length && quadrants[i][k] != null) {
						itr=quadrants[i][k].iterator();
						while(itr.hasNext()) {
							testElement= (CollisionElement) itr.next();
							if(element.equals(testElement)) continue;
							if(PVector.dist(element.location, testElement.location) > (testElement.actionRadius+element.actionRadius)) continue;
							element.collision(testElement, this, true);
							testElement.collision(element, this,false);
						}
					}
	}
////////////////////////////////////////////////////////////////////////////////
}
class ElementBlob extends MyCollisionElement {
	float 							defaultRadius=155;

	int								startFrame;
	
	float							moved;
	
	ElementLorenz					lorenzElement;
		
	boolean							shapeSet;
	
//	PROGRAMM
	PVector newLocation;
///////////////////////////////////////////////////////////
	ElementBlob(pcaRanJS that_, PVector location_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = location_;
		startFrame=frameCount;

		lorenzElement= new ElementLorenz(that, location, this);
	}
	ElementBlob(pcaRanJS that_, PVector location_) {
		that=that_;
		actionRadius=defaultRadius;
		location = location_;
		startFrame=frameCount;

		lorenzElement= new ElementLorenz(that, location,this);
	}
///////////////////////////////////////////////////////////
	
	public void move(PVector newLocation) {
		moved=PVector.dist(newLocation, location);
		
		if(moved>0) that.movement=true;
		
		if(frameCount-startFrame > 100 && random(0,1) >0.9f) startFrame=frameCount;

		location = newLocation;
		
		if(lorenzElement.allSet == true) resetElementLorenz();
	
		if(shapeSet && !lorenzElement.allSet && (moved<=0 || PVector.dist(location, lorenzElement.location) > 20)) {
			startFrame=frameCount;
			shapeSet=false;
			lorenzElement.remove();
		}
		if(frameCount-startFrame> 50 && !shapeSet && moved>0 ) {
			that.lorenzElements.add(lorenzElement);
			that.collisionDetection.addElement(lorenzElement);
			lorenzElement.location=new PVector(location.x,location.y, location.z);
			lorenzElement.startFrame=frameCount;
			lorenzElement.elements = new ArrayList();
			shapeSet=true;
		}
		
	}
///////////////////////////////////////////////////////////
	public void resetElementLorenz(){
		startFrame=frameCount;
		shapeSet=false;
		lorenzElement=new ElementLorenz(that, location, this);
	}
///////////////////////////////////////////////////////////
	public void finalize() {
		if(lorenzElement.allSet) return;	
		lorenzElement.remove();
	}
}
class ElementChaos extends MyCollisionElement {
	float 							defaultRadius=25;

	PVector 						ranPoint;

	float							friction=1;
	
	float							pushForce=5;
	
	int								disturbance=0;
	
	ElementLorenz					lorenz=null;
	
	ElementChaos 					element1, element2;
	///////////////////////////////////////////////////////////
	ElementChaos(pcaRanJS that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	ElementChaos(pcaRanJS that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	
///////////////////////////////////////////////////////////
	public void collide (ElementChaos element, CollisionMap collisionMap, boolean mainCollision) {
		PVector newVelocity;
		float distance=PVector.dist(location, element.location);
		if(lorenz!=null && !lorenz.allSet) {
			int index = lorenz.elements.indexOf(this);
			PVector pointLocation = new PVector(lorenz.points[index][0],lorenz.points[index][1],lorenz.points[index][2]);
			pointLocation.mult(lorenz.zoom);
			pointLocation.sub(lorenz.average);
			pointLocation.add(lorenz.location);
			if(PVector.dist(location, pointLocation)<=random(5, 15)) return;
		}
		if(distance < (actionRadius+element.actionRadius)*0.9f) {
			newVelocity= PVector.sub(location,element.location);
		
			if(mainCollision) {
				float lineZ= abs((location.z-element.location.z)/2);
				stroke(map(lineZ,0,30,0,100 ));
				line(location.x,location.y,location.z,element.location.x,element.location.y,element.location.z);
			}			
		}
		else {
			newVelocity= PVector.sub(element.location,location);
		}
		newVelocity.normalize();
		newVelocity.mult(map(distance, 0,(actionRadius+element.actionRadius),pushForce,0));		
			
		velocity.add(newVelocity);
		
//		println(element1.velocity);
	}
///////////////////////////////////////////////////////////
	public void collide(ElementBlob element, CollisionMap collisionMap, boolean mainCollision) {
		if(element.moved <=0 || that.globalFriction < 0.8f) return;
		
		int pressedFrames = frameCount-element.startFrame;

		PVector newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(0.5f*pressedFrames);
		newVelocity.limit(pushForce+4);
		
		velocity.add(newVelocity);
		
		friction=0.7f;
		disturbance=PApplet.parseInt(random(0,2));
	}
///////////////////////////////////////////////////////////
	public void collide(ElementLorenz element, CollisionMap collisionMap, boolean mainCollision) {
		if(!element.allSet) {
			if(element.elements.contains(this)) lorenz= element;	
			return;
		}
			
		PVector newVelocity= PVector.sub(location,element.location);
		newVelocity.normalize();
		newVelocity.mult(10);
		
		if(element.location.y+20 > location.y) {
			
			if(element.location.x > location.x)
				newVelocity.sub(new PVector(10,0));
			else
				newVelocity.add(new PVector(10,0));
			
			friction=1.5f;
		}
		else friction=0.4f;

		
		velocity.add(newVelocity);
		disturbance=PApplet.parseInt(random(0,2));
	}
///////////////////////////////////////////////////////////
	public void move() {	
		if(that.ran != null) {
			moveRan();
			return;
		}
		if(lorenz !=null) {
  			int index = lorenz.elements.indexOf(this);
			if(!lorenz.allSet && index<=lorenz.count) {
				moveLorenz(index);
				return;
			}
		}
		moveNormal();
	}
///////////////////////////////////////////////////////////
	public void moveLorenz(int index){
		PVector pointLocation = new PVector(lorenz.points[index][0],lorenz.points[index][1],lorenz.points[index][2]);
		pointLocation.mult(lorenz.zoom);
		pointLocation.sub(lorenz.average);
		pointLocation.add(lorenz.location);
		
		velocity= PVector.sub(pointLocation, location);
		
		velocity.mult(0.3f);
	//	stroke(255,0,0);
		if(velocity.mag() <=1) {
			if(index-1 >=0 && index+2 < lorenz.elements.size()) {
				element =(ElementChaos) lorenz.elements.get(index-1);
				
				
				element1 =(ElementChaos) lorenz.elements.get(index+1);
				element2 =(ElementChaos) lorenz.elements.get(index+2);
				line(element.location.x, element.location.y, element.location.z, location.x,location.y,location.z);
//				curve( element.location.x, element.location.y, element.location.z,location.x,location.y,location.z, element1.location.x, element1.location.y, element1.location.z, element2.location.x, element2.location.y, element2.location.z);
			}
		}
		stroke(0);

	///	lorenz.moved=true;		
	
		if(PVector.dist(pointLocation, location) <=1) location = pointLocation;
		else {
			location.add(velocity);
			lorenz.moved=true;
		}
	}
///////////////////////////////////////////////////////////
	public void moveRan() {
		PVector oldLocation = location;
		
//		boolean contained=that.ranShape.contains(location.x,location.y);
		
		if(false/* && !contained*/) {
			velocity= PVector.sub(ranPoint, location);
			velocity.mult(0.3f);
		}
		else velocity.mult(0.3f);
		
		location.add(velocity);
		
/*		if(false && !that.ranShape.contains(location.x,location.y)) {
			RPoint[] points=that.ranShape.getIntersections(RShape.createLine(location.x,location.y,oldLocation.x,oldLocation.y));
			location=new PVector(points[0].x, points[0].y,0);
		}
*/		
	}
///////////////////////////////////////////////////////////
	public void moveNormal() {
  		velocity.mult(that.globalFriction);
		velocity.mult(friction);
		
		if(lorenz != null && PVector.dist(location, lorenz.location) > 210) 
			velocity.mult(-1);
		
		if(that.globalDisturbance > 0 || disturbance>0) {
			float mult=-0.06f;
			velocity.mult(mult);
			location.add(velocity);
			velocity.mult(1/mult);
			
		}
		else {
			location.add(velocity);
		}
		
		friction=lerp(friction,1,0.3f);
		disturbance--;
	}
///////////////////////////////////////////////////////////
}

class ElementLorenz extends MyCollisionElement {
	ElementBlob						blob;

	float 							defaultRadius=155;
	int								variableSets=17;

	float							pushForce=5;

	int								startFrame;

	float							x,y,z;
	float[] 						variable= {-1.11f, 1.12f, 4.49f, 0.13f, 1.4f, 0.4f, 0.13f, 1.47f, 0.13f};
	float[][] 						points;
	PVector							average= new PVector(0,0,0);
	float							zoom=25;
	float							rotation=0;
	int								iterations=1000;
	
	ArrayList<CollisionElement> 	elements = new ArrayList();
	
	PVector							quadrant = new PVector(0,0);

	boolean							allSet=false;
	int								count=0;	
	boolean							moved=true;
	
	float							moveUp=0.8f;
	
///////////////////////////////////////////////////////////
	ElementLorenz(pcaRanJS that_, PVector location_, ElementBlob blob_, float actionRadius_) {
		that=that_;
		blob=blob_;
		actionRadius=actionRadius_;
		location = location_;
		startFrame=frameCount;
		
		getVariableSet();
		generatePoints();
	}
	ElementLorenz(pcaRanJS that_, PVector location_, ElementBlob blob_) {
		that=that_;
		blob=blob_;
		actionRadius=defaultRadius;
		location = location_;
		startFrame=frameCount;

		getVariableSet();
		generatePoints();
	}
///////////////////////////////////////////////////////////
	public void collide(ElementChaos element, CollisionMap collisionMap,  boolean mainCollision) {
		if(!allSet) {	
			PVector thisQuadrant= collisionMap.getQuadrant(element.location);
			
			if(elements.size() < iterations && !thisQuadrant.equals(quadrant)) elements.add(element);
				
			quadrant=thisQuadrant;
			return;
		}
		
		
 	}
///////////////////////////////////////////////////////////
	public void move() {
		count = (frameCount-startFrame)*100;
		if(count> iterations) count = iterations;
		
		if(count!=iterations) moved=true;
		
		if(!allSet) return;
		
		velocity.limit(3);
		
/*		velocity.limit(1);
		velocity.limit(3);
*/		
		moveUp+=0.02f;
		velocity.y-=moveUp;
		
/*		float distance=PVector.dist(new PVector(location.x,location.y), that.mouseElement.location);
		if(distance<=actionRadius && false) {
			PVector newVelocity= PVector.sub(location,element.location);
			newVelocity.normalize();
			
			pushForce=5;
			newVelocity.mult(map(distance, 0,actionRadius,pushForce,0));		
			velocity.add(newVelocity);
		}
	
*/	
		velocity.mult(that.globalFriction);	
		if(velocity.mag() >0) that.lorenzMovement=true;
		
		location.add(new PVector(velocity.x,velocity.y));
	
		if(location.y < -actionRadius) {
			remove();
			return;	
		}
		draw();
	}
	
	public void remove(){
		that.lorenzElements.remove(this);
		that.collisionDetection.remove(this);
	}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
	public void getVariableSet () {
		String filenumber = nf(PApplet.parseInt(random(0, variableSets)),5,0);
		String filename = sketchPath("variableSets"+java.io.File.separator+filenumber+"_lorenzVariableSet.txt");
		String[] data=loadStrings(filename);
		
		if(data==null) return;

		int id=0;
		int k=0;
		for(int i=0; 18 >i; i++) {
			if(i%2==0) {
				id++;
				continue;
			}
			variable[k]=PApplet.parseFloat(data[id]);
			k++;
			id++;
		}
		
		id++; //obj.iteration=data.readFloat();
		id+=2; //obj.zoom=data.readFloat();
		id+=2; //obj.rotation[0]=data.readFloat();
		id+=2; //obj.rotation[1]=data.readFloat();
		id+=2; //obj.rotation[2]=data.readFloat();
	}
///////////////////////////////////////////////////////////
	public void generatePoints(){
		points = new float[iterations][3];
		x=1;
		y=1;
		z=1;
		float count=0;
		for(int i=0; i<20; i++) iterate();
		for(int i=0; i<iterations; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;		
			
			average.add(new PVector(x,y,z));
			iterate();	
			count++;
		}
		average.mult(1/count);
		average.mult(zoom);
	}
///////////////////////////////////////////////////////////
	public void iterate(){
		float	dx = (variable[0] * x - y * y - z * z + variable[1] * variable[2]) * variable[3],
				dy = (-y + x * y - variable[4] * x * z + variable[5]) * variable[6],
				dz = (-z + variable[7] * x * y + x * z) * variable[8];
		x+=dx;
		y+=dy;
		z+=dz;
	}
///////////////////////////////////////////////////////////
	public void draw() {
		pushMatrix();
			stroke(0);
			
			translate(location.x, location.y,location.z);
			rotation+=0.05f;
			rotateY(rotation);
//			box(10);
			pushMatrix();			
				translate(-average.x, -average.y,-average.z);
//				box(10);
				beginShape();
					for(int i=0; i< points.length; i++) {
						x =points[i][0];
						y =points[i][1];
						z =points[i][2];
		
						curveVertex(x*zoom,y*zoom,z*zoom);
					}
				endShape();
			popMatrix();
		popMatrix();
	}
}
class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	public void collide(ElementChaos element, CollisionMap collisionMap, boolean mainCollision){};
	public void collide(ElementLorenz element, CollisionMap collisionMap, boolean mainCollision){};
	public void collide(ElementBlob element, CollisionMap collisionMap, boolean mainCollision){};
/////////////////////////////////////////////////////////
 	public void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision) {
		String type=element.getClass().getName();
		
		if(type == "pcaRanJS$ElementChaos") 	collide((ElementChaos) element, collisionMap, mainCollision);
		if(type == "pcaRanJS$ElementLorenz") 	collide((ElementLorenz) element, collisionMap, mainCollision);
		if(type == "pcaRanJS$ElementBlob") 	collide((ElementBlob) element, collisionMap, mainCollision);
	}	
}
///////////////////////////
// DATA CLASS
 
class Data {
  ArrayList datalist;
  String filename,data[];
  int datalineId;
 
  // begin data saving
  public void beginSave() {
    datalist=new ArrayList();
  }
 
  public void add(String s) {
    datalist.add(s);
  }
 
  public void add(float val) {
    datalist.add(""+val);
  }
 
  public void add(int val) {
    datalist.add(""+val);
  }
 
  public void add(boolean val) {
    datalist.add(""+val);
  }
 
  public void endSave(String _filename) {
    filename=_filename;
 
    data=new String[datalist.size()];
    data=(String [])datalist.toArray(data);
 
    saveStrings(filename, data);
    println("Saved data to '"+filename+
      "', "+data.length+" lines.");
  }
 
  public void load(String _filename) {
    filename=_filename;
 
    datalineId=0;
    data=loadStrings(filename);
    println("Loaded data from '"+filename+
      "', "+data.length+" lines.");
  }
 
  public float readFloat() {
    return PApplet.parseFloat(data[datalineId++]);
  }
 
  public int readInt() {
    return PApplet.parseInt(data[datalineId++]);
  }
 
  public boolean readBoolean() {
    return PApplet.parseBoolean(data[datalineId++]);
  }
 
  public String readString() {
    return data[datalineId++];
  }
 
  // Utility function to auto-increment filenames
  // based on filename templates like "name-###.txt" 
 
  public String getIncrementalFilename(String templ) {
    String s="",prefix,suffix,padstr,numstr;
    int index=0,first,last,count;
    File f;
    boolean ok;
 
    first=templ.indexOf('#');
    last=templ.lastIndexOf('#');
    count=last-first+1;
 
    if( (first!=-1)&& (last-first>0)) {
      prefix=templ.substring(0, first);
      suffix=templ.substring(last+1);
 
      // Comment out if you want to use absolute paths
      // or if you're not using this inside PApplet
      if(sketchPath!=null) prefix=savePath(prefix);
 
      index=0;
      ok=false;
 
      do {
        padstr="";
        numstr=""+index;
        for(int i=0; i< count-numstr.length(); i++) padstr+="0";
        s=prefix+padstr+numstr+suffix;
 
        f=new File(s);
        ok=!f.exists();
        index++;
 
        // Provide a panic button. If index > 10000 chances are it's an
        // invalid filename.
        if(index>10000) ok=true;
 
      }
      while(!ok);
 
      // Panic button - comment out if you know what you're doing
      if(index> 10000) {
        println("getIncrementalFilename thinks there is a problem - "+
          "Is there  more than 10000 files already in the sequence "+
          " or is the filename invalid?");
        println("Returning "+prefix+"ERR"+suffix);
        return prefix+"ERR"+suffix;
      }
    }
 
    return s;
  }
 
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "pcaRanJS" });
  }
}
