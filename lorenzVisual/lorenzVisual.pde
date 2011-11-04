import controlP5.*;
import damkjer.ocd.*;

ControlP5 controlP5;
Camera camera1;


float x=1;
float y=1;
float z=1;

float count=1;
float rotation=0;
float zoom=100;
float iteration = 100;

float	variable0,
		variable1,
		variable2,
		variable3,
		variable4,
		variable5,
		variable6,
		variable7,
		variable8;

Lorenz84 obj;

void setup(){
	size(900, 1000, P3D); 
	background(0);
	lights();
	controlP5 = new ControlP5(this);
 	controlP5.addSlider("zoom",0,1000,zoom,20,20,800,10);

	obj=new Lorenz84();

	variable0=obj.variable[0];
	variable1=obj.variable[1];
	variable2=obj.variable[2];
	variable3=obj.variable[3];
	variable4=obj.variable[4];
	variable5=obj.variable[5];
	variable6=obj.variable[6];
	variable7=obj.variable[7];
	variable8=obj.variable[8];

	
 	controlP5.addSlider("zoom",0,1000,zoom,20,240,800,10);
 	controlP5.addSlider("iteration",0,10000,iteration,20,220,800,10);
 	controlP5.addSlider("variable0",-8,-1,obj.variable[0],20,20,800,10);
 	controlP5.addSlider("variable1",-0.14,1.3,obj.variable[1],20,40,800,10);
 	controlP5.addSlider("variable2",-1,4.6,obj.variable[2],20,60,800,10);
 	controlP5.addSlider("variable3",0,1.94,obj.variable[3],20,80,800,10);
 	controlP5.addSlider("variable4",-0.8,1.9,obj.variable[4],20,100,800,10);
 	controlP5.addSlider("variable5",-6.3,7.8,obj.variable[5],20,120,800,10);
 	controlP5.addSlider("variable6",-0.001,0.18,obj.variable[6],20,140,800,10);
 	controlP5.addSlider("variable7",-0.89,1.8,obj.variable[7],20,160,800,10);
 	controlP5.addSlider("variable8",-0.0,0.18,obj.variable[8],20,180,800,10);
 	

 	
 	camera1 = new Camera(this, 450, 450, 700, 450, 450,0);
//	camera1.feed();
}

void draw(){
	background(0);
	//zoom = mouseY;
	pushMatrix();
		translate(width/2, height/2);
		rotation+=0.01;
		rotateY(rotation);
		obj.zoom=zoom;
		
		obj.variable[0]=variable0;
		obj.variable[1]=variable1;
		obj.variable[2]=variable2;
		obj.variable[3]=variable3;
		obj.variable[4]=variable4;
		obj.variable[5]=variable5;
		obj.variable[6]=variable6;
		obj.variable[7]=variable7;
		obj.variable[8]=variable8;
		obj.iteration=iteration;
		
		
		
		
		obj.generate();
	popMatrix();
	
	camera1.circle(0.01);
	//camera1.feed();
	controlP5.draw(); 

}



