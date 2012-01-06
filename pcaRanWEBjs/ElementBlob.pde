class ElementBlob extends MyCollisionElement {
	float 							defaultRadius=155;

	int								startFrame;
	
	float							moved;
	
		
	boolean							shapeSet;
	
//	PROGRAMM
	PVector newLocation;
///////////////////////////////////////////////////////////
	ElementBlob(pcaRanWEBjs that_, PVector location_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = location_;
		startFrame=frameCount;
	}
	ElementBlob(pcaRanWEBjs that_, PVector location_) {
		that=that_;
		actionRadius=defaultRadius;
		location = location_;
		startFrame=frameCount;
	}
///////////////////////////////////////////////////////////
	
	void move(PVector newLocation) {
		
	}
///////////////////////////////////////////////////////////
	void resetElementLorenz(){
	}
///////////////////////////////////////////////////////////
	void finalize() {
	}
}