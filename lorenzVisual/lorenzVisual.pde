import controlP5.*;
import damkjer.ocd.*;

ControlP5 controlP5;
Camera camera1;
Lorenz84 obj;


float[] rotation= new float[3],
		variable=new float[9];
	
float	zoom=100,
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
		speed=0.05;

float	xmag, ymag, newXmag, newYmag, diff;
int rotationTimer;


void setup(){
	size(900, 1000, P3D); 
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

	
 	controlP5.addSlider("variable0",-8,-1,obj.variable[0],20,20,800,10);
 	controlP5.addSlider("variable1",-0.14,1.3,obj.variable[1],20,40,800,10);
 	controlP5.addSlider("variable2",-1,4.6,obj.variable[2],20,60,800,10);
 	controlP5.addSlider("variable3",0,1.94,obj.variable[3],20,80,800,10);
 	controlP5.addSlider("variable4",-0.8,1.9,obj.variable[4],20,100,800,10);
 	controlP5.addSlider("variable5",-6.3,7.8,obj.variable[5],20,120,800,10);
 	controlP5.addSlider("variable6",-0.001,0.18,obj.variable[6],20,140,800,10);
 	controlP5.addSlider("variable7",-0.89,1.8,obj.variable[7],20,160,800,10);
 	controlP5.addSlider("variable8",-0.0,0.18,obj.variable[8],20,180,800,10);

 	controlP5.addSlider("iteration",1,10000,iteration,20,220,800,10);
 	controlP5.addSlider("zoom",1,1000,zoom,20,240,800,10);
	
	controlP5.addSlider("rotationX",0,360,rotationX,20,280,800,10);
	controlP5.addSlider("rotationZ",0,360,rotationZ,20,300,800,10);	
	
//	camera1.feed();
}


void draw(){
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


void rotation () {
//	rotationY=obj.rotation[1]+0.5;
	newXmag = mouseX/float(width) * TWO_PI;
	newYmag = mouseY/float(height) * TWO_PI;

	if(mousePressed && mouseY > height/2) {
		rotationTimer = millis();
		
		diff = xmag-newXmag;
		if (abs(diff) >  0.01) rotationY -= degrees(diff/1.0);
	
		diff = ymag-newYmag;
		if (abs(diff) >  0.01) rotationX += degrees(diff/1.0);
		
		speed=0.01;
	}
	else if(millis()-rotationTimer > 5000) {
		
		if(speed<0.4) speed*=1.05;
		else speed=0.4;
		rotationY=obj.rotation[1]+speed;
		if(rotationZ > 0) rotationZ=obj.rotation[2]-speed;
		if(rotationX> 0) rotationX=obj.rotation[0]-speed;
	} 
	else {
		if(speed>0.05) speed*=0.95;
		else speed=0.05;
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


