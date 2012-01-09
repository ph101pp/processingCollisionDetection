package pcaCollisionDetection;
import processing.core.*;
import java.util.*;
import java.lang.*;

/**
*	Divides the screen in quadrants of a certain gridSize and places each given element in its quadrant.
*	Elements that are tested against the map only have to be tested against its surrounding quadrants to get all collisions.
*	For each actionRadius the collisionDetection instance creates an own map.
*/
public class CollisionMap{
////////////////////////////////////////////////////////////////////////////////
/**
*	Size of each Quadrant. Equals the actionRadius of the elements that are contained in this map.
*/
	public float 								gridSize; 
/**
*	Column count and row count.
*/
	public int									columns, rows;
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionElement>[][] 	quadrants;
	private CollisionElement					testElement;
	private int									x,y,i,k,length;
	private PVector								q, q1, q2, radius;
	private Iterator							itr;
////////////////////////////////////////////////////////////////////////////////
/**
*	CollisionMaps are initialized by the CollisionDetection object.
*/
	public CollisionMap(PApplet that_, float gridSize_) {
		that=that_;
		gridSize=gridSize_;
		columns=(int) Math.ceil(that.width/gridSize)+2;
		rows=(int) Math.ceil(that.height/gridSize)+2;
    	quadrants= (ArrayList<CollisionElement>[][]) new ArrayList[columns][rows]; 
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Elements are added by the CollisionDetection object. Use the CollisionDetection.add or CollisionDetection.addElement function instead.
*/
	public void _add(CollisionElement element) {	
		PVector quadrant = getQuadrant(element.location);
		x= (int) quadrant.x;
		y= (int) quadrant.y;
		
		if(quadrants[x][y] == null) quadrants[x][y] = new ArrayList();
		quadrants[x][y].add(element);
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Evaluates the Quadrant in which the passed location falls.
@param	location	location of the point that shall be placed.
@return	The coodrinates of the quadrant as PVector.
*/
	public PVector getQuadrant(PVector location) {
		return _getQuadrant(location);
	}
/**
*	Evaluates the Quadrant in which the passed location falls.
@param	x	x coordinate of the point that shall be placed.
@param	y	y coordinate of the point that shall be placed.
@return	The coodrinates of the quadrant as PVector.
*/
	public PVector getQuadrant(int x, int y) {
		return _getQuadrant(new PVector(x,y));
	}
	private PVector _getQuadrant(PVector location) {
		x = (int) Math.floor(location.x/gridSize)+1;
		y = (int) Math.floor(location.y/gridSize)+1;
		
		if(x < 1) x=0;
		if(x > (int) Math.ceil(that.width/gridSize)) x=(int) Math.ceil(that.width/gridSize)+1;
		if(y < 1) y=0;
		if(y > (int) Math.ceil(that.height/gridSize)) y=(int) Math.ceil(that.height/gridSize)+1;
			
		return new PVector(x,y);	
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Returns a list of all elements located in the passed quadrant.
@param	x	x coordinate of the quadrant which elements shall be returned.
@param	y	y coordinate of the quadrant which elements shall be returned.
@return	An ArrayList of the Elements contained in the quadrant
*/
	public ArrayList getQuadrantElements(int x, int y) {
		return _getQuadrantElements(x,y);
	}
/**
*	Returns a list of all elements located in the passed quadrant.
@param	coordinates	coordinates of the quadrant which elements shall be returned.
@return	An ArrayList of the Elements contained in the quadrant
*/
	public ArrayList getQuadrantElements(PVector coordinates) {
		return _getQuadrantElements((int) coordinates.x,(int) coordinates.y);
	}
	private ArrayList _getQuadrantElements(int x, int y) {
		if(quadrants[x][y] != null) return quadrants[x][y];
		else return new ArrayList();
	}
////////////////////////////////////////////////////////////////////////////////
/**
* 	Get the number of elements contained in this map.
@return		The number of elements contained in this map.
*/
	public int size() {
		length=0;
		for(i=0; i< quadrants.length; i++)
			for(k=0; k< quadrants[i].length; k++)
				if(quadrants[i][k] != null)
					length+=quadrants[i][k].size();
		return length;	
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Elements of a map are tested by the CollisionDetection object. Use the CollisionDetection.testElement function instead.
*/
	public void _test(CollisionElement element, boolean removeElement) {
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
