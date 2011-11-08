class LorenzFormula {
	int animate=5,
		direction=1,
		iteration=1000;
	
	float 	animationStep=0.0001,
			x,y,z;
	
/*	
defaults = {
	{min, max, start}
};		
*/
	float[][] defaults ={
			{-8, -1, -1.11},
			{-0.14, 1.3, 1.12},
			{-1, 4.6, 4.49},
			{0, 1.94, 0.13},
			{-0.8, 1.9, 1.4},
			{-6.3, 7.8, 0.4},
			{-0.001, 0.18, 0.13},
			{-0.89, 1.8, 1.47},
			{0, 0.18, 0.13}
		};
	
	float[] variable= {-1.11, 1.12, 4.49, 0.13, 1.4, 0.4, 0.13, 1.47, 0.13};
	
	float[][] points = new float[iteration][3];
	
///////////////////////////////////////////////////////////
	void animation(){
		for( int i = 0; i < defaults.length; i++) {
		
			if(animate == i) {
				if(variable[i] <= defaults[i][0]) direction=1;
				if(variable[i] >= defaults[i][1]) direction=-1;
			
				if(direction > 0) variable[i]+=animationStep;
				else variable[i]-=animationStep;
			}
			else if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
			else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
	
		}
	}
///////////////////////////////////////////////////////////
	void formulaEventListener (){
	
	}
///////////////////////////////////////////////////////////
	void generatePoints(){
		x=1;
		y=1;
		z=1;
		
		for(int i=0; i<20; i++) iterate();
		for(int i=0; i<iteration; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;			
			iterate();	
		}
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
//////////////////////////////////////////////////////////
	void printFormula(){
		String 	x = "( "+variable[0]+" * x - y * y - z * z + "+variable[1]+" * "+variable[2]+") * "+variable[3],
				y="( -y + x * y - "+variable[4]+" * x * z + "+variable[5]+") * "+variable[6],
				z="(-z + "+variable[7]+" * x * y + x * z) * "+variable[8];
	
	
		textAlign(RIGHT);
		textFont(monaco25);
		text(x, 20, 20, width-40, 200); 
		text(y, 20, 45, width-40, 200); 
		text(z, 20, 70, width-40, 200); 
	
	}
}