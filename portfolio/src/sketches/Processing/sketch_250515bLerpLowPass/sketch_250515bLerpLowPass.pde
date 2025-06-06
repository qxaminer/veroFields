// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

// Ellipse position
float ellX, ellY;
float ellSize = 350;

void setup() {
  size(1960, 975);
  initSquare();  // Initialize the moving square

  // Set ellipse to a fixed position (centered)
  ellX = width / 2;
  ellY = height / 2;
}

void draw() {
  background(127);

  // --- Flickering Grayscale Ellipse ---
  float grayValue = random(0, 255);  // Random grayscale value each frame
  fill(grayValue);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Moving Square ---
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // Update position
  x += spdX;
  y += spdY;

  // Check if square moved off screen
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    initSquare();
  }
}

// Initialize square properties
void initSquare() {
  w = 150;
  h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  // Avoid zero speed
  if (spdX == 0 && spdY == 0) {
    spdX = 1;
    spdY = 1;
  }

  fillCol = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
}
