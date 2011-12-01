class CreateLines implements Comparator<ChaosElement> {
	chaosBG			that;
	int				maxLines = 5,
					connectionDistance = 20;
///////////////////////////////////////////////////////////
    CreateLines (chaosBG that_) {
    	that=that_;
    }
///////////////////////////////////////////////////////////
	int compare(ChaosElement o1, ChaosElement o2) {
		if(o1.lineCount >= maxLines || o2.lineCount >= maxLines) return 1;
		float distance =PVector.dist(o1.location,o2.location);
		if(distance < connectionDistance) {
			
//			stroke((distance*255/connectionDistance));
			line(o1.location.x,o1.location.y,o1.location.z,o2.location.x,o2.location.y,o2.location.z);
			o1.lineCount++;
			o2.lineCount++;
		}
        return 1;
    }
}
