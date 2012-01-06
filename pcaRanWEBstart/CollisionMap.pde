public class CollisionMap{
////////////////////////////////////////////////////////////////////////////////
	public float 								gridSize; 
	public int									columns, rows;
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionElement>[][] 	quadrants;
	private CollisionElement					testElement;
	private int									x,y,i,k,length;
	private PVector								q, q1, q2, radius;
	private Iterator							itr;
////////////////////////////////////////////////////////////////////////////////
	public CollisionMap(PApplet that_, float gridSize_) {
		that=that_;
		gridSize=gridSize_;
		columns=(int) Math.ceil(that.width/gridSize)+2;
		rows=(int) Math.ceil(that.height/gridSize)+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[columns][rows]; 
    	
    	for(i=(int) 0; i<columns; i++) 
			for(k= 0; k<rows; k++) 
				quadrants[i][k] = new ArrayList();

	}
////////////////////////////////////////////////////////////////////////////////
	public void add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element.location);
		x= (int) quadrant.x;
		y= (int) quadrant.y;
		
		quadrants[x][y].add(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public PVector getQuadrant(PVector location) {
		x = (int) Math.floor(location.x/gridSize)+1;
		y = (int) Math.floor(location.y/gridSize)+1;
		
		if(x < 1) x=0;
		if(x > (int) Math.ceil(that.width/gridSize)) x=(int) Math.ceil(that.width/gridSize)+1;
		if(y < 1) y=0;
		if(y > (int) Math.ceil(that.height/gridSize)) y=(int) Math.ceil(that.height/gridSize)+1;
			
		return new PVector(x,y);	
	}
////////////////////////////////////////////////////////////////////////////////
	public ArrayList getQuadrantElements(int x, int y) {
		if(quadrants[x][y] != null) return quadrants[x][y];
		else return new ArrayList();
	}
////////////////////////////////////////////////////////////////////////////////
	public int size() {
		length=0;
		for(i=0; i< quadrants.length; i++)
			for(k=0; k< quadrants[i].length; k++)
				if(quadrants[i][k] != null)
					length+=quadrants[i][k].size();
		return length;	
	}
////////////////////////////////////////////////////////////////////////////////
	public void test(CollisionElement element, boolean removeElement) {
		q = getQuadrant(element.location);		
		x= (int) q.x;
		y= (int) q.y;
		
		if(element.actionRadius <= gridSize) {
			q1 = PVector.sub(q, new PVector(2,2));
			q2 = PVector.add(q, new PVector(2,2));
		}
		else {
			radius = new PVector(element.actionRadius, element.actionRadius);
			q1 = getQuadrant(PVector.sub(element.location, radius));		
			q2 = getQuadrant(PVector.add(element.location, radius));		
			q1.sub(new PVector(1,1));
			q2.add(new PVector(1,1));
		}
		if(removeElement && quadrants[x][y] != null && quadrants[x][y].contains(element))
			quadrants[x][y].remove(element);
				
		for(i=(int) q1.x; i<=q2.x; i++) 
			if(i >=0 && i < quadrants.length)
				for(k=(int) q1.y; k<=q2.y; k++) 
					if(k >=0 && k < quadrants[i].length && quadrants[i][k] != null) {
						itr=quadrants[i][k].iterator();
						while(itr.hasNext()) {
							testElement= (CollisionElement) itr.next();
							if(element.equals(testElement)) continue;
							if(PVector.dist(element.location, testElement.location) > (testElement.actionRadius+element.actionRadius)) continue;
							element.collision(testElement, this, true);
							testElement.collision(element, this,false);
						}
					}
	}
////////////////////////////////////////////////////////////////////////////////
}
