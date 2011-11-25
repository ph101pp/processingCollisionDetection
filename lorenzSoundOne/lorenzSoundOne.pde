import 			ddf.minim.*;
//import			java.util.ArrayList;
///////////////////////////////////////////////////////////
Minim			minim;
AudioInput		micIn;
lorenzSoundOne	that;
LorenzFormula 	lorenzFormula;
LorenzVisual 	lorenzVisual;
int 			iteration=1000;

float[][] 		points = new float[1000][3];


float 			x1,y1,z1,maxVol;
///////////////////////////////////////////////////////////
void setup() {
	size(700, 700, P3D);
	
	that=this;
	lorenzFormula = new LorenzFormula(this);
	lorenzVisual = new LorenzVisual(this);
	minim = new Minim(this);
	
	
	
	
	minim.debugOn();
  
	// get a line in from Minim, default bit depth is 16
	micIn = minim.getLineOut(Minim.MONO, 512);

}
///////////////////////////////////////////////////////////
void draw() {	
	translate(width/2,height/2);
	background(255);
	stroke(0);
	noFill();
	rotateY(90);
 	points=new float[iteration][3];
 	
	lorenzFormula.iteration=iteration;
	lorenzFormula.animation();
	lorenzFormula.generatePoints();
	
	
//	GET MAX VOLUME		
	maxVol=-2;
	for(int i = 0; i < micIn.bufferSize() - 1; i++) 
		if( maxVol < micIn.mix.get(i) ) 
			maxVol = micIn.mix.get(i);
	
	
	float 	randomCount = (iteration - (iteration*maxVol));
	
	println(randomCount);
	
	for(int k=0; k<iteration; k++) {	
		
		if(k >= randomCount/2 && k<=iteration-randomCount/2) continue;
	
		do{
			x1 = random(0,width)-width/2;
		} while (false && abs(x1) < (width/2)*maxVol);

		do{
			y1 = random(0,height)-height/2;
		} while (false && abs(y1) < (height/2)*maxVol);

		z1 = random(0,700)-700/2;
		
		x1/=that.lorenzVisual.zoom;
		y1/=that.lorenzVisual.zoom;
		z1/=that.lorenzVisual.zoom;
		
		points[k][0]=x1;
		points[k][1]=y1;
		points[k][2]=z1;
		
	}
	lorenzVisual.generateShape(new float[] {0,0,0});
}

