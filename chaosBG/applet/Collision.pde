class Collision {
	chaosBG			that;
	float 			gridSize; 
	Iterator		itr;
	ChaosElement	testElement;
	float			distance;

	ArrayList<ChaosElement>[][] elements;
///////////////////////////////////////////////////////////
    Collision (chaosBG that_, float gridSize_) {
    	that=that_;
    	gridSize=gridSize_;
    	elements= (ArrayList<ChaosElement>[][]) new ArrayList[int(ceil(width/gridSize))][int(ceil(height/gridSize))]; 
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
	}

///////////////////////////////////////////////////////////
	void collide(ChaosElement element1, ChaosElement element2) {		
		distance=PVector.dist(element1.location, element2.location);
		that.count++;
		if(distance > gridSize) return;
		
		line(element1.location.x,element1.location.y,element1.location.z,element2.location.x,element2.location.y,element2.location.z);
	
		float force=1.2* abs(gridSize-distance-gridSize)/gridSize;
		
		PVector velocity1= PVector.sub(element1.location,element2.location);
		
		velocity1.normalize();
		//velocity1.mult(force);		
	//	element1.velocity.add(velocity1);
	//	element1.velocity.mult(0.9);
		
		element1.location.add(element1.velocity);
	}
}
