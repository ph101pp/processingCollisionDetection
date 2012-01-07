class ElementBlob extends MyCollisionElement {
	float 							defaultRadius=155;

	int								startFrame;
	
	float							moved;
	
	ElementLorenz					lorenzElement;
		
	boolean							shapeSet;
	
//	PROGRAMM
	PVector newLocation;
///////////////////////////////////////////////////////////
	ElementBlob(pcaRanWEB that_, PVector location_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = location_;
		startFrame=frameCount;

		lorenzElement= new ElementLorenz(that, location, this);
	}
	ElementBlob(pcaRanWEB that_, PVector location_) {
		that=that_;
		actionRadius=defaultRadius;
		location = location_;
		startFrame=frameCount;

		lorenzElement= new ElementLorenz(that, location,this);
	}
///////////////////////////////////////////////////////////
	
	void move(PVector newLocation) {
		moved=PVector.dist(newLocation, location);
		
		if(moved>0) that.movement=true;
		
		if(frameCount-startFrame > 100 && random(0,1) >0.9) startFrame=frameCount;

		location = newLocation;
		
		if(lorenzElement.allSet == true) resetElementLorenz();
	
		if(shapeSet && !lorenzElement.allSet && (moved<=0 || PVector.dist(location, lorenzElement.location) > 30)) {
			startFrame=frameCount;
			shapeSet=false;
			lorenzElement.remove();
		}
		if(frameCount-startFrame> 50 && !shapeSet && moved>0 ) {
			that.lorenzElements.add(lorenzElement);
			that.collisionDetection.addElement(lorenzElement);
			lorenzElement.location=new PVector(location.x,location.y, location.z);
			lorenzElement.startFrame=frameCount;
			lorenzElement.elements = new ArrayList();
			shapeSet=true;
		}
		
	}
///////////////////////////////////////////////////////////
	void resetElementLorenz(){
		startFrame=frameCount;
		shapeSet=false;
		lorenzElement=new ElementLorenz(that, location, this);
	}
///////////////////////////////////////////////////////////
	void finalize() {
		if(lorenzElement.allSet) return;	
		lorenzElement.remove();
	}
}
