/* --------------------------------------------------------------------------
 * SimpleOpenNI NITE Hands
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  03/19/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 * This example works with multiple hands, to enable mutliple hand change
 * the ini file in /usr/etc/primesense/XnVHandGenerator/Nite.ini:
 *  [HandTrackerManager]
 *  AllowMultipleHands=1
 *  TrackAdditionalHands=1
 * on Windows you can find the file at:
 *  C:\Program Files (x86)\Prime Sense\NITE\Hands\Data\Nite.ini
 * ----------------------------------------------------------------------------
 */
/////////////////////////////////////////////////////////////////////////////////////////////////////
// PointDrawer keeps track of the handpoints

class KinectListener extends XnVPointControl
{

	chaosBG					that;
	// NITE
	XnVSessionManager 		sessionManager;
	XnVFlowRouter     		flowRouter;
	SimpleOpenNI     		context;
///////////////////////////////////////////////////////////
	
	KinectListener(chaosBG that_, SimpleOpenNI context_) {
		that=that_;
		context=context_;
		// mirror is by default enabled
		context.setMirror(true);
		
		// enable depthMap generation 
		context.enableDepth();
		
		// enable the hands + gesture
		context.enableHands();
		context.enableGesture();
	
		// setup NITE 
		sessionManager = context.createSessionManager("Click,Wave", "RaiseHand");
		flowRouter = new XnVFlowRouter();
		flowRouter.SetActive(this);
		sessionManager.AddListener(flowRouter);
	}
///////////////////////////////////////////////////////////

	void update(){
		context.update();  
 		context.update(sessionManager);	
 		//image(context.depthImage(),0,0);
	}
///////////////////////////////////////////////////////////
	
	void endSession(){
		sessionManager.EndSession();
		println("end session");	
	};
 
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

  public void OnPointCreate(XnVHandPointContext cxt)
  {
    // create a new list
 //   addPoint(cxt.getNID(),new PVector(cxt.getPtPosition().getX(),cxt.getPtPosition().getY(),cxt.getPtPosition().getZ()));
    println("OnPointCreate, handId: " + cxt.getNID());
		float x=map(cxt.getPtPosition().getX(), -320,320,0,width);
		float y=map(cxt.getPtPosition().getY(), 240,-240,0,height);
		that.mouseElement =new BlobElement(that,new PVector(x,y,0));
		collisionDetection.addElement(that.mouseElement);
//		globalDisturbance=int(random(0,3));
    
 }
///////////////////////////////////////////////////////////

  public void OnPointUpdate(XnVHandPointContext cxt)
  {
//	println("OnPointUpdate " + cxt.getPtPosition());   
//    addPoint(cxt.getNID(),new PVector(cxt.getPtPosition().getX(),cxt.getPtPosition().getY(),cxt.getPtPosition().getZ()));
		float x=map(cxt.getPtPosition().getX(), -320,320,0,width);
		float y=map(cxt.getPtPosition().getY(), 240,-240,0,height);
		
		that.movement=true;
		that.mouseElement.move(new PVector(x,y,0));

		pushMatrix();
			
			println(x+" "+y);
			translate(x, y,0);
			fill(200,0,0);
			box(10);
		popMatrix();
			 noFill();
  }
///////////////////////////////////////////////////////////

  public void OnPointDestroy(long nID)
  {
    println("OnPointDestroy, handId: " + nID);
    
		that.mouseElement.finalize();
		collisionDetection.elements.remove(that.mouseElement);
		that.mouseElement = null;

  }

}