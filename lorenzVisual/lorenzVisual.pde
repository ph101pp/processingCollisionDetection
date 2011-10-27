float x=1;
float y=1;
float z=1;


void setup(){
	size(900, 900, P3D); 
	background(0);
	lights();
	frameRate(2000);
	
	

}

void draw(){
	noStroke();
	fill(0,0,255);
	pushMatrix();
	
	float dx=x*100;
	float dy=y*100;
	float dz=z*100;
	
	println(dx);
	println(dy);
	println(dz);
	println("schau");

	translate(dx+450, dy+450, dz);
	rotateY(0);
	rotateX(0);
	box(3);
	popMatrix();
	
	countUp();
}

void countUp(){

		
	x += (-1.11 * x - y * y - z * z + 1.11 * 4.49) * 0.13;
	y += (-y + x * y - 1.47 * x * z + 0.4) * 0.13;
	z += (-z + 1.47 * x * y + x * z) * 0.13;
	
}
