import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 

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

public class lorenzVisual extends PApplet {



ControlP5 controlP5;


float x=1;
float y=1;
float z=1;

float dx,dy,dz;
float count=1;

float maxCount=1000;
int zoom = 10;


public void setup(){
	size(900, 900, P3D); 
	background(0);
	lights();
	controlP5 = new ControlP5(this);
 	controlP5.addSlider("zoom",0,1000,100,10,10,100,10);

	
	
	
}

public void draw(){
background(0);
//zoom = mouseY;

generate();
controlP5.draw(); 

}

public void generate(){
		
	
	
	for(int i=1; i<=10; i++) countUp();
	
	stroke(255);
	noFill();
	beginShape();
	
	float[] startValues = {x,y,z};
	
	for(int i=1; i<=maxCount; i++) {
		curveVertex(450+x*zoom,450+y*zoom,450+z*zoom);
	
		countUp();
	}
	curveVertex(450+startValues[0]*zoom,450+startValues[1]*zoom,450+startValues[2]*zoom);
	
	
 
	endShape();
	
	
}

public void countUp(){

	float	dx = (-1.11f * x - y * y - z * z + 1.12f * 4.49f) * 0.13f,
			dy = (-y + x * y - 1.47f * x * z + 0.4f) * 0.13f,
			dz = (-z + 1.47f * x * y + x * z) * 0.13f;
	
	x+=dx;
	y+=dy;
	z+=dz;
	
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "lorenzVisual" });
  }
}
