class CollisionDetection {
	chaosBG								that;
	CollisionDetection					nextDetection;
	
	ArrayList<CollisionMap>				maps = new ArrayList();
	ArrayList<CollisionElement>			elements = new ArrayList();
	
	CollisionMap						map;
	CollisionElement 					element;
///////////////////////////////////////////////////////////
	CollisionDetection(chaosBG that_,ArrayList<CollisionElement> elements_) {
		that=that_;
		elements=(ArrayList<CollisionElement>) elements_.clone();
		nextDetection= new CollisionDetection(that, true);
	}
	CollisionDetection(chaosBG that_) {
		that=that_;
		nextDetection= new CollisionDetection(that, true);
	}
	CollisionDetection(chaosBG that_, boolean flag) {
		that=that_;
		nextDetection=this;
	}
///////////////////////////////////////////////////////////
	void addElement (CollisionElement element) {
		this.elements.add(element);
		addToMap(element);
	}
///////////////////////////////////////////////////////////
	void addToMap(CollisionElement element) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			if(map.gridSize!=element.actionRadius) continue;
			map.add(element);
			return;			
		}
		map=new CollisionMap(that, nextDetection, element.actionRadius);
		map.add(element);	
		maps.add(map);
	}
///////////////////////////////////////////////////////////
	int mapSize() {
		int length=0;
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			length+=map.size();
		}
		return length;
	}
///////////////////////////////////////////////////////////
	void mapElements() {
		if(nextDetection.mapSize() == elements.size()) {
			maps=(ArrayList<CollisionMap>)nextDetection.maps.clone();		
		}
		else {
			maps=new ArrayList();
			Iterator itr= elements.iterator();
			while(itr.hasNext()) {
				element = (CollisionElement) itr.next();
				addToMap(element);
			}
		}
		nextDetection.maps= new ArrayList();
		nextDetection.elements = new ArrayList();
	}
///////////////////////////////////////////////////////////
	void testElement (CollisionElement element) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			map.test(element);
		}
		nextDetection.addElement(element);
	}
///////////////////////////////////////////////////////////
	void removeElement (CollisionElement element) {
		elements.remove(element);
		mapElements();
	}
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
class CollisionMap {
	chaosBG								that;
	CollisionDetection					nextDetection;

	ArrayList<CollisionElement>[][] 	quadrants;

	float 								gridSize; 
	CollisionElement					testElement;
///////////////////////////////////////////////////////////
	CollisionMap(chaosBG that_, CollisionDetection nextDetection_, float gridSize_) {
		that=that_;
		nextDetection=nextDetection_;
		gridSize=gridSize_;
		int quadrantsX=int(ceil(width/gridSize))+2;
		int quadrantsY=int(ceil(height/gridSize))+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[quadrantsX][quadrantsY]; 
	}
///////////////////////////////////////////////////////////
	void add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element);
		int x= int(quadrant.x);
		int y= int(quadrant.y);
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	private PVector getQuadrant(CollisionElement element) {
		int x = 1+int(floor(element.location.x/gridSize));
		int y = 1+int(floor(element.location.y/gridSize));
		
		if(x < 1) x=0;
		if(x > int(ceil(width/gridSize))) x=int(ceil(width/gridSize))+1;
		if(y < 1) y=0;
		if(y > int(ceil(height/gridSize))) y=int(ceil(height/gridSize))+1;
			
		return new PVector(x,y);	
	}
///////////////////////////////////////////////////////////
	int size() {
		int length=0;
		for(int i=0; i< quadrants.length; i++)
			for(int k=0; k< quadrants[i].length; k++)
				if(quadrants[i][k] != null)
					length+=quadrants[i][k].size();
		return length;	
	}
///////////////////////////////////////////////////////////
	void test(CollisionElement element) {
		PVector quadrant = getQuadrant(element);		
		int x= int(quadrant.x);
		int y= int(quadrant.y);
		
//		println("testCollison");
		
		if(x == 0 || x == int(ceil(width/gridSize))+2 || y ==0 || y==int(ceil(height/gridSize))+2) 
			element.frameCollision();
		
		if(quadrants[x][y] != null)
			quadrants[x][y].remove(element);
		
		for(int i=1; i>=-1; i--) 
			if(x+i >=0 && x+i < quadrants.length)
				for(int k=-1; k<=1; k++) 
					if(y+k >=0 && y+k < quadrants[x+i].length && quadrants[x+i][y+k] != null) {
						Iterator itr=quadrants[x+i][y+k].iterator();
						while(itr.hasNext()) {
							testElement= (CollisionElement) itr.next();
							element.collision(testElement, true);
							testElement.collision(element, false);
						}
					}
	}
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
abstract class CollisionElement {
	chaosBG								that;
	PVector 							location = new PVector(0,0,0);
	PVector								velocity = new PVector(0,0,0);
	float 								actionRadius;

///////////////////////////////////////////////////////////
	abstract void frameCollision();
	abstract void move();
	abstract void collide(NewChaosElement element, boolean mainCollision);
	abstract void collide(MouseElement element, boolean mainCollision);
	abstract void collide(CollisionElement element, boolean mainCollision);

///////////////////////////////////////////////////////////

	void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
	
	void collision(CollisionElement element, boolean mainCollision) {
		String type=element.getClass().getName();
		
		if(type == "chaosBG$NewChaosElement") collide((NewChaosElement) element, mainCollision);
		if(type == "chaosBG$MouseElement") collide((MouseElement) element, mainCollision);
		else collide((CollisionElement) element, mainCollision);
	}
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////