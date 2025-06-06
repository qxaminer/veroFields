// Global declarations
float x, y, w, h;
float spdX, spdY;
color strokeCol;

float ellX, ellY;
float ellSize;

PVector pyramidBaseLeft, pyramidBaseRight, pyramidTip;
float flickerRate;
int flickerCounter = 0;

void setup() {
  size(1960, 975);
  initSquare();
  initEllipse();
  initPyramid(); // Set up the "tractor beam" pyramid
}

void draw() {
  background(127);

  // --- Ellipse ---
  fill(200);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Pyramid: flickering silver triangle ---
  drawPyramid();

  // --- Check overlap for rect ---
  boolean overlapping = rectCircleOverlap(x, y, w, h, ellX, ellY, ellSize / 2);

  // --- Flickering Rect ---
  if (overlapping) {
    fill(random(x), 100);  // transparent when inside
  } else {
    fill(random(x));       // original flicker
  }

  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // --- Move rect ---
  x += spdX;
  y += spdY;

  // --- Reset all on exit ---
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
  // Flicker changes every reset
  flickerRate = random(2, 8);

  float radius = ellSize / 2;

  // Pick a random angle on ellipse edge for base
  float angle = random(TWO_PI);
  float baseLength = random(30, 80);  // vary pyramid base size

  // Perpendicular offset direction
  float offsetAngle = angle + HALF_PI;

  // Base center on ellipse edge
  float baseCenterX = ellX + cos(angle) * radius;
  float baseCenterY = ellY + sin(angle) * radius;

  // Base endpoints
  pyramidBaseLeft = new PVector(
    baseCenterX + cos(offsetAngle) * baseLength / 2,
    baseCenterY + sin(offsetAngle) * baseLength / 2
  );

  pyramidBaseRight = new PVector(
    baseCenterX - cos(offsetAngle) * baseLength / 2,
    baseCenterY - sin(offsetAngle) * baseLength / 2
  );

  // Tip within the ellipse (bounded inside)
  float tipRadius = radius * random(0.2, 0.9);
  float tipAngle = random(TWO_PI);
  pyramidTip = new PVector(
    ellX + cos(tipAngle) * tipRadius,
    ellY + sin(tipAngle) * tipRadius
  );
}

// --------------------------
// Drawing Functions
// --------------------------

void drawPyramid() {
  flickerCounter++;
  if (flickerCounter >= flickerRate) {
    flickerCounter = 0;
  }

  if (flickerCounter == 0) {
    // Flicker: silver shimmer
    fill(random(180, 255), random(180, 255), random(220, 255), 180);
  } else {
    fill(230, 230, 255, 80); // cool low-opacity silver
  }

  stroke(100);
  strokeWeight(2);
  triangle(
    pyramidBaseLeft.x, pyramidBaseLeft.y,
    pyramidBaseRight.x, pyramidBaseRight.y,
    pyramidTip.x, pyramidTip.y
  );
}

// --------------------------
// Collision Detection
/
