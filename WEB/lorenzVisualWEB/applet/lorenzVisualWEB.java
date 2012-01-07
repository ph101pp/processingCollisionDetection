import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 
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

public class lorenzVisualWEB extends PApplet {




public ControlP5 controlP5;
public Camera camera1;
public Lorenz84 obj;


public float[] 	rotation= new float[3],
				variable=new float[9];
	
public float	zoom=100,
				iteration=100,
				variable0,
				variable1,
				variable2,
				variable3,
				variable4,
				variable5,
				variable6,
				variable7,
				variable8,
				rotationX,
				rotationY,
				rotationZ,
				speed=0.05f;

public float	xmag, ymag, newXmag, newYmag, diff;
public int 		rotationTimer;


public int		sliderHeight=600,
				sliderWidth=20,
				sliderDistance=60,
				sliderTop=200,
				sliderRight=80;

public void setup(){
	size(1680, 1050, P3D); 
	lights();

	controlP5 = new ControlP5(this);
	obj=new Lorenz84();
//	camera1 = new Camera(this, 450, 450, 700, 450, 450,0);

	variable0=obj.variable[0];
	variable1=obj.variable[1];
	variable2=obj.variable[2];
	variable3=obj.variable[3];
	variable4=obj.variable[4];
	variable5=obj.variable[5];
	variable6=obj.variable[6];
	variable7=obj.variable[7];
	variable8=obj.variable[8];

	
 	controlP5.addSlider("iteration",1,10000,iteration,			sliderRight+sliderDistance*1,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("zoom",1,1000,zoom,						sliderRight+sliderDistance*2,sliderTop,sliderWidth, sliderHeight);

 	controlP5.addSlider("variable0",-8,-1,obj.variable[0],		sliderRight+sliderDistance*3+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable1",-0.14f,1.3f,obj.variable[1],	sliderRight+sliderDistance*4+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable2",-1,4.6f,obj.variable[2],		sliderRight+sliderDistance*5+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable3",0,1.94f,obj.variable[3],		sliderRight+sliderDistance*6+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable4",-0.8f,1.9f,obj.variable[4],	sliderRight+sliderDistance*7+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable5",-6.3f,7.8f,obj.variable[5],	sliderRight+sliderDistance*8+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable6",-0.001f,0.18f,obj.variable[6],sliderRight+sliderDistance*9+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable7",-0.89f,1.8f,obj.variable[7],	sliderRight+sliderDistance*10+30,sliderTop,sliderWidth, sliderHeight);
 	controlP5.addSlider("variable8",-0.0f,0.18f,obj.variable[8],	sliderRight+sliderDistance*11+30,sliderTop,sliderWidth, sliderHeight);

	
	
	
	controlP5.setColorForeground(0xffdddddd);
	controlP5.setColorBackground(0xff333333);
	controlP5.setColorActive(0xffffffff);
//	camera1.feed();
}


public void draw(){
	println(mouseX);
	background(0);
	variable[0] = variable0;
	variable[1] = variable1;
	variable[2] = variable2;
	variable[3] = variable3;
	variable[4] = variable4;
	variable[5] = variable5;
	variable[6] = variable6;
	variable[7] = variable7;
	variable[8] = variable8;
	
	rotation();
	
	obj.update(variable, rotation, iteration, zoom);
	obj.draw();
	
	controlP5.draw(); 

}


public void rotation () {
//	rotationY=obj.rotation[1]+0.5;
	newXmag = mouseX/PApplet.parseFloat(width) * TWO_PI;
	newYmag = mouseY/PApplet.parseFloat(height) * TWO_PI;

	if(mousePressed && mouseX > 815) {
		rotationTimer = millis();
		
		diff = xmag-newXmag;
		if (abs(diff) >  0.01f) rotationY -= degrees(diff/1.0f);
	
		diff = ymag-newYmag;
		if (abs(diff) >  0.01f) rotationX += degrees(diff/1.0f);
		
		speed=0.01f;
	}
	else if(millis()-rotationTimer > 5000) {
		
		if(speed<0.4f) speed*=1.05f;
		else speed=0.4f;
		rotationY=obj.rotation[1]+speed;
		if(rotationZ > 0) rotationZ=obj.rotation[2]-speed;
		if(rotationX> 0) rotationX=obj.rotation[0]-speed;
	} 
	else {
		if(speed>0.05f) speed*=0.95f;
		else speed=0.05f;
		rotationY=obj.rotation[1]+speed;
		if(rotationZ > 0) rotationZ=obj.rotation[2]-speed;
		if(rotationX> 0) rotationX=obj.rotation[0]-speed;
	}
	
	xmag=newXmag;
	ymag=newYmag;
	rotation[0] = rotationX;
	rotation[1] = rotationY;
	rotation[2] = rotationZ;

}


public class Lorenz84 {
	public 	float x=1;
	public 	float y=1;
	public	float z=1;
	public	float[] firstValues=new float[3];


	public	float[] rotation = {0,0,0};
	public	float iteration=10000;
	public	float zoom = 100;
	public	float[] variable= {-1.11f, 1.12f, 4.49f, 0.13f, 1.4f, 0.4f, 0.13f, 1.47f, 0.13f};
	
///////////////////////////////////////////////////////////
	public	void generate(){
		x=1;
		y=1;
		z=1;
		
		for(int i=1; i<=20; i++) iterate();
		
		stroke(255);
		noFill();
		
		beginShape();
			curveVertex(x*zoom,y*zoom,z*zoom);
			float[] startValues = {x,y,z};
	
			for(int i=1; i<=iteration; i++) {
				iterate();
				curveVertex(x*zoom,y*zoom,z*zoom);
			}

/*
			x=startValues[0];
			y=startValues[1];
			z=startValues[2];
			
	 		curveVertex(x*zoom,y*zoom,z*zoom);
	 		iterate();
	 		curveVertex(x*zoom,y*zoom,z*zoom);
	 		iterate();
	 		curveVertex(x*zoom,y*zoom,z*zoom);
*/			
		endShape();
	
	
	}

///////////////////////////////////////////////////////////
	public	void iterate(){
		 float	dx = (variable[0] * x - y * y - z * z + variable[1] * variable[2]) * variable[3],
				dy = (-y + x * y - variable[4] * x * z + variable[5]) * variable[6],
				dz = (-z + variable[7] * x * y + x * z) * variable[8];
		
		x+=dx;
		y+=dy;
		z+=dz;
	}
///////////////////////////////////////////////////////////
	public	void update(float[] variable_, float[] rotation_, float iteration_, float zoom_) {
		int i;
		
		for(i=0; i<variable_.length; i++) variable[i] = variable_[i];	

		for(i=0; i<rotation_.length; i++) rotation[i] = rotation_[i];
		
		iteration=iteration_;
		zoom=zoom_;
	
	}
///////////////////////////////////////////////////////////
	public	void draw (){
		pushMatrix();
			translate(width/2+280, height/2);

			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			obj.generate();
		popMatrix();
	}
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "lorenzVisualWEB" });
  }
}
