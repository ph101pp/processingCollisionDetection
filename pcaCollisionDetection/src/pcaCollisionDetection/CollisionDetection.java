package pcaCollisionDetection;
import processing.core.*;
import java.util.*;
import java.lang.*;

/**
*	Processing Library.
*	Object that allows collisionDetection of many elements. 
*	Elements that are added to the set, are mapped to grids according to their actionRadius. Like this it is possible to test a CollisionElement 
*	only against elements that lay in the surrounding quadrants of its own quadrant in each map and not against all elements on the screen. 
*	This reduces the amaunt of tests needed to get all collisions on the screen drastically. 
*/
public class CollisionDetection {
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionMap>				maps = new ArrayList();
	private ArrayList<CollisionElement>			elements = new ArrayList();
	private CollisionMap						map;
	private CollisionElement 					element;
////////////////////////////////////////////////////////////////////////////////
/**
*	Creates and Initialises a new Instance of the CollisionDetection Object. 
*	After initialisation CollisionElements can be passed to the Instance.
*	CollisionElements in this list are mapped according to their actionRadius.
*	After mapping the elements, any CollisionElement can then be tested for a collision against this list of Elements.
*	
@param 	this		Reference to the actual processing Sketch PApplet.
*/
	public CollisionDetection(PApplet that_) {
		that=that_;
    	that.registerPre(this);
	}
/**
*	Creates and Initialises a new Instance of the CollisionDetection Object. 
*	After initialisation CollisionElements can be passed to the Instance.
*	CollisionElements in this list are mapped according to their actionRadius.
*	After mapping the elements, any CollisionElement can then be tested for a collision against this list of Elements.
*	All passed elements will be added to the list.
*	
@param 	this		Reference to the actual processing Sketch PApplet.
@param 	elements	ArrayList of CollisionElements to be added to the CollisionDetecton set.
*/
	public CollisionDetection(PApplet that_, ArrayList<CollisionElement> elements_) {
		that=that_;
		elements=(ArrayList<CollisionElement>) elements_.clone(); 
	   	that.registerPre(this);
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Is called by processing before each call of the draw() function
*/
	public void pre() {
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Adds a CollisionElement to the Set of Elements that will be tested.
*	
@param 	element		CollisionElement that should be added.
*/
	public void add(CollisionElement element) {
		elements.add(element);
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Removes a CollisionElement from the Set of Elements that is tested.
*	
@param 	element		CollisionElement that should be removed.
*/
	public void remove(CollisionElement element) {
		elements.remove(element);
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Adds a CollisionElement to the Set of Elements that will be tested
*	and directly maps it. This is only needed if you want to test against 
*	this element during the same frame in which you added it to the list.
*	
@param 	element		CollisionElement that should be added.
*/
	public void addElement (CollisionElement element) {
		add(element);
		addToMap(element);
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Removes a CollisionElement from the Set of Elements that is tested
*	and directly removes it from the map. This is only needed if you want to test against 
*	the set of elements (without the removed one) during the same frame in which you 
*	removed it from the list.
*	
@param 	element		CollisionElement that should be removed.
*/
	public void removeElement (CollisionElement element) {
		remove(element);
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
/**
@return		Returns an ArrayList of all elements that are contained in the list 
*			and are mapped each frame.
*	
*/
	public ArrayList getElements () {
		return elements;
	}
////////////////////////////////////////////////////////////////////////////////
/**
@return		Returns the number of elements that are contained in the list 
*			and are mapped each frame.
*	
*/
	public int size() {
		return elements.size();
	}
////////////////////////////////////////////////////////////////////////////////
/**
@return		Returns the number of elements that currently mapped
*	
*/
	public int mapSize() {
		int length=0;
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			length+=map.size();
		}
		return length;
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Maps every element according to its actionRadius to a CollisionMap. 
*	This function is called inside the pre() function so before each call of the draw() function.
*	You only need to call this if you want to test an element of the list a 
*	second time or if you moved an element and want to test against its new position.
*	
*/
	public void remapElements() {
		maps=new ArrayList();
		Iterator itr= elements.iterator();
		while(itr.hasNext()) {
			element = (CollisionElement) itr.next();
			addToMap(element);
		}
	}
////////////////////////////////////////////////////////////////////////////////
/**
*	Tests a given CollisionElement against the set of all Mapped elements in 
*	this CollisionDetection instance.
*
@param	element			CollisionElement that will be tested against the set.
@param	removeElement 	Boolean default true. If this is set to false the 
						tested Element will not be removed from the maps 
						(if it is contained in one). This will make bulg CollisionTests 
						remarkably slower.
*/
	public void testElement (CollisionElement element, boolean removeElement) {
		_testElement(element, removeElement);
	}
////////////////////////////////////////////////////////////////////////////////
	public void testElement (CollisionElement element) {
		_testElement(element, true);	
	}
////////////////////////////////////////////////////////////////////////////////
	private void _testElement (CollisionElement element, boolean removeElement) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			map._test(element, removeElement);
		}
	}
////////////////////////////////////////////////////////////////////////////////
	private void addToMap(CollisionElement element) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			if(map.gridSize!=element.actionRadius) continue;
			map._add(element);
			return;			
		}
		map=new CollisionMap(that, element.actionRadius);
		map._add(element);	
		maps.add(map);
	}
////////////////////////////////////////////////////////////////////////////////
}
