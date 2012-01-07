class EventListener {
	
	LorenzFormula 	lorenzFormula;
	LorenzVisual 	lorenzVisual;
	PointList		pointList;
	
	boolean clicked = false;
	
	EventListener(LorenzFormula lorenzFormula_, LorenzVisual lorenzVisual_, PointList pointList_) {
		lorenzFormula=lorenzFormula_;
		lorenzVisual=lorenzVisual_;
		pointList=pointList_;
	}
///////////////////////////////////////////////////////////
	
	void click() {
		if(!mousePressed) {
			clicked = false;
			return;
		} 
		else {
			if(clicked) return;
			clicked = true;
		}
			
//		Pause
		if(mouseX > 1535 && mouseX < 1563 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1535,989,28,28);
			lorenzFormula.paused=lorenzFormula.paused ? false:true;
		}
		
//		Reset
		if(mouseX > 1574 && mouseX < 1602 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1574,989,28,28);
			for(int i=0; i<lorenzFormula.variable.length; i++) lorenzFormula.variable[i]=lorenzFormula.defaults[i][2];
		}
		
//		ScreenShot
		if(mouseX > 1613 && mouseX < 1641 && mouseY > 989 && mouseY < 1017) {
			fill(255);
			rect(1613,989,28,28);
			
			String name=nf(year(),2)+""+nf(month(),2)+""+nf(day(),2)+""+nf(hour(),2)+""+nf(minute(),2)+""+nf(second(),2)+".png";
			save("screenShots/"+name);
		}
		
		
	}
///////////////////////////////////////////////////////////
	void hover() {
	
//		Pause
		if(mouseX > 1535 && mouseX < 1563 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1535,989,28,28);
			strokeWeight(1);
		}
		
//		Reset
		if(mouseX > 1574 && mouseX < 1602 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1574,989,28,28);
			strokeWeight(1);
		}
		
//		ScreenShot
		if(mouseX > 1613 && mouseX < 1641 && mouseY > 989 && mouseY < 1017) {
			noFill();
			strokeWeight(2);
			stroke(255);
			rect(1613,989,28,28);
			strokeWeight(1);
		}

	
	
	
	
	}




}
