

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

KinectTracker tracker;

void setup() {
  size(1280, 480);
  tracker = new KinectTracker(this);
}

void draw() {
  background(255);
  fill(0);
  stroke(255,255,0);

  println (tracker.calculateBlobs());

}
