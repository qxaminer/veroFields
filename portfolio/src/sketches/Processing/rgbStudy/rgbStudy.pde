//void setup(){
//  size(400, 400);

//// red circle
//fill(255, 0, 0);
//ellipse(100, 100, 300, 300);

//// green circle
//fill(0, 255, 0);
//ellipse(200, 200, 300, 300);

//// blue circle
//fill(0, 0, 255);
//ellipse(300, 300, 300, 300);

//}
  /**
 * Radial Gradient. 
 * 
 * Draws a series of concentric circles to create a gradient 
 * from one color to another.
 */

int dim;

void setup() {
  size(1640, 860);
  dim = width/2;
  background(0);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  frameRate(60);
}

void draw() {
  background(0);
  for (int x = 0; x <= width; x+=dim) {
    drawGradient(x, height/2);
  } 
}

void drawGradient(float x, float y) {
  int radius = dim/2;
  float h = random(0, 360);
  for (int r = radius; r > 0; --r) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 1) % 355;
  }
}
