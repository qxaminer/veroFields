// design drawn in a function
// random size, position, and color

float x;
float y;
float x2;
float y2;

void setup() {
  size(500, 500);

  frameRate(5); //  but better to implement a timer.
}

void draw() {
  fill(255, 25);
  x = random(width); // between 0 and width
  y = random(height); // between 0 and height
  background(255);
  design(250, 250);
  design(x, y);

  if (frameCount % 240 == 0) {
    //    x = random(width); // between 0 and width
    //y = random(height); // between 0 and height
  }
}
void keyPressed() {
  x2 = random(width);
  y2 = random(height);
}

void mousePressed() {
  design(mouseX, mouseY);
}
void design(float x, float y) {
  stroke(0);
  strokeWeight(3);
  line(x + 00, y - 25, x + 00, y + 25);
  line(x - 25, y + 00, x + 25, y + 00);
  line(x - 25, y - 25, x + 25, y - 25);
  line(x - 25, y + 25, x + 25, y - 25);

  fill(255);
  ellipse(x + 00, y - 25, 10, 10);
  ellipse(x + 00, y + 25, 10, 10);
  ellipse(x - 25, y + 00, 10, 10);
  ellipse(x + 25, y + 00, 10, 10);
}
