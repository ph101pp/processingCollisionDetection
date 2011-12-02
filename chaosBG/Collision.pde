class Collision {
	chaosBG							that;
	Collision						nextCollision;
	Iterator						itr;
	ChaosElement					testElement;
	ArrayList<ChaosElement>			elements;
	ArrayList<ChaosElement>[][] 	quadrants;
	
	float 							gridSize; 
	float							distance;
	PVector							velocity1,velocity2, mouse;
	PVector 						wind;
	int 							maxZ;;
	float							mouseDist;
	
///////////////////////////////////////////////////////////
    Collision (chaosBG that_, ArrayList elements_, float gridSize_, boolean flag) {
    	that=that_;
    	elements=elements_;
    	gridSize=gridSize_;
    	quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[int(ceil(width/gridSize))+2][int(ceil(height/gridSize))+2]; 
    }
    Collision (chaosBG that_, ArrayList elements_, float gridSize_) {
    	that=that_;
    	elements=elements_;
    	gridSize=gridSize_;
    	maxZ=that.depth;
    	quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[int(ceil(width/gridSize))+2][int(ceil(height/gridSize))+2]; 
		float rand=0.3;
    	wind = new PVector(random(-rand,rand),random(-rand,rand), random(-rand,rand));
    	nextCollision = new Collision(that, new ArrayList(), gridSize, true);
    }
	    
///////////////////////////////////////////////////////////
	void add(ChaosElement element) {	 	
		PVector quadrant = getQuadrant(element);		
		int x= int(quadrant.x);
		int y= int(quadrant.y);
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	PVector getQuadrant(ChaosElement element) {
		int x = 1+int(floor(element.location.x/gridSize));
		int y = 1+int(floor(element.location.y/gridSize));
		
		if(x < 1) x=0;
		if(x > int(ceil(width/gridSize))) x=int(ceil(width/gridSize))+1;
		
		if(y < 1) y=0;
		if(y > int(ceil(height/gridSize))) y=int(ceil(height/gridSize))+1;
			
		return new PVector(x,y);	
	}
///////////////////////////////////////////////////////////
	void createCollisionMap() {
		int length=0;
		for(int i=0; i< nextCollision.quadrants.length; i++)
			for(int k=0; k< nextCollision.quadrants[i].length; k++)
				if(nextCollision.quadrants[i][k] != null)
					length+=nextCollision.quadrants[i][k].size();
		
		if(length == elements.size()) quadrants=nextCollision.quadrants.clone();
		else {
    		quadrants= (ArrayList<ChaosElement>[][]) new ArrayList[int(ceil(width/gridSize))+2][int(ceil(height/gridSize))+2]; 
			itr=elements.iterator();
			while(itr.hasNext()) 
				add((ChaosElement)itr.next());
		}	
	}
///////////////////////////////////////////////////////////
	void test(ChaosElement element) {
		PVector quadrant = getQuadrant(element);		
		int x= int(quadrant.x);
		int y= int(quadrant.y);
		
		if(quadrants[x][y] != null)
			quadrants[x][y].remove(element);
		
		for(int i=-1; i<=1; i++) 
			if(x+i >=0 && x+i < quadrants.length)
				for(int k=-1; k<=1; k++) 
					if(y+k >=0 && y+k < quadrants[x+i].length && quadrants[x+i][y+k] != null) {
						itr=quadrants[x+i][y+k].iterator();
						while(itr.hasNext())
							collide(element, (ChaosElement) itr.next());
					}
		nextCollision.add(element);
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
		float radius=0;
		if(int(blobPosition[0]) > 0 && int(blobPosition[1]) > 0) {
			that.dropX=map(blobPosition[0],0,640,0,width);
			that.dropY=map(blobPosition[1],0,480,0,height);
			radius=200;
		}
		if(frameCount% 10 == 0) {
			that.dropX=random(width);
			that.dropY=random(height);
			radius = 200;
		}
		else {
			radius = 200;
		}
		
		
		if(int(blobPosition[0]) > 0) {
			mouse=new PVector(that.dropX, that.dropY,0);
			mouseDist= PVector.dist(new PVector(element1.location.x,element1.location.y),new PVector(that.dropX, that.dropY));
			if(mouseDist < radius) {
				velocity2= PVector.sub(element1.location,mouse);
				velocity2.normalize();
				velocity2.mult(1.1);		
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