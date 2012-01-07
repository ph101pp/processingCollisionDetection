import 			ddf.minim.*;
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
void setup() {
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
void draw() {	
	background(255);
 	rotationY +=0.001;
	lorenzFormula.animation();

	lorenzPoints=lorenzFormula.generatePoints(iteration);
	drawLorenzSoundFour(lorenzPoints.clone());

	lorenzPoints=lorenzFormula.generatePoints(iteration);
	drawLorenzSoundThree(lorenzPoints.clone());
}
///////////////////////////////////////////////////////////
void drawLorenzSoundFour(float[][] points) {
//	MANIPULATE POINTS
	i=0;
	for(int k=0; true && k<iteration; k++) {	

		bufferIndex=int(map(k, 0, iteration, 0,micIn.bufferSize()));
		
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
void drawLorenzSoundThree (float[][] points) {
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
		if(true && k> map(maxVol, 0,0.5, iteration, 0)) continue;

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
void drawLine(float[][] points, PVector position) {

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
void drawShape(float[][] points, PVector position) {
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
void generateShape(float[][] points, float zoom){
	beginShape();
		for(int i=0; i<points.length; i++) {
			float	x =points[i][0],
					y =points[i][1],
					z =points[i][2];
		
			curveVertex(x*zoom,y*zoom,z*zoom);
		}
	endShape();
}
