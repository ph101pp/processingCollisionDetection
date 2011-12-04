class LorenzVisual {
	lorenzSoundThree 	that;
	float			zoom=70,
					speed=0.05,
					xmag, ymag, newXmag, newYmag, diff, rotationX, rotationY, rotationZ;
	int 			rotationTimer;
	
	float[]			rotation= {0,90,0},
					matrix = new float[3],
					position = {1020,510};
					
	
	LorenzVisual(lorenzSoundThree that_) {
		that=that_;
	}
///////////////////////////////////////////////////////////
	void generateShape(float[] startPoint){
		beginShape();
			
			for(int i=0; i<that.points.length; i++) {
				
				
				float	x =that.points[i][0],
						y =that.points[i][1],
						z =that.points[i][2];
			
				float[] boxShades= {1, 20, 50, 100};
				
/*				
				pushMatrix();
					noStroke();
					translate(x*zoom,y*zoom,z*zoom);
				
					for(int k=0; k<boxShades.length; k++) {
						if(k==0) fill(255,255,255,255);
						else fill(255,255,255,10/(k*k));
						box(boxShades[k]);

					}
				popMatrix();
*/


					curveVertex(x*zoom,y*zoom,z*zoom);
			}
		endShape();
	}
}