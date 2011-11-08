class LorenzVisual {
	LorenzFormula 	lorenzFormula;
	float			zoom=100,
					speed=0.05,
					xmag, ymag, newXmag, newYmag, diff, rotationX, rotationY, rotationZ;
	int 			rotationTimer;
	
	float[]			rotation= new float[3];
	
	LorenzVisual(LorenzFormula lorenzFormula_) {
		lorenzFormula=lorenzFormula_;
	}
///////////////////////////////////////////////////////////

	void rotation () {
	//	rotationY=obj.rotation[1]+0.5;
		newXmag = mouseX/float(width) * TWO_PI;
		newYmag = mouseY/float(height) * TWO_PI;
	
		if(mousePressed && mouseY > height/2) {
			rotationTimer = millis();
			
			diff = xmag-newXmag;
			if (abs(diff) >  0.01) rotationY -= degrees(diff/1.0);
		
			diff = ymag-newYmag;
			if (abs(diff) >  0.01) rotationX += degrees(diff/1.0);
			
			speed=0.01;
		}
		else {
			if(millis()-rotationTimer > 5000) {
				if(speed<0.4) speed*=1.05;
				else speed=0.4;
			} 
			else {
				if(speed>0.05) speed*=0.95;
				else speed=0.05;
			}
			
/*			if(rotationY <91 && rotationY>89) rotationY=90;
			else if(rotationY > 90) rotationY=rotation[1]-speed;
			else if(rotationY < 90) rotationY=rotation[1]+speed;
*/			
			rotationY=rotation[1]+speed;

			
			if(rotationZ > 0) rotationZ=rotation[2]-speed;
			if(rotationX> 0) rotationX=rotation[0]-speed;

		}
		
		xmag=newXmag;
		ymag=newYmag;
		rotation[0] = rotationX;
		rotation[1] = rotationY;
		rotation[2] = rotationZ;
	
	}
///////////////////////////////////////////////////////////
	void generateShape(){
		beginShape();
			for(int i=0; i<lorenzFormula.points.length; i++) {
				float 	x =lorenzFormula.points[i][0],
						y =lorenzFormula.points[i][1],
						z =lorenzFormula.points[i][2];
			
					curveVertex(x*zoom,y*zoom,z*zoom);
			}
		endShape();
	}
	
///////////////////////////////////////////////////////////
	
	void draw (){
		rotation();
		pushMatrix();
			translate(width/2-30, 100+height/2);
			stroke(255);
			noFill();
			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			generateShape();
		popMatrix();
	}
	
}