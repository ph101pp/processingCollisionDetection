class ElementLorenz extends MyCollisionElement {
	ElementBlob						blob;

	float 							defaultRadius=155;
	int								variableSets=17;

	float							pushForce=5;

	int								startFrame;

	float							x,y,z;
	float[] 						variable= {-1.11, 1.12, 4.49, 0.13, 1.4, 0.4, 0.13, 1.47, 0.13};
	float[][] 						points;
	PVector							average= new PVector(0,0,0);
	float							zoom=25;
	float							rotation=0;
	int								iterations=1000;
	
	ArrayList<CollisionElement> 	elements = new ArrayList();
	
	PVector							quadrant = new PVector(0,0);

	boolean							allSet=false;
	int								count=0;	
	boolean							moved=true;
	
	float							moveUp=0.8;
	
///////////////////////////////////////////////////////////
	ElementLorenz(pcaRanWEB that_, PVector location_, ElementBlob blob_, float actionRadius_) {
		that=that_;
		blob=blob_;
		actionRadius=actionRadius_;
		location = location_;
		startFrame=frameCount;
		
		getVariableSet();
		generatePoints();
	}
	ElementLorenz(pcaRanWEB that_, PVector location_, ElementBlob blob_) {
		that=that_;
		blob=blob_;
		actionRadius=defaultRadius;
		location = location_;
		startFrame=frameCount;

		getVariableSet();
		generatePoints();
	}
///////////////////////////////////////////////////////////
	void collide(ElementChaos element, CollisionMap collisionMap,  boolean mainCollision) {
		if(!allSet) {	
			PVector thisQuadrant= collisionMap.getQuadrant(element.location);
			
			if(elements.size() < iterations && !thisQuadrant.equals(quadrant)) elements.add(element);
				
			quadrant=thisQuadrant;
			return;
		}
		
		
 	}
///////////////////////////////////////////////////////////
	void move() {
		count = (frameCount-startFrame)*100;
		if(count> iterations) count = iterations;
		
		if(count!=iterations) moved=true;
		
		if(!allSet) return;
		
		velocity.limit(3);
		
/*		velocity.limit(1);
		velocity.limit(3);
*/		
		moveUp+=0.02;
		velocity.y-=moveUp;
		
/*		float distance=PVector.dist(new PVector(location.x,location.y), that.mouseElement.location);
		if(distance<=actionRadius && false) {
			PVector newVelocity= PVector.sub(location,element.location);
			newVelocity.normalize();
			
			pushForce=5;
			newVelocity.mult(map(distance, 0,actionRadius,pushForce,0));		
			velocity.add(newVelocity);
		}
	
*/	
		velocity.mult(that.globalFriction);	
		if(velocity.mag() >0) that.lorenzMovement=true;
		
		location.add(new PVector(velocity.x,velocity.y));
	
		if(location.y < -actionRadius) {
			remove();
			return;	
		}
		draw();
	}
	
	void remove(){
		that.lorenzElements.remove(this);
		that.collisionDetection.remove(this);
	}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
	void getVariableSet () {
		String filenumber = nf(int(random(0, variableSets)),5,0);
		String filename = sketchPath("variableSets"+java.io.File.separator+filenumber+"_lorenzVariableSet.txt");
		String[] data=loadStrings(filename);
		
		if(data==null) return;

		int id=0;
		int k=0;
		for(int i=0; 18 >i; i++) {
			if(i%2==0) {
				id++;
				continue;
			}
			variable[k]=float(data[id]);
			k++;
			id++;
		}
		
		id++; //obj.iteration=data.readFloat();
		id+=2; //obj.zoom=data.readFloat();
		id+=2; //obj.rotation[0]=data.readFloat();
		id+=2; //obj.rotation[1]=data.readFloat();
		id+=2; //obj.rotation[2]=data.readFloat();
	}
///////////////////////////////////////////////////////////
	void generatePoints(){
		points = new float[iterations][3];
		x=1;
		y=1;
		z=1;
		float count=0;
		for(int i=0; i<20; i++) iterate();
		for(int i=0; i<iterations; i++) {
			points[i][0]=x;
			points[i][1]=y;
			points[i][2]=z;		
			
			average.add(new PVector(x,y,z));
			iterate();	
			count++;
		}
		average.mult(1/count);
		average.mult(zoom);
	}
///////////////////////////////////////////////////////////
	void iterate(){
		float	dx = (variable[0] * x - y * y - z * z + variable[1] * variable[2]) * variable[3],
				dy = (-y + x * y - variable[4] * x * z + variable[5]) * variable[6],
				dz = (-z + variable[7] * x * y + x * z) * variable[8];
		x+=dx;
		y+=dy;
		z+=dz;
	}
///////////////////////////////////////////////////////////
	void draw() {
		pushMatrix();
			stroke(0);
			
			translate(location.x, location.y,location.z);
			rotation+=0.05;
			rotateY(rotation);
//			box(10);
			pushMatrix();			
				translate(-average.x, -average.y,-average.z);
//				box(10);
				beginShape();
					for(int i=0; i< points.length; i++) {
						x =points[i][0];
						y =points[i][1];
						z =points[i][2];
		
						curveVertex(x*zoom,y*zoom,z*zoom);
					}
				endShape();
			popMatrix();
		popMatrix();
	}
}
