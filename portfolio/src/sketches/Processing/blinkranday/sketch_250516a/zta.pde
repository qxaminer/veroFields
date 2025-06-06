// Global declarations
float x, y, w, h;
float spdX, spdY;
color strokeCol;

float ellX, ellY;
float ellSize;

PVector pyramidTip;

void setup() {
  size(1960, 975);
  initSquare();
  initEllipse(); // setup ellipse
  initPyramid(); // setup pyramid position
}

void draw() {
  background(127);

  // --- Ellipse ---
  fill(200);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Check for overlap ---
  boolean overlapping = rectCircleOverlap(x, y, w, h, ellX, ellY, ellSize / 2);

  // --- Flickering Rect ---
  if (overlapping) {
    fill(random(x), 100);  // transparent
  } else {
    fill(random(x));  // subtle flicker
  }

  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // --- Pyramid (triangle anchored on rect top) ---
  drawPyramid();

  // --- Move square ---
  x += spdX;
  y += spdY;

  // --- Reset square and ellipse ---
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    initSquare();
    initEllipse();
    initPyramid();
  }
}

// --------------------------
// Initialization Functions
// --------------------------

void initSquare() {
  w = 150;
  h = 60;
  x = random(600);
  y = random(300, height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  if (spdX == 0 && spdY == 0) {
    spdX = 1;
    spdY = 1;
  }

  strokeCol = color(random(230 * 0.5), 160 * 0.5, random(90 * 0.5));
}

void initEllipse() {
  ellX = random(200, width - 200);
  ellY = random(200, height - 200);
  ellSize = random(100, 200) * (0.5 * PI);
}

void initPyramid() {
  // Random angle around ellipse center
  float angle = random(TWO_PI);
  float radius = (ellSize / 2) * 0.25 * random(0.5, 1); // never more than 0.25 * diameter

  // Polar to Cartesian
  float tipX = ellX + cos(angle) * radius;
  float tipY = ellY + sin(angle) * radius;
  pyramidTip = new PVector(tipX, tipY);
}

// --------------------------
// Drawing Functions
// --------------------------

void drawPyramid() {
  // Base of pyramid = top of rectangle
  float baseLeftX = x;
  float baseLeftY = y;
  float baseRightX = x + w;
  float baseRightY = y;

  fill(255, 180, 0, 180); // gold semi-transparent
  stroke(80);
  strokeWeight(2);
  triangle(baseLeftX, baseLeftY, baseRightX, baseRightY, pyramidTip.x, pyramidTip.y);
}

// --------------------------
// Collision Detection
// --------------------------

boolean rectCircleOverlap(float rx, float ry, float rw, float rh, float cx, float cy, float radius) {
  float testX = cx;
  float testY = cy;

  if (cx < rx)         testX = rx;
  else if (cx > rx+rw) testX = rx+rw;
  if (cy < ry)         testY = ry;
  else if (cy > ry+rh) testY = ry+rh;

  float distX = cx - testX;
  float distY = cy - testY;
  float distance = sqrt(distX*distX + distY*distY);

  return (distance <= radius);
}
