class ChaosElement {
	chaosBG that;
	
	PVector 						location;
	PVector							velocity;
	PVector							velocity1;
	PVector							mouse;
	int								lineCount=0;
	float							friction=0.88;
	float							radius=200;
	float							mouseDist;
	boolean 						drop =false;
///////////////////////////////////////////////////////////
	ChaosElement(chaosBG that_) {
		that=that_;
		location = new PVector (random(width), random(height),random(that.depth));
		velocity = new PVector (0,0,0);
	}
///////////////////////////////////////////////////////////
	void draw() {
		pushMatrix();
			translate(location.x, location.y, location.z);
			fill(0,0,0,100);
			box(1);
			noFill();
		popMatrix();	
	}
///////////////////////////////////////////////////////////
	void move() {		
		float force=1;//(1-(PVector.dist(element1.location, new PVector(width/2,height/2,element1.location.z))/(height/2)))*0.2;
		if(int(blobPosition[0]) > 0 && int(blobPosition[1]) > 0) {
			that.dropX=map(blobPosition[0],0,640,0,width);
			that.dropY=map(blobPosition[1],0,480,0,height);
			radius=200;
		}
		else if(mousePressed && that.mouseMoved) {
			that.dropX=mouseX;
			that.dropY=mouseY;
			radius=200;
		}
		else if(frameCount% 10 == 0 && true) {
			that.dropX=random(width);
			that.dropY=random(height);
			radius = random(height/5);
			drop=false;
		}
//		else radius=0;
		
		if(int(blobPosition[0]) > 0 || (mousePressed  && that.mouseMoved) || drop) {
			mouse=new PVector(that.dropX, that.dropY,0);
			mouseDist= PVector.dist(new PVector(location.x,location.y),new PVector(that.dropX, that.dropY));
			if(mouseDist < radius) {
				velocity1= PVector.sub(location,mouse);
				velocity1.normalize();
				velocity1.mult(2);		
				velocity.add(velocity1);
			}
		}
		

//	wind.mult(force);
	//	velocity.add(wind);
		
		velocity.mult(friction);
	//	velocity.add(wind);
		location.add(velocity);
	}
}