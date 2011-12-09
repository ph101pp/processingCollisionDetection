
class NewChaosElement extends CollisionElement {

	float 							defaultRadius=50;

	int								lineCount=0;
	float							radius=200;
	boolean 						drop =false;
	float							pressed;
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
		if(int(that.blobs[0]) > 0 && int(that.blobs[1]) > 0) {
			that.dropX=map(that.blobs[0],0,640,0,width);
			that.dropY=map(that.blobs[1],0,480,0,height);
			radius=200;
			pressed=blobFrames;
			    pushMatrix();
    	translate(that.dropX,that.dropY);
    	fill(255,0,0);
    	box(10);
    	noFill();
   			 popMatrix();

		}
		else if(mousePressed && that.mouseMoved>0) {
			that.dropX=mouseX;
			that.dropY=mouseY;
			radius=int(map(width*height, 0,1680*1050 ,0, 200));;
			pressed=pressedFrames;
		}
		else if(frameCount% 10 == 0 && true) {
			that.dropX=random(width);
			that.dropY=random(height);
			radius = random(height/5);
			drop=false;
		}
//		else radius=0;
		PVector mouse=new PVector(that.dropX, that.dropY,0);
		float mouseDist= PVector.dist(new PVector(location.x,location.y),new PVector(that.dropX, that.dropY));


		if(((int(that.blobs[0]) > 0 && int(that.blobs[1]) > 0) || (mousePressed  && that.mouseMoved>0)|| drop) && that.friction>=0.7) {
			if((mouseDist < 10*pressed && mouseDist<radius)) {
				PVector velocity1= PVector.sub(location,mouse);
				velocity1.normalize();
				velocity1.mult(0.5*pressed);
				velocity1.limit(5);
				velocity.add(velocity1);
			}
			if(mousePressed && that.mouseMoved >0 && mouseDist < 10*pressed && mouseDist<radius) that.friction=0.7;
			else if(mousePressed && that.mouseMoved >0) that.friction=0.9;

			if(blobPressed && that.blobMoved >0 && mouseDist < 10*pressed && mouseDist<radius) that.friction=0.7;
			else if(blobPressed && that.blobMoved >0) that.friction=0.9;
		}

		
		if(that.pressedFrames > 100 && random(0,1) >0.9) that.pressedStart=frameCount;
		if(that.blobFrames > 100 && random(0,1) >0.9) that.blobStart=frameCount;


		velocity.mult(that.friction);
//		velocity.add(that.wind);

		if(mousePressed && that.mouseMoved >0 && random(0,1) > map(that.pressedFrames, 0, that.pressedFrames+20,0.1,1)) {
			float mult=-0.06;
			velocity.mult(mult);
			location.add(velocity);
			velocity.mult(1/mult);
		}
		else location.add(velocity);
//	wind.mult(force);
	//	velocity.add(wind);
	}
	
	
	
}

