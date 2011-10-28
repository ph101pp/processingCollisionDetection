float x=1;
float y=1;
float z=1;

float dx,dy,dz;
float count=1;

float maxCount=1000;
int zoom = 10;


void setup(){
	size(900, 900, P3D); 
	background(0);
	lights();
	
	
	generate();
}

void generate(){
		
	
	
	for(int i=1; i<=10; i++) countUp();
	
	stroke(255);
	noFill();
	beginShape();
	
	float[] startValues = {x,y,z};
	
	for(int i=1; i<=maxCount; i++) {
		curveVertex(450+x*zoom,450+y*zoom,450+z*zoom);
	
		countUp();
	}
	curveVertex(450+startValues[0]*zoom,450+startValues[1]*zoom,450+startValues[2]*zoom);
	
	
 
	endShape();
	
	
}

void countUp(){

	float	dx = (-1.11 * x - y * y - z * z + 1.12 * 4.49) * 0.13,
			dy = (-y + x * y - 1.47 * x * z + 0.4) * 0.13,
			dz = (-z + 1.47 * x * y + x * z) * 0.13;
	
	x+=dx;
	y+=dy;
	z+=dz;
	
}
