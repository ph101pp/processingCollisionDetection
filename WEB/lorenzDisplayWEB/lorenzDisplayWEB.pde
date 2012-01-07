LorenzFormula lorenzFormula;
LorenzVisual lorenzVisual;
PointList pointList;
EventListener eventListener;

public PFont 	frutigerRoman24,
				frutigerRoman16,
				monaco9;
public PImage 	blueLight;


void setup(){
	size(1680, 1050, P3D); 
//	size(900, 1000, P3D); 
	//smooth();
	frameRate(10);
	frutigerRoman24 = loadFont("FrutigerCE-Roman-24.vlw");
	frutigerRoman16 = loadFont("FrutigerCE-Roman-16.vlw");
	monaco9 = loadFont("Monaco-12.vlw");
	
	
	blueLight = loadImage("Lorenz84AbstractorDesign.png");
	background(blueLight);

	lorenzFormula = new LorenzFormula();
	lorenzVisual = new LorenzVisual(lorenzFormula);
	pointList = new PointList(lorenzFormula, lorenzVisual);
	eventListener = new EventListener(lorenzFormula, lorenzVisual, pointList);



}

///////////////////////////////////////////////////////////
void draw(){
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



