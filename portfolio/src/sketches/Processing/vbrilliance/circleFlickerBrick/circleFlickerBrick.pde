int rectX = 100;
int rectY = 100;
int rectWidth = 150;
int rectHeight = 60;

float ellipseX = 400;
float ellipseY = 200;
float ellipseSize = 100;

void setup() {
  size(1600, 900);
}

void draw() {
  background(127);

  // Flickering Rectangle Effect
  fill(random(255), random(255), random(255), random(100, 255)); // Random color with random opacity
  rect(rectX, rectY, rectWidth, rectHeight);

  // Rotating Ellipse
  fill(0, 255, 0); // Green color
  ellipseX = width / 2 + cos(radians(frameCount)) * 150;
  ellipseY = height / 2 + sin(radians(frameCount)) * 150;
  ellipse(ellipseX, ellipseY, ellipseSize, ellipseSize);
}
