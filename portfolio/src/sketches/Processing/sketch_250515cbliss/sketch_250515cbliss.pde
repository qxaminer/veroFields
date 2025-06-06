// Global declarations
float x = 0, y = 0, w = 0, h = 0;
float spdX, spdY;
color strokeCol;

float ellX, ellY;
float ellSize;

void setup() {
  size(1900, 975);
  initSquare();
  initEllipse(); // setup ellipse
}

void draw() {
  background(127);

  // --- Ellipse: random position and randomized enlargement ---
  fill(200); // constant grayscale for now
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Check if rect is overlapping with ellipse ---
  boolean overlapping = rectCircleOverlap(x, y, w, h, ellX, ellY, ellSize / 2);

  // --- Flickering Rect ---
  if (overlapping) {
    // Lower opacity if overlapping with ellipse
    fill(random(x), 100); // alpha = 100
  } else {
    fill(random(x)); // original flicker logic
  }

  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // Update rect position
  x += spdX;
  y += spdY;

  // Reset square if it moves off screen
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    initSquare();
    initEllipse(); // New ellipse position & size too
  }
}

// Initialize square with original flicker style
void initSquare() {
  w = 150;
  h = 60;
  x = random(600);
  y = random(300, height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  // Avoid immobile square
  if (spdX == 0 && spdY == 0) {
    spdX = 1;
    spdY = 1;
  }

  strokeCol = color(random(230 * 0.5), 160 * 0.5, random(90 * 0.5));
}

// Initialize ellipse position and size
void initEllipse() {
  ellX = random(200, width - 200);
  ellY = random(200, height - 200);
  ellSize = random(100, 200) * (0.5 * PI);
}

// Collision detection: Rect vs Circle (ellipse treated as circle)
boolean rectCircleOverlap(float rx, float ry, float rw, float rh, float cx, float cy, float radius) {
  float testX = cx;
  float testY = cy;

  // Find the closest edge point
  if (cx < rx)         testX = rx;
  else if (cx > rx+rw) testX = rx+rw;
  if (cy < ry)         testY = ry;
  else if (cy > ry+rh) testY = ry+rh;

  float distX = cx - testX;
  float distY = cy - testY;
  float distance = sqrt(distX*distX + distY*distY);

  return (distance <= radius);
}
