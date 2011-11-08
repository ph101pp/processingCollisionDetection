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

public class lorenzDisplay extends PApplet {

LorenzFormula lorenzFormula;
LorenzVisual lorenzVisual;
PFont monaco25;
// The font must be located in the current sketch's 
// "data" directory to load successfully 
public void setup(){
	size(900, 1000, P3D); 
	background(0);
	lights();
	loadFont("Monaco-25.vlw");

	lorenzFormula = new LorenzFormula();
	lorenzVisual = new LorenzVisual(lorenzFormula);
	monaco25=loadFont("Monaco-25.vlw");
	
}


public void draw(){
	background(0);
	lorenzFormula.animation();
	lorenzFormula.generatePoints();
	lorenzFormula.printFormula();


	lorenzVisual.draw();

}




class LorenzFormula {
	int animate=5,
		direction=1,
		iteration=1000;
	
	float 	animationStep=0.0001f,
			x,y,z;
	
/*	
defaults = {
	{min, max, start}
};		
*/
	float[][] defaults ={
			{-8, -1, -1.11f},
			{-0.14f, 1.3f, 1.12f},
			{-1, 4.6f, 4.49f},
			{0, 1.94f, 0.13f},
			{-0.8f, 1.9f, 1.4f},
			{-6.3f, 7.8f, 0.4f},
			{-0.001f, 0.18f, 0.13f},
			{-0.89f, 1.8f, 1.47f},
			{0, 0.18f, 0.13f}
		};
	
	float[] variable= {-1.11f, 1.12f, 4.49f, 0.13f, 1.4f, 0.4f, 0.13f, 1.47f, 0.13f};
	
	float[][] points = new float[iteration][3];
	
///////////////////////////////////////////////////////////
	public void animation(){
		for( int i = 0; i < defaults.length; i++) {
		
			if(animate == i) {
				if(variable[i] <= defaults[i][0]) direction=1;
				if(variable[i] >= defaults[i][1]) direction=-1;
			
				if(direction > 0) variable[i]+=animationStep;
				else variable[i]-=animationStep;
			}
			else if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
			else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
	
		}
	}
///////////////////////////////////////////////////////////
	public void formulaEventListener (){
	
	}
///////////////////////////////////////////////////////////
	public void generatePoints(){
		x=1;
		y=1;
		z=1;
		
		for(int i=0; i<20; i++) iterate();
		for(int i=0; i<iteration; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;			
			iterate();	
		}
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
//////////////////////////////////////////////////////////
	public void printFormula(){
		String x = "( "+variable[0]+" * x - y * y - z * z + "+variable[1]+" * "+variable[2]+") * "+variable[3],
			y="",z="";
	
	
		textAlign(RIGHT);
		text(x, 20, 20, width-40, 200); 
		text(y, 20, 65, width-40, 200); 
		text(z, 20, 110, width-40, 200); 
	
	}
}
class LorenzVisual {
	LorenzFormula 	lorenzFormula;
	float			zoom=100,
					speed=0.05f,
					xmag, ymag, newXmag, newYmag, diff, rotationX, rotationY, rotationZ;
	int 			rotationTimer;
	
	float[]			rotation= new float[3];
	
	LorenzVisual(LorenzFormula lorenzFormula_) {
		lorenzFormula=lorenzFormula_;
	}
///////////////////////////////////////////////////////////

	public void rotation () {
	//	rotationY=obj.rotation[1]+0.5;
		newXmag = mouseX/PApplet.parseFloat(width) * TWO_PI;
		newYmag = mouseY/PApplet.parseFloat(height) * TWO_PI;
	
		if(mousePressed && mouseY > height/2) {
			rotationTimer = millis();
			
			diff = xmag-newXmag;
			if (abs(diff) >  0.01f) rotationY -= degrees(diff/1.0f);
		
			diff = ymag-newYmag;
			if (abs(diff) >  0.01f) rotationX += degrees(diff/1.0f);
			
			speed=0.01f;
		}
		else {
			if(millis()-rotationTimer > 5000) {
				if(speed<0.4f) speed*=1.05f;
				else speed=0.4f;
			} 
			else {
				if(speed>0.05f) speed*=0.95f;
				else speed=0.05f;
			}
			
/*			if(rotationY <91 && rotationY>89) rotationY=90;
			else if(rotationY > 90) rotationY=rotation[1]-speed;
			else if(rotationY < 90) rotationY=rotation[1]+speed;
*/			
			rotationY=rotation[1]+speed;

			
			if(rotationZ > 0) rotationZ=rotation[2]-speed;
			if(rotationX> 0) rotationX=rotation[0]-speed;

		}
		
		xmag=newXmag;
		ymag=newYmag;
		rotation[0] = rotationX;
		rotation[1] = rotationY;
		rotation[2] = rotationZ;
	
	}
///////////////////////////////////////////////////////////
	public void generateShape(){
		beginShape();
			for(int i=0; i<lorenzFormula.points.length; i++) {
				float 	x =lorenzFormula.points[i][0],
						y =lorenzFormula.points[i][1],
						z =lorenzFormula.points[i][2];
			
					curveVertex(x*zoom,y*zoom,z*zoom);
			}
		endShape();
	}
	
///////////////////////////////////////////////////////////
	
	public void draw (){
		rotation();
		pushMatrix();
			translate(width/2-30, 100+height/2);
			stroke(255);
			noFill();
			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			generateShape();
		popMatrix();
	}
	
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "lorenzDisplay" });
  }
}
