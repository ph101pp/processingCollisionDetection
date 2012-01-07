class LorenzFormula {

	lorenzSoundFinal 		that;
	
	int 				animate=5,
						direction=1;
	
	float 				animationStep=0.001,
						x,y,z;
	
	float[] 			formulaPosition = {465, 85},
						variable= {-1.11, 1.12, 4.49, 0.13, 1.4, 0.4, 0.13, 1.47, 0.13};
/*	
						defaults = {
							{min, max, start}
						};		
*/
	float[][] 			defaults ={
							{-2.5, -1.07, -1.11},
							{0.25, 1.16, 1.12},
							{3, 4.6, 4.49},
							{0, 1.94, 0.13},
							{-0.8, 1.65, 1.4},
							{-4, 2, 0.4},
							{-0.001, 0.18, 0.13},
							{-0.89, 1.5, 1.47},
							{0.01, 0.13, 0.13}
						};
						
						
///////////////////////////////////////////////////////////
	LorenzFormula(lorenzSoundFinal that_) {
		that=that_;
	}
///////////////////////////////////////////////////////////
	void animation(){
		for( int i = 0; i < defaults.length; i++) {
		
			if(animate == i) {
				if(variable[i] <= defaults[i][0]) direction=1;
				if(variable[i] >= defaults[i][1]) direction=-1;
			
				if(direction > 0) variable[i]+=animationStep;
				else variable[i]-=animationStep;
			}
			else {
				if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
				else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
			}
		}
		
	}
///////////////////////////////////////////////////////////
	float[][] generatePoints(int iterations){
		float[][] points=new float[iterations][3];
		x=1;
		y=1;
		z=1;
		
		for(int i=0; i<50; i++) iterate();
		for(int i=0; i<iterations; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;			
			iterate();	
		}
		return points;
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
}
