class LorenzFormula {
	boolean paused=false;

	int animate=5,
		direction=1,
		iteration=1000;
	
	float 	animationStep=0.000001,
			x,y,z;
	
/*	
defaults = {
	{min, max, start}
};		
*/
	float[][] defaults ={
			{-1, 3, 1},
			{ -0.8,  3.8, 1.8},
			{-2.71,2.71, 0.71},
			{-1.51,3.51, 1.51},
		};
		
	float[][] targetAreas = {
		{75,-5},
		{390,-5},
		{515,-5},
		{655,-5},
	};
	
	float[] formulaPosition = {465, 85};
	
	float[] variable= {1, 1.8, 0.71, 1.51};
	
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
			if(mouseY > targetAreas[i][1]+formulaPosition[1] && mouseY < targetAreas[i][1]+30+formulaPosition[1] && mouseX > targetAreas[i][0]+formulaPosition[0] && mouseX < targetAreas[i][0]+100+formulaPosition[0]) {
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
		float	dx = sin(variable[0]*y)-z*cos(variable[1]*x),
				dy = z*sin(variable[2]*x)-cos(variable[3]*x),
				dz = sin(x);
		x+=dx;
		y+=dy;
		z+=dz;
	}
//////////////////////////////////////////////////////////
	void printFormula(LorenzVisual lorenzVisual){
		int stellen=7;
		String 	x="dx = sin(y*"+nf(variable[0],1,stellen)+") - z* cos(x*"+nf(variable[1],1,stellen)+");",
				y="dx = z*sin(x*"+nf(variable[2],1,stellen)+") - cos(y*"+nf(variable[3],1,stellen)+");",
				z="dz = sin(x);";
		
		pushMatrix();
			translate(formulaPosition[0],formulaPosition[1]);
			textAlign(LEFT);
			fill(38,46,49);
			textFont(frutigerRoman24);
			text(x, 0, 0, width-40, 200); 
			text(y, 0, 32, width-40, 200); 
			text(z, 0, 64, width-40, 200); 
			
/*			text("Rotation X: "+nf(lorenzVisual.rotation[0],3,2)+" Degrees", 0, 106, width-40, 200 );
			text("Rotation Y: "+nf(lorenzVisual.rotation[1],3,2)+" Degrees", 0, 138, width-40, 200 );
			text("Points: "+iteration, 0, 170, width-40, 200 );
*/			
			
			for(int i=0; i<targetAreas.length; i++) {
				noFill();
				stroke(38,46,49);
				
				if(mouseY > targetAreas[i][1]+formulaPosition[1] && mouseY < targetAreas[i][1]+30+formulaPosition[1] && mouseX > targetAreas[i][0]+formulaPosition[0] && mouseX < targetAreas[i][0]+100+formulaPosition[0]) 
					stroke(191,231,251);
					
				if(i == animate) {
					noStroke();
					fill(0);
					rect(targetAreas[i][0],targetAreas[i][1],100,30);
					stroke(191,231,251);
					line(targetAreas[i][0],targetAreas[i][1]+30, targetAreas[i][0]+100 ,targetAreas[i][1]+30);
					fill(255);
					noStroke();
					text(nf(variable[i],1,stellen),targetAreas[i][0]+8,targetAreas[i][1]+5,100,30);
				}
				else  line(targetAreas[i][0],targetAreas[i][1]+30, targetAreas[i][0]+100 ,targetAreas[i][1]+30);

								
			
			
			};

		popMatrix();
	
	}
}