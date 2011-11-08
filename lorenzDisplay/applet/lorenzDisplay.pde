LorenzFormula lorenzFormula;
LorenzVisual lorenzVisual;
PFont monaco25;
// The font must be located in the current sketch's 
// "data" directory to load successfully 
void setup(){
	size(900, 1000, P3D); 
	background(0);
	lights();
	loadFont("Monaco-25.vlw");

	lorenzFormula = new LorenzFormula();
	lorenzVisual = new LorenzVisual(lorenzFormula);
	monaco25=loadFont("Monaco-25.vlw");
	
}


void draw(){
	background(0);
	lorenzFormula.animation();
	lorenzFormula.generatePoints();
	lorenzFormula.printFormula();


	lorenzVisual.draw();

}




