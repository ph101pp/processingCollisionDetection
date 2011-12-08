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
		elements=elements_;
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
		elements.add(element);
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
	}
///////////////////////////////////////////////////////////
	void removeElement (CollisionElement element) {}
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
						while(itr.hasNext())
							new Interaction(element, (CollisionElement) itr.next());
					}
		nextDetection.addElement(element);
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

///////////////////////////////////////////////////////////
	void setActionRadius(float actionRadius_) {
		actionRadius=actionRadius_;
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
public class Interaction {

	float							force=5;
///////////////////////////////////////////////////////////
	Interaction(CollisionElement element1, CollisionElement element2) {
		PVector velocity1, velocity2;
		float distance=PVector.dist(element1.location, element2.location);
		if(distance > element1.actionRadius) return;
	
		if(distance < element1.actionRadius*0.9) {
			float lineZ= abs((element1.location.z-element2.location.z)/2);
			
			stroke(map(lineZ,0,30,0,100 ));
			line(element1.location.x,element1.location.y,element1.location.z,element2.location.x,element2.location.y,element2.location.z);
			
			velocity1= PVector.sub(element1.location,element2.location);
			velocity2= PVector.sub(element2.location,element1.location);
		}
		else {
			velocity1= PVector.sub(element2.location,element1.location);
			velocity2= PVector.sub(element1.location,element2.location);
		}
		velocity1.normalize();
		velocity1.mult(map(distance, 0,element1.actionRadius,force,0));		
		velocity2.normalize();
		velocity2.mult(map(distance, 0,element1.actionRadius,force,0));		
		
	
	//	element1.location.add(velocity1);
		element1.velocity.add(velocity1);
		element2.velocity.add(velocity2);

//		println(element1.velocity);

	}
	
}
