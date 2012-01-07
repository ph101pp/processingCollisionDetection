class LorenzVisual {
	lorenzSoundFinal	that;
	float			zoom=70;
	LorenzVisual(lorenzSoundFinal that_) {
		that=that_;
	}
///////////////////////////////////////////////////////////
	void generateShape(float[][] points){
		beginShape();
			for(int i=0; i<points.length; i++) {
				float	x =points[i][0],
						y =points[i][1],
						z =points[i][2];
			
				curveVertex(x*zoom,y*zoom,z*zoom);
			}
		endShape();
	}
}
