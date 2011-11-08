class LorenzFormula {
	int animate=5,
		direction=1,
		iteration=1000;
	
	float 	animationStep=0.01,
			x,y,z;
	
/*	
defaults = {
	{min, max, start}
};		
*/
	float[][] defaults ={
			{-8, -1.11, -1.11},
			{-0.14, 1.3, 1.12},
			{-1, 4.6, 4.49},
			{0, 1.94, 0.13},
			{-0.8, 1.9, 1.4},
			{-4, 2, 0.4},
			{-0.001, 0.18, 0.13},
			{-0.89, 1.7, 1.47},
			{0, 0.15, 0.13}
		};
		
	float[][] targetAreas = {
		{75,-5},
		{390,-5},
		{515,-5},
		{655,-5},
		{190,27},
		{395,27},
		{535,27},
		{110,59},
		{400,59}
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
			else {
				if(variable[i] > defaults[i][2]) variable[i]-=animationStep;
				else if(variable[i] < defaults[i][2]) variable[i]+=animationStep;
			}
		}
		
	}
///////////////////////////////////////////////////////////
	void formulaEventListener (){
		if(!mousePressed) return;
		
		for(int i=0; i<targetAreas.length; i++) {
			if(mouseY > targetAreas[i][1]+80 && mouseY < targetAreas[i][1]+30+80 && mouseX > targetAreas[i][0]+385 && mouseX < targetAreas[i][0]+100+385) {
				animate=i;
				direction=1;
			}
		};
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
		int stellen=5;
		String 	x="dx = (  "+nf(variable[0],1,stellen)+"  * x - y * y - z * z +  "+nf(variable[1],1,stellen)+"  *  "+nf(variable[2],1,stellen)+"  ) *  "+nf(variable[3],1,stellen),
				y="dy = ( -y + x * y -  "+nf(variable[4],1,stellen)+"  * x * z +  "+nf(variable[5],1,stellen)+"  ) *  "+nf(variable[6],1,stellen),
				z="dz = (-z +  "+nf(variable[7],1,stellen)+"  * x * y + x * z) *  "+nf(variable[8],1,stellen);
		
		pushMatrix();
			translate(385,80);
			textAlign(LEFT);
			fill(38,46,49);
			textFont(frutigerRoman24);
			text(x, 0, 0, width-40, 200); 
			text(y, 0, 32, width-40, 200); 
			text(z, 0, 64, width-40, 200); 
			
			
			for(int i=0; i<targetAreas.length; i++) {
				noFill();
				stroke(38,46,49);
				
				if(mouseY > targetAreas[i][1]+80 && mouseY < targetAreas[i][1]+30+80 && mouseX > targetAreas[i][0]+385 && mouseX < targetAreas[i][0]+100+385) 
					stroke(191,231,251);
					
				if(i == animate) {
					stroke(191,231,251);
					fill(0);
					rect(targetAreas[i][0],targetAreas[i][1],100,30);
					fill(255);
					noStroke();
					text(nf(variable[i],1,stellen),targetAreas[i][0]+8,targetAreas[i][1]+5,100,30);
				}
				else rect(targetAreas[i][0],targetAreas[i][1],100,30);
								
			
			
			};

		popMatrix();
	
	}
}