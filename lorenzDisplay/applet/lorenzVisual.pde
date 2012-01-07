class LorenzVisual {
	LorenzFormula 	lorenzFormula;
	float			zoom=85,
					speed=0.05,
					xmag, ymag, newXmag, newYmag, diff, rotationX, rotationY, rotationZ;
	int 			rotationTimer;
	
	float[]			rotation= {0,90,0},
					matrix = new float[3],
					position = {1020,510};
					
	
	LorenzVisual(LorenzFormula lorenzFormula_) {
		lorenzFormula=lorenzFormula_;
	}
///////////////////////////////////////////////////////////

	void rotation () {
	//	rotationY=obj.rotation[1]+0.5;
		newXmag = mouseX/float(width) * TWO_PI;
		newYmag = mouseY/float(height) * TWO_PI;
	
		if(mousePressed && mouseY > 200 && mouseX > 400) {
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
	
///////////////////////////////////////////////////////////
	
	void draw (){
		rotation();
		pushMatrix();
			translate(position[0], position[1]);

			stroke(39,46,49);
			
/*			line(0,0,0,100,0,0);
			line(0,0,0,0,-100,0);
			line(0,0,0,0,0,100);
*/
//			rect(0,0,0,1,1,1);

			stroke(255,255,255,200);
			noFill();
			rotateX(radians(rotation[0]));
			rotateY(radians(rotation[1]));
			rotateZ(radians(rotation[2]));

			matrix[0] = modelX(0,0,0);
			matrix[1] = modelY(0,0,0);
			matrix[2] = modelZ(0,0,0);
	

			generateShape();
		popMatrix();
	}
	
}
