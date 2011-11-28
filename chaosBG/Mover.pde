class Mover implements Comparator<ChaosElement> {
	chaosBG			that;
	int				maxLines = 5,
					connectionDistance = 20;
	float			friction = 0.98;
///////////////////////////////////////////////////////////
    Mover (chaosBG that_) {
    	that=that_;
    }
///////////////////////////////////////////////////////////
	int compare(ChaosElement o1, ChaosElement o2) {
		float distance =PVector.dist(o2.location,o1.location);
		
		that.count++;
		o1.lineCount=0;
		o2.lineCount=0;
		if(distance < connectionDistance) {
			
			float force=connectionDistance-(distance-connectionDistance)*1.5;
			
			PVector velocity1= PVector.sub(o2.location,o1.location);
			PVector velocity2= PVector.sub(o2.location,o1.location);
			
			velocity1.normalize();
			velocity2.normalize();
			
			velocity1.mult(force);
			velocity2.mult(force);
			
			o1.location.add(velocity1);
			o2.location.add(velocity2);


		}
        return 1;
    }
}