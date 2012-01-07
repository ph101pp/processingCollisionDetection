class PointList {

	LorenzFormula 	lorenzFormula;
	LorenzVisual 	lorenzVisual;
	
	ListPoint[] listPoint;
	
	int startValue=1;
	
	PointList(LorenzFormula lorenzFormula_, LorenzVisual lorenzVisual_) {
		lorenzFormula=lorenzFormula_;
		lorenzVisual=lorenzVisual_;
		listPoint= new ListPoint[lorenzFormula.points.length];
	}
///////////////////////////////////////////////////////////
	void draw(){
		pushMatrix();
			translate(0,-10);
			moveList();
			for(int i=startValue; startValue+110 > i && i<lorenzFormula.points.length; i++) {
					
				listPoint[i]= new ListPoint(i,lorenzFormula.points[i], 120, (i-startValue)*13+35);
				
			}
		popMatrix();
	}
///////////////////////////////////////////////////////////
	void moveList() {
		if(mouseX <120 || mouseX > 420) return;
		
		if(mouseY <200 && startValue>1) startValue--;
		if(mouseY > height-200 && startValue < lorenzFormula.points.length-103) startValue++;
	
	
	}

}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
class ListPoint {
	int	count;
	float[] thisPoint;
	float	x,y,
			w=400,
			h=14,	
			dx=0,
			dy=-10;

	
	
	ListPoint(int count_, float[] thisPoint_, float x_, float y_){
		count=count_;
		thisPoint=thisPoint_;
		x=x_;
		y=y_;		
		
		drawPoint();
	}
///////////////////////////////////////////////////////////
	void drawPoint (){
		
		if(mouseX > x+dx && mouseX < x+w+dx && mouseY>y+dy && mouseY < y+h+dy ) {
			highlight();
			return;
		}
		
		textAlign(LEFT);
		fill(255);
		textFont(monaco9);
		
		int stelleX = thisPoint[0] >0 ? 2 : 1,
			stelleY = thisPoint[1] >0 ? 2 : 1,
			stelleZ = thisPoint[2] >0 ? 2 : 1;
		
		
		text(nf(count,5)+":   x="+nf(thisPoint[0],stelleX,5)+"   y="+nf(thisPoint[1],stelleY,5)+"   z="+nf(thisPoint[2],stelleZ,5), x, y, w, h);
		
	}	
	
///////////////////////////////////////////////////////////
	void highlight (){
		stroke(191,231,251);
		fill(0);
		rect(x-10,y-20,400, 30);
		
		noFill();
		float	actualX =thisPoint[0]*lorenzVisual.zoom,
				actualY =thisPoint[1]*lorenzVisual.zoom,
				actualZ =thisPoint[2]*lorenzVisual.zoom;
		
		pushMatrix();
			translate(lorenzVisual.position[0], lorenzVisual.position[1]);
			rotateX(radians(lorenzVisual.rotation[0]));
			rotateY(radians(lorenzVisual.rotation[1]));
			rotateZ(radians(lorenzVisual.rotation[2]));

			pushMatrix();
				translate(actualX,actualY,actualZ);
				fill(191,231,251,200);
				noStroke();
				box(7);
				stroke(191,231,251);
				strokeWeight(2);
				line(0,0,0, -actualX,-actualY,-actualZ);
			popMatrix();
		popMatrix();
		
		line(x-10+400,y-20+15, lorenzVisual.position[0], lorenzVisual.position[1]);
		strokeWeight(1);
		
		rectMode(CORNER);
		textAlign(LEFT);
		fill(255);
		textFont(frutigerRoman16);

		int stelleX = thisPoint[0] >0 ? 2 : 1,
			stelleY = thisPoint[1] >0 ? 2 : 1,
			stelleZ = thisPoint[2] >0 ? 2 : 1;

		text(nf(count,5)+":     x="+nf(thisPoint[0],stelleX,5)+"     y="+nf(thisPoint[1],stelleY,5)+"     z="+nf(thisPoint[2],stelleZ,5), x, y-12, 400, 30);
		
	}

}