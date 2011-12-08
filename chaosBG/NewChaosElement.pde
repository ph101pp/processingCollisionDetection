
class NewChaosElement extends CollisionElement {

	float 							defaultRadius=50;

	PVector							velocity1;
	PVector							mouse;
	int								lineCount=0;
	float							radius=200;
	float							mouseDist;
	boolean 						drop =false;
///////////////////////////////////////////////////////////
	NewChaosElement(chaosBG that_, float actionRadius_) {
		that=that_;
		actionRadius=actionRadius_;
		location = new PVector (random(width), random(height),random(that.depth));
	}
	NewChaosElement(chaosBG that_) {
		that=that_;
		actionRadius=defaultRadius;
		location = new PVector (random(width), random(height),random(that.depth));
	}
///////////////////////////////////////////////////////////
	void frameCollision() {
		float border =  30;
		if(location.x < 0-border) {
			location.x*=-1;
	//			element.velocity.x*=-1;
	//			element.velocity.add(new PVector(0,force/2,0));
		}
		else if(location.x > width+border) {
			location.x= width+border-(location.x-width+border);
	//			element.velocity.x= width+border-(element.velocity.x-width+border);
	//			element.velocity.add(new PVector(-force/2,0,0));
		}
		if(location.y < 0-border) {
			location.y*=-1;
	//			element.velocity.y*=-1;
	//			element.velocity.add(new PVector(0,force/2,0));
		}
		else if(location.y > height+border) {
			location.y= height+border-(location.y-height+border);
	//			element.velocity.y= height+border-(element.velocity.y-height+border);
	//			element.velocity.add(new PVector(0,-force/2,0));
		}
		if(location.z < 0-border) {
			location.z*=-1;
	//			element.velocity.z*=-1;
	//			element.velocity.add(new PVector(0,0,force/2));
		}
		else if(location.z > depth) {
			location.z= depth-(location.z-depth);
	//			element.velocity.z= maxZ-(element.velocity.z-maxZ);
	//			element.velocity.add(new PVector(0,0,-force/2));
		}
	}	
///////////////////////////////////////////////////////////
	void move() {		
		float force=1;//(1-(PVector.dist(element1.location, new PVector(width/2,height/2,element1.location.z))/(height/2)))*0.2;
		if(int(blobPosition[0]) > 0 && int(blobPosition[1]) > 0) {
			that.dropX=map(blobPosition[0],0,640,0,width);
			that.dropY=map(blobPosition[1],0,480,0,height);
			radius=200;
		}
		else if(mousePressed && that.mouseMoved>0) {
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
		mouse=new PVector(that.dropX, that.dropY,0);
		mouseDist= PVector.dist(new PVector(location.x,location.y),new PVector(that.dropX, that.dropY));


		if((int(blobPosition[0]) > 0 || (mousePressed  && that.mouseMoved>0)|| drop) && that.friction>=0.7) {
			if(mouseDist < 10*pressedFrames && mouseDist<radius) {
				velocity1= PVector.sub(location,mouse);
				velocity1.normalize();
				velocity1.mult(0.5*pressedFrames);
				velocity1.limit(5);
				velocity.add(velocity1);
			}
			if(mousePressed && that.mouseMoved >0 && mouseDist < 10*pressedFrames && mouseDist<radius) that.friction=0.7;
			else if(mousePressed && that.mouseMoved >0) that.friction=0.9;
		}

		
		if(that.pressedFrames > 100 && random(0,1) >0.9) that.pressedStart=frameCount;


		velocity.mult(that.friction);
//		velocity.add(that.wind);

		if(mousePressed && that.mouseMoved >0 && random(0,1) > map(that.pressedFrames, 0, that.pressedFrames+10,0.1,1)) {
			velocity.mult(-0.5);
			location.add(velocity);
			velocity.mult(-2);
		}
		else location.add(velocity);
//	wind.mult(force);
	//	velocity.add(wind);
	}
	
	
	
}