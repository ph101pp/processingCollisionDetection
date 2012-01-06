public class CollisionDetection {
////////////////////////////////////////////////////////////////////////////////
	private PApplet								that;
	private ArrayList<CollisionMap>				maps = new ArrayList();
	private ArrayList<CollisionElement>			elements = new ArrayList();
	private CollisionMap						map;
	private CollisionElement 					element;
////////////////////////////////////////////////////////////////////////////////
	public CollisionDetection(PApplet that_) {
		that=that_;
	}
	public CollisionDetection(PApplet that_, ArrayList<CollisionElement> elements_) {
		that=that_;
		elements=(ArrayList<CollisionElement>) elements_.clone(); 
	}
////////////////////////////////////////////////////////////////////////////////
	public void pre() {
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
	public void add(CollisionElement element) {
		elements.add(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void remove(CollisionElement element) {
		elements.remove(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void addElement (CollisionElement element) {
		add(element);
		addToMap(element);
	}
////////////////////////////////////////////////////////////////////////////////
	public void removeElement (CollisionElement element) {
		remove(element);
		remapElements();
	}
////////////////////////////////////////////////////////////////////////////////
	public ArrayList getElements () {
		return elements;
	}
////////////////////////////////////////////////////////////////////////////////
	public int size() {
		return elements.size();
	}
////////////////////////////////////////////////////////////////////////////////
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
	public void remapElements() {
		maps=new ArrayList();
		Iterator itr= elements.iterator();
		while(itr.hasNext()) {
			element = (CollisionElement) itr.next();
			addToMap(element);
		}
	}
////////////////////////////////////////////////////////////////////////////////
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
			map.test(element, removeElement);
		}
	}
////////////////////////////////////////////////////////////////////////////////
	private void addToMap(CollisionElement element) {
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
////////////////////////////////////////////////////////////////////////////////
}
