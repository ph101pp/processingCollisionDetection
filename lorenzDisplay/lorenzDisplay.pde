import fullscreen.*;
import japplemenubar.*;

LorenzFormula lorenzFormula;
LorenzVisual lorenzVisual;
FullScreen fullScreen;

//PointList pointList;
PFont frutigerRoman24;
PImage blueLight;
// The font must be located in the current sketch's 
// "data" directory to load successfully 
void setup(){
	size(1680, 1050, P3D); 
//	size(900, 1000, P3D); 
	lights();
	frutigerRoman24 = loadFont("FrutigerCE-Roman-24.vlw");
	blueLight = loadImage("images/Lorenz84AbstractorDesign.png");
	background(blueLight);

	fullScreen = new FullScreen(this); 
	lorenzFormula = new LorenzFormula();
	lorenzVisual = new LorenzVisual(lorenzFormula);
//	pointList = new pointList(lorenzFormula);



	
	fullScreen.enter(); 


}


void draw(){
	background(blueLight);
	drawStaticElements();
	
	lorenzFormula.animation();
	lorenzFormula.formulaEventListener();
	lorenzFormula.generatePoints();
	lorenzFormula.printFormula();

	lorenzVisual.draw();
	
//	pointList.draw();

}

void drawStaticElements(){

}




