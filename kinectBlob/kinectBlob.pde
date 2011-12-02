

// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing
import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import processing.video.*;
import java.awt.*;

OpenCV opencv;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

void setup() {
  size(1280, 480);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
}

void draw() {
  background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  //  PVector v1 = tracker.getPos();
  //  fill(50,100,250,200);
  //  noStroke();
  //  ellipse(v1.x,v1.y,20,20);
  //
  //  // Let's draw the "lerped" location
  //  PVector v2 = tracker.getLerpedPos();
  //  fill(100,250,50,200);
  //  noStroke();
  //  ellipse(v2.x,v2.y,20,20);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold", 10, 500);
}

void keyPressed() {

  if (key == 't') {
    tracker.calculateBlobs();
  }
}

void stop() {
  tracker.quit();
  super.stop();
}


