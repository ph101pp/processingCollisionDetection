class Lorenz84 {
	float x=1;
	float y=1;
	float z=1;
	float[] firstValues=new float[3];


	float[] rotation = {0,0,0};
	float iteration=10000;
	float zoom = 100;
	float[] variable= {-1.11, 1.12, 4.49, 0.13, 1.4, 0.4, 0.13, 1.47, 0.13};
	
///////////////////////////////////////////////////////////
	void generate(){
		x=1;
		y=1;
		z=1;
		
		for(int i=1; i<=20; i++) iterate();
		
		stroke(255);
		noFill();
		
		beginShape();
			curveVertex(x*zoom,y*zoom,z*zoom);
			float[] startValues = {x,y,z};
	
			for(int i=1; i<=iteration; i++) {
				iterate();
				curveVertex(x*zoom,y*zoom,z*zoom);
			}

/*
			x=startValues[0];
			y=startValues[1];
			z=startValues[2];
			
	 		curveVertex(x*zoom,y*zoom,z*zoom);
	 		iterate();
	 		curveVertex(x*zoom,y*zoom,z*zoom);
	 		iterate();
	 		curveVertex(x*zoom,y*zoom,z*zoom);
*/			
		endShape();
	
	
	}

///////////////////////////////////////////////////////////
	void iterate(){
		float	dx = (variable[0] * x - y * y - z * z + variable[1] * variable[2]) * variable[3],
				dy = (-y + x * y - variable[4] * x * z + variable[5]) * variable[6],
				dz = (-z + variable[7] * x * y + x * z) * variable[8];
		
		x+=dx;
		y+=dy;
		z+=dz;
	}
///////////////////////////////////////////////////////////
	void draw (){
		pushMatrix();
			translate(width/2-30, 100+height/2);

			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			obj.generate();
		popMatrix();
	}
}