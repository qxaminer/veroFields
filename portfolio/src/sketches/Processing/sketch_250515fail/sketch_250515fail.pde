// Initial sketch
int rectX = 100;
int rectY = 100;
int rectWidth = 150;
int rectHeight = 60;

float ellipseX = 400;
float ellipseY = 200;
float ellipseSize = 100;

void setup() {
  size(600, 400);
}

void draw() {
  background(127);

  // Rectangle
  fill(255, 0, 0); // Red color
  rect(rectX, rectY, rectWidth, rectHeight);

  // Ellipse
  fill(0, 255, 0); // Green color
  ellipse(ellipseX, ellipseY, ellipseSize, ellipseSize);
}
