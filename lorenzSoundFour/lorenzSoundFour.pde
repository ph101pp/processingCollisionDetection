import 			ddf.minim.*;
//import			java.util.ArrayList;
///////////////////////////////////////////////////////////
Minim			minim;
AudioInput		micIn;
lorenzSoundFour	that;
LorenzFormula 	lorenzFormula;
LorenzVisual 	lorenzVisual;
int 			iteration=1000;

float[][] 		points = new float[1000][3];


float[]			transformMatrix= new float[1000],
				position;

float 			x1,y1,z1,maxVol, averX, averY, averZ;
int				i;
float			rotationY=0;

float			zoom=2;
int 			bufferIndex;
///////////////////////////////////////////////////////////
void setup() {
	size(1500, 1000, P3D);
	
//	position= new float[] {1000, height/2, -300};
	position= new float[] {width/2, height/2, -100};
	that=this;
	lorenzFormula = new LorenzFormula(this);
	lorenzVisual = new LorenzVisual(this);
	minim = new Minim(this);
	
	
	
	
	minim.debugOn();
  
	// get a line in from Minim, default bit depth is 16
	micIn = minim.getLineIn(Minim.MONO, 192);

}
///////////////////////////////////////////////////////////
void draw() {	
 	rotationY +=0.001;
	points=new float[iteration][3];
 	
	
	//	GENERATE POINTS
	lorenzFormula.animation();
	lorenzFormula.generatePoints();
//	/GENERATE POINTS

//	MANIPULATE POINTS
	averX=0;
	averY=0;
	averZ=0;
	i=0;
	for(int k=0; true && k<iteration; k++) {	
		averX+=points[k][0];
		averY+=points[k][1];
		averZ+=points[k][2];
		
		
		bufferIndex=int(map(k, 0, iteration, 0,micIn.bufferSize()));
		
	//	println(micIn.mix.get(bufferIndex));
		float chaosRadius=map(abs(micIn.mix.get(bufferIndex)),-1,1,-250,250);		
		
		
		x1 = random(0,chaosRadius)-chaosRadius/2;
		y1 = random(0,chaosRadius)-chaosRadius/2;
		z1 = random(0,chaosRadius)-chaosRadius/2;
		
		x1/=that.lorenzVisual.zoom;
		y1/=that.lorenzVisual.zoom;
		z1/=that.lorenzVisual.zoom;
		
		
		points[k][0]+=x1;//+0.02*(k-iteration/2);
		points[k][1]+=y1;
		points[k][2]+=z1;
	
		
		averX+=x1;
		averY+=y1;
		averZ+=z1;
		
		i++;
	}
//	/MANIPULATE POINTS

//	PRINT
	
	background(255);
	translate(position[0]-averX/10, position[1]-averY/10, position[2]-averZ/10);
//	rotateY(rotationY);
	fill(255,0,0);
	//box(10);
	
	stroke(10);
	noFill();
	lorenzVisual.generateShape(new float[] {0,0,0});
}

