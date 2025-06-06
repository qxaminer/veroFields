// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

// Ellipse position
float ellX, ellY;
float ellSize = 100;

// --- Low‑pass filter vars ---
float grayNow  = random(255);
float grayNext = random(255);
float lerpAmt  = 0.05;                // initial value (will change)          //modelcom
float[] speeds = {0.01, 0.05, 0.15, 0.30}; // presets for cycling flicker speed //modelcom

void setup() {
  size(1960, 975);
  initSquare();

  ellX = width / 2;
  ellY = height / 2;
}

void draw() {
  background(127);

  // --- Smooth‑random ellipse via lerp() ---
  grayNow = lerp(grayNow, grayNext, lerpAmt);

  if (abs(grayNow - grayNext) < 1) {                 // reached target
    grayNext = random(255);                          // pick new brightness
    lerpAmt  = speeds[int(random(speeds.length))];   // cycle to a new speed //modelcom
  }

  fill(grayNow);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Moving Square (unchanged) ---
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // Update position
  x += spdX;
  y += spdY;

  // Respawn if off screen
  if (x > width || x + w < 0 || y > height || y + h < 0) initSquare();
}

// Initialize square properties
void initSquare() {
  w = 150;
  h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  if (spdX == 0 && spdY == 0) { spdX = 1; spdY = 1; }

  fillCol = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
}
