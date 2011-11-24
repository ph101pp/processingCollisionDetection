import ddf.minim.*;
///////////////////////////////////////////////////////////
Minim minim;
AudioInput micIn;

String hallo="hallooooo";
float x1,y1,x2,y2,maxVol;
///////////////////////////////////////////////////////////
void setup() {
	size(700, 700, P3D);
	
	hallo="tschau";

	minim = new Minim(this);
	minim.debugOn();
  
	// get a line in from Minim, default bit depth is 16
	micIn = minim.getLineIn(Minim.MONO, 512);

}
///////////////////////////////////////////////////////////
void draw() {	
	translate(width/2,height/2);
		
	maxVol=-2;
	for(int i = 0; i < micIn.bufferSize() - 1; i++) 
		if( maxVol < micIn.mix.get(i) ) 
			maxVol = micIn.mix.get(i);
	
	
	background(255);
	stroke(0);

	x1 = (random(0,700)-width/2) *maxVol;
	y1 = (random(0,700)-height/2) *maxVol;

 
 
	for(int i=0; i<=1000; i++) {

		
		x2 = random(0,700)-height/2;
		x2 = x2 - (x2*maxVol);
		y2 = random(0,700)-height/2;
		y2 = y2 - (y2*maxVol);
		
		line(x1,y1,x2,y2);
		
		x1=x2;
		y1=y2;
	}
  
  
}

