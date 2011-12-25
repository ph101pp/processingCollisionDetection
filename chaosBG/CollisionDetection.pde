class CollisionDetection {
	CollisionDetection					nextDetection;
	
	ArrayList<CollisionMap>				maps = new ArrayList();
	ArrayList<CollisionElement>			elements = new ArrayList();
	
	CollisionMap						map;
	CollisionElement 					element;
///////////////////////////////////////////////////////////
	CollisionDetection(ArrayList<CollisionElement> elements_) {
		elements=(ArrayList<CollisionElement>) elements_.clone();
		nextDetection= new CollisionDetection(true);
	}
	CollisionDetection() {
		nextDetection= new CollisionDetection(true);
	}
	CollisionDetection(boolean flag) {
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
		map=new CollisionMap(nextDetection, element.actionRadius);
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
	CollisionDetection					nextDetection;

	ArrayList<CollisionElement>[][] 	quadrants;
	int									columns;
	int									rows;

	float 								gridSize; 
	CollisionElement					testElement;
///////////////////////////////////////////////////////////
	int									x,y,x1,y1,x2,y2;
	int									length, i, k;
	PVector								quadrant,quadrant1,quadrant2,radius;

///////////////////////////////////////////////////////////
	CollisionMap(CollisionDetection nextDetection_, float gridSize_) {
		nextDetection=nextDetection_;
		gridSize=gridSize_;
		columns=int(ceil(width/gridSize))+2;
		rows=int(ceil(height/gridSize))+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[columns][rows]; 
	}
///////////////////////////////////////////////////////////
	void add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element.location);
		x= int(quadrant.x);
		y= int(quadrant.y);
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
///////////////////////////////////////////////////////////
	PVector getQuadrant(PVector location) {
		x = 1+int(floor(location.x/gridSize));
		y = 1+int(floor(location.y/gridSize));
		
		if(x < 1) x=0;
		if(x > int(ceil(width/gridSize))) x=int(ceil(width/gridSize))+1;
		if(y < 1) y=0;
		if(y > int(ceil(height/gridSize))) y=int(ceil(height/gridSize))+1;
			
		return new PVector(x,y);	
	}
///////////////////////////////////////////////////////////
	int size() {
		length=0;
		for(i=0; i< quadrants.length; i++)
			for(k=0; k< quadrants[i].length; k++)
				if(quadrants[i][k] != null)
					length+=quadrants[i][k].size();
		return length;	
	}
///////////////////////////////////////////////////////////
	void test(CollisionElement element) {
		quadrant = getQuadrant(element.location);		
		x= int(quadrant.x);
		y= int(quadrant.y);
		x1= x-1;
		y1= y-1;
		x2= x+1;
		y2= y+1;
		if(element.actionRadius > gridSize) {
			radius = new PVector(element.actionRadius, element.actionRadius);
			quadrant1 = getQuadrant(PVector.sub(element.location, radius));		
			quadrant2 = getQuadrant(PVector.add(element.location, radius));		
		
			x1= int(quadrant1.x)-1;
			y1= int(quadrant1.y)-1;
			x2= int(quadrant2.x)+1;
			y2= int(quadrant2.y)+1;
		}

		if(quadrants[x][y] != null && quadrants[x][y].contains(element))
			quadrants[x][y].remove(element);
				
		if(x <= 1 || x >= rows-2 || y <= 1 || y >= columns-2) 
			element.frameCollision();
		
		for(i=x1; i<=x2; i++) 
			if(i >=0 && i < quadrants.length)
				for(k=y1; k<=y2; k++) 
					if(k >=0 && k < quadrants[i].length && quadrants[i][k] != null) {
						Iterator itr=quadrants[i][k].iterator();
						while(itr.hasNext()) {
							testElement= (CollisionElement) itr.next();
							if(element.equals(testElement)) continue;
							element.collision(testElement, this, true);
							testElement.collision(element, this,false);
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
	PVector 							location = new PVector(0,0,0);
	PVector								velocity = new PVector(0,0,0);
	float 								actionRadius;

///////////////////////////////////////////////////////////
	void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
	}
///////////////////////////////////////////////////////////
	void frameCollision() {};
	abstract void collision(CollisionElement element, CollisionMap collisionMap, boolean mainCollision);
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////