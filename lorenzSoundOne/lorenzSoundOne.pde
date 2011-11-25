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
	
	position= new float[] {1000, height/2, -300};
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
 	rotationY +=0.5;
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
	for(int k=0; true && k<iteration; k++) {	
		averX+=points[k][0];
		averY+=points[k][1];
		averZ+=points[k][2];
		
		if(true && k<= maxVol*iteration) continue;

		float chaosRadius=transformMatrix[i];		
		
		
		x1 = noise(0,chaosRadius)-chaosRadius/2;
		y1 = noise(0,chaosRadius)-chaosRadius/2;
		z1 = noise(0,chaosRadius)-chaosRadius/2;
		
		x1/=that.lorenzVisual.zoom;
		y1/=that.lorenzVisual.zoom;
		z1/=that.lorenzVisual.zoom;
		
		
		points[k][0]+=x1;
		points[k][1]+=y1;
		points[k][2]+=z1;
		
		averX+=x1;
		averY+=y1;
		averZ+=z1;
		
		i++;
	}
//	/MANIPULATE POINTS

//	PRINT
	
	println(averX);
	println(averY);
	
	background(255);
	translate(position[0]-averX/10, position[1]-averY/10, position[2]-averZ/10);
	rotateY(rotationY);

	fill(255,0,0);
	box(10);
	
	stroke(10);
	noFill();
	lorenzVisual.generateShape(new float[] {0,0,0});
}

