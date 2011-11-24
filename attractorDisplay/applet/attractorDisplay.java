import processing.core.*; 
import processing.xml.*; 

import fullscreen.*; 
import japplemenubar.*; 

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

public class attractorDisplay extends PApplet {




LorenzFormula lorenzFormula;
LorenzVisual lorenzVisual;
FullScreen fullScreen;
PointList pointList;
EventListener eventListener;

PFont 	frutigerRoman24,
		frutigerRoman16,
		monaco9;
PImage blueLight;


public void setup(){
	size(1680, 1050, P3D); 
//	size(900, 1000, P3D); 
	frutigerRoman24 = loadFont("FrutigerCE-Roman-24.vlw");
	frutigerRoman16 = loadFont("FrutigerCE-Roman-16.vlw");
	monaco9 = loadFont("Monaco-12.vlw");
	
	
	blueLight = loadImage("images/Lorenz84AbstractorDesign.png");
	background(blueLight);

	fullScreen = new FullScreen(this); 
	lorenzFormula = new LorenzFormula();
	lorenzVisual = new LorenzVisual(lorenzFormula);
	pointList = new PointList(lorenzFormula, lorenzVisual);
	eventListener = new EventListener(lorenzFormula, lorenzVisual, pointList);



	
	fullScreen.enter(); 


}

///////////////////////////////////////////////////////////
public void draw(){
	background(blueLight);
	
	if(!lorenzFormula.paused) lorenzFormula.animation();
	lorenzFormula.formulaEventListener();
	lorenzFormula.generatePoints();
	lorenzFormula.printFormula(lorenzVisual);

	lorenzVisual.draw();
	
	pointList.draw();
	eventListener.click();
	eventListener.hover();

}



class PointList {

	LorenzFormula 	lorenzFormula;
	LorenzVisual 	lorenzVisual;
	
	ListPoint[] listPoint;
	
	int startValue=1;
	
	PointList(LorenzFormula lorenzFormula_, LorenzVisual lorenzVisual_) {
		lorenzFormula=lorenzFormula_;
		lorenzVisual=lorenzVisual_;
		listPoint= new ListPoint[lorenzFormula.points.length];
	}
///////////////////////////////////////////////////////////
	
	
	public void draw(){
		pushMatrix();
			moveList();
			for(int i=startValue; startValue+110 > i && i<lorenzFormula.points.length; i++) {
					
				listPoint[i]= new ListPoint(i,lorenzFormula.points[i], 120, (i-startValue)*13+35);
				
			}
		popMatrix();
	}
///////////////////////////////////////////////////////////
	public void moveList() {
		if(mouseX <120 || mouseX > 420) return;
		
		if(mouseY <200 && startValue>1) startValue--;
		if(mouseY > height-200 && startValue < lorenzFormula.points.length-103) startValue++;
	
	
	}

}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
class ListPoint {
	int	count;
	float[] thisPoint;
	float	x,y,
			w=400,
			h=14;	

	
	
	ListPoint(int count_, float[] thisPoint_, float x_, float y_){
		count=count_;
		thisPoint=thisPoint_;
		x=x_;
		y=y_;		
		
		drawPoint();
	}
///////////////////////////////////////////////////////////
	public void drawPoint (){
		
		if(mouseX > x && mouseX < x+w && mouseY>y && mouseY < y+h ) {
			highlight();
			return;
		}
		
		textAlign(LEFT);
		fill(255);
		textFont(monaco9);
		
		int stelleX = thisPoint[0] >0 ? 2 : 1,
			stelleY = thisPoint[1] >0 ? 2 : 1,
			stelleZ = thisPoint[2] >0 ? 2 : 1;
		
		
		text(nf(count,5)+":   x="+nf(thisPoint[0],stelleX,5)+"   y="+nf(thisPoint[1],stelleY,5)+"   z="+nf(thisPoint[2],stelleZ,5), x, y, w, h);
		
	}	
	
///////////////////////////////////////////////////////////
	public void highlight (){
		stroke(191,231,251);
		fill(0);
		rect(x-10,y-20,400, 30);
		
		noFill();
		float	actualX =thisPoint[0]*lorenzVisual.zoom,
				actualY =thisPoint[1]*lorenzVisual.zoom,
				actualZ =thisPoint[2]*lorenzVisual.zoom;
		
		pushMatrix();
			translate(lorenzVisual.position[0], lorenzVisual.position[1]);
			rotateX(radians(lorenzVisual.rotation[0]));
			rotateY(radians(lorenzVisual.rotation[1]));
			rotateZ(radians(lorenzVisual.rotation[2]));

			pushMatrix();
				translate(actualX,actualY,actualZ);
				fill(191,231,251,200);
				noStroke();
				box(7);
				stroke(191,231,251);
				strokeWeight(2);
				line(0,0,0, -actualX,-actualY,-actualZ);
			popMatrix();
		popMatrix();
		
		line(x-10+400,y-20+15, lorenzVisual.position[0], lorenzVisual.position[1]);
		strokeWeight(1);
		
		rectMode(CORNER);
		textAlign(LEFT);
		fill(255);
		textFont(frutigerRoman16);

		int stelleX = thisPoint[0] >0 ? 2 : 1,
			stelleY = thisPoint[1] >0 ? 2 : 1,
			stelleZ = thisPoint[2] >0 ? 2 : 1;

		text(nf(count,5)+":     x="+nf(thisPoint[0],stelleX,5)+"     y="+nf(thisPoint[1],stelleY,5)+"     z="+nf(thisPoint[2],stelleZ,5), x, y-12, 400, 30);
		
	}

}
class LorenzFormula {
	boolean paused=false;

	int animate=5,
		direction=1,
		iteration=1000;
	
	float 	animationStep=0.000001f,
			x,y,z;
	
/*	
defaults = {
	{min, max, start}
};		
*/
	float[][] defaults ={
			{-1, 3, 1},
			{ -0.8f,  3.8f, 1.8f},
			{-2.71f,2.71f, 0.71f},
			{-1.51f,3.51f, 1.51f},
		};
		
	float[][] targetAreas = {
		{75,-5},
		{390,-5},
		{515,-5},
		{655,-5},
	};
	
	float[] formulaPosition = {465, 85};
	
	float[] variable= {1, 1.8f, 0.71f, 1.51f};
	
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
			else {
				if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
				else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
			}
		}
		
	}
///////////////////////////////////////////////////////////
	public void formulaEventListener (){
		if(!mousePressed) return;
		
		for(int i=0; i<targetAreas.length; i++) {
			if(mouseY > targetAreas[i][1]+formulaPosition[1] && mouseY < targetAreas[i][1]+30+formulaPosition[1] && mouseX > targetAreas[i][0]+formulaPosition[0] && mouseX < targetAreas[i][0]+100+formulaPosition[0]) {
				animate=i;
				direction=1;
			}
		};
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
		float	dx = sin(variable[0]*y)-z*cos(variable[1]*x),
				dy = z*sin(variable[2]*x)-cos(variable[3]*x),
				dz = sin(x);
		x+=dx;
		y+=dy;
		z+=dz;
	}
//////////////////////////////////////////////////////////
	public void printFormula(LorenzVisual lorenzVisual){
		int stellen=5;
		String 	x="dx = sin(y*"+nf(variable[0],1,stellen)+") - z* cos(x*"+nf(variable[1],1,stellen)+");",
				y="dx = z*sin(x*"+nf(variable[2],1,stellen)+") - cos(y*"+nf(variable[3],1,stellen)+");",
				z="dz = sin(x);";
		
		pushMatrix();
			translate(formulaPosition[0],formulaPosition[1]);
			textAlign(LEFT);
			fill(38,46,49);
			textFont(frutigerRoman24);
			text(x, 0, 0, width-40, 200); 
			text(y, 0, 32, width-40, 200); 
			text(z, 0, 64, width-40, 200); 
			
/*			text("Rotation X: "+nf(lorenzVisual.rotation[0],3,2)+" Degrees", 0, 106, width-40, 200 );
			text("Rotation Y: "+nf(lorenzVisual.rotation[1],3,2)+" Degrees", 0, 138, width-40, 200 );
			text("Points: "+iteration, 0, 170, width-40, 200 );
*/			
			
			for(int i=0; i<targetAreas.length; i++) {
				noFill();
				stroke(38,46,49);
				
				if(mouseY > targetAreas[i][1]+formulaPosition[1] && mouseY < targetAreas[i][1]+30+formulaPosition[1] && mouseX > targetAreas[i][0]+formulaPosition[0] && mouseX < targetAreas[i][0]+100+formulaPosition[0]) 
					stroke(191,231,251);
					
				if(i == animate) {
					noStroke();
					fill(0);
					rect(targetAreas[i][0],targetAreas[i][1],100,30);
					stroke(191,231,251);
					line(targetAreas[i][0],targetAreas[i][1]+30, targetAreas[i][0]+100 ,targetAreas[i][1]+30);
					fill(255);
					noStroke();
					text(nf(variable[i],1,stellen),targetAreas[i][0]+8,targetAreas[i][1]+5,100,30);
				}
				else  line(targetAreas[i][0],targetAreas[i][1]+30, targetAreas[i][0]+100 ,targetAreas[i][1]+30);

								
			
			
			};

		popMatrix();
	
	}
}
class LorenzVisual {
	LorenzFormula 	lorenzFormula;
	float			zoom=1,
					speed=0.05f,
					xmag, ymag, newXmag, newYmag, diff, rotationX, rotationY, rotationZ;
	int 			rotationTimer;
	
	float[]			rotation= new float[3],
					matrix = new float[3],
					position = {1020,510};
					
	
	LorenzVisual(LorenzFormula lorenzFormula_) {
		lorenzFormula=lorenzFormula_;
	}
///////////////////////////////////////////////////////////

	public void rotation () {
	//	rotationY=obj.rotation[1]+0.5;
		newXmag = mouseX/PApplet.parseFloat(width) * TWO_PI;
		newYmag = mouseY/PApplet.parseFloat(height) * TWO_PI;
	
		if(mousePressed && mouseY > 200 && mouseX > 400) {
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
		for(int i=0; i<lorenzFormula.points.length; i++) {
			float 	x =lorenzFormula.points[i][0],
					y =lorenzFormula.points[i][1],
					z =lorenzFormula.points[i][2];
				pushMatrix();
					noStroke();
					translate(x*zoom,y*zoom,z*zoom);
				
					
					for(int k=1 ; k<10; k++) {
						fill(255,255,255,100/k);
						sphere(k);

					}
				popMatrix();
		}
	}
	
///////////////////////////////////////////////////////////
	
	public void draw (){
		rotation();
		pushMatrix();
			translate(position[0], position[1]);

			stroke(39,46,49);
			
/*			line(0,0,0,100,0,0);
			line(0,0,0,0,-100,0);
			line(0,0,0,0,0,100);
*/
//			rect(0,0,0,1,1,1);

			stroke(255,255,255,200);
			noFill();
			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			matrix[0] = modelX(0,0,0);
			matrix[1] = modelY(0,0,0);
			matrix[2] = modelZ(0,0,0);
	

			generateShape();
		popMatrix();
	}
	
}
class EventListener {
	
	LorenzFormula 	lorenzFormula;
	LorenzVisual 	lorenzVisual;
	PointList		pointList;
	
	boolean clicked = false;
	
	EventListener(LorenzFormula lorenzFormula_, LorenzVisual lorenzVisual_, PointList pointList_) {
		lorenzFormula=lorenzFormula_;
		lorenzVisual=lorenzVisual_;
		pointList=pointList_;
	}
///////////////////////////////////////////////////////////
	
	public void click() {
		if(!mousePressed) {
			clicked = false;
			return;
		} 
		else {
			if(clicked) return;
			clicked = true;
		}
			
//		Pause
		if(mouseX > 1535 && mouseX < 1563 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1535,989,28,28);
			lorenzFormula.paused=lorenzFormula.paused ? false:true;
		}
		
//		Reset
		if(mouseX > 1574 && mouseX < 1602 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1574,989,28,28);
			for(int i=0; i<lorenzFormula.variable.length; i++) lorenzFormula.variable[i]=lorenzFormula.defaults[i][2];
		}
		
//		ScreenShot
		if(mouseX > 1613 && mouseX < 1641 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1613,989,28,28);
			
			String name=nf(year(),2)+""+nf(month(),2)+""+nf(day(),2)+""+nf(hour(),2)+""+nf(minute(),2)+""+nf(second(),2)+".png";
			save("screenShots/"+name);
		}
		
		
	}
///////////////////////////////////////////////////////////
	public void hover() {
	
//		Pause
		if(mouseX > 1535 && mouseX < 1563 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1535,989,28,28);
			strokeWeight(1);
		}
		
//		Reset
		if(mouseX > 1574 && mouseX < 1602 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1574,989,28,28);
			strokeWeight(1);
		}
		
//		ScreenShot
		if(mouseX > 1613 && mouseX < 1641 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1613,989,28,28);
			strokeWeight(1);
		}

	
	
	
	
	}




}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "attractorDisplay" });
  }
}
