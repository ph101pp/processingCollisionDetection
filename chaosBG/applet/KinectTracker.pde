
class KinectTracker {
 	OpenCV opencv;
	chaosBG that;
	Kinect kinect;
  // Size of kinect image
  int kw = 640;
  int kh = 480;
  int threshold = 600;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;


  PImage display;

  KinectTracker(chaosBG that_) {
 	that=that_;
	opencv = new OpenCV(that);
	opencv.allocate(kw, kh);
  	kinect = new Kinect(that);
 	kinect.start();
    kinect.enableDepth(true);

    // We could skip processing the grayscale image for efficiency
    // but this example is just demonstrating everything
    kinect.processDepthImage(true);

    display = createImage(kw, kh, PConstants.RGB);
  }

  void createDisplay() {
    PImage img = kinect.getDepthImage();
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // mirroring image
        int offset = kw-x-1+y*kw;
        // Raw depth
        int rawDepth = depth[offset];

        int pix = x+y*display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(255);
        } 
        else {
          display.pixels[pix] = color(0);
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }



  float[] calculateBlobs() {
  	float 	sumX=0,
  			sumY=0;
  	int		count=1;
  
    createDisplay();
    opencv.copy(display);
   image( opencv.image(), 640, 0 );
    opencv.threshold( 80 );
    Blob[] blobs = opencv.blobs( 10, width*height/2, 100, true, OpenCV.MAX_VERTICES*4 );
	
    // draw blob results
        for( int i=0; i<blobs.length; i++ ) {
        	println(blobs[i].points.length);
        	
        	

         beginShape();
           for( int j=0; j<blobs[i].points.length; j++ ) {
              vertex( blobs[i].points[j].x, blobs[i].points[j].y );
           
           		sumX+=blobs[i].points[j].x;
           		sumY+=blobs[i].points[j].y;
           		count++;
           
           }
          endShape(CLOSE);
       }
       
    float[] value = {sumX/count, sumY/count};
    return value;
  }
}
