public class Lorenz84 {
	public 	float x=1;
	public 	float y=1;
	public	float z=1;
	public	float[] firstValues=new float[3];


	public	float[] rotation = {0,0,0};
	public	float iteration=10000;
	public	float zoom = 100;
	public	float[] variable= {-1.11, 1.12, 4.49, 0.13, 1.4, 0.4, 0.13, 1.47, 0.13};
	
///////////////////////////////////////////////////////////
	public	void generate(){
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
	public	void iterate(){
		 float	dx = (variable[0] * x - y * y - z * z + variable[1] * variable[2]) * variable[3],
				dy = (-y + x * y - variable[4] * x * z + variable[5]) * variable[6],
				dz = (-z + variable[7] * x * y + x * z) * variable[8];
		
		x+=dx;
		y+=dy;
		z+=dz;
	}
///////////////////////////////////////////////////////////
	public	void update(float[] variable_, float[] rotation_, float iteration_, float zoom_) {
		int i;
		
		for(i=0; i<variable_.length; i++) variable[i] = variable_[i];	

		for(i=0; i<rotation_.length; i++) rotation[i] = rotation_[i];
		
		iteration=iteration_;
		zoom=zoom_;
	
	}
///////////////////////////////////////////////////////////
	public	void draw (){
		pushMatrix();
			translate(width/2+280, height/2);

			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			obj.generate();
		popMatrix();
	}
}
