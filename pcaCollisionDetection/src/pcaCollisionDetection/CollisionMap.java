package pcaCollisionDetection;
import processing.core.*;
import java.util.*;
import java.lang.*;

public class CollisionMap{
////////////////////////////////////////////////////////////////////////////////
	public float 								gridSize; 
	public int									columns, rows;
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionElement>[][] 	quadrants;
	private CollisionElement					testElement;
	private int									x,y,x1,y1,x2,y2,i,k,length;
	private PVector								quadrant,quadrant1,quadrant2,radius;
	private Iterator							itr;
////////////////////////////////////////////////////////////////////////////////
	public CollisionMap(PApplet that_, float gridSize_) {
		that=that_;
		gridSize=gridSize_;
		columns=(int) Math.ceil(that.width/gridSize)+2;
		rows=(int) Math.ceil(that.height/gridSize)+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[columns][rows]; 
	}
////////////////////////////////////////////////////////////////////////////////
	public void add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element.location);
		x= (int) quadrant.x;
		y= (int) quadrant.y;
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
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
		quadrant = getQuadrant(element.location);		
		x= (int) quadrant.x;
		y= (int) quadrant.y;
		if(element.actionRadius <= gridSize) {
			x1= x-2;
			y1= y-2;
			x2= x+2;
			y2= y+2;
		}
		else {
			radius = new PVector(element.actionRadius, element.actionRadius);
			quadrant1 = getQuadrant(PVector.sub(element.location, radius));		
			quadrant2 = getQuadrant(PVector.add(element.location, radius));		
		
			x1= (int) quadrant1.x-1;
			y1= (int) quadrant1.y-1;
			x2= (int) quadrant2.x+1;
			y2= (int) quadrant2.y+1;
		}
		if(removeElement && quadrants[x][y] != null && quadrants[x][y].contains(element))
			quadrants[x][y].remove(element);
				
		
		for(i=x1; i<=x2; i++) 
			if(i >=0 && i < quadrants.length)
				for(k=y1; k<=y2; k++) 
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
