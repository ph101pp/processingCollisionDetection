import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 

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

public class lorenzSoundFinal extends PApplet {


//import			java.util.ArrayList;
///////////////////////////////////////////////////////////
Minim					minim;
AudioInput				micIn;
lorenzSoundFinal		that;
LorenzFormula 			lorenzFormula;
LorenzVisual 			lorenzVisual;
int 					iteration=1000;

float[][] 				lorenzPoints = new float[iteration][3];


float[]					transformMatrix= new float[1000];

float		 			x1,y1,z1,maxVol, averX, averY, averZ;
int						i;
float					rotationY=0;
		
float					zoom=50;
int 					bufferIndex;
///////////////////////////////////////////////////////////
public void setup() {
	size(1680, 1050, P3D);
	stroke(10);
	noFill();
	
	that=this;
	lorenzFormula = new LorenzFormula(this);
	minim = new Minim(this);
	
	
	
	
	minim.debugOn();
	// get a line in from Minim, default bit depth is 16
	micIn = minim.getLineIn(Minim.MONO, 192);

}
///////////////////////////////////////////////////////////
public void draw() {	
	background(255);
 	rotationY +=0.001f;
	lorenzFormula.animation();

	lorenzPoints=lorenzFormula.generatePoints(iteration);
	drawLorenzSoundFour(lorenzPoints.clone());

	lorenzPoints=lorenzFormula.generatePoints(iteration);
	drawLorenzSoundThree(lorenzPoints.clone());
}
///////////////////////////////////////////////////////////
public void drawLorenzSoundFour(float[][] points) {
//	MANIPULATE POINTS
	i=0;
	for(int k=0; true && k<iteration; k++) {	

		bufferIndex=PApplet.parseInt(map(k, 0, iteration, 0,micIn.bufferSize()));
		
	//	println(micIn.mix.get(bufferIndex));
		float chaosRadius=map(abs(micIn.mix.get(bufferIndex)),-1,1,-250,250);		
		
		x1 = random(0,chaosRadius)-chaosRadius/2;
		y1 = random(0,chaosRadius)-chaosRadius/2;
		z1 = random(0,chaosRadius)-chaosRadius/2;
		
		x1/=zoom;
		y1/=zoom;
		z1/=zoom;
				
		points[k][0]+=x1;//+0.02*(k-iteration/2);
		points[k][1]+=y1;
		points[k][2]+=z1;
	
		i++;
	}
	drawShape(points, new PVector(35-240+3*width/4,  30+height/2));
	drawLine(points, new PVector(35+40+3*width/4, 200+height/2));
}
///////////////////////////////////////////////////////////
public void drawLorenzSoundThree (float[][] points) {
//	GET MAX VOLUME		
	maxVol=-2;
	for(int i = 0; i < micIn.bufferSize() - 1; i++) 
		if( maxVol < micIn.mix.get(i) ) 
			maxVol = micIn.mix.get(i);
//	/GET MAX VOLUME		
//	GET TRANSFROM MATRIX
	float 	randomCount = (iteration - (iteration*maxVol));
	i=0;
	for(int k=0; k<iteration; k++) {
		if(k%10 ==0 || true) i++;
		transformMatrix[k]=map(i, 0,1000,0,250);
	}
//	/GET TRANSFROM MATRIX

//	MANIPULATE POINTS
	i=0;
	for(int k=0; true && k<iteration; k++) {	
		if(true && k> map(maxVol, 0,0.5f, iteration, 0)) continue;

		float chaosRadius=transformMatrix[i];		
		
		
		x1 = random(0,chaosRadius)-chaosRadius/2;
		y1 = random(0,chaosRadius)-chaosRadius/2;
		z1 = random(0,chaosRadius)-chaosRadius/2;
		
		x1/=zoom;
		y1/=zoom;
		z1/=zoom;
		
		
		points[k][0]+=x1;
		points[k][1]+=y1;
		points[k][2]+=z1;

		i++;
	
	}
	drawShape(points, new PVector(35+250+width/4, 30+height/2));
	drawLine(points, new PVector(35-110+width/4, 200+height/2));
}
///////////////////////////////////////////////////////////
public void drawLine(float[][] points, PVector position) {

	for(int k=0; true && k<iteration; k++) {	
		points[k][1]-=map(k, 0,1000,0,400/20);
	}
	
	pushMatrix();
		translate(position.x, position.y);
		fill(255,0,0);
	//	box(10);
		noFill();
		generateShape(points, 20);
	popMatrix();
}
///////////////////////////////////////////////////////////
public void drawShape(float[][] points, PVector position) {
	averX=0;
	averY=0;
	averZ=0;
	for(int k=0; true && k<iteration; k++) {	
		averX+=points[k][0];
		averY+=points[k][1];
		averZ+=points[k][2];
	}
	averX/=iteration;
	averY/=iteration;
	averZ/=iteration;
//	/MANIPULATE POINTS
	pushMatrix();
		translate(position.x-averX*zoom, position.y-averY*zoom);
	//	rotateY(rotationY);
//		rotateY(90);
		fill(255,0,0);
	//	box(10);
		noFill();
		generateShape(points, zoom);
	popMatrix();
}
///////////////////////////////////////////////////////////
public void generateShape(float[][] points, float zoom){
	beginShape();
		for(int i=0; i<points.length; i++) {
			float	x =points[i][0],
					y =points[i][1],
					z =points[i][2];
		
			curveVertex(x*zoom,y*zoom,z*zoom);
		}
	endShape();
}
class LorenzFormula {

	lorenzSoundFinal 		that;
	
	int 				animate=5,
						direction=1;
	
	float 				animationStep=0.001f,
						x,y,z;
	
	float[] 			formulaPosition = {465, 85},
						variable= {-1.11f, 1.12f, 4.49f, 0.13f, 1.4f, 0.4f, 0.13f, 1.47f, 0.13f};
/*	
						defaults = {
							{min, max, start}
						};		
*/
	float[][] 			defaults ={
							{-2.5f, -1.07f, -1.11f},
							{0.25f, 1.16f, 1.12f},
							{3, 4.6f, 4.49f},
							{0, 1.94f, 0.13f},
							{-0.8f, 1.65f, 1.4f},
							{-4, 2, 0.4f},
							{-0.001f, 0.18f, 0.13f},
							{-0.89f, 1.5f, 1.47f},
							{0.01f, 0.13f, 0.13f}
						};
						
						
///////////////////////////////////////////////////////////
	LorenzFormula(lorenzSoundFinal that_) {
		that=that_;
	}
///////////////////////////////////////////////////////////
	public void animation(){
		for( int i = 0; i < defaults.length; i++) {
		
			if(animate == i) {
				if(variable[i] <= defaults[i][0]) direction=1;
				if(variable[i] >= defaults[i][1]) direction=-1;
			
				if(direction > 0) variable[i]+=animationStep;
				else variable[i]-=animationStep;
			}
			else {
				if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
				else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
			}
		}
		
	}
///////////////////////////////////////////////////////////
	public float[][] generatePoints(int iterations){
		float[][] points=new float[iterations][3];
		x=1;
		y=1;
		z=1;
		
		for(int i=0; i<50; i++) iterate();
		for(int i=0; i<iterations; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;			
			iterate();	
		}
		return points;
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
}
class LorenzVisual {
	lorenzSoundFinal	that;
	float			zoom=70;
	LorenzVisual(lorenzSoundFinal that_) {
		that=that_;
	}
///////////////////////////////////////////////////////////
	public void generateShape(float[][] points){
		beginShape();
			for(int i=0; i<points.length; i++) {
				float	x =points[i][0],
						y =points[i][1],
						z =points[i][2];
			
				curveVertex(x*zoom,y*zoom,z*zoom);
			}
		endShape();
	}
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "lorenzSoundFinal" });
  }
}
