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


float[]			transformMatrix= new float[1000],
				position;

float 			x1,y1,z1,maxVol, averX, averY, averZ;
int				i, rotationY=0;



///////////////////////////////////////////////////////////
void setup() {
	size(1500, 1000, P3D);
	
	position= new float[] {1000, height/2, 0};
	that=this;
	lorenzFormula = new LorenzFormula(this);
	lorenzVisual = new LorenzVisual(this);
	minim = new Minim(this);
	
	
	
	
	minim.debugOn();
  
	// get a line in from Minim, default bit depth is 16
	micIn = minim.getLineIn(Minim.MONO, 512);

}
///////////////////////////////////////////////////////////
void draw() {	
 	rotationY +=0.2;
	points=new float[iteration][3];
 	
	
	
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
		transformMatrix[k]=i/1.3;
	}
//	/GET TRANSFROM MATRIX

//	GENERATE POINTS
	lorenzFormula.animation();
	lorenzFormula.generatePoints();
//	/GENERATE POINTS

//	MANIPULATE POINTS
	averX=0;
	averY=0;
	averZ=0;
	i=0;
	for(int k=0; k<iteration; k++) {	
		
		if(k<= maxVol*iteration) continue;

		float chaosRadius=transformMatrix[i];		
		
		
		x1 = random(0,chaosRadius)-chaosRadius/2;
		y1 = random(0,chaosRadius)-chaosRadius/2;
		z1 = random(0,chaosRadius)-chaosRadius/2;
		
		x1/=that.lorenzVisual.zoom;
		y1/=that.lorenzVisual.zoom;
		z1/=that.lorenzVisual.zoom;
		
		
		points[k][0]+=x1;
		points[k][1]+=y1;
		points[k][2]+=z1;
		
		averX+=points[k][0];
		averY+=points[k][1];
		averZ+=points[k][2];
		
		i++;
	}
//	/MANIPULATE POINTS

//	PRINT

	background(255);
	stroke(10);
	noFill();
	println(position);
	translate(position[0]+averX/iteration, position[1]+averY/iteration, position[2]+averZ/iteration);
	rotateY(rotationY);
	lorenzVisual.generateShape(new float[] {0,0,0});
}

