package testLibrary;
import processing.core.*;

public class testLibrary {
  PApplet parent;

  public testLibrary(PApplet parent) {
    this.parent = parent;
    parent.registerDraw(this);
    
    parent.println("Hallo");
  }

  public void draw() {
	parent.println("library OUTPUT");
	}
}
