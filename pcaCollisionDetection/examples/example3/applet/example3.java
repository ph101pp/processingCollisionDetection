import processing.core.*; 
import processing.xml.*; 

import pcaCollisionDetection.*; 
import geomerative.*; 
import java.awt.Color; 

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

public class example3 extends PApplet {




////////////////////////////////////////////////////////////////////////////////
int								gridSize=30;
ArrayList<CollisionElement>	gridElements;
float							x,y;

CollisionDetection				collisionDetection;
ElementGrid						gridElement;
ElementMouse					mouse = new ElementMouse();

////////////////////////////////////////////////////////////////////////////////
public void setup() {
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
public void draw(){
	background(255);
	
	collisionDetection.testElement(mouse);
	for(int i=0; i<gridElements.size(); i++){
		gridElement=(ElementGrid) gridElements.get(i);
		gridElement.draw();
	}
	mouse.draw();
}
class ElementGrid extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	example3	that;
	Color		elementColor;
	RPolygon	polygon,intersection;
////////////////////////////////////////////////////////////////////////////////
	public ElementGrid(example3 that_, float x , float y){	
		that=that_;
		elementColor = new Color(PApplet.parseInt(random(10,245)), PApplet.parseInt(random(10,245)), PApplet.parseInt(random(10,245)));
		location = new PVector (x, y);
		actionRadius= random(10, 15);
		
		polygon=RPolygon.createCircle(x,y,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	public void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){
	
		intersection= polygon.intersection(element.polygon);
		fill(0);
		intersection.draw();
	
	};
////////////////////////////////////////////////////////////////////////////////
	public void draw() {
		fill(elementColor.getRed(),elementColor.getGreen(),elementColor.getBlue());
//		polygon.draw();
	}
////////////////////////////////////////////////////////////////////////////////
}
class ElementMouse extends MyCollisionElement{
////////////////////////////////////////////////////////////////////////////////
	RPolygon	polygon;	
////////////////////////////////////////////////////////////////////////////////
	public ElementMouse(){	
		location = new PVector (mouseX, mouseY);
		actionRadius= 100;
		polygon=RPolygon.createCircle(mouseX,mouseY,actionRadius);
	}
////////////////////////////////////////////////////////////////////////////////
	public void draw() {
		polygon.translate(mouseX-location.x,mouseY-location.y);
		location = new PVector (mouseX, mouseY);
		
//		polygon.draw();
	}
////////////////////////////////////////////////////////////////////////////////
}
class MyCollisionElement extends CollisionElement{
/////////////////////////////////////////////////////////
	public void collide(ElementGrid element, CollisionMap collisionMap, boolean testedElement){};
	public void collide(ElementMouse element, CollisionMap collisionMap, boolean testedElement){};
/////////////////////////////////////////////////////////
 	public void collision(CollisionElement element, CollisionMap collisionMap, boolean testedElement) {
		String type=element.getClass().getName();

		if(type == "example3$ElementGrid") 	collide((ElementGrid) element, collisionMap, testedElement);
		if(type == "example3$ElementMouse") collide((ElementMouse) element, collisionMap, testedElement);
	}	
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "example3" });
  }
}
