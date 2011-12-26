package pcaCollisionDetection;
import processing.core.*;
import java.util.*;
import java.lang.*;

public class CollisionDetection {
	PApplet								that;

	ArrayList<CollisionMap>				maps = new ArrayList();
	ArrayList<CollisionElement>			elements = new ArrayList();
	
	CollisionMap						map;
	CollisionElement 					element;
///////////////////////////////////////////////////////////
	public CollisionDetection(PApplet that_) {
		that=that_;
    	that.registerPre(this);
	}
	public CollisionDetection(PApplet that_, ArrayList<CollisionElement> elements_) {
		that=that_;
		elements=(ArrayList<CollisionElement>) elements_.clone(); 
	   	that.registerPre(this);
	}
///////////////////////////////////////////////////////////
	public void pre() {
		mapElements();
	}
///////////////////////////////////////////////////////////
	public void addElement (CollisionElement element) {
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
		map=new CollisionMap(that, element.actionRadius);
		map.add(element);	
		maps.add(map);
	}
///////////////////////////////////////////////////////////
	public int mapSize() {
		int length=0;
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			length+=map.size();
		}
		return length;
	}
	public int size() {
		return elements.size();
	}
///////////////////////////////////////////////////////////
	public void mapElements() {
		maps=new ArrayList();
		Iterator itr= elements.iterator();
		while(itr.hasNext()) {
			element = (CollisionElement) itr.next();
			addToMap(element);
		}
	}
///////////////////////////////////////////////////////////
	public void testElement (CollisionElement element) {
		Iterator itr= maps.iterator();
		while(itr.hasNext()) {
			map=(CollisionMap) itr.next();
			map.test(element);
		}
	}
///////////////////////////////////////////////////////////
	public void removeElement (CollisionElement element) {
		remove(element);
		mapElements();
	}
///////////////////////////////////////////////////////////
	public void remove(CollisionElement element) {
		elements.remove(element);
	}
}
