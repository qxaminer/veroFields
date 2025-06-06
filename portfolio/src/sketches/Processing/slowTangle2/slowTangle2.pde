// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

void setup() {
  size(1960, 975);
  initSquare();  // Initialize square for the first time
}

void draw() {
  background(127, 127, 127);
  
  // Draw the square
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // Update position
  x += spdX;
  y += spdY;

  // Check if off screen (left, right, top, bottom)
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    initSquare();  // Re-initialize if square is off-screen
  }
}

// initialize or re-initialize square properties
void initSquare() {
  w = 150;
  h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);
  
  // make square move
  if (spdX == 0 && spdY == 0) {
    spdX = 1;
    spdY = 1;
  }

  fillCol = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
}
