class Collision {
	chaosBG			that;
	float 			gridSize; 
	Iterator		itr;
	ChaosElement	testElement;
	float			distance;
	PVector 		velocity1,velocity2, mouse;
	PVector 		wind;
	int 			maxZ=width/2;
	float			mouseDist;
	ArrayList<ChaosElement>[][] elements;
///////////////////////////////////////////////////////////
    Collision (chaosBG that_, float gridSize_) {
    	that=that_;
    	gridSize=gridSize_;
    	elements= (ArrayList<ChaosElement>[][]) new ArrayList[int(ceil(width/gridSize))][int(ceil(height/gridSize))]; 
		float rand=0.3;
    	wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
    }
///////////////////////////////////////////////////////////
	void add (ChaosElement element) {
	 	testFrame(element);
		int x = int(floor(element.location.x/gridSize));
		int y = int(floor(element.location.y/gridSize));
		
		if(elements[x][y] == null) elements[x][y] = new ArrayList();
		elements[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	void test(ChaosElement element) {
		testFrame(element);
		int x = int(floor(element.location.x/gridSize));
		int y = int(floor(element.location.y/gridSize));
		
		if(elements[x][y] != null)
			elements[x][y].remove(element);
		
		for(int i=-1; i<=1; i++) 
			if(x+i >=0 && x+i < elements.length)
				for(int k=-1; k<=1; k++) 
					if(y+k >=0 && y+k < elements[x+i].length && elements[x+i][y+k] != null) {
						itr=elements[x+i][y+k].iterator();
						while(itr.hasNext())
							collide(element, (ChaosElement) itr.next());
					}
		that.newCollision.add(element);
	}
///////////////////////////////////////////////////////////
	void testFrame (ChaosElement element) {
		if(element.location.x < 0) element.location.x*=-1;
		else if(element.location.x > width) element.location.x= width-(element.location.x-width);
		if(element.location.y < 0) element.location.y*=-1;
		else if(element.location.y > height) element.location.y= height-(element.location.y-height);
		if(element.location.z > maxZ) element.location.z= maxZ-(element.location.z-maxZ);
		else if(element.location.z < -maxZ) element.location.z= -maxZ-(element.location.z+maxZ);
	}

///////////////////////////////////////////////////////////
	void collide(ChaosElement element1, ChaosElement element2) {		
		distance=PVector.dist(element1.location, element2.location);
		that.count++;
		if(distance > gridSize) return;
		
		if(distance < gridSize*0.9) {
			float colorHue= maxZ-((element1.location.z-element2.location.z)/2);
			
			colorHue*=200/maxZ;
			colorHue-=155;
			stroke(colorHue);
			line(element1.location.x,element1.location.y,element1.location.z,element2.location.x,element2.location.y,element2.location.z);
			
			velocity1= PVector.sub(element1.location,element2.location);
		}
		else {
			velocity1= PVector.sub(element2.location,element1.location);
		}
		velocity1.normalize();
		velocity1.mult(2);		
		
		float force=(1-(PVector.dist(element1.location, new PVector(width/2,height/2,element1.location.z))/(height/2)))*0.2;
		
		if(mousePressed) {
			mouse=new PVector(mouseX, mouseY,0);
			mouseDist= PVector.dist(element1.location,mouse);
			if(mouseDist < 300) {
				velocity2= PVector.sub(element1.location,mouse);
				velocity2.normalize();
				velocity2.mult(1.3);		
				velocity1.add(velocity2);
			}
		}
		
		
		wind.mult(force);
		velocity1.add(wind);
	//	element1.velocity.add(velocity1);
	//	element1.velocity.mult(0.9);
		element1.location.add(velocity1);
		testFrame(element1);
	}
}